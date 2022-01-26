local addonName, PermoksAccountManager = ...

PermoksAccountManager = LibStub("AceAddon-3.0"):NewAddon(PermoksAccountManager, "PermoksAccountManager", "AceConsole-3.0", "AceEvent-3.0")

-- Create minimap icon with LibDataBroker.
local PermoksAccountManagerLDB = LibStub("LibDataBroker-1.1"):NewDataObject("PermoksAccountManager", {
	type = "data source",
	text = "Permoks Account Manager",
	icon = "Interface/Icons/achievement_guildperk_everybodysfriend.blp",
	OnClick = function(self, button)
		if button == "LeftButton" then
			if PermoksAccountManagerFrame:IsShown() then
				PermoksAccountManager:HideInterface()
			else
				PermoksAccountManager:ShowInterface()
			end
		elseif button == "RightButton" then
			PermoksAccountManager:OpenOptions()
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine("|cfff49b42Permoks Account Manager|r")
		tt:AddLine("|cffffffffLeft-click|r to open the Manager")
		tt:AddLine("|cffffffffRight-click|r to open options")
		tt:AddLine("Type '/acc minimap' to hide the Minimap Button!")
	end
})

local AceGUI = LibStub("AceGUI-3.0")
local LibIcon = LibStub("LibDBIcon-1.0")
local LibQTip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local LSM = LibStub("LibSharedMedia-3.0")
local VERSION = "1.0"
local INTERNALVERSION = 2
local INTERNALBCVERSION = 1
local defaultDB = {
    profile = {
      	minimap = {
        	hide = false,
    	},
	},
	global = {
		blacklist = {},
		accounts = {
			main = {
				name = L["Main"],
				data = {},
				pages = {},
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
				justifyH = "LEFT",
			},
			other = {
				updated = false,
				labelOffset = 15,
				widthPerAlt = 120,
				frameStrata = "MEDIUM",
			},
			characters = {
				charactersPerPage = 6,
				minLevel = GetMaxLevelForExpansionLevel(GetExpansionLevel()),
			},
			border = {
				edgeSize = 5,
				color = {0.39, 0.39, 0.39, 1},
				bgColor = {0.1, 0.1, 0.1, 0.9},
			},
			font = "Expressway",
			savePosition = false,
			showOptionsButton = false,
			showGuildAttunementButton = false,
			currencyIcons = true,
			itemIcons = true,
			useScoreColor = true,
			showCurrentSpecIcon = true,
			questCompletionString = "+",
			useScoreOutline = true,
			itemIconPosition = "right",
			currencyIconPosition = "right",
			customCategories = {
				general = {
					childOrder = {characterName = 1, ilevel = 2}, 
					childs = {"characterName", "ilevel"}, 
					order = 0, 
					hideToggle = true, 
					name = "General", 
					enabled = true,
				},
				['**'] = {childOrder = {}, childs = {}, enabled = true}
			},
			defaultCategories = {
				['**'] = {
					enabled = true
				},
			}
		},
		currentCallings = {},
		quests = {},
		currencyInfo = {},
		itemIcons = {},
		position = {},
		version = VERSION,
	},
}

--- Create an iterator for a hash table.
-- @param t:table The table to create the iterator for.
-- @param order:function A sort function for the keys.
-- @return function The iterator usable in a loop.
local function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]], keys[i+1]
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

local CreateFontFrame, LoadFonts, UpdateFonts
do
	local normalFont, smallFont, bigFont

	--- Initialize the fonts
	function LoadFonts()
		local font = LSM:Fetch("font", PermoksAccountManager.db.global.options.font)

		normalFont = CreateFont("MAM_NormalFont")
		normalFont:SetFont(font, 11)
		normalFont:SetTextColor(1, 1, 1, 1)

		smallFont = CreateFont("MAM_SmallFont")
		smallFont:SetFont(font, 9)
		smallFont:SetTextColor(1, 1, 1, 1)

		bigFont = CreateFont("MAM_BigFont")
		bigFont:SetFont(font, 17)
		bigFont:SetTextColor(1, 1, 1, 1)
	end

	--- Update the font path of all previously created fonts.
	function UpdateFonts()
		local font = LSM:Fetch("font", PermoksAccountManager.db.global.options.font)
		normalFont:SetFont(font, 11)
		smallFont:SetFont(font, 9)
		bigFont:SetFont(font, 17)
	end

	--- Create the text for a normal button.
	-- @param button:Button The button to create the font object for.
	-- @param column:table The information table for the current column.
	-- @param alt_data:table A table with information about a character.
	-- @param text:string Text that can be used instead of generating a new one with alt_data.
	-- @param buttonOptions:table
	-- TODO
	local function createColumnFont(button, column, alt_data, text, buttonOptions)
		text = text or column.data(alt_data)
		button:SetNormalFontObject((column.big and bigFont) or (column.small and smallFont) or normalFont)
		button:SetText(text)

		local fontString = button:GetFontString()
		if fontString then
			if column.outline and PermoksAccountManager.db.global.options.useScoreOutline then
				local font, size = fontString:GetFont()
				fontString:SetFont(font, size, column.outline)
				button.outline = true
			end

			button.fontString = fontString
			fontString:SetSize(110, 20)
			fontString:SetJustifyV(column.justify or "MIDDLE")
			fontString:SetJustifyH(buttonOptions.justifyH)
		end
	end

	--- Create the text for a label button.
	-- @param button:Button The button to create the font object for.
	-- @param column:table The information table for the current column.
	-- @param text:string Text for the current row.
	-- @param buttonOptions:table
	-- TODO
	local function createLabelFont(button, column, text, buttonOptions)
		button:SetNormalFontObject(normalFont)
		button:SetText(column.hideLabel and " " or text .. ":")

		local fontString = button:GetFontString()
		fontString:SetSize(110, 20)
		fontString:SetJustifyV("CENTER")
		fontString:SetJustifyH("RIGHT")
	end

	--- Create a button with a text.
	-- @param type:string The type of button to create.
	-- @param parent:Frame The parent frame for the button.
	-- @param column:table The column data for the current column.
	-- @param alt_data:table
	-- @param text:string Pre-defined text to use for the button.
	-- @param index:int If the index is given then create a texture.
	-- @param width:float Possible custom width.
	function CreateFontFrame(type, parent, column, alt_data, text, index, width)
		local buttonOptions = PermoksAccountManager.db.global.options.buttons
		local button = CreateFrame("Button", nil, parent)
		button:SetSize(width or buttonOptions.buttonWidth, 20)
		button:SetPushedTextOffset(0, 0)

		if type == "row" then
			if not column.hideOption and not column.hideLabel then
				local highlightTexture = button:CreateTexture()
				highlightTexture:SetAllPoints()
				highlightTexture:SetColorTexture(0.5, 0.5, 0.5, 0.5)
				button:SetHighlightTexture(highlightTexture)

				if index then
					local normalTexture = button:CreateTexture(nil, "BACKGROUND")
					normalTexture:SetAllPoints()
					button:SetNormalTexture(normalTexture)
					button.normalTexture = normalTexture
				end
			end
			createColumnFont(button, column, alt_data, text, buttonOptions)
		elseif type == "label" then
			createLabelFont(button, column, text, buttonOptions)
		end

		return button
	end
end

do
	local PermoksAccountManagerEvents = {
		"CHAT_MSG_PARTY",
		"CHAT_MSG_PARTY_LEADER",
		"CHAT_MSG_GUILD",
	}

	--- Initialization called on ADDON_LOADED
	function PermoksAccountManager:OnInitialize()
		self.spairs = spairs
		self.isBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC

	 	-- init databroker
		self.db = LibStub("AceDB-3.0"):New("PermoksAccountManagerDB", defaultDB, true)
		PermoksAccountManager:RegisterChatCommand('pam', 'HandleChatCommand')
	  	LibIcon:Register("PermoksAccountManager", PermoksAccountManagerLDB, self.db.profile.minimap)

		PermoksAccountManager:CreateFrames()
		self.managerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		self.managerFrame:SetScript("OnEvent", function(self, event, arg1, arg2)
			if event == "PLAYER_ENTERING_WORLD" then
				if arg1 or arg2 then
					PermoksAccountManager:OnLogin()
					FrameUtil.RegisterFrameForEvents(self, PermoksAccountManagerEvents)
				end
			else
				if arg1 and arg1:lower() == "!allkeys" then
					PermoksAccountManager:PostKeysIntoChat(event == "CHAT_MSG_GUILD" and "guild" or "party")
				end
			end
		end)
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

	local mainFrame = CreateFrame("Frame", "PermoksAccountManagerFrame", UIParent)
	self.managerFrame = mainFrame
	mainFrame:SetFrameStrata(options.other.frameStrata)
	mainFrame:ClearAllPoints()
	mainFrame:Hide()
	tinsert(UISpecialFrames, "PermoksAccountManagerFrame")

	-- Restore saved position
  	if options.savePosition then
		local position = self.db.global.position
		mainFrame:SetPoint(position.point or "TOP", WorldFrame, position.relativePoint or "TOP", position.xOffset or 0, position.yOffset or -300)
	else
		mainFrame:SetPoint("TOPLEFT", WorldFrame, "TOPLEFT", WorldFrame:GetWidth()/3, -300)
	end

	local mainFrameBackdrop = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	mainFrame.backdrop = mainFrameBackdrop
	self:UpdateBorder(mainFrameBackdrop, mainFrame, true)

	mainFrame.label_column = CreateFrame("Button", nil, mainFrame)
	mainFrame.label_column:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, -5)
	mainFrame.label_column:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMLEFT", 120, 0)
	mainFrame.altColumns = {general = {}}

	mainFrame.topDragBar = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	mainFrame.topDragBar:ClearAllPoints()
	mainFrame.topDragBar:SetHeight(30)
	mainFrame.topDragBar:SetPoint("BOTTOMLEFT", mainFrame, "TOPLEFT", -5, 0)
	mainFrame.topDragBar:SetPoint("BOTTOMRIGHT", mainFrame, "TOPRIGHT", 5, 0)
	mainFrame.topDragBar:EnableMouse(true)
	mainFrame.topDragBar:RegisterForDrag("LeftButton")
	mainFrame.topDragBar:SetScript("OnDragStart", function(self,button)
		mainFrame:SetMovable(true)
    	mainFrame:StartMoving()
	end)
	mainFrame.topDragBar:SetScript("OnDragStop", function(self,button)
    	mainFrame:StopMovingOrSizing()

    	mainFrame:ClearAllPoints()
    	mainFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", mainFrame:GetLeft(), mainFrame:GetTop() - UIParent:GetTop())

		mainFrame:SetMovable(false)
	end)
	self:UpdateBorder(mainFrame.topDragBar, nil, true)

	local categoryFrame = CreateFrame("Frame", nil, mainFrame)
	self.categoryFrame = categoryFrame
	mainFrame.categoryFrame = categoryFrame
	categoryFrame:SetPoint("TOPLEFT", mainFrame, "BOTTOMLEFT", 0, -15)
	categoryFrame:SetPoint("TOPRIGHT", mainFrame, "BOTTOMRIGHT", 0, -15)

	local cLabelColumn = CreateFrame("Frame", nil, categoryFrame)
	categoryFrame.labelColumn = cLabelColumn
	cLabelColumn.categories = {}
	cLabelColumn:SetPoint("TOPLEFT", categoryFrame, "TOPLEFT", 0, -5)
	cLabelColumn:SetPoint("BOTTOMRIGHT", categoryFrame, "BOTTOMLEFT", 120, 0)
	categoryFrame.altColumns = {}

	local categoryFrameBackdrop = CreateFrame("Frame", nil, categoryFrame, "BackdropTemplate")
	categoryFrame.backdrop = categoryFrameBackdrop
	self:UpdateBorder(categoryFrameBackdrop, categoryFrame, true)
	categoryFrame:Hide()

	return mainFrame
end


function PermoksAccountManager:CreateMenuButtons()
	local mainFrame = self.managerFrame

	-------------------
	-- Close Button
	local closeButton = CreateFrame("Button", nil, mainFrame.topDragBar)
	mainFrame.closeButton = closeButton
	closeButton:ClearAllPoints()
	closeButton:SetSize(20, 20)
	closeButton:SetPoint("RIGHT", mainFrame.topDragBar, "RIGHT", -5, 0)
	closeButton:SetScript("OnClick", function() PermoksAccountManager:HideInterface() end)
	closeButton:SetNormalTexture("Interface/Addons/PermoksAccountManager/textures/testbutton.tga")
	closeButton:SetHighlightAtlas("auctionhouse-nav-button-highlight", false)

	local closeButtonTexture = closeButton:CreateTexture(nil, "OVERLAY")
	closeButton.x = closeButtonTexture
	closeButtonTexture:SetAllPoints()
	closeButtonTexture:SetTexture("Interface/Addons/PermoksAccountManager/textures/testbuttonx.tga")
	closeButton:SetScript("OnMouseDown", function() closeButtonTexture:AdjustPointsOffset(1, -1) end)
	closeButton:SetScript("OnMouseUp", function() closeButtonTexture:AdjustPointsOffset(-1, 1) end)

	-------------------
	-- Guild Attunement Button
	if self.isBC then
		local guildAttunementButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
		mainFrame.guildAttunementButton = guildAttunementButton
		guildAttunementButton:SetSize(80, 20)
		guildAttunementButton:ClearAllPoints()
		guildAttunementButton:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", -85, -5)
		guildAttunementButton:SetText("Attunement")
		guildAttunementButton:SetScript("OnClick", PermoksAccountManager.ShowGuildAttunements)
	end
end

function PermoksAccountManager:IsBCCClient()
	return WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
end

function PermoksAccountManager:CheckForModernize()
	local internalVersion = self.db.global.internalVersion
	if not internalVersion or internalVersion < INTERNALVERSION then
		self:Modernize(internalVersion)
	end
	self.db.global.internalVersion = INTERNALVERSION
end

function PermoksAccountManager:Modernize(oldInternalVersion)
	local db = self.db
	local data = db.global.data

	if (oldInternalVersion or 0) < 2 then
		self:UpdateDefaultCategories("general")
		oldInternalVersion = 2
	end
end

function PermoksAccountManager:getGUID()
	self.myGUID = self.myGUID or UnitGUID("player")
	return self.myGUID
end

function PermoksAccountManager:SortPages()
	local account = self.db.global.accounts.main
	local data = account.data
	local sortKey = self.isBC and "charLevel" or "ilevel"
	wipe(account.pages)

	local enabledAlts = 1
	for alt_guid, alt_data in self.spairs(data, function(t, a, b) if t[a] and t[b] then return t[a][sortKey] > t[b][sortKey] end end) do
		if not self.db.global.blacklist[alt_guid] then
			local page = ceil(enabledAlts/self.db.global.options.characters.charactersPerPage)
			account.pages[page] = account.pages[page] or {}
			tinsert(account.pages[page], alt_guid)
			enabledAlts = enabledAlts + 1

			alt_data.page = page
		end
	end

	if self.db.global.currentPage > #account.pages then
		self.db.global.currentPage = #account.pages
	end

	for i=1, #account.pages do
		table.sort(account.pages[i], function(a, b) if data[a] and data[b] then return data[a][sortKey] > data[b][sortKey] end end) 
	end
end

function PermoksAccountManager:AddBasicCharacterInfo(charInfo)
	local _, class = UnitClass("player")
	charInfo.class = class
	charInfo.faction = UnitFactionGroup("player")

	local name, realm = UnitFullName('player')
	charInfo.name = name
	charInfo.realm = realm

	charInfo.charLevel = UnitLevel("player")
end

function PermoksAccountManager:AddNewCharacter(account, guid, alts)
	local data = account.data
	data[guid] = {guid = guid}

	self:AddBasicCharacterInfo(data[guid])
	local page = ceil(alts/self.db.global.options.characters.charactersPerPage)
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
	local guid = self:getGUID()
	local level = UnitLevel("player")
	local min_level = db.options.characters.minLevel

	self.elvui = IsAddOnLoaded("ElvUI")
	self.ElvUI_Skins = self.elvui and ElvUI[1]:GetModule("Skins")
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

		if not self.charInfo.page then
			self.charInfo.page = self:FindPageForGUID(guid)
		end
	end

	self:SortPages()
	self.LoadOptions()
	self.UpdateCustomLabelOptions()

	C_Timer.After(self:GetNextWeeklyResetTime(), function() self:CheckForReset() end)
end

function PermoksAccountManager:SkinButtonElvUI(button)
	if not self.elvui then return end

	self.ElvUI_Skins:HandleButton(button)
end

function PermoksAccountManager:TimeToDaysHoursMinutes(expirationTime)
	if expirationTime == 0 then return 0 end

	local remaining = expirationTime - time()
	local days = floor(remaining / 86400)
	local hours = floor((remaining/3600) - (days * 24))
	local minutes = floor((remaining / 60) - (days * 1440) - (hours * 60))

	return days, hours, minutes
end


-- Rewright needed
function PermoksAccountManager:CheckForReset()
	local db = self.db.global
	local currentTime = time()
	local resetDaily = currentTime > (db.dailyReset or 0)
	local resetWeekly = currentTime > (db.weeklyReset or 0)
	local resetBiweekly = currentTime > (db.biweeklyReset or 0)
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
	altData.keyDungeon = L["No Key"]
	altData.keyLevel = 0

	-- Weekly Quests
	if altData.questInfo and altData.questInfo.weekly then
		for visibility, quests in pairs(altData.questInfo.weekly) do
			wipe(altData.questInfo.weekly[visibility])
		end
	end
end

function PermoksAccountManager:ResetDailyActivities(db, altData)
	local currentTime = time()
	
	if altData.completedDailies then
		wipe(altData.completedDailies)
	end

	-- Callings
	if altData.callingsUnlocked and altData.callingInfo and altData.callingInfo.numCallings and altData.callingInfo.numCallings < 3 then
		altData.callingInfo.numCallings = altData.callingInfo.numCallings + 1
		altData.callingInfo[#altData.callingInfo + 1] = currentTime + self:GetNextDailyResetTime() + (86400*2)
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
			wipe(altData.questInfo.daily[visibility])
		end
	end
end

function PermoksAccountManager:ResetBiweeklyActivities(altData)
	if altData.questInfo and altData.questInfo.biweekly then
		for visibility, quests in pairs(altData.questInfo.biweekly) do
			wipe(altData.questInfo.biweekly[visibility])
		end
	end
end

function PermoksAccountManager:RequestCharacterInfo()
	if not self.isBC then
		RequestRatedInfo()
		CovenantCalling_CheckCallings()
	end
end

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
	if not charInfo then return end

	for key, info in pairs(self.labelRows) do
		if info.isComplete then
			self:SaveCompletionData(key, info.isComplete(charInfo), charInfo.guid)
		end
	end
end

function PermoksAccountManager:SaveCompletionData(key, isComplete, guid)
	if not guid then return end

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

	local mainFrame = self.managerFrame
	local accountDropdown = mainFrame.accountDropdown or AceGUI:Create("Dropdown")
	if not mainFrame.accountDropdown then
		mainFrame.accountDropdown = accountDropdown
		accountDropdown:SetLabel("Account")
		accountDropdown:SetWidth(120)
		accountDropdown:SetPoint("BOTTOMLEFT", mainFrame.topDragBar, "BOTTOMLEFT", 0, 5)
		accountDropdown.frame:SetParent(mainFrame)
		accountDropdown:SetCallback("OnValueChanged", function(self, _, accountKey)
			PermoksAccountManager.db.global.currentPage = 1

			if PermoksAccountManager.managerFrame.pageDropdown then
				PermoksAccountManager.managerFrame.pageDropdown:SetValue(1)
			end
			PermoksAccountManager.account = PermoksAccountManager.db.global.accounts[accountKey]
			PermoksAccountManager:HideAllCategories()
			PermoksAccountManager:UpdateAltAnchors("general", mainFrame, mainFrame.label_column)
			PermoksAccountManager:UpdateStrings(1, "general")
			PermoksAccountManager:UpdatePageButtons()
			PermoksAccountManager:UpdateMainFrameSize()
		end)
	end
	mainFrame.accountButtons = mainFrame.accountButtons or {}

	local accountList = {}
	local accountOrder = {}
	for accountName, accountInfo in self.spairs(db.accounts, function(t, a, b) return a == "main" end) do
		accountList[accountName] = accountInfo.name
		tinsert(accountOrder, accountName)
	end

	accountDropdown:Fire("OnClose")
	accountDropdown:SetList(accountList, accountOrder)
	accountDropdown:SetValue("main")
end

function PermoksAccountManager:UpdatePageButtons()
	local db = self.db.global
	local pages = self.account.pages
	local mainFrame = self.managerFrame
	local categoryFrame= self.categoryFrame

	--if #pages == 1 and mainFrame.pageDropdown then mainFrame.pageDropdown.frame:Hide() return end 
	local pageDropdown = mainFrame.pageDropdown or AceGUI:Create("Dropdown")

	if not mainFrame.pageDropdown then
		mainFrame.pageDropdown = pageDropdown
		pageDropdown:SetLabel("Page")
		pageDropdown.text:SetJustifyH("LEFT")
		pageDropdown:SetPoint("BOTTOMLEFT", mainFrame.topDragBar, "BOTTOMLEFT", 125, 5)
		pageDropdown:SetWidth(100)
		pageDropdown:SetCallback("OnValueChanged", function(self, _, pageNumber)
			PermoksAccountManager.db.global.currentPage = pageNumber
			PermoksAccountManager:UpdateAltAnchors("general", mainFrame, mainFrame.label_column)
			PermoksAccountManager:UpdateStrings(pageNumber, "general")
			PermoksAccountManager:UpdateMainFrameSize(true)

			if categoryFrame.openCategory then
				local category = categoryFrame.openCategory
				PermoksAccountManager:UpdateAltAnchors(category, categoryFrame, categoryFrame.labelColumn.categories[category])
				PermoksAccountManager:UpdateStrings(nil, category, categoryFrame)
			end
		end)
		pageDropdown.frame:SetParent(mainFrame)
	end

	local pageList = {}
	local pageOrder = {}
	for pageNumber, alts in pairs(pages) do
		pageList[pageNumber] = tostring(pageNumber)
		tinsert(pageOrder, pageNumber)
	end
	table.sort(pageOrder)

	pageDropdown.frame:Show()
	pageDropdown:SetList(pageList, pageOrder)	
	pageDropdown:SetValue(1)
end


local function UpdateOrCreateMenu(category, anchorFrame, parent)
	local db = PermoksAccountManager.db.global
	local completionData = db.completionData
	local childs = db.currentCategories[category].childs
	local options = db.currentCategories[category].childOrder
	if not options then return end

	PermoksAccountManager.managerFrame.labels = PermoksAccountManager.managerFrame.labels or {}
	PermoksAccountManager.managerFrame.labels[category] = PermoksAccountManager.managerFrame.labels[category] or {}
	local labels = PermoksAccountManager.managerFrame.labels[category]
	local alts = #PermoksAccountManager.account.pages[PermoksAccountManager.db.global.currentPage]

	local enabledRows = 0
	for j, row_iden in pairs(childs) do
		local row = PermoksAccountManager.labelRows[row_iden]
		if row then
			if row.label then
				local text = type(row.label) == "function" and row.label() or row.label
				local label_row = labels[row_iden] or CreateFontFrame("label", parent or anchorFrame, row, nil, text, nil, 120)
				labels[row_iden] = label_row
				label_row:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, -enabledRows*20)
				label_row:Show()

				PermoksAccountManager:UpdateMenuButton(label_row)
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

local function updateButtonTexture(button, index, row_identifier, alt_guid)
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

function PermoksAccountManager:UpdateRowButton(button, buttonOptions, row_identifier)
	button:SetWidth(buttonOptions.buttonWidth)

	local fontString = button.fontString or button:GetFontString()
	if fontString then
		fontString:SetJustifyH(buttonOptions.justifyH)
		fontString:SetWidth(buttonOptions.buttonTextWidth)

		if self.db.global.updateFont then
			local font, size = fontString:GetFont()
			fontString:SetFont(LSM:Fetch("font", self.db.global.options.font), size)
		end
	end
end

function PermoksAccountManager:UpdateMenuButton(button)
	local fontString = button.fontString or button:GetFontString()
	if fontString and self.db.global.updateFont then
		local font, size = fontString:GetFont()
		fontString:SetFont(LSM:Fetch("font", self.db.global.options.font), size)
	end
end

function PermoksAccountManager:UpdateAltAnchors(category, columnFrame, customAnchorFrame)
	columnFrame.altColumns[category] = columnFrame.altColumns[category] or {}

	local db = self.db.global
	local altDataForPage = self.account.pages[db.currentPage or 1]
	if not altDataForPage then return end

	local widthPerAlt = db.options.other.widthPerAlt
	local labelOffset = db.options.other.labelOffset
	local altColumns = columnFrame.altColumns[category]

	if #altColumns > #altDataForPage then
		for index = #altDataForPage + 1, #altColumns do
			altColumns[index]:Hide()
		end
	end

	for index, alt_guid in ipairs(altDataForPage) do
		local anchorFrame = altColumns[index] or CreateFrame("Button", nil, customAnchorFrame)
		anchorFrame:SetPoint("TOPLEFT", customAnchorFrame, "TOPRIGHT", (widthPerAlt * (index - 1)) + labelOffset, 0)
		anchorFrame:SetPoint("BOTTOMRIGHT", customAnchorFrame, "BOTTOMLEFT", (widthPerAlt * index) + widthPerAlt + labelOffset, 0)
		anchorFrame.GUID = alt_guid
		anchorFrame:Show()

		altColumns[index] = anchorFrame
		anchorFrame.rows = anchorFrame.rows or {}
	end
end

function PermoksAccountManager:UpdateAllFonts()
	UpdateFonts()

	UpdateOrCreateMenu("general", self.managerFrame.label_column)
	self:UpdateStrings(self.db.global.currentPage, "general")

	for category, labelColumn in pairs(self.categoryFrame.labelColumn.categories) do
		UpdateOrCreateMenu(category, labelColumn)
		self:UpdateStrings(nil, category, self.categoryFrame)
	end

	self.db.global.updateFont = false
end

local InternalLabelFunctions = {
	quest = function(alt_data, column)
		if not alt_data.questInfo then return "-" end
		if not column.questType or not column.visibility or not column.key then return "-" end

		local required = column.required or 1
		if type(column.required) == "function" then
			required = column.required(alt_data)
		end

		PermoksAccountManager:Debug(alt_data.name)
		local questInfo = alt_data.questInfo[column.questType] and alt_data.questInfo[column.questType][column.visibility] and alt_data.questInfo[column.questType][column.visibility][column.key]
		if not questInfo then return PermoksAccountManager:CreateQuestString(0, required) or "-" end

		return PermoksAccountManager:CreateQuestString(questInfo, required, (column.plus) or (column.plus == nil and required == 1)) or "-"
	end,
	currency = function(alt_data, column)
		if not alt_data.currencyInfo then return "-" end

		local currencyInfo = alt_data.currencyInfo[column.id]
		if not currencyInfo then return "-" end

		return PermoksAccountManager:CreateCurrencyString(currencyInfo, column.abbCurrent, column.abbMax, column.hideMax) or "-"
	end,
	faction = function(alt_data, column)
		if not alt_data.factions then return "-" end

		local factionInfo = alt_data.factions[column.id]
		if not factionInfo then return "-" end

		return PermoksAccountManager:CreateFactionString(factionInfo) or "-"
	end,
	item = function(alt_data, column)
		if not alt_data.itemCounts then return "-" end

		local itemCounts = alt_data.itemCounts[column.key]
		local itemIcon = PermoksAccountManager.db.global.itemIcons[column.id]
		if not itemCounts then return "-" end

		return PermoksAccountManager:CreateItemString(itemCounts, itemIcon, alt_data.name)
	end,
	sanctum = function(alt_data, column)
		if not alt_data.sanctumInfo then return "-" end

		local sanctumInfo = alt_data.sanctumInfo[column.key]
		if not sanctumInfo then return "-" end

		return "Tier " .. sanctumInfo.tier
	end,
	raid = function(alt_data, column)
		if not alt_data.instanceInfo or not alt_data.instanceInfo.raids then return "-" end

		local raidInfo = alt_data.instanceInfo.raids[column.key]
		if not raidInfo then return "-" end

		return PermoksAccountManager:CreateRaidString(raidInfo)
	end,
	pvp = function(alt_data, column)
		if not alt_data.pvp then return "-" end

		local pvpInfo = alt_data.pvp[column.key]
		if not pvpInfo then return "-" end

		return PermoksAccountManager:CreateRatingString(pvpInfo)
	end,
	vault = function(alt_data, column)
		if not alt_data.vaultInfo then return "-" end

		local vaultInfo = alt_data.vaultInfo[column.key]
		if not vaultInfo then return "-" end

		return PermoksAccountManager:CreateVaultString(vaultInfo)
	end,
}

local InternalTooltipFunctions = {
	raid = PermoksAccountManager.RaidTooltip_OnEnter,
	vault = PermoksAccountManager.VaultTooltip_OnEnter,
	item = PermoksAccountManager.ItemTooltip_OnEnter,
	currency = PermoksAccountManager.CurrencyTooltip_OnEnter,
	pvp = PermoksAccountManager.PVPTooltip_OnEnter,
}

function PermoksAccountManager:GetLabelFunction(labelRow)
	return InternalLabelFunctions[labelRow.type] or (type(labelRow.data) == "function" and labelRow.data)
end

function PermoksAccountManager:UpdateColumnForAlt(alt_guid, anchorFrame, category)
	local db = self.db.global
	local buttonOptions = db.options.buttons
	local childs = db.currentCategories[category].childs
	local enabledChilds = db.currentCategories[category].childOrder
	local altData = self.account.data[alt_guid]
	if not altData then return end

	local rows = anchorFrame.rows
	local enabledRows = 0
	local yOffset = 0
	for index, row_identifier in pairs(childs) do
		local labelRow = self.labelRows[row_identifier]
		if labelRow and enabledChilds[row_identifier] then
			local labelFunction = self:GetLabelFunction(labelRow)
			local text = labelFunction and labelFunction(altData, labelRow)
			local row = rows[row_identifier] or CreateFontFrame("row", anchorFrame, labelRow, altData, text, enabledRows)
			if not rows[row_identifier] then
				rows[row_identifier] = row
				if labelRow.tooltip then
					local tooltipFunction
					if labelRow.customTooltip then
						tooltipFunction = labelRow.customTooltip
					elseif InternalTooltipFunctions[labelRow.type] then
						tooltipFunction = InternalTooltipFunctions[labelRow.type]
					elseif type(labelRow.tooltip) == "function" then
						tooltipFunction = labelRow.tooltip
					end
					row:SetScript("OnLeave", Tooltip_OnLeave)
         			row.tooltipFunction = tooltipFunction
				end
			end
      
			if row.tooltipFunction then
				row:SetScript("OnEnter", function(self)
				self.tooltipFunction(self, altData, labelRow)
				end)
			end

			row:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, -yOffset * 20)
			row:SetText(text)
			row:Show()
						
			updateButtonTexture(row, enabledRows, row_identifier, alt_guid)
			self:UpdateRowButton(row, buttonOptions, row_identifier)

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
	if not page then return end

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
	local categoryLabelColumn = self.categoryFrame.labelColumn.categories[category] or CreateFrame("Frame", nil, self.categoryFrame.labelColumn)
	self.categoryFrame.labelColumn.categories[category] = categoryLabelColumn

	categoryLabelColumn:SetPoint("TOPLEFT", self.categoryFrame.labelColumn, "TOPLEFT", 0, 0)
	categoryLabelColumn.state = defaultState or categoryLabelColumn.state or "closed"

	if categoryLabelColumn.state == "closed" then
		local numRows = UpdateOrCreateMenu(category, categoryLabelColumn)
		self:UpdateAltAnchors(category, self.categoryFrame, categoryLabelColumn)
		self:UpdateStrings(nil, category, self.categoryFrame)
		categoryLabelColumn:SetSize(120, (numRows * 20))
		categoryLabelColumn:Show()
					
		if numRows > 0 then
			categoryLabelColumn.state = "open"
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
		self.categoryFrame.labelColumn.categories[category].state = "closed"
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
	if not categoryButtons then return end

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
	for category, row in PermoksAccountManager.spairs(categories, function(t, a, b) return t[a].order < t[b].order end) do
		if category ~= "general" and db.currentCategories[category].enabled then
			local categoryButton = PermoksAccountManager.managerFrame.categoryButtons[category] or CreateFrame("Button", nil, PermoksAccountManager.managerFrame)
			categoryButton:Show()
			categoryButton:SetPoint("TOPRIGHT", PermoksAccountManager.managerFrame.topDragBar, "TOPLEFT", 0, -(buttonrows*26) - 5)
			if not PermoksAccountManager.managerFrame.categoryButtons[category] then
				categoryButton:SetSize(100, 25)
				categoryButton.name = row.name	

				local normalTexture = categoryButton:CreateTexture()
				categoryButton.normalTexture = normalTexture
				normalTexture:SetSize(categoryButton:GetWidth() + 4, categoryButton:GetHeight() + 11)
				normalTexture:ClearAllPoints()
				normalTexture:SetPoint("TOPLEFT", -2, 0)
				normalTexture:SetAtlas("auctionhouse-nav-button", false)

				categoryButton:SetHighlightAtlas("auctionhouse-nav-button-highlight", false)
				PermoksAccountManager:SkinButtonElvUI(categoryButton)

				local text = categoryButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				categoryButton.Text = text
				text:ClearAllPoints()
				text:SetPoint("CENTER")
				text:SetText(row.name)
				text:SetTextColor(1, 1, 1, 1)

				local selected = categoryButton:CreateTexture()
				categoryButton.selected = selected
				selected:SetSize(categoryButton:GetSize())
				selected:ClearAllPoints()
				selected:SetPoint("CENTER", 0, -1)
				selected:SetAtlas("auctionhouse-nav-button-select", false)
				selected:Hide()

				categoryButton:SetScript("OnMouseDown", function() text:AdjustPointsOffset(1, -1) end)
				categoryButton:SetScript("OnMouseUp", function() text:AdjustPointsOffset(-1, 1) end)
			end

			if row.disable_drawLayer then
				categoryButton:DisableDrawLayer("BACKGROUND")
			end
			
			categoryButton:SetScript("OnClick", function()
				PermoksAccountManager:HideAllCategories(category)
				PermoksAccountManager:UpdateCategory(categoryButton, nil, row.name, category) 
			end)

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
		local backgroundFrame = self.managerFrame.categoriesBackgroundFrame or CreateFrame("Frame", nil, self.managerFrame, "BackdropTemplate")
		if not self.managerFrame.categoriesBackgroundFrame then
			backgroundFrame:SetPoint("TOPRIGHT", self.managerFrame.topDragBar, "TOPLEFT", PermoksAccountManager.db.global.options.border.edgeSize, 0)
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

function PermoksAccountManager:UpdateMainFrameSize(widthOnly, heightOnly)
	local alts = #self.account.pages[self.db.global.currentPage]
	local width = ((alts * self.db.global.options.other.widthPerAlt) + 120) - min((self.db.global.options.other.widthPerAlt - self.db.global.options.buttons.buttonWidth), 20) + 4
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

	local numRows = UpdateOrCreateMenu("general", self.managerFrame.label_column)
	self:UpdateOrCreateCategoryButtons()

	self.managerFrame.height = max(numRows * 20 + 10, max(0,(self.numCategories-2) * 30))
	self.managerFrame.numRows = numRows
	self:UpdateMainFrameSize(widthOnly, heightOnly)
end

function PermoksAccountManager:UpdateAnchorsAndSize(category, widthOnly, heightOnly, updateMenu)
	if category == "general" then
		if updateMenu then
			local numRows = UpdateOrCreateMenu("general", self.managerFrame.label_column)
			self.managerFrame.height = max(numRows * 20 + 10, max(0,(self.numCategories-2) * 30))
		end

		self:UpdateAltAnchors("general", self.managerFrame, self.managerFrame.label_column)
		self:UpdateStrings(self.db.global.currentPage, "general")
	end

	if self.categoryFrame.openCategory then
		local openCategory = self.categoryFrame.openCategory
		self:UpdateCategory(PermoksAccountManager.managerFrame.categoryButtons[openCategory], "closed", nil, openCategory)
	end

	self:UpdateMainFrameSize(widthOnly, heightOnly)
end

do
	local BACKDROP_PAM_NO_BG = {
		edgeFile = "Interface/Buttons/WHITE8X8",
		edgeSize = 5,
	}

	local BACKDROP_PAM_BG = {
		edgeFile = "Interface/Buttons/WHITE8X8",
		bgFile = "Interface/Buttons/WHITE8X8",
		edgeSize = 5,
	}

	local backdrops = {}
	function PermoksAccountManager:UpdateBorder(backdrop, anchor, useBG)
		local borderOptions = self.db.global.options.border
		local color = borderOptions.color
		local bgColor = borderOptions.bgColor or {0.1, 0.1, 0.1, 0.9}
		backdrop:SetBackdrop(nil)

		if anchor then
			backdrop:SetPoint("TOPLEFT", anchor, "TOPLEFT", -5, 5)
			backdrop:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 5, -5)
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

function PermoksAccountManager:CreateFractionString(numCompleted, numDesired, abbreviateCompleted, abbreviateDesired)
	if not numCompleted or not numDesired then return end
	local color = (numDesired and numCompleted >= numDesired and "00ff00") or (numCompleted > 0 and "ff9900") or "ffffff"
	local showNumDesired = numDesired > 0

	numCompleted = abbreviateCompleted and AbbreviateNumbers(numCompleted) or AbbreviateLargeNumbers(numCompleted)
	numDesired = abbreviateDesired and AbbreviateNumbers(numDesired) or numDesired

	if showNumDesired then
		return string.format("|cff%s%s|r/%s", color, numCompleted, numDesired)
	else
		return string.format("|cff%s%s|r", color, numCompleted)
	end
end

function PermoksAccountManager:CreateTimeString(days, hours, minutes)
	local colorThreshold = days > 0
	local color = "ff0000"
	local firstNumber = hours
	local secondNumber = minutes
	local firstAbbreviation = "h"
	local secondAbbreviation = "m"

	if colorThreshold then
		color = "ff5500"
		firstNumber = days
		secondNumber = hours
		firstAbbreviation = "d"
		secondAbbreviation = "h"
	end

	return string.format("|cff%s%02d%s %02d%s|r", color, firstNumber, firstAbbreviation, secondNumber, secondAbbreviation)
end

function PermoksAccountManager:HideInterface()
	if self.db.global.options.hideCategory then
		self.categoryFrame:Hide()
		self:HideAllCategories()
	end

	if self.db.global.options.savePosition then
		local frame = self.managerFrame
		local position = self.db.global.position
		position.point, position.relativeTo, position.relativePoint, position.xOffset, position.yOffset = frame:GetPointByName("TOPLEFT")
	end
	self.managerFrame:Hide();
end

function PermoksAccountManager:ShowInterface()
	if not self.loaded then
		self:CreateMenuButtons()
		self:UpdateAltAnchors("general", self.managerFrame, self.managerFrame.label_column)
		self:UpdateMenu(self.db.global.alts)
		self:UpdatePageButtons()
		self:UpdateAccounts()

		self.loaded = true
	end

	self.myGUID = self.myGUID or UnitGUID("player")
	self:RequestCharacterInfo()

	self.managerFrame:Show()
	self:UpdateCompletionDataForCharacter(self.charInfo)
	self:UpdateMenu()
	self:UpdateStrings(self.db.global.currentPage, "general")
	if self.categoryFrame.openCategory then
		local openCategory = self.categoryFrame.openCategory
		self:UpdateCategory(self.managerFrame.categoryButtons[openCategory], "closed", nil, openCategory)
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
	if weeklyReset then
		return (weeklyReset >= 302400 and weeklyReset - 302400 or weeklyReset)
	end
end

function PermoksAccountManager:PostKeysIntoChat(channel)
	local chatChannel
	if channel and (channel == "raid" or channel == "guild" or channel == "party") then
		chatChannel = channel:upper()
	else
		chatChannel = UnitInParty("player") and "PARTY" or "GUILD"
	end

	local db = self.db.global
	local data = self.account.data
	local keys = {}
	for alt_guid, alt_data in pairs(data) do
		if alt_data.level ~= "0" then
			local key = string.format("[%s: %s+%d]",alt_data.name, alt_data.keyDungeon, alt_data.keyLevel)
			tinsert(keys, key)
		end
	end

	local msg = table.concat(keys, " ")
	SendChatMessage(msg, chatChannel)
end