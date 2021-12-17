local addonName, PermoksAccountManager = ...
local LibQTip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

do
	local module = "classic_professions"
	local function functionOnLoad()
		local professionEvents = {
			"TRADE_SKILL_UPDATE",
			"BAG_UPDATE_DELAYED"
		}

		local professionFrame = CreateFrame("Frame")
		FrameUtil.RegisterFrameForEvents(professionFrame, professionEvents)

		professionFrame:SetScript("OnEvent", function(self, event, ...)
			if event == "TRADE_SKILL_UPDATE" then
				PermoksAccountManager:UpdateProfessions(...)
			elseif event == "BAG_UPDATE_DELAYED" then
				PermoksAccountManager:UpdateProfessionCDs()
			end
		end)
	end
	PermoksAccountManager:AddModule(module, functionOnLoad)
end

-- https://github.com/Stanzilla/WoWUIBugs/issues/47
local function GetCooldownLeft(start, duration)
    -- Before restarting the GetTime() will always be greater than [start]
    -- After the restart, [start] is technically always bigger because of the 2^32 offset thing
    if start < GetTime() then
        local cdEndTime = start + duration
        local cdLeftDuration = cdEndTime - GetTime()
        
        return cdLeftDuration
    end

    local time = time()
    local startupTime = time - GetTime()
    -- just a simplification of: ((2^32) - (start * 1000)) / 1000
    local cdTime = (2 ^ 32) / 1000 - start
    local cdStartTime = startupTime - cdTime
    local cdEndTime = cdStartTime + duration
    local cdLeftDuration = cdEndTime - time
    
    return cdLeftDuration
end


-- Need to rewrite most of this stuff. I hate the classic API
function PermoksAccountManager:UpdateProfessions()
	local charInfo = self.charInfo
	if not charInfo then return end
	charInfo.professions = charInfo.professions or {}

	local professions = {}
	local updated = false
	for skillLine=1, GetNumSkillLines() do
		local name, _, _, skillRank, _, _, skillMaxRank, isProfession = GetSkillLineInfo(skillLine)
		if isProfession then
			if skillRank < skillMaxRank then updated = true end
			tinsert(professions, {name = name, skillRank = skillRank, skillMaxRank = skillMaxRank})
		end
	end

	charInfo.professions = professions
	
	if updated then
		PermoksAccountManager:SendCharacterUpdate("professions")
	end
end


function PermoksAccountManager:UpdateProfessionCDs()
	local charInfo = self.charInfo
	if not charInfo then return end
	if not charInfo.professions then self:UpdateProfessions() end
	charInfo.professionCDs = charInfo.professionCDs or {}

	local professionCDs = charInfo.professionCDs
	local updated = false
	if charInfo.professions then
		for _, professionInfo in ipairs(charInfo.professions) do
			local professionName = professionInfo.name
			if self.professionCDs[professionName] and self.professionCDs[professionName].cds then
				for spellId, cdName in pairs(self.professionCDs[professionName].cds) do
					local start, duration = GetSpellCooldown(spellId)
					local cooldown = start > 0 and time() + GetCooldownLeft(start, duration) or 0
					if not professionCDs[spellId] or professionCDs[spellId] ~= cooldown then updated = true end
					professionCDs[spellId] = cooldown
				end
			end
		end
	end

	charInfo.professionCDs = professionCDs

	if updated then
		PermoksAccountManager:SendCharacterUpdate("professionCDs")
	end
end


function PermoksAccountManager:CreateProfessionString(professionInfo, professionCDs)
	if not professionInfo or not professionCDs then return end

	local cdInfo = self.professionCDs[professionInfo.name]
	local professionString = string.format("\124T%d:18:18\124t %s", cdInfo.icon, professionInfo.skillRank)

	local professionCDString
	if cdInfo.cds then
		for spellId, cdName in pairs(cdInfo.cds) do
			local cooldown = professionCDs[spellId]
			self:Debug("Name: ", cdName, "CD: ", cooldown, "Time: ", time())
			if cooldown and (cooldown == 0 or time() > cooldown) then
				professionCDString = string.format("%s\124T%d:18:18\124t", professionCDString or "", cdInfo.items and select(5, GetItemInfoInstant(cdInfo.items[spellId])) or GetSpellTexture(spellId))
			end
		end
	end

	return professionCDString and string.format("%s %s", professionString, professionCDString) or professionString
end

function PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, professionInfo)
	if not alt_data or not alt_data.professionCDs or not professionInfo or not self.professionCDs[professionInfo.name].cds then return end
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "RIGHT", "LEFT")
	button.tooltip = tooltip

	for spellId, cdName in pairs(self.professionCDs[professionInfo.name].cds) do
		local expirationTime = alt_data.professionCDs[spellId]
		if expirationTime and expirationTime > 0 and expirationTime > time() then
			local days, hours, minutes = self:TimeToDaysHoursMinutes(expirationTime)
			tooltip:AddLine(cdName, self:CreateTimeString(days, hours, minutes))
		else
			tooltip:AddLine(cdName, L["|cff00ff00READY|r"])
		end
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end