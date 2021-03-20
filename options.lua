local addonName, AltManager = ...
local locale = GetLocale()
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local options

AltManager.numCustomCategories = 0

local lCurrency = {}
local custom_categories
local default_categories = {
	general = {
		order = 1,
		cantDisable = true,
		name = "General",
		childs = {"characterName", "ilevel", "gold", "weekly_key", "keystone", "soul_ash", "stygia", "conquest", "honor", "valor", "contract"},
	},
	daily = {
		order = 2,
		name = "Daily",
		childs = {"callings", "maw_dailies", "eye_of_the_jailer", "sanctum_quests", "conductor"},
	},
	weekly = {
		order = 3,
		name = "Weekly",
		childs = {"great_vault_mplus", "great_vault_raid", "great_vault_pvp", "mythics_done", "dungeon_quests", "pvp_quests", "weekend_event", "world_boss", "anima", "maw_souls", "maw_weekly", "torghast_layer", "wrath", "hunt"},
	},
	reputation = {
		order = 4,
		name = "Reputation",
		childs = {"venari", "ascended", "wild_hunt", "undying_army", "court_of_harvesters"},
	},
	raid = {
		order = 5,
		name = "Raid",
		childs = {"nathria"},
	},
	sanctum = {
		order = 6,
		name = "Sanctum",
		childs = {"reservoir_anima", "renown", "redeemed_soul", "transport_network", "anima_conductor", "command_table", "sanctum_unique"},
	},
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
	}
}

AltManager.columns = {
	name = {
		order = 0.1,
		label = "Name",
		enabled = function() return true end,
		hideOption = true,
		data = function(alt_data) return alt_data.name end,
		color = function(alt_data) return RAID_CLASS_COLORS[alt_data.class] end,
	},
	ilevel = {
		order = 0.2,
		fakeLabel = true,
		enabled = function() return true end,
		hideOption = true,
		data = function(alt_data) return string.format("%.2f", alt_data.ilevel or 0) end,
		justify = "TOP",
		font = "Fonts\\FRIZQT__.TTF",
	},
	gold = {
		label = "Gold",
		enabled = function(option, key) return option[key].enabled end,
		option = "gold",
		data = function(alt_data) return alt_data.gold and alt_data.gold or 0 end,
		group = "currency",
	},
	weekly_key = {
		label = "Highest Key",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateWeeklyString(alt_data.vaultInfo.MythicPlus) or "-" end,
		group = "dungeons"
	},
	keystone = {
		label = "Keystone",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (AltManager.keys[alt_data.dungeon] or alt_data.dungeon) .. " +" .. tostring(alt_data.level) end,
		group = "dungeons",
	},
	soul_ash = {
		label = "Soul Ash",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1828], false, true)) or "-" end,
		group = "currency",
	},
	stygia = {
		label = "Stygia",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1767])) or "-" end,
		group = "currency",
	},
	conquest = {
		label = "Conquest",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1602) end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1602], nil, nil, true)) or "-" end,
		group = "currency",
	},
	honor = {
		label = "Honor",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1792) end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1792], true, true)) or "-" end,
		group = "currency",
	},
	contract = {
		label = "Contract",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.contract and AltManager:CreateContractString(alt_data.contract) or "-" end,
		group = "buff",
	},
	callings = {
		label = "Callings",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:CallingTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return AltManager:CreateCallingString(alt_data.callingInfo) end,
		group = "resetDaily"
	},
	maw_dailies = {
		label = "Maw Dailies",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.daily.maw, alt_data.questInfo.maxMawQuests or 2)) or "-" end,
		group = "resetDaily",
	},
	eye_of_the_jailer = {
		label = "Eye of the Jailer",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.jailerInfo and AltManager:CreateJailerString(alt_data.jailerInfo)) or "-" end,
		group = "resetDaily",
	},
	sanctum_quests = {
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
		group = "resetDaily",
	},
	conductor = {
		label = "Conductor (NYI)",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return "-" end,
		group = "NYI",
	},			
	great_vault_mplus = {
		label = "Vault M+",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "MythicPlus") end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.MythicPlus) or "-" end,
		group = "vault",
	},
	great_vault_raid = {
		label = "Vault Raid",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "Raid") end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.Raid) or "-" end,
		group = "vault",
	},
	great_vault_pvp = {
		label = "Vault PVP",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:VaultTooltip_OnEnter(button, alt_data, "RankedPvP") end,
		data = function(alt_data) return alt_data.vaultInfo and AltManager:CreateVaultString(alt_data.vaultInfo.RankedPvP) or "-" end,
		group = "vault",
	},
	mythics_done = {
		label = "Mythic+0",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:DungeonTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return alt_data.instanceInfo and AltManager:CreateDungeonString(alt_data.instanceInfo.dungeons) or "-" end,
		group = "dungeons",
	},
	dungeon_quests = {
		label = "Dungeon Quests",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.questInfo and  AltManager:CreateQuestString(alt_data.questInfo.weekly.dungeon, 2) or "-" end,
		group = "resetWeekly",
	},
	pvp_quests = {
		label = "PVP Quests",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.questInfo and  AltManager:CreateQuestString(alt_data.questInfo.weekly.pvp, 2) or "-" end,
		group = "resetWeekly",
	},
	weekend_event = {
		label = "Weekend Event",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.weekend, 1, true) or "-" end,
		group = "resetWeekly",
	},
	world_boss = {
		label = "World Boss",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.wb, 1, true) or "-" end,
		group = "resetWeekly",
	},
	anima = {
		label = "1k Anima",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.anima, 1, true) or "-" end,
		group = "resetWeekly",
	},
	maw_souls = {
		label = "Return Souls",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.souls, 1, true) or "-" end,
		group = "resetWeekly",
	},
	maw_weekly = {
		enabled = function(option, key) return option[key].enabled end,
		label = "Maw Weeklies",
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.maw, alt_data.questInfo.maxMawQuests or 2) or "-" end,
		group = "resetWeekly",
	},
	torghast_layer = {
		label = "Torghast",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:TorghastTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return alt_data.torghastInfo and AltManager:CreateTorghastString(alt_data.torghastInfo) or "-" end,
		group = "torghast",
	},
	wrath = {
		label = "Wrath of the Jailer",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.wrath, 1, true) or "-" end,
		group = "resetWeekly"
	},
	hunt = {
		label = "The Hunt",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.hunt, 2, true) or "-" end,
		group = "resetWeekly",
	},
	venari = {
		label = "Ve'nari",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2432])) or "-" end,
		group = "reputation",
	},
	ascended = {
		label = "Ascended",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2407])) or "-" end,
		group = "reputation",
	},
	wild_hunt = {
		label = "Wild Hunt",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2465])) or "-" end,
		group = "reputation",
	},
	undying_army = {
		label = "Undying Army",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2410])) or "-" end,
		group = "reputation",
	},
	court_of_harvesters = {
		label = "Court of Harvesters",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2413])) or "-" end,
		group = "reputation",
	},
	nathria = {
		label = "Castle Nathria",
		enabled = function(option, key) return option[key].enabled end,
		tooltip = function(button, alt_data) AltManager:RaidTooltip_OnEnter(button, alt_data, AltManager.raids[2296].name) end,
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.nathria)) or "-" end,
		group = "raids",
	},
	reservoir_anima = {
		label = "Reservoir Anima",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1813], nil, nil, true)) or "-" end,
		group = "currency",
	},
	renown = {
		label = "Renown",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return alt_data.renown or "-" end,
		group = "sanctum",
	},	
	redeemed_soul = {
		label = "Redeemed Soul",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1810])) or "-" end,
		group = "sanctum",
	},
	transport_network = {
		label = "Transport Network",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[2] and alt_data.sanctumInfo[2].tier) or "-" end,
		group = "sanctum",
	},
	anima_conductor = {
		label = "Anima Conductor",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[1] and alt_data.sanctumInfo[1].tier) or "-" end,
		group = "sanctum",
	},
	command_table = {
		label = "Command Table",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[3] and alt_data.sanctumInfo[3].tier) or "-" end,
		group = "sanctum",
	},
	sanctum_unique = {
		label = "Unique",
		enabled = function(option, key) return option[key].enabled end,
		data = function(alt_data) return (alt_data.sanctumInfo and alt_data.sanctumInfo[5] and alt_data.sanctumInfo[5].tier) or "-" end,
		group = "sanctum",
	}
}

local function sortCategoryChilds(category)
	local category = AltManager.db.global.options.customCategories[category]
	local childs = category.childs
	table.sort(childs, function(a, b) return category[a] < category[b] end)
end

local function setCustomOption(info, value)
	local key = info[#info]
	local mainCategory = info[#info-2]

	local childs = AltManager.db.global.options.customCategories[mainCategory].childs
	if not value and tContains(childs, key) then
		tDeleteItem(childs, key)

		for i, child in ipairs(childs) do
			AltManager.db.global.options.customCategories[mainCategory][child] = i
		end

		AltManager.db.global.options.customCategories[mainCategory][key] = value
		options.args.custom_order.args[mainCategory].args[key] = nil
	elseif value and not tContains(childs, key) then
		tinsert(childs, key)
		AltManager.db.global.options.customCategories[mainCategory][key] = #childs

		options.args.custom_order.args[mainCategory].args[key] = {
			order = #childs,
			type = "input",
			name = AltManager.columns[key].label,
			validate = function(info, value) return tonumber(value) or "Please insert a number." end,
			set = function(info, value) 
				local key = info[#info]
				local category = info[#info-1]
				AltManager.db.global.options.customCategories[category][key] = tonumber(value)
				sortCategoryChilds(category)
			end,
			get = function(info)
				local key = info[#info]
				local category = info[#info-1]
				return tostring(AltManager.db.global.options.customCategories[category][key])
			end,
		}
	else
		AltManager.db.global.options.customCategories[mainCategory][key] = value
		options.args.custom_order.args[mainCategory].args[key] = nil
	end
end

local function getCustomOption(info)
	local key = info[#info]
	local mainCategory = info[#info-2]

	local value = AltManager.db.global.options.customCategories[mainCategory][key]
	return type(value) == "number" or (type(value) == "boolean" and value)
end

-- credit to the author of Shadowed Unit Frames
local function selectDifferentTab(group, key)
	AceConfigDialog.Status[addonName].children[group].status.groups.selected = key
	AceConfigRegistry:NotifyChange(addonName)
end

local function deleteCustomCategory(category)
	if AltManager.main_frame.unroll_buttons[custom_categories[category].name] then
		AltManager.main_frame.unroll_buttons[custom_categories[category].name]:Hide()
		AltManager.main_frame.unroll_buttons[custom_categories[category].name] = nil
	end

	custom_categories[category] = nil
	options.args.categoryToggles.args.custom_categories_toggles.args[category] = nil
	options.args.custom_categories.args[category] = nil
	AltManager.numCustomCategories = AltManager.numCustomCategories - 1

	selectDifferentTab("custom_categories", "general")
end


local default_category_childs = {}
local customCategoryDefault = {
	delete = {
		order = 0.5,
		type = "execute",
		name = "Delete",
		func = function(info) deleteCustomCategory(info[#info-1]) end,
		hidden = function(info) if info[#info-1] == "general" then return true end end,
		confirm = true,
	},
}

do
	for key, info in pairs(AltManager.columns) do
		if info.group then
			default_category_childs[info.group] = default_category_childs[info.group] or {}
			tinsert(default_category_childs[info.group], key)
		end
	end

	local groupOrder = {"currency", "resetDaily", "resetWeekly", "vault", "torghast", "dungeons", "raids", "reputation", "buff", "sanctum"}
	for i, group in ipairs(groupOrder) do
		customCategoryDefault[group] = {
			order = i,
			type = "group",
			name = AltManager.groups[group].label,
			inline = true,
			args = {}
		}

		for j, child in ipairs(default_category_childs[group]) do
			customCategoryDefault[group].args[child] = {
				type = "toggle",
				name = AltManager.columns[child].label,
			}
		end
	end
end


local function addCustomCategory(category, name)
	if not custom_categories[category] then
		AltManager.numCustomCategories = AltManager.numCustomCategories + 1
		local order = AltManager.numCustomCategories

		custom_categories[category] = {
			order = order,
			name = name,
		}

		options.args.categoryToggles.args.custom_categories_toggles.args[category] = {
			order = order,
			type = "toggle",
			name = name,
		}

		options.args.custom_categories.args[category] = {
			order = order,
			type = "group",
			name = name,
			hidden = function(info) return not AltManager.db.global.options[category] end,
			set = setCustomOption,
			get = getCustomOption,
			args = customCategoryDefault,
		}

		options.args.custom_order.args[category] = {
			order = order,
			type = "group",
			name = name,
			hidden = function(info) return not AltManager.db.global.options[category] end,
			args = {
			}
		}


		AltManager.db.global.options[category]  = true
		selectDifferentTab("custom_categories", category)
	end
end

local function loadToggleOptions()
	AltManager.db.global.defaultCategories = default_categories

	local categoryData = {}
	custom_categories = AltManager.db.global.customCategories

	options.args.categoryToggles = {
		order = 1,
		type = "group",
		name = "General",
		args = {
			general = {
				order = 1,
				type = "group",
				name = "General",
				inline = true,
				args = {
					useCustom = {
						order = 1,
						type = "toggle",
						name = "Use Custom",
						desc = "Toggle the use of custom categories.",
						set = function(info, value)
							AltManager.db.global.custom = value
							ReloadUI()
						end,
						get = function(info)
							return AltManager.db.global.custom
						end,
						confirm = true,
						confirmText = "Requires a reload!",
						width = "full",
					},
				}
			},
			default_categories_toggles = {
				order = 2,
				type = "group",
				name = "Categories",
				inline = true,
				set = function(info, value)
					local key = info[#info]
					AltManager.db.global.options[key] = value
				end,
				get = function(info)
					local key = info[#info]
					return AltManager.db.global.options[key]
				end,
				hidden = function() return AltManager.db.global.custom end,
				args = {

				}
			},
			custom_categories_toggles = {
				order = 4,
				type = "group",
				name = "Custom Categories",
				inline = true,
				hidden = function() return not AltManager.db.global.custom end,
				set = function(info, value)
					local key = info[#info]
					AltManager.db.global.options[key] = value

					if not value then
						AltManager.numCustomCategories = AltManager.numCustomCategories - 1
					else
						AltManager.numCustomCategories = AltManager.numCustomCategories + 1
					end
				end,
				get = function(info)
					local key = info[#info]
					return AltManager.db.global.options[key]
				end,
				args = {

				}
			},
		},
	}

	options.args.default_categories = {
		order = 2,
		type = "group",
		name = "Default Categories",
		childGroups = "tab",
		set = function(info, value)
			local key = info[#info]
			local previousKey = info[#info-1]
			AltManager.db.global.options.defaultCategories[previousKey][key] = value
		end,
		get = function(info)
			local key = info[#info]
			local previousKey = info[#info-1]
			return AltManager.db.global.options.defaultCategories[previousKey][key]
		end,
		args = {

		}
	}

	options.args.custom_categories = {
		order = 3,
		type = "group",
		name = "Custom Categories",
		childGroups = "tab",
		args = {
			create = {
				order = 100,
				type = "group",
				name = "Add New",
				args = {
					create_group = {
						order = 1,
						type = "group",
						name = "General",
						inline = true,
						args = {
							name = {
								order = 1,
								name = "Name",
								type = "input",
								validate = function(info, value)
									if value:match("[^%w:]") then
										return "You can only use letters, numbers, and colons (for now)."
									elseif string.len(value)==0 then
										return "Can't create an empty category."
									elseif AltManager.db.global.defaultCategories[value:lower()] then
										return "Can't override a default category (for now)."
									end

									return true
								end,
								set = function(info, value) categoryData.create = value	end,
								get = function(info) return categoryData.create or "" end,
							},
							create = {
								order = 2,
								name = "Create",
								type = "execute",
								func = function(info) 
									if categoryData.create then
										local categoryName = categoryData.create:lower()
										addCustomCategory(categoryName, categoryData.create)
										categoryData.create = nil	
									end
								end,
							},
						}
					},

				}
			},
			general = {
				order = 0,
				type = "group",
				name = "General",
				set = setCustomOption,
				get = getCustomOption,
				args = customCategoryDefault,
			}
		}
	}

	options.args.custom_order = {
		order = 4,
		type = "group",
		name = "Custom Order",
		childGroups = "tab",
		args = {

		}
	}



	for category, info in pairs(default_categories) do
		if type(AltManager.db.global.options.defaultCategories[category]) == "nil" then
			AltManager.db.global.options.defaultCategories[category] = true
		end

		if not info.cantDisable then
			options.args.categoryToggles.args.default_categories_toggles.args[category] = {
				order = info.order,
				type = "toggle",
				name = info.name,
			}
		end

		options.args.default_categories.args[category] = {
			order = info.order,
			type = "group",
			name = info.name,
			hidden = function(info) return not AltManager.db.global.options[category] end,
			args = {
			}
		}

		for i, child in ipairs(info.childs) do
			if AltManager.columns[child] and not AltManager.columns[child].hideOption then
				options.args.default_categories.args[category].args[child] = {
					order = i,
					type = "toggle",
					name = AltManager.columns[child].label,
				}
			end
		end
	end

	AltManager.numCustomCategories = 0
	for category, info in pairs(custom_categories) do
		if not info.hideToggle then
			AltManager.numCustomCategories = AltManager.numCustomCategories + 1
			options.args.categoryToggles.args.custom_categories_toggles.args[category] = {
				order = info.order,
				type = "toggle",
				name = info.name,
			}
		end

		options.args.custom_categories.args[category] = {
			order = info.order,
			type = "group",
			name = info.name,
			hidden = function(info) return not AltManager.db.global.options[category] end,
			set = setCustomOption,
			get = getCustomOption,
			args = customCategoryDefault
		}

		options.args.custom_order.args[category] = {
			order = info.order,
			type = "group",
			name = info.name,
			hidden = function(info) return not AltManager.db.global.options[category] end,
			args = {

			}
		}

		local categoryOptions = AltManager.db.global.options.customCategories[category]
		for child, enabled in pairs(categoryOptions) do
			if enabled and type(enabled) == "boolean" and not tContains(categoryOptions.childs, child) then
				tinsert(categoryOptions.childs, child)
			end
		end

		table.sort(categoryOptions.childs, function(a, b) return categoryOptions[a] < categoryOptions[b] end)
		for i, child in ipairs(categoryOptions.childs) do
			if not AltManager.columns[child].hideOption then
				options.args.custom_order.args[category].args[child] = {
					order = i,
					type = "input",
					name = AltManager.columns[child].label,
					width = "half",
					validate = function(info, value) return tonumber(value) or "Please insert a number." end,
					set = function(info, value) 
						local key = info[#info]
						local category = info[#info-1]
						AltManager.db.global.options.customCategories[category][key] = tonumber(value)
						sortCategoryChilds(category)
					end,
					get = function(info)
						local key = info[#info]
						local category = info[#info-1]
						return tostring(AltManager.db.global.options.customCategories[category][key])
					end,
				}
			end
		end
	end
end

function AltManager.OpenOptions()
	AceConfigDialog:Open(addonName)
end

function AltManager:LoadOptions()
	options = {
		type = "group",
		name = addonName,
		args = {}
	}

	loadToggleOptions()
	AceConfigRegistry:RegisterOptionsTable(addonName, options, true)
	AltManager:RegisterChatCommand('abcdefg', self.OpenOptions)
end