local addonName, AltManager = ...
local locale = GetLocale()

AltManager.numMythicDungeons = 8
AltManager.keys = {
	[375] = "MISTS", 	-- Mists of Tirna Scithe
	[376] = "NW",		-- The Necrotic Wage
	[377] = "DOS",	-- De Other Side
	[378] = "HOA"	,	-- Halls of Atonement
	[379] = "PF",	-- Plaguefall
	[380] = "SD",	-- Sanguine Depths
	[381] = "SOA",	-- Spires of Ascension
	[382] = "TOP",	-- Theater of Pain
}

AltManager.vault_rewards = {
	-- MythicPlus
	[Enum.WeeklyRewardChestThresholdType.MythicPlus] = {
		[2] = 200,
		[3] = 203,
		[4] = 207,
		[5] = 210,
		[6] = 210,
		[7] = 213,
		[8] = 216,
		[9] = 216,
		[10] = 220,
		[11] = 220,
		[12] = 223,
		[13] = 223,
	},
	-- RankedPvP
	[Enum.WeeklyRewardChestThresholdType.RankedPvP] = {
		[0] = 200,
		[1] = 207,
		[2] = 213,
		[3] = 220,
		[4] = 226,
		[5] = 233,
	},
	-- Raid
	[Enum.WeeklyRewardChestThresholdType.Raid] = {
		[17] = 187,
		[14] = 200,
		[15] = 213,
		[16] = 226,
	},
}

AltManager.raids = {
	[2296] = {name = GetRealZoneText(2296), englishName = "nathria"},
}

AltManager.dungeons = {
	[2286] = GetRealZoneText(2286),
	[2285] = GetRealZoneText(2285),
	[2293] = GetRealZoneText(2293),
	[2289] = GetRealZoneText(2289),
	[2287] = GetRealZoneText(2287),
	[2284] = GetRealZoneText(2284),
	[2290] = GetRealZoneText(2290),
	[2291] = GetRealZoneText(2291),
}

AltManager.items = {
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
}

AltManager.factions = {
	friendship = {
		[2432] = {name = "Ve'nari", type = "friendship"},
	},
	faction = {
		[2407] = {name = "The Ascended", type = "faction"},
		[2465] = {name = "The Wild Hunt", type = "faction"},
		[2410] = {name = "The Undying Army", type = "faction"},
		[2413] = {name = "Court of Harvesters", type = "faction"},
	}
}

AltManager.currencies = {
	[1602] = true,
	[1767] = true,
	[1792] = true,
	[1810] = true,
	[1813] = true,
	[1828] = true,
	[1191] = true,
}

AltManager.quests = {
	daily = {
		[60732] = {key = "maw_dailies"},
		[61334] = {key = "maw_dailies"},
		[62239] = {key = "maw_dailies"},
		[63031] = {key = "maw_dailies"},
		[63038] = {key = "maw_dailies"},	
		[63039] = {key = "maw_dailies"},
		[63040] = {key = "maw_dailies"},
		[63043] = {key = "maw_dailies"},
		[63045] = {key = "maw_dailies"},
		[63047] = {key = "maw_dailies"},
		[63050] = {key = "maw_dailies"},
		[63062] = {key = "maw_dailies"},
		[63069] = {key = "maw_dailies"},
		[63072] = {key = "maw_dailies"},
		[63100] = {key = "maw_dailies"},
		[63179] = {key = "maw_dailies"},

		-- Kyrian
		-- Venthyr
		-- Night Fae
		[62614] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 1},
		[62615] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 1},
		[62611] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 1},
		[62610] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 1},
		[62606] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 1},
		[62608] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 1},
		[60175] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 1},
		[62607] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 1},
		[62453] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 2},
		[62296] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 2},
		[60153] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 2},
		[62382] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 2},
		[62263] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 3},
		[62459] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 3},
		[62466] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 3},
		[60188] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 3},
		[62465] = {covenant = 3, key = "transport_network", sanctum = 2, minSanctumTier = 3},

		[61691] = {covenant = 3, key = "conductor", sanctum = 1, minSanctumTier = 1, addToMax = 1}, -- Large Lunarlight Pod
		[61633] = {covenant = 3, key = "conductor", sanctum = 1, minSanctumTier = 1, addToMax = 1}, -- Dreamsong Fenn
		-- Necrolords
		[58872] = {covenant = 4, key = "conductor", sanctum = 1, minSanctumTier = 1, addToMax = 1}, -- Gieger
		[61647] = {covenant = 4, key = "conductor", sanctum = 1, minSanctumTier = 1, addToMax = 1}, -- Chosen Runecoffer
	},
	weekly = {
		[61332] = {covenant = 1, key = "maw_souls"}, -- kyrian 5 souls
		[62861] = {covenant = 1, key = "maw_souls"}, -- kyrian 10 souls
		[62862] = {covenant = 1, key = "maw_souls"}, -- kyrian 15 souls
		[62863] = {covenant = 1, key = "maw_souls"}, -- kyrian 20 souls
		[61334] = {covenant = 2, key = "maw_souls"}, -- venthyr 5 souls
		[62867] = {covenant = 2, key = "maw_souls"}, -- venthyr 10 souls
		[62868] = {covenant = 2, key = "maw_souls"}, -- venthyr 15 souls
		[62869] = {covenant = 2, key = "maw_souls"}, -- venthyr 20 souls
		[61331] = {covenant = 3, key = "maw_souls"}, -- night fae 5 souls
		[62858] = {covenant = 3, key = "maw_souls"}, -- night fae 10 souls
		[62859] = {covenant = 3, key = "maw_souls"}, -- night fae 15 souls
		[62860] = {covenant = 3, key = "maw_souls"}, -- night fae 20 souls
		[61333] = {covenant = 4, key = "maw_souls"}, -- necro 5 souls
		[62864] = {covenant = 4, key = "maw_souls"}, -- necro 10 souls
		[62865] = {covenant = 4, key = "maw_souls"}, -- necro 15 souls
		[62866] = {covenant = 4, key = "maw_souls"}, -- necro 20 souls

		[61982] = {covenant = 1, key = "anima"}, -- kyrian 1k anima
		[61981] = {covenant = 2, key = "anima"}, -- venthyr 1k anima
		[61984] = {covenant = 3, key = "anima"}, -- night fae 1k anima
		[61983] = {covenant = 4, key = "anima"}, -- necro 1k anima

		[60242] = {key = "dungeon_quests"}, -- Trading Favors: Necrotic Wake
		[60243] = {key = "dungeon_quests"}, -- Trading Favors: Sanguine Depths
		[60244] = {key = "dungeon_quests"}, -- Trading Favors: Halls of Atonement
		[60245] = {key = "dungeon_quests"}, -- Trading Favors: The Other Side
		[60246] = {key = "dungeon_quests"}, -- Trading Favors: Tirna Scithe
		[60247] = {key = "dungeon_quests"}, -- Trading Favors: Theater of Pain
		[60248] = {key = "dungeon_quests"}, -- Trading Favors: Plaguefall
		[60249] = {key = "dungeon_quests"}, -- Trading Favors: Spires of Ascension
		[60250] = {key = "dungeon_quests"}, -- A Valuable Find: Theater of Pain
		[60251] = {key = "dungeon_quests"}, -- A Valuable Find: Plaguefall
	 	[60252] = {key = "dungeon_quests"}, -- A Valuable Find: Spires of Ascension
	 	[60253] = {key = "dungeon_quests"}, -- A Valuable Find: Necrotic Wake
	 	[60254] = {key = "dungeon_quests"}, -- A Valuable Find: Tirna Scithe
	 	[60255] = {key = "dungeon_quests"}, -- A Valuable Find: The Other Side
	 	[60256] = {key = "dungeon_quests"}, -- A Valuable Find: Halls of Atonement
	 	[60257] = {key = "dungeon_quests"}, -- A Valuable Find: Sanguine Depths

	 	-- Maw Warth of the Jailer
	 	[63414] = {key = "wrath"}, -- Wrath of the Jailer

	 	-- Maw Hunt
	 	[63195] = {key = "hunt"},
	 	[63198] = {key = "hunt"},
	 	[63199] = {key = "hunt"},
	 	[63433] = {key = "hunt"},

	 	-- Maw Weekly
	 	[60622] = {key = "maw_weekly"},
	 	[60646] = {key = "maw_weekly"},
	 	[60762] = {key = "maw_weekly"},
	 	[60775] = {key = "maw_weekly"},
	 	[60902] = {key = "maw_weekly"},
	 	[61075] = {key = "maw_weekly"},
	 	[61079] = {key = "maw_weekly"},
	 	[61088] = {key = "maw_weekly"},
	 	[61103] = {key = "maw_weekly"},
	 	[61104] = {key = "maw_weekly"},
	 	[61765] = {key = "maw_weekly"},
	 	[62214] = {key = "maw_weekly"},
	 	[62234] = {key = "maw_weekly"},
	 	[63206] = {key = "maw_weekly"},

	 	-- World Boss
	 	[61813] = {key = "world_boss"}, -- Valinor - Bastion
	 	[61814] = {key = "world_boss"}, -- Nurghash - Revendreth
	 	[61815] = {key = "world_boss"}, -- Oranomonos - Ardenweald
	 	[61816] = {key = "world_boss"}, -- Mortanis - Maldraxxus

	 	-- PVP Weekly
	 	[62284] = {key = "pvp_quests"}, -- Random BGs
	 	[62285] = {key = "pvp_quests"}, -- Epic BGs
	 	[62286] = {key = "pvp_quests"},
	 	[62287] = {key = "pvp_quests"},
	 	[62288] = {key = "pvp_quests"},
	 	[62289] = {key = "pvp_quests"},

	 	-- Weekend Event
	 	[62631] = {key = "weekend_event"}, -- World Quests
	 	[62632] = {key = "weekend_event"}, -- BC Timewalking
	 	[62633] = {key = "weekend_event"}, -- WotLK Timewalking
	 	[62634] = {key = "weekend_event"}, -- Cata Timewalking
	 	[62635] = {key = "weekend_event"}, -- MOP Timewalking
	 	[62636] = {key = "weekend_event"}, -- Draenor Timewalking
	 	[62637] = {key = "weekend_event"}, -- Battleground Event
	 	[62638] = {key = "weekend_event"}, -- Mythuc Dungeon Event
	 	[62639] = {key = "weekend_event"}, -- Pet Battle Event
	 	[62640] = {key = "weekend_event"}, -- Arena Event
	},
}

AltManager.jailerWidgets = {
	[2885] = true,
}

AltManager.locale = {
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

AltManager.sanctum = {
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