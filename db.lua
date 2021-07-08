local addonName, AltManager = ...
local locale = GetLocale()

local default_categories = {
	general = {
		order = 0,
		name = "General",
		childs = {"characterName", "ilevel", "gold", "weekly_key", "mplus_score", "keystone", "soul_cinders", 
		"soul_ash", "valor", "stygian_ember", "stygia", "cataloged_research", "tower_knowledge", "deaths_advance", "archivists"},
		childOrder = {characterName = 1, ilevel = 2, gold = 3, weekly_key = 4, mplus_score = 5, keystone = 6, soul_cinders = 7, 
		soul_ash = 8, valor = 9, stygian_ember = 10, stygia = 11, cataloged_research = 12, tower_knowledge = 13, deaths_advance = 14, archivists = 15},
		hideToggle = true,
		enabled = true,
	},
	currentdaily = {
		order = 2,
		name = "Daily",
		childs = {"korthia_dailies", "relic_creatures", "riftbound_cache", "helsworn_chest"},
		childOrder = {korthia_dailies = 1, relic_creatures = 2, riftbound_cache = 3, helsworn_chest = 4},
		enabled = true,
	},
	currentweekly = {
		order = 3,
		name = "(Bi)Weekly",
		childs = {"korthia_weekly", "anima_weekly", "maw_assault", "assault_vessels", "rift_vessels", "separator1", "battle_plans", "korthia_supplies", "containing_the_helsworn", "tormentors_weekly", "tormentors_locations",	
		"separator2", "torghast_layer", "world_boss", "contract"},
		childOrder = {korthia_weekly = 1, anima_weekly = 2, maw_assault = 3, assault_vessels = 4, rift_vessels = 5, separator1 = 10, battle_plans = 11, korthia_supplies = 12, containing_the_helsworn = 13, tormentors_weekly = 14, tormentors_locations = 15, 
		separator2 = 20, torghast_layer = 21, world_boss = 22, contract = 23},
		enabled = true,
	},
	vault = {
		order = 4,
		name = "Vault",
		childs = {"great_vault_mplus", "great_vault_raid", "great_vault_pvp"},
		childOrder = {great_vault_mplus = 1, great_vault_raid = 2, great_vault_pvp = 3},
		enabled = true,
	},
	old =  {
		order = 5,
		name = "Old",
		childs = {"callings", "maw_dailies", "sanctum_quests", "separator1", "mythics_done", "dungeon_quests", "pvp_quests", "weekend_event", 
		"separator2", "maw_souls", "wrath", "hunt"},
		childOrder = {callings = 1, maw_dailies = 2, sanctum_quests = 3, separator1 = 10, mythics_done = 11, dungeon_quests = 12, pvp_quests = 13, weekend_event = 14,
		separator2 = 20, maw_souls = 21, wrath = 22, hunt = 23},
		enabled = true,
	},
	reputation = {
		order = 6,
		name = "Reputation",
		childs = {"archivists", "deaths_advance", "venari", "ascended", "wild_hunt", "undying_army", "court_of_harvesters", },
		childOrder = {archivists = 1, deaths_advance = 2, venari = 3, ascended = 4, wild_hunt = 5, undying_army = 6, court_of_harvesters = 7, },
		enabled = true,
	},
	raid = {
		order = 7,
		name = "Raid",
		childs = {"nathria", "sanctum_of_domination"},
		childOrder = {nathria = 1, sanctum_of_domination = 2},
		enabled = true,
	},
	sanctum = {
		order = 8,
		name = "Sanctum",
		childs = {"reservoir_anima", "renown", "redeemed_soul", "separator1", "transport_network", "anima_conductor", "command_table", "sanctum_unique"},
		childOrder = {reservoir_anima = 1, renown = 2, redeemed_soul = 3, separator1 = 4, transport_network = 5, anima_conductor = 6, command_table = 7, sanctum_unique = 8},
		enabled = true,
	},
	pvp = {
		order = 9,
		name = "PVP",
		childs = {"conquest", "honor", "arenaRating2v2", "arenaRating3v3", "rbgRating"},
		childOrder = {conquest = 1, honor = 2, arenaRating2v2 = 3, arenaRating3v3 = 4, rbgRating = 5},
		enabled = true,
	},
	items = {
		order = 10,
		name = "Items",
		childs = {"flask", "foodHaste", "augmentRune", "armorKit", "oilHeal", "oilDPS", "potHP", "drum", "potManaInstant", "potManaChannel", "tome"},
		childOrder = {flask = 1, foodHaste = 2, augmentRune = 3, armorKit = 4, oilHeal = 5, oilDPS = 6, potHP = 7, drum = 8, potManaInstant = 9, potManaChannel = 10, tome = 11},
		enabled = false
	}
}

AltManager.groups = {
	currency = {
		label = "Currency",
	},
	resetDaily = {
		label = "Daily Reset",
	},
	resetWeekly = {
		label = "Weekly Reset",
	},
	vault = {
		label = "Vault",
	},
	torghast = {
		label = "Torghast",
	},
	dungeons = {
		label = "Dungeons",
	},
	raids = {
		label = "Raids",
	},
	reputation = {
		label = "Reputation",
	},
	buff = {
		label = "Buff",
	},
	sanctum = {
		label = "Sanctum",
	},
	separator = {
		label = "Separator",
	},
	item = {
		label = "Items",
	},
	pvp = {
		label = "PVP",
	},
	onetime = {
		label = "ETC",
	}
}

AltManager.groupOrder = {"separator", "currency", "resetDaily", "resetWeekly", "vault", "torghast", "dungeons", "raids", "reputation", "buff", "sanctum", "item", "pvp", "onetime"}

AltManager.columns = {
	characterName = {
		order = 0.1,
		fakeLabel = "Name",
		hideOption = true,
		data = function(alt_data) return alt_data.name end,
		color = function(alt_data) return RAID_CLASS_COLORS[alt_data.class] end,
	},
	ilevel = {
		order = 0.2,
		fakeLabel = "Ilvl",
		hideOption = true,
		data = function(alt_data) return string.format("%.2f", alt_data.ilevel or 0) end,
		justify = "TOP",
		small = true,
	},
	gold = {
		label = "Gold",
		option = "gold",
		data = function(alt_data) return alt_data.gold and tonumber(alt_data.gold) and GetMoneyString(alt_data.gold, true) or "-" end,
		group = "currency",
	},
	weekly_key = {
		label = "Highest Key",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateWeeklyString(alt_data.vaultInfo.MythicPlus) or "-" end,
		isComplete = function(alt_data) return alt_data.vaultInfo and alt_data.vaultInfo.MythicPlus and alt_data.vaultInfo.MythicPlus[1].level >= 15 end,
		group = "dungeons"
	},
	mplus_score = {
		label = "Mythic+ Score",
		data = function(alt_data) return alt_data.mythicScore and AbbreviateLargeNumbers(alt_data.mythicScore) or "-" end,
		group = "dungeons",
	},
	keystone = {
		label = "Keystone",
		data = function(alt_data) return (AltManager.keys[alt_data.dungeon] or alt_data.dungeon) .. " +" .. tostring(alt_data.level) end,
		group = "dungeons",
	},
	soul_cinders = {
		label = "Soul Cinders",
		type = "currency",
		id = 1906,
		group = "currency",
	},
	soul_ash = {
		label = "Soul Ash",
		type = "currency",
		id = 1828,
		group = "currency",
	},
	stygia = {
		label = "Stygia",
		type = "currency",
		id = 1767,
		group = "currency",
	},
	conquest = {
		label = "Conquest",
		type = "currency",
		id = 1602,
		hideMax = true,
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1602) end,
		group = "currency",
	},
	honor = {
		label = "Honor",
		type = "currency",
		id = 1792,
		abbCurrent = true,
		abbMax = true,
		group = "currency",
	},
	valor = {
		label = "Valor",
		type = "currency",
		id = 1191,
		hideMax = true,
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1191) end,
		group = "currency",
	},
	tower_knowledge = {
		label = "Tower Knowledge",
		type = "currency",
		id = 1904,
		hideMax = true,
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1904) end,
		group = "currency",
	},
	stygian_ember = {
		label = "Stygian Ember",
		type = "currency",
		id = 1977,
		group = "currency",
	},
	cataloged_research = {
		label = "Cataloged Research",
		type = "currency",
		id = 1931,
		abbMax = true,
		group = "currency",
	},
	contract = {
		label = "Contract",
		data = function(alt_data) return alt_data.contract and AltManager:CreateContractString(alt_data.contract) or "-" end,
		group = "buff",
	},
	arenaRating2v2 = {
		label = "2v2 Rating",
		tooltip = function(button, alt_data) AltManager:PVPTooltip_OnEnter(button, alt_data, 1) end,
		data = function(alt_data) return alt_data.pvp and alt_data.pvp[1] and AltManager:CreateRatingString(alt_data.pvp[1]) or "-" end,
		group = "pvp",
	},
	arenaRating3v3 = {
		label = "3v3 Rating",
		tooltip = function(button, alt_data) AltManager:PVPTooltip_OnEnter(button, alt_data, 2) end,
		data = function(alt_data) return alt_data.pvp and alt_data.pvp[2] and AltManager:CreateRatingString(alt_data.pvp[2]) or "-" end,
		group = "pvp",
	},
	rbgRating = {
		label = "RBG Rating",
		tooltip = function(button, alt_data) AltManager:PVPTooltip_OnEnter(button, alt_data, 3) end,
		data = function(alt_data) return alt_data.pvp and alt_data.pvp[3] and AltManager:CreateRatingString(alt_data.pvp[3]) or "-" end,
		group = "pvp",
	},
	callings = {
		label = "Callings",
		tooltip = function(button, alt_data) AltManager:CallingTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return AltManager:CreateCallingString(alt_data.callingInfo) end,
		group = "resetDaily"
	},
	korthia_dailies = {
		label = "Korthia Dailies",
		type = "quest",
		reset = "daily",
		key = "korthia_dailies",
		required = function(alt_data) 
			if alt_data.questInfo.unlocks then
				local _, unlocked = next(alt_data.questInfo.unlocks.korthia_five_dailies)
				return unlocked and 4 or 3
			end
			return 3
		end,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.korthia_dailies) >= 3 end,	
		group = "resetDaily",
	},
	riftbound_cache = {
		label = "Riftbound Caches",
		type = "quest",
		reset = "daily",
		key = "riftbound_cache",
		required = 4,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.riftbound_cache)>=4 end,
		group = "resetDaily",
	},
	relic_creatures = {
		label = "Relic Creatures",
		type = "quest",
		reset = "daily",
		key = "relic_creatures",
		required = 15,
		plus = true,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.relic_creatures) >= 15 end,
		group = "resetDaily"
	},
	helsworn_chest = {
		label = "Helsworn Chest",
		type = "quest",
		reset = "daily",
		key = "helsworn_chest",
		plus = true,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.helsworn_chest) >= 1 end,
		group = "resetDaily"
	},
	assault_vessels = {
		label = "Assault Vessels",
		type = "quest",
		reset = "biweekly",
		key = "assault_vessels",
		required = 2,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.biweekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.biweekly.assault_vessels) >= 2 end,
		group = "resetWeekly"
	},
	rift_vessels = {
		label = "Rift Vessels",
		type = "quest",
		reset = "weekly",
		key = "rift_vessels",
		required = 3,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.rift_vessels) >= 3 end,
		group = "resetWeekly"
	},
	maw_dailies = {
		label = "Maw Dailies",
		type = "quest",
		reset = "daily",
		key = "maw_dailies",
		required = 2,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.maw_dailies) >= 2 end,
		group = "resetDaily",
	},
	eye_of_the_jailer = {
		label = "Eye of the Jailer",
		data = function(alt_data) return (alt_data.jailerInfo and AltManager:CreateJailerString(alt_data.jailerInfo)) or "-" end,
		group = "resetDaily",
	},
	sanctum_quests = {
		label = "Covenant Specific",
		data = function(alt_data) 
			if alt_data.covenant then
				local covenant = alt_data.covenant
				local rightFeatureType = (covenant == 3 and 2) or (covenant == 4 and 5) or 0
				return (alt_data.questInfo and AltManager:CreateSanctumString(alt_data.sanctumInfo, rightFeatureType, alt_data.questInfo.daily.transport_network, alt_data.questInfo.maxnfTransport or 1)) or "-" 
			else
				return "-"
			end
		end,
		group = "resetDaily",
	},
	conductor = {
		label = "Conductor (NYI)",
		data = function(alt_data) return "-" end,
		group = "NYI",
	},			
	great_vault_mplus = {
		label = "Vault M+",
		tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "MythicPlus") end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.MythicPlus) or "-" end,
		group = "vault",
	},
	great_vault_raid = {
		label = "Vault Raid",
		tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "Raid") end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.Raid) or "-" end,
		group = "vault",
	},
	great_vault_pvp = {
		label = "Vault PVP",
		tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "RankedPvP") end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.RankedPvP) or "-" end,
		group = "vault",
	},
	mythics_done = {
		label = "Mythic+0",
		tooltip = function(button, alt_data) AltManager:DungeonTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return alt_data.instanceInfo and AltManager:CreateDungeonString(alt_data.instanceInfo.dungeons) or "-" end,
		group = "dungeons",
	},
	dungeon_quests = {
		label = "Dungeon Quests",
		type = "quest",
		reset = "weekly",
		key = "dungeon_quests",
		required = 2,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.dungeon_quests) == 2 end,
		group = "resetWeekly",
	},
	pvp_quests = {
		label = "PVP Quests",
		type = "quest",
		reset = "weekly",
		key = "pvp_quests",
		required = 2,
		enabled = function(option, key) return option[key].enabled end,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.pvp_quests) == 2 end,
		group = "resetWeekly",
	},
	weekend_event = {
		label = "Weekend Event",
		type = "quest",
		reset = "weekly",
		key = "weekend_event",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.weekend_event) == 1 end,
		group = "resetWeekly",
	},
	world_boss = {
		label = "World Boss",
		type = "quest",
		reset = "weekly",
		key = "world_boss",
		required = 2,
		plus = true,
		isCompleteTest = true,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.world_boss) == 2 end,
		group = "resetWeekly",
	},
	anima_weekly = {
		label = "1k Anima",
		type = "quest",
		reset = "weekly",
		key = "anima_weekly",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.anima_weekly) == 1 end,
		group = "resetWeekly",
	},
	maw_souls = {
		label = "Return Souls",
		type = "quest",
		reset = "weekly",
		key = "maw_souls",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.maw_souls) == 1 end,
		group = "resetWeekly",
	},
	korthia_weekly = {
		label = "Korthia Weekly",
		type = "quest",
		reset = "weekly",
		key = "korthia_weekly",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.korthia_weekly)==1 end,
		group = "resetWeekly",
	},
	maw_weekly = {
		label = "Maw Weeklies",
		type = "quest",
		reset = "weekly",
		key = "maw_weekly",
		required = function(alt_data) return alt_data.questInfo.maxMawQuests or 2 end,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.maw_weekly) == (alt_data.questInfo.maxMawQuests or 2) end,
		group = "resetWeekly",
	},
	tormentors_weekly = {
		label = "Tormentors Weekly",
		type = "quest",
		reset = "weekly",
		key = "tormentors_weekly",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.tormentors_weekly)>=1 end,
		group = "resetWeekly",
	},
	tormentors_locations = {
		label = "NYI Tormentors Locs",
		type = "quest",
		reset = "weekly",
		key = "tormentors_locations",
		required = 6,
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.tormentors_locations)>=1 end,
		group = "resetWeekly"
	},
	maw_assault = {
		label = "Maw Assault",
		type = "quest",
		reset = "biweekly",
		key = "assault",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.biweekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.biweekly.assault) >= 1 end,
		group = "resetWeekly",
	},
	battle_plans = {
		label = "Maw Battle Plans",
		type = "quest",
		reset = "weekly",
		key = "battle_plans",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.battle_plans) == 1 end,
		group = "resetWeekly",
	},
	korthia_supplies = {
		label = "Korthia Supplies",
		type = "quest",
		reset = "weekly",
		key = "korthia_supplies",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.korthia_supplies) == 1 end,
		group = "resetWeekly",
	},
	containing_the_helsworn = {
		label = "Maw WQ",
		type = "quest",
		reset = "weekly",
		key = "containing_the_helsworn",
		group = "resetWeekly",
	},
	torghast_layer = {
		label = "Torghast",
		tooltip = function(button, alt_data) AltManager:TorghastTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return alt_data.torghastInfo and AltManager:CreateTorghastString(alt_data.torghastInfo) or "-" end,
		isComplete = function(alt_data) return alt_data.torghastInfo and AltManager:CompletedTorghastLayers(alt_data.torghastInfo) end,
		group = "torghast",
	},
	wrath = {
		label = "Wrath of the Jailer",
		type = "quest",
		reset = "weekly",
		key = "wrath",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.wrath) == 1 end,
		group = "resetWeekly"
	},
	hunt = {
		label = "The Hunt",
		type = "quest",
		reset = "weekly",
		key = "hunt",
		isComplete = function(alt_data) return alt_data.questInfo and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hunt) == 1 end,
		group = "resetWeekly",
	},
	archivists = {
		label = "Archivists",
		type = "faction",
		id = 2472,
		group = "reputation",
	},
	deaths_advance = {
		label = "Death's Advance",
		type = "faction",
		id = 2470,
		group = "reputation",
	},
	venari = {
		label = "Ve'nari",
		type = "faction",
		id = 2432,
		group = "reputation",
	},
	ascended = {
		label = "Ascended",
		type = "faction",
		id = 2407,
		group = "reputation",
	},
	wild_hunt = {
		label = "Wild Hunt",
		type = "faction",
		id = 2465,
		group = "reputation",
	},
	undying_army = {
		label = "Undying Army",
		type = "faction",
		id = 2410,
		group = "reputation",
	},
	court_of_harvesters = {
		label = "Court of Harvesters",
		type = "faction",
		id = 2413,
		group = "reputation",
	},
	nathria = {
		label = "Nathria",
		tooltip = function(button, alt_data) AltManager:RaidTooltip_OnEnter(button, alt_data, 2296) end,
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.nathria)) or "-" end,
		isComplete = function(alt_data) return alt_data.instanceInfo and alt_data.instanceInfo.raids.nathria and alt_data.instanceInfo.raids.nathria.defeatedEncounters == 10 end,
		group = "raids",
	},
	sanctum_of_domination = {
		label = "SoD",
		tooltip = function(button, alt_data) AltManager:RaidTooltip_OnEnter(button, alt_data, 2450) end,
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.sanctum_of_domination)) or "-" end,
		isComplete = function(alt_data) return alt_data.instanceInfo and alt_data.instanceInfo.raids.sanctum_of_domination and alt_data.instanceInfo.raids.sanctum_of_domination.defeatedEncounters == 10 end,
		group = "raids",
	},
	reservoir_anima = {
		label = "Reservoir Anima",
		type = "currency",
		id = 1813,
		hideMax = true,
		group = "currency",
	},
	renown = {
		label = "Renown",
		data = function(alt_data) return alt_data.renown or "-" end,
		group = "sanctum",
	},	
	redeemed_soul = {
		label = "Redeemed Soul",
		type = "currency",
		id = 1810,
		group = "sanctum",
	},
	transport_network = {
		label = "Transport Network",
		data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[2] and alt_data.sanctumInfo[2].tier) or "-" end,
		group = "sanctum",
	},
	anima_conductor = {
		label = "Anima Conductor",
		data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[1] and alt_data.sanctumInfo[1].tier) or "-" end,
		group = "sanctum",
	},
	command_table = {
		label = "Command Table",
		data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[3] and alt_data.sanctumInfo[3].tier) or "-" end,
		group = "sanctum",
	},
	sanctum_unique = {
		label = "Unique",
		data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[5] and alt_data.sanctumInfo[5].tier) or "-" end,
		group = "sanctum",
	},
	separator1 = {
		fakeLabel = "Separator1",
		data = function() return "" end,
		group = "separator",
	},
	separator2 = {
		fakeLabel = "Separator2",
		data = function() return "" end,
		group = "separator",
	},
	separator3 = {
		fakeLabel = "Separator3",
		data = function() return "" end,
		group = "separator",
	},
	separator4 = {
		fakeLabel = "Separator4",
		data = function() return "" end,
		group = "separator",
	},
	separator5 = {
		fakeLabel = "Separator5",
		data = function() return "" end,
		group = "separator",
	},
	separator6 = {
		fakeLabel = "Separator6",
		data = function() return "" end,
		group = "separator",
	},

	-- Items
	flask = {
		label = "Flasks",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.flask, 171276) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "flask") end,
		group = "item",
	},
	foodHaste = {
		label = "Haste Food",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.foodHaste, 172045) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "foodHaste") end,
		group = "item",
	},
	augmentRune = {
		label = "Augment Runes",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.augmentRune, 181468) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "augmentRune") end,
		group = "item",
	},
	armorKit = {
		label = "Armor Kits",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.armorKit, 172347) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "armorKit") end,
		group = "item",
	},
	oilHeal = {
		label = "Heal Oils",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.oilHeal, 171286) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "oilHeal") end,
		group = "item",
	},
	oilDPS = {
		label = "DPS Oils",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.oilDPS, 171285) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "oilDPS") end,
		group = "item",
	},
	potHP = {
		label = "HP Pots",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.potHP, 171267) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "potHP") end,
		group = "item",
	},
	drum = {
		label = "Drums",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.drum, 172233) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "drum") end,
		group = "item",
	},
	potManaInstant = {
		label = "Instant Mana",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.potManaInstant, 171272) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "potManaInstant") end,
		group = "item",
	},
	potManaChannel = {
		label = "Channal Mana",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.potManaChannel, 171268) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "potManaChannel") end,
		group = "item",
	},
	tome = {
		label = "Tomes",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.tome, 173049) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "tome") end,
		group = "item",
	},
	relic = {
		label = "Korthia Relics",
		type = "quest",
		reset = "relics",
		key = "relic",
		required = 20,
		plus = true,
		group = "onetime",
	}
}

AltManager.numDungeons = 9
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


AltManager.raids = {
	[2296] = {name = GetRealZoneText(2296), englishName = "nathria"},
	[2450] = {name = GetRealZoneText(2450), englishName = "sanctum_of_domination"},
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
	[2441] = GetRealZoneText(2441),
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
	[2432] = {name = "Ve'nari", paragon = true, type = "friend"},
	[2472] = {name = "The Archivists' Codex", paragon = true, type = "friend"},
	[2407] = {name = "The Ascended", paragon = true},
	[2465] = {name = "The Wild Hunt", paragon = true},
	[2410] = {name = "The Undying Army", paragon = true},
	[2413] = {name = "Court of Harvesters", paragon = true},
	[2470] = {name = "Death's Advance", paragon = true},
}

AltManager.currencies = {
	[1602] = true,
	[1767] = true,
	[1792] = true,
	[1810] = true,
	[1813] = true,
	[1828] = true,
	[1191] = true,
	[1931] = true,
	[1904] = true,
	[1906] = true,
	[1977] = true,
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

		[63775] = {key = "korthia_dailies"},
		[63776] = {key = "korthia_dailies"},
		[63777] = {key = "korthia_dailies"},
		[63778] = {key = "korthia_dailies"},
		[63779] = {key = "korthia_dailies"},
		[63780] = {key = "korthia_dailies"},
		[63781] = {key = "korthia_dailies"},
		[63782] = {key = "korthia_dailies"},
		[63783] = {key = "korthia_dailies"},
		[63784] = {key = "korthia_dailies"},
		[63785] = {key = "korthia_dailies"},
		[63786] = {key = "korthia_dailies"},
		[63787] = {key = "korthia_dailies"},
		[63788] = {key = "korthia_dailies"},
		[63789] = {key = "korthia_dailies"},
		[63790] = {key = "korthia_dailies"},
		[63791] = {key = "korthia_dailies"},
		[63792] = {key = "korthia_dailies"},
		[63793] = {key = "korthia_dailies"},
		[63794] = {key = "korthia_dailies"},
		[63934] = {key = "korthia_dailies"},
		[63935] = {key = "korthia_dailies"},
		[63936] = {key = "korthia_dailies"},
		[63937] = {key = "korthia_dailies"},
		[63950] = {key = "korthia_dailies"},
		[63954] = {key = "korthia_dailies"},
		[63955] = {key = "korthia_dailies"},
		[63956] = {key = "korthia_dailies"},
		[63957] = {key = "korthia_dailies"},
		[63958] = {key = "korthia_dailies"},
		[63959] = {key = "korthia_dailies"},
		[63960] = {key = "korthia_dailies"},
		[63961] = {key = "korthia_dailies"},
		[63962] = {key = "korthia_dailies"},
		[63963] = {key = "korthia_dailies"},
		[63964] = {key = "korthia_dailies"},
		[63965] = {key = "korthia_dailies"},
		[63989] = {key = "korthia_dailies"},
		[64015] = {key = "korthia_dailies"},
		[64016] = {key = "korthia_dailies"},
		[64017] = {key = "korthia_dailies"},
		[64043] = {key = "korthia_dailies"},
		[64065] = {key = "korthia_dailies"},
		[64070] = {key = "korthia_dailies"},
		[64080] = {key = "korthia_dailies"},
		[64089] = {key = "korthia_dailies"},
		[64101] = {key = "korthia_dailies"},
		[64103] = {key = "korthia_dailies"},
		[64104] = {key = "korthia_dailies"},
		[64129] = {key = "korthia_dailies"},
		[64166] = {key = "korthia_dailies"},
		[64194] = {key = "korthia_dailies"},
		[64432] = {key = "korthia_dailies"},


	 	[64456] = {key = "riftbound_cache"},
	 	[64470] = {key = "riftbound_cache"},
	 	[64471] = {key = "riftbound_cache"},
	 	[64472] = {key = "riftbound_cache"},

	 	[64341] = {key = "relic_creatures"},
	 	[64342] = {key = "relic_creatures"},
	 	[64343] = {key = "relic_creatures"},
	 	[64344] = {key = "relic_creatures"},
	 	[64747] = {key = "relic_creatures"},
	 	[64748] = {key = "relic_creatures"},
	 	[64749] = {key = "relic_creatures"},
	 	[64750] = {key = "relic_creatures"},
	 	[64751] = {key = "relic_creatures"},
	 	[64752] = {key = "relic_creatures"},
	 	[64753] = {key = "relic_creatures"},
	 	[64754] = {key = "relic_creatures"},
	 	[64755] = {key = "relic_creatures"},
	 	[64756] = {key = "relic_creatures"},
	 	[64757] = {key = "relic_creatures"},

	 	[64256]= {key = "helsworn_chest"},
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

		[61982] = {covenant = 1, key = "anima_weekly"}, -- kyrian 1k anima
		[61981] = {covenant = 2, key = "anima_weekly"}, -- venthyr 1k anima
		[61984] = {covenant = 3, key = "anima_weekly"}, -- night fae 1k anima
		[61983] = {covenant = 4, key = "anima_weekly"}, -- necro 1k anima

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
	 	[64531] = {key = "world_boss"}, -- Mor'geth, Tormentor of the Damned

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

	 	[63949] = {key = "korthia_weekly"}, -- Shaping Fate

	 	[63854] = {key = "tormentors_weekly"}, -- Tormentors of Torghast
	 	[64122] = {key = "tormentors_weekly"}, -- Tormentors of Torghast

	 	[64694] = {key = "tormentors_locations"},
	 	[64695] = {key = "tormentors_locations"},
	 	[64696] = {key = "tormentors_locations"},
	 	[64697] = {key = "tormentors_locations"},
	 	[64698] = {key = "tormentors_locations"},

	 	[64521] = {key = "battle_plans"}, -- Helsworn Battle Plans
	 	[64522] = {key = "korthia_supplies"}, -- Stolen Korthia Supplies

	 	[64273] = {key = "containing_the_helsworn"}, -- Containing the Helsworn World Quest

	 	[64265] = {key = "rift_vessels"},
	 	[64269] = {key = "rift_vessels"},
	 	[64270] = {key = "rift_vessels"},
	},
	biweekly = {
		[63824] = {key = "assault"}, -- Kyrian
		[63543] = {key = "assault"}, -- Necrolord
		[63822] = {key = "assault"}, -- Venthyr
		[63823] = {key = "assault"}, -- Nightfae

		[64056] = {key = "assault_vessels"},
	 	[64055] = {key = "assault_vessels"},
	 	[64058] = {key = "assault_vessels"},
	 	[64057] = {key = "assault_vessels"},
	},
	relics = {
		[63860] = {key = "relic", item = 185914, tier = 1},
		[63911] = {key = "relic", item = 187200, tier = 1},
		[63899] = {key = "relic", item = 187206, tier = 1},
		[63912] = {key = "relic", item = 187201, tier = 1},
		[63892] = {key = "relic", item = 187055, tier = 1},
		[63910] = {key = "relic", item = 187052, tier = 2},
		[63924] = {key = "relic", item = 187150, tier = 2},
		[63909] = {key = "relic", item = 187047, tier = 2},
		[63921] = {key = "relic", item = 187119, tier = 2},
		[63915] = {key = "relic", item = 187204, tier = 3},
		[63917] = {key = "relic", item = 187103, tier = 3},
		[63916] = {key = "relic", item = 187205, tier = 3},
		[63918] = {key = "relic", item = 187104, tier = 3},
		[63919] = {key = "relic", item = 187210, tier = 4},
		[63913] = {key = "relic", item = 187202, tier = 4},
		[63920] = {key = "relic", item = 187207, tier = 4},
		[63914] = {key = "relic", item = 187203, tier = 4},
		[63922] = {key = "relic", item = 187208, tier = 5},
		[63923] = {key = "relic", item = 187209, tier = 5},
		[63908] = {key = "relic", item = 186014, tier = 5},
	},
	unlocks = {
		[63727] = {key = "korthia_five_dailies"},
	}
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

function AltManager:getDefaultCategories()
	return default_categories
end

local tocversion = select(4, GetBuildInfo())
if tocversion == 90005 then
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
elseif tocversion == 90100 then
		AltManager.vault_rewards = {
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
			[0] = 213,
			[1] = 220,
			[2] = 226,
			[3] = 233,
			[4] = 240,
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
end