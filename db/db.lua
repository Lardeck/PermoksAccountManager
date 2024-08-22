local addonName, PermoksAccountManager = ...
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local default_categories = {
    general = {
        order = 0,
        name = L['General'],
        childs = {
            'characterName',
            'ilevel',
            'gold',
            'weekly_key',
            'keystone',
            'mplus_score',
            'catalyst_charges',
            'valorstones',
            'champion_crest',
            'veteran_crest',
            'hero_crest',
            'myth_crest',
            'spark_omens',

            -- Probably interesting during the first weeks, might wanna (re-)move later
            'separator2',
            'restored_coffer_key',
            'resonance_crystals',
            'kej',
            'radiant_remnant',
            'radiant_echo',

            -- DF Stuff -> Remove from Default Categories after global Launch
            'separator3',
            'residual_memories',
            'radiant_echoes_prepatch_dailies',
            'radiant_echoes_cache',
        },
        childOrder = {
            characterName = 1,
            ilevel = 2,
            gold = 3,
            weekly_key = 4,
            keystone = 5,
            mplus_score = 6,
            catalyst_charges = 7,
            valorstones = 8,
            champion_crest = 9,
            veteran_crest = 10,
            hero_crest = 11,
            myth_crest = 12,
            spark_omens = 13,

            -- Probably interesting during the first weeks, might wanna (re-)move later
            separator2 = 20,
            restored_coffer_key = 21,
            resonance_crystals = 22,
            kej = 23, 
            radiant_remnant = 24,
            radiant_echo = 25,

            -- DF Stuff -> Remove from Default Categories after global Launch
            separator3 = 30,
            residual_memories = 31,
            radiant_echoes_prepatch_dailies = 32,
            radiant_echoes_cache = 33,
        },
        hideToggle = true,
        enabled = true
    },
    currentdaily = {
        order = 1,
        name = 'Daily',
        childs = {
        },
        childOrder = {
        },
        enabled = false
    },
    currentweekly = {
        order = 2,
        name = '(Bi)Weekly',
        childs = {
            'dungeon_weekly',
            'weekend_event',
            'worldsoul_weekly',
            'archaic_cypher_key',

            'separator1',
            'the_theater_troupe',
            'rollin_down_in_the_deeps',
            'gearing_up_for_trouble',
            'awakening_the_machine',
            'spreading_the_light',
            'lesser_keyflame_weeklies',
            'greater_keyflame_weeklies',
            'severed_threads_pact_weekly',

            'separator2',
            'isle_of_dorne_rares',
            'ringing_deeps_rares',
            'hallowfall_rares',
            'azj_kahet_rares',
        },
        childOrder = {
            dungeon_weekly = 1,
            weekend_event = 2,
            worldsoul_weekly = 3,
            archaic_cypher_key = 5,

            separator1 = 10,
            the_theater_troupe = 11,
            rollin_down_in_the_deeps = 12,
            gearing_up_for_trouble = 13,
            awakening_the_machine = 14,
            spreading_the_light = 15,
            lesser_keyflame_weeklies = 16,
            greater_keyflame_weeklies = 17,
            severed_threads_pact_weekly = 18,

            
            separator2 = 20,
            isle_of_dorne_rares = 21,
            ringing_deeps_rares = 22,
            hallowfall_rares = 23,
            azj_kahet_rares = 24,
        },
        enabled = true
    },
    vault = {
        order = 3,
        name = L['Vault'],
        childs = {
            'great_vault_mplus',
            'great_vault_raid',
            'great_vault_pvp'
        },
        childOrder = {
            great_vault_mplus = 1,
            great_vault_raid = 2,
            great_vault_pvp = 3
        },
        enabled = true
    },
    professions = {
        order = 4,
        name = L['Professions'],
        childs = {
            'knowledge_tww_treasures',
            'knowledge_tww_treatise',
            'knowledge_tww_gather',
            'knowledge_tww_weeklies_quest',
            'separator1',
            'artisans_acuity',
        },
        childOrder = {
            knowledge_tww_treasures = 1,
            knowledge_tww_treatise = 2,
            knowledge_tww_gather = 3,
            knowledge_tww_weeklies_quest = 4,

            separator1 = 10,
            artisans_acuity = 11,
        },
        enabled = true
    },
    renown = {
        order = 5,
        name = L['Reputation'],
        childs = {
            'council_of_dornogal',
            'hallowfall_arathi',
            'the_assembly_of_the_deeps',
            'the_severed_threads',
            'the_general',
            'the_vizier',
            'the_weaver',
            -- 'brann_bronzebeard', Makes no sense without a custom string for the level
        },
        childOrder = {
            council_of_dornogal = 1,
            hallowfall_arathi = 2,
            the_assembly_of_the_deeps= 2,
            the_severed_threads = 4,
            the_general = 5,
            the_vizier = 6,
            the_weaver = 7,
            -- brann_bronzebeard = 8,
        },
        enabled = true
    },
    raid = {
        order = 6,
        name = L['Raid'],
        childs = {
            'nerub_ar_palace',
        },
        childOrder = {
            nerub_ar_palace = 1,
        },
        enabled = true
    },
    pvp = {
        order = 7,
        name = L['PVP'],
        childs = {
            'conquest',
            'honor',
            'arenaRating2v2',
            'arenaRating3v3',
            'rbgRating',

            'separator3',
            'pvp_sparks',
            'pvp_weekly',
        },
        childOrder = {
            conquest = 1,
            honor = 2,
            arenaRating2v2 = 3,
            arenaRating3v3 = 4,
            rbgRating = 5,

            separator3 = 30,
            pvp_sparks = 31,
            pvp_weekly = 32,
        },
        enabled = true
    },
    old_weekly = {
        order = 8,
        name = "Old Weekly",
        childs = {
            'big_dig',
            'show_your_mettle',
        },
        childOrder = {
            big_dig = 51,
            show_your_mettle = 52,
        },
        enabled = true,
    },
    old_daily = {
        order = 9,
        name = "Old Daily",
        childs = {
        },
        childOrder = {
        },
        enabled = false,
    },
    unlocks = {
        order = 10,
        name = 'Unlocks',
        childs = {},
        childOrder = {},
        enabled = false,
    },
}

PermoksAccountManager.groups = {
    currency = {
        label = L['Currency'],
        order = 3
    },
    character = {
        label = L['Character'],
        order = 2
    },
    resetDaily = {
        label = L['Daily Reset'],
        order = 5
    },
    resetWeekly = {
        label = L['Weekly Reset'],
        order = 6
    },
    resetBiweekly = {
        label = L['Biweekly Reset'],
        order = 8,
    },
    vault = {
        label = L['Vault'],
        order = 9
    },
    torghast = {
        label = L['Torghast'],
        order = 10
    },
    dungeons = {
        label = L['Dungeons'],
        order = 11
    },
    raids = {
        label = L['Raids'],
        order = 12
    },
    reputation = {
        label = L['Reputation'],
        order = 13
    },
    buff = {
        label = L['Buff'],
        order = 14
    },
    sanctum = {
        label = L['Sanctum'],
        order = 15
    },
    separator = {
        label = L['Separator'],
        order = 1
    },
    item = {
        label = L['Items'],
        order = 15
    },
    pvp = {
        label = L['PVP'],
        order = 16
    },
    onetime = {
        label = L['ETC'],
        order = 17
    },
    other = {
        label = L['Other'],
        order = 18
    },
    profession = {
        label = L['Professions'],
        order = 19
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

PermoksAccountManager.numDungeons = 9
PermoksAccountManager.keys = {
    [2] = "TJS", -- Temple of the Jade Serpent
    [165] = "SBG", -- Shadowmoon Burial Grounds
    [369] = 'YARD', -- Operation: Mechagon - Junkyard
	[370] = 'WORK', -- Operation: Mechagon - Workshop
	[375] = 'MISTS', -- Mists of Tirna Scithe
    [376] = 'NW', -- The Necrotic Wage
    [377] = 'DOS', -- De Other Side
    [378] = 'HOA', -- Halls of Atonement
    [379] = 'PF', -- Plaguefall
    [380] = 'SD', -- Sanguine Depths
    [381] = 'SOA', -- Spires of Ascension
    [382] = 'TOP', -- Theater of Pain
    [391] = 'STRT', -- Tazavesh: Streets of Wonder
    [392] = 'GMBT', -- Tazavesh: So'lesh Gambit
	[166] = 'GD', -- Grimrail Depot
    [168] = 'EB', -- Everbloom
	[169] = 'ID', -- Iron Docks
	[197] = 'EOA', -- Eye of Azshara
	[198] = 'DHT', -- Darkheart Thicket
	[199] = 'BRH', -- Blackrook Hold
	[200] = 'HOV', -- Halls of Valor
	[206] = 'NL', -- Neltharion's Lair
	[207] = 'VOTW', -- Vault of the Wardens
	[208] = 'MOS', -- Maw of Souls
	[209] = 'ARC', -- The Arcway
	[210] = 'COS', -- Court of Stars
	[227] = 'LOWR', -- Return to Karazhan: Lower
	[233] = 'COEN', -- Cathedral of Eternal Night
	[234] = 'UPPR', -- Return to Karathan: Upper
	[239] = 'SEAT', -- Seat of the Triumvirate
    [244] = 'AD', -- Atal'Dazar
    [245] = 'FH', -- Freehold
    [248] = 'WM', -- Waycrest Manor
    [251] = 'UNDR', -- The Underrot
    [399] = 'RLP', -- Ruby Life Pools
    [400] = 'NO', -- The Nokhud Offensive
    [401] = 'AV', -- The Azure Vault
    [402] = 'AA', -- Algeth'ar Academy
    [403] = 'ULD', -- Uldaman: Legacy of Tyr
    [404] = 'NELT', -- Neltharus
    [405] = 'BH', -- Brackenhide Hollow
    [406] = 'HOI', -- Halls of Infusion
    [438] = 'VP', -- The Vortex Pinnacle
    [456] = 'TOTT', -- Throne of the Tides
    [463] = 'FALL', -- Dawn of the Infinite: Galakrond's Fall
    [464] = 'RISE', -- Dawn of the Infinite: Murozond's Rise

    -- PLACEHOLDER: abbreviations
    [499] = 'PSF', -- Priory of the Sacred Flame
    [500] = 'TR', -- The Rookery
    [501] = 'TSV', -- The Stonevault
    [502] = 'COT', -- City of Threads
    [503] = 'AK', -- Ara-Kara, City of Echoes
    [504] = 'DFC', -- Darkflame Cleft
    [505] = 'DAWN', -- The Dawnbreaker
    [506] = 'CIN', -- Cinderbrew Meadery
    [507] = 'GB', -- Grim Batol
}

PermoksAccountManager.activityIDToKeys = {
	[459] = 197, -- EOA
	[460] = 198, -- DHT
	[461] = 200, -- HOV
	[462] = 206, -- NL
	[463] = 199, -- BRH
	[464] = 207, -- VOTW
	[465] = 208, -- MOS
	[466] = 210, -- COS
	[467] = 209, -- ARC
	[471] = 227, -- LOWR
	[473] = 234, -- UPPR
	[476] = 233, -- COEN
	[486] = 239, -- SEAT
}

PermoksAccountManager.raids = {
    [2657] = {name = GetRealZoneText(2657), englishID = 'nerub_ar_palace', instanceID = 1273, startIndex = 1, endIndex = 8},
}

PermoksAccountManager.dungeons = {
    [2451] = GetRealZoneText(2451),
    [2515] = GetRealZoneText(2515),
    [2516] = GetRealZoneText(2516),
    [2519] = GetRealZoneText(2519),
    [2520] = GetRealZoneText(2520),
    [2521] = GetRealZoneText(2521),
    [2526] = GetRealZoneText(2526),
    [2527] = GetRealZoneText(2527),
    [2579] = GetRealZoneText(2579),
}

PermoksAccountManager.item = {
    [171276] = {key = 'flask'}, -- Flask
    [172045] = {key = 'foodHaste'}, -- Haste Food
    [181468] = {key = 'augmentRune'}, -- Rune
    [172347] = {key = 'armorKit'}, -- Armor Kit
    [171286] = {key = 'oilHeal'}, -- Heal Oil
    [171285] = {key = 'oilDPS'}, -- DPS Oil
    [171267] = {key = 'potHP'}, -- HP Pot
    [172233] = {key = 'drum'}, -- Drum
    [171272] = {key = 'potManaInstant'}, -- Mana Pot Instant
    [171268] = {key = 'potManaChannel'}, -- Mana Pot Channel
    [173049] = {key = 'tome'}, -- Tome
    [186017] = {key = 'korthiteCrystal'}, -- Korthite Crystal
	[187707] = {key = 'progenitorEssentia'}, -- Progenitor Essentia
	[187802] = {key = 'potCosmicHP'}, -- Cosmic HP Pot
	[199211] = {key = 'primevalEssence'}, --Primeval Essence
    [202196] = {key = 'vaultKey'}, -- Zskera Vault Key
    [190453] = {key = 'spark_ingenuity'}, -- Spark of Ingenuity
    [199197] = {key = 'spark_ingenuity'}, -- Bottled Essence
    [204440] = {key = 'spark_shadowflame'}, -- Spark of Shadowflame
    [204717] = {key = 'spark_shadowflame'}, -- Splintered Spark of Shadowflame
    [204715] = {key = 'unearthed_fragrant_coin'}, -- Unearthed Fragrant Coin
    [204985] = {key = 'barter_brick'}, -- Barter Brick
    [206959] = {key = 'spark_dreams'}, -- Spark of Dreams
    [208396] = {key = 'spark_dreams'}, -- Splintered Spark of Dreams
    [202171] = {key = 'obsidian_flightstone'}, -- Obsidian Flightstone
    [207030] = {key = 'dilated_time_capsule'}, -- Dilated Time Capsule
    [209856] = {key = 'dilated_time_pod'}, -- Dilated Time Pod
    [207026] = {key = 'dreamsurge_coalescence'}, -- Dreamsurge Coalescence
    [208153] = {key = 'dreamsurge_chrysalis'}, -- Dreamsurge Chrysalis
    [210254] = {key = 'dreamsurge_cocoon'}, -- Dreamsurge Cocoon
    [208066] = {key = 'dreamseeds'}, -- Small Dreamseed
    [208067] = {key = 'dreamseeds'}, -- Plump Dreamseed
    [208047] = {key = 'dreamseeds'}, -- Gigantic Dreamseed
    [211515] = {key = 'spark_awakening'}, -- Splintered Spark of Awakening
    [211516] = {key = 'spark_awakening'}, -- Spark of Awakening
    [190456] = {key = 'artisans_mettle'}, -- Artisan's Mettle

    --- TWW items
    [211297] = {key = 'spark_omens'}, -- Fractured Spark of Omens
    [211296] = {key = 'spark_omens'}, -- Spark of Omens
    [210814] = {key = 'artisans_acuity'}, -- Artisan's Acuity
    [206350] = {key = 'radiant_remnant'}, -- Radiant Remnant
    [220520] = {key = 'radiant_echo'}, -- Radiant Echo
    [212493] = {key = 'firelight_ruby'}, -- Odd Glob of Wax
    [224642] = {key = 'firelight_ruby'}, -- Firelight Ruby
    [220693] = {key = 'coffer_key_shard'}, -- Coffer Key Shard    
}

PermoksAccountManager.factions = {
    [2432] = {name = "Ve'nari", paragon = true, type = 'friend'},
    [2472] = {name = "The Archivists' Codex", paragon = true, type = 'friend'},
    [2407] = {name = 'The Ascended', paragon = true},
    [2465] = {name = 'The Wild Hunt', paragon = true},
    [2410] = {name = 'The Undying Army', paragon = true},
    [2413] = {name = 'Court of Harvesters', paragon = true},
    [2470] = {name = "Death's Advance", paragon = true},
    [2478] = {name = 'The Enlightened', paragon = true},
    [2480] = {name = 'Automa', paragon = true},
    [2503] = {name = 'Maruuk Centaur', paragon = true, type = 'renown', warband = 'unique'},
    [2507] = {name = 'Dragonscale Expedition', paragon = true, type = 'renown', warband = 'unique'},
    [2510] = {name = 'Valdrakken Akkord', paragon = true, type = 'renown', warband = 'unique'},
    [2511] = {name = 'Iskaara Tuskar', paragon = true, type = 'renown', warband = 'unique'},
    [2517] = {name = 'Wrathion', paragon = true, type = 'friend', warband = 'unique'},
    [2518] = {name = 'Sabellian', paragon = true, type = 'friend', warband = 'unique'},
    [2526] = {name = 'Winterpelt Furbolg', paragon = true},
    [2544] = {name = 'Artisan\'s Consortium', paragon = true, type = 'friend', warband = 'unique'},
    [2550] = {name = 'Cobalt Assembly', paragon = true, type = 'friend', warband = 'unique'},
    [2553] = {name = 'Soridormi', paragon = true, type = 'friend', warband = 'unique'},
    [2564] = {name = 'Loamm Niffen', paragon = true, type = 'renown', warband = 'unique'},
    [2568] = {name = 'Glimmerogg Racer'},
    [2574] = {name = 'Dream Wardens', paragon = true, type = 'renown', warband = 'unique'},
    [2593] = {name = 'Keg Leg\'s Crew', type = 'renown', warband = 'unique'},
    [2590] = {name = 'Council of Dornogal', paragon = true, type = 'renown', warband = 'unique'},
    [2570] = {name = 'Hallowfall Arathi', paragon = true, type = 'renown', warband = 'unique'},
    [2594] = {name = 'The Assembly of the Deeps', paragon = true, type = 'renown', warband = 'unique'},
    [2600] = {name = 'The Severed Threads', paragon = true, type = 'renown', warband = 'unique'},
    [2605] = {name = 'The General',paragon = true, type = 'friend', warband = 'unique'},
    [2607] = {name = 'The Vizier',paragon = true, type = 'friend', warband = 'unique'},
    [2601] = {name = 'The Weaver',paragon = true, type = 'friend', warband = 'unique'},
    [2640] = {name = 'Brann Bronzebeard', type = 'friend', warband = 'unique'},
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
    [1822] = 1, -- Renown
    [1979] = 0,
    [2000] = 0,
    [2003] = 0, -- Dragon Isles Supplies
    [2009] = 0,
    [2118] = 0, -- Elemental Overflow
    [2122] = 0, -- Storm Sigil
    [2123] = 0, -- Bloody Tokens
    [2166] = 0, -- Renascent Lifeblood (Crucible Charges DF Season 1)
    [2245] = 0, -- Flightstones
    [2533] = 0, -- Renascent Shadowflame (Crucible Charges DF Season 2)
    [2594] = 0, -- Paracausal Flakes
    [2650] = 0, -- Emerald Dewdrop
    [2651] = 0, -- Seedbloom
    [2777] = 0, -- Dream Infusion
    [2796] = 0, -- Renascent Dream (Crucible Charges DF Season 3)
    [2806] = 0, -- Whelpling Awakened Crest
    [2807] = 0, -- Drake's Awakened Crest
    [2809] = 0, -- Wyrm's Awakened Crest
    [2812] = 0, -- Aspect's Awakened Crest
    [2912] = 0, -- Renascent Awakening (Crucible Charges DF Season 4)
    [3089] = 0, -- Residual Memories (11.0 prepatch currency)

    -- TWW Currencies
    [2914] = 0, -- Weathered Harbinger Crest
    [2915] = 0, -- Carved Harbinger Crest
    [2916] = 0, -- Runed Harbinger Crest
    [2917] = 0, -- Gilded Harbinger Crest
    [2813] = 0, -- Harmonized Silk (Crucible Charges TWW Season 1)
    [3008] = 0, -- Valorstones
    [2815] = 0, -- Resonance Crystals
    [3056] = 0, -- Kej
    [3028] = 0, -- Restored Coffer Key
    [2803] = 0, -- Undercoin
}

PermoksAccountManager.currencyCustomOptions = {
    [2166] = {currencyUpdate = 2167},
    [2533] = {forceUpdate = true},
    [2709] = {forceUpdate = true},
    [2707] = {forceUpdate = true},
    [2706] = {forceUpdate = true},
    [2708] = {forceUpdate = true},
}

PermoksAccountManager.research = {
    [1902] = 'zereth_mortis_three_dailies',
    [1972] = 'zereth_mortis_three_wqs'
}

PermoksAccountManager.professionCDs = {
	[L['Tailoring']] = {
		cds = {
            [376556] = true, -- Azureweave Bolt
			[376557] = true, -- Chronocloth Bolt
		},
	},
	[L['Alchemy']] = {
	},
	[L['Leatherworking']] = {
	},
	[L['Enchanting']] = {
	},
	[L['Engineering']] = {
	},
	[L['Blacksmithing']] = {
	},
	[L['Herbalism']] = {
	},
	[L['Mining']] = {
	},
	[L['Skinning']] = {
	},
	[L['Jewelcrafting']] = {
	}
}

-- key is the SkillLineID of the parentProfession
PermoksAccountManager.childProfessions = {
    df_profession = {
        [164] = {spellID = 365677, skillLineID = 2822}, -- Blacksmithing
        [165] = {spellID = 366249, skillLineID = 2830}, -- Leatherworking
        [171] = {spellID = 366261, skillLineID = 2823}, -- Alchemy
        [182] = {spellID = 366252, skillLineID = 2832}, -- Herbalism
        [185] = {spellID = 366256, skillLineID = 2824}, -- Cooking
        [186] = {spellID = 366260, skillLineID = 2833}, -- Mining
        [197] = {spellID = 366258, skillLineID = 2831}, -- Tailoring
        [202] = {spellID = 366254, skillLineID = 2827}, -- Engineering
        [333] = {spellID = 366255, skillLineID = 2825}, -- Enchanting
        [356] = {spellID = 366253, skillLineID = 2826}, -- Fishing
        [393] = {spellID = 366259, skillLineID = 2834}, -- Skinning
        [755] = {spellID = 366250, skillLineID = 2829}, -- Jewelcrafting
        [773] = {spellID = 366251, skillLineID = 2828}, -- Inscription
    },
    tww_profession = {
        [164] = {spellID = 423332, skillLineID = 2872}, -- Blacksmithing
        [165] = {spellID = 423340, skillLineID = 2880}, -- Leatherworking
        [171] = {spellID = 423321, skillLineID = 2871}, -- Alchemy
        [182] = {spellID = 441327, skillLineID = 2877}, -- Herbalism
        [185] = {spellID = 423333, skillLineID = 2873}, -- Cooking
        [186] = {spellID = 423341, skillLineID = 2881}, -- Mining
        [197] = {spellID = 423343, skillLineID = 2883}, -- Tailoring
        [202] = {spellID = 423335, skillLineID = 2875}, -- Engineering
        [333] = {spellID = 423334, skillLineID = 2874}, -- Enchanting
        [356] = {spellID = 423336, skillLineID = 2876}, -- Fishing
        [393] = {spellID = 423342, skillLineID = 2882}, -- Skinning
        [755] = {spellID = 423339, skillLineID = 2879}, -- Jewelcrafting
        [773] = {spellID = 423338, skillLineID = 2878}, -- Inscription
    },
}

PermoksAccountManager.quests = {

    -- General Weeklies (previous expansion quests get deprecated so we replace these IDs instead of adding new ones)
    weekend_event = {
        [83345] = {questType = 'weekly', log = true}, -- Battleground Event:    A Call to Battle
        [83347] = {questType = 'weekly', log = true}, -- Mythic Dungeon Event:  Emissary of War
        [83357] = {questType = 'weekly', log = true}, -- Pet Battle Event:      The Very Best
        [83358] = {questType = 'weekly', log = true}, -- Arena Event:           The Arena Calls
        [83366] = {questType = 'weekly', log = true}, -- World Quests:          The World Awaits
        [83359] = {questType = 'weekly', log = true}, -- A Shattered Path Through Time
        [83362] = {questType = 'weekly', log = true}, -- A Shrouded Path Through Time
        [83365] = {questType = 'weekly', log = true}, -- A Frozen Path Through Time
        [83364] = {questType = 'weekly', log = true}, -- A Savage Path Through Time

    },
    pvp_weekly = {
        [80184] = {questType = 'weekly', log = true}, -- Preserving in Battle
        [80185] = {questType = 'weekly', log = true}, -- Preserving Solo
        [80186] = {questType = 'weekly', log = true}, -- Preserving in War
        [80187] = {questType = 'weekly', log = true}, -- Preserving in Skirmishes
        [80188] = {questType = 'weekly', log = true}, -- Preserving in Arenas
        [80189] = {questType = 'weekly', log = true}, -- Preserving Teamwork
    },
    pvp_sparks = {
        [81793] = {questType = 'weekly', log = true}, -- Sparks of War: Isle of Dorn
        [81794] = {questType = 'weekly', log = true}, -- Sparks of War: The Ringing Deeps
        [81795] = {questType = 'weekly', log = true}, -- Sparks of War: Hallowfall
        [81796] = {questType = 'weekly', log = true}, -- Sparks of War: Azj-Kahet
    },
    dungeon_weekly = {
        [83432] = {questType = 'weekly', warband = true, log = true}, -- The Rookery
        [83436] = {questType = 'weekly', warband = true, log = true}, -- Cinderbrew Meadery
        [83443] = {questType = 'weekly', warband = true, log = true}, -- Darkflame Cleft
        [83457] = {questType = 'weekly', warband = true, log = true}, -- The Stonevault
        [83458] = {questType = 'weekly', warband = true, log = true}, -- Priory of the Sacred Flame
        [83459] = {questType = 'weekly', warband = true, log = true}, -- The Dawnbreaker
        [83465] = {questType = 'weekly', warband = true, log = true}, -- Ara-Kara, City of Echoes
        [83469] = {questType = 'weekly', warband = true, log = true}, -- City of Threads
    },

    -- 9.0 Shadowlands
    maw_dailies = {
        [60732] = {questType = 'daily', log = true},
        [61334] = {questType = 'daily', log = true},
        [62239] = {questType = 'daily', log = true},
        [63031] = {questType = 'daily', log = true},
        [63038] = {questType = 'daily', log = true},
        [63039] = {questType = 'daily', log = true},
        [63040] = {questType = 'daily', log = true},
        [63043] = {questType = 'daily', log = true},
        [63045] = {questType = 'daily', log = true},
        [63047] = {questType = 'daily', log = true},
        [63050] = {questType = 'daily', log = true},
        [63062] = {questType = 'daily', log = true},
        [63069] = {questType = 'daily', log = true},
        [63072] = {questType = 'daily', log = true},
        [63100] = {questType = 'daily', log = true},
        [63179] = {questType = 'daily', log = true},
        [60622] = {questType = 'weekly', log = true},
        [60646] = {questType = 'weekly', log = true},
        [60762] = {questType = 'weekly', log = true},
        [60775] = {questType = 'weekly', log = true},
        [60902] = {questType = 'weekly', log = true},
        [61075] = {questType = 'weekly', log = true},
        [61079] = {questType = 'weekly', log = true},
        [61088] = {questType = 'weekly', log = true},
        [61103] = {questType = 'weekly', log = true},
        [61104] = {questType = 'weekly', log = true},
        [61765] = {questType = 'weekly', log = true},
        [62214] = {questType = 'weekly', log = true},
        [62234] = {questType = 'weekly', log = true},
        [63206] = {questType = 'weekly', log = true}
    },
    transport_network = {
        -- Kyrian
        -- Venthyr
        -- Night Fae
        [62614] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = 'daily', log = true},
        [62615] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = 'daily', log = true},
        [62611] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = 'daily', log = true},
        [62610] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = 'daily', log = true},
        [62606] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = 'daily', log = true},
        [62608] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = 'daily', log = true},
        [60175] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = 'daily', log = true},
        [62607] = {covenant = 3, sanctum = 2, minSanctumTier = 1, questType = 'daily', log = true},
        [62453] = {covenant = 3, sanctum = 2, minSanctumTier = 2, questType = 'daily', log = true},
        [62296] = {covenant = 3, sanctum = 2, minSanctumTier = 2, questType = 'daily', log = true},
        [60153] = {covenant = 3, sanctum = 2, minSanctumTier = 2, questType = 'daily', log = true},
        [62382] = {covenant = 3, sanctum = 2, minSanctumTier = 2, questType = 'daily', log = true},
        [62263] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = 'daily', log = true},
        [62459] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = 'daily', log = true},
        [62466] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = 'daily', log = true},
        [60188] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = 'daily', log = true},
        [62465] = {covenant = 3, sanctum = 2, minSanctumTier = 3, questType = 'daily', log = true}
    },
    korthia_dailies = {
        [63775] = {questType = 'daily', log = true},
        [63776] = {questType = 'daily', log = true},
        [63777] = {questType = 'daily', log = true},
        [63778] = {questType = 'daily', log = true},
        [63779] = {questType = 'daily', log = true},
        [63780] = {questType = 'daily', log = true},
        [63781] = {questType = 'daily', log = true},
        [63782] = {questType = 'daily', log = true},
        [63783] = {questType = 'daily', log = true},
        [63784] = {questType = 'daily', log = true},
        [63785] = {questType = 'daily', log = true},
        [63786] = {questType = 'daily', log = true},
        [63787] = {questType = 'daily', log = true},
        [63788] = {questType = 'daily', log = true},
        [63789] = {questType = 'daily', log = true},
        [63790] = {questType = 'daily', log = true},
        [63791] = {questType = 'daily', log = true},
        [63792] = {questType = 'daily', log = true},
        [63793] = {questType = 'daily', log = true},
        [63794] = {questType = 'daily', log = true},
        [63934] = {questType = 'daily', log = true},
        [63935] = {questType = 'daily', log = true},
        [63936] = {questType = 'daily', log = true},
        [63937] = {questType = 'daily', log = true},
        [63950] = {questType = 'daily', log = true},
        [63954] = {questType = 'daily', log = true},
        [63955] = {questType = 'daily', log = true},
        [63956] = {questType = 'daily', log = true},
        [63957] = {questType = 'daily', log = true},
        [63958] = {questType = 'daily', log = true},
        [63959] = {questType = 'daily', log = true},
        [63960] = {questType = 'daily', log = true},
        [63961] = {questType = 'daily', log = true},
        [63962] = {questType = 'daily', log = true},
        [63963] = {questType = 'daily', log = true},
        [63964] = {questType = 'daily', log = true},
        [63965] = {questType = 'daily', log = true},
        [63989] = {questType = 'daily', log = true},
        [64015] = {questType = 'daily', log = true},
        [64016] = {questType = 'daily', log = true},
        [64017] = {questType = 'daily', log = true},
        [64043] = {questType = 'daily', log = true},
        [64065] = {questType = 'daily', log = true},
        [64070] = {questType = 'daily', log = true},
        [64080] = {questType = 'daily', log = true},
        [64089] = {questType = 'daily', log = true},
        [64101] = {questType = 'daily', log = true},
        [64103] = {questType = 'daily', log = true},
        [64104] = {questType = 'daily', log = true},
        [64129] = {questType = 'daily', log = true},
        [64166] = {questType = 'daily', log = true},
        [64194] = {questType = 'daily', log = true},
        [64432] = {questType = 'daily', log = true}
    },
    zereth_mortis_dailies = {
        [64579] = {questType = 'daily', log = true},
        [64592] = {questType = 'daily', log = true},
        [64717] = {questType = 'daily', log = true},
        [64785] = {questType = 'daily', log = true},
        [64854] = {questType = 'daily', log = true},
        [64964] = {questType = 'daily', log = true},
        [64977] = {questType = 'daily', log = true},
        [65033] = {questType = 'daily', log = true},
        [65072] = {questType = 'daily', log = true},
        [65096] = {questType = 'daily', log = true},
        [65142] = {questType = 'daily', log = true},
        [65177] = {questType = 'daily', log = true},
        [65226] = {questType = 'daily', log = true},
        [65255] = {questType = 'daily', log = true},
        [65256] = {questType = 'daily', log = true},
        [65264] = {questType = 'daily', log = true},
        [65265] = {questType = 'daily', log = true},
        [65268] = {questType = 'daily', log = true},
        [65269] = {questType = 'daily', log = true},
        [65325] = {questType = 'daily', log = true},
        [65326] = {questType = 'daily', log = true},
        [65362] = {questType = 'daily', log = true},
        [65363] = {questType = 'daily', log = true},
        [65364] = {questType = 'daily', log = true},
        [65445] = {questType = 'daily', log = true}
    },
    zereth_mortis_wqs = {
        [64960] = {questType = 'daily'},
        [64974] = {questType = 'daily'},
        [65081] = {questType = 'daily'},
        [65089] = {questType = 'daily'},
        [65102] = {questType = 'daily'},
        [65115] = {questType = 'daily'},
        [65117] = {questType = 'daily'},
        [65119] = {questType = 'daily'},
        [65232] = {questType = 'daily'},
        [65234] = {questType = 'daily'},
        [65230] = {questType = 'daily'},
        [65244] = {questType = 'daily'},
        [65252] = {questType = 'daily'},
        [65262] = {questType = 'daily'},
        [65402] = {questType = 'daily'},
        [65403] = {questType = 'daily'},
        [65405] = {questType = 'daily'},
        [65406] = {questType = 'daily'},
        [65407] = {questType = 'daily'},
        [65408] = {questType = 'daily'},
        [65409] = {questType = 'daily'},
        [65410] = {questType = 'daily'},
        [65411] = {questType = 'daily'},
        [65412] = {questType = 'daily'},
        [65413] = {questType = 'daily'},
        [65414] = {questType = 'daily'},
        [65415] = {questType = 'daily'},
        [65416] = {questType = 'daily'},
        [65417] = {questType = 'daily'}
    },
    conductor = {
        [61691] = {covenant = 3, sanctum = 1, minSanctumTier = 1, addToMax = 1, questType = 'daily'}, -- Large Lunarlight Pod
        [61633] = {covenant = 3, sanctum = 1, minSanctumTier = 1, addToMax = 1, questType = 'daily'}, -- Dreamsong Fenn
        -- Necrolords
        [58872] = {covenant = 4, sanctum = 1, minSanctumTier = 1, addToMax = 1, questType = 'daily'}, -- Gieger
        [61647] = {covenant = 4, sanctum = 1, minSanctumTier = 1, addToMax = 1, questType = 'daily'} -- Chosen Runecoffer
    },
    riftbound_cache = {
        [64456] = {questType = 'daily'},
        [64470] = {questType = 'daily'},
        [64471] = {questType = 'daily'},
        [64472] = {questType = 'daily'}
    },
    relic_creatures = {
        [64341] = {questType = 'daily'},
        [64342] = {questType = 'daily'},
        [64343] = {questType = 'daily'},
        [64344] = {questType = 'daily'},
        [64747] = {questType = 'daily'},
        [64748] = {questType = 'daily'},
        [64749] = {questType = 'daily'},
        [64750] = {questType = 'daily'},
        [64751] = {questType = 'daily'},
        [64752] = {questType = 'daily'},
        [64753] = {questType = 'daily'},
        [64754] = {questType = 'daily'},
        [64755] = {questType = 'daily'},
        [64756] = {questType = 'daily'},
        [64757] = {questType = 'daily'}
    },
    helsworn_chest = {
        [64256] = {questType = 'daily'}
    },
    relic_gorger = {
        [64433] = {questType = 'daily'},
        [64434] = {questType = 'daily'},
        [64435] = {questType = 'daily'},
        [64436] = {questType = 'daily'}
    },
    jiro_cyphers = {
        [65144] = {questType = 'daily'}, -- Creatii
        [65166] = {questType = 'daily'}, -- Genesii
        [65167] = {questType = 'daily'} -- Nascii
    },
    maw_souls = {
        [61332] = {covenant = 1, questType = 'weekly', log = true}, -- kyrian 5 souls
        [62861] = {covenant = 1, questType = 'weekly', log = true}, -- kyrian 10 souls
        [62862] = {covenant = 1, questType = 'weekly', log = true}, -- kyrian 15 souls
        [62863] = {covenant = 1, questType = 'weekly', log = true}, -- kyrian 20 souls
        [61334] = {covenant = 2, questType = 'weekly', log = true}, -- venthyr 5 souls
        [62867] = {covenant = 2, questType = 'weekly', log = true}, -- venthyr 10 souls
        [62868] = {covenant = 2, questType = 'weekly', log = true}, -- venthyr 15 souls
        [62869] = {covenant = 2, questType = 'weekly', log = true}, -- venthyr 20 souls
        [61331] = {covenant = 3, questType = 'weekly', log = true}, -- night fae 5 souls
        [62858] = {covenant = 3, questType = 'weekly', log = true}, -- night fae 10 souls
        [62859] = {covenant = 3, questType = 'weekly', log = true}, -- night fae 15 souls
        [62860] = {covenant = 3, questType = 'weekly', log = true}, -- night fae 20 souls
        [61333] = {covenant = 4, questType = 'weekly', log = true}, -- necro 5 souls
        [62864] = {covenant = 4, questType = 'weekly', log = true}, -- necro 10 souls
        [62865] = {covenant = 4, questType = 'weekly', log = true}, -- necro 15 souls
        [62866] = {covenant = 4, questType = 'weekly', log = true} -- necro 20 souls
    },
    anima_weekly = {
        [61982] = {covenant = 1, questType = 'weekly', log = true}, -- kyrian 1k anima
        [61981] = {covenant = 2, questType = 'weekly', log = true}, -- venthyr 1k anima
        [61984] = {covenant = 3, questType = 'weekly', log = true}, -- night fae 1k anima
        [61983] = {covenant = 4, questType = 'weekly', log = true} -- necro 1k anima
    },
    battle_plans = {
        [64521] = {questType = 'weekly', log = true} -- Helsworn Battle Plans
    },
    korthia_supplies = {
        [64522] = {questType = 'weekly', log = true} -- Stolen Korthia Supplies
    },
    korthia_weekly = {
        [63949] = {questType = 'weekly', log = true} -- Shaping Fate
    },
    zereth_mortis_weekly = {
        [65324] = {questType = 'weekly', log = true}
    },
    -- Maw Warth of the Jailer
    wrath = {
        [63414] = {questType = 'weekly'} -- Wrath of the Jailer
    },
    -- Maw Hunt
    hunt = {
        [63195] = {questType = 'weekly'},
        [63198] = {questType = 'weekly'},
        [63199] = {questType = 'weekly'},
        [63433] = {questType = 'weekly'}
    },
    -- World Boss
    world_boss = {
        [61813] = {questType = 'weekly'}, -- Valinor - Bastion
        [61814] = {questType = 'weekly'}, -- Nurghash - Revendreth
        [61815] = {questType = 'weekly'}, -- Oranomonos - Ardenweald
        [61816] = {questType = 'weekly'}, -- Mortanis - Maldraxxus
        [64531] = {questType = 'weekly'} -- Mor'geth, Tormentor of the Damned
    },
    korthia_world_boss = {
        [64531] = {questType = 'weekly'} -- Mor'geth, Tormentor of the Damned
    },
    zereth_mortis_world_boss = {
        [65143] = {questType = 'weekly'} -- Antros
    },
    tormentors_weekly = {
        [63854] = {questType = 'weekly'}, -- Tormentors of Torghast
        [64122] = {questType = 'weekly'} -- Tormentors of Torghast
    },
    tormentors_locations = {
        [64692] = {questType = 'weekly'},
        [64693] = {questType = 'weekly'},
        [64694] = {questType = 'weekly'},
        [64695] = {questType = 'weekly'},
        [64696] = {questType = 'weekly'},
        [64697] = {questType = 'weekly'},
        [64698] = {questType = 'weekly'}
    },
    containing_the_helsworn = {
        [64273] = {questType = 'weekly'} -- Containing the Helsworn World Quest
    },
    rift_vessels = {
        [64265] = {questType = 'weekly'},
        [64269] = {questType = 'weekly'},
        [64270] = {questType = 'weekly'}
    },
    maw_assault = {
        [63824] = {questType = 'weekly'}, -- Kyrian
        [63543] = {questType = 'weekly'}, -- Necrolord
        [63822] = {questType = 'weekly'}, -- Venthyr
        [63823] = {questType = 'weekly'} -- Nightfae
    },
    assault_vessels = {
        [64056] = {name = 'Venthyr', total = 2, questType = 'weekly'},
        [64055] = {name = 'Venthyr', total = 2, questType = 'weekly'},
        [64058] = {name = 'Kyrian', total = 2, questType = 'weekly'},
        [64057] = {name = 'Kyrian', total = 2, questType = 'weekly'},
        [64059] = {name = 'Night Fae', total = 2, questType = 'weekly'},
        [64060] = {name = 'Night Fae', total = 2, questType = 'weekly'},
        [64044] = {name = 'Necrolord', total = 2, questType = 'weekly'},
        [64045] = {name = 'Necrolord', total = 2, questType = 'weekly'}
    },
    adamant_vault_conduit = {
        [64347] = {questType = 'weekly'}
    },
    sanctum_normal_embers_trash = {
        [64610] = {questType = 'weekly'},
        [64613] = {questType = 'weekly'},
        [64616] = {questType = 'weekly'},
        [64619] = {questType = 'weekly'},
        [64622] = {questType = 'weekly'}
    },
    sanctum_heroic_embers_trash = {
        [64611] = {questType = 'weekly'},
        [64614] = {questType = 'weekly'},
        [64617] = {questType = 'weekly'},
        [64620] = {questType = 'weekly'},
        [64623] = {questType = 'weekly'}
    },
    sandworn_chest = {
        [65611] = {questType = 'daily'}
    },
    puzzle_caches = {
        [64972] = {questType = 'daily'}, -- Toccatian Cache
        [65314] = {questType = 'daily'},
        [65319] = {questType = 'daily'},
        [65323] = {questType = 'daily'}, -- Cantaric Cache
        [65094] = {questType = 'daily'},
        [65318] = {questType = 'daily'},
        [65091] = {questType = 'daily'}, -- Mezzonic Cache
        [65315] = {questType = 'daily'},
        [65320] = {questType = 'daily'},
        [65316] = {questType = 'daily'}, -- Glissandian Cache
        [65321] = {questType = 'daily'},
        [65092] = {questType = 'daily'},
        [65317] = {questType = 'daily'}, -- Fuguel Cache
        [65322] = {questType = 'daily'},
        [65093] = {questType = 'daily'}
    },
    korthia_five_dailies = {
        [63727] = {questType = 'unlocks', log = true}
    },
    zereth_mortis_three_dailies = {
        [65219] = {questType = 'unlocks', log = true}
    },
    dragonflight_world_boss = {
        [69927] =  {questType = 'weekly'},
        [69928] =  {questType = 'weekly'},
        [69929] =  {questType = 'weekly'},
        [69930] =  {questType = 'weekly'},
    },
    aiding_the_accord = {
        [70750] = {questType = 'weekly', log = true},
        [72068] = {questType = 'weekly', log = true},
        [72373] = {questType = 'weekly', log = true},
        [72374] = {questType = 'weekly', log = true},
        [72375] = {questType = 'weekly', log = true},
        [75259] = {questType = 'weekly', log = true},
        [75859] = {questType = 'weekly', log = true},
        [75860] = {questType = 'weekly', log = true},
        [75861] = {questType = 'weekly', log = true},
        [77254] = {questType = 'weekly', log = true},
        [77976] = {questType = 'weekly', log = true},
        [78446] = {questType = 'weekly', log = true},
        [78447] = {questType = 'weekly', log = true},
        [78861] = {questType = 'weekly', log = true},
        [80385] = {questType = 'weekly', log = true},
        [80386] = {questType = 'weekly', log = true},
        [80388] = {questType = 'weekly', log = true},
        [80389] = {questType = 'weekly', log = true},

    },
    grand_hunts = {
        [70906] = {questType = 'weekly'},
        [71136] = {questType = 'weekly'},
        [71137] = {questType = 'weekly'}
    },
    marrukai_camp = {
        [65784] = {questType = 'biweekly', log = true},
        [65789] = {questType = 'biweekly', log = true},
        [65792] = {questType = 'biweekly', log = true},
        [65796] = {questType = 'biweekly', log = true},
        [65798] = {questType = 'biweekly', log = true},
        [66698] = {questType = 'biweekly', log = true},
        [66711] = {questType = 'biweekly', log = true},
        [67034] = {questType = 'biweekly', log = true},
        [67039] = {questType = 'biweekly', log = true},
        [67222] = {questType = 'biweekly', log = true},
        [67605] = {questType = 'biweekly', log = true},
        [70210] = {questType = 'biweekly', log = true},
        [70299] = {questType = 'biweekly', log = true},
        [70279] = {questType = 'biweekly', log = true},
        [70352] = {questType = 'biweekly', log = true},
        [70701] = {questType = 'biweekly', log = true},
        [70990] = {questType = 'biweekly', log = true},
        [71241] = {questType = 'biweekly', log = true},
    },
    trial_of_flood = {
        [71033] = {questType = 'weekly'}
    },
    trial_of_elements = {
        [71995] = {questType = 'weekly'}
    },
    trial_of_storms = {
        [74567] = {questType = 'weekly'}
    },
    brackenhide_hollow_rares = {
        [74032] = {questType = 'daily', name = 'Snarglebone'},
        [73985] = {questType = 'daily', name = 'Blisterhide'},
        [73996] = {questType = 'daily', name = 'Gnarls'},
        [74004] = {questType = 'daily', name = 'High Shaman Rotknuckle'},
    },
    knowledge_df_mobs = {
        [70522] = {questType = 'weekly', skillLineID = 165, profession = 'Leatherworking', item = 198975}, --Leatherworking 1
        [70523] = {questType = 'weekly', skillLineID = 165, profession = 'Leatherworking', item = 198976}, --Leatherworking 2
        [73138] = {questType = 'weekly', skillLineID = 165, profession = 'Leatherworking', item = 204232}, --Leatherworking 3
        [70514] = {questType = 'weekly', skillLineID = 333, profession = 'Enchanting', item= 198967}, --Enchanting 1
        [70515] = {questType = 'weekly', skillLineID = 333, profession = 'Enchanting', item= 198968}, --Enchanting 2
        [73136] = {questType = 'weekly', skillLineID = 333, profession = 'Enchanting', item= 204224}, --Enchanting 3
        [70516] = {questType = 'weekly', skillLineID = 202, profession = 'Engineering', item = 198969}, --Engineering 1
        [70517] = {questType = 'weekly', skillLineID = 202, profession = 'Engineering', item = 198970}, --Engineering 2
        [73165] = {questType = 'weekly', skillLineID = 202, profession = 'Engineering', item = 204227}, --Engineering 3
        [70518] = {questType = 'weekly', skillLineID = 773, profession = 'Inscription', item = 198971}, --Inscription 1
        [70519] = {questType = 'weekly', skillLineID = 773, profession = 'Inscription', item = 198972}, --Inscription 2
        [73163] = {questType = 'weekly', skillLineID = 773, profession = 'Inscription', item = 204229}, --Inscription 3
        [70524] = {questType = 'weekly', skillLineID = 197, profession = 'Tailoring', item = 198977}, --Tailoring 1
        [70525] = {questType = 'weekly', skillLineID = 197, profession = 'Tailoring', item = 198978}, --Tailoring 2
        [73153] = {questType = 'weekly', skillLineID = 197, profession = 'Tailoring', item = 204225}, --Tailoring 3
        [70512] = {questType = 'weekly', skillLineID = 164, profession = 'Blacksmithing', item = 198965}, --Blacksmithing 1
        [70513] = {questType = 'weekly', skillLineID = 164, profession = 'Blacksmithing', item = 198966}, --Blacksmithing 2
        [73161] = {questType = 'weekly', skillLineID = 164, profession = 'Blacksmithing', item = 204230}, --Blacksmithing 3
        [70520] = {questType = 'weekly', skillLineID = 755, profession = 'Jewelcrafting', item = 198973}, --Jewelcrafting 1
        [70521] = {questType = 'weekly', skillLineID = 755, profession = 'Jewelcrafting', item = 198974}, --Jewelcrafting 2
        [73168] = {questType = 'weekly', skillLineID = 755, profession = 'Jewelcrafting', item = 204222}, --Jewelcrafting 3
        [70504] = {questType = 'weekly', skillLineID = 171, profession = 'Alchemy', item = 198963}, --Alchemy 1
        [70511] = {questType = 'weekly', skillLineID = 171, profession = 'Alchemy', item = 198964}, --Alchemy 2
        [73166] = {questType = 'weekly', skillLineID = 171, profession = 'Alchemy', item = 204226}, --Alchemy 3
        [71857] = {questType = 'weekly', skillLineID = 182, profession = 'Herbalism'}, --Herbalism 1
        [71858] = {questType = 'weekly', skillLineID = 182, profession = 'Herbalism'}, --Herbalism 2
        [71859] = {questType = 'weekly', skillLineID = 182, profession = 'Herbalism'}, --Herbalism 3
        [71860] = {questType = 'weekly', skillLineID = 182, profession = 'Herbalism'}, --Herbalism 4
        [71861] = {questType = 'weekly', skillLineID = 182, profession = 'Herbalism'}, --Herbalism 5
        [71864] = {questType = 'weekly', skillLineID = 182, profession = 'Herbalism'}, --Herbalism 6
        [70381] = {questType = 'weekly', skillLineID = 393, profession = 'Skinning'}, --Skinning 1
        [70383] = {questType = 'weekly', skillLineID = 393, profession = 'Skinning'}, --Skinning 2
        [70384] = {questType = 'weekly', skillLineID = 393, profession = 'Skinning'}, --Skinning 3
        [70385] = {questType = 'weekly', skillLineID = 393, profession = 'Skinning'}, --Skinning 4
        [70386] = {questType = 'weekly', skillLineID = 393, profession = 'Skinning'}, --Skinning 5
        [70389] = {questType = 'weekly', skillLineID = 393, profession = 'Skinning'}, --Skinning 6
        [72160] = {questType = 'weekly', skillLineID = 186, profession = 'Mining'}, --Mining 1
        [72161] = {questType = 'weekly', skillLineID = 186, profession = 'Mining'}, --Mining 2
        [72162] = {questType = 'weekly', skillLineID = 186, profession = 'Mining'}, --Mining 3
        [72163] = {questType = 'weekly', skillLineID = 186, profession = 'Mining'}, --Mining 4
        [72164] = {questType = 'weekly', skillLineID = 186, profession = 'Mining'}, --Mining 5
        [72165] = {questType = 'weekly', skillLineID = 186, profession = 'Mining'}, --Mining 6
    },
    knowledge_df_treasures = {
        [66375] = {questType = 'weekly', skillLineID = 773, profession = 'Inscription', item = 193904}, --Inscription 1
        [66376] = {questType = 'weekly', skillLineID = 773, profession = 'Inscription', item = 193905}, --Inscription 2
        [66384] = {questType = 'weekly', skillLineID = 165, profession = 'Leatherworking', item = 193910}, --Leatherworking 1
        [66385] = {questType = 'weekly', skillLineID = 165, profession = 'Leatherworking', item = 193913}, --Leatherworking 2
        [66386] = {questType = 'weekly', skillLineID = 197, profession = 'Tailoring', item = 193898}, --Tailoring 1
        [66387] = {questType = 'weekly', skillLineID = 197, profession = 'Tailoring', item = 193899}, --Tailoring 2
        [66377] = {questType = 'weekly', skillLineID = 333, profession = 'Enchanting', item = 193900}, --Enchanting 1
        [66378] = {questType = 'weekly', skillLineID = 333, profession = 'Enchanting', item = 193901}, --Enchanting 2
        [66381] = {questType = 'weekly', skillLineID = 164, profession = 'Blacksmithing', item = 192131}, --Blacksmithing 1
        [66382] = {questType = 'weekly', skillLineID = 164, profession = 'Blacksmithing', item = 192132}, --Blacksmithing 2
        [66379] = {questType = 'weekly', skillLineID = 202, profession = 'Engineering', item = 193902}, --Engineering 1
        [66380] = {questType = 'weekly', skillLineID = 202, profession = 'Engineering', item = 193903}, --Engineering 2
        [66388] = {questType = 'weekly', skillLineID = 755, profession = 'Jewelcrafting', item = 193909}, --Jewelcrafting 1
        [66389] = {questType = 'weekly', skillLineID = 755, profession = 'Jewelcrafting', item = 193907}, --Jewelcrafting 2
        [66373] = {questType = 'weekly', skillLineID = 171, profession = 'Alchemy', item = 193891}, --Alchemy 1
        [66374] = {questType = 'weekly', skillLineID = 171, profession = 'Alchemy', item = 193897}, --Alchemy 2
    },
    knowledge_df_treatise = {
        [74105] = {questType = 'weekly', skillLineID = 773, profession = 'Inscription'}, -- Inscription
        [74106] = {questType = 'weekly', skillLineID = 186, profession = 'Mining'}, -- Mining
        [74107] = {questType = 'weekly', skillLineID = 182, profession = 'Herbalism'}, -- Herbalism
        [74108] = {questType = 'weekly', skillLineID = 171, profession = 'Alchemy'}, -- Alchemy
        [74109] = {questType = 'weekly', skillLineID = 164, profession = 'Blacksmithing'}, -- Blacksmithing
        [74110] = {questType = 'weekly', skillLineID = 333, profession = 'Enchanting'}, -- Enchanting
        [74111] = {questType = 'weekly', skillLineID = 202, profession = 'Engineering'}, -- Engineering
        [74112] = {questType = 'weekly', skillLineID = 755, profession = 'Jewelcrafting'}, -- Jewelcrafting
        [74113] = {questType = 'weekly', skillLineID = 165, profession = 'Leatherworking'}, -- Leatherworking
        [74114] = {questType = 'weekly', skillLineID = 393, profession = 'Skinning'}, -- Skinning
        [74115] = {questType = 'weekly', skillLineID = 197, profession = 'Tailoring'}, -- Tailoring
    },
    knowledge_df_weeklies_craft = {
        [70558] = {questType = 'weekly', log = true}, -- Inscription 1
        [70559] = {questType = 'weekly', log = true}, -- Inscription 2
        [70560] = {questType = 'weekly', log = true}, -- Inscription 3
        [70561] = {questType = 'weekly', log = true}, -- Inscription 4
        [70567] = {questType = 'weekly', log = true}, -- Leatherworking 1
        [70568] = {questType = 'weekly', log = true}, -- Leatherworking 2
        [70569] = {questType = 'weekly', log = true}, -- Leatherworking 3
        [70571] = {questType = 'weekly', log = true}, -- Leatherworking 4
        [70572] = {questType = 'weekly', log = true}, -- Tailoring 1
        [70582] = {questType = 'weekly', log = true}, -- Tailoring 2
        [70586] = {questType = 'weekly', log = true}, -- Tailoring 3
        [70587] = {questType = 'weekly', log = true}, -- Tailoring 4
        [72155] = {questType = 'weekly', log = true}, -- Enchanting 1
        [72172] = {questType = 'weekly', log = true}, -- Enchanting 2
        [72175] = {questType = 'weekly', log = true}, -- Enchanting 3
        [72173] = {questType = 'weekly', log = true}, -- Enchanting 4
        [70233] = {questType = 'weekly', log = true}, -- Blacksmithing 1
        [70234] = {questType = 'weekly', log = true}, -- Blacksmithing 2
        [70235] = {questType = 'weekly', log = true}, -- Blacksmithing 3
        [70211] = {questType = 'weekly', log = true}, -- Blacksmithing 4
        [70540] = {questType = 'weekly', log = true}, -- Engineering 1
        [70545] = {questType = 'weekly', log = true}, -- Engineering 2
        [70557] = {questType = 'weekly', log = true}, -- Engineering 3
        [70539] = {questType = 'weekly', log = true}, -- Engineering 4
        [70562] = {questType = 'weekly', log = true}, -- Jewelcrafting 1
        [70563] = {questType = 'weekly', log = true}, -- Jewelcrafting 2
        [70564] = {questType = 'weekly', log = true}, -- Jewelcrafting 3
        [70565] = {questType = 'weekly', log = true}, -- Jewelcrafting 4
        [70531] = {questType = 'weekly', log = true}, -- Alchemy 1
        [70532] = {questType = 'weekly', log = true}, -- Alchemy 2
        [70533] = {questType = 'weekly', log = true}, -- Alchemy 3
        [70530] = {questType = 'weekly', log = true}, -- Alchemy 4
    },
    knowledge_df_weeklies_loot = {
        [66943] = {questType = 'weekly', log = true}, -- Inscription 5
        [66944] = {questType = 'weekly', log = true}, -- Inscription 6
        [66945] = {questType = 'weekly', log = true}, -- Inscription 7
        [72438] = {questType = 'weekly', log = true}, -- Inscription 8
        [66363] = {questType = 'weekly', log = true}, -- Leatherworking 5
        [66364] = {questType = 'weekly', log = true}, -- Leatherworking 6
        [66951] = {questType = 'weekly', log = true}, -- Leatherworking 7
        [72407] = {questType = 'weekly', log = true}, -- Leatherworking 8
        [66899] = {questType = 'weekly', log = true}, -- Tailoring 5
        [66952] = {questType = 'weekly', log = true}, -- Tailoring 6
        [66953] = {questType = 'weekly', log = true}, -- Tailoring 7
        [72410] = {questType = 'weekly', log = true}, -- Tailoring 8
        [66884] = {questType = 'weekly', log = true}, -- Enchanting 5
        [66900] = {questType = 'weekly', log = true}, -- Enchanting 6
        [66935] = {questType = 'weekly', log = true}, -- Enchanting 7
        [72423] = {questType = 'weekly', log = true}, -- Enchanting 8
        [66517] = {questType = 'weekly', log = true}, -- Blacksmithing 5
        [66941] = {questType = 'weekly', log = true}, -- Blacksmithing 6
        [72398] = {questType = 'weekly', log = true}, -- Blacksmithing 7
        [66897] = {questType = 'weekly', log = true}, -- Blacksmithing 8
        [66891] = {questType = 'weekly', log = true}, -- Engineering 5
        [66890] = {questType = 'weekly', log = true}, -- Engineering 6
        [66942] = {questType = 'weekly', log = true}, -- Engineering 7
        [72396] = {questType = 'weekly', log = true}, -- Engineering 8
        [73165] = {questType = 'weekly', log = true}, -- Engineering 9
        [66516] = {questType = 'weekly', log = true}, -- Jewelcrafting 5
        [66949] = {questType = 'weekly', log = true}, -- Jewelcrafting 6
        [66950] = {questType = 'weekly', log = true}, -- Jewelcrafting 7
        [72428] = {questType = 'weekly', log = true}, -- Jewelcrafting 8
        [66937] = {questType = 'weekly', log = true}, -- Alchemy 5
        [66938] = {questType = 'weekly', log = true}, -- Alchemy 6
        [66940] = {questType = 'weekly', log = true}, -- Alchemy 7
        [72427] = {questType = 'weekly', log = true}, -- Alchemy 8
        [70613] = {questType = 'weekly', log = true}, -- Herbalism 5
        [70614] = {questType = 'weekly', log = true}, -- Herbalism 6
        [70615] = {questType = 'weekly', log = true}, -- Herbalism 7
        [70616] = {questType = 'weekly', log = true}, -- Herbalism 8
        --[71970] = {questType = 'weekly', log = true}, -- Herbalism 8
        --[71857] = {questType = 'weekly', log = true}, -- Herbalism 8
        [70620] = {questType = 'weekly', log = true}, -- Skinning 5
        [72159] = {questType = 'weekly', log = true}, -- Skinning 6
        [70619] = {questType = 'weekly', log = true}, -- Skinning 7
        [72158] = {questType = 'weekly', log = true}, -- Skinning 8
        [72157] = {questType = 'weekly', log = true}, -- Mining 5
        [70617] = {questType = 'weekly', log = true}, -- Mining 6
        [70618] = {questType = 'weekly', log = true}, -- Mining 7
        [72156] = {questType = 'weekly', log = true}, -- Mining 8
        --[66936] = {questType = 'weekly', log = true}, -- Mining 8
        [75354] = {questType = 'weekly', log = true}, -- Leatherworking
        [75368] = {questType = 'weekly', log = true}, -- Leatherworking
        [77945] = {questType = 'weekly', log = true}, -- Leatherworking
        [77946] = {questType = 'weekly', log = true}, -- Leatherworking
        [75150] = {questType = 'weekly', log = true}, -- Enchanting
        [75865] = {questType = 'weekly', log = true}, -- Enchanting
        [77910] = {questType = 'weekly', log = true}, -- Enchanting
        [77937] = {questType = 'weekly', log = true}, -- Enchanting
        [75148] = {questType = 'weekly', log = true}, -- Blacksmithing
        [75569] = {questType = 'weekly', log = true}, -- Blacksmithing
        [77935] = {questType = 'weekly', log = true}, -- Blacksmithing
        [77936] = {questType = 'weekly', log = true}, -- Blacksmithing
        [75575] = {questType = 'weekly', log = true}, -- Engineering
        [75608] = {questType = 'weekly', log = true}, -- Engineering
        [77891] = {questType = 'weekly', log = true}, -- Engineering
        [77938] = {questType = 'weekly', log = true}, -- Engineering
        [75149] = {questType = 'weekly', log = true}, -- Inscription
        [75573] = {questType = 'weekly', log = true}, -- Inscription
        [77889] = {questType = 'weekly', log = true}, -- Inscription
        [77914] = {questType = 'weekly', log = true}, -- Inscription
        [75407] = {questType = 'weekly', log = true}, -- Tailoring
        [75600] = {questType = 'weekly', log = true}, -- Tailoring
        [77947] = {questType = 'weekly', log = true}, -- Tailoring
        [77949] = {questType = 'weekly', log = true}, -- Tailoring
        [75362] = {questType = 'weekly', log = true}, -- Jewelcrafting
        [75602] = {questType = 'weekly', log = true}, -- Jewelcrafting
        [77892] = {questType = 'weekly', log = true}, -- Jewelcrafting
        [77912] = {questType = 'weekly', log = true}, -- Jewelcrafting
        [75363] = {questType = 'weekly', log = true}, -- Alchemy
        [75371] = {questType = 'weekly', log = true}, -- Alchemy
        [77932] = {questType = 'weekly', log = true}, -- Alchemy
        [77933] = {questType = 'weekly', log = true}, -- Alchemy
    },
    knowledge_df_weeklies_order = {
        [70589] = {questType = 'weekly', log = true}, -- Blacksmithing 0
        [70591] = {questType = 'weekly', log = true}, -- Engineering 0
        [70592] = {questType = 'weekly', log = true}, -- Inscription 0
        [70593] = {questType = 'weekly', log = true}, -- Jewelcrafting 0
        [70594] = {questType = 'weekly', log = true}, -- Leatherworking 0
        [70595] = {questType = 'weekly', log = true}, -- Tailoring 0
    },
    community_feast = {
        [74097] = {questType = 'daily'},
    },
    iskaara_story = {
        [72291] = {questType = 'weekly', log = true},
    },
    obsidian_citadel_rares = {
        [72127] = {questType = 'daily', name = 'Captain Lancer'},
        [73072] = {questType = 'daily', name = 'Enkine the Voracious'},
        [74067] = {questType = 'daily', name = 'Morchok'},
        [74054] = {questType = 'daily', name = 'Turboris'},
        [74043] = {questType = 'daily', name = 'Char'},
        [74040] = {questType = 'daily', name = 'Battlehorn Pyrhus'},
        [74042] = {questType = 'daily', name = 'Cauldronbreaker Blakor'},
        [74052] = {questType = 'daily', name = 'Rohzor Forgesmash'},
    },
    tyrhold_rares = {
        [74055] = {questType = 'daily', name = 'Ancient Protector'},
    },
    iskaara_fishing_dailies = {
        [70438] = {questType = 'daily', log = true},
        [70450] = {questType = 'daily', log = true},
        [71191] = {questType = 'daily', log = true},
        [71194] = {questType = 'daily', log = true},
        [72069] = {questType = 'daily', log = true},
        [72075] = {questType = 'daily', log = true},

    },
    community_feast_weekly = {
        [70893] = {questType = 'weekly', log = true},
    },
    dragonbane_keep_siege = {
        [70866] = {questType = 'weekly'},
    },
    dragonbane_keep_key = {
        [66805] = {questType = 'weekly', log = true},
        [66133] = {questType = 'weekly', log = true},
    },
    dragonbane_keep_weeklies = {
        [65842] = {questType = 'weekly', log = true},
        [66103] = {questType = 'weekly', log = true},
        [66308] = {questType = 'weekly', log = true},
        [66321] = {questType = 'weekly', log = true},
        [66326] = {questType = 'weekly', log = true},
        [66445] = {questType = 'weekly', log = true},
        [66449] = {questType = 'weekly', log = true},
        [66633] = {questType = 'weekly', log = true},
        [66926] = {questType = 'weekly', log = true},
        [67051] = {questType = 'weekly', log = true},
        [67099] = {questType = 'weekly', log = true},
        [67142] = {questType = 'weekly', log = true},
        [69918] = {questType = 'weekly', log = true},
        [70848] = {questType = 'weekly', log = true},
        [72447] = {questType = 'weekly', log = true},
        [72448] = {questType = 'weekly', log = true},
    },
    show_your_mettle = {
        [70221] = {questType = 'weekly', log = true},
    },
    fish_turnins_df = {
        [72828] = {questType = 'weekly', name = '|T1387373:0|t[Scalebelly Mackerel]'},
        [72823] = {questType = 'weekly', name = '|T4554376:0|t[Islefin Dorado]'},
        [72827] = {questType = 'weekly', name = '|T4554372:0|t[Thousandbite Piranha]'},
        [72826] = {questType = 'weekly', name = '|T4539689:0|t[Aileron Seamoth]'},
        [72825] = {questType = 'weekly', name = '|T4539687:0|t[Cerulean Spinefish]'},
        [72824] = {questType = 'weekly', name = '|T4554371:0|t[Temporal Dragonhead]'},
    },
    forbidden_reach_weeklies = {
        [72952] = {questType = 'weekly', log = true},
        [73140] = {questType = 'weekly', log = true},
        [73141] = {questType = 'weekly', log = true},
        [73142] = {questType = 'weekly', log = true},
        [73179] = {questType = 'weekly', log = true},
        [73190] = {questType = 'weekly', log = true},
        [73191] = {questType = 'weekly', log = true},
        [73194] = {questType = 'weekly', log = true},
        [73715] = {questType = 'weekly', log = true},
        [74282] = {questType = 'weekly', log = true},
        [74284] = {questType = 'weekly', log = true},
        [74293] = {questType = 'weekly', log = true},
        [74379] = {questType = 'weekly', log = true},
        [75024] = {questType = 'weekly', log = true},
        [75025] = {questType = 'weekly', log = true},
    },
    forbidden_reach_task_picked = {
        [74908] = {questType = 'daily', log = true}, -- Dragonscale Expedition
        [74909] = {questType = 'daily', log = true}, -- Iskaara Tuskarr
        [74910] = {questType = 'daily', log = true}, -- Maruuk Centaur
        [74911] = {questType = 'daily', log = true}, -- Valdrakken Akkord
    },
    forbidden_reach_tasks = {
        [74118] = {questType = 'daily', log = true}, -- Dragonscale Expedition
        [74389] = {questType = 'daily', log = true}, -- Dragonscale Expedition
        [74119] = {questType = 'daily', log = true}, -- Iskaara Tuskarr
        [74391] = {questType = 'daily', log = true}, -- Iskaara Tuskarr
        [74117] = {questType = 'daily', log = true}, -- Maruuk Centaur
        [74390] = {questType = 'daily', log = true}, -- Maruuk Centaur
        [75261] = {questType = 'daily', log = true}, -- Valdrakken Akkord
        [75263] = {questType = 'daily', log = true}, -- Valdrakken Akkord
    },
    forbidden_reach_elite_wqs = {
        [75257] = {questType = 'weekly', log = true}, -- The War Creche
    },
    glimerogg_racer_dailies = {
        [74514] = {questType = 'weekly', log = true}, -- The Slowest Fan Club
        [74515] = {questType = 'weekly', log = true}, -- Snail Mail
        [74516] = {questType = 'weekly', log = true}, -- A Snail's Pace
        [74517] = {questType = 'weekly', log = true}, -- All Terrain Snail
        [74518] = {questType = 'weekly', log = true}, -- Resistance Training
        [74519] = {questType = 'weekly', log = true}, -- Good for Goo
        [74520] = {questType = 'weekly', log = true}, -- Less Cargo
    },
    loamm_niffen_weekly = {
        [75665] = {questType = 'weekly', log = true},
    },
    researchers_under_fire_weekly = {
        [75627] = {questType = 'weekly'},
        [75628] = {questType = 'weekly'},
        [75629] = {questType = 'weekly'},
        [75630] = {questType = 'weekly'},
    },
    zc_wb_wq = {
        [74892] = {questType = 'weekly', log = true}, -- Zaqali Elders
    },
    dig_maps_weeklies = {
        [75747] = {questType = 'weekly'},
        [75748] = {questType = 'weekly'},
        [75749] = {questType = 'weekly'},
    },
    dig_maps_received_weekly = {
        [76077] = {questType = 'weekly'},
        [75665] = {questType = 'weekly'},
    },
    proven_weekly = {
        [72166] = {questType = 'weekly', log = true},
        [72167] = {questType = 'weekly', log = true},
        [72168] = {questType = 'weekly', log = true},
        [72169] = {questType = 'weekly', log = true},
        [72170] = {questType = 'weekly', log = true},
        [72171] = {questType = 'weekly', log = true},
    },
    fyrak_assault = {
        [75467] = {questType = 'weekly'},
    },
    zyrak_cavern_zone_events = {
        [75664] = {questType = 'weekly', forceUpdate = true},
        [75156] = {questType = 'weekly', forceUpdate = true},
        [75471] = {questType = 'weekly', forceUpdate = true},
        [75222] = {questType = 'weekly', forceUpdate = true},
        [75370] = {questType = 'weekly', forceUpdate = true},
        [75441] = {questType = 'weekly', forceUpdate = true},
        [75611] = {questType = 'weekly', forceUpdate = true},
        [75624] = {questType = 'weekly', forceUpdate = true},
        [75612] = {questType = 'weekly', forceUpdate = true},
        [75454] = {questType = 'weekly', forceUpdate = true},
        [75455] = {questType = 'weekly', forceUpdate = true},
        [75450] = {questType = 'weekly', forceUpdate = true},
        [75451] = {questType = 'weekly', forceUpdate = true},
        [75461] = {questType = 'weekly', forceUpdate = true},
        [74352] = {questType = 'weekly', forceUpdate = true},
        [75478] = {questType = 'weekly', forceUpdate = true},
        [75494] = {questType = 'weekly', forceUpdate = true},
        [75705] = {questType = 'weekly', forceUpdate = true},
    },
    time_rift = {
        [77236] = {questType = 'weekly', log = true},
    },
    time_rift_pod = {
        [77836] = {questType = 'weekly'}
    },
    dreamsurge_weekly = {
        [77251] = {questType = 'weekly', log = true},
    },
    ed_wb_wq = {
        [76367] = {questType = 'weekly', log = true}, -- Aurostor
    },
    dream_wardens_weekly = {
        [78444] = {questType = 'weekly', log = true},
    },
    superbloom = {
        [78319] = {questType = 'weekly', log = true},
    },
    dream_shipments = {
        [78427] = {questType = 'weekly', log = true},
        [78428] = {questType = 'weekly', log = true},
    },
    anniversary_wb = {
        [47461] = {questType = 'daily', name = "Kazzak"}, -- Kazzak
        [47462] = {questType = 'daily', name = "Azuregos"}, -- Azuregos
        [47463] = {questType = 'daily', name = "Dragons of Nightmare"}, -- Dragons of Nightmare
        [60214] = {questType = 'daily', name = "Doomwalker"}, -- Doomwalker
    },
    big_dig = {
        [79226] = {questType = 'weekly', warband = true, log = true},
    },

    -- 11.0 PREPATCH
    radiant_echoes_prepatch_weeklies = {
        [82689] = {questType = 'weekly', log = true, name = "Dragonblight (Lich King)"}, --name = 'Only Darkness'},
        [82676] = {questType = 'weekly', log = true, name = "Dustwallow Marsh (Onyxia)"}, --name = 'Broken Masquerade'},
        [78938] = {questType = 'weekly', log = true, name = "Searing Gorge (Ragnaros)"}, --name = 'Champion of the Waterlords'},
    },
}

PermoksAccountManager.locale = {
    currency = {
        ['renown'] = C_CurrencyInfo.GetBasicCurrencyInfo(1822).name,
        ['soul_ash'] = C_CurrencyInfo.GetBasicCurrencyInfo(1828).name,
        ['stygia'] = C_CurrencyInfo.GetBasicCurrencyInfo(1767).name,
        ['reservoir_anima'] = C_CurrencyInfo.GetBasicCurrencyInfo(1813).name,
        ['redeemed_soul'] = C_CurrencyInfo.GetBasicCurrencyInfo(1810).name,
        ['conquest'] = C_CurrencyInfo.GetBasicCurrencyInfo(1602).name,
        ['honor'] = C_CurrencyInfo.GetBasicCurrencyInfo(1792).name,
        ['valor'] = C_CurrencyInfo.GetBasicCurrencyInfo(1191).name
    },
    raids = {
        nathria = {
            ['deDE'] = 'Castle Nathria',
            ['enUS'] = 'Castle Nathria',
            ['enGB'] = 'Castle Nathria',
            ['esES'] = 'Castle Nathria',
            ['esMX'] = 'Castle Nathria',
            ['frFR'] = 'Castle Nathria',
            ['itIT'] = 'Castle Nathria'
        }
    }
}

PermoksAccountManager.sanctum = {
    [1] = {
        [1] = 312, -- Anima Conductor
        [2] = 308, -- Transport Network
        [3] = 316, -- Command Table
        --[4] = 327, -- Resevoir Upgrades
        [5] = 320 -- Path of Ascension
    },
    [2] = {
        [1] = 314, -- Anima Conductor
        [2] = 309, -- Transport Network
        [3] = 317, -- Command Table
        --[4] = 326, -- Resevoir Upgrades
        [5] = 324 -- Ember Court
    },
    [3] = {
        [1] = 311, -- Anima Conductor
        [2] = 307, -- Transport Network
        [3] = 315, -- Command Table
        --[4] = 328, -- Resevoir Upgrades
        [5] = 319 -- The Queen's Conservatory
    },
    [4] = {
        [1] = 313, -- Anima Conductor
        [2] = 310, -- Transport Network
        [3] = 318, -- Command Table
        --[4] = 329, -- Resevoir Upgrades
        [5] = 321 -- Abomination Factory
    }
}

function PermoksAccountManager:getDefaultCategories()
    return default_categories
end

PermoksAccountManager.vault_rewards = {
    -- MythicPlus
    [Enum.WeeklyRewardChestThresholdType.Activities] = {
        [-1] = 489,
        [0] = 506,
        [2] = 509,
        [3] = 509,
        [4] = 512,
        [5] = 512,
        [6] = 515,
        [7] = 515,
        [8] = 519,
        [9] = 519,
        [10] = 522,
    },
    -- RankedPvP
    [Enum.WeeklyRewardChestThresholdType.RankedPvP] = {
        [0] = 445,
        [1] = 455,
        [2] = 460,
        [3] = 465,
        [4] = 470,
        [5] = 475,
		[6] = 458,
		[7] = 464,
		[8] = 471
    },
    -- Raid
    [Enum.WeeklyRewardChestThresholdType.Raid] = {
        [17] = 480,
        [14] = 493,
        [15] = 506,
        [16] = 519,
    }
}

PermoksAccountManager.ICONSTRINGS = {
    left = '\124T%d:18:18\124t %s',
    right = '%s \124T%d:18:18\124t'
}

PermoksAccountManager.ICONBANKSTRINGS = {
    left = '\124T%d:18:18\124t %s (%s)',
    right = '%s (%s) \124T%d:18:18\124t'
}

PermoksAccountManager.encounterOrder = {
	[2393] = 1, [2429] = 2, [2422] = 3, [2428] = 4, [2418] = 5, [2420] = 6, [2426] = 7, [2394] = 8, [2425] = 9, [2424] = 10,
	[2435] = 11, [2442] = 12, [2439] = 13, [2445] = 14, [2444] = 15, [2443] = 16, [2446] = 17, [2447] = 18, [2440] = 19, [2441] = 20,
	[2458] = 21, [2459] = 22, [2470] = 23, [2460] = 24, [2465] = 25, [2463] = 26, [2461] = 27, [2469] = 28, [2457] = 29, [2467] = 30, [2464] = 31,
}
