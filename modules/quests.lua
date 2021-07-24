local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

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

function AltManager:UpdateRetailQuest(questID)
	local char_table = self.char_table
	if not char_table then return end
	if not char_table.questInfo then self:UpdateAllRetailQuests() end

	local questInfo = self.quests[questID]
	if not questInfo then return end
	local questType, visibility, key = questInfo.questType, questInfo.visibility, questInfo.key
	if questType and visibility and key and char_table.questInfo[questType][visibility][key] then
		char_table.questInfo[questType][visibility][key][questID] = true
		self:RemoveQuest(questID)
	end
end

function AltManager:UpdateBCCQuest(questID)
	local char_table = self.char_table
	if not char_table then return end
	if not char_table.questInfo then self:UpdateAllBCCQuests(char_table) end

	local resetKey, key = self:FindQuestByQuestID(questID)
	if resetKey and key and char_table.questInfo[resetKey][key] then
		char_table.questInfo[resetKey][key][questID] = true
		if resetKey == "daily" then
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

function AltManager:UpdateQuest(questID)
	if not questID then return end
	if self.isBC then
		self:UpdateBCCQuest(questID)
	else
		self:UpdateRetailQuest(questID)
	end
end

function AltManager:UpdateAllHiddenQuests()
	local char_table = self.char_table
	if not char_table or not char_table.questInfo then return end	
	self:Debug("Update Hidden Quests")

	for questType, keys in pairs(char_table.questInfo) do
		if type(keys) == "table" and keys.hidden then
			for key, quests in pairs(keys.hidden) do
				for questID, _ in pairs(self.quests[key]) do
					local isComplete = char_table.questInfo[questType].hidden[key][questID]
					char_table.questInfo[questType].hidden[key][questID] = isComplete or C_QuestLog.IsQuestFlaggedCompleted(questID)
				end
			end
		end
	end
end

function AltManager:UpdateAllRetailQuests()
	local char_table = self.char_table
	if not char_table then return end
	char_table.questInfo = char_table.questInfo or default

	local covenant = char_table.covenant or C_Covenants.GetActiveCovenantID()
	local questInfo = char_table.questInfo
	for key, quests in pairs(self.quests) do
		for questID, info in pairs(quests) do
			local visibleType = info.log and "visible" or "hidden"

			questInfo[info.questType] = questInfo[info.questType] or {}
			questInfo[info.questType][visibleType] = questInfo[info.questType][visibleType] or {}
			questInfo[info.questType][visibleType][key] = questInfo[info.questType][visibleType][key] or {}
			local currentQuestInfo = questInfo[info.questType][visibleType][key]
			local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)

			if info.covenant and covenant == info.covenant then
				local sanctumTier
				if info.sanctum and char_table.sanctumInfo then
					sanctumTier = char_table.sanctumInfo[info.sanctum] and char_table.sanctumInfo[info.sanctum].tier or 0
					questInfo["max" .. key] = max(1, sanctumTier)
				end

				if not info.sanctum or (sanctumTier and sanctumTier >= info.minSanctumTier) then
					currentQuestInfo[questID] = isComplete or nil
				end
			elseif not info.covenant then
				currentQuestInfo[questID] = isComplete or nil
			end
		end
	end

	--questInfo.maxMawQuests = C_QuestLog.IsQuestFlaggedCompleted(60284) and 3 or 2
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

function AltManager:QuestTooltip_OnEnter(button, alt_data, reset, visibility, key)
	if not alt_data or not alt_data.questInfo then return end
	local info = alt_data.questInfo[reset][visibility] and alt_data.questInfo[reset][visibility][key]
	if not info then return end

	local quests = self.quests[key]
	local completedByName = {}
	for questId, isComplete in pairs(info) do
		if isComplete and quests[questId] and quests[questId].name then
			completedByName[quests[questId].name] = completedByName[quests[questId].name] or {num = 0, total = quests[questId].total}
			completedByName[quests[questId].name].num = completedByName[quests[questId].name].num + 1
		end
	end

	if not next(completedByName) then return end
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
	button.tooltip = tooltip
	for name, completionInfo in pairs(completedByName) do
		tooltip:AddLine(name, self:CreateFractionString(completionInfo.num, completionInfo.total))
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end


do
	local questEvents = {
		"QUEST_ACCEPTED",
		"QUEST_TURNED_IN",
		"QUEST_REMOVED",
		"QUEST_LOG_UPDATE",
	}

	local questFrame = CreateFrame("Frame")
	local timer
	FrameUtil.RegisterFrameForEvents(questFrame, questEvents)

	questFrame:SetScript("OnEvent", function(self, e, questID)
		if AltManager.addon_loaded then
			AltManager:Debug(e, questID, GetTime())
			if e == "QUEST_ACCEPTED" then
				AltManager:AddQuest(questID)
			elseif e == "QUEST_TURNED_IN" then
				AltManager:UpdateQuest(questID)
				AltManager:SendCharacterUpdate("questInfo")
			elseif e == "QUEST_REMOVED" then
				AltManager:RemoveQuest(questID)
			elseif e == "QUEST_LOG_UPDATE" then
				timer = timer or C_Timer.NewTimer(1, function() AltManager:UpdateAllHiddenQuests() timer=nil end)
			end
			AltManager:UpdateCompletionDataForCharacter()
		end
	end)
end