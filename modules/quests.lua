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
	completed_world_quests = {
		label = 'Done WQs',
		type = 'worldquest',
		tooltip = true,
		customTooltip = function(...)
			PermoksAccountManager:CompletedWorldQuestsTooltip_OnEnter(...)
		end,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	korthia_dailies = {
		label = L['Korthia Dailies'],
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = function(alt_data)
			local unlocks = alt_data.questInfo.unlocks and alt_data.questInfo.unlocks.visible
			if unlocks then
				local _, unlocked = next(unlocks.korthia_five_dailies)
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
	riftbound_cache = {
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
	dailyQuestCounter = {
		label = 'Daily Quests',
		data = function(alt_data)
			return alt_data.completedDailies and
				PermoksAccountManager:CreateFractionString((alt_data.completedDailies.num or 0), 25)
		end,
		group = 'resetDaily',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
	},
	relic_gorger = {
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
		label = 'Korthia WB',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	anima_weekly = {
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
		label = L['Maw WQ'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	wrath = {
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
		label = 'Sandworn Chest',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	zereth_mortis_dailies = {
		label = 'Dailies',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 2,
		unlock = {
			key = 'zereth_mortis_three_dailies',
			charKey = 'researchInfo',
			required = 3,
		},
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	zereth_mortis_weekly = {
		label = 'Patterns',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	zereth_mortis_wqs = {
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
		label = 'ZM WB',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	jiro_cyphers = {
		label = 'Jiro Cyphers',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		required = 3,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	puzzle_caches = {
		label = 'Puzzle Caches',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		required = 5,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	dragonflight_world_boss = {
		label = L['World Boss'],
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	aiding_the_accord = {
		label = 'Aiding the Accord',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	grand_hunts = {
		label = 'Grand Hunts',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		required = 3,
		version = WOW_PROJECT_MAINLINE
	},
	marrukai_camp = {
		label = 'Maruukai Camp',
		type = 'quest',
		questType = 'biweekly',
		visibility = 'visible',
		group = 'resetBiweekly',
		required = 4,
		version = WOW_PROJECT_MAINLINE
	},
	sparks_of_life = {
		label = 'Sparks of Life',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	brackenhide_hollow_rares = {
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
		label = 'Trial of Flood',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	trial_of_elements = {
		label = 'Trial of Elements',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	trial_of_storms = {
		label = 'Trial of Storms',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	knowledge_mobs = {
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
	knowledge_weeklies_order  ={
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
		label = 'Community Feast',
		type = 'quest',
		questType = 'daily',
		visibility = 'hidden',
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	iskaara_story = {
		label = 'Iskaara Story Scroll',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	obsidian_citadel_rares = {
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
		label = 'Iskaara Dailies',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 2,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	forbidden_reach_weeklies = {
		label = 'FR Weeklies',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		required = 5,
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	forbidden_reach_elite_wqs = {
		label = 'FR WQ',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	forbidden_reach_tasks = {
		label = 'FR Dailies',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		required = 2,
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	forbidden_reach_task_picked = {
		label = 'FR Faction Picked',
		type = 'quest',
		questType = 'daily',
		visibility = 'visible',
		group = 'resetDaily',
		version = WOW_PROJECT_MAINLINE
	},
	community_feast_weekly = {
		label = 'Community Feast',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dragonbane_keep_siege = {
		label = 'Siege',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dragonbane_keep_key = {
		label = 'Citadel WQ',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dragonbane_keep_weeklies = {
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
		label = 'Show Your Mettle',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	loamm_niffen_weekly = {
		label = 'AWA: Cavern',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	researchers_under_fire_weekly = {
		label = 'Under Fire',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	zc_wb_wq = {
		label = 'Zaralek WB',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dig_maps_weeklies = {
		label = 'Sniffenseeking',
		type = 'quest',
		questType = 'weekly',
		required = 3,
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dig_maps_received_weekly = {
		label = 'Dig Maps',
		type = 'quest',
		questType = 'weekly',
		required = 2,
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	proven_weekly = {
		label = 'PVP Weekly',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	fyrak_assault = {
		label = 'Fyrak Assault',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	glimerogg_racer_dailies = {
		label = 'Glimerogg Dailies',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	zyrak_cavern_zone_events = {
		label = 'Cavern Zone Events',
		type = 'quest',
		questType = 'weekly',
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
		label = 'Time Needs Mending',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	time_rift_pod = {
		label = 'Time Rift Weekly',
		type = 'quest',
		questType = 'weekly',
		visibility = 'hidden',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dreamsurge_weekly = {
		label = 'Dreamsurge Weekly',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	superbloom = {
		label = 'Superbloom',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	ed_wb_wq = {
		label = 'Dream WB',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dream_wardens_weekly = {
		label = 'AWA: Dream',
		type = 'quest',
		questType = 'weekly',
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	dream_shipments = {
		label = 'Shipments',
		type = 'quest',
		questType = 'weekly',
		required = 2,
		visibility = 'visible',
		group = 'resetWeekly',
		version = WOW_PROJECT_MAINLINE
	},
	anniversary_wb = {
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

local function UpdateWorldQuests(charInfo, questID)
	charInfo.completedWorldQuests = charInfo.completedWorldQuests or {}
	charInfo.completedWorldQuests[questID] = true
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

local function UpdateAllHiddenQuests(charInfo)
	local self = PermoksAccountManager
	if not charInfo.questInfo then
		UpdateAllQuests(charInfo)
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
		UpdateAllQuests(charInfo)
	end

	if self.isCata then
		UpdateCataDailies(charInfo)
	end

	if C_QuestLog.IsWorldQuest(questID) then
		UpdateWorldQuests(charInfo, questID)
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

local function CreateWorldQuestString(completedWorldQuests)
	return PermoksAccountManager:GetNumCompletedQuests(completedWorldQuests)
end

local function Update(charInfo)
	UpdateAllQuests(charInfo)
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

	local module = PermoksAccountManager:AddModule(module, payload)
	module:AddCustomLabelType('worldquest', CreateWorldQuestString, true, 'completedWorldQuests')
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

function PermoksAccountManager:CompletedWorldQuestsTooltip_OnEnter(button, altData, column, key)
	if not altData or not altData.completedWorldQuests then
		return
	end

	local info = altData.completedWorldQuests

	local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 1, 'LEFT')
	button.tooltip = tooltip

	for questID, isComplete in pairs(info) do
		local name = QuestUtils_GetQuestName(questID)
		local color = "FF0000"

		if isComplete then
			color = "00FF00"
		end

		if name then
			tooltip:AddLine(string.format("|cFF%s%s|r", color, name))
		end
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
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

	local questInfo = self.quests[key]
	local professionCounter = {}
	local professionItems = {}
	local prof1, prof2 = unpack(altData.professions or {})

	if prof1 or prof2 then
		for questID, questInfoTbl in pairs(questInfo) do
			local skillLineID = questInfoTbl.skillLineID
			if skillLineID then
				if info[questID] then
					professionCounter[skillLineID] = (professionCounter[skillLineID] or 0) + 1
				end

				if (skillLineID == prof1 or skillLineID == prof2) then
					professionItems[questInfoTbl.skillLineID] = professionItems[questInfoTbl.skillLineID] or {}

					if questInfoTbl.item then
						tinsert(professionItems[questInfoTbl.skillLineID], {questID, questInfoTbl.item, info[questID]})
					end
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
