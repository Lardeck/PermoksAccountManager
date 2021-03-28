local addonName, AltManager = ...
local locale = GetLocale()
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local LibIcon = LibStub("LibDBIcon-1.0")
local options

AltManager.numCategories = 0

local lCurrency = {}
local custom_categories
local default_categories = {
	general = {
		order = 0,
		name = "General",
		childs = {"characterName", "ilevel", "gold", "weekly_key", "keystone", "soul_ash", "stygia", "conquest", "honor", "valor", "contract"},
		childOrder = {characterName = 1, ilevel = 2, gold = 3, weekly_key = 4, keystone = 5, soul_ash = 6, stygia = 7, conquest = 8, honor = 9, valor = 10, contract = 11},
		hideToggle = true,
	},
	daily = {
		order = 1,
		name = "Daily",
		childs = {"callings", "maw_dailies", "eye_of_the_jailer", "sanctum_quests", "conductor"},
		childOrder = {callings = 1, maw_dailies = 2, eye_of_the_jailer = 3, sanctum_quests = 4, conductor = 5},
	},
	weekly = {
		order = 2,
		name = "Weekly",
		childs = {"great_vault_mplus", "great_vault_raid", "great_vault_pvp", "mythics_done", "dungeon_quests", "pvp_quests",
			 	  "weekend_event", "world_boss", "anima", "maw_souls", "maw_weekly", "torghast_layer", "wrath", "hunt"},
		childOrder = {great_vault_mplus = 1, great_vault_raid = 2, great_vault_pvp = 3, mythics_done = 4, dungeon_quests = 5, pvp_quests = 6,
					  weekend_event = 7, world_boss = 8, anima = 9, maw_souls = 10, maw_weekly = 11, torghast_layer = 12, wrath = 13, hunt = 14}
	},
	reputation = {
		order = 3,
		name = "Reputation",
		childs = {"venari", "ascended", "wild_hunt", "undying_army", "court_of_harvesters"},
		childOrder = {venari = 1, ascended = 2, wild_hunt = 3, undying_army = 4, court_of_harvesters = 5},
	},
	raid = {
		order = 4,
		name = "Raid",
		childs = {"nathria"},
		childOrder = {nathria = 1}
	},
	sanctum = {
		order = 5,
		name = "Sanctum",
		childs = {"reservoir_anima", "renown", "redeemed_soul", "transport_network", "anima_conductor", "command_table", "sanctum_unique"},
		childOrder = {reservoir_anima = 1, renown = 2, redeemed_soul = 3, transport_network = 4, anima_conductor = 5, command_table = 6, sanctum_unique = 7}
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
	characterName = {
		order = 0.1,
		label = "Name",
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
		font = "Fonts\\FRIZQT__.TTF",
	},
	gold = {
		label = "Gold",
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
		data = function(alt_data) return (AltManager.keys[alt_data.dungeon] or alt_data.dungeon) .. " +" .. tostring(alt_data.level) end,
		group = "dungeons",
	},
	soul_ash = {
		label = "Soul Ash",
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1828], false, true)) or "-" end,
		group = "currency",
	},
	stygia = {
		label = "Stygia",
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1767])) or "-" end,
		group = "currency",
	},
	conquest = {
		label = "Conquest",
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1602) end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1602], nil, nil, true)) or "-" end,
		group = "currency",
	},
	honor = {
		label = "Honor",
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1792) end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1792], true, true)) or "-" end,
		group = "currency",
	},
	valor = {
		label = "Valor",
		tooltip = function(button, alt_data) AltManager:CurrencyTooltip_OnEnter(button, alt_data, 1191) end,
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1191], nil, nil, true)) or "-" end,
		group = "currency",
	},
	contract = {
		label = "Contract",
		data = function(alt_data) return alt_data.contract and AltManager:CreateContractString(alt_data.contract) or "-" end,
		group = "buff",
	},
	callings = {
		label = "Callings",
		tooltip = function(button, alt_data) AltManager:CallingTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return AltManager:CreateCallingString(alt_data.callingInfo) end,
		group = "resetDaily"
	},
	maw_dailies = {
		label = "Maw Dailies",
		data = function(alt_data) return (alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.daily.maw, alt_data.questInfo.maxMawQuests or 2)) or "-" end,
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
				return (alt_data.questInfo and AltManager:CreateSanctumString(alt_data.sanctumInfo, rightFeatureType, alt_data.questInfo.daily.nfTransport, alt_data.questInfo.maxnfTransport or 1)) or "-" 
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
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.weekend, 1, true) or "-" end,
		group = "resetWeekly",
	},
	world_boss = {
		label = "World Boss",
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.wb, 1, true) or "-" end,
		group = "resetWeekly",
	},
	anima = {
		label = "1k Anima",
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.anima, 1, true) or "-" end,
		group = "resetWeekly",
	},
	maw_souls = {
		label = "Return Souls",
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.souls, 1, true) or "-" end,
		group = "resetWeekly",
	},
	maw_weekly = {
		label = "Maw Weeklies",
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.maw, alt_data.questInfo.maxMawQuests or 2) or "-" end,
		group = "resetWeekly",
	},
	torghast_layer = {
		label = "Torghast",
		tooltip = function(button, alt_data) AltManager:TorghastTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return alt_data.torghastInfo and AltManager:CreateTorghastString(alt_data.torghastInfo) or "-" end,
		group = "torghast",
	},
	wrath = {
		label = "Wrath of the Jailer",
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.wrath, 1, true) or "-" end,
		group = "resetWeekly"
	},
	hunt = {
		label = "The Hunt",
		data = function(alt_data) return alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.weekly.hunt, 2, true) or "-" end,
		group = "resetWeekly",
	},
	venari = {
		label = "Ve'nari",
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2432])) or "-" end,
		group = "reputation",
	},
	ascended = {
		label = "Ascended",
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2407])) or "-" end,
		group = "reputation",
	},
	wild_hunt = {
		label = "Wild Hunt",
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2465])) or "-" end,
		group = "reputation",
	},
	undying_army = {
		label = "Undying Army",
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2410])) or "-" end,
		group = "reputation",
	},
	court_of_harvesters = {
		label = "Court of Harvesters",
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[2413])) or "-" end,
		group = "reputation",
	},
	nathria = {
		label = "Castle Nathria",
		tooltip = function(button, alt_data) AltManager:RaidTooltip_OnEnter(button, alt_data, AltManager.raids[2296].name) end,
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.nathria)) or "-" end,
		group = "raids",
	},
	reservoir_anima = {
		label = "Reservoir Anima",
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1813], nil, nil, true)) or "-" end,
		group = "currency",
	},
	renown = {
		label = "Renown",
		data = function(alt_data) return alt_data.renown or "-" end,
		group = "sanctum",
	},	
	redeemed_soul = {
		label = "Redeemed Soul",
		data = function(alt_data) return (alt_data.currencyInfo and AltManager:CreateCurrencyString(alt_data.currencyInfo[1810])) or "-" end,
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
	}
}

-- credit to the author of Shadowed Unit Frames
local function selectDifferentTab(group, key)
	AceConfigDialog.Status[addonName].children.categories.children[group].status.groups.selected = key
	AceConfigRegistry:NotifyChange(addonName)
end

local function deleteCustomCategory(category)
	if AltManager.main_frame.unroll_buttons[custom_categories[category].name] then
		AltManager.main_frame.unroll_buttons[custom_categories[category].name]:Hide()
		AltManager.main_frame.unroll_buttons[custom_categories[category].name] = nil
	end

	custom_categories[category] = nil
	options.args.categoryToggles.args.custom_categories_toggles.args[category] = nil
	options.args.categories.args.customCategories.args[category] = nil

	if AltManager.db.global.custom then
		AltManager.numCategories = AltManager.numCategories - 1
	end

	selectDifferentTab("customCategories", "create")
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

local function sortCategoryChilds(optionsTable, category)
	local category = AltManager.db.global.options[optionsTable][category]
	table.sort(category.childs, function(a, b) return category.childOrder[a] < category.childOrder[b] end)
end

local function setOrder(info, value)
	local key = info[#info]
	local category = info[#info-1]
	local optionsTable = info[#info-2]
	local newOrder = tonumber(value)

	AltManager.db.global.options[optionsTable][category].childOrder[key] = newOrder

	options.args.order.args[optionsTable].args[category].args[key].order = newOrder
	sortCategoryChilds(optionsTable, category)
	AceConfigRegistry:NotifyChange(addonName)
end

local function getOrder(info)
	local key = info[#info]
	local category = info[#info-1]
	local optionsTable = info[#info-2]
	return tostring(AltManager.db.global.options[optionsTable][category].childOrder[key])
end

local function setCustomOption(info, value)
	local key = info[#info]
	local category = info[#info-2]

	local childs = AltManager.db.global.options.customCategories[category].childs
	if not value and tContains(childs, key) then
		tDeleteItem(childs, key)

		for i, child in ipairs(childs) do
			AltManager.db.global.options.customCategories[category].childOrder[child] = i
		end

		AltManager.db.global.options.customCategories[category].childOrder[key] = nil
		options.args.order.args.customCategories.args[category].args[key] = nil
	elseif value and not tContains(childs, key) then
		tinsert(childs, key)

		AltManager.db.global.options.customCategories[category].childOrder[key] = #childs

		options.args.order.args.customCategories.args[category].args[key] = {
			order = #childs,
			type = "input",
			name = AltManager.columns[key].label,
			width = "half",
			validate = function(info, value) return tonumber(value) or "Please insert a number." end,
			set = setOrder,
			get = getOrder,
		}
	else
		AltManager.db.global.options.customCategories[category].childOrder[key] = value
		options.args.order.args.customCategories.args[category].args[key] = nil
	end
end

local function getCustomOption(info)
	local key = info[#info]
	local category = info[#info-2]

	local value = AltManager.db.global.options.customCategories[category].childOrder[key]
	return type(value) == "number" or (type(value) == "boolean" and value)
end

local function setDefaultOption(info, value)
	local key = info[#info]
	local category = info[#info-1]

	local childs = AltManager.db.global.options.defaultCategories[category].childs
	if not value and tContains(childs, key) then
		tDeleteItem(childs, key)

		for i, child in ipairs(childs) do
			AltManager.db.global.options.defaultCategories[category].childOrder[child] = i
		end

		AltManager.db.global.options.defaultCategories[category].childOrder[key] = nil
		options.args.order.args.defaultCategories.args[category].args[key] = nil
	elseif value and not tContains(childs, key) then
		local order = default_categories[category].childOrder[key]
		tinsert(childs, order, key)

		AltManager.db.global.options.defaultCategories[category].childOrder[key] = order

		options.args.order.args.defaultCategories.args[category].args[key] = {
			order = order,
			type = "input",
			name = AltManager.columns[key].label,
			width = "half",
			validate = function(info, value) return tonumber(value) or "Please insert a number." end,
			set = setOrder,
			get = getOrder,
		}
	end
end

local function getDefaultOption(info)
	local key = info[#info]
	local category = info[#info-1]

	local value = AltManager.db.global.options.defaultCategories[category].childOrder[key]
	return type(value) == "number" or (type(value) == "boolean" and value)
end

local function addCategoryToggle(optionsTable, category, name, order)
	options.args.categoryToggles.args[optionsTable].args[category] = {
		order = order,
		type = "toggle",
		name = name,
	}
end

local function addCategoryOptions(optionsTable, args, category, name, order)
	options.args.categories.args[optionsTable].args[category] = {
		order = order,
		type = "group",
		name = name,
		hidden = function(info) return not AltManager.db.global.options[category] end,
		args = args or customCategoryDefault,
	}

	options.args.order.args[optionsTable].args[category] = {
		order = order,
		type = "group",
		name = name,
		hidden = function(info) return not AltManager.db.global.options[category] end,
		args = {
		}
	}
end

local function addCustomCategory(category, name)
	if not custom_categories[category].name then
		if AltManager.db.global.custom then
			AltManager.numCategories = AltManager.numCategories + 1
		end
		local order = AltManager.numCategories

		custom_categories[category].order = order
		custom_categories[category].name = name

		addCategoryToggle("custom_categories_toggles", category, name, order)
		addCategoryOptions("customCategories", nil, category, name, order)

		AltManager.db.global.options[category]  = true
		selectDifferentTab("customCategories", category)
	end
end

local function createOrderOptionsForCategory(categoryOptions, optionsTable, category)
	table.sort(categoryOptions.childs, function(a, b) return categoryOptions.childOrder[a] < categoryOptions.childOrder[b] end)
	for i, child in ipairs(categoryOptions.childs) do
		options.args.order.args[optionsTable].args[category].args[child] = {
			order = i,
			type = "input",
			name = AltManager.columns[child].label or AltManager.columns[child].fakeLabel,
			width = "half",
			validate = function(info, value) return tonumber(value) or "Please insert a number." end,
			set = setOrder,
			get = getOrder,
		}
	end
end



local function createDefaultOptions()
	local numCategories = 0

	for category, info in pairs(default_categories) do
		if not info.hideToggle then
			numCategories = numCategories + 1
			addCategoryToggle("default_categories_toggles", category, info.name, info.order)
		end

		local args = {}
		for i, child in ipairs(info.childs) do
			if AltManager.columns[child] and not AltManager.columns[child].hideOption then
				args[child] = {
					order = i,
					type = "toggle",
					name = AltManager.columns[child].label,
				}
			end
		end

		addCategoryOptions("defaultCategories", args, category, info.name, info.order)
		createOrderOptionsForCategory(AltManager.db.global.options.defaultCategories[category], "defaultCategories", category)
	end	

	return numCategories
end

local function createCustomOptions()
	local numCategories = 0

	for category, info in pairs(custom_categories) do
		if not info.hideToggle then
			numCategories = numCategories + 1
			addCategoryToggle("custom_categories_toggles", category, info.name, info.order)
		end

		addCategoryOptions("customCategories", nil, category, info.name, info.order)
		createOrderOptionsForCategory(AltManager.db.global.options.customCategories[category], "customCategories", category)
	end

	return numCategories
end

local function loadOptionsTemplate()
	local categoryData = {}

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
					showOptionsButton = {
						order = 1,
						type = "toggle",
						name = "Show Options Button",
						set = function(info,value) AltManager.db.global.options.showOptionsButton = value end,
						get = function(info) return AltManager.db.global.options.showOptionsButton end,
					},
					showMinimapButton = {
						order = 1.5,
						type = "toggle",
						name = "Show Minimap Button",
						set = function(info, value) 
							AltManager.db.profile.minimap.hide = not value 
							if not value then
								LibIcon:Hide("MartinsAltManager")
							else
								LibIcon:Show("MartinsAltManager")
							end
						end,
						get = function(info) return not AltManager.db.profile.minimap.hide end,
					},
					useCustom = {
						order = 2,
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

					if not AltManager.db.global.custom then
						if not value then
							AltManager.numCategories = AltManager.numCategories - 1
						else
							AltManager.numCategories = AltManager.numCategories + 1
						end
					end
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
				name = "Categories",
				inline = true,
				hidden = function() return not AltManager.db.global.custom end,
				set = function(info, value)
					local key = info[#info]
					AltManager.db.global.options[key] = value

					if AltManager.db.global.custom then
						if not value then
							AltManager.numCategories = AltManager.numCategories - 1
						else
							AltManager.numCategories = AltManager.numCategories + 1
						end
					end
				end,
				get = function(info)
					local key = info[#info]
					return AltManager.db.global.options[key]
				end,
				args = {

				}
			},
			commands = {
				order = 5,
				type = "group",
				name = "Commands",
				inline = true,
				args = {
					purge = {
						order = 0,
						type = "execute",
						name = "Purge",
						func = function() AltManager:Purge() end,
						confirm = true,
						confirmText = "Are you sure?",
					}
				}
			}
		},
	}

	options.args.categories = {
		order = 2,
		type = "group",
		name = "Categories",
		args = {
			defaultCategories = {
				order = 1,
				type = "group",
				name = "Default",
				childGroups = "tab",
				set = setDefaultOption,
				get = getDefaultOption,
				args = {

				}
			},
			customCategories = {
				order = 2,
				type = "group",
				name = "Custom",
				childGroups = "tab",
				set = setCustomOption,
				get = getCustomOption,
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
											elseif AltManager.db.global.options.defaultCategories[value:lower()] then
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
						args = customCategoryDefault,
					}
				}
			}
		}
	}

	options.args.order = {
		order = 4,
		type = "group",
		name = "Order",
		args = {
			defaultCategories = {
				order = 1,
				type = "group",
				name = "Default",
				childGroups = "tab",
				args = {

				}
			},
			customCategories = {
				order = 2,
				type = "group",
				name = "Custom",
				childGroups = "tab",
				args = {

				},
			},
		}
	}
end

function AltManager.OpenOptions()
	AceConfigDialog:Open(addonName)
end

function AltManager:LoadOptions()
	AltManager.numCategories = 0

	if type(AltManager.db.global.options.defaultCategories) == "nil" then
		AltManager.db.global.options.defaultCategories = default_categories
	end

	custom_categories = AltManager.db.global.options.customCategories

	options = {
		type = "group",
		name = addonName,
		args = {}
	}

	loadOptionsTemplate()
	local numDefaultCategories = createDefaultOptions()
	local numCustomCategories = createCustomOptions()

	if self.db.global.custom then
		AltManager.numCategories = numCustomCategories
	else
		AltManager.numCategories = numDefaultCategories
	end

	AceConfigRegistry:RegisterOptionsTable(addonName, options, true)
	AltManager:RegisterChatCommand('abcdefg', self.OpenOptions)
end

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