local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local default_categories = {
	general = {
		order = 0,
		name = "General",
		childs = {
			"characterName",
			"characterLevel",
			"ilevel",
			"gold",
			"location",
			"profession1CDs",
			"profession2CDs",
			"honor_mists",
			"conquest_points",
			"justice_points",
			"valor_points",
			"ironpaw_token"
		},
		childOrder = {
			characterName = 1,
			characterLevel = 2,
			ilevel = 3,
			gold = 4,
			location = 5,
			profession1CDs = 6,
			profession2CDs = 7,
			honor_mists = 8,
			conquest_points = 9,
			justice_points = 10,
			valor_points = 11,
			ironpaw_token = 12,
		},
		hideToggle = true,
		enabled = true,
	},
	dailies = {
		order = 1,
		name = "Dailies (NYI)",
		childs = {},
		childOrder = {},
		enabled = true,
	},
	sharedFactions = {
		order = 2,
		name = "Repuation",
		childs = {
			"golden_lotus",
			"shado_pan",
			"the_august_celestials",
			"the_black_prince",
			"the_klaxxi",
			"separator1",
			"the_anglers",
			"separator2",
			"the_tillers",
		},
		childOrder = {
			golden_lotus = 1,
			shado_pan = 2,
			the_august_celestials = 3,
			the_black_prince = 4,
			the_klaxxi = 5,
			separator1 = 10,
			the_anglers = 11,
			separator2 = 20,
			the_tillers = 21,
		},
		enabled = true,
	},
	lockouts = {
		order = 3,
		name = "Lockouts",
		childs = {
			"mogushan_vaults",
			"heart_of_fear",
			"terrace_of_endless_spring",
		},
		childOrder = {
			mogushan_vaults = 1,
			heart_of_fear = 2,
			terrace_of_endless_spring = 3,
		},
		enabled = true,
	},
	items = {
		order = 7,
		name = "Items",
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
PermoksAccountManager.raids = {
	-- old mount drop raids (optional)
	[GetRealZoneText(309)] = { instanceID = 309, englishID = "zul_gurub" },
	[GetRealZoneText(532)] = { instanceID = 532, englishID = "karazhan" },
	[GetRealZoneText(550)] = { instanceID = 550, englishID = "tempest_keep" },

	-- Wrath of the Lich King
	[GetRealZoneText(533)] = { instanceID = 533, englishID = "naxxramas" },
	[GetRealZoneText(603)] = { instanceID = 603, englishID = "ulduar" },
	[GetRealZoneText(615)] = { instanceID = 615, englishID = "obsidian_sanctum" },
	[GetRealZoneText(616)] = { instanceID = 616, englishID = "eye_of_eternity" },
	[GetRealZoneText(624)] = { instanceID = 624, englishID = "vault_of_archavon" },
	[GetRealZoneText(649)] = { instanceID = 649, englishID = "trial_of_the_crusader" },
	[GetRealZoneText(249)] = { instanceID = 249, englishID = "onyxias_lair" },
	[GetRealZoneText(631)] = { instanceID = 631, englishID = "icecrown_citadel" },
	[GetRealZoneText(724)] = { instanceID = 724, englishID = "ruby_sanctum" },

	-- Catacylsm
	[GetRealZoneText(669)] = { instanceID = 669, englishID = "blackwing_descent" },
	[GetRealZoneText(671)] = { instanceID = 671, englishID = "the_bastion_of_twilight" },
	[GetRealZoneText(720)] = { instanceID = 720, englishID = "firelands" },
	[GetRealZoneText(754)] = { instanceID = 754, englishID = "throne_of_the_four_winds" },
	[GetRealZoneText(757)] = { instanceID = 757, englishID = "baradin_hold" },
	[GetRealZoneText(967)] = { instanceID = 967, englishID = "dragon_soul" },

	-- Mists
	[GetRealZoneText(1008)] = { instanceID = 1008, englishID = "mogushan_vaults" },
	[GetRealZoneText(1009)] = { instanceID = 1009, englishID = "heart_of_fear" },
	[GetRealZoneText(996)] = { instanceID = 996, englishID = "terrace_of_endless_spring" },
}

PermoksAccountManager.raidDifficultyLabels = {
	[1] = "5N",
	[2] = "5H",
	[3] = "10N",
	[4] = "25N",
	[5] = "10H",
	[6] = "25H",
	[9] = "40",
	[148] = "20",
	[173] = "N",
	[174] = "H",
	[175] = "10",
	[176] = "25",
	[193] = "10H",
	[194] = "25H",
}

-- GetCurrentRegion
-- TODO Use instanceID or GetRealZoneText as key
-- Seems like we probably have to use GetCurrentRegionName
PermoksAccountManager.oldRaidResetInfo = {
	-- US (+ Brazil + OC)
	[1] = {
		zg = { year = 2020, month = 4, day = 13, hour = 18, min = 0, sec = 0 },
		zgOC = { year = 2020, month = 4, day = 16, hour = 2, min = 0, sec = 0 }, -- not sure how to differentiate
	},
	-- Korea
	[2] = {},
	-- EU (+ Russia)
	[3] = {
		zg = { year = 2020, month = 4, day = 13, hour = 9, min = 0, sec = 0 }, --3*24*60*60
	},
	-- TW
	[4] = {},
	-- CN
	[5] = {
		zg = { year = 2020, month = 4, day = 18, hour = 7, min = 0, sec = 0 },
	},
}

PermoksAccountManager.numDungeons = 16

-- Name = MapID
PermoksAccountManager.dungeons = {}

PermoksAccountManager.item = {
	-- Flasks
	-- [46377] = { key = 'flaskEndlessRage' },           -- Flask of Endless Rage
}

PermoksAccountManager.factions = {
	[1269] = { name = "Golden Lotus" },
	[1270] = { name = "Shado-Pan" },
	[1341] = { name = "August Celestials" },
	[1359] = { name = "Black Prince" },
	[1337] = { name = "The Klaxxi" },
	[1302] = { name = "The Angler" },
	[1272] = { name = "The Tillers" },
}

PermoksAccountManager.currency = {
	[1900] = 0,
	[1901] = 0,
	[101] = 0,
	[102] = 0,
	[161] = 0,
	[221] = 0,
	[301] = 0,
	[2589] = 0,
	[2711] = 0,
	[341] = 0,
	[390] = 0,
	[391] = 0,
	[395] = 0,
	[396] = 0,
	[402] = 0, -- Ironpaw Token
}

PermoksAccountManager.currencyCustomOptions = {
	[395] = { forceUpdate = true },
	[396] = { forceUpdate = true },
}

PermoksAccountManager.professionCDs = {
	[L["Tailoring"]] = {
		cds = {
			[75141] = "Dreamcloth",
			[75142] = "Dreamcloth",
			[75144] = "Dreamcloth",
			[75145] = "Dreamcloth",
			[75146] = "Dreamcloth",
		},
		items = {
			[75141] = 54440,
			[75142] = 54440,
			[75144] = 54440,
			[75145] = 54440,
			[75146] = 54440,
		},
		icon = 136249,
		num = 6,
	},
	[L["Alchemy"]] = {
		cds = {
			[78866] = L["Transmute: Living Elements"], -- Transmute: Living Elements
			[80243] = L["Transmute: Truegold"], -- Transmute: Truegold
		},
		items = {
			[78866] = 54464,
			[80243] = 58480,
		},
		icon = 136240,
		num = 2,
	},
	[L["Leatherworking"]] = {
		icon = 133611,
		num = 0,
	},
	[L["Enchanting"]] = {
		icon = 136244,
		num = 0,
	},
	[L["Engineering"]] = {
		icon = 136243,
		num = 0,
	},
	[L["Blacksmithing"]] = {
		icon = 136241,
		num = 0,
	},
	[L["Herbalism"]] = {
		icon = 136246,
		num = 0,
	},
	[L["Mining"]] = {
		icon = 136248,
		num = 0,
	},
	[L["Skinning"]] = {
		icon = 134366,
		num = 0,
	},
	[L["Jewelcrafting"]] = {
		cds = {
			[73478] = L["Fire Prism"], -- Fire Prism
		},
		items = {
			[73478] = 52304,
		},
		icon = 134071,
		num = 1,
	},
	[L["Inscription"]] = {
		icon = 237171,
		num = 0,
	},
}

PermoksAccountManager.quests = {

}

function PermoksAccountManager:getDefaultCategories(key)
	return key and default_categories[key] or default_categories
end

PermoksAccountManager.ICONSTRINGS = {
	left = "\124T%d:18:18\124t %s",
	right = "%s \124T%d:18:18\124t",
	leftBank = "\124T%d:18:18\124t %s (%s)",
	rightBank = "%s (%s) \124T%d:18:18\124t",
}

PermoksAccountManager.ICONBANKSTRINGS = {
	left = "\124T%d:18:18\124t %s (%s)",
	right = "%s (%s) \124T%d:18:18\124t",
}
