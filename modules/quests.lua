local addonName, AltManager = ...

local function GetCurrentTier(talents)
	local currentTier = 0;
	for i, talentInfo in ipairs(talents) do
		if talentInfo.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableAlreadyHave then
			currentTier = currentTier + 1;
		end
	end
	return currentTier;
end

function AltManager:UpdateQuest(questID)
	if not questID then return end
	local char_table = self.validateData()
	if not char_table then return end
	if not char_table.questInfo then self:UpdateAllQuests() end

	local foundResetKey, key
	for resetKey, quests in pairs(self.quests) do
		if quests[questID] then
			foundResetKey = resetKey
			key = quests[questID].key
			break
		end
	end

	if foundResetKey and key and char_table.questInfo[foundResetKey][key] then
		char_table.questInfo[foundResetKey][key][questID] = true
	end
end

function AltManager:UpdateAllQuests()
	local char_table = self.validateData()
	if not char_table then return end

	local covenant = char_table.covenant or C_Covenants.GetActiveCovenantID()
	local questInfo = {}
	for reset, quests in pairs(self.quests) do
		questInfo[reset] = {}
		for questID, info in pairs(quests) do
			if info.covenant and covenant == info.covenant then
				local sanctumTier
				if info.sanctum and char_table.sanctumInfo then
					sanctumTier = char_table.sanctumInfo[info.sanctum] and char_table.sanctumInfo[info.sanctum].tier or 0
					questInfo["max" .. info.key] = max(1, sanctumTier)
				end

				if not info.sanctum or (sanctumTier >= info.minSanctumTier) then
					local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)

					questInfo[reset][info.key] = questInfo[reset][info.key] or {}
					questInfo[reset][info.key][questID] = isComplete
				end
			elseif not info.covenant then
				local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)

				questInfo[reset][info.key] = questInfo[reset][info.key] or {}
				questInfo[reset][info.key][questID] = isComplete
			end
		end
	end

	questInfo.maxMawQuests = C_QuestLog.IsQuestFlaggedCompleted(60284) and 3 or 2
	char_table.questInfo = questInfo
end

function AltManager:GetNumCompletedQuests(questInfo)
	if not questInfo then return 0 end
	local numCompleted = 0

	for questID, questCompleted in pairs(questInfo) do
		numCompleted = questCompleted and numCompleted + 1 or numCompleted
	end

	return numCompleted
end

function AltManager:CreateQuestString(questInfo, numDesired, replaceWithPlus)
	if not questInfo then return end
	if not numDesired then return end
	local numCompleted = 0
	if type(questInfo) == "table" then
		numCompleted = self:GetNumCompletedQuests(questInfo)
	else
		numCompleted = questInfo
	end

	local isComplete = numCompleted >= numDesired
	local color = (isComplete and "00ff00") or (numCompleted > 0 and "ff9900") or "ffffff"

	if numDesired then
		if replaceWithPlus and isComplete then
			return string.format("|cff%s+|r", color)
		else
			return string.format("|cff%s%d|r/%d", color, numCompleted, numDesired)
		end
	else
		return string.format("|cff%s%d|r", color, numCompleted)
	end
end

