local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local default_categories = {
	general = {
		order = 1,
		name = "General",
		childs = {
			"characterName",
			"factionGroup",
			"characterLevel",
			"location",
			"gold",
			"primary_profession_1",
			"primary_profession_2",
			"first_aid",
			"fishing",
			"cooking",
			"pvp_rank_points",
			"merchants_favor",
		},
		childOrder = {
			characterName = 1,
			factionGroup = 2,
			characterLevel = 3,
			location = 4,
			gold = 5,
			primary_profession_1 = 6,
			primary_profession_2 = 7,
			first_aid = 8,
			fishing = 9,
			cooking = 10,
			pvp_rank_points = 11,
			merchants_favor = 12,
		},
		hideToggle = true,
		enabled = true,
	},
	sharedFactions = {
		order = 2,
		name = "Reputation",
		childs = {},
		childOrder = {},
		enabled = true,
	},
	lockouts = {
		order = 3,
		name = "Lockouts",
		childs = {},
		childOrder = {},
		enabled = false,
	},
}

PermoksAccountManager.groups = {
	character = {
		label = L["Character"],
		order = 2,
	},
	currency = {
		label = L["Currency"],
		order = 4,
	},
	resetDaily = {
		label = L["Daily Reset"],
		order = 5,
	},
	resetWeekly = {
		label = L["Weekly Reset"],
		order = 6,
	},
	dungeons = {
		label = L["Dungeons"],
		order = 7,
	},
	raids = {
		label = L["Raids"],
		order = 8,
	},
	reputation = {
		label = L["Reputation"],
		order = 9,
	},
	buff = {
		label = L["Buff"],
		order = 10,
	},
	separator = {
		label = L["Separator"],
		order = 1,
	},
	item = {
		label = L["Items"],
		order = 11,
	},
	extra = {
		label = L["Extra"],
		order = 12,
	},
	profession = {
		label = L["Professions"],
		order = 13,
	},
	other = {
		label = L["Other"],
		order = 14,
	},
}

PermoksAccountManager.labelRows = {
	separator1 = {
		hideLabel = true,
		label = "Separator1",
		data = function()
			return ""
		end,
		group = "separator",
	},
	separator2 = {
		hideLabel = true,
		label = "Separator2",
		data = function()
			return ""
		end,
		group = "separator",
	},
	separator3 = {
		hideLabel = true,
		label = "Separator3",
		data = function()
			return ""
		end,
		group = "separator",
	},
	separator4 = {
		hideLabel = true,
		label = "Separator4",
		data = function()
			return ""
		end,
		group = "separator",
	},
	separator5 = {
		hideLabel = true,
		label = "Separator5",
		data = function()
			return ""
		end,
		group = "separator",
	},
	separator6 = {
		hideLabel = true,
		label = "Separator6",
		data = function()
			return ""
		end,
		group = "separator",
	},
}

-- instanceID = mapID (retail uses instanceIDs)
PermoksAccountManager.raids = {}

PermoksAccountManager.raidDifficultyLabels = {}

-- GetCurrentRegion
-- TODO Use instanceID or GetRealZoneText as key
-- Seems like we probably have to use GetCurrentRegionName
PermoksAccountManager.oldRaidResetInfo = {}

PermoksAccountManager.numDungeons = 16

-- Name = MapID
PermoksAccountManager.dungeons = {}

PermoksAccountManager.item = {}

PermoksAccountManager.factions = {
	[2800] = { name = "PVP Rank Points", type = "renown" },

	-- Alliance
	[2586] = { name = "Azeroth Commerce Authority", factionGroup = "Alliance" },
	[2826] = { name = "Brotherhood of the Horse", factionGroup = "Alliance" },
	[69] = { name = "Darnassus", factionGroup = "Alliance" },
	[54] = { name = "Gnomeregan Exiles", factionGroup = "Alliance" },
	[2779] = { name = "High Order", factionGroup = "Alliance" },
	[47] = { name = "Ironforge", factionGroup = "Alliance" },
	[2740] = { name = "Kirin Tor", factionGroup = "Alliance" },
	[890] = { name = "Silverwing Sentinels", factionGroup = "Alliance" },
	[730] = { name = "Stormpike Guard", factionGroup = "Alliance" },
	[72] = { name = "Stormwind", factionGroup = "Alliance" },
	[509] = { name = "The League of Arathor", factionGroup = "Alliance" },
	[2799] = { name = "Theramore Expeditionary Force", factionGroup = "Alliance" },
	[471] = { name = "Wildhammer Clan", factionGroup = "Alliance" },
	[589] = { name = "Wintersaber Trainers", factionGroup = "Alliance" },

	-- Horde
	[2782] = { name = "Bolder'ok Clan", factionGroup = "Horde" },
	[2798] = { name = "Darkspear Raiders", factionGroup = "Horde" },
	[530] = { name = "Darkspear Trolls", factionGroup = "Horde" },
	[2587] = { name = "Durotar Supply and Logistics", factionGroup = "Horde" },
	[729] = { name = "Frostwolf Clan", factionGroup = "Horde" },
	[76] = { name = "Orgrimmar", factionGroup = "Horde" },
	[630] = { name = "Ravasaur Trainers", factionGroup = "Horde" },
	[510] = { name = "The Defilers", factionGroup = "Horde" },
	[2787] = { name = "Earthen Ring", factionGroup = "Horde" },
	[81] = { name = "Thunder Bluff", factionGroup = "Horde" },
	[68] = { name = "Undercity", factionGroup = "Horde" },
	[889] = { name = "Warsong Outriders", factionGroup = "Horde" },
	[2778] = { name = "Windshapers", factionGroup = "Horde" },

	-- Both factions
	[529] = { name = "Argent Dawn" },
	[2747] = { name = "Barkskin Burrow" },
	[87] = { name = "Bloodsail Buccaneers" },
	[21] = { name = "Booty Bay" },
	[910] = { name = "Brood of Nozdormu" },
	[609] = { name = "Cenarion Circle" },
	[2719] = { name = "Cenarion Scouts" },
	[909] = { name = "Darkmoon Faire" },
	[2641] = { name = "Emerald Wardens" },
	[577] = { name = "Everlook" },
	[369] = { name = "Gadgetzan" },
	[92] = { name = "Gelkis Clan Centaur" },
	[2765] = { name = "Guardians of Hyjal" },
	[749] = { name = "Hydraxian Waterlords" },
	[93] = { name = "Magram Clan Centaur" },
	[789] = { name = "Moro'gai" },
	[2758] = { name = "Nightclaw Druids" },
	[2827] = { name = "Powderfuse" },
	[470] = { name = "Ratchet" },
	[349] = { name = "Ravenholdt" },
	[629] = { name = "Shatterspear Trolls" },
	[809] = { name = "Shen'dralar" },
	[70] = { name = "Syndicate" },
	[2819] = { name = "The Watchers" },
	[59] = { name = "Thorium Brotherhood" },
	[576] = { name = "Timbermaw Hold" },
	[270] = { name = "Zandalar Tribe" },
}

PermoksAccountManager.currency = {
	[3402] = 0, -- Merchant's Favor
}

PermoksAccountManager.currencyCustomOptions = {}

PermoksAccountManager.professionCDs = {
	[C_TradeSkillUI.GetTradeSkillDisplayName(197)] = {
		cds = {
			[18560] = L["Mooncloth"], -- Mooncloth
		},
		items = {
			[18560] = 14342,
		},
		icon = 136249,
		num = 1,
	},
	[C_TradeSkillUI.GetTradeSkillDisplayName(171)] = {
		cds = {
			[17187] = L["Transmute"], -- Transmute: Arcanite (shared cooldown)
		},
		items = {
			[17187] = 12360,
		},
		icon = 136240,
		num = 1,
	},
	[C_TradeSkillUI.GetTradeSkillDisplayName(165)] = {
		cds = {
			[19566] = L["Salt Shaker"], -- Salt Shaker
		},
		items = {
			[19566] = 15846,
		},
		icon = 133611,
		num = 1,
	},
}

PermoksAccountManager.quests = {}

function PermoksAccountManager:getDefaultCategories(key)
	return key and default_categories[key] or default_categories
end

PermoksAccountManager.ICONSTRINGS = {
	left = "\124T%d:16:16\124t %s",
	right = "%s \124T%d:16:16\124t",
	leftBank = "\124T%d:0:0\124t %s (%s)",
	rightBank = "%s (%s) \124T%d:0:0\124t",
}

PermoksAccountManager.ICONBANKSTRINGS = {
	left = "\124T%d:0:0\124t %s (%s)",
	right = "%s (%s) \124T%d:0:0\124t",
}
