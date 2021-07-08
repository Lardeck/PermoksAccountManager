local addonName, AltManager = ...

local frequencyNames = {
	[0] = "default",
	[1] = "daily",
	[2] = "weekly",
}

local default = {
	daily = {},
	weekly = {},
	biweekly = {},
	relics = {},
	unlocks = {},
}

function AltManager:GetQuestInfo(questLogIndex)
	if self.isBC then
		local title, _, _, isHeader, _, _, frequency, questID, _, _, _, _, _, _, _, isHidden = GetQuestLogTitle(questLogIndex)
		return {title = title, isHeader = isHeader, frequency = frequency, isHidden = isHidden, questID = questID}
	else
		return C_QuestLog.GetInfo(questLogIndex)
	end
end

function AltManager:AddQuest(questID, questLogIndex, questInfo)
	local questLogIndex = questLogIndex or (self:IsBCCClient() and GetQuestLogIndexByID(questID) or C_QuestLog.GetLogIndexForQuestID(questID))
	if questLogIndex then
		local questInfo = questInfo or self:GetQuestInfo(questLogIndex)
		local title = questInfo.title

		self.db.global.quests[questID] = {frequency = questInfo.frequency, name = questInfo.title}
	end
end

function AltManager:FindQuestByQuestID(questID)
	local resetKey, key
	if self.db.global.quests[questID] then
		local questInfo = self.db.global.quests[questID]
		resetKey = frequencyNames[questInfo.frequency]
		if self.quests[resetKey] then
			key = self.quests[resetKey][questID]
		end
	else
		for reset, quests in pairs(self.quests) do
			if quests[questID] then
				return reset, quests[questID].key
			end
		end
	end

	return resetKey, key
end


function AltManager:UpdateQuest(questID)
	local char_table = self.char_table
	if not questID or not char_table then return end
	if not char_table.questInfo then 
		if self.isBC then
			self:UpdateAllBCCQuests(char_table)
		else
			self:UpdateAllRetailQuests() 
		end
	end

	local resetKey, key = self:FindQuestByQuestID(questID)
	if resetKey and key and char_table.questInfo[resetKey][key] then
		char_table.questInfo[resetKey][key][questID] = true
		if self:IsBCCClient() and resetKey == "daily" then
			if self.quests[resetKey][questID].unique then
				if not char_table.completedDailies[key] then
					char_table.completedDailies[key] = true
					char_table.completedDailies.num = char_table.completedDailies.num + 1
				end
			elseif not char_table.completedDailies[questID] then
				char_table.completedDailies[questID] = true
				char_table.completedDailies.num = char_table.completedDailies.num + 1
			end
		end
		self:RemoveQuest(questID)
	end
end

function AltManager:UpdateAllRetailQuests()
	local char_table = self.char_table
	if not char_table then return end
	char_table.questInfo = char_table.questInfo or default

	local covenant = char_table.covenant or C_Covenants.GetActiveCovenantID()
	local questInfo = char_table.questInfo
	for reset, quests in pairs(self.quests) do
		questInfo[reset] = questInfo[reset] or {}
		for questID, info in pairs(quests) do
			questInfo[reset][info.key] = questInfo[reset][info.key] or {}
			if info.covenant and covenant == info.covenant then
				local sanctumTier
				if info.sanctum and char_table.sanctumInfo then
					sanctumTier = char_table.sanctumInfo[info.sanctum] and char_table.sanctumInfo[info.sanctum].tier or 0
					questInfo["max" .. info.key] = max(1, sanctumTier)
				end

				if not info.sanctum or (sanctumTier and sanctumTier >= info.minSanctumTier) then
					local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)
					questInfo[reset][info.key][questID] = isComplete or nil
				end
			elseif not info.covenant then
				local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)
				questInfo[reset][info.key][questID] = isComplete or nil
			end
		end
	end

	questInfo.maxMawQuests = C_QuestLog.IsQuestFlaggedCompleted(60284) and 3 or 2
	char_table.questInfo = questInfo
end

function AltManager:UpdateAllBCCQuests()
	local char_table = self.char_table
	if not char_table then return end

	char_table.questInfo = char_table.questInfo or default
	char_table.completedDailies = {}
	char_table.completedDailies.num = 0

	local questInfo = char_table.questInfo
	for reset, quests in pairs(self.quests) do
		questInfo[reset] = questInfo[reset] or {}
		for questID, info in pairs(quests) do
			local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)

			questInfo[reset][info.key] = questInfo[reset][info.key] or {}
			questInfo[reset][info.key][questID] = isComplete

			if reset == "daily" and isComplete then
				if info.unique then
					if not char_table.completedDailies[info.key] then
						char_table.completedDailies.num = char_table.completedDailies.num + 1
						char_table.completedDailies[info.key] = true
					end
				else
					char_table.completedDailies[questID] = true
					char_table.completedDailies.num = char_table.completedDailies.num + 1
				end
			end
		end
	end

	char_table.questInfo = questInfo
end

function AltManager:UpdateCurrentlyActiveQuests()
	local numQuests = self:IsBCCClient() and GetNumQuestLogEntries() or C_QuestLog.GetNumQuestLogEntries()
	local info
	for questLogIndex=1, numQuests do
		info = self:GetQuestInfo(questLogIndex)
		if info and not info.isHeader and not info.isHidden then
			self:AddQuest(info.questID, questLogIndex, info)
		end
	end
end

function AltManager:RemoveQuest(questID)
	self.db.global.quests[questID] = nil
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

do
	local questEvents = {
		"QUEST_ACCEPTED",
		"QUEST_TURNED_IN",
		"QUEST_REMOVED",
	}

	local questFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(questFrame, questEvents)

	questFrame:SetScript("OnEvent", function(self, e, questID)
		if AltManager.addon_loaded then
			if e == "QUEST_ACCEPTED" then
				AltManager:AddQuest(questID)
			elseif e == "QUEST_TURNED_IN" then
				AltManager:UpdateQuest(questID)
				AltManager:SendCharacterUpdate("questInfo")
			elseif e == "QUEST_REMOVED" then
				AltManager:RemoveQuest(questID)
			end
			AltManager:UpdateCompletionDataForCharacter()
		end
	end)
end