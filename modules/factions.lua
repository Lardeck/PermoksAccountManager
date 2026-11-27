local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local FACTION_STANDING_LABEL_CUSTOM = {}
local FACTION_BAR_COLORS_CUSTOM = {
	[1] = { r = 152, g = 32, b = 32 },
	[2] = { r = 222, g = 0, b = 10 },
	[3] = { r = 209, g = 102, b = 33 },
	[4] = { r = 222, g = 255, b = 10 },
	[5] = { r = 7, g = 255, b = 13 },
	[6] = { r = 10, g = 222, b = 136 },
	[7] = { r = 18, g = 224, b = 204 },
	[8] = { r = 5, g = 255, b = 189 },
}
do
	for standingID, color in pairs(FACTION_BAR_COLORS) do
		FACTION_BAR_COLORS_CUSTOM[standingID] = FACTION_BAR_COLORS_CUSTOM[standingID]
			or { r = color.r * 256, g = color.g * 256, b = color.b * 256 }
	end
	FACTION_BAR_COLORS_CUSTOM[9] = { r = 16, g = 165, b = 202 }

	for i = 1, 8 do
		FACTION_STANDING_LABEL_CUSTOM[i] = GetText("FACTION_STANDING_LABEL" .. i)
	end
	FACTION_STANDING_LABEL_CUSTOM[9] = "Paragon"
end

local labelRows = {
	archivists = {
		label = L["Archivists"],
		type = "faction",
		key = 2472,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	deaths_advance = {
		label = function()
			return PermoksAccountManager.factions[2470].localName or L["Death's Advance"]
		end,
		type = "faction",
		key = 2470,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	venari = {
		label = function()
			return PermoksAccountManager.factions[2432].localName or L["Ve'nari"]
		end,
		type = "faction",
		key = 2432,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	ascended = {
		label = function()
			return PermoksAccountManager.factions[2407].localName or L["Ascended"]
		end,
		type = "faction",
		key = 2407,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	wild_hunt = {
		label = function()
			return PermoksAccountManager.factions[2465].localName or L["Wild Hunt"]
		end,
		type = "faction",
		key = 2465,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	undying_army = {
		label = function()
			return PermoksAccountManager.factions[2410].localName or L["Undying Army"]
		end,
		type = "faction",
		key = 2410,
		group = "reputation",
	},
	court_of_harvesters = {
		label = function()
			return PermoksAccountManager.factions[2413].localName or L["Court of Harvesters"]
		end,
		type = "faction",
		key = 2413,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	the_enlightened = {
		label = function()
			return PermoksAccountManager.factions[2478].localName or L["The Enlightened"]
		end,
		type = "faction",
		key = 2478,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	dragonscale_expedition = {
		label = function()
			return PermoksAccountManager.factions[2507].localName or "Expedition"
		end,
		type = "faction",
		warband = "unique",
		key = 2507,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	iskaara_tuskar = {
		label = function()
			return PermoksAccountManager.factions[2511].localName or "Iskaara Tuskar"
		end,
		type = "faction",
		warband = "unique",
		key = 2511,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	maruuk_centaur = {
		label = function()
			return PermoksAccountManager.factions[2503].localName or "Maruuk Centaur"
		end,
		type = "faction",
		warband = "unique",
		key = 2503,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	valdrakken_akkord = {
		label = function()
			return PermoksAccountManager.factions[2510].localName or "Valdrakken Akkord"
		end,
		type = "faction",
		warband = "unique",
		key = 2510,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	winterpelt_furbolg = {
		label = function()
			return PermoksAccountManager.factions[2526].localName or "Winterpelt Furbolg"
		end,
		type = "faction",
		key = 2526,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	artisan_consortium = {
		label = function()
			return PermoksAccountManager.factions[2544].localName or "Artisan's Consortium"
		end,
		type = "faction",
		warband = "unique",
		key = 2544,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	cobalt_assembly = {
		label = function()
			return PermoksAccountManager.factions[2550].localName or "Cobalt Assembly"
		end,
		type = "faction",
		warband = "unique",
		key = 2550,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	sabellian = {
		label = function()
			return PermoksAccountManager.factions[2518].localName or "Sabellian"
		end,
		type = "faction",
		warband = "unique",
		key = 2518,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	wrathion = {
		label = function()
			return PermoksAccountManager.factions[2517].localName or "Wrathion"
		end,
		type = "faction",
		warband = "unique",
		key = 2517,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	loam_niffen = {
		label = function()
			return PermoksAccountManager.factions[2564].localName or "Loam Niffen"
		end,
		type = "faction",
		warband = "unique",
		key = 2564,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	dream_wardens = {
		label = function()
			return PermoksAccountManager.factions[2574].localName or "Dream Wardens"
		end,
		type = "faction",
		warband = "unique",
		key = 2574,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	soridormi = {
		label = function()
			return PermoksAccountManager.factions[2553].localName or "Soridormi"
		end,
		type = "faction",
		warband = "unique",
		key = 2553,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	keg_legs_crew = {
		label = function()
			return PermoksAccountManager.factions[2593].localName or "Keg Leg's Crew"
		end,
		type = "faction",
		warband = "unique",
		key = 2593,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},

	-- 11.0
	council_of_dornogal = {
		label = function()
			return PermoksAccountManager.factions[2590].localName or "Council of Dornogal"
		end,
		type = "faction",
		warband = "unique",
		key = 2590,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	hallowfall_arathi = {
		label = function()
			return PermoksAccountManager.factions[2570].localName or "Hallowfall Arathi"
		end,
		type = "faction",
		warband = "unique",
		key = 2570,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	the_assembly_of_the_deeps = {
		label = function()
			return PermoksAccountManager.factions[2594].localName or "The Assembly of the Deeps"
		end,
		type = "faction",
		warband = "unique",
		key = 2594,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	the_severed_threads = {
		label = function()
			return PermoksAccountManager.factions[2600].localName or "The Severed Threads"
		end,
		type = "faction",
		warband = "unique",
		key = 2600,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	the_general = {
		label = function()
			return PermoksAccountManager.factions[2605].localName or "The General"
		end,
		type = "faction",
		warband = "unique",
		key = 2605,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	the_vizier = {
		label = function()
			return PermoksAccountManager.factions[2607].localName or "The Vizier"
		end,
		type = "faction",
		warband = "unique",
		key = 2607,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	the_weaver = {
		label = function()
			return PermoksAccountManager.factions[2601].localName or "The Weaver"
		end,
		type = "faction",
		warband = "unique",
		key = 2601,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	brann_bronzebeard = {
		label = function()
			return PermoksAccountManager.factions[2640].localName or "Brann Bronzebeard"
		end,
		type = "faction",
		warband = "unique",
		key = 2640,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},

	-- 11.1
	the_cartels_of_undermine = {
		label = function()
			return PermoksAccountManager.factions[2653].localName or "Cartels Undermine"
		end,
		type = "faction",
		warband = "unique",
		key = 2653,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	bilgewater_cartel = {
		label = function()
			return PermoksAccountManager.factions[2673].localName or "Bilgewater"
		end,
		type = "faction",
		warband = "unique",
		key = 2673,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	blackwater_cartel = {
		label = function()
			return PermoksAccountManager.factions[2675].localName or "Blackwater"
		end,
		type = "faction",
		warband = "unique",
		key = 2675,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	steamwheedle_cartel = {
		label = function()
			return PermoksAccountManager.factions[2677].localName or "Steamwheedle"
		end,
		type = "faction",
		warband = "unique",
		key = 2677,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	venture_company = {
		label = function()
			return PermoksAccountManager.factions[2671].localName or "Venture Company"
		end,
		type = "faction",
		warband = "unique",
		key = 2671,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	gallagio_loyalty_rewards_club = {
		label = function()
			return PermoksAccountManager.factions[2685].localName or "Gallagio"
		end,
		type = "faction",
		warband = "unique",
		key = 2685,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	darkfuse_solutions = {
		label = function()
			return PermoksAccountManager.factions[2669].localName or "Darkfuse Solutions"
		end,
		type = "faction",
		warband = "unique",
		key = 2669,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	flames_radiance = {
		label = function()
			return PermoksAccountManager.factions[2688].localName or "Flame's Radiance"
		end,
		type = "faction",
		warband = "unique",
		key = 2688,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},

	-- 11.2
	the_karesh_trust = {
		label = function()
			return PermoksAccountManager.factions[2658].localName or "Manaforge Vandals"
		end,
		type = "faction",
		warband = "unique",
		key = 2658,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	manaforge_vandals = {
		label = function()
			return PermoksAccountManager.factions[2736].localName or "Manaforge Vandals"
		end,
		type = "faction",
		warband = "unique",
		key = 2736,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},

	-- 12.0
	silvermoon_court = {
		label = function()
			return PermoksAccountManager.factions[2710].localName or "Silvermoon Court"
		end,
		type = "faction",
		warband = "unique",
		key = 2710,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	the_singularity = {
		label = function()
			return PermoksAccountManager.factions[2699].localName or "The Singularity"
		end,
		type = "faction",
		warband = "unique",
		key = 2699,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	harati = {
		label = function()
			return PermoksAccountManager.factions[2704].localName or "Hara'ti"
		end,
		type = "faction",
		warband = "unique",
		key = 2704,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	amani_tribe = {
		label = function()
			return PermoksAccountManager.factions[2696].localName or "Amani Tribe"
		end,
		type = "faction",
		warband = "unique",
		key = 2696,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},

	-- 12.1
	zuljarras_force = {
		label = function()
			return PermoksAccountManager.factions[2772].localName or "Zul'jarra"
		end,
		type = "faction",
		warband = "unique",
		key = 2772,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	captain_tokka = {
		label = function()
			return PermoksAccountManager.factions[2773].localName or "Captain Tokka"
		end,
		type = "faction",
		warband = "unique",
		key = 2773,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	delves_current = {
		label = function()
			return PermoksAccountManager.factions[2796].localName or "Delves"
		end,
		type = "faction",
		warband = "unique",
		key = 2796,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},
	prey_current = {
		label = function()
			return PermoksAccountManager.factions[2808].localName or "Prey"
		end,
		type = "faction",
		warband = "unique",
		key = 2808,
		group = "reputation",
		version = WOW_PROJECT_MAINLINE,
	},

	-- wotlk
	alliance_vanguard = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1037]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1037,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	valiance_expedition = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1050]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1050,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	horde_expedition = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1052]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1052,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_taunka = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1064]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1064,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_hand_of_vengeance = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1067]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1067,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	explorers_league = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1068]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1068,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_kaluak = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1073]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1073,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	warsong_offensive = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1085]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1085,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	kirin_tor = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1090]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1090,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_wyrmrest_accord = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1091]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1091,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_silver_covenant = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1094]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1094,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	knights_of_the_ebon_blade = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1098]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1098,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	frenzyheart_tribe = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1104]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1104,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_oracles = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1105]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1105,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	argent_crusade = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1106]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1106,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_sons_of_hodir = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1119]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1119,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_sunreavers = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1124]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1124,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_frostborn = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1126]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1126,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	the_ashen_verdict = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1156]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1156,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},

	the_earthen_ring = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1135]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1135,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	therazane = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1171]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1171,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	guardians_of_hyjal = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1158]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1158,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	dragonmaw_clan = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1172]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1172,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	ramkahen = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1173]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1173,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	wildhammer_clan = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1174]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1174,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	hellscreams_reach = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1178]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1178,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},
	baradins_warden = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1177]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1177,
		type = "faction",
		version = WOW_PROJECT_CATACLYSM_CLASSIC,
		group = "reputation",
	},

	-- Mists
	golden_lotus = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1269]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1269,
		type = "faction",
		version = WOW_PROJECT_MISTS_CLASSIC,
		group = "reputation",
	},
	shado_pan = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1270]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1270,
		type = "faction",
		version = WOW_PROJECT_MISTS_CLASSIC,
		group = "reputation",
	},
	the_august_celestials = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1341]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1341,
		type = "faction",
		version = WOW_PROJECT_MISTS_CLASSIC,
		group = "reputation",
	},
	the_black_prince = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1359]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1359,
		type = "faction",
		version = WOW_PROJECT_MISTS_CLASSIC,
		group = "reputation",
	},
	the_klaxxi = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1337]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1337,
		type = "faction",
		version = WOW_PROJECT_MISTS_CLASSIC,
		group = "reputation",
	},
	the_anglers = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1302]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1302,
		type = "faction",
		version = WOW_PROJECT_MISTS_CLASSIC,
		group = "reputation",
	},
	the_tillers = {
		label = function()
			local factionInfo = PermoksAccountManager.factions[1272]
			return factionInfo.localName or factionInfo.name
		end,
		key = 1272,
		type = "faction",
		version = WOW_PROJECT_MISTS_CLASSIC,
		group = "reputation",
	},
}

local foreverLabelRows = {
	pvp_rank_points = {
		label = "Rank Points",
		type = "faction",
		key = 2800,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	argent_dawn = {
		label = function()
			local faction = PermoksAccountManager.factions[529]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 529,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	azeroth_commerce_authority = {
		label = function()
			local faction = PermoksAccountManager.factions[2586]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2586,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	barkskin_burrow = {
		label = function()
			local faction = PermoksAccountManager.factions[2747]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2747,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	bloodsail_buccaneers = {
		label = function()
			local faction = PermoksAccountManager.factions[87]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 87,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	bolderok_clan = {
		label = function()
			local faction = PermoksAccountManager.factions[2782]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2782,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	booty_bay = {
		label = function()
			local faction = PermoksAccountManager.factions[21]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 21,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	brood_of_nozdormu = {
		label = function()
			local faction = PermoksAccountManager.factions[910]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 910,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	brotherhood_of_the_horse = {
		label = function()
			local faction = PermoksAccountManager.factions[2826]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2826,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	cenarion_circle = {
		label = function()
			local faction = PermoksAccountManager.factions[609]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 609,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	cenarion_scouts = {
		label = function()
			local faction = PermoksAccountManager.factions[2719]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2719,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	darkmoon_faire = {
		label = function()
			local faction = PermoksAccountManager.factions[909]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 909,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	darkspear_raiders = {
		label = function()
			local faction = PermoksAccountManager.factions[2798]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2798,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	darkspear_trolls = {
		label = function()
			local faction = PermoksAccountManager.factions[530]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 530,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	darnassus = {
		label = function()
			local faction = PermoksAccountManager.factions[69]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 69,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	durotar_supply_and_logistics = {
		label = function()
			local faction = PermoksAccountManager.factions[2587]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2587,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	emerald_wardens = {
		label = function()
			local faction = PermoksAccountManager.factions[2641]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2641,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	everlook = {
		label = function()
			local faction = PermoksAccountManager.factions[577]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 577,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	frostwolf_clan = {
		label = function()
			local faction = PermoksAccountManager.factions[729]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 729,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	gadgetzan = {
		label = function()
			local faction = PermoksAccountManager.factions[369]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 369,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	gelkis_clan_centaur = {
		label = function()
			local faction = PermoksAccountManager.factions[92]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 92,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	gnomeregan_exiles = {
		label = function()
			local faction = PermoksAccountManager.factions[54]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 54,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	guardians_of_hyjal = {
		label = function()
			local faction = PermoksAccountManager.factions[2765]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2765,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	high_order = {
		label = function()
			local faction = PermoksAccountManager.factions[2779]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2779,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	hydraxian_waterlords = {
		label = function()
			local faction = PermoksAccountManager.factions[749]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 749,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	ironforge = {
		label = function()
			local faction = PermoksAccountManager.factions[47]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 47,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	kirin_tor = {
		label = function()
			local faction = PermoksAccountManager.factions[2740]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2740,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	magram_clan_centaur = {
		label = function()
			local faction = PermoksAccountManager.factions[93]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 93,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	morogai = {
		label = function()
			local faction = PermoksAccountManager.factions[789]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 789,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	nightclaw_druids = {
		label = function()
			local faction = PermoksAccountManager.factions[2758]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2758,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	orgrimmar = {
		label = function()
			local faction = PermoksAccountManager.factions[76]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 76,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	powderfuse = {
		label = function()
			local faction = PermoksAccountManager.factions[2827]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2827,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	ratchet = {
		label = function()
			local faction = PermoksAccountManager.factions[470]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 470,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	ravasaur_trainers = {
		label = function()
			local faction = PermoksAccountManager.factions[630]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 630,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	ravenholdt = {
		label = function()
			local faction = PermoksAccountManager.factions[349]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 349,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	shatterspear_trolls = {
		label = function()
			local faction = PermoksAccountManager.factions[629]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 629,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	shendralar = {
		label = function()
			local faction = PermoksAccountManager.factions[809]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 809,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	silverwing_sentinels = {
		label = function()
			local faction = PermoksAccountManager.factions[890]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 890,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	stormpike_guard = {
		label = function()
			local faction = PermoksAccountManager.factions[730]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 730,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	stormwind = {
		label = function()
			local faction = PermoksAccountManager.factions[72]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 72,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	syndicate = {
		label = function()
			local faction = PermoksAccountManager.factions[70]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 70,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	the_defilers = {
		label = function()
			local faction = PermoksAccountManager.factions[510]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 510,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	the_earthen_ring = {
		label = function()
			local faction = PermoksAccountManager.factions[2787]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2787,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	the_league_of_arathor = {
		label = function()
			local faction = PermoksAccountManager.factions[509]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 509,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	the_watchers = {
		label = function()
			local faction = PermoksAccountManager.factions[2819]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2819,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	theramore_expeditionary_force = {
		label = function()
			local faction = PermoksAccountManager.factions[2799]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2799,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	thorium_brotherhood = {
		label = function()
			local faction = PermoksAccountManager.factions[59]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 59,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	thunder_bluff = {
		label = function()
			local faction = PermoksAccountManager.factions[81]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 81,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	timbermaw_hold = {
		label = function()
			local faction = PermoksAccountManager.factions[576]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 576,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	undercity = {
		label = function()
			local faction = PermoksAccountManager.factions[68]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 68,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	warsong_outriders = {
		label = function()
			local faction = PermoksAccountManager.factions[889]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 889,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	wildhammer_clan = {
		label = function()
			local faction = PermoksAccountManager.factions[471]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 471,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	windshapers = {
		label = function()
			local faction = PermoksAccountManager.factions[2778]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 2778,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	wintersaber_trainers = {
		label = function()
			local faction = PermoksAccountManager.factions[589]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 589,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
	zandalar_tribe = {
		label = function()
			local faction = PermoksAccountManager.factions[270]
			return faction.localName or faction.name
		end,
		type = "faction",
		key = 270,
		group = "reputation",
		version = WOW_PROJECT_CAMELOT,
	},
}

local friendshipStandings = {
	-- Ve'nari
	["Dubious"] = "1/6",
	["Apprehensive"] = "2/6",
	["Tentative"] = "3/6",
	["Ambivalent"] = "4/6",
	["Cordial"] = "5/6",
	["Appreciative"] = "6/6",

	-- Black Dragons / Severed Threads Leaders
	["Stranger"] = "1/9",
	["Acquaintance"] = "2/9",
	["Crony"] = "3/9",
	["Accomplice"] = "4/9",
	["Collaborator"] = "5/9",
	["Accessory"] = "6/9",
	["Abettor"] = "7/9",
	["Conspirator"] = "8/9",
	["Mastermind"] = "9/9",

	-- Archivists
	["Tier 1"] = "1/6",
	["Tier 2"] = "2/6",
	["Tier 3"] = "3/6",
	["Tier 4"] = "4/6",
	["Tier 5"] = "5/6",
	["Tier 6"] = "6/6",

	-- Consortium
	["Neutral"] = "1/5",
	["Preferred"] = "2/5",
	["Respected"] = "3/5",
	["Valued"] = "4/5",
	["Esteemed"] = "5/5",

	-- Soridormi
	["Anomaly"] = "1/5",
	["Future Friend"] = "2/5",
	["Rift-Mender"] = "3/5",
	["Timewalker"] = "4/5",
	["Legend"] = "5/5",

	-- Cobalt Assembly
	["Empty"] = "1/5",
	["Low"] = "2/5",
	["Medium"] = "3/5",
	["High"] = "4/5",
	["Maximum"] = "5/5",
}

local GetFriendshipReputation = C_GossipInfo and C_GossipInfo.GetFriendshipReputation or GetFriendshipReputation
--TODO: Rework after DF launch
local function GetFactionOrFriendshipInfo(factionId, factionType)
	local barMin, barMax, barValue = 0, 0, 0
	local hasReward, renown, name, _, standing
	if C_Reputation and C_Reputation.GetFactionDataByID then
		local factionData = C_Reputation.GetFactionDataByID(factionId)
		if factionData then
			name = factionData.name
			standing = factionData.reaction
			barMin = factionData.currentReactionThreshold
			barMax = factionData.nextReactionThreshold
			barValue = factionData.currentStanding
		end
	else
		name, _, standing, barMin, barMax, barValue = GetFactionInfoByID(factionId)
	end
	local isParagon = C_Reputation.IsFactionParagon and C_Reputation.IsFactionParagon(factionId)

	--if isParagon then
	--	barValue, barMax, _, hasReward = C_Reputation.GetFactionParagonInfo(factionId)
	--	barMin, standing, barValue = 0, 9, barValue % barMax
	--elseif factionType == "renown" then
	if factionType == "renown" then
		renown = C_MajorFactions.GetCurrentRenownLevel(factionId)
		local majorFactionInfo = C_MajorFactions.GetMajorFactionData(factionId)
		if majorFactionInfo then
			barMin = 0
			barValue = majorFactionInfo.renownReputationEarned
			barMax = majorFactionInfo.renownLevelThreshold
		end
	elseif factionType == "friend" then
		local friendshipInfo = C_GossipInfo.GetFriendshipReputation(factionId)
		if friendshipInfo then
			barMin = friendshipInfo.reactionThreshold
			barValue = friendshipInfo.standing
			barMax = friendshipInfo.nextThreshold or friendshipInfo.reactionThreshold
			standing = friendshipInfo.reaction
		end
	end

	if not barMax or not barMin then
		return
	end

	return barValue - barMin, (barMax - barMin), standing, name, hasReward, renown
end

local function UpdateFaction(factionTable, factionId, standing, current, maximum, info, hasReward, renown)
	factionTable[factionId] = factionTable[factionId] or {}
	local faction = factionTable[factionId]
	faction.standing = standing
	faction.current = current
	faction.max = maximum
	faction.type = info.type
	faction.hasReward = hasReward
	faction.renown = renown
	faction.exalted = not info.paragon and standing == 8
	faction.maximum = info.type == "friend" and current >= maximum
end

local function UpdateFactions(charInfo)
	local self = PermoksAccountManager

	charInfo.factions = charInfo.factions or {}
	if self.isRetail then
		self.warbandData.factions = self.warbandData.factions or {}
	end
	if self.isForever then
		charInfo.factionGroup = UnitFactionGroup("player") or charInfo.factionGroup or charInfo.faction
	end

	local factions = charInfo.factions
	local warbandFactions = self.warbandData.factions

	for factionId, info in pairs(self.factions) do
		if not info.factionGroup or info.factionGroup == charInfo.factionGroup then
			local current, maximum, standing, name, hasReward, renown = GetFactionOrFriendshipInfo(factionId, info.type)

			UpdateFaction(factions, factionId, standing, current, maximum, info, hasReward, renown)

			if warbandFactions then
				UpdateFaction(warbandFactions, factionId, standing, current, maximum, info, hasReward, renown)
			end

			if not info.localName then
				info.localName = name
			end
		end
	end
end

local function Update(charInfo)
	UpdateFactions(charInfo)
end

local module = "factions"
local payload = {
	update = Update,
	labels = PermoksAccountManager.isForever and foreverLabelRows or labelRows,
	events = {
		["UPDATE_FACTION"] = UpdateFactions,
	},
	share = {
		[UpdateFactions] = "factions",
	},
}
PermoksAccountManager:AddModule(module, payload)

local function convertStanding(standing)
	if friendshipStandings[standing] then
		return friendshipStandings[standing]
	else
		return standing:sub(1, 1)
	end
end

function PermoksAccountManager:CreateFactionString(factionInfo)
	if not factionInfo then
		return
	end

	if factionInfo.renown then
		return string.format(
			"%s - %s/%s",
			BLUE_FONT_COLOR:WrapTextInColorCode(factionInfo.renown),
			AbbreviateNumbers(factionInfo.current or 0),
			AbbreviateNumbers(factionInfo.max or 0)
		)
	end

	if not factionInfo.standing then
		return "No Data"
	end
	if factionInfo.exalted then
		return string.format("|cff00ff00%s|r", L["Exalted"])
	elseif factionInfo.maximum then
		return string.format("|cff00ff00%s|r", "Maximum")
	end

	local standingColor, standing = FACTION_BAR_COLORS_CUSTOM[5], FACTION_STANDING_LABEL_CUSTOM[factionInfo.standing]
	if standing then
		standingColor = FACTION_BAR_COLORS_CUSTOM[factionInfo.standing]
	else
		standing = factionInfo.standing
	end

	if factionInfo.max then
		local color = factionInfo.hasReward and "ff00ff00"
			or CreateColor(standingColor.r / 255, standingColor.g / 255, standingColor.b / 255):GenerateHexColor()
		return string.format(
			"|c%s%s|r/%s |cff%02X%02X%02X%s|r",
			color,
			AbbreviateLargeNumbers(factionInfo.current or 0),
			AbbreviateNumbers(factionInfo.max or 0),
			standingColor.r,
			standingColor.g,
			standingColor.b,
			convertStanding(standing)
		)
	end
end
