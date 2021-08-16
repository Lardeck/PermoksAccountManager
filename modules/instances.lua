local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateInstanceInfo()
	local char_table = self.char_table
	if not char_table then return end

	local instanceInfo = {raids = {}, dungeons = {}}
	local name, difficulty, locked, isRaid, difficultyName, numEncounters, encounterProgress, _

	for i=1, GetNumSavedInstances() do
		local link = GetSavedInstanceChatLink(i)
		local instanceID, instanceName = link:match(":(%d+):%d+:%d+\124h%[(.+)%]\124h")
		instanceID = tonumber(instanceID)
		name, _, _, difficulty, locked, extended, _, isRaid, _, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)

		if locked or (extended and encounterProgress>0) then
			if self.raids[instanceID] or (self.isBC and self.raids[name]) then
				local info = self.raids[instanceID] or self.raids[name]

				instanceInfo.raids[info.englishName] = instanceInfo.raids[info.englishName] or {}
				instanceInfo.raids[info.englishName][difficulty] = {difficulty = difficultyName, numEncounters = numEncounters, defeatedEncounters = encounterProgress}
			elseif (self.dungeons[instanceID] and difficulty == 23) or ((self.isBC and self.dungeons[name] and difficulty == 174)) then
				instanceInfo.dungeons[instanceID or self.dungeons[name]] = {
					numEncounters = numEncounters, 
					defeatedEncounters = encounterProgress,
					completed = numEncounters == encounterProgress,
				}
			end
		end
	end

	char_table.instanceInfo = instanceInfo
end

function AltManager:CreateDungeonString(savedInfo)
	if not savedInfo then return "-" end
	local numCompletedDungeons = 0

	for instanceID, info in pairs(savedInfo) do
		if info.numEncounters == info.defeatedEncounters then
			numCompletedDungeons = numCompletedDungeons + 1
		end
	end

	if numCompletedDungeons == self.numDungeons then
		return "|cff00ff00+|r"
	else
		return numCompletedDungeons .. "/" .. self.numDungeons
	end
end

function AltManager:CreateRaidString(savedInfo, hideDifficulty)
	if not savedInfo then return "-" end
	local raidString = ""
	local maxDifficultyId = self.isBC and 175 or 16

	local highestDifficulty = 0
	for difficulty in pairs(savedInfo) do
		if difficulty <= maxDifficultyId and difficulty > highestDifficulty then
			highestDifficulty = difficulty
		end
	end

	local raidInfo = savedInfo[highestDifficulty]
	if raidInfo then
		raidString = string.format("%s%s", self:CreateQuestString(raidInfo.defeatedEncounters, raidInfo.numEncounters), hideDifficulty and "" or raidInfo.difficulty:sub(1,1))
		return raidString
	end
end

function AltManager:DungeonTooltip_OnEnter(button, alt_data)
	if not alt_data or not alt_data.instanceInfo then return end
	local dungeonInfo = alt_data.instanceInfo.dungeons
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 3, "LEFT", "CENTER", "RIGHT")
	button.tooltip = tooltip

	for key, value in self.spairs(self.dungeons, function(t, a, b) return t[a] < t[b] end) do
		local left = self.isBC and key or value
		local info = self.isBC and dungeonInfo[value] or dungeonInfo[key]
		local right = "|cffff0000-|r"

		if info then
			right = self:CreateQuestString(info.defeatedEncounters, info.numEncounters)
		end
		tooltip:AddLine(left, "   ", right)
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end

function AltManager:RaidTooltip_OnEnter(button, alt_data, id)
	if not alt_data or not alt_data.instanceInfo or not self.raids[id] then return end
	local raidInfo = alt_data.instanceInfo.raids[self.raids[id].englishName]
	if not raidInfo then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader(self.raids[id].name)
	tooltip:AddLine("")

	for difficulty, info in AltManager.spairs(raidInfo, function(t, a, b) if a == 17 then return b < a else return a < b end end) do
		tooltip:AddLine(info.difficulty..":", self:CreateQuestString(info.defeatedEncounters, info.numEncounters))
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end

do
	local istanceEvents = {
		"UPDATE_INSTANCE_INFO",
	}

	local instanceFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(instanceFrame, istanceEvents)

	instanceFrame:SetScript("OnEvent", function(self, e, ...)
		if AltManager.addon_loaded then
			AltManager:UpdateInstanceInfo()
			AltManager:UpdateCompletionDataForCharacter()
			AltManager:SendCharacterUpdate("instanceInfo")
		end
	end)
end