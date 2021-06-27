local addonName, AltManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local FACTION_BAR_COLORS_CUSTOM = {}

function AltManager:UpdateFactions()
	local char_table = self.validateData()
	if not char_table then return end

	local factionReputations = char_table.factions or {}

	-- Probably not efficient to use two for loops but its easier to understand
	local name, _, standingID, barMin, barMax, barValue
	for factionId, info in pairs(self.factions.faction) do
		if not info.faction or char_table.faction == info.faction then
			name, _, standingID, barMin, barMax, barValue = GetFactionInfoByID(factionId)

			if barMin and barMax then
				local current = standingID < 8 and barValue - barMin or 21000
				local maximum = standingID < 8 and barMax - barMin or 21000
				factionReputations[factionId] = factionReputations[factionId] or {}
				factionReputations[factionId].standingID = standingID
				factionReputations[factionId].current = current
				factionReputations[factionId].max = maximum
				factionReputations[factionId].exalted = standingID == 8
			end

			if not info.localName then
				info.localName = name
			end
		end
	end

	if not self:IsBCCClient() then
		local barValue, barMin, barMax, maxRep, _
		for factionId, info in pairs(self.factions.friendship) do
			_, barValue, maxRep,  _, _, _, standing, barMin, barMax = GetFriendshipReputation(factionId)

			factionReputations[factionId] = factionReputations[factionId] or {}
			if barMin then
				factionReputations[factionId].current = barValue - barMin
				factionReputations[factionId].standing = standing
				factionReputations[factionId].max = (barMax and barMax - barMin) or nil
				factionReputations[factionId].bff = barValue == maxRep
			end
		end
	end

	char_table.factions = factionReputations
end

function AltManager:CreateFactionString(factionInfo)
	if not factionInfo then return end
	if not factionInfo.standingID and not factionInfo.standing then return "No Data" end

	local color, standing = FACTION_BAR_COLORS_CUSTOM[5]
	if factionInfo.standingID then
		if factionInfo.exalted then return string.format("|cff00ff00%s|r", L["Exalted"]) end

		standing = GetText("FACTION_STANDING_LABEL".. factionInfo.standingID)
		color = FACTION_BAR_COLORS_CUSTOM[factionInfo.standingID]

	elseif factionInfo.standing then
		if factionInfo.bff then return "|cff00ff00BFF|r" end

		standing = factionInfo.standing
	end


	if factionInfo.max then
		return string.format("%s/%s |cff%02X%02X%02X%s|r", AbbreviateNumbers(factionInfo.current), AbbreviateNumbers(factionInfo.max), color.r, color.g, color.b, standing)
	end

	return 
end

do
	local factionEvents = {
		"UPDATE_FACTION",
	}

	local factionFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(factionFrame, factionEvents)

	factionFrame:SetScript("OnEvent", function(self, e, ...)
		if AltManager.addon_loaded then
			AltManager:UpdateFactions()
			AltManager:UpdateCompletionDataForCharacter()
			AltManager:SendCharacterUpdate("factionInfo")
		end
	end)

	for standingID, color in pairs(FACTION_BAR_COLORS) do
		FACTION_BAR_COLORS_CUSTOM[standingID] = {r = color.r*256, g = color.g*256, b = color.b*256}
	end
end