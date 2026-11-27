local addonName, PermoksAccountManager = ...
local LibQTip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local options

local module = "forever_professions"
local labelRows = {
	primary_profession_1 = {
		label = "Profession 1",
		type = "profession",
		passRow = true,
		professionIndex = 1,
		group = "profession",
		version = WOW_PROJECT_CAMELOT,
	},
	primary_profession_2 = {
		label = "Profession 2",
		type = "profession",
		passRow = true,
		professionIndex = 2,
		group = "profession",
		version = WOW_PROJECT_CAMELOT,
	},
	first_aid = {
		label = "First Aid",
		type = "profession",
		passRow = true,
		professionIndex = 3,
		group = "profession",
		version = WOW_PROJECT_CAMELOT,
	},
	fishing = {
		label = "Fishing",
		type = "profession",
		passRow = true,
		professionIndex = 4,
		group = "profession",
		version = WOW_PROJECT_CAMELOT,
	},
	cooking = {
		label = "Cooking",
		type = "profession",
		passRow = true,
		professionIndex = 5,
		group = "profession",
		version = WOW_PROJECT_CAMELOT,
	},
}

-- https://github.com/Stanzilla/WoWUIBugs/issues/47
local function GetCooldownLeft(start, duration)
	-- Before restarting the GetTime() will always be greater than [start]
	-- After the restart, [start] is technically always bigger because of the 2^32 offset thing
	if start <= GetTime() then
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

local function UpdateProfessionInfo(professionIndex, professionID, professions)
	if not professionID then
		return
	end

	local self = PermoksAccountManager
	local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLineID, skillModifier, specializationIndex, specializationOffset, skillLineName = GetProfessionInfo(professionID)

	local profession = professions[professionID]
	if not profession then
		professions[professionID] = {
			professionIndex = professionIndex,
			professionID = professionID,
			skillLineID = skillLineID,
			name = name,
			icon = icon,
			skillLevel = skillLevel,
			maxSkillLevel = maxSkillLevel,
		}
	else
		profession.professionIndex = professionIndex
		profession.skillLevel = skillLevel
		profession.maxSkillLevel = maxSkillLevel
	end
end

-- Need to rewrite most of this stuff. I hate the classic API
local function UpdateProfessions(charInfo, isReset)
	local self = PermoksAccountManager
	charInfo.professions = charInfo.professions or {}

	--replacing profession-table ID with skillLineID
	local professionsIDs = { GetProfessions() }

	local professions = isReset and {} or charInfo.professions
	for professionIndex = 1, 5 do
		local professionID = professionsIDs[professionIndex]
		if professionID then
			UpdateProfessionInfo(professionIndex, professionID, professions)
		end
	end

	charInfo.professions = professions
end

local function UpdateProfessionCDs(charInfo)
	local self = PermoksAccountManager

	if not charInfo.professions then
		UpdateProfessions(charInfo)
	end

	charInfo.professionCDs = charInfo.professionCDs or {}

	local professionCDs = charInfo.professionCDs
	local updated = false

	if charInfo.professions then
		for professionID, professionInfo in pairs(charInfo.professions) do
			professionCDs[professionID] = professionCDs[professionID] or {}

			local professionName = professionInfo.name
			if self.professionCDs[professionName] and self.professionCDs[professionName].cds then
				for spellID in pairs(self.professionCDs[professionName].cds) do
					local cooldownInfo = C_Spell.GetSpellCooldown(spellID)
					if cooldownInfo and not (issecretvalue(cooldownInfo.startTime) or issecretvalue(cooldownInfo.duration)) then
						local start, duration = cooldownInfo.startTime, cooldownInfo.duration
						local cooldown = start > 0 and time() + GetCooldownLeft(start, duration) or 0
						if professionCDs[professionID][spellID] ~= cooldown then
							professionCDs[professionID][spellID] = cooldown
							updated = true
						end
					end
				end
			end
		end
	end

	charInfo.professionCDs = professionCDs

	if updated then
		PermoksAccountManager:SendCharacterUpdate("professionCDs")
	end
end

local function GetProfessionCDString(professionName, spellID, isReady)
	local professionCD = PermoksAccountManager.professionCDs[professionName]
	if not professionCD or not professionCD.cds[spellID] then
		return
	end

	local professionCDIcon
	if professionCD.items then
		professionCDIcon = C_Item.GetItemIconByID(professionCD.items[spellID])
	else
		professionCDIcon = C_Spell.GetSpellTexture(spellID)
	end

	if professionCDIcon then
		return isReady and string.format("|T%d:0|t", professionCDIcon) or string.format("|T%d:0:0::::::::255:0:0|t", professionCDIcon)
	end
end

local function CreateProfessionString(labelRow, professions, professionCDs)
	
	if not professions or not professionCDs then
		return
	end

	local professionID, professionInfo
	for _, info in pairs(professions) do
		if info.professionIndex and info.professionIndex == labelRow.professionIndex then
			professionID = info.professionID
			professionInfo = info
			break
		end
	end

	if not professionInfo then
		return
	end

	local professionCDInfo = professionCDs[professionID]
	local professionString = string.format("\124T%d:16:16\124t %d/%d", professionInfo.icon, professionInfo.skillLevel, professionInfo.maxSkillLevel)
	if not professionCDInfo then
		return professionString
	end

	for spellID, cooldown in pairs(professionCDInfo) do
		local professionCDString = GetProfessionCDString(professionInfo.name, spellID, cooldown == 0 or time() > cooldown)

		if professionCDString then
			professionString = string.format("%s - %s", professionString, professionCDString)
		end
	end

	return professionString
end

local function Update(charInfo)
	UpdateProfessions(charInfo)
	UpdateProfessionCDs(charInfo)
end

local payload = {
	update = Update,
	events = {
		["TRADE_SKILL_UPDATE"] = UpdateProfessions,
		["SKILL_LINES_CHANGED"] = function(charInfo)
			UpdateProfessions(charInfo, true)
		end,
		["BAG_UPDATE_DELAYED"] = UpdateProfessionCDs,
	},
	labels = labelRows,
	share = {
		[UpdateProfessions] = "professions"
	}
}
local module = PermoksAccountManager:AddModule(module, payload)
module:AddCustomLabelType("profession", CreateProfessionString, nil, "professions", "professionCDs")

function PermoksAccountManager.ProfessionTooltip_OnEnter(button, altData, labelRow)
	if not altData or not altData.professions then
		return
	end

	local self = PermoksAccountManager
	local professionID, professionCDInfo
	for professionID, info in pairs(altData.professions) do
		if info.professionIndex == labelRow.professionIndex then
			professionID = professionID
			professionCDInfo = self.professionCDs[info.name]
			break
		end
	end

	if not professionCDInfo or not professionCDInfo.cds or not next(professionCDInfo.cds) then
		return
	end

	local cooldowns = altData.professionCDs and altData.professionCDs[professionID]
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "RIGHT", "LEFT")
	button.tooltip = tooltip

	for spellID, name in pairs(professionCDInfo.cds) do
		local expirationTime = cooldowns and cooldowns[spellID]
		local status = L["Unknown"]
		if expirationTime then
			local seconds = self:GetSecondsRemaining(expirationTime)
			status = seconds > 0 and self:FormatTimeString(seconds, SecondsToTime(seconds)) or L["|cff00ff00READY|r"]
		end
		tooltip:AddLine(name, status)
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end