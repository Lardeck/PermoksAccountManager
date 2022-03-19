local addonName, PermoksAccountManager = ...

PermoksAccountManager = LibStub('AceAddon-3.0'):NewAddon(PermoksAccountManager, 'PermoksAccountManager', 'AceConsole-3.0', 'AceEvent-3.0')

-- Create minimap icon with LibDataBroker.
local PermoksAccountManagerLDB =
    LibStub('LibDataBroker-1.1'):NewDataObject(
    'PermoksAccountManager',
    {
        type = 'data source',
        text = 'Permoks Account Manager',
        icon = 'Interface/Icons/achievement_guildperk_everybodysfriend.blp',
        OnClick = function(self, button)
            if button == 'LeftButton' then
                if PermoksAccountManagerFrame:IsShown() then
                    PermoksAccountManager:HideInterface()
                else
                    PermoksAccountManager:ShowInterface()
                end
            elseif button == 'RightButton' then
                PermoksAccountManager:OpenOptions()
            end
        end,
        OnTooltipShow = function(tt)
            tt:AddLine('|cfff49b42Permoks Account Manager|r')
            tt:AddLine('|cffffffffLeft-click|r to open the Manager')
            tt:AddLine('|cffffffffRight-click|r to open options')
            tt:AddLine("Type '/pam minimap' to hide the Minimap Button!")
        end
    }
)

local AceGUI = LibStub('AceGUI-3.0')
local LibIcon = LibStub('LibDBIcon-1.0')
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local LSM = LibStub('LibSharedMedia-3.0')
local VERSION = '1.0.5'
local INTERNALVERSION = 3
local INTERNALBCVERSION = 1
local defaultDB = {
    profile = {
        minimap = {
            hide = false
        }
    },
    global = {
        blacklist = {},
        accounts = {
            main = {
                name = L['Main'],
                data = {},
                pages = {}
            }
        },
        currentPage = 1,
        numAccounts = 1,
        data = {},
        completionData = {['**'] = {numCompleted = 0}},
        alts = 0,
        synchedCharacters = {},
        blockedCharacters = {},
        options = {
            buttons = {
                updated = false,
                buttonWidth = 120,
                buttonTextWidth = 110,
                justifyH = 'LEFT'
            },
            other = {
                updated = false,
                labelOffset = 5,
                widthPerAlt = 120,
                frameStrata = 'MEDIUM'
            },
            characters = {
                charactersPerPage = 6,
                minLevel = GetMaxLevelForExpansionLevel(GetExpansionLevel())
            },
            border = {
                edgeSize = 5,
                color = {0.39, 0.39, 0.39, 1},
                bgColor = {0.1, 0.1, 0.1, 0.9}
            },
            font = 'Expressway',
            savePosition = false,
            showOptionsButton = false,
            showGuildAttunementButton = false,
            currencyIcons = true,
            itemIcons = true,
            useScoreColor = true,
            showCurrentSpecIcon = true,
            questCompletionString = '+',
            useOutline = true,
            itemIconPosition = 'right',
            currencyIconPosition = 'right',
            customCategories = {
                general = {
                    childOrder = {characterName = 1, ilevel = 2},
                    childs = {'characterName', 'ilevel'},
                    order = 0,
                    hideToggle = true,
                    name = 'General',
                    enabled = true
                },
                ['**'] = {childOrder = {}, childs = {}, enabled = true}
            },
            defaultCategories = {
                ['**'] = {
                    enabled = true
                }
            },
			customLabels = {
				quests = {},
				item = {},
				currency = {},
			}
        },
        currentCallings = {},
        quests = {},
        currencyInfo = {},
        itemIcons = {},
        position = {},
        version = VERSION
    }
}

--- Create an iterator for a hash table.
-- @param t:table The table to create the iterator for.
-- @param order:function A sort function for the keys.
-- @return function The iterator usable in a loop.
local function spairs(t, order)
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end

    if order then
        table.sort(
            keys,
            function(a, b)
                return order(t, a, b)
            end
        )
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]], keys[i + 1]
        end
    end
end

--- This function will be called when the user leaves the button the tooltip belonged to.
local function Tooltip_OnLeave(self)
    if self.tooltip then
        LibQTip:Release(self.tooltip)
        self.tooltip = nil
    end
end

local CreateLabelButton, CreateManagerButton, LoadFonts, UpdateFonts
do
    local normalFont, smallFont, mediumLargeFont, largeFont

    --- Initialize the fonts
    function LoadFonts()
        local options = PermoksAccountManager.db.global.options
        local outline = options.useOutline and 'OUTLINE' or nil
        local font = LSM:Fetch('font', options.font)

        normalFont = CreateFont('PAM_NormalFont')
        normalFont:SetFont(font, 11, outline)
        normalFont:SetTextColor(1, 1, 1, 1)

        smallFont = CreateFont('PAM_SmallFont')
        smallFont:SetFont(font, 9, outline)
        smallFont:SetTextColor(1, 1, 1, 1)

        mediumLargeFont = CreateFont('PAM_MediumLargeFont')
        mediumLargeFont:SetFont(font, 12, outline)
        mediumLargeFont:SetTextColor(1, 1, 1, 1)

        largeFont = CreateFont('PAM_LargeFont')
        largeFont:SetFont(font, 17, outline)
        largeFont:SetTextColor(1, 1, 1, 1)
    end

    --- Update the font path of all previously created fonts.
    function UpdateFonts()
        local options = PermoksAccountManager.db.global.options
        local outline = options.useOutline and 'OUTLINE' or nil
        local font = LSM:Fetch('font', options.font)
        normalFont:SetFont(font, 11, outline)
        smallFont:SetFont(font, 9, outline)
        mediumLargeFont:SetFont(font, 13, outline)
        largeFont:SetFont(font, 17, outline)
    end

    --- Create the text for a normal button.
    -- @param button:Button The button to create the font object for.
    -- @param column:table The information table for the current column.
    -- @param alt_data:table A table with information about a character.
    -- @param text:string Text that can be used instead of generating a new one with alt_data.
    -- @param buttonOptions:table
    -- TODO
    local function CreateInfoButton(button, column, buttonOptions)
        button:SetNormalFontObject((column.big and largeFont) or (column.small and smallFont) or normalFont)
        button:SetText(' ')

        local fontString = button:GetFontString()
        if fontString then
            button.fontString = fontString
            fontString:SetSize(110, 20)
            fontString:SetJustifyV(column.justify or 'MIDDLE')
            fontString:SetJustifyH(buttonOptions.justifyH)
        end
    end

    --- Create the text for a label button.
    -- @param button:Button The button to create the font object for.
    -- @param buttonOptions:table
    -- TODO
    local function CreateMenuButton(button)
        button:SetNormalFontObject(mediumLargeFont)
        button:SetText(' ')

        local fontString = button:GetFontString()
        fontString:SetSize(130, 20)
        fontString:SetJustifyV('CENTER')
        fontString:SetJustifyH('RIGHT')
    end

    --- Create a button with a text.
    -- @param type:string The type of button to create.
    -- @param parent:Frame The parent frame for the button.
    -- @param column:table The column data for the current column.
    -- @param alt_data:table
    -- @param index:int If the index is given then create a texture.
    -- @param width:float Possible custom width.
    function CreateLabelButton(type, parent, column, index, width)
        local buttonOptions = PermoksAccountManager.db.global.options.buttons
        local button = CreateFrame('Button', nil, parent)
        button:SetSize(width or buttonOptions.buttonWidth, 20)
        button:SetPushedTextOffset(0, 0)

        if type == 'row' then
            if not column.hideOption and not column.hideLabel then
                local highlightTexture = button:CreateTexture()
                highlightTexture:SetAllPoints()
                highlightTexture:SetColorTexture(0.5, 0.5, 0.5, 0.5)
                button:SetHighlightTexture(highlightTexture)

                if index then
                    local normalTexture = button:CreateTexture(nil, 'BACKGROUND')
                    normalTexture:SetAllPoints()
                    button:SetNormalTexture(normalTexture)
                    button.normalTexture = normalTexture
                end
            end
            CreateInfoButton(button, column, buttonOptions)
        elseif type == 'label' then
            CreateMenuButton(button)
        end

        return button
    end

    function CreateManagerButton(width, height, text)
        local button = CreateFrame('Button', nil, PermoksAccountManager.managerFrame)
        button:SetSize(width, height)

        local normalTexture = button:CreateTexture()
        button.normalTexture = normalTexture
        normalTexture:SetSize(width + 4, height + 11)
        normalTexture:ClearAllPoints()
        normalTexture:SetPoint('TOPLEFT', -2, 0)
        normalTexture:SetAtlas('auctionhouse-nav-button', false)

        button:SetHighlightAtlas('auctionhouse-nav-button-highlight', false)
        PermoksAccountManager:SkinButtonElvUI(button)

        local fontString = button:CreateFontString(nil, 'OVERLAY', 'PAM_MediumLargeFont')
        button.Text = fontString
        fontString:ClearAllPoints()
        fontString:SetAllPoints()
        fontString:SetText(text)
        fontString:SetTextColor(1, 1, 1, 1)

        local selected = button:CreateTexture()
        button.selected = selected
        selected:SetSize(button:GetSize())
        selected:ClearAllPoints()
        selected:SetPoint('CENTER', 0, -1)
        selected:SetAtlas('auctionhouse-nav-button-select', false)
        selected:Hide()

        button:SetScript(
            'OnMouseDown',
            function()
                fontString:AdjustPointsOffset(1, -1)
            end
        )
        button:SetScript(
            'OnMouseUp',
            function()
                fontString:AdjustPointsOffset(-1, 1)
            end
        )

        return button
    end
end

do
    local BACKDROP_PAM_NO_BG = {
        edgeFile = 'Interface/Buttons/WHITE8X8',
        edgeSize = 5
    }

    local BACKDROP_PAM_BG = {
        edgeFile = 'Interface/Buttons/WHITE8X8',
        bgFile = 'Interface/Buttons/WHITE8X8',
        edgeSize = 5
    }

    local backdrops = {}
    function PermoksAccountManager:UpdateBorder(backdrop, anchor, useBG)
        local borderOptions = self.db.global.options.border
        local color = borderOptions.color
        local bgColor = borderOptions.bgColor or {0.1, 0.1, 0.1, 0.9}
        backdrop:SetBackdrop(nil)

        if anchor then
            backdrop:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -5, 5)
            backdrop:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 5, -5)
        end

        if useBG then
            backdrop:SetBackdrop(BACKDROP_PAM_BG)
            backdrop:SetBackdropColor(unpack(bgColor))
            backdrops[backdrop] = true
        else
            backdrop:SetBackdrop(BACKDROP_PAM_NO_BG)
            backdrops[backdrop] = false
        end

        backdrop:SetBackdropBorderColor(unpack(color))
    end

    function PermoksAccountManager:UpdateBorderColor()
        local borderOptions = self.db.global.options.border
        local color = borderOptions.color
        local bgColor = borderOptions.bgColor or {0.1, 0.1, 0.1, 0.9}

        for backdrop, useBG in pairs(backdrops) do
            if useBG then
                backdrop:SetBackdropColor(unpack(bgColor))
            end
            backdrop:SetBackdropBorderColor(unpack(color))
        end
    end
end

do
    local PermoksAccountManagerEvents = {
        'CHAT_MSG_PARTY',
        'CHAT_MSG_PARTY_LEADER',
        'CHAT_MSG_GUILD'
    }

    --- Initialization called on ADDON_LOADED
    function PermoksAccountManager:OnInitialize()
        self.spairs = spairs
        self.isBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC

        -- init databroker
        self.db = LibStub('AceDB-3.0'):New('PermoksAccountManagerDB', defaultDB, true)
        PermoksAccountManager:RegisterChatCommand('pam', 'HandleChatCommand')
        PermoksAccountManager:HandleSecretPsst()
        LibIcon:Register('PermoksAccountManager', PermoksAccountManagerLDB, self.db.profile.minimap)

        PermoksAccountManager:CreateFrames()
        self.managerFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
        self.managerFrame:SetScript(
            'OnEvent',
            function(self, event, arg1, arg2)
                if event == 'PLAYER_ENTERING_WORLD' then
                    if arg1 or arg2 then
                        PermoksAccountManager:OnLogin()
                        if not PermoksAccountManager.isBC then
                            FrameUtil.RegisterFrameForEvents(self, PermoksAccountManagerEvents)
                        end
                    end
                else
                    if arg1 and arg1:lower() == '!allkeys' then
                        PermoksAccountManager:PostKeysIntoChat(event == 'CHAT_MSG_GUILD' and 'guild' or 'party')
                    end
                end
            end
        )
    end

    --- Not used right now.
    function PermoksAccountManager:OnEnable()
    end

    --- Not used right now.
    function PermoksAccountManager:OnDisable()
    end
end

function PermoksAccountManager:Debug(...)
    if self.db.global.options.debug then
        self:Print(...)
    end
end

function PermoksAccountManager:CreateFrames()
    local options = self.db.global.options

    local managerFrame = CreateFrame('Frame', 'PermoksAccountManagerFrame', UIParent)
    self.managerFrame = managerFrame
    managerFrame:SetFrameStrata(options.other.frameStrata)
    managerFrame:ClearAllPoints()
    managerFrame:Hide()
    tinsert(UISpecialFrames, 'PermoksAccountManagerFrame')

    -- Restore saved position
    if options.savePosition then
        local position = self.db.global.position
        managerFrame:SetPoint(position.point or 'TOP', WorldFrame, position.relativePoint or 'TOP', position.xOffset or 0, position.yOffset or -300)
    else
        managerFrame:SetPoint('TOPLEFT', WorldFrame, 'TOPLEFT', WorldFrame:GetWidth() / 3, -300)
    end

    local managerFrameBackdrop = CreateFrame('Frame', nil, managerFrame, 'BackdropTemplate')
    managerFrame.backdrop = managerFrameBackdrop
    self:UpdateBorder(managerFrameBackdrop, managerFrame, true)

    managerFrame.labelColumn = CreateFrame('Button', nil, managerFrame)
    managerFrame.labelColumn:SetPoint('TOPLEFT', managerFrame, 'TOPLEFT', 0, -5)
    managerFrame.labelColumn:SetPoint('BOTTOMRIGHT', managerFrame, 'BOTTOMLEFT', 140, 0)
    managerFrame.altColumns = {general = {}}

    managerFrame.topDragBar = CreateFrame('Frame', nil, managerFrame, 'BackdropTemplate')
    managerFrame.topDragBar:ClearAllPoints()
    managerFrame.topDragBar:SetHeight(40)
    managerFrame.topDragBar:SetPoint('BOTTOMLEFT', managerFrame, 'TOPLEFT', -5, 0)
    managerFrame.topDragBar:SetPoint('BOTTOMRIGHT', managerFrame, 'TOPRIGHT', 5, 0)
    managerFrame.topDragBar:EnableMouse(true)
    managerFrame.topDragBar:RegisterForDrag('LeftButton')
    managerFrame.topDragBar:SetScript(
        'OnDragStart',
        function(self, button)
            managerFrame:SetMovable(true)
            managerFrame:StartMoving()
        end
    )
    managerFrame.topDragBar:SetScript(
        'OnDragStop',
        function(self, button)
            managerFrame:StopMovingOrSizing()

            managerFrame:ClearAllPoints()
            managerFrame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', managerFrame:GetLeft(), managerFrame:GetTop() - UIParent:GetTop())

            managerFrame:SetMovable(false)
        end
    )
    self:UpdateBorder(managerFrame.topDragBar, nil, true)

    local categoryFrame = CreateFrame('Frame', nil, managerFrame)
    self.categoryFrame = categoryFrame
    managerFrame.categoryFrame = categoryFrame
    categoryFrame:SetPoint('TOPLEFT', managerFrame, 'BOTTOMLEFT', 0, -12)
    categoryFrame:SetPoint('TOPRIGHT', managerFrame, 'BOTTOMRIGHT', 0, -12)

    local cLabelColumn = CreateFrame('Frame', nil, categoryFrame)
    categoryFrame.labelColumn = cLabelColumn
    cLabelColumn.categories = {}
    cLabelColumn:SetPoint('TOPLEFT', categoryFrame, 'TOPLEFT', 0, -5)
    cLabelColumn:SetPoint('BOTTOMRIGHT', categoryFrame, 'BOTTOMLEFT', 140, 0)
    categoryFrame.altColumns = {}

    local categoryFrameBackdrop = CreateFrame('Frame', nil, categoryFrame, 'BackdropTemplate')
    categoryFrame.backdrop = categoryFrameBackdrop
    self:UpdateBorder(categoryFrameBackdrop, categoryFrame, true)
    categoryFrame:Hide()

    return managerFrame
end

function PermoksAccountManager:CreateMenuButtons()
    local managerFrame = self.managerFrame

    -------------------
    -- Close Button
    local closeButton = CreateFrame('Button', nil, managerFrame.topDragBar)
    managerFrame.closeButton = closeButton
    closeButton:ClearAllPoints()
    closeButton:SetSize(20, 20)
    closeButton:SetPoint('RIGHT', managerFrame.topDragBar, 'RIGHT', -10, 0)
    closeButton:SetScript(
        'OnClick',
        function()
            PermoksAccountManager:HideInterface()
        end
    )
    closeButton:SetNormalTexture('Interface/Addons/PermoksAccountManager/textures/testbutton.tga')
    closeButton:SetHighlightAtlas('auctionhouse-nav-button-highlight', false)

    local closeButtonTexture = closeButton:CreateTexture(nil, 'OVERLAY')
    closeButton.x = closeButtonTexture
    closeButtonTexture:SetAllPoints()
    closeButtonTexture:SetTexture('Interface/Addons/PermoksAccountManager/textures/testbuttonx.tga')
    closeButtonTexture:SetVertexColor(2, 2, 2, 1)
    closeButton:SetScript(
        'OnMouseDown',
        function()
            closeButtonTexture:AdjustPointsOffset(1, -1)
        end
    )
    closeButton:SetScript(
        'OnMouseUp',
        function()
            closeButtonTexture:AdjustPointsOffset(-1, 1)
        end
    )

    -------------------
    -- Guild Attunement Button
    if self.isBC then
        local guildAttunementButton = CreateFrame('Button', nil, managerFrame, 'UIPanelButtonTemplate')
        managerFrame.guildAttunementButton = guildAttunementButton
        guildAttunementButton:SetSize(80, 20)
        guildAttunementButton:ClearAllPoints()
        guildAttunementButton:SetPoint('BOTTOMLEFT', managerFrame, 'BOTTOMLEFT', -85, -5)
        guildAttunementButton:SetText('Attunement')
        guildAttunementButton:SetScript('OnClick', PermoksAccountManager.ShowGuildAttunements)
    end
end

function PermoksAccountManager:CheckForModernize()
    local internalVersion = self.db.global.internalVersion
    if not internalVersion or internalVersion < INTERNALVERSION then
        self:Modernize(internalVersion)
    end
    --self.db.global.internalVersion = INTERNALVERSION
end

function PermoksAccountManager:Modernize(oldInternalVersion)
    local db = self.db

    if (oldInternalVersion or 0) < 2 then
        self:UpdateDefaultCategories('currentdaily')
    end

	if oldInternalVersion < 3 then
		for _, accountInfo in pairs(db.global.accounts) do
			for _, altData in pairs(accountInfo.data) do
				altData.sanctumInfo = nil
			end
		end
	end
end

function PermoksAccountManager:GetGUID()
    self.myGUID = self.myGUID or UnitGUID('player')
    return self.myGUID
end

function PermoksAccountManager:SortPages()
    local account = self.db.global.accounts.main
    local data = account.data
    local sortKey = self.isBC and 'charLevel' or 'ilevel'
    account.pages = {{}}

    local enabledAlts = 1
    for alt_guid, alt_data in self.spairs(
        data,
        function(t, a, b)
            if t[a] and t[b] then
                return t[a][sortKey] > t[b][sortKey]
            end
        end
    ) do
        if not self.db.global.blacklist[alt_guid] then
            local page = ceil(enabledAlts / self.db.global.options.characters.charactersPerPage)
            account.pages[page] = account.pages[page] or {}
            tinsert(account.pages[page], alt_guid)
            enabledAlts = enabledAlts + 1

            alt_data.page = page
        end
    end

    if self.db.global.currentPage > #account.pages then
        self.db.global.currentPage = #account.pages
    end

    for i = 1, #account.pages do
        table.sort(
            account.pages[i],
            function(a, b)
                if data[a] and data[b] then
                    return data[a][sortKey] > data[b][sortKey]
                end
            end
        )
    end
end

local function AddBasicCharacterInfo(charInfo)
    local _, class = UnitClass('player')
    charInfo.class = class
    charInfo.faction = UnitFactionGroup('player')

    local name, realm = UnitFullName('player')
    charInfo.name = name
    charInfo.realm = realm

    charInfo.charLevel = UnitLevel('player')
end

function PermoksAccountManager:AddNewCharacter(account, guid, alts)
    local data = account.data
    data[guid] = {guid = guid}

    AddBasicCharacterInfo(data[guid])
    local page = ceil(alts / self.db.global.options.characters.charactersPerPage)
    account.pages[page] = account.pages[page] or {}
    tinsert(account.pages[page], guid)

    data[guid].page = page
end

function PermoksAccountManager:SaveBattleTag(db)
    if not db.battleTag then
        local _, battleTag = BNGetInfo()
        db.battleTag = battleTag
    end
end

function PermoksAccountManager:OnLogin()
    local db = self.db.global
    local guid = self:GetGUID()
    local level = UnitLevel('player')
    local min_level = db.options.characters.minLevel

    self.elvui = IsAddOnLoaded('ElvUI')
    self.ElvUI_Skins = self.elvui and ElvUI[1]:GetModule('Skins')
    self:SaveBattleTag(db)
    self:CheckForModernize()
    self:CheckForReset()
    LoadFonts()

    self.account = db.accounts.main
    local data = self.account.data
    if guid and not data[guid] and not self:isBlacklisted(guid) and not (level < min_level) then
        db.alts = db.alts + 1
        self:AddNewCharacter(self.account, guid, db.alts)
    end

    self.charInfo = data[guid]
    self:LoadAllModules(self.charInfo)
    if self.charInfo then
        self:RequestCharacterInfo()
        self:UpdateCompletionData()
    end

    db.currentPage = 1
    self:SortPages()
    self:LoadOptionsTemplate()
	self:LoadCustomLabelButtons()
	self:LoadCustomLabelTable()
    self.LoadOptions()

    C_Timer.After(
        self:GetNextWeeklyResetTime(),
        function()
            self:CheckForReset()
        end
    )
end

function PermoksAccountManager:SkinButtonElvUI(button)
    if not self.elvui then
        return
    end

    self.ElvUI_Skins:HandleButton(button)
end

function PermoksAccountManager:GetSecondsRemaining(expirationTime)
    if expirationTime == 0 then
        return 0
    end
    return expirationTime - time()
end

-- TODO: Completion Data
function PermoksAccountManager:CheckForReset()
    local db = self.db.global
    local currentTime = time()
    local resetDaily = currentTime >= (db.dailyReset or 0)
    local resetWeekly = currentTime >= (db.weeklyReset or 0)
    local resetBiweekly = currentTime >= (db.biweeklyReset or 0)
    wipe(db.completionData)

    for account, accountData in pairs(db.accounts) do
        self:ResetAccount(db, accountData, resetDaily, resetWeekly, resetBiweekly)
    end

    db.weeklyReset = resetWeekly and currentTime + self:GetNextWeeklyResetTime() or db.weeklyReset
    db.dailyReset = resetDaily and currentTime + self:GetNextDailyResetTime() or db.dailyReset
    db.biweeklyReset = resetBiweekly and currentTime + self:GetNextBiWeeklyResetTime() or db.resetBiweekly
end

function PermoksAccountManager:ResetAccount(db, accountData, daily, weekly, biweekly)
    for _, altData in pairs(accountData.data) do
        if weekly then
            self:ResetWeeklyActivities(altData)
        end

        if daily then
            self:ResetDailyActivities(db, altData)
        end

        if biweekly then
            self:ResetBiweeklyActivities(altData)
        end
    end
end

function PermoksAccountManager:ResetWeeklyActivities(altData)
    -- M0/Raids
    if altData.instanceInfo then
        altData.instanceInfo.raids = {}
        altData.instanceInfo.dungeons = {}
    end

    -- Torghast
    if altData.torghastInfo then
        wipe(altData.torghastInfo)
    end

    -- Vault
    if altData.vaultInfo then
        wipe(altData.vaultInfo)
    end

    altData.raidActivityInfo = {}

    -- M+
    altData.keyInfo = nil

    -- Weekly Quests
    if altData.questInfo and altData.questInfo.weekly then
        for visibility, quests in pairs(altData.questInfo.weekly) do
            altData.questInfo.weekly[visibility] = {}
        end
    end
end

function PermoksAccountManager:ResetDailyActivities(db, altData)
    local currentTime = time()

    if altData.completedDailies then
        altData.completedDailies = {}
    end

    -- Callings
    if altData.callingsUnlocked and altData.callingInfo and altData.callingInfo.numCallings and altData.callingInfo.numCallings < 3 then
        altData.callingInfo.numCallings = altData.callingInfo.numCallings + 1
        altData.callingInfo[#altData.callingInfo + 1] = currentTime + self:GetNextDailyResetTime() + (86400 * 2)
    end

    if altData.covenant and db.currentCallings[altData.covenant] then
        for questID, currentCallingInfo in pairs(db.currentCallings[altData.covenant]) do
            if currentCallingInfo.timeRemaining and currentCallingInfo.timeRemaining < time() then
                db.currentCallings[altData.covenant][questID] = nil
            end
        end
    end

    -- Daily Quests
    if altData.questInfo and altData.questInfo.daily then
        for visibility, quests in pairs(altData.questInfo.daily) do
            altData.questInfo.daily[visibility] = {}
        end
    end
end

function PermoksAccountManager:ResetBiweeklyActivities(altData)
    if altData.questInfo and altData.questInfo.biweekly then
        for visibility, quests in pairs(altData.questInfo.biweekly) do
            altData.questInfo.biweekly[visibility] = {}
        end
    end
end

function PermoksAccountManager:RequestCharacterInfo()
    if not self.isBC then
        RequestRatedInfo()
        CovenantCalling_CheckCallings()
    end
end

-- TODO: Rework Completion Data
function PermoksAccountManager:UpdateCompletionData()
    local db = self.db.global
    local accountData = db.accounts.main
    for alt_guid, alt_data in pairs(accountData.data) do
        for key, info in pairs(self.labelRows) do
            if info.isComplete then
                self:SaveCompletionData(key, info.isComplete(alt_data), alt_guid)
            end
        end
    end
end

function PermoksAccountManager:UpdateCompletionDataForCharacter(charInfo)
    if not charInfo then
        return
    end

    for key, info in pairs(self.labelRows) do
        if info.isComplete then
            self:SaveCompletionData(key, info.isComplete(charInfo), charInfo.guid)
        end
    end
end

function PermoksAccountManager:SaveCompletionData(key, isComplete, guid)
    if not guid then
        return
    end

    if self.labelRows[key] then
        local completionData = self.db.global.completionData[key]

        if not completionData[guid] then
            completionData[guid] = isComplete or nil
            completionData.numCompleted = (completionData.numCompleted or 0) + (isComplete and 1 or 0)
        end
    end
end

function PermoksAccountManager:UpdateAccountButtons()
    local db = self.db.global

    local managerFrame = self.managerFrame
    local accountDropdown = managerFrame.accountDropdown or AceGUI:Create('Dropdown')
    if not managerFrame.accountDropdown then
        managerFrame.accountDropdown = accountDropdown
        --accountDropdown:SetLabel('Account')
        accountDropdown:SetWidth(120)
        accountDropdown:SetPoint('BOTTOMLEFT', managerFrame.topDragBar, 'LEFT', 5, -12)
        accountDropdown.frame:SetParent(managerFrame)
        accountDropdown:SetCallback(
            'OnValueChanged',
            function(_, _, accountKey)
                PermoksAccountManager.db.global.currentPage = 1

                if PermoksAccountManager.managerFrame.pageDropdown then
                    PermoksAccountManager.managerFrame.pageDropdown:SetValue(1)
                end
                PermoksAccountManager.account = PermoksAccountManager.db.global.accounts[accountKey]
                PermoksAccountManager:HideAllCategories()
                PermoksAccountManager:UpdateAltAnchors('general', managerFrame, managerFrame.labelColumn)
                PermoksAccountManager:UpdateStrings(1, 'general')
                PermoksAccountManager:UpdatePageButtons()
                PermoksAccountManager:UpdateManagerFrameSize()
            end
        )
    end
    managerFrame.accountButtons = managerFrame.accountButtons or {}

    local accountList = {}
    local accountOrder = {}
    for accountName, accountInfo in self.spairs(
        db.accounts,
        function(t, a, b)
            return a == 'main'
        end
    ) do
        accountList[accountName] = accountInfo.name
        tinsert(accountOrder, accountName)
    end

    accountDropdown:Fire('OnClose')
    accountDropdown:SetList(accountList, accountOrder)
    accountDropdown:SetValue('main')
end

function PermoksAccountManager:UpdatePageButtons()
    local db = self.db.global
    local pages = self.account.pages
    local managerFrame = self.managerFrame
    managerFrame.pageButtons = managerFrame.pageButtons or {}
    local categoryFrame = self.categoryFrame
    local currentPage = db.currentPage

    if #pages == 1 then
        if managerFrame.pageButtons then
            for _, button in pairs(managerFrame.pageButtons) do
                button:Hide()
            end
            return
        end
    end

    for pageNumber = 1, #pages do
        local pageButton = managerFrame.pageButtons[pageNumber] or CreateManagerButton(35, 20, pageNumber)

        if not managerFrame.pageButtons[pageNumber] then
            managerFrame.pageButtons[pageNumber] = pageButton
            if pageNumber == currentPage then
                pageButton.Text:SetTextColor(0, 1, 0, 1)
                pageButton.selected:Show()
            end

            local index = pageNumber - 1
            pageButton:SetPoint('LEFT', managerFrame.topDragBar, 'LEFT', (index * 35) + (index > 0 and 135 or 130), 0)
            pageButton:SetID(pageNumber)
            pageButton:SetScript(
                'OnClick',
                function(self, button, down)
                    local currentPage = db.currentPage
                    if currentPage == pageNumber then
                        return
                    end

                    managerFrame.pageButtons[currentPage].selected:Hide()
                    managerFrame.pageButtons[currentPage].Text:SetTextColor(1, 1, 1, 1)
                    self.selected:Show()
                    self.Text:SetTextColor(0, 1, 0, 1)
                    PermoksAccountManager.db.global.currentPage = pageNumber
                    PermoksAccountManager:UpdateAltAnchors('general', managerFrame, managerFrame.labelColumn)
                    PermoksAccountManager:UpdateStrings(pageNumber, 'general')
                    PermoksAccountManager:UpdateManagerFrameSize(true)

                    if categoryFrame.openCategory then
                        local category = categoryFrame.openCategory
                        PermoksAccountManager:UpdateAltAnchors(category, categoryFrame, categoryFrame.labelColumn.categories[category])
                        PermoksAccountManager:UpdateStrings(nil, category, categoryFrame)
                    end
                end
            )
            pageButton:SetParent(managerFrame.topDragBar)
            pageButton:Show()
        end
    end
end

local function UpdateOrCreateMenu(category, anchorFrame, parent)
    local db = PermoksAccountManager.db.global
    local completionData = db.completionData
    local childs = db.currentCategories[category].childs
    local options = db.currentCategories[category].childOrder
    if not options then
        return
    end

    PermoksAccountManager.managerFrame.labels = PermoksAccountManager.managerFrame.labels or {}
    PermoksAccountManager.managerFrame.labels[category] = PermoksAccountManager.managerFrame.labels[category] or {}
    local labels = PermoksAccountManager.managerFrame.labels[category]
    local alts = #PermoksAccountManager.account.pages[PermoksAccountManager.db.global.currentPage]

    local enabledRows = 0
    for j, row_iden in pairs(childs) do
        local row = PermoksAccountManager.labelRows[row_iden]
        if row then
            if row.label then
                local label_row = labels[row_iden] or CreateLabelButton('label', parent or anchorFrame, row, nil, 140)
                if not labels[row_iden] then
                    labels[row_iden] = label_row
                    if not row.hideLabel then
                        label_row:SetText((type(row.label) == 'function' and row.label() or row.label) .. ':')
                    end
                end
                label_row:SetPoint('TOPLEFT', anchorFrame, 'TOPLEFT', 0, -enabledRows * 20)
                label_row:Show()

                enabledRows = enabledRows + (row.offset or 1)
            elseif row.hideLabel then
                enabledRows = enabledRows + (row.offset or 1)
            end
        end
    end

    for row_iden, label in pairs(labels) do
        if not options[row_iden] then
            label:Hide()
        end
    end

    return enabledRows
end

local function UpdateButtonTexture(button, index, row_identifier, alt_guid)
    if button.normalTexture then
        if PermoksAccountManager.db.global.completionData[row_identifier][alt_guid] then
            button.normalTexture:SetColorTexture(0, 1, 0, 0.25)
        elseif index % 2 == 0 then
            button.normalTexture:SetColorTexture(0.65, 0.65, 0.65, 0.25)
        else
            button.normalTexture:SetColorTexture(0.3, 0.3, 0.3, 0.25)
        end
    end
end

local function UpdateRowButton(button, buttonOptions, _)
    button:SetWidth(buttonOptions.buttonWidth)

    local fontString = button:GetFontString()
    if fontString then
        fontString:SetJustifyH(buttonOptions.justifyH)
        fontString:SetWidth(buttonOptions.buttonTextWidth)
    end
end

function PermoksAccountManager:UpdateMenuButton(button)
    local fontString = button.fontString or button:GetFontString()
    if fontString and self.db.global.updateFont then
        local _, size = fontString:GetFont()
        fontString:SetFont(LSM:Fetch('font', self.db.global.options.font), size)
    end
end

function PermoksAccountManager:UpdateAltAnchors(category, columnFrame, customAnchorFrame)
    columnFrame.altColumns[category] = columnFrame.altColumns[category] or {}

    local db = self.db.global
    local altDataForPage = self.account.pages[db.currentPage or 1]
    if not altDataForPage then
        return
    end

    local widthPerAlt = db.options.other.widthPerAlt
    local labelOffset = db.options.other.labelOffset
    local altColumns = columnFrame.altColumns[category]

    if #altColumns > #altDataForPage then
        for index = #altDataForPage + 1, #altColumns do
            altColumns[index]:Hide()
        end
    end

    for index, alt_guid in ipairs(altDataForPage) do
        local anchorFrame = altColumns[index] or CreateFrame('Button', nil, customAnchorFrame)
        anchorFrame:SetPoint('TOPLEFT', customAnchorFrame, 'TOPRIGHT', (widthPerAlt * (index - 1)) + labelOffset, 0)
        anchorFrame:SetPoint('BOTTOMRIGHT', customAnchorFrame, 'BOTTOMLEFT', (widthPerAlt * index) + widthPerAlt + labelOffset, 0)
        anchorFrame.GUID = alt_guid
        anchorFrame:Show()

        altColumns[index] = anchorFrame
        anchorFrame.rows = anchorFrame.rows or {}
    end
end

function PermoksAccountManager:UpdateAllFonts()
    UpdateFonts()
end

local InternalLabelFunctions = {
    quest = function(alt_data, column, key)
        if not alt_data.questInfo then
            return '-'
        end

        -- TODO Somehow save it per character so we don't have to check it everytime we change the text.
        local required
        if column.unlock then
            local unlockInfo = column.unlock
            local unlocked = alt_data[unlockInfo.charKey] and alt_data[unlockInfo.charKey][unlockInfo.key]
            if unlocked then
                required = unlockInfo.required
            end
        end

        required = required or column.required or 1
        if type(column.required) == 'function' then
            required = column.required(alt_data)
        end

        local questInfo = alt_data.questInfo[column.questType] and alt_data.questInfo[column.questType][column.visibility] and alt_data.questInfo[column.questType][column.visibility][column.key or key]
        if not questInfo then
            return PermoksAccountManager:CreateQuestString(0, required) or '-'
        end

        return PermoksAccountManager:CreateQuestString(questInfo, required, column.plus or (column.plus == nil and required == 1)) or '-'
    end,
    currency = function(alt_data, column, key)
        if not alt_data.currencyInfo then
            return '-'
        end

        local currencyInfo = alt_data.currencyInfo[column.key or key]
        if not currencyInfo then
            return '-'
        end

        return PermoksAccountManager:CreateCurrencyString(currencyInfo, column.abbCurrent, column.abbMax, column.hideMax, column.customIcon) or '-'
    end,
    faction = function(alt_data, column, key)
        if not alt_data.factions then
            return '-'
        end

        local factionInfo = alt_data.factions[column.key or key]
        if not factionInfo then
            return '-'
        end

        return PermoksAccountManager:CreateFactionString(factionInfo) or '-'
    end,
    item = function(alt_data, column, key)
        if not alt_data.itemCounts then
            return '-'
        end

        local itemInfo = alt_data.itemCounts[column.key or key]
        if not itemInfo then
            return '-'
        end

        return PermoksAccountManager:CreateItemString(itemInfo)
    end,
    sanctum = function(alt_data, column, key)
        if not alt_data.sanctumInfo then
            return '-'
        end

        local sanctumInfo = alt_data.sanctumInfo
        if not sanctumInfo then
            return '-'
        end

        return PermoksAccountManager:CreateSanctumTierString(sanctumInfo, column.key or key)
    end,
    raid = function(alt_data, column)
        if not alt_data.instanceInfo or not alt_data.instanceInfo.raids then
            return '-'
        end

        local raidInfo = alt_data.instanceInfo.raids[column.key]
        if not raidInfo then
            return '-'
        end

        return PermoksAccountManager:CreateRaidString(raidInfo)
    end,
    pvp = function(alt_data, column, key)
        if not alt_data.pvp then
            return '-'
        end

        local pvpInfo = alt_data.pvp[column.key or key]
        if not pvpInfo then
            return '-'
        end

        return PermoksAccountManager:CreateRatingString(pvpInfo)
    end,
    vault = function(alt_data, column, key)
        if not alt_data.vaultInfo then
            return '-'
        end

        local vaultInfo = alt_data.vaultInfo[column.key or key]
        if not vaultInfo then
            return '-'
        end

        return PermoksAccountManager:CreateVaultString(vaultInfo)
    end
}

local InternalTooltipFunctions = {
    raid = PermoksAccountManager.RaidTooltip_OnEnter,
    vault = PermoksAccountManager.VaultTooltip_OnEnter,
    item = PermoksAccountManager.ItemTooltip_OnEnter,
    currency = PermoksAccountManager.CurrencyTooltip_OnEnter,
    pvp = PermoksAccountManager.PVPTooltip_OnEnter
}

function PermoksAccountManager:GetInternalLabelFunction(labelRow)
    return InternalLabelFunctions[labelRow.type] or (type(labelRow.data) == 'function' and labelRow.data)
end

local function DeleteUnusedLabel(category, categoryInfo, labelIdentifier)
	tDeleteItem(categoryInfo.childs, labelIdentifier)
	categoryInfo.childOrder[labelIdentifier] = nil
	PermoksAccountManager:UpdateAnchorsAndSize(category, nil, true, true)
end

function PermoksAccountManager:DeleteUnusedLabels(labelIdentifier)
	for category, categoryInfo in pairs(self.db.global.options.defaultCategories) do
		if categoryInfo.childOrder[labelIdentifier] then
			DeleteUnusedLabel(category, categoryInfo, labelIdentifier)
		end
	end

	for category, categoryInfo in pairs(self.db.global.options.customCategories) do
		if categoryInfo.childOrder[labelIdentifier] then
			DeleteUnusedLabel(category, categoryInfo, labelIdentifier)
		end
	end
end

function PermoksAccountManager:UpdateColumnForAlt(alt_guid, anchorFrame, category)
    local altData = self.account.data[alt_guid]
    if not altData then
        return
    end

    local db = self.db.global
    local buttonOptions = db.options.buttons
    local childs = db.currentCategories[category].childs
    local enabledChilds = db.currentCategories[category].childOrder

    local rows = anchorFrame.rows
    local enabledRows, yOffset = 0, 0
    for _, row_identifier in pairs(childs) do
        local labelRow = self.labelRows[row_identifier]
        if labelRow and enabledChilds[row_identifier] then
            local row = rows[row_identifier] or CreateLabelButton('row', anchorFrame, labelRow, enabledRows)
            if not rows[row_identifier] then
                rows[row_identifier] = row

                local module = self:GetModuleForRow(row_identifier)
                local moduleLabelFunction = module and module.labelFunctions[labelRow.type]
                if moduleLabelFunction then
                    row.module = module
                    row.labelFunction = moduleLabelFunction.callback
                else
                    row.labelFunction = self:GetInternalLabelFunction(labelRow)
                end

                if labelRow.tooltip then
                    local tooltipFunction
                    if labelRow.customTooltip then
                        tooltipFunction = labelRow.customTooltip
                    elseif InternalTooltipFunctions[labelRow.type] then
                        tooltipFunction = InternalTooltipFunctions[labelRow.type]
                    elseif type(labelRow.tooltip) == 'function' then
                        tooltipFunction = labelRow.tooltip
                    end
                    row:SetScript('OnLeave', Tooltip_OnLeave)
                    row.tooltipFunction = tooltipFunction
                end
            end

            if row.tooltipFunction then
                row:SetScript(
                    'OnEnter',
                    function(self)
                        self.tooltipFunction(self, altData, labelRow)
                    end
                )
            end

            if row.module then
				local args = row.module:GenerateLabelArgs(altData, labelRow.type, labelRow.update)
				local text
				if labelRow.passKey then
					text = row.labelFunction(labelRow.key or row_identifier, unpack(args))
				else
					text = row.labelFunction(unpack(args))
				end
                row:SetText(text)
            else
                row:SetText(row.labelFunction(altData, labelRow, row_identifier))
            end
            row:SetPoint('TOPLEFT', anchorFrame, 'TOPLEFT', 0, -yOffset * 20)
            row:Show()

            UpdateButtonTexture(row, enabledRows, row_identifier, alt_guid)
            UpdateRowButton(row, buttonOptions, row_identifier)

            if labelRow.color and row.fontString then
                row.fontString:SetTextColor(labelRow.color(altData):GetRGBA())
            end

            enabledRows = enabledRows + 1
            yOffset = yOffset + (labelRow.offset or 1)
        end
    end

    for row_identifier, row in pairs(rows) do
        if not enabledChilds[row_identifier] then
            row:Hide()
        end
    end
end

function PermoksAccountManager:UpdateStrings(page, category, columnFrame)
    local db = self.db.global
    local page = self.account.pages[page or self.db.global.currentPage]
    if not page then
        return
    end

    local enabledAlts = 1
    columnFrame = columnFrame or self.managerFrame
    for _, alt_guid in ipairs(page) do
        if not db.blacklist[alt_guid] then
            local anchorFrame = columnFrame.altColumns[category][enabledAlts]

            self:UpdateColumnForAlt(alt_guid, anchorFrame, category)
            enabledAlts = enabledAlts + 1
        end
    end
end

function PermoksAccountManager:UpdateCategory(button, defaultState, name, category)
    local categoryLabelColumn = self.categoryFrame.labelColumn.categories[category] or CreateFrame('Frame', nil, self.categoryFrame.labelColumn)
    self.categoryFrame.labelColumn.categories[category] = categoryLabelColumn

    categoryLabelColumn:SetPoint('TOPLEFT', self.categoryFrame.labelColumn, 'TOPLEFT', 0, 0)
    categoryLabelColumn.state = defaultState or categoryLabelColumn.state or 'closed'

    if categoryLabelColumn.state == 'closed' then
        local numRows = UpdateOrCreateMenu(category, categoryLabelColumn)
        self:UpdateAltAnchors(category, self.categoryFrame, categoryLabelColumn)
        self:UpdateStrings(nil, category, self.categoryFrame)
        categoryLabelColumn:SetSize(140, (numRows * 20))
        categoryLabelColumn:Show()

        if numRows > 0 then
            categoryLabelColumn.state = 'open'
            self.categoryFrame.openCategory = category
            self.categoryFrame.openCategoryRows = numRows
            button.selected:Show()
            button.Text:SetTextColor(0, 1, 0, 1)
            self:UpdateCategoryFrameSize(numRows)
            self.categoryFrame:Show()
        end
    else
        self:HideCategory(button, category)
    end
end

function PermoksAccountManager:HideCategory(button, category)
    if self.categoryFrame.labelColumn.categories[category] then
        self.categoryFrame.labelColumn.categories[category].state = 'closed'
        self.categoryFrame.labelColumn.categories[category]:Hide()
    end

    if category == self.categoryFrame.openCategory then
        self.categoryFrame.openCategory = nil
        self.categoryFrame.openCategoryRows = nil
    end

    button.selected:Hide()
    button.Text:SetTextColor(1, 1, 1, 1)
end

function PermoksAccountManager:HideAllCategories(currentCategory)
    local categoryButtons = self.managerFrame.categoryButtons
    if not categoryButtons then
        return
    end

    for category, button in pairs(categoryButtons) do
        if category ~= currentCategory then
            self:HideCategory(button, category)
        end
    end

    self.categoryFrame:Hide()
end

function PermoksAccountManager:UpdateOrCreateCategoryButtons()
    local db = PermoksAccountManager.db.global
    local buttonrows = 0
    local categories = db.currentCategories
    local nameTbl
    if not db.custom then
        nameTbl = self:getDefaultCategories()
    end
    for category, row in PermoksAccountManager.spairs(
        categories,
        function(t, a, b)
            if t[a] and t[b] then
                return t[a].order < t[b].order
            end
        end
    ) do
        if category ~= 'general' and db.currentCategories[category].enabled then
            local categoryButton = PermoksAccountManager.managerFrame.categoryButtons[category] or CreateManagerButton(100, 25, nameTbl and nameTbl[category] and nameTbl[category].name or row.name)
            categoryButton:Show()
            categoryButton:SetPoint('TOPRIGHT', PermoksAccountManager.managerFrame.topDragBar, 'TOPLEFT', 0, -(buttonrows * 26) - 5)
            if not PermoksAccountManager.managerFrame.categoryButtons[category] then
                categoryButton.name = row.name
            end

            if row.disable_drawLayer then
                categoryButton:DisableDrawLayer('BACKGROUND')
            end

            categoryButton:SetScript(
                'OnClick',
                function()
                    PermoksAccountManager:HideAllCategories(category)
                    PermoksAccountManager:UpdateCategory(categoryButton, nil, row.name, category)
                end
            )

            PermoksAccountManager.managerFrame.categoryButtons[category] = categoryButton
            buttonrows = buttonrows + 1
        elseif PermoksAccountManager.managerFrame.categoryButtons[category] and not PermoksAccountManager.db.global.currentCategories[category].enabled then
            PermoksAccountManager.managerFrame.categoryButtons[category]:Hide()
        end
    end

    PermoksAccountManager:UpdateCategoryButtonsBackground(buttonrows)
end

function PermoksAccountManager:UpdateCategoryButtonsBackground(buttons)
    if buttons > 0 then
        local height = buttons * 26
        local backgroundFrame = self.managerFrame.categoriesBackgroundFrame or CreateFrame('Frame', nil, self.managerFrame, 'BackdropTemplate')
        if not self.managerFrame.categoriesBackgroundFrame then
            backgroundFrame:SetPoint('TOPRIGHT', self.managerFrame.topDragBar, 'TOPLEFT', PermoksAccountManager.db.global.options.border.edgeSize, 0)
            backgroundFrame:SetFrameLevel(0)
            self:UpdateBorder(backgroundFrame, nil, true)
            self.managerFrame.categoriesBackgroundFrame = backgroundFrame
        end
        backgroundFrame:SetSize(110, height + 8)
        backgroundFrame:Show()
    elseif self.managerFrame.categoriesBackgroundFrame then
        self.managerFrame.categoriesBackgroundFrame:Hide()
    end
end

function PermoksAccountManager:UpdateManagerFrame()
    PermoksAccountManager:SortPages()
    PermoksAccountManager:UpdatePageButtons()
    PermoksAccountManager:UpdateAnchorsAndSize('general')
end

function PermoksAccountManager:UpdateManagerFrameSize(widthOnly, heightOnly)
    local alts = #self.account.pages[self.db.global.currentPage]
    local width = ((alts * self.db.global.options.other.widthPerAlt) + 140) - min((self.db.global.options.other.widthPerAlt - self.db.global.options.buttons.buttonWidth), 20) + 4
    local height = self.managerFrame.height

    if widthOnly then
        self.managerFrame:SetWidth(max(width + self.db.global.options.other.labelOffset, 240))
    elseif heightOnly then
        self.managerFrame:SetHeight(height)
    else
        self.managerFrame:SetSize(max(width + self.db.global.options.other.labelOffset, 240), height)
    end
    self.managerFrame.lowest_point = -self.managerFrame.height
end

function PermoksAccountManager:UpdateCategoryFrameSize(numRows)
    local height = numRows * 20
    self.categoryFrame:SetHeight(height + 10)
end

function PermoksAccountManager:UpdateMenu(widthOnly, heightOnly)
    self.managerFrame.categoryButtons = self.managerFrame.categoryButtons or {}

    if self.isBC then
        self.managerFrame.guildAttunementButton:SetShown(self.db.global.options.showGuildAttunementButton)
    end

    local numRows = UpdateOrCreateMenu('general', self.managerFrame.labelColumn)
    self:UpdateOrCreateCategoryButtons()

    self.managerFrame.height = max(numRows * 20 + 10, max(0, (self.numCategories - 2) * 30))
    self.managerFrame.numRows = numRows
    self:UpdateManagerFrameSize(widthOnly, heightOnly)
end

function PermoksAccountManager:UpdateAnchorsAndSize(category, widthOnly, heightOnly, updateMenu)
    if category == 'general' then
        if updateMenu then
            local numRows = UpdateOrCreateMenu('general', self.managerFrame.labelColumn)
            self.managerFrame.height = max(numRows * 20 + 10, max(0, (self.numCategories - 2) * 30))
        end

        self:UpdateAltAnchors('general', self.managerFrame, self.managerFrame.labelColumn)
        self:UpdateStrings(self.db.global.currentPage, 'general')
    end

    if self.categoryFrame.openCategory then
        local openCategory = self.categoryFrame.openCategory
        self:UpdateCategory(PermoksAccountManager.managerFrame.categoryButtons[openCategory], 'closed', nil, openCategory)
    end

    self:UpdateManagerFrameSize(widthOnly, heightOnly)
end

function PermoksAccountManager:CreateFractionString(numCompleted, numDesired, abbreviateCompleted, abbreviateDesired)
    if not numCompleted or not numDesired then
        return
    end
    local color = (numCompleted >= numDesired and '00ff00') or (numCompleted > 0 and 'ff9900') or 'ffffff'

    numCompleted = abbreviateCompleted and AbbreviateNumbers(numCompleted) or AbbreviateLargeNumbers(numCompleted)
    local numDesiredAbbreviated = abbreviateDesired and AbbreviateNumbers(numDesired) or numDesired

    if numDesired > 0 then
        return string.format('|cff%s%s|r/%s', color, numCompleted, numDesiredAbbreviated)
    else
        return string.format('|cff%s%s|r', color, numCompleted)
    end
end

function PermoksAccountManager:FormatTimeString(seconds, string)
    local color = 'ff0000'
    if seconds > 86400 then
        color = '00ff00'
    end

    return string.format('|cff%s%s|r', color, string)
end

function PermoksAccountManager:HideInterface()
    if self.db.global.options.hideCategory then
        self.categoryFrame:Hide()
        self:HideAllCategories()
    end

    if self.db.global.options.savePosition then
        local frame = self.managerFrame
        local position = self.db.global.position
        position.point, position.relativeTo, position.relativePoint, position.xOffset, position.yOffset = frame:GetPointByName('TOPLEFT')
    end
    self.managerFrame:Hide()
end

function PermoksAccountManager:ShowInterface()
    if not self.loaded then
        self:CreateMenuButtons()
        self:UpdateAltAnchors('general', self.managerFrame, self.managerFrame.labelColumn)
        self:UpdatePageButtons()
        self:UpdateAccountButtons()
        self:UpdateAccounts()

        self.loaded = true
    end

    self.myGUID = self.myGUID or UnitGUID('player')
    self:RequestCharacterInfo()

    self.managerFrame:Show()
    self:UpdateCompletionDataForCharacter(self.charInfo)
    self:UpdateMenu()
    self:UpdateStrings(self.db.global.currentPage, 'general')
    if self.categoryFrame.openCategory then
        local openCategory = self.categoryFrame.openCategory
        self:UpdateCategory(self.managerFrame.categoryButtons[openCategory], 'closed', nil, openCategory)
    end
end

function PermoksAccountManager:GetNextWeeklyResetTime()
    local weeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
    return weeklyReset
end

function PermoksAccountManager:GetNextDailyResetTime()
    local dailyReset = C_DateAndTime.GetSecondsUntilDailyReset()
    return dailyReset
end

function PermoksAccountManager:GetNextBiWeeklyResetTime()
    local weeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
    return (weeklyReset >= 302400 and weeklyReset - 302400 or weeklyReset)
end

function PermoksAccountManager:PostKeysIntoChat(channel)
    local chatChannel
    if channel and (channel == 'raid' or channel == 'guild' or channel == 'party') then
        chatChannel = channel:upper()
    else
        chatChannel = UnitInParty('player') and 'PARTY' or 'GUILD'
    end

    local keys = {}
    for _, alt_data in pairs(self.db.global.accounts.main.data) do
        local keyInfo = alt_data.keyInfo
        if keyInfo and keyInfo.keyLevel > 0 then
            local key = string.format('[%s: %s+%d]', alt_data.name, keyInfo.keyDungeon, keyInfo.keyLevel)
            tinsert(keys, key)
        end
    end

    local msg = table.concat(keys, ' ')
    SendChatMessage(msg:sub(1, 255), chatChannel)
end
