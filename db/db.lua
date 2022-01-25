local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local default_categories = {
	general = {
		order = 0,
		name = L["General"],
		childs = {"characterName", "ilevel", "gold", "weekly_key", "keystone", "mplus_score", "soul_cinders", 
		"soul_ash", "valor", "stygian_ember", "stygia", "cataloged_research", "tower_knowledge", "the_enlightened", "automaton"},
		childOrder = {characterName = 1, ilevel = 2, gold = 3, weekly_key = 4, keystone = 5, mplus_score = 6, soul_cinders = 7, 
		soul_ash = 8, valor = 9, stygian_ember = 10, stygia = 11, cataloged_research = 12, tower_knowledge = 13, the_enlightened = 14, automaton = 15},
		hideToggle = true,
		enabled = true,
	},
	currentdaily = {
		order = 2,
		name = L["Daily"],
		childs = {"korthia_dailies", "relic_creatures", "relic_gorger", "riftbound_cache", "helsworn_chest"},
		childOrder = {korthia_dailies = 1, relic_creatures = 2, relic_gorger = 3, riftbound_cache = 4, helsworn_chest = 5},
		enabled = true,
	},
	currentweekly = {
		order = 3,
		name = L["(Bi)Weekly"],
		childs = {"korthia_weekly", "anima_weekly", "maw_assault", "assault_vessels", "rift_vessels", "separator1", "battle_plans", "korthia_supplies", "containing_the_helsworn", "tormentors_weekly", "tormentors_locations",	
		"separator2", "adamant_vault_conduit", "torghast_layer", "world_boss", "contract"},
		childOrder = {korthia_weekly = 1, anima_weekly = 2, maw_assault = 3, assault_vessels = 4, rift_vessels = 5, separator1 = 10, battle_plans = 11, korthia_supplies = 12, containing_the_helsworn = 13, tormentors_weekly = 14, tormentors_locations = 15, 
		separator2 = 20, adamant_vault_conduit = 21, torghast_layer = 22, world_boss = 23, contract = 24},
		enabled = true,
	},
	vault = {
		order = 4,
		name = L["Vault"],
		childs = {"great_vault_mplus", "great_vault_raid", "great_vault_pvp"},
		childOrder = {great_vault_mplus = 1, great_vault_raid = 2, great_vault_pvp = 3},
		enabled = true,
	},
	reputation = {
		order = 6,
		name = L["Reputation"],
		childs = {"archivists", "deaths_advance", "venari", "ascended", "wild_hunt", "undying_army", "court_of_harvesters", "the_enlightened", "automaton"},
		childOrder = {archivists = 1, deaths_advance = 2, venari = 3, ascended = 4, wild_hunt = 5, undying_army = 6, court_of_harvesters = 7, the_enlightened = 8, automaton = 9},
		enabled = true,
	},
	raid = {
		order = 7,
		name = L["Raid"],
		childs = {"nathria", "sanctum_of_domination"},
		childOrder = {nathria = 1, sanctum_of_domination = 2},
		enabled = true,
	},
	sanctum = {
		order = 8,
		name = L["Sanctum"],
		childs = {"reservoir_anima", "renown", "redeemed_soul", "separator1", "transport_network", "anima_conductor", "command_table", "sanctum_unique"},
		childOrder = {reservoir_anima = 1, renown = 2, redeemed_soul = 3, separator1 = 4, transport_network = 5, anima_conductor = 6, command_table = 7, sanctum_unique = 8},
		enabled = true,
	},
	pvp = {
		order = 9,
		name = L["PVP"],
		childs = {"conquest", "honor", "arenaRating2v2", "arenaRating3v3", "rbgRating"},
		childOrder = {conquest = 1, honor = 2, arenaRating2v2 = 3, arenaRating3v3 = 4, rbgRating = 5},
		enabled = true,
	},
	items = {
		order = 10,
		name = L["Items"],
		childs = {"flask", "foodHaste", "augmentRune", "armorKit", "oilHeal", "oilDPS", "potHP", "drum", "potManaInstant", "potManaChannel", "tome", "korthiteCrystal"},
		childOrder = {flask = 1, foodHaste = 2, augmentRune = 3, armorKit = 4, oilHeal = 5, oilDPS = 6, potHP = 7, drum = 8, potManaInstant = 9, potManaChannel = 10, tome = 11, korthiteCrystal = 12},
		enabled = false
	},
	daily_nine_one = {
		order = 7,
		name = L["9.1 Daily"],
		childs = {"korthia_dailies", "relic_creatures", "relic_gorger", "riftbound_cache", "helsworn_chest"},
		childOrder = {korthia_dailies = 1, relic_creatures = 2, relic_gorger = 3, riftbound_cache = 4, helsworn_chest = 5},
		enabled = false,
	},
	weekly_nine_one = {
		order = 3,
		name = L["9.1 (Bi)Weekly"],
		childs = {"korthia_weekly", "anima_weekly", "maw_assault", "assault_vessels", "rift_vessels", "separator1", "battle_plans", "korthia_supplies", "containing_the_helsworn", "tormentors_weekly", "tormentors_locations",	
		"separator2", "adamant_vault_conduit", "torghast_layer", "world_boss", "contract"},
		childOrder = {korthia_weekly = 1, anima_weekly = 2, maw_assault = 3, assault_vessels = 4, rift_vessels = 5, separator1 = 10, battle_plans = 11, korthia_supplies = 12, containing_the_helsworn = 13, tormentors_weekly = 14, tormentors_locations = 15, 
		separator2 = 20, adamant_vault_conduit = 21, torghast_layer = 22, world_boss = 23, contract = 24},
		enabled = false,
	},
	none_zero =  {
		order = 5,
		name = L["9.0"],
		childs = {"callings", "maw_dailies", "sanctum_quests", "separator1", "mythics_done", "dungeon_quests", "pvp_quests", "weekend_event", 
		"separator2", "maw_souls", "wrath", "hunt"},
		childOrder = {callings = 1, maw_dailies = 2, sanctum_quests = 3, separator1 = 10, mythics_done = 11, dungeon_quests = 12, pvp_quests = 13, weekend_event = 14,
		separator2 = 20, maw_souls = 21, wrath = 22, hunt = 23},
		enabled = false,
	},
}

PermoksAccountManager.groups = {
	currency = {
		label = L["Currency"],
		order = 3,
	},
	character = {
		label = L["Character"],
		order = 2,
	},
	resetDaily = {
		label = L["Daily Reset"],
		order = 5,
	},
	resetWeekly = {
		label = L["Weekly Reset"],
		order = 6,
	},
	vault = {
		label = L["Vault"],
		order = 7,
	},
	torghast = {
		label = L["Torghast"],
		order = 8,
	},
	dungeons = {
		label = L["Dungeons"],
		order = 9,
	},
	raids = {
		label = L["Raids"],
		order = 10,
	},
	reputation = {
		label = L["Reputation"],
		order = 11,
	},
	buff = {
		label = L["Buff"],
		order = 12,
	},
	sanctum = {
		label = L["Sanctum"],
		order = 13,
	},
	separator = {
		label = L["Separator"],
		order = 1,
	},
	item = {
		label = L["Items"],
		order = 14,
	},
	pvp = {
		label = L["PVP"],
		order = 15,
	},
	onetime = {
		label = L["ETC"],
		order = 16,
	},
	other = {
		label = L["Other"],
		order = 17,
	},
}

PermoksAccountManager.labelRows = {
	separator1 = {
		hideLabel = true,
		label = "Separator1",
		data = function() return "" end,
		group = "separator",
	},
	separator2 = {
		hideLabel = true,
		label = "Separator2",
		data = function() return "" end,
		group = "separator",
	},
	separator3 = {
		hideLabel = true,
		label = "Separator3",
		data = function() return "" end,
		group = "separator",
	},
	separator4 = {
		hideLabel = true,
		label = "Separator4",
		data = function() return "" end,
		group = "separator",
	},
	separator5 = {
		hideLabel = true,
		label = "Separator5",
		data = function() return "" end,
		group = "separator",
	},
	separator6 = {
		hideLabel = true,
		label = "Separator6",
		data = function() return "" end,
		group = "separator",
	},
}

PermoksAccountManager.numDungeons = 9
PermoksAccountManager.keys = {
	[210] = "COS", -- Court of Stars
	[375] = "MISTS", 	-- Mists of Tirna Scithe
	[376] = "NW",		-- The Necrotic Wage
	[377] = "DOS",	-- De Other Side
	[378] = "HOA"	,	-- Halls of Atonement
	[379] = "PF",	-- Plaguefall
	[380] = "SD",	-- Sanguine Depths
	[381] = "SOA",	-- Spires of Ascension
	[382] = "TOP",	-- Theater of Pain
	[391] = "T:SOW", -- Tazavesh: Streets of Wonder
	[392] = "T:SG", -- Tazavesh: So'lesh Gambit
}

PermoksAccountManager.raids = {
	[2296] = {name = GetRealZoneText(2296), englishName = "nathria"},
	[2450] = {name = GetRealZoneText(2450), englishName = "sanctum_of_domination"},
}

PermoksAccountManager.dungeons = {
	[2286] = GetRealZoneText(2286),
	[2285] = GetRealZoneText(2285),
	[2293] = GetRealZoneText(2293),
	[2289] = GetRealZoneText(2289),
	[2287] = GetRealZoneText(2287),
	[2284] = GetRealZoneText(2284),
	[2290] = GetRealZoneText(2290),
	[2291] = GetRealZoneText(2291),
	[2441] = GetRealZoneText(2441),
}

PermoksAccountManager.item = {
	[171276] = {key = "flask"}, -- Flask
	[172045] = {key = "foodHaste"}, -- Haste Food
	[181468] = {key = "augmentRune"}, -- Rune
	[172347] = {key = "armorKit"}, -- Armor Kit
	[171286] = {key = "oilHeal"}, -- Heal Oil
	[171285] = {key = "oilDPS"}, -- DPS Oil
	[171267] = {key = "potHP"}, -- HP Pot
	[172233] = {key = "drum"}, -- Drum
	[171272] = {key = "potManaInstant"}, -- Mana Pot Instant
	[171268] = {key = "potManaChannel"}, -- Mana Pot Channel
	[173049] = {key = "tome"}, -- Tome
	[186017] = {key = "korthiteCrystal"}, -- Korthite Crystal
}

PermoksAccountManager.factions = {
	[2432] = {name = "Ve'nari", paragon = true, type = "friend"},
	[2472] = {name = "The Archivists' Codex", paragon = true, type = "friend"},
	[2407] = {name = "The Ascended", paragon = true},
	[2465] = {name = "The Wild Hunt", paragon = true},
	[2410] = {name = "The Undying Army", paragon = true},
	[2413] = {name = "Court of Harvesters", paragon = true},
	[2470] = {name = "Death's Advance", paragon = true},
	[2478] = {name = "The Enlightened", paragon = true},
	[2480] = {name = "Automa", paragon = true},
}

PermoksAccountManager.currency = {
	[1602] = 0,
	[1767] = 0,
	[1792] = 0,
	[1810] = 0,
	[1813] = 0,
	[1828] = 0,
	[1191] = 0,
	[1931] = 0,
	[1904] = 0,
	[1906] = 0,
	[1977] = 0,
	[1822] = 1,
}

PermoksAccountManager.quests = {
	maw_dailies = {
		[60732] = {questType = "daily", log = true},
		[61334] = {questType = "daily", log = true},
		[62239] = {questType = "daily", log = true},
		[63031] = {questType = "daily", log = true},
		[63038] = {questType = "daily", log = true},	
		[63039] = {questType = "daily", log = true},
		[63040] = {questType = "daily", log = true},
		[63043] = {questType = "daily", log = true},
		[63045] = {questType = "daily", log = true},
		[63047] = {questType = "daily", log = true},
		[63050] = {questType = "daily", log = true},
		[63062] = {questType = "daily", log = true},
		[63069] = {questType = "daily", log = true},
		[63072] = {questType = "daily", log = true},
		[63100] = {questType = "daily", log = true},
		[63179] = {questType = "daily", log = true},
		[60622] = {questType = "weekly", log = true},
	 	[60646] = {questType = "weekly", log = true},
	 	[60762] = {questType = "weekly", log = true},
	 	[60775] = {questType = "weekly", log = true},
	 	[60902] = {questType = "weekly", log = true},
	 	[61075] = {questType = "weekly", log = true},
	 	[61079] = {questType = "weekly", log = true},
	 	[61088] = {questType = "weekly", log = true},
	 	[61103] = {questType = "weekly", log = true},
	 	[61104] = {questType = "weekly", log = true},
	 	[61765] = {questType = "weekly", log = true},
	 	[62214] = {questType = "weekly", log = true},
	 	[62234] = {questType = "weekly", log = true},
	 	[63206] = {questType = "weekly", log = true},
	 },

	 transport_network = {
		-- Kyrian
		-- Venthyr
		-- Night Fae
		[62614] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = "daily", log = true},
		[62615] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = "daily", log = true},
		[62611] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = "daily", log = true},
		[62610] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = "daily", log = true},
		[62606] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = "daily", log = true},
		[62608] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = "daily", log = true},
		[60175] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = "daily", log = true},
		[62607] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = "daily", log = true},
		[62453] = {covenant = 3, sanctum = 2, minSanctumTier = 2, questType = "daily", log = true},
		[62296] = {covenant = 3, sanctum = 2, minSanctumTier = 2, questType = "daily", log = true},
		[60153] = {covenant = 3, sanctum = 2, minSanctumTier = 2, questType = "daily", log = true},
		[62382] = {covenant = 3, sanctum = 2, minSanctumTier = 2, questType = "daily", log = true},
		[62263] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = "daily", log = true},
		[62459] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = "daily", log = true},
		[62466] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = "daily", log = true},
		[60188] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = "daily", log = true},
		[62465] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = "daily", log = true},
	},

	korthia_dailies = {
		[63775] = {questType = "daily", log = true},
		[63776] = {questType = "daily", log = true},
		[63777] = {questType = "daily", log = true},
		[63778] = {questType = "daily", log = true},
		[63779] = {questType = "daily", log = true},
		[63780] = {questType = "daily", log = true},
		[63781] = {questType = "daily", log = true},
		[63782] = {questType = "daily", log = true},
		[63783] = {questType = "daily", log = true},
		[63784] = {questType = "daily", log = true},
		[63785] = {questType = "daily", log = true},
		[63786] = {questType = "daily", log = true},
		[63787] = {questType = "daily", log = true},
		[63788] = {questType = "daily", log = true},
		[63789] = {questType = "daily", log = true},
		[63790] = {questType = "daily", log = true},
		[63791] = {questType = "daily", log = true},
		[63792] = {questType = "daily", log = true},
		[63793] = {questType = "daily", log = true},
		[63794] = {questType = "daily", log = true},
		[63934] = {questType = "daily", log = true},
		[63935] = {questType = "daily", log = true},
		[63936] = {questType = "daily", log = true},
		[63937] = {questType = "daily", log = true},
		[63950] = {questType = "daily", log = true},
		[63954] = {questType = "daily", log = true},
		[63955] = {questType = "daily", log = true},
		[63956] = {questType = "daily", log = true},
		[63957] = {questType = "daily", log = true},
		[63958] = {questType = "daily", log = true},
		[63959] = {questType = "daily", log = true},
		[63960] = {questType = "daily", log = true},
		[63961] = {questType = "daily", log = true},
		[63962] = {questType = "daily", log = true},
		[63963] = {questType = "daily", log = true},
		[63964] = {questType = "daily", log = true},
		[63965] = {questType = "daily", log = true},
		[63989] = {questType = "daily", log = true},
		[64015] = {questType = "daily", log = true},
		[64016] = {questType = "daily", log = true},
		[64017] = {questType = "daily", log = true},
		[64043] = {questType = "daily", log = true},
		[64065] = {questType = "daily", log = true},
		[64070] = {questType = "daily", log = true},
		[64080] = {questType = "daily", log = true},
		[64089] = {questType = "daily", log = true},
		[64101] = {questType = "daily", log = true},
		[64103] = {questType = "daily", log = true},
		[64104] = {questType = "daily", log = true},
		[64129] = {questType = "daily", log = true},
		[64166] = {questType = "daily", log = true},
		[64194] = {questType = "daily", log = true},
		[64432] = {questType = "daily", log = true},
	},

	zereth_mortis_dailies = {
		[64717] = {questType = "daily", log	= true},
		[64785] = {questType = "daily", log = true},
		[64977] = {questType = "daily", log	= true},
		[65265] = {questType = "daily", log = true},
		[65325] = {questType = "daily", log = true},
		[65363] = {questType = "daily", log = true},
	},

	zereth_mortis_wqs = {
		[64974] = {questType = "daily"},
		[65081] = {questType = "daily"},
		[65406] = {questType = "daily"},
	},

	conductor = {
		[61691] = {covenant = 3, sanctum = 1, minSanctumTier = 1, addToMax = 1, questType = "daily"}, -- Large Lunarlight Pod
		[61633] = {covenant = 3, sanctum = 1, minSanctumTier = 1, addToMax = 1, questType = "daily"}, -- Dreamsong Fenn
		-- Necrolords
		[58872] = {covenant = 4, sanctum = 1, minSanctumTier = 1, addToMax = 1, questType = "daily"}, -- Gieger
		[61647] = {covenant = 4, sanctum = 1, minSanctumTier = 1, addToMax = 1, questType = "daily"}, -- Chosen Runecoffer
	},

	riftbound_cache = {
	 	[64456] = {questType = "daily"},
	 	[64470] = {questType = "daily"},
	 	[64471] = {questType = "daily"},
	 	[64472] = {questType = "daily"},
	},

	relic_creatures = {
	 	[64341] = {questType = "daily"},
	 	[64342] = {questType = "daily"},
	 	[64343] = {questType = "daily"},
	 	[64344] = {questType = "daily"},
	 	[64747] = {questType = "daily"},
	 	[64748] = {questType = "daily"},
	 	[64749] = {questType = "daily"},
	 	[64750] = {questType = "daily"},
	 	[64751] = {questType = "daily"},
	 	[64752] = {questType = "daily"},
	 	[64753] = {questType = "daily"},
	 	[64754] = {questType = "daily"},
	 	[64755] = {questType = "daily"},
	 	[64756] = {questType = "daily"},
	 	[64757] = {questType = "daily"},
	},

	helsworn_chest = {
 		[64256]= {questType = "daily"},
 	},


	relic_gorger = {
	 	[64433] = {questType = "daily"},
	 	[64434] = {questType = "daily"},
	 	[64435] = {questType = "daily"},
	 	[64436] = {questType = "daily"},
	},

	maw_souls = {
		[61332] = {covenant = 1, questType = "weekly", log = true}, -- kyrian 5 souls
		[62861] = {covenant = 1, questType = "weekly", log = true}, -- kyrian 10 souls
		[62862] = {covenant = 1, questType = "weekly", log = true}, -- kyrian 15 souls
		[62863] = {covenant = 1, questType = "weekly", log = true}, -- kyrian 20 souls
		[61334] = {covenant = 2, questType = "weekly", log = true}, -- venthyr 5 souls
		[62867] = {covenant = 2, questType = "weekly", log = true}, -- venthyr 10 souls
		[62868] = {covenant = 2, questType = "weekly", log = true}, -- venthyr 15 souls
		[62869] = {covenant = 2, questType = "weekly", log = true}, -- venthyr 20 souls
		[61331] = {covenant = 3, questType = "weekly", log = true}, -- night fae 5 souls
		[62858] = {covenant = 3, questType = "weekly", log = true}, -- night fae 10 souls
		[62859] = {covenant = 3, questType = "weekly", log = true}, -- night fae 15 souls
		[62860] = {covenant = 3, questType = "weekly", log = true}, -- night fae 20 souls
		[61333] = {covenant = 4, questType = "weekly", log = true}, -- necro 5 souls
		[62864] = {covenant = 4, questType = "weekly", log = true}, -- necro 10 souls
		[62865] = {covenant = 4, questType = "weekly", log = true}, -- necro 15 souls
		[62866] = {covenant = 4, questType = "weekly", log = true}, -- necro 20 souls
	},


	anima_weekly = {
		[61982] = {covenant = 1, questType = "weekly", log = true}, -- kyrian 1k anima
		[61981] = {covenant = 2, questType = "weekly", log = true}, -- venthyr 1k anima
		[61984] = {covenant = 3, questType = "weekly", log = true}, -- night fae 1k anima
		[61983] = {covenant = 4, questType = "weekly", log = true}, -- necro 1k anima
	},

	dungeon_quests = {
		[60242] = {questType = "weekly", log = true}, -- Trading Favors: Necrotic Wake
		[60243] = {questType = "weekly", log = true}, -- Trading Favors: Sanguine Depths
		[60244] = {questType = "weekly", log = true}, -- Trading Favors: Halls of Atonement
		[60245] = {questType = "weekly", log = true}, -- Trading Favors: The Other Side
		[60246] = {questType = "weekly", log = true}, -- Trading Favors: Tirna Scithe
		[60247] = {questType = "weekly", log = true}, -- Trading Favors: Theater of Pain
		[60248] = {questType = "weekly", log = true}, -- Trading Favors: Plaguefall
		[60249] = {questType = "weekly", log = true}, -- Trading Favors: Spires of Ascension
		[60250] = {questType = "weekly", log = true}, -- A Valuable Find: Theater of Pain
		[60251] = {questType = "weekly", log = true}, -- A Valuable Find: Plaguefall
	 	[60252] = {questType = "weekly", log = true}, -- A Valuable Find: Spires of Ascension
	 	[60253] = {questType = "weekly", log = true}, -- A Valuable Find: Necrotic Wake
	 	[60254] = {questType = "weekly", log = true}, -- A Valuable Find: Tirna Scithe
	 	[60255] = {questType = "weekly", log = true}, -- A Valuable Find: The Other Side
	 	[60256] = {questType = "weekly", log = true}, -- A Valuable Find: Halls of Atonement
	 	[60257] = {questType = "weekly", log = true}, -- A Valuable Find: Sanguine Depths
	},

	battle_plans = {
 		[64521] = {questType = "weekly", log = true}, -- Helsworn Battle Plans
 	},

 	korthia_supplies = {
 		[64522] = {questType = "weekly", log = true}, -- Stolen Korthia Supplies
 	},

 	pvp_quests = {
	 	-- PVP Weekly
	 	[62284] = {questType = "weekly", log = true}, -- Random BGs
	 	[62285] = {questType = "weekly", log = true}, -- Epic BGs
	 	[62286] = {questType = "weekly", log = true},
	 	[62287] = {questType = "weekly", log = true},
	 	[62288] = {questType = "weekly", log = true},
	 	[62289] = {questType = "weekly", log = true},
	},

 	-- Weekend Event
 	weekend_event = {
	 	[62631] = {questType = "weekly", log = true}, -- World Quests
	 	[62632] = {questType = "weekly", log = true}, -- BC Timewalking
	 	[62633] = {questType = "weekly", log = true}, -- WotLK Timewalking
	 	[62634] = {questType = "weekly", log = true}, -- Cata Timewalking
	 	[62635] = {questType = "weekly", log = true}, -- MOP Timewalking
	 	[62636] = {questType = "weekly", log = true}, -- Draenor Timewalking
	 	[62637] = {questType = "weekly", log = true}, -- Battleground Event
	 	[62638] = {questType = "weekly", log = true}, -- Mythuc Dungeon Event
	 	[62639] = {questType = "weekly", log = true}, -- Pet Battle Event
	 	[62640] = {questType = "weekly", log = true}, -- Arena Event
	},

	korthia_weekly = {
 		[63949] = {questType = "weekly", log = true}, -- Shaping Fate
 	},

 	-- Maw Warth of the Jailer
 	wrath = {
 		[63414] = {questType = "weekly"}, -- Wrath of the Jailer
 	},

 	-- Maw Hunt
 	hunt = {
	 	[63195] = {questType = "weekly"},
	 	[63198] = {questType = "weekly"},
	 	[63199] = {questType = "weekly"},
	 	[63433] = {questType = "weekly"},
 	},

 	-- World Boss
 	world_boss = {
	 	[61813] = {questType = "weekly"}, -- Valinor - Bastion
	 	[61814] = {questType = "weekly"}, -- Nurghash - Revendreth
	 	[61815] = {questType = "weekly"}, -- Oranomonos - Ardenweald
	 	[61816] = {questType = "weekly"}, -- Mortanis - Maldraxxus
	 	[64531] = {questType = "weekly"}, -- Mor'geth, Tormentor of the Damned
	},

	korthia_world_boss = {
		[64531] = {questType = "weekly"}, -- Mor'geth, Tormentor of the Damned
	},

	zereth_mortis_world_boss = {
		[65143] = {questType = "weekly"}, -- Antros

	},

	tormentors_weekly = {
 		[63854] = {questType = "weekly"}, -- Tormentors of Torghast
 		[64122] = {questType = "weekly"}, -- Tormentors of Torghast
 	},

 	tormentors_locations = {
	 	[64692] = {questType = "weekly"},
	 	[64693] = {questType = "weekly"},
	 	[64694] = {questType = "weekly"},
	 	[64695] = {questType = "weekly"},
	 	[64696] = {questType = "weekly"},
	 	[64697] = {questType = "weekly"},
	 	[64698] = {questType = "weekly"},
	},

	containing_the_helsworn = {
 		[64273] = {questType = "weekly"}, -- Containing the Helsworn World Quest
 	},

 	rift_vessels = {
	 	[64265] = {questType = "weekly"},
	 	[64269] = {questType = "weekly"},
	 	[64270] = {questType = "weekly"},
	},

	assault = {
		[63824] = {questType = "weekly"}, -- Kyrian
		[63543] = {questType = "weekly"}, -- Necrolord
		[63822] = {questType = "weekly"}, -- Venthyr
		[63823] = {questType = "weekly"}, -- Nightfae
	},

	assault_vessels = {
		[64056] = {name = "Venthyr", total = 2, questType = "weekly"},
	 	[64055] = {name = "Venthyr", total = 2, questType = "weekly"},
	 	[64058] = {name = "Kyrian", total = 2, questType = "weekly"},
	 	[64057] = {name = "Kyrian", total = 2, questType = "weekly"},
	 	[64059] = {name = "Night Fae", total = 2, questType = "weekly"},
	 	[64060] = {name = "Night Fae", total = 2, questType = "weekly"},
	 	[64044] = {name = "Necrolord", total = 2, questType = "weekly"},
	 	[64045] = {name = "Necrolord", total = 2, questType = "weekly"},
	},

	adamant_vault_conduit = {
		[64347] = {questType = "weekly"}
	},

	sanctum_normal_embers_trash = {
        [64610] = {questType = "weekly"},
        [64613] = {questType = "weekly"},
        [64616] = {questType = "weekly"},
        [64619] = {questType = "weekly"}, 
        [64622] = {questType = "weekly"},
    },

    sanctum_heroic_embers_trash = {
        [64611] = {questType = "weekly"},
        [64614] = {questType = "weekly"},
        [64617] = {questType = "weekly"},
        [64620] = {questType = "weekly"},
        [64623] = {questType = "weekly"},
    },

	korthia_five_dailies = {
		[63727] = {questType = "unlocks", log = true},
	},

	zereth_mortis_three_dailies = {

	},
}

PermoksAccountManager.locale = {
	currency = {
		["renown"] = C_CurrencyInfo.GetBasicCurrencyInfo(1822).name,
		["soul_ash"] = C_CurrencyInfo.GetBasicCurrencyInfo(1828).name,
		["stygia"] = C_CurrencyInfo.GetBasicCurrencyInfo(1767).name,
		["reservoir_anima"] = C_CurrencyInfo.GetBasicCurrencyInfo(1813).name,
		["redeemed_soul"] = C_CurrencyInfo.GetBasicCurrencyInfo(1810).name,
		["conquest"] = C_CurrencyInfo.GetBasicCurrencyInfo(1602).name,
		["honor"] = C_CurrencyInfo.GetBasicCurrencyInfo(1792).name,
		["valor"] = C_CurrencyInfo.GetBasicCurrencyInfo(1191).name,
	},
	raids = {
		nathria = {
			["deDE"] = "Castle Nathria",
			["enUS"] = "Castle Nathria",
			["enGB"] = "Castle Nathria",
			["esES"] = "Castle Nathria",
			["esMX"] = "Castle Nathria",
			["frFR"] = "Castle Nathria",
			["itIT"] = "Castle Nathria",
		},
	}
}

PermoksAccountManager.sanctum = {
	[1] = {
		[1] = 312, -- Anima Conductor
		[2] = 308, -- Transport Network
		[3] = 316, -- Command Table
		--[4] = 327, -- Resevoir Upgrades
		[5] = 320, -- Path of Ascension
	},
	[2] = {
		[1] = 314, -- Anima Conductor
		[2] = 309, -- Transport Network
		[3] = 317, -- Command Table
		--[4] = 326, -- Resevoir Upgrades
		[5] = 324, -- Ember Court
	},
	[3] = {
		[1] = 311, -- Anima Conductor
		[2] = 307, -- Transport Network
		[3] = 315, -- Command Table
		--[4] = 328, -- Resevoir Upgrades
		[5] = 319, -- The Queen's Conservatory
	},
	[4] = {
		[1] = 313, -- Anima Conductor
		[2] = 310, -- Transport Network
		[3] = 318, -- Command Table
		--[4] = 329, -- Resevoir Upgrades
		[5] = 321, -- Abomination Factory
	},
}

function PermoksAccountManager:getDefaultCategories()
	return default_categories
end

PermoksAccountManager.vault_rewards = {
	-- MythicPlus
	[Enum.WeeklyRewardChestThresholdType.MythicPlus] = {
		[2] = 226,
		[3] = 226,
		[4] = 226,
		[5] = 229,
		[6] = 229,
		[7] = 233,
		[8] = 236,
		[9] = 236,
		[10] = 239,
		[11] = 242,
		[12] = 246,
		[13] = 246,
		[14] = 249,
		[15] = 252,
	},
	-- RankedPvP
	[Enum.WeeklyRewardChestThresholdType.RankedPvP] = {
		[0] = 220,
		[1] = 226,
		[2] = 233,
		[3] = 240,
		[4] = 246,
		[5] = 246,
	},
	-- Raid
	[Enum.WeeklyRewardChestThresholdType.Raid] = {
		[17] = 213,
		[14] = 226,
		[15] = 239,
		[16] = 252,
	},
}

PermoksAccountManager.ICONSTRINGS = {
	left = "\124T%d:18:18\124t %s",
	right = "%s \124T%d:18:18\124t",
}

PermoksAccountManager.ICONBANKSTRINGS = {
	left = "\124T%d:18:18\124t %s (%s)",
	right = "%s (%s) \124T%d:18:18\124t",
}