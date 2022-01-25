local addonName, PermoksAccountManager = ...
local LibQTip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local pvpInfoTbl = {"seasonBest", "seasonWon", "seasonPlayed"}

local module = "pvp"
local labelRows = {
	arenaRating2v2 = {
		label = L["2v2 Rating"],
		type = "pvp",
		key = 1,
		tooltip = true,
		group = "pvp",
		version = WOW_PROJECT_MAINLINE,
	},
	arenaRating3v3 = {
		label = L["3v3 Rating"],
		type = "pvp",
		key = 2,
		tooltip = true,
		group = "pvp",
		version = WOW_PROJECT_MAINLINE,
	},
	rbgRating = {
		label = L["RBG Rating"],
		type = "pvp",
		key = 3,
		tooltip = true,
		group = "pvp",
		version = WOW_PROJECT_MAINLINE,
	},
}

local function UpdatePVPRating(charInfo)
	charInfo.pvp = charInfo.pvp or {}

	local pvp = charInfo.pvp
	for i=1, 3 do
		local rating, seasonBest, weeklyBest, seasonPlayed, seasonWon, weeklyPlayed, weeklyWon, lastWeeksBest, hasWon, pvpTier = GetPersonalRatedInfo(CONQUEST_BRACKET_INDEXES[i])
		pvp[i] = {rating = rating, seasonBest = seasonBest, seasonPlayed = seasonPlayed, seasonWon = seasonWon, pvpTier = pvpTier}
	end
end

local function Update(charInfo)
	UpdatePVPRating(charInfo)
end

local payload = {
	update = Update,
	labels = labelRows,
	events = {
		["PVP_RATED_STATS_UPDATE"] = UpdatePVPRating,
	},
	share = {
		[UpdatePVPRating] = "pvp",
	}
}
PermoksAccountManager:AddModule(module, payload)

function PermoksAccountManager:CreateRatingString(bracketInfo)
	if not bracketInfo then return end

	local tierInfo = C_PvP.GetPvpTierInfo(bracketInfo.pvpTier)
	if not tierInfo then return end

	return string.format("\124T%d:18:18\124t %d", tierInfo.tierIconID, bracketInfo.rating)
end

function PermoksAccountManager.PVPTooltip_OnEnter(button, altData, labelRow)
	if not altData.pvp then return end
	local info = altData.pvp[labelRow.key]
	if not info then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
	button.tooltip = tooltip

	for i, infoKey in ipairs(pvpInfoTbl) do
		tooltip:AddLine(infoKey:gsub("^%l", string.upper), info[infoKey])
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end