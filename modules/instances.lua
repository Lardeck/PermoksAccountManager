local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateInstanceInfo()
	local char_table = self.validateData()
	if not char_table then return end

	local instanceInfo = {raids = {}, dungeons = {}}
	local name, difficulty, locked, isRaid, difficultyName, numEncounters, encounterProgress, _

	for i=1, GetNumSavedInstances() do
		local link = GetSavedInstanceChatLink(i)
		local instanceID, instanceName = link:match(":(%d+):%d+:%d+\124h%[(.+)%]\124h")
		instanceID = tonumber(instanceID)
		name, _, _, difficulty, locked, _, _, isRaid, _, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)

		if locked then
			if self.raids[instanceID] then
				local info = self.raids[instanceID]

				instanceInfo.raids[info.englishName] = instanceInfo.raids[info.englishName] or {}
				instanceInfo.raids[info.englishName][difficulty] = {difficulty = difficultyName, numEncounters = numEncounters, defeatedEncounters = encounterProgress}
			elseif self.dungeons[instanceID] and difficulty == 23 then
				instanceInfo.dungeons[instanceID] = {
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

	if numCompletedDungeons == self.numMythicDungeons then
		return "|cff00ff00+|r"
	else
		return numCompletedDungeons .. "/" .. self.numMythicDungeons
	end
end

function AltManager:CreateRaidString(savedInfo)
	if not savedInfo then return "-" end
	local raidString = ""

	local difficulties = {}
	for difficulty in pairs(savedInfo) do
		difficulties[#difficulties + 1] = difficulty
	end

	table.sort(difficulties)
	local highestDifficulty = difficulties[#difficulties]
	if highestDifficulty == 17 and #difficulties > 1 then
		highestDifficulty = difficulties[#difficulties-1]
	end

	local raidInfo = savedInfo[highestDifficulty]
	raidString = string.format("%s%s", self:CreateQuestString(raidInfo.defeatedEncounters, raidInfo.numEncounters), raidInfo.difficulty:sub(1,1))

	return raidString
end

function AltManager:DungeonTooltip_OnEnter(button, alt_data)
	if not alt_data or not alt_data.instanceInfo then return end
	local dungeonInfo = alt_data.instanceInfo.dungeons
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 3, "LEFT", "CENTER", "RIGHT")
	button.tooltip = tooltip

	for instanceID, name in pairs(AltManager.dungeons) do
		local left = name
		local info = dungeonInfo[instanceID]
		local right = "|cffff0000-|r"

		if info then
			right = self:CreateQuestString(info.defeatedEncounters, info.numEncounters)
		end
		tooltip:AddLine(left, "   ", right)
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end

function AltManager:RaidTooltip_OnEnter(button, alt_data, name)
	if not alt_data or not alt_data.instanceInfo or not alt_data.instanceInfo.raids.nathria then return end
	local raidInfo = alt_data.instanceInfo.raids.nathria
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 3, "LEFT", "CENTER", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader(name, '', '')
	tooltip:AddLine("")

	--spairs(db.data, function(t, a, b)  return t[a].ilevel > t[b].ilevel end) do
	for difficulty, info in AltManager.spairs(raidInfo, function(t, a, b) if a and b then if a<17 and b<17 then return a < b else return a > b end end end) do
		tooltip:AddLine(info.difficulty..":", "", self:CreateQuestString(info.defeatedEncounters, info.numEncounters))
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end