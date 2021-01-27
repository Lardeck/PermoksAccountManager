local addonName, AltManager = ...

function AltManager:UpdateFactions()
	local char_table = self.validateData()
	if not char_table then return end

	local factionReputations = char_table.factions or {}

	-- Probably not that efficient to use two for loops but its easier to understand
	local standingID, barMin, barMax, barValue
	for factionId, info in pairs(self.factions.faction) do
		standingID, barMin, barMax, barValue = select(3, GetFactionInfoByID(factionId))

		if barMin and barMax then
			local current = standingID < 8 and barValue - barMin or 21000
			local maximum = standingID < 8 and barMax - barMin or 21000

			factionReputations[factionId] = factionReputations[factionId] or {}
			factionReputations[factionId].current = current
			factionReputations[factionId].max = maximum
		end
	end

	local barValue, barMin, barMax, maxRep, _
	for factionId, info in pairs(self.factions.friendship) do
		_, barValue, maxRep,  _, _, _, _, barMin, barMax = GetFriendshipReputation(factionId)

		factionReputations[factionId] = factionReputations[factionId] or {}
		if barMin then
			factionReputations[factionId].current = barValue - barMin
			factionReputations[factionId].max = (barMax and barMax - barMin) or nil
			factionReputations[factionId].bff = barValue == maxRep
		end
	end

	char_table.factions = factionReputations
end

function AltManager:CreateFactionString(factionInfo)
	if not factionInfo then return "-" end

	if factionInfo.bff then 
		return "|cff00ff00BFF|r" 
	elseif factionInfo.max then
		return string.format("%s/|cffffff00%s|r", AbbreviateLargeNumbers(factionInfo.current), AbbreviateNumbers(factionInfo.max))	
	end

	return 
end