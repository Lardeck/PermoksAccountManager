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
			'justice_points',
			'valor_points',
			'tol_barad_commendations',
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
			justice_points = 12,
			valor_points = 13,
			tol_barad_commendations = 14,
		},
		hideToggle = true,
		enabled = true
	},
	dailies = {
		order = 1,
		name = 'Dailies',
		childs = {
		},
		childOrder = {
		},
		enabled = true,
	},
	sharedFactions = {
		order = 3.1,
		name = 'Repuation',
		childs = {
			'guardians_of_hyjal',
			'ramkahen',
			'the_earthen_ring',
			'therazane',
			'separator2',
			'wildhammer_clan',
			'dragonmaw_clan',
			'separator3',
			'baradins_warden',
			'hellscreams_reach',
		},
		childOrder = {
			guardians_of_hyjal = 1,
			ramkahen = 2,
			the_earthen_ring = 3,
			therazane = 4,
			separator2 = 20,
			wildhammer_clan = 21,
			dragonmaw_clan = 22,
			separator3 = 30,
			baradins_warden = 31,
			hellscreams_reach = 32,
		},
		enabled = true
	},
	lockouts = {
		order = 4,
		name = 'Lockouts',
		childs = {
			'baradin_hold',
			'blackwing_descent',
			'the_bastion_of_twilight',
			'throne_of_the_four_winds',
		},
		childOrder = {
			baradin_hold = 1,
			blackwing_descent = 2,
			the_bastion_of_twilight = 3,
			throne_of_the_four_winds = 4,
		},
		enabled = true
	},
	consumables = {
		order = 6,
		name = 'Consumables',
		childs = {

		},
		childOrder = {

		},
		enabled = true
	},
	items = {
		order = 7,
		name = 'Items',
		childs = {

		},
		childOrder = {

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
	-- old mount drop raids (optional)
	[GetRealZoneText(309)] = { instanceID = 309, englishID = 'zul_gurub' },
	[GetRealZoneText(532)] = { instanceID = 532, englishID = 'karazhan' },
	[GetRealZoneText(550)] = { instanceID = 550, englishID = 'tempest_keep' },

	-- Wrath of the Lich King
	[GetRealZoneText(533)] = { instanceID = 533, englishID = 'naxxramas' },
	[GetRealZoneText(603)] = { instanceID = 603, englishID = 'ulduar' },
	[GetRealZoneText(615)] = { instanceID = 615, englishID = 'obsidian_sanctum' },
	[GetRealZoneText(616)] = { instanceID = 616, englishID = 'eye_of_eternity' },
	[GetRealZoneText(624)] = { instanceID = 624, englishID = 'vault_of_archavon' },
	[GetRealZoneText(649)] = { instanceID = 649, englishID = 'trial_of_the_crusader' },
	[GetRealZoneText(249)] = { instanceID = 249, englishID = 'onyxias_lair' },
	[GetRealZoneText(631)] = { instanceID = 631, englishID = 'icecrown_citadel' },
	[GetRealZoneText(724)] = { instanceID = 724, englishID = 'ruby_sanctum' },

	-- Catacylsm
	[GetRealZoneText(669)] = { instanceID = 669, englishID = 'blackwing_descent' },
	[GetRealZoneText(671)] = { instanceID = 671, englishID = 'the_bastion_of_twilight' },
	[GetRealZoneText(720)] = { instanceID = 720, englishID = 'firelands' },
	[GetRealZoneText(754)] = { instanceID = 754, englishID = 'throne_of_the_four_winds' },
	[GetRealZoneText(757)] = { instanceID = 757, englishID = 'baradin_hold' },
	[GetRealZoneText(967)] = { instanceID = 967, englishID = 'dragon_soul' },

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
	[2] = {

	},
	-- EU (+ Russia)
	[3] = {
		zg = { year = 2020, month = 4, day = 13, hour = 9, min = 0, sec = 0 }, --3*24*60*60
	},
	-- TW
	[4] = {

	},
	-- CN
	[5] = {
		zg = { year = 2020, month = 4, day = 18, hour = 7, min = 0, sec = 0 },
	}
}

PermoksAccountManager.numDungeons = 16

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
	[GetRealZoneText(650)] = 650, -- Trial of the Champion
	[GetRealZoneText(632)] = 632, -- The Forge of Souls
	[GetRealZoneText(658)] = 658, -- Pit of Saron
	[GetRealZoneText(668)] = 668, -- Halls of Reflection
}

PermoksAccountManager.item = {
	-- Flasks
	[46377] = { key = 'flaskEndlessRage' },           -- Flask of Endless Rage
	[46379] = { key = 'flaskStoneblood' },            -- Flask of Stoneblood
	[46376] = { key = 'flaskFrostWyrm' },             -- Flask of Frost Wyrm
	[46378] = { key = 'flaskPureMojo' },              -- Flask of Pure Mojo
	-- Food buffs
	[43015] = { key = 'foodFishFeast' },              -- Fish Feast
	[43005] = { key = 'foodSpicedMammothTreats' },    -- Spiced Mammoth Treats
	[42999] = { key = 'foodDragonfinFilet' },         -- Dragonfin Filet
	[43000] = { key = 'foodBlackenedDragonfin' },     -- Blackened Dragonfin
	[34767] = { key = 'foodFirecrackerSalmon' },      -- Firecracker Salmon
	[34755] = { key = 'foodTenderShoveltuskSteak' },  -- Tender Shoveltusk Steak
	-- Potions
	[40211] = { key = 'potionOfSpeed' },              -- Potion of Speed
	[40212] = { key = 'potionOfWildMagic' },          -- Potion of Wild Magic
	[40093] = { key = 'potionIndestructible' },       -- Indestructible Potion
	[42545] = { key = 'potionRunicManaInjector' },    -- Runic Mana Injector
	[41166] = { key = 'potionRunicHealingInjector' }, -- Runic Healing Injector
	[33448] = { key = 'potionRunicMana' },            -- Runic Mana Potion
	[33447] = { key = 'potionRunicHealing' },         -- Runic Healing Potion
	[5634] = { key = 'potionFreeAction' },            -- Free Action Potion
	-- Engineering
	[42641] = { key = 'engiGlobalThermalSapperCharge' }, -- Global Thermal Sapper Charge
	[41119] = { key = 'engiSaroniteBomb' },           -- Saronite Bomb
	-- Others
	[47242] = { key = 'trophyOfTheCrusade' },         -- Trophy of the Crusade
	[43102] = { key = 'frozenOrb' },                  -- Frozen Orb
	[45087] = { key = 'runedOrb' },                   -- Runed Orb
	[47556] = { key = 'crusaderOrb' },                -- Crusader Orb
	[49908] = { key = 'primordialSaronite' },         -- Primordial Saronite
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

	[1135] = { name = 'The Earthen Ring' },
	[1158] = { name = 'Guardians of Hyjal' },
	[1171] = { name = 'Therazane' },
	[1172] = { name = 'Dragonmaw Clan', faction = 'Horde' },
	[1173] = { name = 'Ramkahen' },
	[1174] = { name = 'Wildhammer Clan', faction = 'Alliance' },
	[1177] = { name = 'Baradin\'s Wardens', faction = 'Alliance' },
	[1178] = { name = 'Hellscream\'s Reach', faction = 'Horde' },
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
	[391] = 0,
	[395] = 0,
	[396] = 0,
}

PermoksAccountManager.currencyCustomOptions = {
    [396] = {forceUpdate = true},
}

PermoksAccountManager.professionCDs = {
	[L['Tailoring']] = {
		cds = {
			[94743] = "Dreamcloth",
			[75141] = "Dreamcloth",
			[75142] = "Dreamcloth",
			[75144] = "Dreamcloth",
			[75145] = "Dreamcloth",
			[75146] = "Dreamcloth",
		},
		items = {
			[94743] = 54440,
			[75141] = 54440,
			[75142] = 54440,
			[75144] = 54440,
			[75145] = 54440,
			[75146] = 54440,
		},
		icon = 136249,
		num = 6
	},
	[L['Alchemy']] = {
		cds = {
			[78866] = L['Transmute: Living Elements'], -- Transmute: Living Elements
			[80243] = L['Transmute: Truegold'] -- Transmute: Truegold
		},
		items = {
			[78866] = 54464,
			[80243] = 58480
		},
		icon = 136240,
		num = 2
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
		icon = 136248,
		num = 0
	},
	[L['Skinning']] = {
		icon = 134366,
		num = 0
	},
	[L['Jewelcrafting']] = {
		cds = {
			[73478] = L['Fire Prism'] -- Fire Prism
		},
		items = {
			[73478] = 52304
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

	heroic_dungeon_dailies = {
		-- 3.3.4 Gamma Dailies
		[78753] = { questType = 'daily', log = true }, -- Threats to Azeroth
		[78752] = { questType = 'daily', log = true }, -- Titan Rune Protocol Gamma
	},

	raid_weekly = {
		-- Raids
		[24581] = { questType = 'weekly', log = true }, -- Noth the Plaguebringer Must Die!
		[24580] = { questType = 'weekly', log = true }, -- Anub'Rekhan Must Die!
		[24585] = { questType = 'weekly', log = true }, -- Flame Leviathan Must Die!
		[24587] = { questType = 'weekly', log = true }, -- Ignis the Furnace Master Must Die!
		[24582] = { questType = 'weekly', log = true }, -- Instructor Razuvious Must Die!
		[24589] = { questType = 'weekly', log = true }, -- Lord Jaraxxus Must Die!
		[24590] = { questType = 'weekly', log = true }, -- Lord Marrowgar Must Die!
		[24584] = { questType = 'weekly', log = true }, -- Malygos Must Die!
		[24583] = { questType = 'weekly', log = true }, -- Patchwerk Must Die!
		[24586] = { questType = 'weekly', log = true }, -- Razorscale Must Die!
		[24579] = { questType = 'weekly', log = true }, -- Sartharion Must Die!
		[24588] = { questType = 'weekly', log = true }, -- XT-002 Deconstructor Must Die!
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
		[12501] = { questType = 'daily', log = true },                 -- Troll Patrol
		[12502] = { questType = 'daily', log = true },                 -- Troll Patrol: Can You Dig It? (Captain Brandon - 75)
		[12509] = { questType = 'daily', log = true },                 -- Troll Patrol: Intestinal Fortitude (Captain Rupert - 250)
		[12519] = { questType = 'daily', log = true },                 -- Troll Patrol: Whatdya Want, a Medal? (Captain Grondel - 25)
		[12541] = { questType = 'daily', log = true },                 -- Troll Patrol: The Alchemist's Apprentice (Alchemist Finklestein - 75)
		[12564] = { questType = 'daily', log = true },                 -- Troll Patrol: Something for the Pain (Captain Brandon - 75)
		[12568] = { questType = 'daily', log = true },                 -- Troll Patrol: Done to Death (Captain Rupert - 75)
		[12585] = { questType = 'daily', log = true },                 -- Troll Patrol: Creature Comforts (Captain Grondel - 75)
		[12588] = { questType = 'daily', log = true },                 -- Troll Patrol: Can You Dig It? (Captain Brandon - 75)
		[12591] = { questType = 'daily', log = true },                 -- Troll Patrol: Throwing Down (Captain Rupert - 75)
		[12594] = { questType = 'daily', log = true },                 -- Troll Patrol: Couldn't Care Less (Captain Grondel - 75)
		[12604] = { questType = 'daily', log = true },                 -- Congratulations!
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
