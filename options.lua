local addonName, PermoksAccountManager = ...
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local AceConfig = LibStub('AceConfig-3.0')
local AceConfigDialog = LibStub('AceConfigDialog-3.0')
local AceConfigRegistry = LibStub('AceConfigRegistry-3.0')
local AceGUI = LibStub('AceGUI-3.0')
local LibIcon = LibStub('LibDBIcon-1.0')
local LibDeflate = LibStub('LibDeflate')
local LibSerialize = LibStub('LibSerialize')
local LSM = LibStub('LibSharedMedia-3.0')
local options
local imexport

PermoksAccountManager.numCategories = 0

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
            type = 'group',
            name = '',
            inline = true,
            args = {
                name = {
                    order = 1,
                    type = 'input',
                    name = L['Rename'],
                    desc = nil,
                    get = function(info)
                        local accountKey = info[#info - 1]
                        return PermoksAccountManager.db.global.accounts[accountKey].name
                    end,
                    set = function(info, value)
                        local accountKey = info[#info - 1]
                        changeAccountName(accountKey, value)
                    end
                },
                unsync = {
                    order = 3,
                    type = 'execute',
                    name = L['Delete'],
                    func = function(info)
                        local accountKey = info[#info - 1]
                        UnsyncAccount(accountKey)
                    end,
                    confirm = true,
                    confirmText = L['Are you sure?']
                }
            }
        }
    end
end

local function AddAccounts()
    for account, _ in pairs(PermoksAccountManager.db.global.accounts) do
        if account ~= 'main' then
            PermoksAccountManager:AddAccountToOptions(account)
        end
    end
end

local function GetAccountSyncDescription()
    local comment = 'THIS ONLY WORKS ON CONNECTED REALMS'
    local first = 'Enter the necessary info of a currently online character of the second account.'
    local second = 'Press the Sync Button.'
    local third = 'Follow the instruction in the chat on the second account.'

    return string.format('|cffff0000%s|r\nSteps:\n1 - %s\n2 - %s\n3 - %s', comment, first, second, third)
end


local function RemoveCharacterFromOptions(altGUID)
	options.args.characters.args.customCharacterOrder.args[altGUID] = nil
end

---comment
---@param altGUID string
function PermoksAccountManager:AddCharacterToOrderOptions(altGUID, altData, accountName)
	local coloredName = altData.class and RAID_CLASS_COLORS[altData.class]:WrapTextInColorCode((altData.name or "") .. ((altData.realm and "-" .. altData.realm) or "")) or ""
	local factionIcon = altData.faction and altData.faction ~= "Neutral" and ("|T%s:%d:%d|t"):format(FACTION_LOGO_TEXTURES[PLAYER_FACTION_GROUP[altData.faction]], 0, 0)

	options.args.characters.args.customCharacterOrder.args[altGUID] = {
		order = altData.order,
		type = "group",
		inline = true,
		name = coloredName .. (factionIcon or ""),
		x = altData,
		args = {
			order = {
				order = 1,
				type = 'input',
				name = 'Order',
				width = 'half',
                disabled = function()
                    return PermoksAccountManager.db.global.options.characters.sortBy ~= 'order'
                end
			},
			remove = {
				order = 2,
				type = 'execute',
				name = 'Remove',
				width = 0.9,
				func = function(info)
					PermoksAccountManager:RemoveCharacter(info[#info-1])
					RemoveCharacterFromOptions(info[#info-1])
				end,
				confirm = true,
				confirmText = 'Are you sure you want to remove this character?',
			},
			[accountName] = {
                order = 3,
                type = 'execute',
                name = 'Filter',
				width = 0.9,
				func = function(info)
					PermoksAccountManager:AddChracterToFilterFromOptions(info[#info-1], info[#info])
					RemoveCharacterFromOptions(info[#info-1])
				end,
				confirm = true,
				confirmText = 'Do you really want to remove this character and add him to the filter?'
		    },
		}
    }
end

-- credit to the author of Shadowed Unit Frames
local function selectDifferentTab(group, key)
    AceConfigDialog.Status[addonName].children.categories.children[group].status.groups.selected = key
    AceConfigRegistry:NotifyChange(addonName)
end

local function deleteCustomCategory(category)
    local categoryButtons = PermoksAccountManager.managerFrame.categoryButtons
    local categoryFrame = PermoksAccountManager.categoryFrame

    if categoryFrame and categoryButtons then
        if categoryFrame.openCategory and categoryFrame.openCategory == category then
            PermoksAccountManager:UpdateCategory(categoryButtons[category], 'open', nil, category)
            categoryFrame.labelColumn.categories[category] = nil
        end
    
        if categoryButtons[category] then
            categoryButtons[category]:Hide()
            categoryButtons[category] = nil
        end
    end

    if PermoksAccountManager.db.global.custom then
        custom_categories[category] = nil
        options.args.categories.args.custom_categories_toggles.args[category] = nil
        options.args.categories.args.customCategories.args[category] = nil
        options.args.order.args.customCategories.args[category] = nil
        options.args.order.args.customCategoriesOrder.args[category] = nil
        selectDifferentTab('customCategories', 'create')
    else
        PermoksAccountManager.db.global.currentCategories[category] = nil
        options.args.categories.args.default_categories_toggles.args[category] = nil
        options.args.categories.args.defaultCategories.args[category] = nil
        options.args.order.args.defaultCategories.args[category] = nil
        options.args.order.args.defaultCategoriesOrder.args[category] = nil
        selectDifferentTab('defaultCategories', 'create')
    end

    PermoksAccountManager.numCategories = PermoksAccountManager.numCategories - 1
end

local function sortCategoryChilds(optionsTable, category)
    local category = PermoksAccountManager.db.global.options[optionsTable][category]
    table.sort(
        category.childs,
        function(a, b)
            return category.childOrder[a] < category.childOrder[b]
        end
    )
end

local function setCategoryOrder(info, value)
    local category = info[#info]
    local optionsTable = info[#info - 1]
    local newOrder = tonumber(value)

    PermoksAccountManager.db.global.options[optionsTable:gsub('Order', '')][category].order = newOrder
    options.args.order.args[optionsTable].args[category].order = newOrder
    AceConfigRegistry:NotifyChange(addonName)
end

local function getCategoryOrder(info)
    local category = info[#info]
    local optionsTable = info[#info - 1]
    return tostring(PermoksAccountManager.db.global.options[optionsTable:gsub('Order', '')][category].order)
end

local function setOrder(info, value)
    local key = info[#info]
    local category = info[#info - 1]
    local optionsTable = info[#info - 2]
    local newOrder = tonumber(value)
    local categoryOptions = PermoksAccountManager.db.global.options[optionsTable][category]

    categoryOptions.childOrder[key] = newOrder
    sortCategoryChilds(optionsTable, category)
    for i, child in pairs(categoryOptions.childs) do
		if options.args.order.args[optionsTable].args[category].args[child] then
        	options.args.order.args[optionsTable].args[category].args[child].order = i
		end
    end

    AceConfigRegistry:NotifyChange(addonName)
    PermoksAccountManager:UpdateAnchorsAndSize(category, nil, true, true)
end

local function getOrder(info)
    local key = info[#info]
    local category = info[#info - 1]
    local optionsTable = info[#info - 2]
    return tostring(PermoksAccountManager.db.global.options[optionsTable][category].childOrder[key])
end

local function setCategoryChildOption(info, value)
    local key = info[#info]
    local category = info[3]
    local categoryType = info[2]
    local categoryOptionsTbl = PermoksAccountManager.db.global.options[categoryType]

    local childs = categoryOptionsTbl[category].childs
    local optionsOrderConfig = options.args.order.args[categoryType].args
    if not value and categoryOptionsTbl[category].childOrder[key] then
        tDeleteItem(childs, key)

        local i = 1
        for _, child in pairs(childs) do
            categoryOptionsTbl[category].childOrder[child] = i
            i = i + 1
        end

        categoryOptionsTbl[category].childOrder[key] = nil
        optionsOrderConfig[category].args[key] = nil
    elseif value and not tContains(childs, key) then
        local order = (#childs + 1)
        tinsert(childs, order, key)

        categoryOptionsTbl[category].childOrder[key] = order

        optionsOrderConfig[category].args[key] = {
            order = order,
            type = 'input',
            name = PermoksAccountManager.labelRows[key].label,
            width = 'half'
        }
    elseif categoryType == 'customCategories' then
        categoryOptionsTbl[category].childOrder[key] = value
        optionsOrderConfig[category].args[key] = nil
    end

    PermoksAccountManager:UpdateAnchorsAndSize(category, nil, true, true)
end

local function getCategoryChildOption(info)
    local key = info[#info]
    local categoryType = info[2]
    local category = info[3]

    local value = PermoksAccountManager.db.global.options[categoryType][category].childOrder[key]
    return type(value) == 'number' or (type(value) == 'boolean' and value)
end

local function addCategoryToggle(optionsTable, category, name, order)
    options.args.categories.args[optionsTable].args[category] = {
        order = order,
        type = 'toggle',
        name = name
    }
end

local function addCategoryOptions(optionsTable, args, category, name, order)
    options.args.categories.args[optionsTable].args[category] = {
        order = order,
        type = 'group',
        name = name,
        hidden = function()
            return not PermoksAccountManager.db.global.options[optionsTable][category].enabled
        end,
        args = args or PermoksAccountManager:GetCustomLabelTable()
    }

    options.args.order.args[optionsTable].args[category] = {
        order = order,
        type = 'group',
        name = name,
        hidden = function()
            return not PermoksAccountManager.db.global.options[optionsTable][category].enabled
        end,
        args = {}
    }
end

local function createOrderOptionsForCategory(categoryOptions, optionsTable, category)
    if not categoryOptions.hideToggle then
        options.args.order.args[optionsTable .. 'Order'].args[category] = {
            order = categoryOptions.order,
            type = 'input',
            name = categoryOptions.name,
            width = 'half'
        }
    end

    table.sort(
        categoryOptions.childs,
        function(a, b)
            if a and b then
                return (categoryOptions.childOrder[a] or 0) < (categoryOptions.childOrder[b] or 0)
            end
        end
    )

    for i, child in pairs(categoryOptions.childs) do
        local name = PermoksAccountManager.labelRows[child] and PermoksAccountManager.labelRows[child].label
        if name then
            options.args.order.args[optionsTable].args[category].args[child] = {
                order = i,
                type = 'input',
                name = name,
                width = 'half'
            }
        end
    end
end

local function addCustomCategory(category, name, isDefault)
    if isDefault then
        local currentCategories = PermoksAccountManager.db.global.currentCategories
        if not currentCategories[category].name then
            PermoksAccountManager.numCategories = PermoksAccountManager.numCategories + 1
            local order = PermoksAccountManager.numCategories

            currentCategories[category] = {
                name = name,
                childs = {},
                childOrder = {},
                order = order,
                hideToggle = false,
                enabled = true,
            }

            addCategoryToggle('default_categories_toggles', category, name, order)
            addCategoryOptions('defaultCategories', nil, category, name, order)
            createOrderOptionsForCategory(PermoksAccountManager.db.global.options.defaultCategories[category], 'defaultCategories', category)

            selectDifferentTab('defaultCategories', category)
            PermoksAccountManager:UpdateOrCreateCategoryButtons()
        end
    elseif not custom_categories[category].name then
        if PermoksAccountManager.db.global.custom then
            PermoksAccountManager.numCategories = PermoksAccountManager.numCategories + 1
        end
        local order = PermoksAccountManager.numCategories

        custom_categories[category].order = order
        custom_categories[category].name = name

        addCategoryToggle('custom_categories_toggles', category, name, order)
        addCategoryOptions('customCategories', nil, category, name, order)
        createOrderOptionsForCategory(PermoksAccountManager.db.global.options.customCategories[category], 'customCategories', category)

        selectDifferentTab('customCategories', category)
        PermoksAccountManager:UpdateOrCreateCategoryButtons()
    end
end

local function createDefaultOptions()
    local numCategories = 0

    for category, info in pairs(PermoksAccountManager.db.global.options.defaultCategories) do
        if not info.hideToggle then
            if PermoksAccountManager.db.global.options.defaultCategories[category].enabled then
                numCategories = numCategories + 1
            end
            addCategoryToggle('default_categories_toggles', category, info.name, info.order)
        end

        local args = {}
        if category == 'general' or not default_categories[category] then
            args = nil
        else
            if info.childs then
                for i, child in pairs(info.childs) do
                    if PermoksAccountManager.labelRows[child] and not PermoksAccountManager.labelRows[child].hideOption then
                        args[child] = {
                            order = i,
                            type = 'toggle',
                            name = PermoksAccountManager.labelRows[child].label
                        }
                    end
                end
            end
        end

        if not PermoksAccountManager.db.global.options.defaultCategories[category].childs then
            PermoksAccountManager:UpdateDefaultCategories(category)
        end

        addCategoryOptions('defaultCategories', args, category, info.name, info.order)
        createOrderOptionsForCategory(PermoksAccountManager.db.global.options.defaultCategories[category], 'defaultCategories', category)
    end

    return numCategories
end

local function createCustomOptions()
    local numCategories = 0

    for category, info in pairs(custom_categories) do
        if not info.hideToggle then
            numCategories = numCategories + 1
            addCategoryToggle('custom_categories_toggles', category, info.name, info.order)
        end

        addCategoryOptions('customCategories', nil, category, info.name, info.order)
        createOrderOptionsForCategory(PermoksAccountManager.db.global.options.customCategories[category], 'customCategories', category)
    end

    return numCategories
end

local labelData = {}
local function EditCustomLabel(labelInfo, labelOptionsInfo)
    labelData = labelInfo
    labelData.oldId = labelOptionsInfo[#labelOptionsInfo]
    AceConfigRegistry:NotifyChange(addonName)
end

local function CreateCustomLabelQuestKey(name)
    return name:lower():gsub(" ", "_")
end

local function CreateCustomLabelButton(labelInfo, options, labelOptionsTbl, labelIdentifier)
    local labelIdentifier = labelIdentifier or labelInfo.labelIdentifier or string.format('custom_%s', labelInfo.name:lower())
    if PermoksAccountManager.labelRows[labelIdentifier] then
        PermoksAccountManager:Print(labelInfo.name .. ' already exists as a custom label.')
        return
    end

    labelOptionsTbl.args[labelInfo.id] = {
        type = 'execute',
        name = labelInfo.name,
        labelIdentifier = labelIdentifier,
        func = function(info)
            EditCustomLabel(labelInfo, info)
        end
    }

    labelInfo.labelIdentifier = labelIdentifier
    options[labelInfo.id] = labelInfo
    PermoksAccountManager.labelRows[labelIdentifier] = {
        label = labelInfo.name,
        type = labelInfo.type,
        customId = labelInfo.id,
        key = labelInfo.type ~= 'quest' and labelInfo.id or nil,
        group = labelInfo.type ~= 'quest' and labelInfo.type or string.format("reset%s%s", labelInfo.reset:sub(1,1):upper(), labelInfo.reset:sub(2)),
        tooltip = labelInfo.type == 'item',
        version = WOW_PROJECT_ID
    }

    if labelInfo.type == 'item' then
        PermoksAccountManager.item[labelInfo.id] = {key = labelIdentifier}

        local module, charInfo = PermoksAccountManager:GetPAMModule('items')
        if module and charInfo then
            module.update(charInfo)
        end
    elseif labelInfo.type == 'currency' then
        PermoksAccountManager.currency[labelInfo.id] = 0

        local module, charInfo = PermoksAccountManager:GetPAMModule('currencies')
        if module and charInfo then
            module.update(charInfo)
        end
    elseif labelInfo.type == 'quest' then
        local key = CreateCustomLabelQuestKey(labelInfo.name)
        if not PermoksAccountManager.quests[key] then
            PermoksAccountManager.quests[key] = {}
            PermoksAccountManager.quests[key][labelInfo.id] = {questType = labelInfo.reset, log = not labelInfo.hidden}

            local module, charInfo = PermoksAccountManager:GetPAMModule('quests')
            if module and charInfo then
                module.update(charInfo)
            end
        else
            PermoksAccountManager:Print(labelInfo.name .. " already exists. Please choose a different one.")
        end
    end
end

local function DeleteCustomLabelButton(labelInfo, isUpdate)
    local labelOptionsTbl = options.args.add.args[labelInfo.type]
    local options = PermoksAccountManager.db.global.options.customLabels[labelInfo.type]
    if labelOptionsTbl and options and labelOptionsTbl.args[labelInfo.id] then
        local oldLabelOptions = labelOptionsTbl.args[labelInfo.id]
        local oldLabeRowInfo = PermoksAccountManager.labelRows[oldLabelOptions.labelIdentifier]

        PermoksAccountManager.labelRows[oldLabelOptions.labelIdentifier] = nil
        labelOptionsTbl.args[labelInfo.id] = nil
        options[labelInfo.id] = nil
        labelData = {}

        if not isUpdate then
            PermoksAccountManager:DeleteUnusedLabels(oldLabelOptions.labelIdentifier)
            PermoksAccountManager:RemoveIdentifierFromLabelTable(oldLabeRowInfo.type, oldLabelOptions.labelIdentifier)
        end
    end
end

local function UpdateCustomLabelButton(labelInfo, options, labelOptionsTbl)
    local oldId = labelInfo.oldId
    if oldId and labelOptionsTbl.args[oldId] then
        local oldlabelOptionsTbl = labelOptionsTbl.args[oldId]
        local labelIdentifier = oldlabelOptionsTbl.labelIdentifier or string.format('custom_%s', labelInfo.name:lower())

        DeleteCustomLabelButton({name = oldlabelOptionsTbl.name, id = oldId, type = labelInfo.type}, true)
        CreateCustomLabelButton(labelInfo, options, labelOptionsTbl, labelIdentifier)
    end
end

function PermoksAccountManager:AddCustomLabelButton(labelInfo)
    local labelOptionsTbl = options.args.add.args[labelInfo.type]
    local options = self.db.global.options.customLabels[labelInfo.type]
    if labelOptionsTbl and options then
        if not labelOptionsTbl.args[labelInfo.id] and not labelOptionsTbl.args[labelInfo.oldId] then
            CreateCustomLabelButton(labelInfo, options, labelOptionsTbl)
        else
            UpdateCustomLabelButton(labelInfo, options, labelOptionsTbl)
        end
    end
end

local function createConfirmPopup()
    -- mostly copied from AceConfigDialog-3.0.lua
    local frame = CreateFrame('Frame', nil, UIParent)
    PermoksAccountManager.confirm = frame
    frame:Hide()
    frame:SetPoint('CENTER', UIParent, 'CENTER')
    frame:SetSize(320, 85)
    frame:SetFrameStrata('TOOLTIP')

    local border = CreateFrame('Frame', nil, frame, 'DialogBorderDarkTemplate')
    border:SetAllPoints(frame)

    local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
    text:SetSize(290, 0)
    text:SetPoint('TOP', 0, -16)
    text:SetText('You need to reload the interface to import a profile.')

    local function newButton(text, parent)
        local button = AceGUI:Create('Button')
        button.frame:SetParent(frame)
        button.frame:SetFrameLevel(button.frame:GetFrameLevel() + 1)
        button:SetText(text)
        return button
    end

    local accept = newButton(ACCEPT)
    accept:SetPoint('BOTTOMRIGHT', frame, 'BOTTOM', -6, 16)
    accept.frame:SetSize(128, 21)
    accept.frame:Show()
    frame.accept = accept

    local cancel = newButton(CANCEL)
    cancel:SetPoint('LEFT', accept.frame, 'RIGHT', 13, 0)
    cancel.frame:SetSize(128, 21)
    cancel.frame:Show()
    cancel:SetCallback(
        'OnClick',
        function()
            frame:Hide()
        end
    )
    frame.cancel = cancel
end

local function createImportExportFrame(options)
    local editGroup = AceGUI:Create('InlineGroup')
    editGroup:SetLayout('fill')
    editGroup.frame:SetParent(options.frame)
    editGroup.frame:SetPoint('BOTTOMLEFT', options.frame, 'BOTTOMLEFT', 17, 52)
    editGroup.frame:SetPoint('TOPRIGHT', options.frame, 'TOPRIGHT', -17, -10)
    editGroup.frame:Hide()

    local editBox = AceGUI:Create('MultiLineEditBox')
    editBox:SetWidth(options.frame:GetWidth() - 20)
    editBox:SetLabel('Export Options')
    editBox.button:Hide()
    editBox.frame:SetClipsChildren(true)
    editBox.editBox:SetScript(
        'OnEscapePressed',
        function()
            editGroup:Close()
        end
    )
    editGroup:AddChild(editBox)

    local close = AceGUI:Create('Button')
    close.frame:SetParent(editGroup.frame)
    close:SetPoint('BOTTOMRIGHT', -27, 13)
    close.frame:SetFrameLevel(close.frame:GetFrameLevel() + 1)
    close:SetHeight(20)
    close:SetWidth(100)
    close.frame:Hide()

    function editGroup.OpenBox(self, mode)
        if mode == 'export' then
            editGroup.frame:Show()

            local optionsString = PermoksAccountManager:OptionsToString()
            editBox.editBox:SetScript(
                'OnChar',
                function()
                    editBox:SetText(optionsString)
                    editBox.editBox:HighlightText()
                end
            )
            editBox.button:Hide()
            editBox:SetText(optionsString)
            editBox.editBox:HighlightText()
            editBox:SetFocus()
            close:SetCallback(
                'OnClick',
                function()
                    editGroup:Close(true)
                end
            )
            close:SetText('Done')
            close.frame:Show()

            C_Timer.After(
                0,
                function()
                    options:ReleaseChildren()
                end
            )
        elseif mode == 'import' then
            editBox:SetText('')
            editGroup.frame:Show()
            editBox:SetFocus()

            close:SetCallback(
                'OnClick',
                function()
                    PermoksAccountManager:ImportOptions(editBox:GetText())
                end
            )
            close:SetText('Import')
            close.frame:Show()

            C_Timer.After(
                0,
                function()
                    options:ReleaseChildren()
                end
            )
        end
    end

    function editGroup.Close(self, openOptions)
        editBox:ClearFocus()
        editGroup.frame:Hide()

        if openOptions then
            PermoksAccountManager.OpenOptions()
        end
    end

    return editGroup
end

function PermoksAccountManager:LoadOptionsTemplate()
    local categoryData = {}
    local syncData = {}

    options = {
        type = 'group',
        name = addonName,
        args = {}
    }

    options.args.categoryToggles = {
        order = 1,
        type = 'group',
        name = L['General'],
        args = {
            general = {
                order = 1,
                type = 'group',
                name = L['General'],
                inline = true,
                set = function(info, value)
                    PermoksAccountManager.db.global.options[info[#info]] = value
                end,
                get = function(info)
                    return PermoksAccountManager.db.global.options[info[#info]]
                end,
                args = {
                    showGuildAttunementButton = {
                        order = 1,
                        type = 'toggle',
                        name = L['Show Guild Attunement Button'],
                        hidden = function()
                            return not PermoksAccountManager.isBC
                        end,
                        set = function(info, value)
                            PermoksAccountManager.db.global.options.showGuildAttunementButton = value
                            PermoksAccountManager.managerFrame.guildAttunementButton:SetShown(value)
                        end,
                        get = function(info)
                            return PermoksAccountManager.db.global.options.showGuildAttunementButton
                        end
                    },
                    showMinimapButton = {
                        order = 2,
                        type = 'toggle',
                        name = L['Show Minimap Button'],
                        set = function(info, value)
                            PermoksAccountManager.db.profile.minimap.hide = not value
                            if not value then
                                LibIcon:Hide('PermoksAccountManager')
                            else
                                LibIcon:Show('PermoksAccountManager')
                            end
                        end,
                        get = function(info)
                            return not PermoksAccountManager.db.profile.minimap.hide
                        end
                    },
                    useCustom = {
                        order = 3,
                        type = 'toggle',
                        name = L['Use Custom'],
                        desc = 'Toggle the use of custom categories.',
                        set = function(info, value)
                            PermoksAccountManager.db.global.custom = value
                            C_UI.Reload()
                        end,
                        get = function(info)
                            return PermoksAccountManager.db.global.custom
                        end,
                        confirm = true,
                        confirmText = 'Requires a reload!'
                    },
                    hideCategory = {
                        order = 4,
                        type = 'toggle',
                        name = L['Hide Category'],
                        desc = L['Hide Category when closing the manager.'],
                        set = function(info, value)
                            if value then
                                PermoksAccountManager:HideAllCategories()
                            end

                            PermoksAccountManager.db.global.options[info[#info]] = value
                        end
                    },
					savePosition = {
						order = 5,
						type = 'toggle',
						name = L['Save Position'],
					},
                    hideWarband = {
                        order = 6,
                        type = 'toggle',
                        name = 'Hide Warband',
                        hidden = function() return not PermoksAccountManager.isRetail end,
                        set = function(info, value)
                            PermoksAccountManager.db.global.options[info[#info]] = value
                            C_UI.Reload()
                        end,
                        confirm = true,
                        confirmText = 'This requires a reload (for now). Are you sure?',
                    },
                }
            },
            commands = {
                order = 5,
                type = 'group',
                name = L['Commands'],
                inline = true,
                args = {
                    export = {
                        order = 0,
                        type = 'execute',
                        name = L['Export'],
                        func = function()
                            imexport:OpenBox('export')
                        end
                    },
                    import = {
                        order = 1,
                        type = 'execute',
                        name = L['Import'],
                        func = function()
                            imexport:OpenBox('import')
                        end
                    },
                    resetDB = {
                        order = 2,
                        type = 'execute',
                        name = L['Reset Categories'],
                        func = function()
                            PermoksAccountManager:ResetCategories()
                            C_UI.Reload()
                        end,
                        confirm = true,
                        confirmText = 'Are you sure?'
                    },
                    weeklyReset = {
                        order = 3,
                        type = 'execute',
                        name = 'Trigger Weekly Reset',
                        func = function()
                            PermoksAccountManager:ResetAccount(PermoksAccountManager.db.global, PermoksAccountManager.account, nil, true)
                            C_UI.Reload()
                        end,
                        confirm = true,
                        confirmText = 'Are you sure?'
                    },
                    dailyReset = {
                        order = 4,
                        type = 'execute',
                        name = 'Trigger Daily Reset',
                        func = function()
                            PermoksAccountManager:ResetAccount(PermoksAccountManager.db.global, PermoksAccountManager.account, true)
                            C_UI.Reload()
                        end,
                        confirm = true,
                        confirmText = 'Are you sure?'
                    },
                    purge = {
                        order = 5,
                        type = 'execute',
                        name = L['Purge'],
                        func = function()
                            PermoksAccountManager:Purge()
                            C_UI.Reload()
                        end,
                        confirm = true,
                        confirmText = 'Are you sure?'
                    }
                }
            }
        }
    }

    options.args.frame = {
        order = 1.5,
        type = 'group',
        name = L['Frame Config'],
        get = function(info)
            local key = info[#info]
            local parentKey = info[#info - 1]
            return PermoksAccountManager.db.global.options[parentKey][key]
        end,
        set = function(info, value)
            local key = info[#info]
            local parentKey = info[#info - 1]
            PermoksAccountManager.db.global.options[parentKey][key] = value
        end,
        args = {
            characters = {
                order = 1,
                type = 'group',
                name = L['Characters'],
                inline = true,
                set = function(info, value)
                    local key = info[#info]
                    local parentKey = info[#info - 1]
                    PermoksAccountManager.db.global.options[parentKey][key] = value

                    if key == 'charactersPerPage' then
                        PermoksAccountManager.db.global.currentPage = 1
                        PermoksAccountManager:SortPages()
                        PermoksAccountManager:UpdatePageButtons()
                        PermoksAccountManager:UpdateAnchorsAndSize('general', true)
                    end
                end,
                args = {
					warning = {
						order = 0,
						type = 'description',
						name = 'Will be moved to the Characters options in an upcoming update.'
					},
                    minLevel = {
                        order = 1,
                        type = 'range',
                        name = L['Minimum Level'],
                        desc = L["Changing this won't remove characters that are below this threshold."],
                        min = 1,
                        max = GetMaxLevelForExpansionLevel(GetExpansionLevel()),
                        bigStep = 1
                    },
                    charactersPerPage = {
                        order = 2,
                        type = 'range',
                        name = L['Characters Per Page'],
                        min = 3,
                        max = 20,
                        bigStep = 1
                    }
                }
            },
            buttons = {
                order = 2,
                type = 'group',
                name = L['Column'],
                inline = true,
                set = function(info, value)
                    local key = info[#info]
                    local parentKey = info[#info - 1]
                    PermoksAccountManager.db.global.options[parentKey][key] = value

                    if key == 'buttonWidth' and PermoksAccountManager.db.global.options[parentKey].buttonTextWidth > value then
                        PermoksAccountManager.db.global.options[parentKey].buttonTextWidth = value
                    end

                    if key == 'justifyH' then
                        PermoksAccountManager.isLayoutDirty = true
                    end

                    PermoksAccountManager:UpdateAnchorsAndSize('general', true)
                    PermoksAccountManager.isLayoutDirty = nil
                end,
                args = {
                    buttonWidth = {
                        order = 1,
                        type = 'range',
                        name = L['Button Width'],
                        set = function(info, value)
                            local key = info[#info]
                            local parentKey = info[#info - 1]
                            local options = PermoksAccountManager.db.global.options

                            options[parentKey][key] = value
                            options.buttons.widthPerAlt = max(value, options.buttons.widthPerAlt)
                            PermoksAccountManager:UpdateAnchorsAndSize('general', true)
                        end,
                        min = 80,
                        max = 250,
                        bigStep = 1
                    },
                    buttonTextWidth = {
                        order = 2,
                        type = 'range',
                        name = L['Text Width'],
                        set = function(info, value)
                            local key = info[#info]
                            local parentKey = info[#info - 1]
                            local options = PermoksAccountManager.db.global.options

                            options[parentKey][key] = value
                            options[parentKey].buttonWidth = max(value, options[parentKey].buttonWidth)
                            options.buttons.widthPerAlt = max(options[parentKey].buttonWidth, options.buttons.widthPerAlt)
                            PermoksAccountManager:UpdateAnchorsAndSize('general', true)
                        end,
                        min = 80,
                        max = 250
                    },
                    justifyH = {
                        order = 3,
                        type = 'select',
                        name = L['Justify Horizontal'],
                        values = {['LEFT'] = 'Left', ['CENTER'] = 'Center', ['RIGHT'] = 'Right'},
                        sorting = {'LEFT', 'CENTER', 'RIGHT'},
                        style = 'dropdown'
                    },
					widthPerAlt = {
                        order = 4,
                        type = 'range',
                        name = L['Column Width'],
                        min = 80,
                        max = 250,
                        bigStep = 1
                    },
                }
            },
            border = {
                order = 3,
                type = 'group',
                name = L['Border'],
                inline = true,
                args = {
                    color = {
                        order = 2,
                        type = 'color',
                        name = L['Border Color'],
                        hasAlpha = true,
                        get = function(info)
                            return unpack(PermoksAccountManager.db.global.options.border.color)
                        end,
                        set = function(info, ...)
                            PermoksAccountManager.db.global.options.border.color = {...}
                            PermoksAccountManager:UpdateBorderColor()
                        end
                    },
                    bgColor = {
                        order = 2,
                        type = 'color',
                        name = L['Background Color'],
                        hasAlpha = true,
                        get = function(info)
                            return unpack(PermoksAccountManager.db.global.options.border.bgColor)
                        end,
                        set = function(info, ...)
                            PermoksAccountManager.db.global.options.border.bgColor = {...}
                            PermoksAccountManager:UpdateBorderColor()
                        end
                    }
                }
            },
            other = {
                order = 3,
                type = 'group',
                name = L['Other'],
                inline = true,
                set = function(info, value)
                    local key = info[#info]
                    local parentKey = info[#info - 1]
                    local options = PermoksAccountManager.db.global.options
                    options[parentKey].updated = options[parentKey].updated or options[parentKey][key]
                    options[parentKey][key] = value

                    PermoksAccountManager:UpdateAnchorsAndSize('general', true)
                end,
                args = {
                    labelOffset = {
                        order = 1,
                        type = 'range',
                        name = L['Label Offset'],
                        min = 0,
                        max = 40,
                        bigStep = 1
                    },
                    frameStrata = {
                        order = 3,
                        type = 'select',
                        name = L['Frame Strata'],
                        values = {BACKGROUND = 'BACKGROUND', LOW = 'LOW', MEDIUM = 'MEDIUM', HIGH = 'HIGH', DIALOG = 'DIALOG', TOOLTIP = 'TOOLTIP'},
                        sorting = {'BACKGROUND', 'LOW', 'MEDIUM', 'HIGH', 'DIALOG', 'TOOLTIP'},
                        set = function(info, value)
                            local key = info[#info]
                            local parentKey = info[#info - 1]

                            PermoksAccountManager.managerFrame:SetFrameStrata(value)
                            PermoksAccountManager.db.global.options[parentKey][key] = value
                        end
                    }
                }
            }
        }
    }

	options.args.characters = {
		order = 1.6,
		type = 'group',
		name = L['Characters'],
		childGroups = 'tab',
		args = {
			test = {
				order = 1,
				type = 'group',
				name = L['Character Options'],
				inline = true,
				args = {
					combine = {
						order = 1,
						type = 'toggle',
						name = L['Combine Accounts'],
						desc = L['Combine Main and Alt Account Characters'],
						set = function(_, value)
                            PermoksAccountManager.db.global.options.characters.combine = value
                            C_UI.Reload()
                        end,
                        get = function(_)
                            return PermoksAccountManager.db.global.options.characters.combine
                        end,
                        confirm = true,
                        confirmText = 'Requires a reload!'
					},
                    sortByIlvl = {
                        order = 2,
                        type = 'select',
                        name = L['Sort By'],
                        values = {ilevel = 'Ilevel', order = 'Custom Order', charLevel = 'Level'},
                        sorting = {'order', 'ilevel', 'charLevel'},
                        hidden = function()
                            return PermoksAccountManager.isWOTLK
                        end,
						set = function(_, value)
                            PermoksAccountManager.db.global.options.characters.sortBy = value
                            if value == 'order' then
                                PermoksAccountManager.db.global.options.characters.sortByLesser = true
                            else
                                PermoksAccountManager.db.global.options.characters.sortByLesser = false
                            end

                            PermoksAccountManager:SortPages()
                            PermoksAccountManager:UpdateAnchorsAndSize('general')
                        end,
                        get = function(_)
                            return PermoksAccountManager.db.global.options.characters.sortBy
                        end,
                    },
                    sortByComparison = {
                        order = 3,
                        type = 'select',
                        name = L['Operator'],
                        values = {greater = '>', lesser = '<'},
                        sorting = {'greater', 'lesser'},
                        width = 'half',
                        disabled = function()
                            return PermoksAccountManager.db.global.options.characters.sortBy == 'order'
                        end,
                        hidden = function()
                            return PermoksAccountManager.isWOTLK
                        end,
						set = function(_, value)
                            PermoksAccountManager.db.global.options.characters.sortByLesser = value == 'lesser'
                            PermoksAccountManager:SortPages()
                            PermoksAccountManager:UpdateAnchorsAndSize('general')
                        end,
                        get = function(_)
                            return PermoksAccountManager.db.global.options.characters.sortByLesser and 'lesser' or 'greater'
                        end,
                    }
				}
			},
			customCharacterOrder = {
				order = 2,
				type = 'group',
				inline = true,
				name = L['Character Info'],
				get = function(info)
					for _, accountInfo in pairs(PermoksAccountManager.db.global.accounts) do
						local data = accountInfo.data[info[#info-1]]
						if data then
							return tostring(data.order)
						end
					end
				end,
				set = function(info, value)
					local order = tonumber(value)
					for _, accountInfo in pairs(PermoksAccountManager.db.global.accounts) do
						local data = accountInfo.data[info[#info-1]]
						if data then
							data.order = order
							options.args.characters.args.customCharacterOrder.args[info[#info-1]].args.order = order
							break
						end
					end

					AceConfigRegistry:NotifyChange(addonName)
					PermoksAccountManager:SortPages()
					PermoksAccountManager:UpdateAnchorsAndSize('general')
				end,
				args = {}
			},
		}
	}

    options.args.categories = {
        order = 2,
        type = 'group',
        name = 'Category Config',
        set = setCategoryChildOption,
        get = getCategoryChildOption,
        args = {
            default_categories_toggles = {
                order = 1,
                type = 'group',
                name = L['Categories'],
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
                hidden = function()
                    return PermoksAccountManager.db.global.custom
                end,
                args = {
                    
                }
            },
            custom_categories_toggles = {
                order = 1,
                type = 'group',
                name = L['Categories'],
                inline = true,
                hidden = function()
                    return not PermoksAccountManager.db.global.custom
                end,
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
                args = {}
            },
            defaultCategories = {
                order = 2,
                type = 'group',
                name = L['Default'],
                childGroups = 'tab',
                args = {
                    create = {
                        order = 100,
                        type = 'group',
                        name = L['Add New'],
                        args = {
                            create_group = {
                                order = 1,
                                type = 'group',
                                name = L['General'],
                                inline = true,
                                args = {
                                    name = {
                                        order = 1,
                                        name = L['Name'],
                                        type = 'input',
                                        validate = function(info, value)
                                            if value:match('[^%w:]') then
                                                return 'You can only use letters, numbers, and colons (for now).'
                                            elseif string.len(value) == 0 then
                                                return "Can't create an empty category."
                                            elseif PermoksAccountManager.db.global.currentCategories[value:lower()].name then
                                                return 'This category already exists.'
                                            end

                                            return true
                                        end,
                                        set = function(info, value)
                                            categoryData.create = value
                                        end,
                                        get = function(info)
                                            return categoryData.create or ''
                                        end
                                    },
                                    create = {
                                        order = 2,
                                        name = L['Create'],
                                        type = 'execute',
                                        func = function(info)
                                            if categoryData.create then
                                                local categoryName = categoryData.create:lower()
                                                addCustomCategory(categoryName, categoryData.create, true)
                                                categoryData.create = nil
                                            end
                                        end
                                    }
                                }
                            }
                        }
                    },
                }
            },
            customCategories = {
                order = 3,
                type = 'group',
                name = L['Custom'],
                childGroups = 'tab',
                args = {
                    create = {
                        order = 100,
                        type = 'group',
                        name = L['Add New'],
                        args = {
                            create_group = {
                                order = 1,
                                type = 'group',
                                name = L['General'],
                                inline = true,
                                args = {
                                    name = {
                                        order = 1,
                                        name = L['Name'],
                                        type = 'input',
                                        validate = function(info, value)
                                            if value:match('[^%w:]') then
                                                return 'You can only use letters, numbers, and colons (for now).'
                                            elseif string.len(value) == 0 then
                                                return "Can't create an empty category."
                                            elseif PermoksAccountManager.db.global.options.customCategories[value:lower()].name then
                                                return 'This category already exists.'
                                            end

                                            return true
                                        end,
                                        set = function(info, value)
                                            categoryData.create = value
                                        end,
                                        get = function(info)
                                            return categoryData.create or ''
                                        end
                                    },
                                    create = {
                                        order = 2,
                                        name = L['Create'],
                                        type = 'execute',
                                        func = function(info)
                                            if categoryData.create then
                                                local categoryName = categoryData.create:lower()
                                                addCustomCategory(categoryName, categoryData.create)
                                                categoryData.create = nil
                                            end
                                        end
                                    }
                                }
                            }
                        }
                    },
                    general = {
                        order = 0,
                        type = 'group',
                        name = L['General'],
                        args = {}
                    }
                }
            }
        }
    }

    options.args.order = {
        order = 4,
        type = 'group',
        name = L['Category Order'],
        args = {
            defaultCategories = {
                order = 1,
                type = 'group',
                name = L['Default'],
                childGroups = 'tab',
                set = setOrder,
                get = getOrder,
                validate = function(_, value)
                    return tonumber(value) or 'Please insert a number.'
                end,
                args = {}
            },
            defaultCategoriesOrder = {
                order = 2,
                type = 'group',
                name = L['Default'],
                inline = true,
                set = setCategoryOrder,
                get = getCategoryOrder,
                validate = function(info, value)
                    local newOrder = tonumber(value)
                    return (not newOrder and 'Please insert a number.') or (newOrder <= 0 and 'Please insert a number greater than 0') or true
                end,
                args = {}
            },
            customCategories = {
                order = 3,
                type = 'group',
                name = L['Custom'],
                childGroups = 'tab',
                set = setOrder,
                get = getOrder,
                validate = function(_, value)
                    return tonumber(value) or 'Please insert a number.'
                end,
                args = {}
            },
            customCategoriesOrder = {
                order = 4,
                type = 'group',
                name = L['Custom'],
                inline = true,
                set = setCategoryOrder,
                get = getCategoryOrder,
                validate = function(info, value)
                    local newOrder = tonumber(value)
                    return (not newOrder and 'Please insert a number.') or (newOrder <= 0 and 'Please insert a number greater than 0') or true
                end,
                args = {}
            }
        }
    }

    options.args.sync = {
        order = 5,
        type = 'group',
        name = L['Account Syncing'],
        childGroups = 'tab',
        args = {
            syncOptions = {
                order = 1,
                type = 'group',
                name = L['Sync Accounts'],
                args = {
                    explanation = {
                        order = 1,
                        type = 'description',
                        name = function()
                            return GetAccountSyncDescription()
                        end
                    },
                    name = {
                        order = 2,
                        name = L['Name'],
                        type = 'input',
                        validate = function(info, value)
                            if value:match('[%d%s%p%c]') then
                                return 'Character names can only consist of letters.'
                            end

                            return true
                        end,
                        set = function(info, value)
                            syncData.name = value
                        end,
                        get = function(info)
                            return syncData.name or ''
                        end
                    },
                    realm = {
                        order = 3,
                        name = L['Realm (if different from current)'],
                        type = 'input',
                        hidden = function()
                            local connectedRealms = GetAutoCompleteRealms()
                            return PermoksAccountManager.isBC or #connectedRealms == 0
                        end,
                        validate = function(info, value)
                            if value:match('[^%a]') then
                                return 'Realm names can only consist of letters.'
                            end

                            return true
                        end,
                        set = function(info, value)
                            syncData.realm = value
                        end,
                        get = function(info)
                            return syncData.realm or ''
                        end
                    },
                    sync = {
                        order = 4,
                        name = L['Sync (Beta)'],
                        type = 'execute',
                        func = function(info)
                            if syncData.name then
                                PermoksAccountManager:RequestAccountSync(syncData.name, syncData.realm)
                            end
                        end
                    },
                    forceUpdate = {
                        order = 5,
                        name = L['Send Update'],
                        type = 'execute',
                        desc = 'To update the character list. Make sure to click this button on a character that existed in the manager at the time of syncing.',
                        disabled = function()
                            return PermoksAccountManager:GetNumAccounts() == 1
                        end,
                        func = function(info)
                            PermoksAccountManager:SendAccountUpdates()
                        end
                    }
                }
            },
            syncedAccounts = {
                order = 2,
                type = 'group',
                name = L['Synced Accounts'],
                args = {}
            }
        }
    }

    options.args.add = {
        order = 6,
        type = 'group',
        name = L['Custom Labels'],
        childGroups = 'tab',
		hidden = function()
            return not PermoksAccountManager.db.global.customLabels
        end,
        args = {
            addTab = {
                order = 1,
                type = 'group',
                name = function() 
                    if labelData.oldId then
                        return L['Save']
                    else
                        return L['Create']
                    end
                end,
                inline = true,
                args = {
                    name = {
                        order = 1,
                        name = L['Name'],
                        type = 'input',
                        validate = function(info, value)
                            if value:match('[^%a%s:]') then
                                return 'You can only use letters (for now).'
                            elseif string.len(value) == 0 then
                                return "Can't create an empty label."
                            end

                            return true
                        end,
                        set = function(info, value)
                            labelData.name = value
                        end,
                        get = function(info)
                            return labelData.name or ''
                        end
                    },
                    id = {
                        order = 3,
                        name = L['ID'],
                        type = 'input',
                        width = 'half',
                        validate = function(info, value)
                            if not tonumber(value) then
                                return 'IDs only contain digits.'
                            end

                            return true
                        end,
                        disabled = function()
                            return labelData.oldId and true or false
                        end,
                        set = function(info, value)
                            labelData.id = tonumber(value)
                        end,
                        get = function()
                            return labelData.id and tostring(labelData.id) or ''
                        end
                    },
                    labelType = {
                        order = 2,
                        name = L['Type'],
                        type = 'select',
                        values = {item = L['Item'], currency = L['Currency'], quest = L['Quest'], custom = L['Custom']},
                        sorting = {'item', 'currency', 'quest', 'custom'},
                        --width = 'half',
                        disabled = function()
                            return labelData.oldId and true or false
                        end,
                        set = function(info, value)
                            labelData.type = value
                        end,
                        get = function(info)
                            return labelData.type or ''
                        end
                    },
                    quest_options = {
                        order = 3.5,
                        name = 'Quest',
                        type = 'header',
                        hidden = function()
                            return labelData.type and labelData.type ~= 'quest' or not labelData.type
                        end,
                    },
                    reset = {
                        order = 4,
                        name = L['Reset'],
                        type = 'select',
                        values = {daily = L['Daily'], weekly = L['Weekly'], biweekly = L['Biweekly']},
                        sorting = {'daily', 'biweekly', 'weekly'},
                        --width = 'half',
                        hidden = function()
                            return labelData.type and labelData.type ~= 'quest' or not labelData.type
                        end,
                        set = function(info, value)
                            labelData.reset = value
                        end,
                        get = function(info)
                            return labelData.reset or ' '
                        end
                    },
                    inlog = {
                        order = 5,
                        name = L['Hidden'],
                        type = 'toggle',
                        desc = 'If you can\'t have this quest in your visible quest log then toggle this option so it gets tracked correctly.',
                        --width = 'half',
                        hidden = function()
                            return labelData.type and labelData.type ~= 'quest' or not labelData.type
                        end,
                        set = function(info, value)
                            labelData.hidden = value
                        end,
                        get = function(info)
                            return labelData.hidden or false
                        end
                    },
                    custom_options = {
                        order = 6,
                        name = 'Custom',
                        type = 'header',
                        hidden = function()
                            return labelData.type and labelData.type ~= 'custom' or not labelData.type
                        end,
                    },
                    custom_events  ={
                        order = 6.1,
                        name = 'Events',
                        type = 'input',
                        width = 'full',
                        hidden = function()
                            return labelData.type and labelData.type ~= 'custom' or not labelData.type
                        end,
                        get = function()
                            return labelData.events
                        end,
                        set = function(_, value)
                            labelData.events = value
                        end
                    },
                    custom_update = {
                        order = 6.2,
                        name = 'Update Function',
                        type = 'input',
                        multiline = true,
                        width = 'full',
                        hidden = function()
                            return labelData.type and labelData.type ~= 'custom' or not labelData.type
                        end,
                        get = function()
                            if not labelData.update then
                                return [[function(data)

end]]
                            else
                                return labelData.update
                            end
                        end,
                        set = function(_, value)
                            labelData.update = value
                        end
                    },
                    custom_label_string = {
                        order = 6.3,
                        name = 'String Function',
                        type = 'input',
                        multiline = true,
                        width = 'full',
                        hidden = function()
                            return labelData.type and labelData.type ~= 'custom' or not labelData.type
                        end,
                        get = function()
                            if not labelData.labelString then
                                return [[function(data)

end]]
                            else
                                return labelData.labelString
                            end
                        end,
                        set = function(_, value)
                            labelData.labelString = value
                        end
                    },
                    sep1 = {
                        order = 19,
                        name = '',
                        type = 'header',
                    },
                    create = {
                        order = 20,
                        name = function()
                            if labelData.oldId then
                                return L['Edit']
                            else
                                return L['Create']
                            end
                        end,
                        type = 'execute',
                        func = function(info)
                            if labelData.name and labelData.id and labelData.type then
                                PermoksAccountManager:AddCustomLabelButton(labelData)
                                PermoksAccountManager.UpdateCustomLabelOptions()
                            end

                            labelData = {}
                        end
                    },
                    delete = {
                        order = 21,
                        name = L['Delete'],
                        type = 'execute',
                        disabled = function()
                            if labelData.oldId then
                                return false
                            else 
                                return true
                            end
                        end,
                        func = function(info)
                            if labelData.name and labelData.id and labelData.type then
                                DeleteCustomLabelButton(labelData)
                            end
                        end,
                    }
                }
            },
            desc = {
                order = 1.5,
                type = 'description',
                name = 'To edit/delete custom labels click on the button for the label below.',
                fontSize = 'medium',
            },
            item = {
                order = 2,
                type = 'group',
                name = L['Items'],
                args = {}
            },
            currency = {
                order = 3,
                type = 'group',
                name = L['Currencies'],
                args = {}
            },
            quest = {
                order = 4,
                type = 'group',
                name = L['Quests'],
                args = {}
            }
        }
    }

    -- TODO: Retail differentiation
    options.args.experimental = {
        order = 7,
        type = 'group',
        name = L['Experimental'],
        set = function(info, value)
            PermoksAccountManager.db.global.options[info[#info]] = value
            PermoksAccountManager:SortPages()
            PermoksAccountManager:UpdateAnchorsAndSize('general', nil, nil, true)
        end,
        get = function(info)
            return PermoksAccountManager.db.global.options[info[#info]]
        end,
        args = {
            testOptions = {
                order = 7,
                type = 'group',
                name = L['Test Options'],
                inline = true,
                args = {
                    currencyIcons = {
                        order = 1,
                        type = 'toggle',
                        name = L['Currency Icons'],
                        retailOnly = false
                    },
                    itemIcons = {
                        order = 2,
                        type = 'toggle',
                        name = L['Item Icons'],
                        retailOnly = false
                    },
                    showCurrentSpecIcon = {
                        order = 3,
                        type = 'toggle',
                        name = L['Show Current Spec'],
                        retailOnly = true
                    },
                    useScoreColor = {
                        order = 4,
                        type = 'toggle',
                        name = L['Color Mythic+ Score'],
                        retailOnly = true
                    },
                    useOutline = {
                        order = 5,
                        type = 'toggle',
                        name = L['Outline'],
                        set = function(info, value)
                            PermoksAccountManager.db.global.options[info[#info]] = value
                            PermoksAccountManager:UpdateAllFonts()
                        end,
                        retailOnly = true
                    },
                    questCompletionString = {
                        order = 6,
                        type = 'input',
                        name = L['Quest Completion String'],
                        retailOnly = false
                    },
                    font = {
                        order = 7,
                        type = 'select',
                        name = 'Font',
                        values = LSM:HashTable('font'),
                        set = function(info, value)
                            PermoksAccountManager.db.global.options[info[#info]] = value
                            PermoksAccountManager:UpdateAllFonts()
                        end,
                        dialogControl = 'LSM30_Font'
                    },
                    fontSize = {
                        order = 8,
                        type = 'range',
                        name = 'Font Size',
                        min = 9,
                        max = 16,
                        step = 1,
                        set = function(info, value)
                            PermoksAccountManager.db.global.options[info[#info]] = value
                            PermoksAccountManager:UpdateAllFonts()
                        end,
                    },
                    itemIconPosition = {
                        order = 9,
                        type = 'select',
                        name = 'Item Icon Position',
                        values = {left = 'Left', right = 'Right'}
                    },
                    currencyIconPosition = {
                        order = 10,
                        type = 'select',
                        name = 'Currency Icon Position',
                        values = {left = 'Left', right = 'Right'}
                    },
                    currentCharacterFirstPosition = {
                        order = 11,
                        type = 'toggle',
                        name = 'Prioritise current char',
                        desc = 'Always show the current character at the front'
                    },
                    name = {
                        order = 12,
                        type = 'input',
                        name = 'Rename Main Account',
                        desc = nil,
                        get = function(info)
                            return PermoksAccountManager.db.global.accounts.main.name
                        end,
                        set = function(info, value)
                            changeAccountName('main', value)
                        end
                    },
                    showOnEnter = {
                        order = 13,
                        type = 'toggle',
                        name = 'Show On Mouseover',
                        desc = 'Show the window while hovering over the minimap button'
                    }
                }
            }
        }
    }
end

function PermoksAccountManager:LoadCustomLabelButtons()
    for _, customLabels in pairs(self.db.global.options.customLabels) do
        for _, labelInfo in pairs(customLabels) do
            self:AddCustomLabelButton(labelInfo)
        end
    end
end

function PermoksAccountManager.UpdateCustomLabelOptions(newDefault)
    newDefault = newDefault or PermoksAccountManager:GetCustomLabelTable(true)

    for category, args in pairs(options.args.categories.args.customCategories.args) do
        if category ~= 'create' then
            args.args = newDefault
        end
    end

    options.args.categories.args.defaultCategories.args.general.args = newDefault
    AceConfigRegistry:NotifyChange(addonName)
end

function PermoksAccountManager.OpenOptions(closeImexport)
    if closeImexport then
        PermoksAccountManager.CloseImexport()
    end

    AceConfigDialog:Open(addonName, PermoksAccountManager.optionsFrame)
end

local function copyTable(obj)
    if type(obj) ~= 'table' then
        return obj
    end
    local res = {}
    for k, v in pairs(obj) do
        res[copyTable(k)] = copyTable(v)
    end
    return res
end

do
    local labelTable = {
        delete = {
            order = 0.5,
            type = 'execute',
            name = L['Delete'],
            func = function(info)
                deleteCustomCategory(info[#info - 1])
                PermoksAccountManager:UpdateOrCreateCategoryButtons()
            end,
            hidden = function(info)
                if info[#info - 1] == 'general' then
                    return true
                end
            end,
            confirm = true
        }
    }
    local function UpdateLabelTable()
        for key, info in pairs(PermoksAccountManager.labelRows) do
            if not info.hideOption then
                local group = info.group or 'other'
                local groupInfo = PermoksAccountManager.groups[group]

                labelTable[group] =
                    labelTable[group] or
                    {
                        order = groupInfo.order,
                        type = 'group',
                        name = groupInfo.label,
                        inline = true,
                        args = {}
                    }

                labelTable[group].args[key] =
                    labelTable[group].args[key] or
                    {
                        type = 'toggle',
                        name = info.label
                    }
            end
        end
    end

    function PermoksAccountManager:RemoveIdentifierFromLabelTable(group, labelIdentifier)
        if labelTable[group] then
            labelTable[group].args[labelIdentifier] = nil
            AceConfigRegistry:NotifyChange(addonName)
        end
    end

    function PermoksAccountManager:GetCustomLabelTable(update)
        if update then
            UpdateLabelTable()
        end

        return labelTable
    end

    function PermoksAccountManager:LoadCustomLabelTable()
        UpdateLabelTable()
    end
end

function PermoksAccountManager:LoadOptions()
    PermoksAccountManager.numCategories = 0
    if type(PermoksAccountManager.db.global.options.defaultCategories.general.childs) == 'nil' then
        PermoksAccountManager.db.global.options.defaultCategories = copyTable(default_categories)
    end

    custom_categories = PermoksAccountManager.db.global.options.customCategories

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

    PermoksAccountManager.optionsFrame = AceGUI:Create('Frame')
    PermoksAccountManager.optionsFrame:EnableResize(true)
    PermoksAccountManager.optionsFrame:Hide()

    AddAccounts()
    createConfirmPopup()
    imexport = imexport or createImportExportFrame(PermoksAccountManager.optionsFrame)

    AceConfigRegistry:RegisterOptionsTable(addonName, options, true)
end

function PermoksAccountManager:CloseImexport()
    if imexport then
        imexport.Close()
    end
end

function PermoksAccountManager:UpdateDefaultCategories(key)
    PermoksAccountManager.db.global.options.defaultCategories[key] = copyTable(default_categories[key])
end

function PermoksAccountManager:AddLabelToDefaultCategory(category, label, customOrder)
	local categoryTbl = self.db.global.options.defaultCategories[category]

	if categoryTbl and categoryTbl.childOrder and not categoryTbl.childOrder[label] then
		local numChildren = #categoryTbl.childs
		categoryTbl.childOrder[label] = customOrder or numChildren + 1
		tinsert(categoryTbl.childs, customOrder and ceil(customOrder) or numChildren + 1, label)
	end
end

function PermoksAccountManager:ReplaceLabelOfDefaultCategory(category, oldLabel, newLabel)
	local categoryTbl = self.db.global.options.defaultCategories[category]

    if categoryTbl and categoryTbl.childOrder[oldLabel] then
        local index = categoryTbl.childOrder[oldLabel]

        if categoryTbl.childs[index] ~= oldLabel and categoryTbl.childs then
            for i, label in pairs(categoryTbl.childs) do
                if label == oldLabel then
                    index = i
                    break
                end
            end
        end

        categoryTbl.childOrder[oldLabel] = nil
        categoryTbl.childOrder[newLabel] = index
        categoryTbl.childs[index] = newLabel
    end
end

function PermoksAccountManager:RemoveLabelFromDefaultCategory(category, label)
	local categoryTbl = self.db.global.options.defaultCategories[category]

    if categoryTbl and categoryTbl.childOrder[label] then
        categoryTbl.childOrder[label] = nil

        for i, l in pairs(categoryTbl.childs) do
            if l == label then
                categoryTbl.childs[i] = nil
                break
            end
        end
    end
end

function PermoksAccountManager:FixOrderOfDefaultCategories()
    for _, categoryTbl in pairs(self.db.global.options.defaultCategories) do
        local newChilds = {}
        for _, label in pairs(categoryTbl.childs) do
            tinsert(newChilds, label)
        end

        categoryTbl.childs = newChilds
        
        wipe(categoryTbl.childOrder)
        for i, label in ipairs(categoryTbl.childs) do
            categoryTbl.childOrder[label] = i
        end
    end
end

function PermoksAccountManager:OptionsToString()
    local export = {internalVersion = self.db.global.internalVersion, custom = self.db.global.custom, options = self.db.global.options}

    local serialized = LibSerialize:Serialize(export)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encode = LibDeflate:EncodeForPrint(compressed)

    return encode or 'HMM'
end

function PermoksAccountManager:ImportOptions(optionsString)
    local decoded = LibDeflate:DecodeForPrint(optionsString)
    if not decoded then
        return
    end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then
        return
    end
    local success, data = LibSerialize:Deserialize(decompressed)
    if not success then
        return
    end

    local categories = data.options.customCategories
    for category, info in pairs(categories) do
        for identifier, index in pairs(info.childOrder) do
            if not PermoksAccountManager.labelRows[identifier] then
                info.childOrder[identifier] = nil
                tDeleteItem(info.childs, identifier)
            end
        end
    end

    PermoksAccountManager.confirm.accept:SetCallback(
        'OnClick',
        function()
            PermoksAccountManager.db.global.custom = data.custom
            PermoksAccountManager.db.global.options = data.options
            PermoksAccountManager.db.global.internalVersion = data.internalVersion

            C_UI.Reload()
        end
    )

    PermoksAccountManager.confirm:Show()
end
