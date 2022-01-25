local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local LibIcon = LibStub("LibDBIcon-1.0")
local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")
local LSM = LibStub("LibSharedMedia-3.0")
local options
local imexport

PermoksAccountManager.numCategories = 0

local lCurrency = {}
local custom_categories
local default_categories = PermoksAccountManager:getDefaultCategories()


local function changeAccountName(accountKey, name)
	local account = PermoksAccountManager.db.global.accounts[accountKey]
	if account then
		account.name = name
		PermoksAccountManager:UpdateAccountButtons()
	end
end

local function UnsyncAccount(accountKey)
	options.args.sync.args.syncedAccounts.args[accountKey] = nil
	PermoksAccountManager:UnsyncAccount(accountKey)

	AceConfigRegistry:NotifyChange(addonName)
end

function PermoksAccountManager:AddAccountToOptions(accountKey)
	if not options.args.sync.args.syncedAccounts.args[accountKey] then
		options.args.sync.args.syncedAccounts.args[accountKey] = {
			type = "group",
			name = "",
			inline = true,
			args = {
				name = {
					order = 1,
					type = "input",
					name = L["Rename"],
					desc = nil,
					get = function(info) 
						local accountKey = info[#info-1]
						return PermoksAccountManager.db.global.accounts[accountKey].name
					end,
					set = function(info, value)
						local accountKey = info[#info-1]
						changeAccountName(accountKey, value)
					end
				},
				unsync = {
					order = 3,
					type = "execute",
					name = L["Delete"],
					func = function(info)
						local accountKey = info[#info - 1]
						UnsyncAccount(accountKey)
					end,
					confirm = true,
					confirmText = "Are you sure?",

				}
			}
		}
	end
end

local function AddAccounts()
	for account, info in pairs(PermoksAccountManager.db.global.accounts) do
		if account ~= "main" then
			PermoksAccountManager:AddAccountToOptions(account, info)
		end
	end
end

local function GetAccountSyncDescription()
	local comment = "THIS ONLY WORKS ON CONNECTED REALMS"
	local first = "Enter the necessary info of a currently online character of the second account."
	local second = "Press the Sync Button."
	local third = "Follow the instruction in the chat on the second account."

	return string.format("|cffff0000%s|r\nSteps:\n1 - %s\n2 - %s\n3 - %s", comment, first, second, third)
end

-- credit to the author of Shadowed Unit Frames
local function selectDifferentTab(group, key)
	AceConfigDialog.Status[addonName].children.categories.children[group].status.groups.selected = key
	AceConfigRegistry:NotifyChange(addonName)
end

local function deleteCustomCategory(category)
	local categoryButtons = PermoksAccountManager.managerFrame.categoryButtons
	local categoryFrame = PermoksAccountManager.categoryFrame

	if categoryFrame.openCategory and categoryFrame.openCategory == category then
		PermoksAccountManager:UpdateCategory(categoryButtons[category], "open", nil, category)
		categoryFrame.labelColumn.categories[category] = nil
	end

	if categoryButtons[category] then
		categoryButtons[category]:Hide()
		categoryButtons[category] = nil
	end

	custom_categories[category] = nil
	options.args.categoryToggles.args.custom_categories_toggles.args[category] = nil
	options.args.categories.args.customCategories.args[category] = nil
	options.args.order.args.customCategories.args[category] = nil
	options.args.order.args.customCategoriesOrder.args[category] = nil

	if PermoksAccountManager.db.global.custom then
		PermoksAccountManager.numCategories = PermoksAccountManager.numCategories - 1
	end

	selectDifferentTab("customCategories", "create")
end

local default_category_childs = {}
local customCategoryDefault = {
	delete = {
		order = 0.5,
		type = "execute",
		name = L["Delete"],
		func = function(info) 
			deleteCustomCategory(info[#info-1]) 
			PermoksAccountManager:UpdateOrCreateCategoryButtons() 
		end,
		hidden = function(info) if info[#info-1] == "general" then return true end end,
		confirm = true,
	},
}

local function sortCategoryChilds(optionsTable, category)
	local category = PermoksAccountManager.db.global.options[optionsTable][category]
	table.sort(category.childs, function(a, b) return category.childOrder[a] < category.childOrder[b] end)
end

local function setCategoryOrder(info, value)
	local category = info[#info]
	local optionsTable = info[#info-1]
	local newOrder = tonumber(value)

	PermoksAccountManager.db.global.options[optionsTable:gsub("Order", "")][category].order = newOrder
	options.args.order.args[optionsTable].args[category].order = newOrder
	AceConfigRegistry:NotifyChange(addonName)
end

local function getCategoryOrder(info)
	local category = info[#info]
	local optionsTable = info[#info-1]
	return tostring(PermoksAccountManager.db.global.options[optionsTable:gsub("Order", "")][category].order)
end

local function setOrder(info, value)
	local key = info[#info]
	local category = info[#info-1]
	local optionsTable = info[#info-2]
	local newOrder = tonumber(value)
	local categoryOptions = PermoksAccountManager.db.global.options[optionsTable][category]

	categoryOptions.childOrder[key] = newOrder
	tDeleteItem(categoryOptions.childs, key)
	tinsert(categoryOptions.childs, floor(newOrder), key)

	sortCategoryChilds(optionsTable, category)
	for i, child in pairs(categoryOptions.childs) do
		categoryOptions.childOrder[child] = i
		options.args.order.args[optionsTable].args[category].args[child].order = i
	end

	AceConfigRegistry:NotifyChange(addonName)
	PermoksAccountManager:UpdateAnchorsAndSize(category, nil, true, true)
end

local function getOrder(info)
	local key = info[#info]
	local category = info[#info-1]
	local optionsTable = info[#info-2]
	return tostring(PermoksAccountManager.db.global.options[optionsTable][category].childOrder[key])
end

local function setCustomOption(info, value)
	local key = info[#info]
	local category = info[#info-2]

	local childs = PermoksAccountManager.db.global.options.customCategories[category].childs
	if not value and tContains(childs, key) then
		tDeleteItem(childs, key)

		local j = 0
		for i, child in ipairs(childs) do
			PermoksAccountManager.db.global.options.customCategories[category].childOrder[child] = j
			options.args.order.args.customCategories.args[category].args[child].order = j
			j = j + 1
		end

		PermoksAccountManager.db.global.options.customCategories[category].childOrder[key] = nil
		options.args.order.args.customCategories.args[category].args[key] = nil
	elseif value and not tContains(childs, key) then
		tinsert(childs, key)

		local j = 0
		for i, child in pairs(childs) do
			PermoksAccountManager.db.global.options.customCategories[category].childOrder[child] = j
			j = j + 1
		end

		options.args.order.args.customCategories.args[category].args[key] = {
			order = #childs,
			type = "input",
			name = PermoksAccountManager.labelRows[key].label,
			width = "half",
			validate = function(info, value) return tonumber(value) or "Please insert a number." end,
			set = setOrder,
			get = getOrder,
		}
	else
		PermoksAccountManager.db.global.options.customCategories[category].childOrder[key] = value
		options.args.order.args.customCategories.args[category].args[key] = nil
	end

	PermoksAccountManager:UpdateAnchorsAndSize(category, nil, true, true)
end

local function getCustomOption(info)
	local key = info[#info]
	local category = info[#info-2]

	local value = PermoksAccountManager.db.global.options.customCategories[category].childOrder[key]
	return type(value) == "number" or (type(value) == "boolean" and value)
end

local function setDefaultOption(info, value)
	local key = info[#info]
	local category = info[#info-1]

	local childs = PermoksAccountManager.db.global.options.defaultCategories[category].childs
	if not value then
		tDeleteItem(childs, key)

		local j = 0
		for i, child in pairs(childs) do
			PermoksAccountManager.db.global.options.defaultCategories[category].childOrder[child] = j
			j = j + 1
		end

		PermoksAccountManager.db.global.options.defaultCategories[category].childOrder[key] = nil
		options.args.order.args.defaultCategories.args[category].args[key] = nil
	elseif value and not tContains(childs, key) then
		local order = default_categories[category].childOrder[key]
		tinsert(childs, order, key)

		PermoksAccountManager.db.global.options.defaultCategories[category].childOrder[key] = order

		options.args.order.args.defaultCategories.args[category].args[key] = {
			order = order,
			type = "input",
			name = PermoksAccountManager.labelRows[key].label,
			width = "half",
			validate = function(info, value) return tonumber(value) or "Please insert a number." end,
			set = setOrder,
			get = getOrder,
		}
	end

	PermoksAccountManager:UpdateAnchorsAndSize(category, nil, true, true)
end

local function getDefaultOption(info)
	local key = info[#info]
	local category = info[#info-1]

	local value = PermoksAccountManager.db.global.options.defaultCategories[category].childOrder[key]
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
		hidden = function(info) return not PermoksAccountManager.db.global.options[optionsTable][category].enabled end,
		args = args or customCategoryDefault,
	}

	options.args.order.args[optionsTable].args[category] = {
		order = order,
		type = "group",
		name = name,
		hidden = function(info) return not PermoksAccountManager.db.global.options[optionsTable][category].enabled end,
		args = {
		}
	}
end

local function createOrderOptionsForCategory(categoryOptions, optionsTable, category)
	if not categoryOptions.hideToggle then
		options.args.order.args[optionsTable .. "Order"].args[category] = {
			order = categoryOptions.order,
			type = "input",
			name = categoryOptions.name,
			width = "half",
			validate = function(info, value) 
				local newOrder = tonumber(value) 
				return (not newOrder and "Please insert a number.") or (newOrder <= 0 and "Please insert a number greater than 0") or true end,
			set = setCategoryOrder,
			get = getCategoryOrder,
		}
	end

	table.sort(categoryOptions.childs, function(a, b) if a and b then return categoryOptions.childOrder[a] < categoryOptions.childOrder[b] end end)
	for i, child in pairs(categoryOptions.childs) do
		local name = PermoksAccountManager.labelRows[child] and PermoksAccountManager.labelRows[child].label
		if name then
			options.args.order.args[optionsTable].args[category].args[child] = {
				order = i,
				type = "input",
				name =  name,
				width = "half",
				validate = function(info, value) return tonumber(value) or "Please insert a number." end,
				set = setOrder,
				get = getOrder,
			}
		end
	end
end

local function addCustomCategory(category, name)
	if not custom_categories[category].name then
		if PermoksAccountManager.db.global.custom then
			PermoksAccountManager.numCategories = PermoksAccountManager.numCategories + 1
		end
		local order = PermoksAccountManager.numCategories

		custom_categories[category].order = order
		custom_categories[category].name = name

		addCategoryToggle("custom_categories_toggles", category, name, order)
		addCategoryOptions("customCategories", nil, category, name, order)
		createOrderOptionsForCategory(PermoksAccountManager.db.global.options.customCategories[category], "customCategories", category)

		selectDifferentTab("customCategories", category)
		PermoksAccountManager:UpdateOrCreateCategoryButtons()
	end
end

local function createDefaultOptions()
	local numCategories = 0

	for category, info in pairs(default_categories) do
		if not info.hideToggle then
			if PermoksAccountManager.db.global.options.defaultCategories[category].enabled then
				numCategories = numCategories + 1
			end
			addCategoryToggle("default_categories_toggles", category, info.name, info.order)
		end

		local args = {}
		for i, child in pairs(info.childs) do
			if PermoksAccountManager.labelRows[child] and not PermoksAccountManager.labelRows[child].hideOption then
				args[child] = {
					order = i,
					type = "toggle",
					name = PermoksAccountManager.labelRows[child].label,
				}
			end
		end

		if not PermoksAccountManager.db.global.options.defaultCategories[category].childs then
			PermoksAccountManager:UpdateDefaultCategories(category)
		end

		addCategoryOptions("defaultCategories", args, category, info.name, info.order)
		createOrderOptionsForCategory(PermoksAccountManager.db.global.options.defaultCategories[category], "defaultCategories", category)
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
		createOrderOptionsForCategory(PermoksAccountManager.db.global.options.customCategories[category], "customCategories", category)
	end

	return numCategories
end

local function createConfirmPopup()
	-- mostly copied from AceConfigDialog-3.0.lua
	local frame = CreateFrame("Frame", nil, UIParent)
	PermoksAccountManager.confirm = frame
	frame:Hide()
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetSize(320, 85)
	frame:SetFrameStrata("TOOLTIP")

	local border = CreateFrame("Frame", nil, frame, "DialogBorderDarkTemplate")
	border:SetAllPoints(frame)

	local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	text:SetSize(290, 0)
	text:SetPoint("TOP", 0, -16)
	text:SetText("You need to reload the interface to import a profile.")

	local function newButton(text, parent)
		local button = AceGUI:Create("Button")
		button.frame:SetParent(frame)
		button.frame:SetFrameLevel(button.frame:GetFrameLevel() + 1)
		button:SetText(text)
		return button
	end

	local accept = newButton(ACCEPT)
	accept:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -6, 16)
	accept.frame:SetSize(128, 21)
	accept.frame:Show()
	frame.accept = accept

	local cancel = newButton(CANCEL)
	cancel:SetPoint("LEFT", accept.frame, "RIGHT", 13, 0)
	cancel.frame:SetSize(128, 21)
	cancel.frame:Show()
	cancel:SetCallback("OnClick", function() frame:Hide() end)
	frame.cancel = cancel
end

local function createImportExportFrame(options)
	local editGroup = AceGUI:Create("InlineGroup")
	editGroup:SetLayout("fill")
	editGroup.frame:SetParent(options.frame)
	editGroup.frame:SetPoint("BOTTOMLEFT", options.frame, "BOTTOMLEFT", 17, 52)
	editGroup.frame:SetPoint("TOPRIGHT", options.frame, "TOPRIGHT", -17, -10)
	editGroup.frame:Hide()

	local editBox = AceGUI:Create("MultiLineEditBox")
	editBox:SetWidth(options.frame:GetWidth() - 20)
	editBox:SetLabel("Export Options")
	editBox.button:Hide()
	editBox.frame:SetClipsChildren(true)
	editBox.editBox:SetScript("OnEscapePressed", function() editGroup:Close() end)
	editGroup:AddChild(editBox)

	local close = AceGUI:Create("Button")
	close.frame:SetParent(editGroup.frame)
	close:SetPoint("BOTTOMRIGHT", -27, 13)
	close.frame:SetFrameLevel(close.frame:GetFrameLevel() + 1)
	close:SetHeight(20)
	close:SetWidth(100)
	close.frame:Hide()

	function editGroup.OpenBox(self, mode)
		if mode == "export" then
			editGroup.frame:Show()

			local optionsString = PermoksAccountManager:OptionsToString()
			editBox.editBox:SetMaxBytes(nil)
			editBox.editBox:SetScript("OnChar", function() editBox:SetText(optionsString) editBox.editBox:HighlightText() end)
			editBox.button:Hide()
			editBox:SetText(optionsString)
			editBox.editBox:HighlightText()
			editBox:SetFocus()
			close:SetCallback("OnClick", function() editGroup:Close() end)
			close:SetText("Done")
			close.frame:Show()

			C_Timer.After(0, function() options:ReleaseChildren() end)
		elseif mode == "import" then
			editBox:SetText("")
			editGroup.frame:Show()
			editBox:SetFocus()

			close:SetCallback("OnClick", function() PermoksAccountManager:ImportOptions(editBox:GetText()) end)
			close:SetText("Import")
			close.frame:Show()

			C_Timer.After(0, function() options:ReleaseChildren() end)
		end
	end

	function editGroup.Close(self)
		editBox:ClearFocus()
		editGroup.frame:Hide()
		PermoksAccountManager.OpenOptions()
	end

	return editGroup
end

local function loadOptionsTemplate()
	local categoryData = {}
	local syncData = {}

	options.args.categoryToggles = {
		order = 1,
		type = "group",
		name = L["General"],
		args = {
			general = {
				order = 1,
				type = "group",
				name = L["General"],
				inline = true,
				set = function(info,value) PermoksAccountManager.db.global.options[info[#info]] = value end,
				get = function(info) return PermoksAccountManager.db.global.options[info[#info]] end,
				args = {
					showOptionsButton = {
						order = 1,
						type = "toggle",
						name = L["Show Options Button"],
						set = function(info,value) 
							PermoksAccountManager.db.global.options.showOptionsButton = value 
							PermoksAccountManager.managerFrame.optionsButton:SetShown(value)
						end,
					},
					showGuildAttunementButton = {
						order = 1.5,
						type = "toggle",
						name = L["Show Guild Attunement Button"],
						set = function(info,value) 
							PermoksAccountManager.db.global.options.showGuildAttunementButton = value 
							PermoksAccountManager.managerFrame.guildAttunementButton:SetShown(value)
						end,
						get = function(info) return PermoksAccountManager.db.global.options.showGuildAttunementButton end,
					},
					showMinimapButton = {
						order = 2,
						type = "toggle",
						name = L["Show Minimap Button"],
						set = function(info, value) 
							PermoksAccountManager.db.profile.minimap.hide = not value 
							if not value then
								LibIcon:Hide("PermoksAccountManager")
							else
								LibIcon:Show("PermoksAccountManager")
							end
						end,
						get = function(info) return not PermoksAccountManager.db.profile.minimap.hide end,
					},
					useCustom = {
						order = 3,
						type = "toggle",
						name = L["Use Custom"],
						desc = "Toggle the use of custom categories.",
						set = function(info, value)
							PermoksAccountManager.db.global.custom = value
							C_UI.Reload()
						end,
						get = function(info)
							return PermoksAccountManager.db.global.custom
						end,
						confirm = true,
						confirmText = "Requires a reload!",
					},
					hideCategory = {
						order = 4,
						type = "toggle",
						name = L["Hide Category"],
						desc = L["Hide Category when closing the manager."],
						set = function(info, value)
							if value then
								PermoksAccountManager:HideAllCategories()
							end

							PermoksAccountManager.db.global.options[info[#info]] = value
						end,
					}
				}
			},
			default_categories_toggles = {
				order = 2,
				type = "group",
				name = L["Categories"],
				inline = true,
				set = function(info, value)
					local key = info[#info]
					PermoksAccountManager.db.global.options.defaultCategories[key].enabled = value

					if not PermoksAccountManager.db.global.custom then
						if not value then
							PermoksAccountManager.numCategories = PermoksAccountManager.numCategories - 1
						else
							PermoksAccountManager.numCategories = PermoksAccountManager.numCategories + 1
						end
					end
					PermoksAccountManager:UpdateMenu()
				end,
				get = function(info)
					local key = info[#info]
					return PermoksAccountManager.db.global.options.defaultCategories[key].enabled
				end,
				hidden = function() return PermoksAccountManager.db.global.custom end,
				args = {

				}
			},
			custom_categories_toggles = {
				order = 4,
				type = "group",
				name = L["Categories"],
				inline = true,
				hidden = function() return not PermoksAccountManager.db.global.custom end,
				set = function(info, value)
					local key = info[#info]
					PermoksAccountManager.db.global.options.customCategories[key].enabled = value

					if PermoksAccountManager.db.global.custom then
						if not value then
							PermoksAccountManager.numCategories = PermoksAccountManager.numCategories - 1
						else
							PermoksAccountManager.numCategories = PermoksAccountManager.numCategories + 1
						end
					end
					PermoksAccountManager:UpdateMenu()
				end,
				get = function(info)
					local key = info[#info]
					return PermoksAccountManager.db.global.options.customCategories[key].enabled
				end,
				args = {

				}
			},
			commands = {
				order = 5,
				type = "group",
				name = L["Commands"],
				inline = true,
				args = {
					export = {
						order = 0,
						type = "execute",
						name = L["Export"],
						func = function()
							imexport:OpenBox("export")
						end,
					},
					import = {
						order = 1,
						type = "execute",
						name = L["Import"],
						func = function() 
							imexport:OpenBox("import")
						end,
					},
					purge = {
						order = 2,
						type = "execute",
						name = L["Purge"],
						func = function() PermoksAccountManager:Purge() C_UI.Reload() end,
						confirm = true,
						confirmText = "Are you sure?",
					},

				}
			},	
		},
	}

	options.args.frame = {
		order = 1.5,
		type = "group",
		name = L["Frame Config"],
		get = function(info) 
			local key = info[#info]
			local parentKey = info[#info-1]
			return PermoksAccountManager.db.global.options[parentKey][key]
		end,
		set = function(info, value)
			local key = info[#info]
			local parentKey = info[#info-1]
			PermoksAccountManager.db.global.options[parentKey][key] = value
		end,
		args = {
			characters = {
				order = 1,
				type = "group",
				name = L["Characters"],
				inline = true,
				set = function(info, value)
					local key = info[#info]
					local parentKey = info[#info-1]
					PermoksAccountManager.db.global.options[parentKey][key] = value

					if key == "charactersPerPage" then
						PermoksAccountManager.db.global.currentPage = 1
						PermoksAccountManager:SortPages()
						PermoksAccountManager:UpdatePageButtons()
						PermoksAccountManager:UpdateAnchorsAndSize("general", true)
					end
				end,
				args = {
					minLevel = {
						order = 1,
						type = "range",
						name = L["Minimum Level"],
						desc = L["Changing this won't remove characters that are below this threshold."],
						min = 1,
						max = GetMaxLevelForExpansionLevel(GetExpansionLevel()),
						bigStep = 1,
					},
					charactersPerPage = {
						order = 2,
						type = "range",
						name = L["Characters Per Page"],
						min = 3,
						max = 10,
						bigStep = 1,
					},
				}
			},
			buttons = {
				order = 2,
				type = "group",
				name = L["Button"],
				inline = true,
				set = function(info, value)
					local key = info[#info]
					local parentKey = info[#info-1]
					PermoksAccountManager.db.global.options[parentKey][key] = value					

					if key == "buttonWidth" and PermoksAccountManager.db.global.options[parentKey].buttonTextWidth > value then
						PermoksAccountManager.db.global.options[parentKey].buttonTextWidth = value
					end

					PermoksAccountManager:UpdateAnchorsAndSize("general", true)
				end,
				args = {
					buttonWidth = {
						order = 1,
						type = "range",
						name = L["Button Width"],
						set = function(info, value)
							local key = info[#info]
							local parentKey = info[#info-1]
							local options = PermoksAccountManager.db.global.options

							options[parentKey][key] = value
							options.other.widthPerAlt = max(value, options.other.widthPerAlt)
							PermoksAccountManager:UpdateAnchorsAndSize("general", true)
						end,
						min = 80,
						max = 250,
						bigStep = 1,
					},
					buttonTextWidth =  {
						order = 2,
						type = "range",
						name = L["Text Width"],
						set = function(info, value)
							local key = info[#info]
							local parentKey = info[#info-1]
							local options = PermoksAccountManager.db.global.options

							options[parentKey][key] = value
							options[parentKey].buttonWidth = max(value, options[parentKey].buttonWidth)
							options.other.widthPerAlt = max(options[parentKey].buttonWidth, options.other.widthPerAlt)
							PermoksAccountManager:UpdateAnchorsAndSize("general", true)
						end,
						min = 80,
						max = 250,
					},
					justifyH = {
						order = 3,
						type = "select",
						name = L["Justify Horizontal"],
						values = {["LEFT"] = "Left", ["CENTER"] = "Center", ["RIGHT"] = "Right"},
						sorting = {"LEFT", "CENTER", "RIGHT"},
						style = "dropdown",
					}
				}
			},
			border = {
				order = 3,
				type = "group",
				name = L["Border"],
				inline = true,
				args = {
					color = {
						order = 2,
						type = "color",
						name = L["Border Color"],
						hasAlpha = true,
						get = function(info) return unpack(PermoksAccountManager.db.global.options.border.color) end,
						set = function(info, ...) PermoksAccountManager.db.global.options.border.color = {...} PermoksAccountManager:UpdateBorderColor() end,
					},
					bgColor = {
						order = 2,
						type = "color",
						name = L["Background Color"],
						hasAlpha = true,
						get = function(info) return unpack(PermoksAccountManager.db.global.options.border.bgColor) end,
						set = function(info, ...) PermoksAccountManager.db.global.options.border.bgColor = {...} PermoksAccountManager:UpdateBorderColor() end,
					}
				},
			},
			other = {
				order = 3,
				type = "group",
				name = L["Other"],
				inline = true,
				set = function(info, value)
					local key = info[#info]
					local parentKey = info[#info-1]
					local options = PermoksAccountManager.db.global.options
					options[parentKey].updated = options[parentKey].updated or options[parentKey][key]
					options[parentKey][key] = value

					PermoksAccountManager:UpdateAnchorsAndSize("general", true)
				end,
				args = {
					labelOffset = {
						order = 1,
						type = "range",
						name = L["Label Offset"],
						min = 0,
						max = 40,
						bigStep = 1,
					},
					widthPerAlt = {
						order = 2,
						type = "range",
						name = L["Width per Alt"],
						min = 80,
						max = 250,
						bigStep = 1,
					},
					frameStrata = {
						order = 3,
						type = "select",
						name = L["Frame Strata"],
						values = {BACKGROUND = "BACKGROUND", LOW = "LOW", MEDIUM = "MEDIUM", HIGH = "HIGH", DIALOG = "DIALOG", TOOLTIP = "TOOLTIP"},
						sorting = {"BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "TOOLTIP"},
						set = function(info, value)
							local key = info[#info]
							local parentKey = info[#info-1]

							PermoksAccountManager.managerFrame:SetFrameStrata(value)
							PermoksAccountManager.db.global.options[parentKey][key] = value
						end,
					}
				},
			},
		}
	}

	options.args.categories = {
		order = 2,
		type = "group",
		name = "Category Config",
		args = {
			defaultCategories = {
				order = 1,
				type = "group",
				name = L["Default"],
				childGroups = "tab",
				set = setDefaultOption,
				get = getDefaultOption,
				args = {

				}
			},
			customCategories = {
				order = 2,
				type = "group",
				name = L["Custom"],
				childGroups = "tab",
				set = setCustomOption,
				get = getCustomOption,
				args = {
					create = {
						order = 100,
						type = "group",
						name = L["Add New"],
						args = {
							create_group = {
								order = 1,
								type = "group",
								name = L["General"],
								inline = true,
								args = {
									name = {
										order = 1,
										name = L["Name"],
										type = "input",
										validate = function(info, value)
											if value:match("[^%w:]") then
												return "You can only use letters, numbers, and colons (for now)."
											elseif string.len(value)==0 then
												return "Can't create an empty category."
											elseif PermoksAccountManager.db.global.options.customCategories[value:lower()].name then
												return "This category already exists."
											end

											return true
										end,
										set = function(info, value) categoryData.create = value	end,
										get = function(info) return categoryData.create or "" end,
									},
									create = {
										order = 2,
										name = L["Create"],
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
						name = L["General"],
						args = {},
					}
				}
			}
		}
	}

	options.args.order = {
		order = 4,
		type = "group",
		name = L["Category Order"],
		args = {
			defaultCategories = {
				order = 1,
				type = "group",
				name = L["Default"],
				childGroups = "tab",
				args = {
				}
			},
			defaultCategoriesOrder = {
				order = 2,
				type = "group",
				name = L["Default"],
				inline = true,
				args = {
				}
			},
			customCategories = {
				order = 3,
				type = "group",
				name = L["Custom"],
				childGroups = "tab",
				args = {
				},
			},
			customCategoriesOrder = {
				order = 4,
				type = "group",
				name = L["Custom"],
				inline = true,
				args = {
				}
			},
		}
	}

	options.args.sync = {
		order = 5,
		type = "group",
		name = L["Account Syncing"],
		childGroups = "tab",
		args = {
			syncOptions = {
				order = 1,
				type = "group",
				name = L["Sync Accounts"],
				args =  {
					explanation = {
						order = 1,
						type = "description",
						name = function() return GetAccountSyncDescription() end,
					},
					name = {
						order = 2,
						name = L["Name"],
						type = "input",
						validate = function(info, value)
							if value:match("[^%a]") then
								return "Character names can only consist of letters."
							end

							return true
						end,
						set = function(info, value) syncData.name = value	end,
						get = function(info) return syncData.name or "" end,
					},
					realm = {
						order = 3,
						name = L["Realm (if different from current)"],
						type = "input",
						hidden = function() local connectedRealms = GetAutoCompleteRealms() return PermoksAccountManager:IsBCCClient() or #connectedRealms == 0 end,
						validate = function(info, value)
							if value:match("[^%a]") then
								return "Realm names can only consist of letters."
							end

							return true
						end,
						set = function(info, value) syncData.realm = value	end,
						get = function(info) return syncData.realm or "" end,
					},
					sync = {
						order = 4,
						name = L["Sync (Beta)"],
						type = "execute",
						func = function(info) 
							if syncData.name then
								PermoksAccountManager:RequestAccountSync(syncData.name, syncData.realm)
							end
						end,
					},
					forceUpdate = {
						order = 5,
						name = L["Send Update"],
						type = "execute",
						desc = "To update the character list. Make sure to click this button on a character that existed in the manager at the time of syncing.",
						disabled = function() return PermoksAccountManager:GetNumAccounts() == 1 end,
						func = function(info)
							PermoksAccountManager:SendAccountUpdates()
						end,
					}
				}
			},
			syncedAccounts = {
				order = 2,
				type = "group",
				name = L["Synced Accounts"],
				args = {
				}
			}
		},
	}

  -- TODO: Retail differentiation
	options.args.experimental = {
		order = 6,
		type = "group",
		name = L["Experimental"],
		set = function(info, value) 
			PermoksAccountManager.db.global.options[info[#info]] = value 
			PermoksAccountManager:UpdateAnchorsAndSize("general", nil, nil, true)
		end,
		get = function(info) return PermoksAccountManager.db.global.options[info[#info]] end,
		args = {
			testOptions = {
				order = 7,
				type = "group",
				name = L["Test Options"],
				inline = true,
				args = {
					currencyIcons = {
						order = 1,
						type = "toggle",
						name = L["Currency Icons"],
            			retailOnly = false
					},
					itemIcons = {
						order = 2,
						type = "toggle",
						name = L["Item Icons"],
            			retailOnly = false
					},
					showCurrentSpecIcon = {
						order = 3,
						type = "toggle",
						name = L["Show Current Spec"],
            			retailOnly = true
					},
					useScoreColor = {
						order = 4,
						type = "toggle",
						name = L["Color Mythic+ Score"],
            			retailOnly = true
					},
					useScoreOutline = {
						order = 5,
						type = "toggle",
						name = L["Outline Score"],
            			retailOnly = true,
					},
					questCompletionString = {
						order = 6,
						type = "input",
						name = L["Quest Completion String"],
            			retailOnly = false,
					},
					font = {
						order = 7,
						type = "select",
						name = "Font",
						values = LSM:HashTable("font"),
						set = function(info, value) 
							PermoksAccountManager.db.global.options[info[#info]] = value 
							PermoksAccountManager.db.global.updateFont = true
							PermoksAccountManager:UpdateAllFonts()
						end,
						dialogControl = "LSM30_Font",
					},
					itemIconPosition = {
						order = 8,
						type = "select",
						name = "Item Icon Position",
						values = {left = "Left", right = "Right"},
					},
					currencyIconPosition = {
						order = 9,
						type = "select",
						name = "Currency Icon Position",
						values = {left = "Left", right = "Right"},
					},
				}
			}
		}
	}

end

function PermoksAccountManager.UpdateCustomLabelOptions(newDefault)
	newDefault = newDefault or PermoksAccountManager:GetCustomLabelTable(true)

	for category, args in pairs(options.args.categories.args.customCategories.args) do
		if category ~= "create" then
			args.args = newDefault
		end
	end
	AceConfigRegistry:NotifyChange(addonName)
end

function PermoksAccountManager.OpenOptions()
	AceConfigDialog:Open(addonName, PermoksAccountManager.optionsFrame)
end

local function copyTable(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[copyTable(k)] = copyTable(v) end
    return res
end

do
	local labelTable = {}
	local function UpdateLabelTable()
		for key, info in pairs(PermoksAccountManager.labelRows) do
			if not info.hideOption then
				local group = info.group or "other"
				local groupInfo = PermoksAccountManager.groups[group]

				labelTable[group] = labelTable[group] or {
					order = groupInfo.order,
					type = "group",
					name = groupInfo.label,
					inline = true,
					args = {}
				}

				labelTable[group].args[key] = labelTable[group].args[key] or {
					type = "toggle",
					name = info.label,
				}
			end
		end
	end

	function PermoksAccountManager:GetCustomLabelTable(update)
		if update then UpdateLabelTable() end

		return labelTable
	end
end

function PermoksAccountManager:LoadOptions()
	PermoksAccountManager.numCategories = 0
	if type(PermoksAccountManager.db.global.options.defaultCategories.general.childs) == "nil" then
		PermoksAccountManager.db.global.options.defaultCategories = copyTable(default_categories)
	end

	custom_categories = PermoksAccountManager.db.global.options.customCategories

	options = {
		type = "group",
		name = addonName,
		args = {}
	}

	loadOptionsTemplate()
	local numDefaultCategories = createDefaultOptions()
	local numCustomCategories = createCustomOptions()

	local db = PermoksAccountManager.db.global
	if db.custom then
		PermoksAccountManager.numCategories = numCustomCategories
		db.currentCategories = db.options.customCategories
	else
		PermoksAccountManager.numCategories = numDefaultCategories
		db.currentCategories = db.options.defaultCategories
	end

	PermoksAccountManager.optionsFrame = AceGUI:Create("Frame")
	PermoksAccountManager.optionsFrame:EnableResize(false)
	PermoksAccountManager.optionsFrame:Hide()

	AddAccounts()
	createConfirmPopup()
	imexport = imexport or createImportExportFrame(PermoksAccountManager.optionsFrame)

	AceConfigRegistry:RegisterOptionsTable(addonName, options, true)
end

function PermoksAccountManager:UpdateDefaultCategories(key)
	PermoksAccountManager.db.global.options.defaultCategories[key] = copyTable(default_categories[key])
end

function PermoksAccountManager:OptionsToString()
	local export = {internalVersion = self.db.global.internalVersion, custom = self.db.global.custom, options = self.db.global.options}

	local serialized = LibSerialize:Serialize(export)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encode = LibDeflate:EncodeForPrint(compressed)

	return encode or "HMM"
end

function PermoksAccountManager:ImportOptions(optionsString)
	local decoded = LibDeflate:DecodeForPrint(optionsString)
	if not decoded then return end
	local decompressed = LibDeflate:DecompressDeflate(decoded)
	if not decompressed then return end
	local success, data = LibSerialize:Deserialize(decompressed)
	if not success then return end

	local categories = data.options.customCategories
	for category, info in pairs(categories) do
		for identifier, index in pairs(info.childOrder) do
			if not PermoksAccountManager.labelRows[identifier] then
				info.childOrder[identifier] = nil
				tDeleteItem(info.childs, identifier)
			end
		end
	end

	PermoksAccountManager.confirm.accept:SetCallback("OnClick", function()
		PermoksAccountManager.db.global.custom = data.custom
		PermoksAccountManager.db.global.options = data.options
		PermoksAccountManager.db.global.internalVersion = data.internalVersion

		C_UI.Reload()
	end)

	PermoksAccountManager.confirm:Show()
end

