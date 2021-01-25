local addonName, AltManager = ...

function AltManager:UpdateFactions()
	local char_table = self.validateData()
	if not char_table then return end

	local factionReputations = {}

	local standingID, barMin, barMax, barValue, standing, _
	for factionId, info in pairs(self.factions) do
		if info.type == "faction" then
			standingID, barMin, barMax, barValue = select(3, GetFactionInfoByID(factionId))
		elseif info.type == "friendship" then
			_, barValue, _,  _, _, _, standing, barMin, barMax = GetFriendshipReputation(factionId)
		end

		if barMin and barMax then
			local today = char_table.factions and char_table.factions[factionId] and char_table.factions[factionId].today

			-- Need to find a better way
			local current = standingID < 8 and barValue - barMin or 21000
			local maximum = standingID < 8 and barMax - barMin or 21000

			factionReputations[factionId] = {current = current, max = maximum, today = today or 0, standing = standing}
		end
	end

	char_table.factions = factionReputations
end

function AltManager:CreateFactionString(factionInfo)
	if not factionInfo then return "-" end

	return string.format("%s/|cffffff00%s|r", AbbreviateNumbers(factionInfo.current), AbbreviateNumbers(factionInfo.max))
end