local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")
local default = {
	arena = {},
	rbg = {},
}

local pvpInfoTbl = {"seasonBest", "seasonWon", "seasonPlayed"}

function AltManager:UpdatePVPRating()
	local char_table = self.char_table
	if not char_table then return end
	char_table.pvp = char_table.pvp or default

	local pvp = char_table.pvp
	for i=1, 3 do
		local rating, seasonBest, weeklyBest, seasonPlayed, seasonWon, weeklyPlayed, weeklyWon, lastWeeksBest, hasWon, pvpTier = GetPersonalRatedInfo(CONQUEST_BRACKET_INDEXES[i])
		pvp[i] = {rating = rating, seasonBest = seasonBest, seasonPlayed = seasonPlayed, seasonWon = seasonWon, pvpTier = pvpTier}
	end

	char_table.pvp = pvp
end

function AltManager:CreateRatingString(bracketInfo)
	if not bracketInfo then return end

	local tierInfo = C_PvP.GetPvpTierInfo(bracketInfo.pvpTier)
	if not tierInfo then return end

	return string.format("\124T%d:18:18\124t %d", tierInfo.tierIconID, bracketInfo.rating)
end

function AltManager:PVPTooltip_OnEnter(button, alt_data, key)
	if not alt_data or not alt_data.pvp then return end
	local info = alt_data.pvp[key]
	if not info then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
	button.tooltip = tooltip

	for i, infoKey in ipairs(pvpInfoTbl) do
		tooltip:AddLine(infoKey:gsub("^%l", string.upper), info[infoKey])
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end


do
	local pvpEvents = {
		"PVP_RATED_STATS_UPDATE",
	}

	local pvpEventsFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(pvpEventsFrame, pvpEvents)

	pvpEventsFrame:SetScript("OnEvent", function(self, e, ...)
		if AltManager.addon_loaded then
			AltManager:UpdatePVPRating()
			AltManager:SendCharacterUpdate("pvp")
		end
	end)
end