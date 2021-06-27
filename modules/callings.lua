local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

local function GetCurrentTier(talents)
	local currentTier = 0;
	for i, talentInfo in ipairs(talents) do
		if talentInfo.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableAlreadyHave then
			currentTier = currentTier + 1;
		end
	end
	return currentTier;
end

function AltManager:CreateCallingString(callingInfo)
	if not callingInfo then return "-" end

	local leastTimeLeft
	for questID, timeLeft in pairs(callingInfo) do
		if type(questID) == "number" then
			if timeLeft > time() and (not leastTimeLeft or timeLeft < leastTimeLeft) then
				leastTimeLeft = timeLeft
			end
		end
	end

	if leastTimeLeft then
		local days, hours, minutes = self:timeToDaysHoursMinutes(leastTimeLeft)
		return string.format("%s - %s", self:CreateQuestString(3 - callingInfo.numCallings, 3), self:CreateTimeString(days, hours, minutes))
	else
		return string.format("%s", self:CreateQuestString(3 - callingInfo.numCallings, 3))
	end
end

function AltManager:UpdateCallings(callings)
	if not callings and not IsAddOnLoaded("Blizzard_CovenantCallings") then UIParentLoadAddOn("Blizzard_CovenantCallings") return end
	local char_table = self.char_table
	if not char_table then return end
	if not char_table.covenant or not char_table.callingsUnlocked then char_table.callingInfo = nil return end

	self.db.global.currentCallings[char_table.covenant] = self.db.global.currentCallings[char_table.covenant] or {}

	local callingInfo = {numCallings = 0}
	local currentCallings = self.db.global.currentCallings[char_table.covenant]

	for index = 1, Constants.Callings.MaxCallings do
		local calling = callings[index];
		if calling then
			local timeLeft = C_TaskQuest.GetQuestTimeLeftSeconds(calling.questID)
			local oldTimeRemaining = char_table.callingInfo and char_table.callingInfo[calling.questID]
			local timeLeftInTime = (oldTimeRemaining and oldTimeRemaining > time() and oldTimeRemaining) or timeLeft and time() + timeLeft
			callingInfo[calling.questID] = timeLeftInTime
			callingInfo.numCallings = callingInfo.numCallings + 1
			currentCallings[calling.questID] = {name = C_QuestLog.GetTitleForQuestID(calling.questID), timeRemaining = timeLeftInTime}
		end
	end

	char_table.callingInfo = callingInfo
end

function AltManager:CallingTooltip_OnEnter(button, alt_data)
	if not alt_data or not alt_data.callingInfo then return end
	local currentCallings = self.db.global.currentCallings[alt_data.covenant]
	if not currentCallings then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 3, "LEFT", "CENTER", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader("Callings")
	tooltip:AddLine("")
	
	for questID, covenantCallingInfo in AltManager.spairs(currentCallings, function(t, a, b) return (t[a].timeRemaining or 0) < (t[b].timeRemaining or 0) end) do
		if alt_data.callingInfo[questID] and (covenantCallingInfo.timeRemaining or 0) > time() then
			tooltip:AddLine(covenantCallingInfo.name, "", self:CreateTimeString(self:timeToDaysHoursMinutes(covenantCallingInfo.timeRemaining)) or "")
		end
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end

function AltManager:CreateSanctumString(sanctumInfo, featureType, numQuestCompleted, numRequiredQuests)
	if not sanctumInfo or not sanctumInfo[featureType] or not numQuestCompleted then return end

	local shortenedName = sanctumInfo[featureType].name:gsub("(%w)%w*-?", function(a) return a end)
	return string.format("%s - %s", shortenedName, self:CreateQuestString(numQuestCompleted, numRequiredQuests))
end

function AltManager:UpdateSanctumBuildings()
	local char_table = self.validateData()
	if not char_table then return end

	local covenant = char_table.covenant or C_Covenants.GetActiveCovenantID()
	if not covenant or not self.sanctum[covenant] then return end
	local sanctumInfo = char_table.sanctumInfo or {}
	for featureType, talentTreeID in pairs(self.sanctum[covenant]) do
		local talentTree = C_Garrison.GetTalentTreeInfo(talentTreeID)
		if talentTree then
			local oldTier = sanctumInfo[featureType] and sanctumInfo[featureType].tier
			local currentTier = GetCurrentTier(talentTree.talents)
			sanctumInfo[featureType] = ((not oldTier or currentTier > oldTier) and {tier = currentTier, name = talentTree.title}) or sanctumInfo[featureType]
		end
	end

	char_table.sanctumInfo = sanctumInfo
end

do
	local callingEvents = {
		"COVENANT_CALLINGS_UPDATED",
	}

	local callingFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(callingFrame, callingEvents)

	callingFrame:SetScript("OnEvent", function(self, e, ...)
		if AltManager.addon_loaded then
			AltManager:UpdateCallings(...)
			AltManager:UpdateCompletionDataForCharacter()
			AltManager:SendCharacterUpdate("callingInfo")
		end
	end)

	local sanctumEvents = {
		"COVENANT_SANCTUM_INTERACTION_ENDED",
	}

	local sanctumFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(sanctumFrame, sanctumEvents)
	sanctumFrame:SetScript("OnEvent", function(self, e, ...)
		if AltManager.addon_loaded then
			AltManager:UpdateSanctumBuildings()
			AltManager:UpdateCompletionDataForCharacter()
			AltManager:SendCharacterUpdate("sanctumInfo")
		end
	end)
end