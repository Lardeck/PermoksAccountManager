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
		childs = {"korthia_dailies", "relic_creatures", "relic_gorger", "riftbound_cache", "helsworn_chest"},
		childOrder = {korthia_dailies = 1, relic_creatures = 2, relic_gorger = 3, riftbound_cache = 4, helsworn_chest = 5},
		enabled = true,
	},
	currentweekly = {
		order = 3,
		name = "(Bi)Weekly",
		childs = {"korthia_weekly", "anima_weekly", "maw_assault", "assault_vessels", "rift_vessels", "separator1", "battle_plans", "korthia_supplies", "containing_the_helsworn", "tormentors_weekly", "tormentors_locations",	
		"separator2", "adamant_vault_conduit", "torghast_layer", "world_boss", "contract"},
		childOrder = {korthia_weekly = 1, anima_weekly = 2, maw_assault = 3, assault_vessels = 4, rift_vessels = 5, separator1 = 10, battle_plans = 11, korthia_supplies = 12, containing_the_helsworn = 13, tormentors_weekly = 14, tormentors_locations = 15, 
		separator2 = 20, adamant_vault_conduit = 21, torghast_layer = 22, world_boss = 23, contract = 24},
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
		questType = "daily",
		visibility = "visible",
		key = "korthia_dailies",
		required = function(alt_data) 
			local unlocks = alt_data.questInfo.unlocks and alt_data.questInfo.unlocks.visible
			if unlocks then
				local _, unlocked = next(unlocks.korthia_five_dailies)
				return unlocked and 4 or 3
			end
			return 3
		end,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.daily and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.korthia_dailies) >= 3 end,	
		group = "resetDaily",
	},
	riftbound_cache = {
		label = "Riftbound Caches",
		type = "quest",
		questType = "daily",
		visibility = "hidden",
		key = "riftbound_cache",
		required = 4,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.daily and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.riftbound_cache)>=4 end,
		group = "resetDaily",
	},
	relic_creatures = {
		label = "Relic Creatures",
		type = "quest",
		questType = "daily",
		visibility = "hidden",
		key = "relic_creatures",
		required = 15,
		plus = true,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.daily and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.relic_creatures) >= 15 end,
		group = "resetDaily"
	},
	relic_gorger = {
		label = "Relic Gorger",
		type = "quest",
		questType = "daily",
		visibility = "hidden",
		key = "relic_gorger",
		required = 4,
		plus = true,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.daily and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.relic_gorger) >= 4 end,
		group = "resetDaily",
	},
	helsworn_chest = {
		label = "Helsworn Chest",
		type = "quest",
		questType = "daily",
		visibility = "hidden",
		key = "helsworn_chest",
		plus = true,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.daily and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.helsworn_chest) >= 1 end,
		group = "resetDaily"
	},
	assault_vessels = {
		label = "Assault Vessels",
		type = "quest",
		questType = "weekly",
		visibility = "hidden",
		key = "assault_vessels",
		required = 4,
		tooltip = function(button, alt_data) AltManager:QuestTooltip_OnEnter(button, alt_data, "weekly", "hidden", "assault_vessels") end,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.assault_vessels) >= 2 end,
		group = "resetWeekly"
	},
	rift_vessels = {
		label = "Rift Vessels",
		type = "quest",
		questType = "weekly",
		visibility = "hidden",
		key = "rift_vessels",
		required = 3,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.rift_vessels) >= 3 end,
		group = "resetWeekly"
	},
	adamant_vault_conduit = {
		label = "AV Conduit",
		type = "quest",
		questType = "weekly",
		visibility = "hidden",
		key = "adamant_vault_conduit",
		group = "resetWeekly",
	},
	maw_dailies = {
		label = "Maw Dailies",
		type = "quest",
		questType = "daily",
		visibility = "visible",
		key = "maw_dailies",
		required = 2,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.daily and AltManager:GetNumCompletedQuests(alt_data.questInfo.daily.maw_dailies) >= 2 end,
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
				return (alt_data.questInfo and alt_data.questInfo.daily and AltManager:CreateSanctumString(alt_data.sanctumInfo, rightFeatureType, alt_data.questInfo.daily.transport_network, alt_data.questInfo.maxnfTransport or 1)) or "-" 
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
		questType = "weekly",
		visibility = "visible",
		key = "dungeon_quests",
		required = 2,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekl and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.dungeon_quests) == 2 end,
		group = "resetWeekly",
	},
	pvp_quests = {
		label = "PVP Quests",
		type = "quest",
		questType = "weekly",
		visibility = "visible",
		key = "pvp_quests",
		required = 2,
		enabled = function(option, key) return option[key].enabled end,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.pvp_quests) == 2 end,
		group = "resetWeekly",
	},
	weekend_event = {
		label = "Weekend Event",
		type = "quest",
		questType = "weekly",
		visibility = "visible",
		key = "weekend_event",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.weekend_event) == 1 end,
		group = "resetWeekly",
	},
	world_boss = {
		label = "World Boss",
		type = "quest",
		questType = "weekly",
		visibility = "hidden",
		key = "world_boss",
		required = 2,
		plus = true,
		isCompleteTest = true,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.world_boss) == 2 end,
		group = "resetWeekly",
	},
	anima_weekly = {
		label = "1k Anima",
		type = "quest",
		questType = "weekly",
		visibility = "visible",
		key = "anima_weekly",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.anima_weekly) == 1 end,
		group = "resetWeekly",
	},
	maw_souls = {
		label = "Return Souls",
		type = "quest",
		questType = "weekly",
		visibility = "visible",
		key = "maw_souls",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.maw_souls) == 1 end,
		group = "resetWeekly",
	},
	korthia_weekly = {
		label = "Korthia Weekly",
		type = "quest",
		questType = "weekly",
		visibility = "visible",
		key = "korthia_weekly",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.korthia_weekly)==1 end,
		group = "resetWeekly",
	},
	maw_weekly = {
		label = "Maw Weeklies",
		type = "quest",
		questType = "weekly",
		visibility = "visible",
		key = "maw_weekly",
		required = 2,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.maw_weekly) == (alt_data.questInfo.maxMawQuests or 2) end,
		group = "resetWeekly",
	},
	tormentors_weekly = {
		label = "Tormentors Weekly",
		type = "quest",
		questType = "weekly",
		visibility = "hidden",
		key = "tormentors_weekly",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.tormentors_weekly)>=1 end,
		group = "resetWeekly",
	},
	tormentors_locations = {
		label = "Tormentors Rep",
		type = "quest",
		questType = "weekly",
		visibility = "hidden",
		key = "tormentors_locations",
		required = 6,
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.tormentors_locations)>=1 end,
		group = "resetWeekly"
	},
	maw_assault = {
		label = "Maw Assault",
		type = "quest",
		questType = "biweekly",
		visibility = "hidden",
		key = "assault",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.biweekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.biweekly.assault) >= 1 end,
		group = "resetWeekly",
	},
	battle_plans = {
		label = "Maw Battle Plans",
		type = "quest",
		questType = "weekly",
		visibility = "visible",
		key = "battle_plans",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.battle_plans) == 1 end,
		group = "resetWeekly",
	},
	korthia_supplies = {
		label = "Korthia Supplies",
		type = "quest",
		questType = "weekly",
		visibility = "visible",
		key = "korthia_supplies",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.korthia_supplies) == 1 end,
		group = "resetWeekly",
	},
	containing_the_helsworn = {
		label = "Maw WQ",
		type = "quest",
		questType = "weekly",
		visibility = "hidden",
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
		questType = "weekly",
		visibility = "hidden",
		key = "wrath",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.wrath) == 1 end,
		group = "resetWeekly"
	},
	hunt = {
		label = "The Hunt",
		type = "quest",
		questType = "weekly",
		visibility = "hidden",
		key = "hunt",
		isComplete = function(alt_data) return alt_data.questInfo and alt_data.questInfo.weekly and AltManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hunt) == 1 end,
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
		questType = "relics",
		visibility = "visible",
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
		[63824] = {questType = "biweekly"}, -- Kyrian
		[63543] = {questType = "biweekly"}, -- Necrolord
		[63822] = {questType = "biweekly"}, -- Venthyr
		[63823] = {questType = "biweekly"}, -- Nightfae
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

	relic = {
		[63860] = {item = 185914, tier = 1, questType = "relics", log = true},
		[63911] = {item = 187200, tier = 1, questType = "relics", log = true},
		[63899] = {item = 187206, tier = 1, questType = "relics", log = true},
		[63912] = {item = 187201, tier = 1, questType = "relics", log = true},
		[63892] = {item = 187055, tier = 1, questType = "relics", log = true},
		[63910] = {item = 187052, tier = 2, questType = "relics", log = true},
		[63924] = {item = 187150, tier = 2, questType = "relics", log = true},
		[63909] = {item = 187047, tier = 2, questType = "relics", log = true},
		[63921] = {item = 187119, tier = 2, questType = "relics", log = true},
		[63915] = {item = 187204, tier = 3, questType = "relics", log = true},
		[63917] = {item = 187103, tier = 3, questType = "relics", log = true},
		[63916] = {item = 187205, tier = 3, questType = "relics", log = true},
		[63918] = {item = 187104, tier = 3, questType = "relics", log = true},
		[63919] = {item = 187210, tier = 4, questType = "relics", log = true},
		[63913] = {item = 187202, tier = 4, questType = "relics", log = true},
		[63920] = {item = 187207, tier = 4, questType = "relics", log = true},
		[63914] = {item = 187203, tier = 4, questType = "relics", log = true},
		[63922] = {item = 187208, tier = 5, questType = "relics", log = true},
		[63923] = {item = 187209, tier = 5, questType = "relics", log = true},
		[63908] = {item = 186014, tier = 5, questType = "relics", log = true},
	},

	adamant_vault_conduit = {
		[64347] = {questType = "weekly"}
	},

	korthia_five_dailies = {
		[63727] = {questType = "unlocks", log = true},
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

function AltManager:getDefaultCategories()
	return default_categories
end

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