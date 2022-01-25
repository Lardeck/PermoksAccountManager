local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local FACTION_BAR_COLORS_CUSTOM, FACTION_STANDING_LABEL_CUSTOM = {}, {}

do
	for standingID, color in pairs(FACTION_BAR_COLORS) do
		FACTION_BAR_COLORS_CUSTOM[standingID] = {r = color.r*256, g = color.g*256, b = color.b*256}
	end
	FACTION_BAR_COLORS_CUSTOM[9] = {r = 16, g = 165, b = 202}

	for i=1, 8 do
		FACTION_STANDING_LABEL_CUSTOM[i] = GetText("FACTION_STANDING_LABEL" .. i)
	end
	FACTION_STANDING_LABEL_CUSTOM[9] = "Paragon"
end

local labelRows = {
	archivists = {
		label = L["Archivists"],
		type = "faction",
		id = 2472,
		group = "reputation",
	},
	deaths_advance = {
		label = function() return PermoksAccountManager.faction[2470].localName or L["Death's Advance"] end,
		type = "faction",
		id = 2470,
		group = "reputation",
	},
	venari = {
		label = function() return PermoksAccountManager.faction[2432].localName or L["Ve'nari"] end,
		type = "faction",
		id = 2432,
		group = "reputation",
	},
	ascended = {
		label = function() return PermoksAccountManager.faction[2407].localName or L["Ascended"] end,
		type = "faction",
		id = 2407,
		group = "reputation",
	},
	wild_hunt = {
		label = function() return PermoksAccountManager.faction[2465].localName or L["Wild Hunt"] end,
		type = "faction",
		id = 2465,
		group = "reputation",
	},
	undying_army = {
		label = function() return PermoksAccountManager.faction[2410].localName or L["Undying Army"] end,
		type = "faction",
		id = 2410,
		group = "reputation",
	},
	court_of_harvesters = {
		label = function() return PermoksAccountManager.faction[2413].localName or L["Court of Harvesters"] end,
		type = "faction",
		id = 2413,
		group = "reputation",
	},
	the_enlightened = {
		label = function() return PermoksAccountManager.faction[2478].localName or L["The Enlightened"] end,
		type = "faction",
		id = 2478,
		group = "reputation",
	},
	automaton = {
		label = function() return PermoksAccountManager.faction[2480].localName or L["Automaton"] end,
		type = "faction",
		id = 2480,
		group = "reputation",
	},
  -- tbc
  theAldor = {
		label = function() return PermoksAccountManager.faction[932].localName or PermoksAccountManager.faction[932].name end,
		id = 932,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	theScryers = {
		label = function() return PermoksAccountManager.faction[934].localName or PermoksAccountManager.faction[934].name end,
		id = 934,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	silvermoonCity = {
		label = function() return PermoksAccountManager.faction[911].localName or PermoksAccountManager.faction[911].name end,
		id = 911,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	exodar = {
		label = function() return PermoksAccountManager.faction[930].localName or PermoksAccountManager.faction[930].name end,
		id = 930,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	theShatar = {
		label = function() return PermoksAccountManager.faction[935].localName or PermoksAccountManager.faction[935].name end,
		id = 935,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	cenarionExpedition = {
		label = function() return PermoksAccountManager.faction[942].localName or PermoksAccountManager.faction[942].name end,
		id = 942,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	honorHold = {
		label = function() return PermoksAccountManager.faction[946].localName or PermoksAccountManager.faction[946].name end,
		id = 946,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	thrallmar = {
		label = function() return PermoksAccountManager.faction[947].localName or PermoksAccountManager.faction[947].name end,
		id = 947,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	keepersOfTime = {
		label = function() return PermoksAccountManager.faction[989].localName or PermoksAccountManager.faction[989].name end,
		id = 989,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	lowerCity = {
		label = function() return PermoksAccountManager.faction[1011].localName or PermoksAccountManager.faction[1011].name end,
		id = 1011,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	theConsortium = {
		label = function() return PermoksAccountManager.faction[933].localName or PermoksAccountManager.faction[933].name end,
		id = 933,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	theVioletEye = {
		label = function() return PermoksAccountManager.faction[967].localName or PermoksAccountManager.faction[967].name end,
		id = 967,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	sporeggar = {
		label = function() return PermoksAccountManager.faction[970].localName or PermoksAccountManager.faction[970].name end,
		id = 970,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	theScaleOfTheSands = {
		label = function() return PermoksAccountManager.faction[990].localName or PermoksAccountManager.faction[990].name end,
		id = 990,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	netherwing = {
		label = function() return PermoksAccountManager.faction[1015].localName or PermoksAccountManager.faction[1015].name end,
		id = 1015,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	ogrila = {
		label = function() return PermoksAccountManager.faction[1038].localName or PermoksAccountManager.faction[1038].name end,
		id = 1038,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	shatteredSunOffensive = {
		label = function() return PermoksAccountManager.faction[1077].localName or PermoksAccountManager.faction[1077].name end,
		id = 1077,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	theMaghar = {
		label = function() return PermoksAccountManager.faction[941].localName or PermoksAccountManager.faction[941].name end,
		id = 941,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
	kurenai = {
		label = function() return PermoksAccountManager.faction[978].localName or PermoksAccountManager.faction[978].name end,
		id = 978,
		type = "faction",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		group = "reputation",
	},
}

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

local function UpdateFactions(charInfo)
	local self = PermoksAccountManager
	
	charInfo.factions = charInfo.factions or {}
	local factions = charInfo.factions

	for factionId, info in pairs(self.faction) do
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

local function Update(charInfo)
	UpdateFactions(charInfo)
end

local module = "factions"
local payload = {
	update = Update,
	labels = labelRows,
	events = {
		["UPDATE_FACTION"] = UpdateFactions,
	},
	share = {
		[UpdateFactions] = "factions"
	},
}
PermoksAccountManager:AddModule(module, payload)

function PermoksAccountManager:CreateFactionString(factionInfo)
	if not factionInfo then return end
	if not factionInfo.standing then return "No Data" end
	if factionInfo.exalted then return string.format("|cff00ff00%s|r", L["Exalted"]) end

	local standingColor, standing = FACTION_BAR_COLORS_CUSTOM[5], FACTION_STANDING_LABEL_CUSTOM[factionInfo.standing]
	local color = factionInfo.hasReward and "00ff00" or "ffffff"
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