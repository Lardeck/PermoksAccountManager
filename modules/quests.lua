local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local frequencyNames = {
	[0] = 'default',
	[1] = 'daily',
	[2] = 'weekly'
}

local completedString = {
	[1] = '|cff00ff00Completed|r',
	[2] = '|cffff0000Not Completed|r'
}

local default = {
	daily = {
		visible = {},
		hidden = {}
	},
	weekly = {
		visible = {},
		hidden = {}
	},
	biweekly = {
		visible = {},
		hidden = {}
	},
	relics = {
		visible = {},
		hidden = {}
	},
	unlocks = {
		visible = {},
		hidden = {}
	}
}

local module = 'quests'
local labelRows = {
	korthia_dailies = {
		IDs = {63775,63776,63777,63778,63779,63780,63781,63782,63783,63784,63785,63786,63787,63788,63789,63790,63791,63792,63793,63794,63934,63935,63936,63937,63950,63954,63955,63956,63957,63958,63959,63960,63961,63962,63963,63964,63965,63989,64015,64016,64017,64043,64065,64070,64080,64089,64101,64103,64104,64129,64166,64194,64432},
		label = L['Korthia Dailies'],
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = function(alt_data)
			local unlocks = alt_data.questInfo.unlocks and alt_data.questInfo.unlocks.visible
			if unlocks then
				local _, unlocked = next(unlocks.korthia_five_dailies_unlocked)
				return unlocked and 4 or 3
			end
			return 3
		end,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.daily and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.visible.korthia_dailies) >= 3
		end,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	sanctum_normal_embers_trash = {
		IDs = {64610,64613,64616,64619,64622},
		hideOption = true,
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		version = WOW_PROJECT_MAINLINE,
	},
	sanctum_heroic_embers_trash = {
		IDs = {64611,64614,64617,64620,64623},
		hideOption = true,
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		version = WOW_PROJECT_MAINLINE,
	},
	transport_network_dailies = {
		IDs = {60153,60175,60188,62263,62296,62382,62453,62459,62465,62466,62606,62607,62608,62610,62611,62614,62615},
		hideOption = true,
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		version = WOW_PROJECT_MAINLINE,
	},
	korthia_five_dailies_unlocked = {
		IDs = {63727},
		hideOption = true,
		type = 'quest',
		questType = 'unlocks',
		visibility = 'visible',
		version = WOW_PROJECT_MAINLINE,
	},
	zereth_mortis_three_dailies_unlocked = {
		IDs = {65219},
		hideOption = true,
		type = 'quest',
		questType = 'unlocks',
		visibility = 'visible',
		version = WOW_PROJECT_MAINLINE,
	},
	riftbound_cache = {
		IDs = {64456,64470,64471,64472},
		label = L['Riftbound Caches'],
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		required = 4,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.daily and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.riftbound_cache) >= 4
		end,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	relic_creatures = {
		IDs = {64341,64342,64343,64344,64747,64748,64749,64750,64751,64752,64753,64754,64755,64756,64757},
		label = L['Relic Creatures'],
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		required = 15,
		plus = true,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.daily and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.relic_creatures) >= 15
		end,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	relic_gorger = {
		IDs = {64433,64434,64435,64436},
		label = L['Relic Gorger'],
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		required = 4,
		plus = true,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.daily and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.relic_gorger) >= 4
		end,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	helsworn_chest = {
		IDs = {64256},
		label = L['Helsworn Chest'],
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		plus = true,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.daily and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.helsworn_chest) >= 1
		end,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	assault_vessels = {
		IDs = {64044,64045,64055,64056,64057,64058,64059,64060},
		label = L['Assault Vessels'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		required = 4,
		tooltip = function(button, alt_data, column)
			PermoksAccountManager:QuestTooltip_OnEnter(button, alt_data, column)
		end,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.assault_vessels) >= 2
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	rift_vessels = {
		IDs = {64265,64269,64270},
		label = L['Rift Vessels'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		required = 3,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.rift_vessels) >= 3
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	adamant_vault_conduit = {
		IDs = {64347},
		label = L['AV Conduit'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.adamant_vault_conduit) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	maw_dailies = {
		IDs = {60622,60646,60732,60762,60775,60902,61075,61079,61088,61103,61104,61334,61765,62214,62234,62239,63031,63038,63039,63040,63043,63045,63047,63050,63062,63069,63072,63100,63179,63206},
		label = L['Maw Dailies'],
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 2,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.daily and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.maw_dailies) >= 2
		end,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	dungeon_quests = {
		IDs = {60242,60243,60244,60245,60246,60247,60248,60249,60250,60251,60252,60253,60254,60255,60256,60257},
		label = L['Dungeon Quests'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		required = 2,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekl and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.dungeon_quests) == 2
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	pvp_quests = {
		IDs = {62284,62285,62286,62287,62288,62289},
		label = L['PVP Quests'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		required = 2,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.pvp_quests) == 2
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	weekend_event = {
		IDs = {72719,72720,72721,72722,72723,72724,72725,72726,72727,72728,72810},
		label = L['Weekend Event'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.weekend_event) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	world_boss = {
		IDs = {61813,61814,61815,61816,64531},
		label = L['World Boss'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		isCompleteTest = true,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.world_boss) == 2
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	korthia_world_boss = {
		IDs = {64531},
		label = 'Korthia WB',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	anima_weekly = {
		IDs = {61981,61982,61983,61984},
		label = L['1k Anima'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.visible.anima_weekly) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	maw_souls = {
		IDs = {61331,61332,61333,61334,62858,62859,62860,62861,62862,62863,62864,62865,62866,62867,62868,62869},
		label = L['Return Souls'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.visible.maw_souls) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	korthia_weekly = {
		IDs = {63949},
		label = L['Korthia Weekly'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.visible.korthia_weekly) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	tormentors_weekly = {
		IDs = {63854,64122},
		label = L['Tormentors'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.tormentors_weekly) >= 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	tormentors_locations = {
		IDs = {64692,64693,64694,64695,64696,64697,64698},
		label = L['Tormentors Rep'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		required = 6,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.tormentors_locations) >= 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	maw_assault = {
		IDs = {63543,63822,63823,63824},
		label = L['Maw Assault'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		required = 2,
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.assault) >= 2
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	battle_plans = {
		IDs = {64521},
		label = L['Maw Battle Plans'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.battle_plans) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	korthia_supplies = {
		IDs = {64522},
		label = L['Korthia Supplies'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.korthia_supplies) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	containing_the_helsworn = {
		IDs = {64273},
		label = L['Maw WQ'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	wrath = {
		IDs = {63414},
		label = L['Wrath of the Jailer'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.wrath) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	hunt = {
		IDs = {63195,63198,63199,63433},
		label = L['The Hunt'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		isComplete = function(alt_data)
			return alt_data.questInfo and alt_data.questInfo.weekly and
				PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hunt) == 1
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	--- 9.2
	sandworn_chest = {
		IDs = {65611},
		label = 'Sandworn Chest',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	zereth_mortis_dailies = {
		IDs = {64579,64592,64717,64785,64854,64964,64977,65033,65072,65096,65142,65177,65226,65255,65256,65264,65265,65268,65269,65325,65326,65362,65363,65364,65445},
		label = 'Dailies',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 2,
		unlock = {
			key = 'zereth_mortis_three_dailies_unlocked',
			charKey = 'researchInfo',
			required = 3,
		},
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	zereth_mortis_weekly = {
		IDs = {65324},
		label = 'Patterns',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	zereth_mortis_wqs = {
		IDs = {64960,64974,65081,65089,65102,65115,65117,65119,65230,65232,65234,65244,65252,65262,65402,65403,65405,65406,65407,65408,65409,65410,65411,65412,65413,65414,65415,65416,65417},
		label = 'ZM WQs',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		required = 2,
		unlock = {
			key = 'zereth_mortis_three_wqs',
			charKey = 'researchInfo',
			required = 3,
		},
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	zereth_mortis_world_boss = {
		IDs = {65143},
		label = 'ZM WB',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	jiro_cyphers = {
		IDs = {65144,65166,65167},
		label = 'Jiro Cyphers',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	puzzle_caches = {
		IDs = {64972,65091,65092,65093,65094,65314,65315,65316,65317,65318,65319,65320,65321,65322,65323},
		label = 'Puzzle Caches',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		required = 5,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	dragonflight_world_boss = {
		IDs = {69927,69928,69929,69930},
		label = L['World Boss'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	aiding_the_accord = {
		IDs = {70750,72068,72373,72374,72375,75259,75859,75860,75861,77254,77976,78446,78447,78861,80385,80386,80388,80389},
		label = 'Aiding the Accord',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	grand_hunts = {
		IDs = {70906,71136,71137},
		label = 'Grand Hunts',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		required = 3,
		version = WOW_PROJECT_MAINLINE
	},
	marrukai_camp = {
		IDs = {65784,65789,65792,65796,65798,66698,66711,67034,67039,67222,67605,70210,70279,70299,70352,70701,70990,71241},
		label = 'Maruukai Camp',
		type = 'quest',
		questType = 'biweekly',
		visibility = 'visible',
		group = 'resetBiweekly',
		required = 4,
		version = WOW_PROJECT_MAINLINE
	},
	sparks_of_life = {
		IDs = {72646,72647,72648,72649,74871,75305,78097},
		label = 'Sparks of Life',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	brackenhide_hollow_rares = {
		IDs = {73985,73996,74004,74032},
		label = 'Brackenhide Rares',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		group = 'resetDaily',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 4,
		version = WOW_PROJECT_MAINLINE
	},
	trial_of_flood = {
		IDs = {71033},
		label = 'Trial of Flood',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	trial_of_elements = {
		IDs = {71995},
		label = 'Trial of Elements',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	trial_of_storms = {
		IDs = {74567},
		label = 'Trial of Storms',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	knowledge_mobs = {
		IDs = {70381,70383,70384,70385,70386,70389,70504,70511,70512,70513,70514,70515,70516,70517,70518,70519,70520,70521,70522,70523,70524,70525,71857,71858,71859,71860,71861,71864,72160,72161,72162,72163,72164,72165,73136,73138,73153,73161,73163,73165,73166,73168},
		customData = {
			professionToQuest = {
				[164] = {70512, 70513, 73161}, -- Blacksmithing
				[165] = {70522, 70523, 73138}, -- Leatherworking
				[171] = {70504, 70511, 73166}, -- Alchemy
				[182] = {71857, 71858, 71859, 71860, 71861, 71864}, -- Herbalism
				[186] = {72160, 72161, 72162, 72163, 72164, 72165}, -- Mining
				[197] = {70524, 70525, 73153}, -- Tailoring
				[202] = {70516, 70517, 73165}, -- Engineering
				[333] = {70514, 70515, 73136}, -- Enchanting
				[393] = {70381, 70383, 70384, 70385, 70386, 70389}, -- Skinning
				[755] = {70520, 70521, 73168}, -- Jewelcrafting
				[773] = {70518, 70519, 73163}, -- Inscription
			},
			questToItem = {
				[70512] = 198965, -- Blacksmithing
				[70513] = 198966, -- Blacksmithing
				[73161] = 204230, -- Blacksmithing
				[70522] = 198975, -- Leatherworking
				[70523] = 198976, -- Leatherworking
				[73138] = 204232, -- Leatherworking
				[70504] = 198963, -- Alchemy
				[70511] = 198964, -- Alchemy
				[73166] = 204226, -- Alchemy
				[70524] = 198977, -- Tailoring
				[70525] = 198978, -- Tailoring
				[73153] = 204225, -- Tailoring
				[70516] = 198969, -- Engineering
				[70517] = 198970, -- Engineering
				[73165] = 204227, -- Engineering
				[70514] = 198967, -- Enchanting
				[70515] = 198968, -- Enchanting
				[73136] = 204224, -- Enchanting
				[70520] = 198973, -- Jewelcrafting
				[70521] = 198974, -- Jewelcrafting
				[73168] = 204222, -- Jewelcrafting
				[70518] = 198971, -- Inscription
				[70519] = 198978, -- Inscription
				[73163] = 204229, -- Inscription
			},
		},
		label = 'Gather Knowledge',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:KnowledgeTooltip_OnEnter(...)
		end,
		required = 6,
		tooltipRequired = 3,
		professionOffset = {
			[182] = 4,
			[186] = 4,
			[393] = 4,
		},
		professionRequired = {
			[182] = 6,
			[186] = 6,
			[393] = 6,
		},
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	knowledge_scout_packs = {
		IDs = {66373,66374,66375,66376,66377,66378,66379,66380,66381,66382,66384,66385,66386,66387,66388,66389},
		customData = {
			professionToQuest = {
				[164] = {66381, 66382}, -- Blacksmithing
				[165] = {66384, 66385}, -- Leatherworking
				[171] = {66373, 66374}, -- Alchemy
				[197] = {66386, 66387}, -- Tailoring
				[202] = {66379, 66380}, -- Engineering
				[333] = {66377, 66378}, -- Enchanting
				[755] = {66388, 66389}, -- Jewelcrafting
				[773] = {66375, 66376}, -- Inscription
			},
			questToItem = {
				[66381] = 192131, -- Blacksmithing
				[66382] = 192132, -- Blacksmithing
				[66384] = 193910, -- Leatherworking
				[66385] = 193913, -- Leatherworking
				[66373] = 193891, -- Alchemy
				[66374] = 193897, -- Alchemy
				[66386] = 193898, -- Tailoring
				[66387] = 193899, -- Tailoring
				[66379] = 193902, -- Engineering
				[66380] = 193903, -- Engineering
				[66377] = 193900, -- Enchanting
				[66378] = 193901, -- Enchanting
				[66388] = 193909, -- Jewelcrafting
				[66389] = 193907, -- Jewelcrafting
				[66375] = 193904, -- Inscription
				[66376] = 193905, -- Inscription
			}
		},
		label = 'Treasure Knowledge',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:KnowledgeTooltip_OnEnter(...)
		end,
		required = 4,
		professionOffset = {
			[182] = -2,
			[186] = -2,
			[393] = -2,
		},
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	knowledge_treatise = {
		IDs = {74105,74106,74107,74108,74109,74110,74111,74112,74113,74114,74115},
		customData = {
			professionToQuest = {
				[164] = {74109}, -- Blacksmithing
				[165] = {74113}, -- Leatherworking
				[171] = {74108}, -- Alchemy
				[182] = {74107}, -- Herbalism
				[186] = {74106}, -- Mining
				[197] = {74115}, -- Tailoring
				[202] = {74111}, -- Engineering
				[333] = {74110}, -- Enchanting
				[393] = {74114}, -- Skinning
				[755] = {74112}, -- Jewelcrafting
				[773] = {74105}, -- Inscription
			},
		},
		label = 'Treatise Knowledge',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:KnowledgeTooltip_OnEnter(...)
		end,
		tooltipRequired = 1,
		required = 2,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	knowledge_weeklies_craft = {
		IDs = {70211,70233,70234,70235,70530,70531,70532,70533,70539,70540,70545,70557,70558,70559,70560,70561,70562,70563,70564,70565,70567,70568,70569,70571,70572,70582,70586,70587,72155,72172,72173,72175},
		customData = {
			professionToQuest = {
				[164] = {70211, 70233, 70234, 70235}, -- Blacksmithing
				[165] = {70567, 70568, 70569, 70571}, -- Leatherworking
				[171] = {70531, 70532, 70533, 70530}, -- Alchemy
				[197] = {70572, 70582, 70586, 70587}, -- Tailoring
				[202] = {70540, 70545, 70557, 70539}, -- Engineering
				[333] = {72155, 72172, 72173, 72175}, -- Enchanting
				[755] = {70562, 70563, 70564, 70565}, -- Jewelcrafting
				[773] = {70558, 70559, 70560, 70561}, -- Inscription
			},
		},
		label = 'Crafting Quests',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 2,
		professionOffset = {
			[182] = -1,
			[186] = -1,
			[393] = -1,
		},
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	knowledge_weeklies_loot = {
		IDs = {66363,66364,66516,66517,66884,66890,66891,66897,66899,66900,66935,66937,66938,66940,66941,66942,66943,66944,66945,66949,66950,66951,66952,66953,70613,70614,70615,70616,70617,70618,70619,70620,72156,72157,72158,72159,72396,72398,72407,72410,72423,72427,72428,72438,73165,75148,75149,75150,75354,75362,75363,75368,75371,75407,75569,75573,75575,75600,75602,75608,75865,77889,77891,77892,77910,77912,77914,77932,77933,77935,77936,77937,77938,77945,77946,77947,77949},
		customData = {
			professionToQuest = {
				[164] = {66517, 66941, 66897, 72398, 75148, 75569, 77935, 77936}, -- Blacksmithing
				[165] = {66363, 66364, 66951, 72407, 75354, 75368, 77945, 77946}, -- Leatherworking
				[171] = {66937, 66938, 66940, 72427, 75363, 75371, 77932, 77933}, -- Alchemy
				[182] = {70613, 70614, 70615, 70616}, -- Herbalism
				[186] = {70617, 70618, 72156, 72157}, -- Mining
				[197] = {66899, 66952, 66953, 72410, 75407, 75600, 77947, 77949}, -- Tailoring
				[202] = {66890, 66890, 66942, 72396, 73165, 75575, 75608, 77891, 77938}, -- Engineering :sus:
				[333] = {66884, 66900, 66935, 72423, 75150, 75865, 77910, 77937}, -- Enchanting
				[393] = {70619, 70620, 72158, 72159}, -- Skinning
				[755] = {66516, 66949, 66950, 72428, 75362, 75602, 77892, 77912}, -- Jewelcrafting
				[773] = {66943, 66944, 66945, 72438, 75149, 75573, 77889, 77914}, -- Inscription
			},
		},
		label = 'Loot Quests',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 2,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	knowledge_weeklies_order = {
		IDs = {70589,70591,70592,70593,70594,70595},
		customData = {
			professionToQuest = {
				[164] = {70589}, -- Blacksmithing
				[165] = {70594}, -- Leatherworking
				[197] = {70595}, -- Tailoring
				[202] = {70591}, -- Engineering
				[755] = {70593}, -- Jewelcrafting
				[773] = {70592}, -- Inscription
			},
		},
		label = 'Crafting Order Quests',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 2,
		professionOffset = {
			[171] = -1,
			[182] = -1,
			[186] = -1,
			[333] = -1,
			[393] = -1,
		},
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	community_feast = {
		IDs = {74097},
		label = 'Community Feast',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	iskaara_story = {
		IDs = {72291},
		label = 'Iskaara Story Scroll',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	obsidian_citadel_rares = {
		IDs = {72127,73072,74040,74042,74043,74052,74054,74067},
		label = 'Obsidian Citadel Rares',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 8,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	fish_turnins_df = {
		IDs = {72823,72824,72825,72826,72827,72828},
		label = 'Fish Turn Ins',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 6,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	tyrhold_rares = {
		IDs = {74055},
		label = 'Tyrhold Rare',
		type = 'quest',
		questType = 'daily',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		visibility = 'hidden',
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	iskaara_fishing_dailies = {
		IDs = {70438,70450,71191,71194,72069,72075},
		label = 'Iskaara Dailies',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 2,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	forbidden_reach_weeklies = {
		IDs = {72952,73140,73141,73142,73179,73190,73191,73194,73715,74282,74284,74293,74379,75024,75025},
		label = 'FR Weeklies',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		required = 5,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	forbidden_reach_elite_wqs = {
		IDs = {75257},
		label = 'FR WQ',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	forbidden_reach_tasks = {
		IDs = {74117,74118,74119,74389,74390,74391,75261,75263},
		label = 'FR Dailies',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 2,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	forbidden_reach_task_picked = {
		IDs = {74908,74909,74910,74911},
		label = 'FR Faction Picked',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	community_feast_weekly = {
		IDs = {70893},
		label = 'Community Feast',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dragonbane_keep_siege = {
		IDs = {70866},
		label = 'Siege',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dragonbane_keep_key = {
		IDs = {66133,66805},
		label = 'Citadel WQ',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dragonbane_keep_weeklies = {
		IDs = {65842,66103,66308,66321,66326,66445,66449,66633,66926,67051,67099,67142,69918,70848,72447,72448},
		label = 'Citadel Weeklies',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 6,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	show_your_mettle = {
		IDs = {70221},
		label = 'Show Your Mettle',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	loamm_niffen_weekly = {
		IDs = {75665},
		label = 'AWA: Cavern',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	researchers_under_fire_weekly = {
		IDs = {75627,75628,75629,75630},
		label = 'Under Fire',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	zc_wb_wq = {
		IDs = {74892},
		label = 'Zaralek WB',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dig_maps_weeklies = {
		IDs = {75747,75748,75749},
		label = 'Sniffenseeking',
		type = 'quest',
		questType = 'weekly',
		required = 3,
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dig_maps_received_weekly = {
		IDs = {75665,76077},
		label = 'Dig Maps',
		type = 'quest',
		questType = 'weekly',
		required = 2,
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	proven_weekly = {
		IDs = {72166,72167,72168,72169,72170,72171},
		label = 'PVP Weekly',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	fyrak_assault = {
		IDs = {75467},
		label = 'Fyrak Assault',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	glimerogg_racer_dailies = {
		IDs = {74514,74515,74516,74517,74518,74519,74520},
		label = 'Glimerogg Dailies',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	zyrak_cavern_zone_events = {
		IDs = {
			75664, 75156, 75471, 75222, 75370, 75441, 75611,
			75624, 75612, 75454, 75455, 75450, 75451, 75461,
			74352, 75478, 75494, 75705
		},
		questType = 'weekly',
		forceUpdate = true,
		label = 'Cavern Zone Events',
		type = 'quest',
		visibility = 'hidden',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		showAll = true,
		required = 18,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	time_rift = {
		IDs = {77236},
		label = 'Time Needs Mending',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	time_rift_pod = {
		IDs = {77836},
		label = 'Time Rift Weekly',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dreamsurge_weekly = {
		IDs = {77251},
		label = 'Dreamsurge Weekly',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	superbloom = {
		IDs = {78319},
		label = 'Superbloom',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	ed_wb_wq = {
		IDs = {76367},
		label = 'Dream WB',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dream_wardens_weekly = {
		IDs = {78444},
		label = 'AWA: Dream',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dream_shipments = {
		IDs = {78427,78428},
		label = 'Shipments',
		type = 'quest',
		questType = 'weekly',
		required = 2,
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	anniversary_wb = {
		IDs = {47461,47462,47463,60214},
		label = 'Anniv. WBs.',
		type = 'quest',
		questType = 'daily',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 4,
		visibility = 'hidden',
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	-- 11.0 PREPATCH
	radiant_echoes_prepatch_weeklies = {
		IDs = {78938,82676,82689},
		label = 'Radiant Echoes Weeklies',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedQuestsTooltip_OnEnter(...)
		end,
		required = 3,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},

	--wotlk
	dailyQuestCounter = {
		label = 'Daily Quests',
		data = function(alt_data)
			return alt_data.completedDailies and
				PermoksAccountManager:CreateFractionString((alt_data.completedDailies.num or 0), 25)
		end,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
	},
	general_dailies = {
		label = 'General',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	general_horde_dailies = {
		label = 'General Horde',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	general_alliance_dailies = {
		label = 'General Alliance',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	heroic_dungeon_dailies = {
		label = 'Heroic Dungeon',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 2,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	raid_weekly = {
		label = 'Raid Weekly',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		required = 1,
		group = 'resetWeekly',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	argent_crusade_dailies = {
		label = 'Argent Crusade',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 7,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	the_oracles_dailies = {
		label = 'Orcales',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	frenzyheart_tribe_dailies = {
		label = 'Frenzyheart',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	knights_of_the_ebon_blade_dailies = {
		label = 'Ebon Blade',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	the_sons_of_hodir_dailies = {
		label = 'Sons of Hodir',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	valiance_expedition_dailies = {
		label = 'Expedition',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	explorers_league_dailies = {
		label = 'Explorers League',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 1,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	the_frostborn_dailies = {
		label = 'Frostborn',
		type = 'quest',
		questType = 'daily',
		tooltip = true,
		customTooltip = function(button, ...)
			PermoksAccountManager:WOTLKDailyQuest_OnEnter(button, ...)
		end,
		visibility = 'visible',
		required = 1,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	warsong_offensive_dailies = {
		label = 'Offensive',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	wotlk_cooking_dailies = {
		label = 'Cooking',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 1,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	wotlk_fishing_dailies = {
		label = 'Fishing',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 1,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
	wotlk_jewelcrafting_dailies = {
		label = 'Jewelcrafting',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 1,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
	},
}

local function UpdateCataDailies(charInfo)
	charInfo.completedDailies = charInfo.completedDailies or { num = 0 }
	charInfo.completedDailies.num = GetDailyQuestsCompleted()
end

local function GetQuestInfo(questLogIndex)
	if not PermoksAccountManager.isRetail then
		local title, _, _, isHeader, _, _, frequency, questID, _, _, _, _, _, _, _, isHidden = GetQuestLogTitle(questLogIndex)
		return { title = title, isHeader = isHeader, frequency = frequency, isHidden = isHidden, questID = questID }
	else
		return C_QuestLog.GetInfo and C_QuestLog.GetInfo(questLogIndex)
	end
end

local function UpdateAllQuests(charInfo)
	local self = PermoksAccountManager
	charInfo.questInfo = charInfo.questInfo or default

	local covenant = self.isRetail and (charInfo.covenant or C_Covenants.GetActiveCovenantID())
	local questInfo = charInfo.questInfo
	for key, quests in pairs(self.quests) do
		for questID, info in pairs(quests) do
			local visibleType = info.log and 'visible' or 'hidden'

			questInfo[info.questType] = questInfo[info.questType] or {}
			questInfo[info.questType][visibleType] = questInfo[info.questType][visibleType] or {}
			questInfo[info.questType][visibleType][key] = questInfo[info.questType][visibleType][key] or {}
			local currentQuestInfo = questInfo[info.questType][visibleType][key]
			local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)

			if not self.isBC then
				if info.covenant and covenant == info.covenant then
					local sanctumTier
					if info.sanctum and charInfo.sanctumInfo then
						sanctumTier = charInfo.sanctumInfo[info.sanctum] and charInfo.sanctumInfo[info.sanctum].tier or 0
						questInfo['max' .. key] = max(1, sanctumTier)
					end

					if not info.sanctum or (sanctumTier and sanctumTier >= info.minSanctumTier) then
						currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil
					end
				elseif not info.covenant then
					currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil
				end
			else
				currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil
			end
		end
	end
end

local function UpdateAllQuestsNew(charInfo)
	local self = PermoksAccountManager
	charInfo.questInfo = charInfo.questInfo or default

	local covenant = self.isRetail and (charInfo.covenant or C_Covenants.GetActiveCovenantID())
	local questInfo = charInfo.questInfo
	for key, info in pairs(self.quest) do
		for _, questID in ipairs(info.IDs) do
			local questType = info.questType
			local visibility = info.visibility

			questInfo[questType] = questInfo[questType] or {}
			questInfo[questType][visibility] = questInfo[questType][visibility] or {}
			questInfo[questType][visibility][key] = questInfo[questType][visibility][key] or {}
			local currentQuestInfo = questInfo[questType][visibility][key]
			local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)

			if not self.isBC then
				if info.covenant and covenant == info.covenant then
					local sanctumTier
					if info.sanctum and charInfo.sanctumInfo then
						sanctumTier = charInfo.sanctumInfo[info.sanctum] and charInfo.sanctumInfo[info.sanctum].tier or 0
						questInfo['max' .. key] = max(1, sanctumTier)
					end

					if not info.sanctum or (sanctumTier and sanctumTier >= info.minSanctumTier) then
						currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil
					end
				elseif not info.covenant then
					currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil
				end
			else
				currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil
			end
		end
	end
end

local function UpdateAllHiddenQuests(charInfo)
	local self = PermoksAccountManager
	if not charInfo.questInfo then
		UpdateAllQuestsNew(charInfo)
	end
	self:Debug('Update Hidden Quests')

	for questType, keys in pairs(charInfo.questInfo) do
		if type(keys) == 'table' and keys.hidden then
			for key, _ in pairs(keys.hidden) do
				if self.quests[key] then
					for questID, questData in pairs(self.quests[key]) do
						local isComplete = charInfo.questInfo[questType].hidden[key][questID]
						if not isComplete or questData.forceUpdate then
							isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)
						end
						charInfo.questInfo[questType].hidden[key][questID] = isComplete or nil
					end
				end
			end
		end
	end
end

local HiddenQuestTimer
do
	local timer
	function HiddenQuestTimer(charInfo)
		if not timer then
			local function HiddenQuestTimerCallback()
				UpdateAllHiddenQuests(charInfo)
				timer = nil
			end

			timer = C_Timer.NewTimer(1, HiddenQuestTimerCallback)
		end
	end
end

local function AddQuest(_, questID, questLogIndex, questInfo)
	local self = PermoksAccountManager
	local questLogIndex = questLogIndex or
		(self.isBC and GetQuestLogIndexByID(questID) or C_QuestLog.GetLogIndexForQuestID(questID))
	if questLogIndex then
		local questInfo = questInfo or GetQuestInfo(questLogIndex)
		self.db.global.quests[questID] = { frequency = questInfo.frequency, name = questInfo.title }
	end
end

local function RemoveQuest(_, questID)
	if questID then
		PermoksAccountManager.db.global.quests[questID] = nil
	end
end

local function UpdateCurrentlyActiveQuests(charInfo)
	local numQuests = C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetNumQuestLogEntries() or GetNumQuestLogEntries()
	local info
	for questLogIndex = 1, numQuests do
		info = GetQuestInfo(questLogIndex)
		if info and not info.isHeader and not info.isHidden then
			AddQuest(charInfo, info.questID, questLogIndex, info)
		end
	end
end

local function UpdateQuest(charInfo, questID)
	if not questID then
		return
	end

	local self = PermoksAccountManager
	if not charInfo.questInfo then
		UpdateAllQuestsNew(charInfo)
	end

	if self.isCata then
		UpdateCataDailies(charInfo)
	end

	local key = self:FindQuestKeyByQuestID(questID)
	if not key then
		return
	end

	local questInfo = self.quests[key][questID]
	local questType, visibility = questInfo.questType, questInfo.log and 'visible' or 'hidden'
	self:Debug('Update', questType, visibility, key, questID)
	if questType and visibility and key and charInfo.questInfo[questType][visibility][key] then
		if self.isCata and questType == 'daily' then
			UpdateCataDailies(charInfo)
		end

		charInfo.questInfo[questType][visibility][key][questID] = true
		RemoveQuest(charInfo, questID)
	end
end

local function Update(charInfo)
	UpdateAllQuestsNew(charInfo)
	UpdateCurrentlyActiveQuests(charInfo)
	UpdateCataDailies(charInfo)
end

do
	local payload = {
		update = Update,
		labels = labelRows,
		events = {
			['QUEST_ACCEPTED'] = AddQuest,
			['QUEST_TURNED_IN'] = UpdateQuest,
			['QUEST_REMOVED'] = RemoveQuest,
			['QUEST_LOG_UPDATE'] = {HiddenQuestTimer}, 
		},
		share = {
			[HiddenQuestTimer] = 'questInfo',
			[UpdateQuest] = 'questInfo'
		}
	}

	if PermoksAccountManager.isCata then
		tinsert(payload.events.QUEST_LOG_UPDATE, UpdateCataDailies)
	end

	PermoksAccountManager:AddModule(module, payload)
end

function PermoksAccountManager:FindQuestKeyByQuestID(questID)
	for key, quests in pairs(self.quests) do
		if quests[questID] then
			return key
		end
	end
end

function PermoksAccountManager:FindQuestByQuestID(questID)
	local resetKey, key
	if self.db.global.quests[questID] then
		local questInfo = self.db.global.quests[questID]
		resetKey = frequencyNames[questInfo.frequency]
		if self.quests[resetKey] then
			key = self.quests[resetKey][questID]
		end
	else
		for reset, quests in pairs(self.quests) do
			if quests[questID] then
				return reset, quests[questID].key
			end
		end
	end

	return resetKey, key
end

function PermoksAccountManager:GetNumCompletedQuests(questInfo)
	if not questInfo then
		return 0
	end
	local numCompleted = 0
	for _, questCompleted in pairs(questInfo) do
		numCompleted = questCompleted and numCompleted + 1 or numCompleted
	end

	return numCompleted
end

function PermoksAccountManager:CreateQuestString(questInfo, numDesired, replaceWithPlus)
	if not questInfo or not numDesired then
		return
	end
	local numCompleted = type(questInfo) == 'table' and self:GetNumCompletedQuests(questInfo) or questInfo
	if replaceWithPlus and numCompleted >= numDesired then
		return string.format('|cff00ff00%s|r', self.db.global.options.questCompletionString)
	else
		return self:CreateFractionString(numCompleted, numDesired)
	end
end

function PermoksAccountManager:QuestTooltip_OnEnter(button, alt_data, column)
	if not alt_data or not alt_data.questInfo or not alt_data.questInfo[column.reset] or
		not alt_data.questInfo[column.reset][column.visibility] then
		return
	end
	local info = alt_data.questInfo[column.questType][column.visibility][column.key]
	if not info then
		return
	end

	local quests = self.quests[column.key]
	local completedByName = {}
	for questId, isComplete in pairs(info) do
		if isComplete and quests[questId] and quests[questId].name then
			completedByName[quests[questId].name] = completedByName[quests[questId].name] or
				{ num = 0, total = quests[questId].total }
			completedByName[quests[questId].name].num = completedByName[quests[questId].name].num + 1
		end
	end

	if not next(completedByName) then
		return
	end
	local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
	button.tooltip = tooltip
	for name, completionInfo in pairs(completedByName) do
		tooltip:AddLine(name, self:CreateFractionString(completionInfo.num, completionInfo.total))
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end

function PermoksAccountManager:CompletedQuestsTooltip_OnEnter(button, altData, column, key)
	if not altData or not altData.questInfo or not altData.questInfo[column.questType] or
		not altData.questInfo[column.questType][column.visibility] then
		return
	end
	local info = altData.questInfo[column.questType][column.visibility][column.key or key]
	if not info then
		return
	end

	if next(info) then
		local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 1, 'LEFT')
		button.tooltip = tooltip

		local questInfo = self.quests[key]

		if column.showAll then
			for questID in pairs(questInfo) do
				local name
				local color = "FF0000"
				if questInfo and questInfo[questID].name then
					name = questInfo[questID].name
				else
					name = QuestUtils_GetQuestName(questID)
				end
				if info[questID] then
					color = "00FF00"
				end

				if name then
					tooltip:AddLine(string.format("|cFF%s%s|r", color, name))
				end
			end
		else
			for questID, isComplete in pairs(info) do
				local name
				local color = "FF0000"
				if questInfo and questInfo[questID].name then
					name = questInfo[questID].name
				else
					name = QuestUtils_GetQuestName(questID)
				end
				if isComplete then
					color = "00FF00"
				end

				if name then
					tooltip:AddLine(string.format("|cFF%s%s|r", color, name))
				end
			end
		end

		tooltip:SmartAnchorTo(button)
		tooltip:Show()
	end
end

function PermoksAccountManager:KnowledgeTooltip_OnEnter(button, altData, column, key)
	if not altData or not altData.questInfo or not altData.questInfo[column.questType] or
		not altData.questInfo[column.questType][column.visibility] then
		return
	end
	local info = altData.questInfo[column.questType][column.visibility][column.key or key]
	if not info then
		return
	end

	local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 3, 'LEFT', 'RIGHT', 'RIGHT')
	button.tooltip = tooltip

	local professionCounter = {}
	local professionItems = {}
	local prof1, prof2 = unpack(altData.professions or {})

	local professionInfo = column.customData
	if prof1 and professionInfo then
		if professionInfo.professionToQuest and professionInfo.professionToQuest[prof1] then
			for _, questID in ipairs(professionInfo.professionToQuest[prof1]) do
				if info[questID] then
					professionCounter[prof1] = (professionCounter[prof1] or 0) + 1
				end

				if professionInfo.questToItem and professionInfo.questToItem[questID] then
					professionItems[prof1] = professionItems[prof1] or {}
					tinsert(professionItems[prof1], {questID, professionInfo.questToItem[questID], info[questID]})
				end
			end
		end
	end

	if prof2 and professionInfo then
		if professionInfo.professionToQuest and professionInfo.professionToQuest[prof2] then
			for _, questID in ipairs(professionInfo.professionToQuest[prof2]) do
				if info[questID] then
					professionCounter[prof2] = (professionCounter[prof2] or 0) + 1
				end

				if professionInfo.questToItem and professionInfo.questToItem[questID] then
					professionItems[prof2] = professionItems[prof2] or {}
					tinsert(professionItems[prof2], {questID, professionInfo.questToItem[questID], info[questID]})
				end
			end
		end
	end

	local professioIndex = 1
	for skillLineID, info in pairs(professionItems) do
		if #info > 0 and professioIndex == 2 then
			tooltip:AddLine(" ")
		end

		local counter = professionCounter[skillLineID] or 0
		local professionName = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineID).professionName
		local maximum = column.professionRequired and column.professionRequired[skillLineID] or column.tooltipRequired or 2
		tooltip:AddLine(string.format('%s (%s)', professionName, self:CreateFractionString(counter, maximum)))

		if #info > 0 then
			tooltip:AddSeparator(1)
			for _, itemInfo in ipairs(info) do
				local questID, itemID, isComplete = unpack(itemInfo)
				local item = Item:CreateFromItemID(itemID)
				if item:IsItemDataCached() then
					tooltip:AddLine(string.format('%s%s', CreateSimpleTextureMarkup(item:GetItemIcon()), item:GetItemLink()), string.format("(%d)", questID), isComplete and completedString[1] or completedString[2])
				else
					local y, x = tooltip:AddLine()
					item:ContinueOnItemLoad(function()
						if tooltip:IsAcquiredBy(addonName .. 'Tooltip') then
							tooltip:SetCell(y, 1, string.format('%s%s', CreateSimpleTextureMarkup(item:GetItemIcon()), item:GetItemLink()))
							tooltip:SetCell(y, 2, string.format("(%d)", questID))
							tooltip:SetCell(y, 3, isComplete and completedString[1] or completedString[2])
						end
					end)
				end
			end
		end

		professioIndex = professioIndex + 1 
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end


function PermoksAccountManager:WOTLKDailyQuest_OnEnter(button, altData, labelRow, labelIdentifier)
	if (not altData or not altData.questInfo or not altData.questInfo[labelRow.questType]) or not labelRow or
		not labelIdentifier then
		return
	end

	local info = altData[labelRow.questType][labelRow.visibility] and
		altData[labelRow.questType][labelRow.visibility][labelIdentifier]
	if not info then return end

	local quests = self.quests[labelIdentifier]
	if not quests then return end

	local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
	button.tooltip = tooltip
	for name, completionInfo in pairs(completedByName) do
		tooltip:AddLine(name, self:CreateFractionString(completionInfo.num, completionInfo.total))
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end
