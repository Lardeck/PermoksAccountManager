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
		[60732] = {key = "maw"},
		[61334] = {key = "maw"},
		[62239] = {key = "maw"},
		[63031] = {key = "maw"},
		[63038] = {key = "maw"},	
		[63039] = {key = "maw"},
		[63040] = {key = "maw"},
		[63043] = {key = "maw"},
		[63045] = {key = "maw"},
		[63047] = {key = "maw"},
		[63050] = {key = "maw"},
		[63062] = {key = "maw"},
		[63069] = {key = "maw"},
		[63072] = {key = "maw"},
		[63100] = {key = "maw"},
		[63179] = {key = "maw"},

		-- Kyrian
		-- Venthyr
		-- Night Fae
		[62614] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 1},
		[62615] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 1},
		[62611] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 1},
		[62610] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 1},
		[62606] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 1},
		[62608] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 1},
		[60175] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 1},
		[62607] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 1},
		[62453] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 2},
		[62296] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 2},
		[60153] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 2},
		[62382] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 2},
		[62263] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 3},
		[62459] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 3},
		[62466] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 3},
		[60188] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 3},
		[62465] = {covenant = 3, key = "nfTransport", sanctum = 2, minSanctumTier = 3},

		[61691] = {covenant = 3, key = "conductor", sanctum = 1, minSanctumTier = 1, addToMax = 1}, -- Large Lunarlight Pod
		[61633] = {covenant = 3, key = "conductor", sanctum = 1, minSanctumTier = 1, addToMax = 1}, -- Dreamsong Fenn
		-- Necrolords
		[58872] = {covenant = 4, key = "conductor", sanctum = 1, minSanctumTier = 1, addToMax = 1}, -- Gieger
		[61647] = {covenant = 4, key = "conductor", sanctum = 1, minSanctumTier = 1, addToMax = 1}, -- Chosen Runecoffer
	},
	weekly = {
		[61332] = {covenant = 1, key = "souls"}, -- kyrian 5 souls
		[62861] = {covenant = 1, key = "souls"}, -- kyrian 10 souls
		[62862] = {covenant = 1, key = "souls"}, -- kyrian 15 souls
		[62863] = {covenant = 1, key = "souls"}, -- kyrian 20 souls
		[61334] = {covenant = 2, key = "souls"}, -- venthyr 5 souls
		[62867] = {covenant = 2, key = "souls"}, -- venthyr 10 souls
		[62868] = {covenant = 2, key = "souls"}, -- venthyr 15 souls
		[62869] = {covenant = 2, key = "souls"}, -- venthyr 20 souls
		[61331] = {covenant = 3, key = "souls"}, -- night fae 5 souls
		[62858] = {covenant = 3, key = "souls"}, -- night fae 10 souls
		[62859] = {covenant = 3, key = "souls"}, -- night fae 15 souls
		[62860] = {covenant = 3, key = "souls"}, -- night fae 20 souls
		[61333] = {covenant = 4, key = "souls"}, -- necro 5 souls
		[62864] = {covenant = 4, key = "souls"}, -- necro 10 souls
		[62865] = {covenant = 4, key = "souls"}, -- necro 15 souls
		[62866] = {covenant = 4, key = "souls"}, -- necro 20 souls

		[61982] = {covenant = 1, key = "anima"}, -- kyrian 1k anima
		[61981] = {covenant = 2, key = "anima"}, -- venthyr 1k anima
		[61984] = {covenant = 3, key = "anima"}, -- night fae 1k anima
		[61983] = {covenant = 4, key = "anima"}, -- necro 1k anima

		[60242] = {key = "dungeon"}, -- Trading Favors: Necrotic Wake
		[60243] = {key = "dungeon"}, -- Trading Favors: Sanguine Depths
		[60244] = {key = "dungeon"}, -- Trading Favors: Halls of Atonement
		[60245] = {key = "dungeon"}, -- Trading Favors: The Other Side
		[60246] = {key = "dungeon"}, -- Trading Favors: Tirna Scithe
		[60247] = {key = "dungeon"}, -- Trading Favors: Theater of Pain
		[60248] = {key = "dungeon"}, -- Trading Favors: Plaguefall
		[60249] = {key = "dungeon"}, -- Trading Favors: Spires of Ascension
		[60250] = {key = "dungeon"}, -- A Valuable Find: Theater of Pain
		[60251] = {key = "dungeon"}, -- A Valuable Find: Plaguefall
	 	[60252] = {key = "dungeon"}, -- A Valuable Find: Spires of Ascension
	 	[60253] = {key = "dungeon"}, -- A Valuable Find: Necrotic Wake
	 	[60254] = {key = "dungeon"}, -- A Valuable Find: Tirna Scithe
	 	[60255] = {key = "dungeon"}, -- A Valuable Find: The Other Side
	 	[60256] = {key = "dungeon"}, -- A Valuable Find: Halls of Atonement
	 	[60257] = {key = "dungeon"}, -- A Valuable Find: Sanguine Depths

	 	-- Maw Warth of the Jailer
	 	[63414] = {key = "wrath"}, -- Wrath of the Jailer

	 	-- Maw Hunt
	 	[63195] = {key = "hunt"},
	 	[63198] = {key = "hunt"},
	 	[63199] = {key = "hunt"},
	 	[63433] = {key = "hunt"},

	 	-- Maw Weekly
	 	[60622] = {key = "maw"},
	 	[60646] = {key = "maw"},
	 	[60762] = {key = "maw"},
	 	[60775] = {key = "maw"},
	 	[60902] = {key = "maw"},
	 	[61075] = {key = "maw"},
	 	[61079] = {key = "maw"},
	 	[61088] = {key = "maw"},
	 	[61103] = {key = "maw"},
	 	[61104] = {key = "maw"},
	 	[61765] = {key = "maw"},
	 	[62214] = {key = "maw"},
	 	[62234] = {key = "maw"},
	 	[63206] = {key = "maw"},

	 	-- World Boss
	 	[61813] = {key = "wb"}, -- Valinor - Bastion
	 	[61814] = {key = "wb"}, -- Nurghash - Revendreth
	 	[61815] = {key = "wb"}, -- Oranomonos - Ardenweald
	 	[61816] = {key = "wb"}, -- Mortanis - Maldraxxus

	 	-- PVP Weekly
	 	[62284] = {key = "pvp"}, -- Random BGs
	 	[62285] = {key = "pvp"}, -- Epic BGs
	 	[62286] = {key = "pvp"},
	 	[62287] = {key = "pvp"},
	 	[62288] = {key = "pvp"},
	 	[62289] = {key = "pvp"},

	 	-- Weekend Event
	 	[62631] = {key = "weekend"}, -- World Quests
	 	[62632] = {key = "weekend"}, -- BC Timewalking
	 	[62633] = {key = "weekend"}, -- WotLK Timewalking
	 	[62634] = {key = "weekend"}, -- Cata Timewalking
	 	[62635] = {key = "weekend"}, -- MOP Timewalking
	 	[62636] = {key = "weekend"}, -- Draenor Timewalking
	 	[62637] = {key = "weekend"}, -- Battleground Event
	 	[62638] = {key = "weekend"}, -- Mythuc Dungeon Event
	 	[62639] = {key = "weekend"}, -- Pet Battle Event
	 	[62640] = {key = "weekend"}, -- Arena Event
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

local lCurrency = AltManager.locale.currency
local lRaid = AltManager.locale.raids
AltManager.columns_table = {
	name = {
		order = 0.05,
		label = "Name",
		enabled = function() return true end,
		hideOption = true,
		data = function(alt_data) return alt_data.name end,
		color = function(alt_data) return RAID_CLASS_COLORS[alt_data.class] end,
	},
	ilevel = {
		order = 0.1,
		fakeLabel = true,
		enabled = function() return true end,
		hideOption = true,
		data = function(alt_data) return string.format("%.2f", alt_data.ilevel or 0) end,
		justify = "TOP",
		font = "Fonts\\FRIZQT__.TTF",
	},
	gold = {
		order = 0.15,
		label = "Gold",
		enabled = function(option, key) return option[key].enabled end,
		option = "gold",
		data = function(alt_data) return alt_data.gold and alt_data.gold or 0 end,
	},
	weekly_key = {
		order = 0.2,
		label = "Highest Key",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateWeeklyString(alt_data.vaultInfo.MythicPlus) or "-" end,
	},
	keystone = {
		order = 0.25,
		label = "Keystone",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (AltManager.keys[alt_data.dungeon] or alt_data.dungeon) .. " +" .. tostring(alt_data.level) end,
	},
	soul_ash = {
		order = 0.3,
		label = lCurrency.soul_ash,
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1828], false, true)) or "-" end,
	},
	stygia = {
		order = 0.35,
		label = lCurrency.stygia,
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1767])) or "-" end,
	},
	conquest = {
		order = 0.4,
		label = lCurrency.conquest,
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1602) end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1602], nil, nil, true)) or "-" end,
	},
	honor = {
		order = 0.45,
		label = lCurrency.honor,
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1792) end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1792], true, true)) or "-" end,
	},
	valor = {
		order = 0.46,
		label = lCurrency.valor,
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1191) end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1191], nil, nil, true)) or "-" end,
	},
	contract = {
		order = 0.5,
		label = "Contract",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.contract and AltManager:CreateContractString(alt_data.contract) or "-" end,
	},
	daily_unroll = {
		order = 1,
		data = "unroll",
		button_pos = 0,
		name = "Daily >",
		unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Daily",  AltManager.db.global.options.daily_unroll) end,
		enabled = function(option, key) return option[key].enabled end,
		unroll_name = "Daily",
		rows = {
			--[[daily_heroic = {
				order = 0.5,
				label = "Daily Heroic",
				data = function(alt_data) return alt_data.daily_heroic and "|cff00ff00+|r" or "\45" end,
			},
			rnd_bg = {
				order = 1,
				label = "Random BG",
				data = function(alt_data) return (alt_data.rnd_bg==true and "|cff00ff00+|r") or "\45" end,
			},
			seperator1 = {
				order = 1.1,
				data = function(alt_data) return "" end,
			},]]
			callings = {
				order = 1,
				label = "Callings",
				enabled = function(option, key) return option[key].enabled end,
				tooltip = function(button, alt_data) AltManager:CallingTooltip_OnEnter(button, alt_data) end,
				data = function(alt_data) return AltManager:CreateCallingString(alt_data.callingInfo) end,
			},
			maw_dailies = {
				order = 1.1, 
				label = "Maw Dailies",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.daily.maw, alt_data.questInfo.maxMawQuests or 2)) or "-" end,
			},
			eye_of_the_jailer = {
				order = 1.2,
				label = "Eye of the Jailer",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.jailerInfo and AltManager:CreateJailerString(alt_data.jailerInfo)) or "-" end,
			},
			seperator1 = {
				order = 1.9,
				enabled = function(option, key) 
					local isLabelBefore = (option.callings.enabled or option.maw_dailies.enabled or option.eye_of_the_jailer.enabled)
					local isLabelAfter = (option.sanctum.enabled)
					return isLabelBefore and isLabelAfter
				end,
				data = function() return "" end,
			},
			sanctum = {
				order = 2,
				label = "Covenant Specific",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) 
					if alt_data.covenant then
						local covenant = alt_data.covenant
						local rightFeatureType = (covenant == 3 and 2) or (covenant == 4 and 5) or 0
						return (alt_data.questInfo and AltManager:CreateSanctumString(alt_data.sanctumInfo, rightFeatureType, alt_data.questInfo.daily.nfTransport, alt_data.questInfo.maxnfTransport or 1)) or "-" 
					else
						return "-"
					end
				end,
			},
			conductor = {
				order = 2.1,
				label = "Conductor (NYI)",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return "-" end,
			},
		}		
	},		
	weekly_unroll = {
		order = 2,
		data = "unroll",
		button_pos = 0,
		name = "Weekly >",
		unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Weekly", AltManager.db.global.options.weekly_unroll) end,
		enabled = function(option, key) return option[key].enabled end,
		unroll_name = "Weekly",
		rows = {
			great_vault_mplus = {
				order = 1,
				label = "Vault M+",
				enabled = function(option, key) return option[key].enabled end,
				tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "MythicPlus") end,
				data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.MythicPlus) or "-" end,
			},
			great_vault_raid = {
				order = 1.1,
				label = "Vault Raid",
				enabled = function(option, key) return option[key].enabled end,
				tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "Raid") end,
				data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.Raid) or "-" end,
			},
			great_vault_pvp = {
				order = 1.2,
				label = "Vault PVP",
				enabled = function(option, key) return option[key].enabled end,
				tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "RankedPvP") end,
				data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.RankedPvP) or "-" end,
			},
			seperator1 = {
				order = 1.5,
				enabled = function(option, key) 
					local isLabelBefore = (option.great_vault_mplus.enabled or option.great_vault_raid.enabled or option.great_vault_pvp.enabled)
					local isLabelAfter = (option.mythics_done.enabled or option.dungeon_quests.enabled or option.world_boss.enabled or option.anima.enabled or option.maw_souls.enabled or option.pvp_quests.enabled)
					return isLabelBefore and isLabelAfter
				end,
				data = function() return "" end,
			},
			mythics_done = {
				label = "Mythic+0",
				enabled = function(option, key) return option[key].enabled end,
				tooltip = function(button, alt_data) AltManager:DungeonTooltip_OnEnter(button, alt_data) end,
				order = 2,
				data = function(alt_data) return alt_data.instanceInfo and AltManager:CreateDungeonString(alt_data.instanceInfo.dungeons) or "-" end
			},
			dungeon_quests = {
				label = "Dungeon Quests",
				enabled = function(option, key) return option[key].enabled end,
				order = 2.1,
				data = function(alt_data) return alt_data.questInfo and  AltManager:CreateQuestString(alt_data.questInfo.weekly.dungeon, 2) or "-" end,
			},
			pvp_quests = {
				label = "PVP Quests",
				enabled = function(option, key) return option[key].enabled end,
				order = 2.2,
				data = function(alt_data) return alt_data.questInfo and  AltManager:CreateQuestString(alt_data.questInfo.weekly.pvp, 2) or "-" end,
			},
			weekend_event = {
				label = "Weekend Event",
				enabled = function(option, key) return option[key].enabled end,
				order = 2.3,
				data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.weekend, 1, true) or "-" end,
			},
			world_boss = {
				label = "World Boss",
				enabled = function(option, key) return option[key].enabled end,
				order = 2.4,
				data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.wb, 1, true) or "-" end,
			},
			anima = {
				label = "1k Anima",
				enabled = function(option, key) return option[key].enabled end,
				order = 2.5,
				data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.anima, 1, true) or "-" end,
			},
			maw_souls = {
				label = "Return Souls",
				enabled = function(option, key) return option[key].enabled end,
				order = 2.6,
				data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.souls, 1, true) or "-" end,
			},
			seperator2 = {
				order = 3,
				enabled = function(option, key, numRows) 
					local isLabelBefore = (option.mythics_done.enabled or option.dungeon_quests.enabled or option.world_boss.enabled or option.anima.enabled or option.maw_souls.enabled or option.pvp_quests.enabled)
					local isLabelAfter = (option.maw_weekly.enabled or option.torghast_layer.enabled or option.wrath.enabled or option.hunt.enabled)
					return isLabelBefore and isLabelAfter
				end,
				data = function() return "" end,
			},
			maw_weekly = {
				order = 4.1,
				enabled = function(option, key) return option[key].enabled end,
				label = "Maw Weeklies",
				data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.maw, alt_data.questInfo.maxMawQuests or 2) or "-" end,
			},
			torghast_layer = {
				label = "Torghast",
				enabled = function(option, key) return option[key].enabled end,
				tooltip = function(button, alt_data) AltManager:TorghastTooltip_OnEnter(button, alt_data) end,
				order = 4.2,
				data = function(alt_data) return alt_data.torghastInfo and AltManager:CreateTorghastString(alt_data.torghastInfo) or "-" end,
			},
			wrath = {
				label = "Wrath of the Jailer",
				enabled = function(option, key) return option[key].enabled end,
				order = 4.3,
				data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.wrath, 1, true) or "-" end,
			},
			hunt = {
				label = "The Hunt",
				enabled = function(option, key) return option[key].enabled end,
				order = 4.4,
				data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.hunt, 2, true) or "-" end,
			},
		}
	},
	reputation_unroll = {
		order = 3,
		data = "unroll",
		button_pos = 0,
		name = "Reputations >",
		unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Reputations", AltManager.db.global.options.reputation_unroll) end,
		enabled = function(option, key) return option[key].enabled end,
		unroll_name = "Reputations",
		rows = {
			venari = {
				order = 0.4,
				label = "Ve'nari",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2432])) or "-" end,
			},
			ascended = {
				order = 0.5,
				label = "Ascended",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2407])) or "-" end,
			},
			wild_hunt = {
				order = 1,
				label = "Wild Hunt",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2465])) or "-" end,
			},
			undying_army = {
				order = 1.5,
				label = "Undying Army",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2410])) or "-" end,
			},
			court_of_harvesters = {
				order = 2,
				label = "Court of Harvesters",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2413])) or "-" end,
			},
		}
	},
	raid_unroll = {
		order = 4,
		data = "unroll",
		button_pos = 0,
		name = "Raids >",
		unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Raids",  AltManager.db.global.options.raid_unroll) end,
		enabled = function(option, key) return option[key].enabled end,
		unroll_name = "Raids",
		rows = {
			nathria = {
				order = 0.5,
				label = AltManager.raids[2296].name,
				enabled = function(option, key) return option[key].enabled end,
				tooltip = function(button, alt_data) AltManager:RaidTooltip_OnEnter(button, alt_data, AltManager.raids[2296].name) end,
				data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.nathria)) or "-" end
			},
		}
	},
	sanctum_unroll = {
		order = 5,
		data = "unroll",
		button_pos = 0,
		name = "Sanctum >",
		unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Sanctum",  AltManager.db.global.options.sanctum_unroll) end,
		enabled = function(option, key) return option[key].enabled end,
		unroll_name = "Sanctum",
		rows = {
			reservoir_anima = {
				order = 0.05,
				label = lCurrency.reservoir_anima,
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1813], nil, nil, true)) or "-" end,
			},
			renown = {
				order = 0.1,
				label = lCurrency.renown,
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return alt_data.renown or "-" end,
			},	
			redeemed_soul = {
				order = 0.15,
				label = lCurrency.redeemed_soul,
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1810])) or "-" end,
			},
			seperator1 = {
				order = 0.9,
				enabled = function(option, key) 
					local isLabelBefore = (option.reservoir_anima.enabled)
					local isLabelAfter = (option.transport_network.enabled or option.anima_conductor.enabled or option.command_table.enabled or option.unique.enabled)
					return isLabelBefore and isLabelAfter
				end,
				data = function() return "" end,
			},
			transport_network = {
				order = 1,
				label = "Transport Network",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[2] and alt_data.sanctumInfo[2].tier) or "-" end,
			},
			anima_conductor = {
				order = 1.1,
				label = "Anima Conductor",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[1] and alt_data.sanctumInfo[1].tier) or "-" end,
			},
			command_table = {
				order = 1.2,
				label = "Command Table",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[3] and alt_data.sanctumInfo[3].tier) or "-" end,
			},
			unique = {
				order = 1.3,
				label = "Unique",
				enabled = function(option, key) return option[key].enabled end,
				data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[5] and alt_data.sanctumInfo[5].tier) or "-" end,
			}
		}
	}
}

AltManager.objectives = {

}