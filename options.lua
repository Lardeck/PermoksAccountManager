local addonName, AltManager = ...
local locale = GetLocale()
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local LibIcon = LibStub("LibDBIcon-1.0")
local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")
local options
local imexport

AltManager.numCategories = 0

local lCurrency = {}
local custom_categories
local default_categories = AltManager:getDefaultCategories()

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
	options.args.order.args.customCategories.args[category] = nil
	options.args.order.args.customCategoriesOrder.args[category] = nil

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

local function setCategoryOrder(info, value)
	local category = info[#info]
	local optionsTable = info[#info-1]
	local newOrder = tonumber(value)

	AltManager.db.global.options[optionsTable:gsub("Order", "")][category].order = newOrder
	options.args.order.args[optionsTable].args[category].order = newOrder
	AceConfigRegistry:NotifyChange(addonName)
end

local function getCategoryOrder(info)
	local category = info[#info]
	local optionsTable = info[#info-1]
	return tostring(AltManager.db.global.options[optionsTable:gsub("Order", "")][category].order)
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

		local j = 0
		for i, child in ipairs(childs) do
			AltManager.db.global.options.customCategories[category].childOrder[child] = j
			options.args.order.args.customCategories.args[category].args[child].order = j
			j = j + 1
		end

		AltManager.db.global.options.customCategories[category].childOrder[key] = nil
		options.args.order.args.customCategories.args[category].args[key] = nil
	elseif value and not tContains(childs, key) then
		tinsert(childs, key)

		local j = 0
		for i, child in pairs(childs) do
			AltManager.db.global.options.customCategories[category].childOrder[child] = j
			j = j + 1
		end

		options.args.order.args.customCategories.args[category].args[key] = {
			order = #childs,
			type = "input",
			name = AltManager.columns[key].label or AltManager.columns[key].fakeLabel,
			width = "half",
			validate = function(info, value) return tonumber(value) or "Please insert a number." end,
			set = setOrder,
			get = getOrder,
		}
	else
		AltManager.db.global.options.customCategories[category].childOrder[key] = value
		options.args.order.args.customCategories.args[category].args[key] = nil
	end

	AltManager:UpdateAnchorsAndSize(category, nil, true, true)
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
	if not value then
		tDeleteItem(childs, key)

		local j = 0
		for i, child in pairs(childs) do
			AltManager.db.global.options.defaultCategories[category].childOrder[child] = j
			j = j + 1
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

	AltManager:UpdateAnchorsAndSize(category, nil, true, true)
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
		hidden = function(info) return not AltManager.db.global.options[optionsTable][category].enabled end,
		args = args or customCategoryDefault,
	}

	options.args.order.args[optionsTable].args[category] = {
		order = order,
		type = "group",
		name = name,
		hidden = function(info) return not AltManager.db.global.options[optionsTable][category].enabled end,
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
		local name = AltManager.columns[child] and (AltManager.columns[child].label or AltManager.columns[child].fakeLabel)
		if name then
			options.args.order.args[optionsTable].args[category].args[child] = {
				order = i,
				type = "input",
				name =  AltManager.columns[child].label or AltManager.columns[child].fakeLabel,
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
		if AltManager.db.global.custom then
			AltManager.numCategories = AltManager.numCategories + 1
		end
		local order = AltManager.numCategories

		custom_categories[category].order = order
		custom_categories[category].name = name

		addCategoryToggle("custom_categories_toggles", category, name, order)
		addCategoryOptions("customCategories", nil, category, name, order)
		createOrderOptionsForCategory(AltManager.db.global.options.customCategories[category], "customCategories", category)

		selectDifferentTab("customCategories", category)
	end
end

local function createDefaultOptions()
	local numCategories = 0

	for category, info in pairs(default_categories) do
		if not info.hideToggle then
			if AltManager.db.global.options.defaultCategories[category].enabled then
				numCategories = numCategories + 1
			end
			addCategoryToggle("default_categories_toggles", category, info.name, info.order)
		end

		local args = {}
		for i, child in pairs(info.childs) do
			if AltManager.columns[child] and not AltManager.columns[child].hideOption then
				args[child] = {
					order = i,
					type = "toggle",
					name = AltManager.columns[child].label or AltManager.columns[child].fakeLabel,
				}
			end
		end

		if not AltManager.db.global.options.defaultCategories[category].childs then
			AltManager:UpdateDefaultCategories(category)
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

local function createConfirmPopup()
	-- mostly copied from AceConfigDialog-3.0.lua
	local frame = CreateFrame("Frame", nil, UIParent)
	AltManager.confirm = frame
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

			local optionsString = AltManager:OptionsToString()
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

			close:SetCallback("OnClick", function() AltManager:ImportOptions(editBox:GetText()) end)
			close:SetText("Import")
			close.frame:Show()

			C_Timer.After(0, function() options:ReleaseChildren() end)
		end
	end

	function editGroup.Close(self)
		editBox:ClearFocus()
		editGroup.frame:Hide()
		AltManager.OpenOptions()
	end

	return editGroup
end

local function loadOptionsTemplate()
	local categoryData = {}
	local syncData = {}

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
					showGuildAttunementButton = {
						order = 1.5,
						type = "toggle",
						name = "Show Guild Attunement Button",
						set = function(info,value) 
							AltManager.db.global.options.showGuildAttunementButton = value 
							AltManager.main_frame.guildAttunmentButton:SetShown(value)
						end,
						get = function(info) return AltManager.db.global.options.showGuildAttunementButton end,
					},
					showMinimapButton = {
						order = 2,
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
						order = 3,
						type = "toggle",
						name = "Use Custom",
						desc = "Toggle the use of custom categories.",
						set = function(info, value)
							AltManager.db.global.custom = value
							C_UI.Reload()
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
					AltManager.db.global.options.defaultCategories[key].enabled = value

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
					return AltManager.db.global.options.defaultCategories[key].enabled
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
					AltManager.db.global.options.customCategories[key].enabled = value

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
					return AltManager.db.global.options.customCategories[key].enabled
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
					export = {
						order = 0,
						type = "execute",
						name = "Export",
						func = function()
							imexport:OpenBox("export")
						end,
					},
					import = {
						order = 1,
						type = "execute",
						name = "Import",
						func = function() 
							imexport:OpenBox("import")
						end,
					},
					purge = {
						order = 2,
						type = "execute",
						name = "Purge",
						func = function() AltManager:Purge() C_UI.Reload() end,
						confirm = true,
						confirmText = "Are you sure?",
					},

				}
			},
			testOptions = {
				order = 7,
				type = "group",
				name = "Test Options",
				inline = true,
				args = {
					currencyIcons = {
						order = 1,
						type = "toggle",
						name = "Currency Icons",
						set = function(info, value) AltManager.db.global.options.currencyIcons = value end,
						get = function(info) return AltManager.db.global.options.currencyIcons end,
					},
					itemIcons = {
						order = 2,
						type = "toggle",
						name = "Item Icons",
						set = function(info, value) AltManager.db.global.options.itemIcons = value end,
						get = function(info) return AltManager.db.global.options.itemIcons end,
					}
				}
			}
		},
	}

		options.args.frame = {
		order = 1.5,
		type = "group",
		name = "Frame Config",
		get = function(info) 
			local key = info[#info]
			local parentKey = info[#info-1]
			return AltManager.db.global.options[parentKey][key]
		end,
		args = {
			buttons = {
				order = 1,
				type = "group",
				name = "Button",
				inline = true,
				set = function(info, value)
					local key = info[#info]
					local parentKey = info[#info-1]
					AltManager.db.global.options[parentKey][key] = value					

					if key == "buttonWidth" and AltManager.db.global.options[parentKey].buttonTextWidth > value then
						AltManager.db.global.options[parentKey].buttonTextWidth = value
					end

					AltManager:UpdateAnchorsAndSize("general", true)
				end,
				args = {
					buttonWidth = {
						order = 1,
						type = "range",
						name = "Button Width",
						min = 60,
						max = 250,
						bigStep = 1,
					},
					buttonTextWidth =  {
						order = 2,
						type = "range",
						name = "Text Width",
						min = 60,
						max = 250,
					},
					justifyH = {
						order = 3,
						type = "select",
						name = "Justify Horizontal",
						values = {["LEFT"] = "Left", ["CENTER"] = "Center", ["RIGHT"] = "Right"},
						sorting = {"LEFT", "CENTER", "RIGHT"},
						style = "dropdown",
					}
				}
			},
			other = {
				order = 2,
				type = "group",
				name = "Other",
				inline = true,
				set = function(info, value)
					local key = info[#info]
					local parentKey = info[#info-1]
					local options = AltManager.db.global.options
					options[parentKey].updated = options[parentKey].updated or options[parentKey][key]
					options[parentKey][key] = value

					AltManager:UpdateAnchorsAndSize("general", true)
				end,
				args = {
					labelOffset = {
						order = 1,
						type = "range",
						name = "Label Offset",
						min = 0,
						max = 40,
						bigStep = 1,
					},
					widthPerAlt = {
						order = 2,
						type = "range",
						name = "Width per Alt",
						min = 60,
						max = 250,
						bigStep = 1,
					},
				}
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
											elseif AltManager.db.global.options.customCategories[value:lower()].name then
												return "This category already exists."
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
		name = "Category Order",
		args = {
			defaultCategories = {
				order = 1,
				type = "group",
				name = "Default",
				childGroups = "tab",
				args = {
				}
			},
			defaultCategoriesOrder = {
				order = 2,
				type = "group",
				name = "Default",
				inline = true,
				args = {
				}
			},
			customCategories = {
				order = 3,
				type = "group",
				name = "Custom",
				childGroups = "tab",
				args = {
				},
			},
			customCategoriesOrder = {
				order = 4,
				type = "group",
				name = "Custom",
				inline = true,
				args = {
				}
			},
		}
	}

	options.args.sync = {
		order = 5,
		type = "group",
		name = "Account Syncing",
		args = {
			syncOptions = {
				order = 1,
				type = "group",
				name = "Sync Accounts",
				inline = true,
				args =  {
					name = {
						order = 1,
						name = "Character Name",
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
						order = 2,
						name = "Realm",
						type = "input",
						hidden = function() local connectedRealms = GetAutoCompleteRealms() return AltManager:IsBCCClient() or #connectedRealms == 0 end,
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
						order = 3,
						name = "sync",
						type = "execute",
						func = function(info) 
							if syncData.name then
								AltManager:RequestAccountsync(syncData.name, syncData.realm)
							end
						end,
					},
					forceUpdate = {
						order = 4,
						name = "Send Update",
						type = "execute",
						desc = "To update the character list. Make sure to click this button on a character that existed in the manager at the time of syncing.",
						disabled = function() return AltManager:GetNumAccounts() == 1 end,
						func = function(info)
							AltManager:SendAccountUpdates()
						end,
					}
				}
			},
			syncedAccounts = {
				order = 2,
				type = "group",
				name = "synced Accounts",
				inline = true,
				args = {
				}
			}
		},
	}

end

function AltManager.OpenOptions()
	AceConfigDialog:Open(addonName, AltManager.optionsFrame)
	--if ViragDevTool_AddData then ViragDevTool_AddData(AltManager.optionsFrame) end
end

local function copyTable(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[copyTable(k)] = copyTable(v) end
    return res
end


function AltManager:LoadOptions()
	AltManager.numCategories = 0
	if type(AltManager.db.global.options.defaultCategories.general.childs) == "nil" then
		AltManager.db.global.options.defaultCategories = copyTable(default_categories)
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

	if AltManager.db.global.custom then
		AltManager.numCategories = numCustomCategories
	else
		AltManager.numCategories = numDefaultCategories
	end

	AltManager.optionsFrame = AceGUI:Create("Frame")
	AltManager.optionsFrame:EnableResize(false)
	AltManager.optionsFrame:Hide()

	createConfirmPopup()
	imexport = imexport or createImportExportFrame(AltManager.optionsFrame)

	AceConfigRegistry:RegisterOptionsTable(addonName, options, true)
end

function AltManager:UpdateDefaultCategories(key)
	AltManager.db.global.options.defaultCategories[key] = copyTable(default_categories[key])
end

function AltManager:OptionsToString()
	local export = {internalVersion = self.db.global.internalVersion, custom = self.db.global.custom, options = self.db.global.options}

	local serialized = LibSerialize:Serialize(export)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encode = LibDeflate:EncodeForPrint(compressed)

	return encode or "HMM"
end

function AltManager:ImportOptions(optionsString)
	local decoded = LibDeflate:DecodeForPrint(optionsString)
	if not decoded then return end
	local decompressed = LibDeflate:DecompressDeflate(decoded)
	if not decompressed then return end
	local success, data = LibSerialize:Deserialize(decompressed)
	if not success then return end

	AltManager.confirm.accept:SetCallback("OnClick", function()
		AltManager.db.global.custom = data.custom
		AltManager.db.global.options = data.options
		AltManager.db.global.internalVersion = data.internalVersion

		C_UI.Reload()
	end)
	AltManager.confirm:Show()

	--if ViragDevTool_AddData then ViragDevTool_AddData(data) end
end

do
	for key, info in pairs(AltManager.columns) do
		if info.group then
			default_category_childs[info.group] = default_category_childs[info.group] or {}
			tinsert(default_category_childs[info.group], key)
		end
	end

	for i, group in ipairs(AltManager.groupOrder) do
		customCategoryDefault[group] = {
			order = i,
			type = "group",
			name = AltManager.groups[group].label,
			inline = true,
			args = {}
		}

		if default_category_childs[group] then
			for j, child in ipairs(default_category_childs[group]) do
				customCategoryDefault[group].args[child] = {
					type = "toggle",
					name = AltManager.columns[child].label or AltManager.columns[child].fakeLabel,
				}
			end
		end
	end
end