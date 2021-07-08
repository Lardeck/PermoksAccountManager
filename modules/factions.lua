local addonName, AltManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local FACTION_BAR_COLORS_CUSTOM, FACTION_STANDING_LABEL_CUSTOM = {}, {}

local function GetFactionOrFriendshipInfo(factionId, factionType)
	local hasReward
	local name, _, standing, barMin, barMax, barValue = GetFactionInfoByID(factionId)
	local isParagon = C_Reputation.IsFactionParagon(factionId)

	if isParagon then
		barValue, barMax, _, hasReward = C_Reputation.GetFactionParagonInfo(factionId)
		barMin, standing, barValue = 0, 9, barValue % barMax
	elseif factionType == "friend" then
		_, barValue, _,  _, _, _, standing, barMin, barMax = GetFriendshipReputation(factionId)
	end

	if not barMax or not barMin then return end
	return barValue - barMin, (barMax - barMin), standing, name, hasReward
end


function AltManager:UpdateFactions()
	local char_table = self.validateData()
	if not char_table then return end
	char_table.factions = char_table.factions or {}
	local factions = char_table.factions

	for factionId, info in pairs(self.factions) do
		local current, maximum, standing, name, hasReward = GetFactionOrFriendshipInfo(factionId, info.type)

		factions[factionId] = factions[factionId] or {}
		factions[factionId].standing = standing
		factions[factionId].current = current
		factions[factionId].max = maximum
		factions[factionId].type = info.type
		factions[factionId].hasReward = hasReward
		factions[factionId].exalted = not info.paragon and standing == 8

		if not info.localName then
			info.localName = name
		end
	end


end

function AltManager:CreateFactionString(factionInfo)
	if not factionInfo then return end
	if not factionInfo.standing then return "No Data" end
	if factionInfo.exalted then return string.format("|cff00ff00%s|r", L["Exalted"]) end

	local standingColor, standing = FACTION_BAR_COLORS_CUSTOM[5], FACTION_STANDING_LABEL_CUSTOM[factionInfo.standing]
	local color = factionInfo.hasReward and factionInfo.current >= 10000 and "00ff00" or "ffffff"
	if standing then
		standingColor = FACTION_BAR_COLORS_CUSTOM[factionInfo.standing]
	else
		standing = factionInfo.standing
	end

	if factionInfo.max then
		return string.format("|cff%s%s/%s|r |cff%02X%02X%02X%s|r", color, AbbreviateNumbers(factionInfo.current or 0), AbbreviateNumbers(factionInfo.max or 0), standingColor.r, standingColor.g, standingColor.b, standing)
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
	FACTION_BAR_COLORS_CUSTOM[9] = {r = 16, g = 165, b = 202}

	for i=1, 8 do
		FACTION_STANDING_LABEL_CUSTOM[i] = GetText("FACTION_STANDING_LABEL" .. i)
	end
	FACTION_STANDING_LABEL_CUSTOM[9] = "Paragon"
end