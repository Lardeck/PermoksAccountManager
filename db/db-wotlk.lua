local addonName, PermoksAccountManager = ...
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local default_categories = {
	general = {
		order = 0,
		name = 'General',
		childs = {
			'characterName',
			'characterLevel',
			'ilevelWrath',
			'gearScore',
			'gold',
			'location',
			'profession1CDs',
			'profession2CDs',
			'dailyQuestCounter',
			'honorBCC',
			'arenaPoints',
			'emblem_of_heroism',
			'emblem_of_valor',
			'emblem_of_conquest',
			'emblem_of_triumph',
			'emblem_of_frost',
			'sidereal_essence',
			'stone_keepers_shard'
		},
		childOrder = {
			characterName = 1,
			characterLevel = 2,
			ilevelWrath = 3,
			gearScore = 4,
			gold = 5,
			location = 6,
			profession1CDs = 7,
			profession2CDs = 8,
			dailyQuestCounter = 9,
			honorBCC = 10,
			arenaPoints = 11,
			emblem_of_heroism = 12,
			emblem_of_valor = 13,
			emblem_of_conquest = 14,
			emblem_of_triumph = 15,
			emblem_of_frost = 16,
			sidereal_essence = 17,
			stone_keepers_shard = 18,
		},
		hideToggle = true,
		enabled = true
	},
	dailies = {
		order = 1,
		name = 'Dailies',
		childs = {
			'normal_dungeon_dailies',
			'heroic_dungeon_dailies',
			'separator1',
			'argent_crusade_dailies',
			'separator2',
			'wotlk_cooking_dailies',
			'wotlk_fishing_dailies',
			'wotlk_jewelcrafting_dailies'
		},
		childOrder = {
			normal_dungeon_dailies = 1,
			heroic_dungeon_dailies = 2,
			separator1 = 10,
			argent_crusade_dailies = 11,
			separator2 = 20,
			wotlk_cooking_dailies = 21,
			wotlk_fishing_dailies = 22,
			wotlk_jewelcrafting_dailies = 23,
		},
		enabled = true,
	},
	sharedFactions = {
		order = 3.1,
		name = 'Shared Rep',
		childs = {
			'kirin_tor',
			'argent_crusade',
			'the_kaluak',
			'the_wyrmrest_accord',
			'knights_of_the_ebon_blade',
			'frenzyheart_tribe',
			'the_oracles',
			'the_sons_of_hodir',
		},
		childOrder = {
			kirin_tor = 1,
			argent_crusade = 2,
			the_kaluak = 3,
			the_wyrmrest_accord = 4,
			knights_of_the_ebon_blade = 5,
			frenzyheart_tribe = 6,
			the_oracles = 7,
			the_sons_of_hodir = 8,
		},
		enabled = true
	},
	allianceFactions = {
		order = 3.2,
		name = 'Alliance Rep',
		childs = {
			'alliance_vanguard',
			'valiance_expedition',
			'explorers_league',
			'the_silver_covenant',
			'the_frostborn',
		},
		childOrder = {
			alliance_vanguard = 1,
			valiance_expedition = 2,
			explorers_league = 3,
			the_silver_covenant = 4,
			the_frostborn = 5,
		},
		enabled = true
	},
	hordeFactions = {
		order = 3.3,
		name = 'Horde Rep',
		childs = {
			'horde_expedition',
			'the_taunka',
			'the_hand_of_vengeance',
			'warsong_offensive',
			'the_sunreavers',
		},
		childOrder = {
			horde_expedition = 1,
			the_taunka = 2,
			the_hand_of_vengeance = 3,
			warsong_offensive = 4,
			the_sunreavers = 5,
		},
		enabled = true
	},
	lockouts = {
		order = 4,
		name = 'Lockouts',
		childs = {
			'heroics_done',
			'separator1',
			'obsidian_sanctum',
			'eye_of_eternity',
			'vault_of_archavon',
			'naxxramas',
			'separator2',
			'ulduar',
			'separator3',
			'trial_of_the_crusader',
			'onyxias_lair'
		},
		childOrder = {
			heroics_done = 1,
			separator1 = 10,
			obsidian_sanctum = 11,
			eye_of_eternity = 12,
			vault_of_archavon = 13,
			naxxramas = 14,
			separator2 = 20,
			ulduar = 21,
			separator3 = 22,
			trial_of_the_crusader = 23,
			onyxias_lair = 24,
		},
		enabled = true
	},
	consumables = {
		order = 6,
		name = 'Consumables',
		childs = {
			'flaskEndlessRage',
			'flaskStoneblood',
			'flaskFrostWyrm',
			'flaskPureMojo',
			'separator1',
			'foodFishFeast',
			'foodSpicedMammothTreats',
			'foodDragonfinFilet',
			'foodBlackenedDragonfin',
			'foodFirecrackerSalmon',
			'foodTenderShoveltuskSteak',
			'separator2',
			'potionOfSpeed',
			'potionOfWildMagic',
			'potionIndestructible',
			'potionRunicManaInjector',
			'potionRunicHealingInjector',
			'potionRunicMana',
			'potionRunicHealing',
			'potionFreeAction',
			'separator3',
			'engiGlobalThermalSapperCharge',
			'engiSaroniteBomb',
		},
		childOrder = {
			flaskEndlessRage = 1,
			flaskStoneblood = 2,
			flaskFrostWyrm = 3,
			flaskPureMojo = 4,
			separator1 = 10,
			foodFishFeast = 11,
			foodSpicedMammothTreats = 12,
			foodDragonfinFilet = 13,
			foodBlackenedDragonfin = 14,
			foodFirecrackerSalmon = 15,
			foodTenderShoveltuskSteak = 16,
			separator2 = 20,
			potionOfSpeed = 21,
			potionOfWildMagic = 22,
			potionIndestructible = 23,
			potionRunicManaInjector = 24,
			potionRunicHealingInjector = 25,
			potionRunicMana = 26,
			potionRunicHealing = 27,
			potionFreeAction = 28,
			separator3 = 30,
			engiGlobalThermalSapperCharge = 31,
			engiSaroniteBomb = 32,
		},
		enabled = true
	},
	items = {
		order = 7,
		name = 'Items',
		childs = {
			'trophyOfTheCrusade',
			'frozenOrb',
			'runedOrb',
			'crusaderOrb',
		},
		childOrder = {
			trophyOfTheCrusade = 1,
			frozenOrb = 2,
			runedOrb = 3,
			crusaderOrb = 4,
		},
		enabled = true
	}
}

PermoksAccountManager.groups = {
	character = {
		label = L['Character'],
		order = 2
	},
	currency = {
		label = L['Currency'],
		order = 4
	},
	resetDaily = {
		label = L['Daily Reset'],
		order = 5
	},
	resetWeekly = {
		label = L['Weekly Reset'],
		order = 6
	},
	dungeons = {
		label = L['Dungeons'],
		order = 7
	},
	raids = {
		label = L['Raids'],
		order = 8
	},
	reputation = {
		label = L['Reputation'],
		order = 9
	},
	buff = {
		label = L['Buff'],
		order = 10
	},
	separator = {
		label = L['Separator'],
		order = 1
	},
	item = {
		label = L['Items'],
		order = 11
	},
	extra = {
		label = L['Extra'],
		order = 12
	},
	profession = {
		label = L['Professions'],
		order = 13
	},
	other = {
		label = L['Other'],
		order = 14
	}
}

PermoksAccountManager.labelRows = {
	separator1 = {
		hideLabel = true,
		label = 'Separator1',
		data = function()
			return ''
		end,
		group = 'separator'
	},
	separator2 = {
		hideLabel = true,
		label = 'Separator2',
		data = function()
			return ''
		end,
		group = 'separator'
	},
	separator3 = {
		hideLabel = true,
		label = 'Separator3',
		data = function()
			return ''
		end,
		group = 'separator'
	},
	separator4 = {
		hideLabel = true,
		label = 'Separator4',
		data = function()
			return ''
		end,
		group = 'separator'
	},
	separator5 = {
		hideLabel = true,
		label = 'Separator5',
		data = function()
			return ''
		end,
		group = 'separator'
	},
	separator6 = {
		hideLabel = true,
		label = 'Separator6',
		data = function()
			return ''
		end,
		group = 'separator'
	}
}

-- instanceID = mapID (retail uses instanceIDs)
PermoksAccountManager.raids = {
	[GetRealZoneText(533)] = { instanceID = 533, englishID = 'naxxramas' },
	[GetRealZoneText(603)] = {instanceID = 603, englishID = 'ulduar'},
	[GetRealZoneText(615)] = { instanceID = 615, englishID = 'obsidian_sanctum' },
	[GetRealZoneText(616)] = { instanceID = 616, englishID = 'eye_of_eternity' },
	[GetRealZoneText(624)] = { instanceID = 624, englishID = 'vault_of_archavon' },
	[GetRealZoneText(649)] = {instanceID = 649, englishID = 'trial_of_the_crusader'},
	[GetRealZoneText(249)] = {instanceID = 249, englishID = 'onyxias_lair'},
	--[GetRealZoneText(631)] = {instanceID = 631, englishID = 'icecrown_citadel'},
	--[GetRealZoneText(724)] = {instanceID = 724, englishID = 'ruby_sanctum'},
    -- old mount drop raids (optional)
	[GetRealZoneText(309)] = {instanceID = 309, englishID = 'zul_gurub'},
	[GetRealZoneText(532)] = {instanceID = 532, englishID = 'karazhan'},
	[GetRealZoneText(550)] = {instanceID = 550, englishID = 'tempest_keep'},
}

PermoksAccountManager.raidDifficultyLabels = {
	[1] = '5N',
	[2] = '5H',
	[3] = '10N',
	[4] = '25N',
	[5] = '10H',
	[6] = '25H',
	[9] = '40',
	[148] = '20',
	[173] = 'N',
	[174] = 'H',
	[175] = '10',
	[176] = '25',
	[193] = '10H',
	[194] = '25H',
}

PermoksAccountManager.numDungeons = 13

-- Name = MapID
PermoksAccountManager.dungeons = {
	[GetRealZoneText(574)] = 574, -- Utgarde Keep
	[GetRealZoneText(575)] = 575, -- Utgarde Pinnacle
	[GetRealZoneText(576)] = 576, -- The Nexus
	[GetRealZoneText(578)] = 578, -- The Oculus
	[GetRealZoneText(595)] = 595, -- The Culling of Stratholme
	[GetRealZoneText(599)] = 599, -- Halls of Stone
	[GetRealZoneText(600)] = 600, -- Drak'Tharon Keep
	[GetRealZoneText(601)] = 601, -- Azjo-Nerub
	[GetRealZoneText(602)] = 602, -- Halls of Lightning
	[GetRealZoneText(604)] = 604, -- Gundrak
	[GetRealZoneText(608)] = 608, -- Violet Hold
	[GetRealZoneText(619)] = 619, -- Ahn'kahet: The Old Kingdom
	--[GetRealZoneText(632)] = 632, -- The Forge of Souls
	[GetRealZoneText(650)] = 650, -- Trial of the Champion
	--[GetRealZoneText(658)] = 658, -- Pit of Saron
	--[GetRealZoneText(668)] = 668, -- Halls of Reflection
}

PermoksAccountManager.item = {
	-- Flasks
	[46377] = { key = 'flaskEndlessRage' }, -- Flask of Endless Rage
	[46379] = { key = 'flaskStoneblood' }, -- Flask of Stoneblood
	[46376] = { key = 'flaskFrostWyrm' }, -- Flask of Frost Wyrm
	[46378] = { key = 'flaskPureMojo' }, -- Flask of Pure Mojo
	-- Food buffs
	[43015] = { key = 'foodFishFeast' }, -- Fish Feast
	[43005] = { key = 'foodSpicedMammothTreats' }, -- Spiced Mammoth Treats
	[42999] = { key = 'foodDragonfinFilet' }, -- Dragonfin Filet
	[43000] = { key = 'foodBlackenedDragonfin' }, -- Blackened Dragonfin
	[34767] = { key = 'foodFirecrackerSalmon' }, -- Firecracker Salmon
	[34755] = { key = 'foodTenderShoveltuskSteak' }, -- Tender Shoveltusk Steak
	-- Potions
	[40211] = { key = 'potionOfSpeed' }, -- Potion of Speed
	[40212] = { key = 'potionOfWildMagic' }, -- Potion of Wild Magic
	[40093] = { key = 'potionIndestructible' }, -- Indestructible Potion
	[42545] = { key = 'potionRunicManaInjector' }, -- Runic Mana Injector
	[41166] = { key = 'potionRunicHealingInjector' }, -- Runic Healing Injector
	[33448] = { key = 'potionRunicMana' }, -- Runic Mana Potion
	[33447] = { key = 'potionRunicHealing' }, -- Runic Healing Potion
	[5634] = { key = 'potionFreeAction' }, -- Free Action Potion
	-- Engineering
	[42641] = { key = 'engiGlobalThermalSapperCharge' }, -- Global Thermal Sapper Charge
	[41119] = { key = 'engiSaroniteBomb' }, -- Saronite Bomb
	-- Others
	[47242] = { key = 'trophyOfTheCrusade' }, -- Trophy of the Crusade
	[43102] = { key = 'frozenOrb' }, -- Frozen Orb
	[45087] = { key = 'runedOrb' }, -- Runed Orb
	[47556] = { key = 'crusaderOrb' }, -- Crusader Orb
}

PermoksAccountManager.factions = {
	[1037] = { name = 'Alliance Vanguard', faction = 'Alliance' },
	[1050] = { name = 'Valiance Expedition', faction = 'Alliance' },
	[1052] = { name = 'Horde Expedition', faction = 'Horde' },
	[1064] = { name = 'The Taunka', faction = 'Horde' },
	[1067] = { name = 'The Hand of Vengeance', faction = 'Horde' },
	[1068] = { name = "Explorers' League", faction = 'Alliance' },
	[1073] = { name = "The Kalu'ak" },
	[1085] = { name = 'Warsong Offensive', faction = 'Horde' },
	[1090] = { name = 'Kirin Tor' },
	[1091] = { name = 'Wyrmrest Accord' },
	[1094] = { name = 'Silver Covenant', faction = 'Alliance' }, -- Argent Tournament
	[1098] = { name = 'Ebon Blade' },
	[1104] = { name = 'Frenzyheart Tribe' },
	[1105] = { name = 'The Oracles' },
	[1106] = { name = 'Argent Crusade' },
	--[1117] = { name = 'Sholazar Basin' },
	[1119] = { name = 'Sons of Hodir' },
	[1124] = { name = 'The Sunreavers', faction = 'Horde' }, -- Argent Tournament
	[1126] = { name = 'The Frostborn', faction = 'Alliance' },
	[1156] = { name = 'The Ashen Verdict' },
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
	[341] = 0,
}

PermoksAccountManager.professionCDs = {
	[L['Tailoring']] = {
		cds = {
			[56001] = L['Moonshroud'], -- Moonshroud
			[56002] = L['Ebonweave'], -- Ebonweave
			[56003] = L['Spellweave'] -- Spellweave
		},
		items = {
			[56001] = 41594,
			[56002] = 41593,
			[56003] = 41595
		},
		icon = 136249,
		num = 3
	},
	[L['Alchemy']] = {
		cds = {
			[66658] = L['Transmute'] -- Transmute: Ametrine
		},
		items = {
			[66658] = 36931
		},
		icon = 136240,
		num = 1
	},
	[L['Leatherworking']] = {
		icon = 133611,
		num = 0
	},
	[L['Enchanting']] = {
		icon = 136244,
		num = 0
	},
	[L['Engineering']] = {
		icon = 136243,
		num = 0
	},
	[L['Blacksmithing']] = {
		icon = 136241,
		num = 0
	},
	[L['Herbalism']] = {
		icon = 136246,
		num = 0
	},
	[L['Mining']] = {
		cds = {
			[55208] = L['Titansteel'] -- Titansteel
		},
		items = {
			[55208] = 37663,
		},
		icon = 136248,
		num = 1
	},
	[L['Skinning']] = {
		icon = 134366,
		num = 0
	},
	[L['Jewelcrafting']] = {
		cds = {
			[62242] = L['Icy Prism'] -- Icy Prism
		},
		items = {
			[62242] = 44943
		},
		icon = 134071,
		num = 1
	},
	[L['Inscription']] = {
		icon = 237171,
		num = 0,
	}
}

PermoksAccountManager.quests = {
	general_dailies = {
		-- Grizzly Hills
		[12038] = { questType = 'daily', log = true }, -- Seared Scourge

		-- The Storm Peaks
		[12833] = { questType = 'daily', log = true }, -- Overstock
		[13424] = { questType = 'daily', log = true }, -- Back to the Pit
		[13423] = { questType = 'daily', log = true }, -- Defending Your Title
		[13422] = { questType = 'daily', log = true }, -- Maintaining Discipline
		[13425] = { questType = 'daily', log = true }, -- The Abberations Must Die
	},

	general_horde_dailies = {
		[12170] = { questType = 'daily', log = true, faction = 'Horde' }, -- Backriver Brawl
		[12315] = { questType = 'daily', log = true, faction = 'Horde' }, -- Crush Captain Brightwater!
		[12317] = { questType = 'daily', log = true, faction = 'Horde' }, -- Keep Them at Bay
		[12324] = { questType = 'daily', log = true, faction = 'Horde' }, -- Smoke'Em Out
		[12432] = { questType = 'daily', log = true, faction = 'Horde' }, -- Riding the Red Rocket
		[13261] = { questType = 'daily', log = true, faction = 'Horde' }, -- Volatility
		[13276] = { questType = 'daily', log = true, faction = 'Horde' }, -- Thats' Abominable!
		[13353] = { questType = 'daily', log = true, faction = 'Horde' }, -- Drag and Drop
		[13357] = { questType = 'daily', log = true, faction = 'Horde' }, -- Retest Now
		[13365] = { questType = 'daily', log = true, faction = 'Horde' }, -- Not a Bug
	},

	general_alliance_dailies = {
		[12244] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Shredder Repair
		[12268] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Pieces Parts
		[12314] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Down with Captain Zorna!
		[12316] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Keep Them at Bay!
		[12323] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Smoke'Em Out
		[12437] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Riding the Red Rocket
		[13233] = { questType = 'daily', log = true, faction = 'Alliance' }, -- No Mercy!
		[13289] = { questType = 'daily', log = true, faction = 'Alliance' }, -- That's Abominable!
		[13292] = { questType = 'daily', log = true, faction = 'Alliance' }, -- The Solution Solution
		[13322] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Retest Now
		[13323] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Drag and Drop
		[13344] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Not a Bug
		[13350] = { questType = 'daily', log = true, faction = 'Alliance' }, -- No Rest For The Wicked
		[13404] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Static Shock Troops: the Bombardment
	},

	normal_dungeon_dailies = {
		-- Timear Foresees
		[13240] = { questType = 'daily', log = true }, -- Normal: Oculus
		[13243] = { questType = 'daily', log = true }, -- Normal: Culling of Stratholme
		[13244] = { questType = 'daily', log = true }, -- Normal: Halls of Lightning
		[13241] = { questType = 'daily', log = true }, -- Normal: Utgarde Pinnacle
	},

	heroic_dungeon_dailies = {
		-- Proof of Demise
		[13250] = { questType = 'daily', log = true }, -- Heroic: Gundrak
		[13252] = { questType = 'daily', log = true }, -- Heroic: Halls of Stone
		[13253] = { questType = 'daily', log = true }, -- Heroic: Halls of Lightning
		[13246] = { questType = 'daily', log = true }, -- Heroic: The Nexus
		[13245] = { questType = 'daily', log = true }, -- Heroic: Utgarde Keep
		[13254] = { questType = 'daily', log = true }, -- Heroic: Azjol-Nerub
		[13255] = { questType = 'daily', log = true }, -- Heroic: Ahn'kahet: The Old Kingdom
		[13249] = { questType = 'daily', log = true }, -- Heroic: Drak'Tharon Keep
		[13256] = { questType = 'daily', log = true }, -- Heroic: The Violet Hold
		[13251] = { questType = 'daily', log = true }, -- Heroic: Culling of Stratholme
		[13247] = { questType = 'daily', log = true }, -- Heroic: The Oculus
		[13248] = { questType = 'daily', log = true }, -- Heroic: Utgarde Pinnacle
		[14199] = { questType = 'daily', log = true }, -- Heroic: Trial of the Champion
	},

	valiance_expedition_dailies = {
		[11153] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Break the Blockade
		[12289] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Kick 'Em While They're Down
		[12296] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Life or Death
		[12444] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Blackriver Skirmish
		[13280] = { questType = 'daily', log = true, faction = 'Alliance' }, -- King of the Mountain
		[13284] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Assault by Ground
		[13309] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Assault by Air
		[13333] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Capture More Dispatches
		[13336] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Blood of the Chosen
	},

	explorers_league_dailies = {
		[11391] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Steel Gate Patrol
	},

	the_frostborn_dailies = {
		[12869] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Pushed Too Far
	},

	--Patch 3.1
	the_silver_covenant_dailies = {

	},

	--Patch 3.1
	the_sunreavers_dailies = {

	},

	warsong_offensive_dailies = {
		[12270] = { questType = 'daily', log = true, faction = 'Horde' }, -- Shred the Alliance
		[12280] = { questType = 'daily', log = true, faction = 'Horde' }, -- Making Repairs
		[12284] = { questType = 'daily', log = true, faction = 'Horde' }, -- Keep 'Em on Their Heels
		[12288] = { questType = 'daily', log = true, faction = 'Horde' }, -- Overwhelmed!
		[13283] = { questType = 'daily', log = true, faction = 'Horde' }, -- King of the Mountain
		[13301] = { questType = 'daily', log = true, faction = 'Horde' }, -- Assault by Ground
		[13310] = { questType = 'daily', log = true, faction = 'Horde' }, -- Assault by Air
		[13330] = { questType = 'daily', log = true, faction = 'Horde' }, -- Blood of the Chosen
		[13331] = { questType = 'daily', log = true, faction = 'Horde' }, -- Keeping the Alliance Blind
	},

	the_sons_of_hodir_dailies = {
		[12977] = { questType = 'daily', log = true }, -- Hodir's Call (Friendly)
		[12981] = { questType = 'daily', log = true }, -- Hot and Cold (Friendly)
		[12994] = { questType = 'daily', log = true }, -- Spy Hunter (Honored)
		[13003] = { questType = 'daily', log = true }, -- How to Slay Your Dragon (Honored)
		[13006] = { questType = 'daily', log = true }, -- A Viscous Cleaning (Honored)
		[13046] = { questType = 'daily', log = true }, -- Feeding Arngrim (Revered)
	},

	knights_of_the_ebon_blade_dailies = {
		[12813] = { questType = 'daily', log = true }, -- From Their Corpses, Rise!
		[12815] = { questType = 'daily', log = true }, -- No Fly Zone
		[12838] = { questType = 'daily', log = true }, -- Intelligence Gathering
		[12995] = { questType = 'daily', log = true }, -- Leave Our Mark
		[13069] = { questType = 'daily', log = true }, -- Shoot'Em Up
		[13071] = { questType = 'daily', log = true }, -- Vile Like Fire!
	},

	the_oracles_dailies = {
		[12704] = { questType = 'daily', log = true }, -- Appeasing the Great Rain Stone
		[12705] = { questType = 'daily', log = true }, -- Will of the Titans
		[12726] = { questType = 'daily', log = true }, -- Song of Wind and Water
		[12735] = { questType = 'daily', log = true }, -- A Cleansing Song
		[12737] = { questType = 'daily', log = true }, -- Song of Fecundity
		[12736] = { questType = 'daily', log = true }, -- Song of Reflection
		[12761] = { questType = 'daily', log = true }, -- Mastery of the Crystals
		[12762] = { questType = 'daily', log = true }, -- Power of the Great Ones
	},

	frenzyheart_tribe_dailies = {
		[12702] = { questType = 'daily', log = true }, -- Chicken Party!
		[12703] = { questType = 'daily', log = true }, -- Kartak's Rampage
		[12732] = { questType = 'daily', log = true }, -- The Heartblood's Strength
		[12734] = { questType = 'daily', log = true }, -- Rejek: First Blood
		[12741] = { questType = 'daily', log = true }, -- Strength of the Tempest
		[12758] = { questType = 'daily', log = true }, -- A Hero's Headgear
		[12759] = { questType = 'daily', log = true }, -- Tools of War
		[12760] = { questType = 'daily', log = true }, -- Secret Strength of the Frenzyheart

	},

	the_wyrmrest_accord_dailies = {
		[11940] = { questType = 'daily', log = true }, -- Drake Hunt
		[12372] = { questType = 'daily', log = true }, -- Defending Wyrmrest Temple
		[13414] = { questType = 'daily', log = true }, -- Aces High!
	},

	the_kaluak_dailies = {
		[11472] = { questType = 'daily', log = true }, -- The Way to His Heart...
		[11945] = { questType = 'daily', log = true }, -- Preparing for the Worst
		[11960] = { questType = 'daily', log = true }, -- Planning for the Future
	},

	argent_crusade_dailies = {
		[12501] = { questType = 'daily', log = true }, -- Troll Patrol
		[12502] = { questType = 'daily', log = true }, -- Troll Patrol: Can You Dig It? (Captain Brandon - 75)
		[12509] = { questType = 'daily', log = true }, -- Troll Patrol: Intestinal Fortitude (Captain Rupert - 250)
		[12519] = { questType = 'daily', log = true }, -- Troll Patrol: Whatdya Want, a Medal? (Captain Grondel - 25)
		[12541] = { questType = 'daily', log = true }, -- Troll Patrol: The Alchemist's Apprentice (Alchemist Finklestein - 75)
		[12564] = { questType = 'daily', log = true }, -- Troll Patrol: Something for the Pain (Captain Brandon - 75)
		[12568] = { questType = 'daily', log = true }, -- Troll Patrol: Done to Death (Captain Rupert - 75)
		[12585] = { questType = 'daily', log = true }, -- Troll Patrol: Creature Comforts (Captain Grondel - 75)
		[12588] = { questType = 'daily', log = true }, -- Troll Patrol: Can You Dig It? (Captain Brandon - 75)
		[12591] = { questType = 'daily', log = true }, -- Troll Patrol: Throwing Down (Captain Rupert - 75)
		[12594] = { questType = 'daily', log = true }, -- Troll Patrol: Couldn't Care Less (Captain Grondel - 75)
		[12604] = { questType = 'daily', log = true }, -- Congratulations!
		[13302] = { questType = 'daily', log = true, faction = 'Horde' }, -- Slaves to Saronite
		[13300] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Slaves to Saronite
	},

	wotlk_cooking_dailies = {
		[13100] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Infused Mushroom Meatloaf
		[13101] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Convention at the Legerdemain
		[13102] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Sewer Stew
		[13103] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Cheese for Glowergold
		[13107] = { questType = 'daily', log = true, faction = 'Alliance' }, -- Mustard Dogs!
		[13112] = { questType = 'daily', log = true, faction = 'Horde' }, -- Infused Mushroom Meatloaf
		[13113] = { questType = 'daily', log = true, faction = 'Horde' }, -- Convention at the Legerdemain
		[13114] = { questType = 'daily', log = true, faction = 'Horde' }, -- Sewer Stew
		[13115] = { questType = 'daily', log = true, faction = 'Horde' }, -- Cheese for Glowergold
		[13116] = { questType = 'daily', log = true, faction = 'Horde' }, -- Mustard Dogs!
	},

	wotlk_fishing_dailies = {
		[13830] = { questType = 'daily', log = true }, -- The Ghostfish
		[13832] = { questType = 'daily', log = true }, -- Jewel of the Sewers
		[13833] = { questType = 'daily', log = true }, -- Blood Is Thicker
		[13834] = { questType = 'daily', log = true }, -- Dangerously Delicious
		[13836] = { questType = 'daily', log = true }, -- Disarmed!
	},

	wotlk_jewelcrafting_dailies = {
		[12958] = { questType = 'daily', log = true }, -- Shipment: Blood Jade Amulet
		[12959] = { questType = 'daily', log = true }, -- Shipment: Glowing Ivory Figurine
		[12960] = { questType = 'daily', log = true }, -- Shipment: Wicked Sun Brooch
		[12961] = { questType = 'daily', log = true }, -- Shipment: Intricate Bone Figurine
		[12962] = { questType = 'daily', log = true }, -- Shipment: Bright Armor Relic
		[12963] = { questType = 'daily', log = true }, -- Shipment: Shifting Sun Curio
	}
}

function PermoksAccountManager:getDefaultCategories(key)
	return key and default_categories[key] or default_categories
end

PermoksAccountManager.ICONSTRINGS = {
	left = '\124T%d:18:18\124t %s',
	right = '%s \124T%d:18:18\124t',
	leftBank = '\124T%d:18:18\124t %s (%s)',
	rightBank = '%s (%s) \124T%d:18:18\124t'
}

PermoksAccountManager.ICONBANKSTRINGS = {
    left = '\124T%d:18:18\124t %s (%s)',
    right = '%s (%s) \124T%d:18:18\124t'
}
