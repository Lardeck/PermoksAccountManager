local addonName, AltManager = ...

AltManager = LibStub("AceAddon-3.0"):NewAddon(AltManager, "MartinsAltManager", "AceConsole-3.0", "AceEvent-3.0")
local AltManagerLDB = LibStub("LibDataBroker-1.1"):NewDataObject("MartinsAltManager", {
	type = "data source",
	text = "Martins Alt Manager",
	icon = "Interface\\Icons\\INV_Chest_Cloth_17",
	OnClick = function(self, button)
		if button == "LeftButton" then
			if AltManagerFrame:IsShown() then
				AltManager:HideInterface()
			else
				AltManager:ShowInterface()
			end
		elseif button == "RightButton" then
			AltManager:OpenOptions()
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine("|cfff49b42Martins Alt Manager|r")
		tt:AddLine("|cffffffffLeft-click|r to open MartinsAltManager")
		tt:AddLine("|cffffffffRight-click|r to open options")
		tt:AddLine("Type '/mam minimap' to hide the Minimap Button!")
	end
})

local LibIcon = LibStub("LibDBIcon-1.0")
local LibQTip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local VERSION = "9.0.19.9"
local INTERNALVERSION = 11
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
		charactersPerPage = 6,
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
				buttonTextWidth = 120,
				justifyH = "CENTER",
			},
			other = {
				updated = false,
				labelOffset = 15,
				widthPerAlt = 120,
				frameStrata = "MEDIUM",
			},
			savePosition = false,
			showOptionsButton = true,
			showGuildAttunementButton = false,
			currencyIcons = true,
			itemIcons = true,
			guildToTrack = "Jade Falcons",
			customCategories = {
				general = {
					childOrder = {characterName = 0, ilevel = 0.5}, 
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
		currencyIcons = {},
		itemIcons = {},
		position = {},
		version = VERSION,
	},
}

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

function AltManager:Debug(...)
	if self.db.global.options.debug then
		self:Print(...)
	end
end

function AltManager:CreateMainFrame()
	local main_frame = CreateFrame("Frame", "AltManagerFrame", UIParent)
	self.main_frame = main_frame
	main_frame:SetFrameStrata(self.db.global.options.other.frameStrata)
	main_frame.background = main_frame:CreateTexture(nil, "BACKGROUND")
	main_frame.background:SetAllPoints()
	main_frame.background:SetDrawLayer("ARTWORK", 1)
	main_frame.background:SetColorTexture(0, 0, 0.1, 0.8)

	main_frame:ClearAllPoints()
  	if self.db.global.options["savePosition"] then
		local position = self.db.global.position
		main_frame:SetPoint(position.point or "TOP", WorldFrame, position.relativePoint or "TOP", position.xOffset or 0, position.yOffset or -300)
	else
		main_frame:SetPoint("TOP", WorldFrame, "TOP", 0, -300)
	end
	main_frame:Hide()

	main_frame.label_column = CreateFrame("Button", nil, self.main_frame)
	main_frame.label_column:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT")
	main_frame.label_column:SetPoint("BOTTOMRIGHT", self.main_frame, "BOTTOMLEFT", 120, 0)
	main_frame.unrollLabelColumn = CreateFrame("Button", nil, self.main_frame)
	main_frame.unrollLabelColumn:Show()

	main_frame.altColumns = {general = {}}

	return main_frame
end

local altManagerEvents = {
	"BAG_UPDATE_DELAYED",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_GUILD",
	"PLAYER_MONEY",
}

function AltManager:OnInitialize()
	self.spairs = spairs
 	-- init databroker
	self.db = LibStub("AceDB-3.0"):New("MartinsAltManagerDB", defaultDB, true)
	AltManager:RegisterChatCommand('mam', 'HandleChatCommand')
  	AltManager:RegisterChatCommand('alts', 'HandleChatCommand')
  	LibIcon:Register("MartinsAltManager", AltManagerLDB, self.db.profile.minimap)

	local main_frame = AltManager:CreateMainFrame()
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	main_frame:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			local isLogin, isReload = ...

			if isLogin or isReload then
				AltManager:OnLogin()
				FrameUtil.RegisterFrameForEvents(main_frame, altManagerEvents)
			end
		end
		
		if event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
			local msg = ...
			if msg and msg:lower() == "!allkeys" then
				AltManager:PostKeysIntoChat("party")
			end
		elseif event == "CHAT_MSG_GUILD" then
			local msg = ...
			if msg and msg:lower() == "!allkeys" then
				AltManager:PostKeysIntoChat("guild")
			end
		elseif AltManager.addon_loaded then
			if event == "BAG_UPDATE_DELAYED" then
				AltManager:CollectData()
				AltManager:SendCharacterUpdate("charLevel")
			elseif event == "PLAYER_MONEY" then
				AltManager:UpdateGold()
				AltManager:SendCharacterUpdate("gold")
			elseif event =="CHALLENGE_MODE_COMPLETED" then
				AltManager:UpdateMythicScore()
			end
		end
	end)
end

function AltManager:OnEnable()
	self.addon_loaded = true
	if not self.isBC then
		tinsert(altManagerEvents, "CHALLENGE_MODE_COMPLETED")
	end
end

function AltManager:OnDisable()
	self.addon_loaded = false
end

function AltManager:IsBCCClient()
	return WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
end

function AltManager:CheckForModernize()
	local internalVersion = self.db.global.internalVersion
	if not internalVersion or internalVersion < INTERNALVERSION then
		self:Modernize(internalVersion)
	end
	self.db.global.internalVersion = INTERNALVERSION
end

function AltManager:Modernize(oldInternalVersion)
	local db = self.db
	local data = db.global.data

	if not oldInternalVersion then
		for alt_guid, alt_data in pairs(data) do
			local questInfo = alt_data.questInfo

			questInfo.daily.maw_dailies = questInfo.daily.maw
			questInfo.daily.maw = nil

			questInfo.daily.transport_network = questInfo.daily.nfTransport
			questInfo.daily.nfTransport = nil

			questInfo.weekly.dungeon_quests = questInfo.weekly.dungeon
			questInfo.weekly.dungeon = nil

			questInfo.weekly.pvp_quests = questInfo.weekly.pvp
			questInfo.weekly.pvp = nil

			questInfo.weekly.weekend_event = questInfo.weekly.weekend
			questInfo.weekly.weekend = nil

			questInfo.weekly.world_boss = questInfo.weekly.wb
			questInfo.weekly.wb = nil

			questInfo.weekly.maw_souls = questInfo.weekly.souls
			questInfo.weekly.souls = nil

			questInfo.weekly.maw_weekly = questInfo.weekly.maw
			questInfo.weekly.maw = nil
		end

		local blacklist = self.db.global.blacklist
		for guid, name in pairs(self.db.global.blacklist) do
			blacklist[guid] = {name = name, class = data[guid].class, realm = data[guid].realm}
		end
		oldInternalVersion = 1
	end

	if oldInternalVersion < 2 then
		self:UpdateDefaultCategories("items")
		oldInternalVersion = 2
	end

	if oldInternalVersion < 3 then
		db.global.accounts.main.data = (data and data) or (db.battleTag and db.global.accounts[db.battleTag] and db.global.accounts[db.battleTag].data) or db.global.accounts.main.data
		local accountTable = db.global.accounts.main

		local numCharacter = 1
		for alt_guid, alt_data in pairs(accountTable.data) do
			local page = floor(numCharacter/db.global.charactersPerPage) + 1

			accountTable.pages[page] = accountTable.pages[page] or {}
			tinsert(accountTable.pages[page], alt_guid)
			alt_data.page = page
			numCharacter = numCharacter + 1
		end

		db.global.data = nil
		self:UpdateDefaultCategories("items")
		self:UpdateDefaultCategories("general")

		oldInternalVersion = 3
	end

	if oldInternalVersion < 8 then
		wipe(AltManager.db.global.options.defaultCategories.general)
		oldInternalVersion = 9

		BasicMessageDialog.Text:SetText("[MartinsAltManager]\n Default Categories have been reset.")
		BasicMessageDialog:Show()
	end

	if oldInternalVersion < 9 then
		self:UpdateDefaultCategories("currentdaily")
		oldInternalVersion = 9
	end

	if oldInternalVersion < 10 then
		for key, info in pairs(self.db.global.accounts) do
			for alt_guid, alt_data in pairs(info.data) do
				for questType, keys in pairs(alt_data.questInfo) do
					if type(keys) == "table" then
						wipe(alt_data.questInfo[questType])
					end
				end
			end
		end

		self:UpdateDefaultCategories("currentweekly")
		oldInternalVersion = 10
	end

	----------------------------------------------
	-- - Fix raidActivityInfo not resetting weekly
	-- - Fix biweekly reset calculation
	if oldInternalVersion < 11 then
		for key, info in pairs(self.db.global.accounts) do
			for alt_guid, alt_data in pairs(info.data) do
				alt_data.raidActivityInfo = {}
				alt_data.biweekly = time() + self:GetNextBiWeeklyResetTime()
			end
		end

		oldInternalVersion = 11
	end
end

function AltManager:getGUID()
	self.myGUID = self.myGUID or UnitGUID("player")
	return self.myGUID
end

local function Tooltip_OnLeave(self)
	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil
	end
end

function AltManager.validateData()
	local guid = AltManager:getGUID()
	if not guid then return end
	if AltManager:isBlacklisted(guid) then return end

	local db = AltManager.db
	local data = AltManager.db.global.accounts.main.data
	local char_table = data[guid]

	return char_table
end

function AltManager:SortPages()
	local account = self.db.global.accounts.main
	local data = account.data
	local sortKey = self.isBC and "charLevel" or "ilevel"
	wipe(account.pages)

	local enabledAlts = 1
	for alt_guid, alt_data in self.spairs(data, function(t, a, b) if t[a] and t[b] then return t[a][sortKey] > t[b][sortKey] end end) do
		if not self.db.global.blacklist[alt_guid] then
			local page = ceil(enabledAlts/self.db.global.charactersPerPage)
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

function AltManager:AddNewCharacter(account, guid, alts)
	local data = account.data
	data[guid] = {}

	local page = ceil(alts/self.db.global.charactersPerPage)
	account.pages[page] = account.pages[page] or {}
	tinsert(account.pages[page], guid)

	data[guid].page = page
end

function AltManager:SaveBattleTag(db)
	if not db.battleTag then
		local _, battleTag = BNGetInfo()
		db.battleTag = battleTag
	end
end

function AltManager:OnLogin()
	local db = self.db.global
	local guid = self:getGUID()
	local level = UnitLevel("player")
	local min_level = GetMaxLevelForExpansionLevel(GetExpansionLevel())
	local min_test_level = 0

	self.isBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
	self:SaveBattleTag(db)
	self:CheckForModernize()
	self.account = db.accounts.main
	self:ValidateReset()

	local data = self.account.data
	if guid and not data[guid] and not self:isBlacklisted(guid) and (not (level < min_level) or not (level < min_test_level)) then
		db.alts = db.alts + 1
		self:AddNewCharacter(self.account, guid, db.alts)
	end
	self.char_table = data[guid]

	self:RequestCharacterInfo()
	self:UpdateEverything()
	self:UpdateCurrentlyActiveQuests()

	self:SortPages(self.account)

	self.LoadOptions()
	db.currentCategories = db.custom and db.options.customCategories or db.options.defaultCategories
	self:UpdateCompletionData()

	self.main_frame.background:SetAllPoints()
	self:UpdateAltAnchors("general", self.main_frame.label_column)
	self:CreateMenuButtons()
	self:UpdateMenu(db.alts)
	self:MakeTopBottomTextures(self.main_frame)

	if #self.account.pages > 1 then
		self:UpdatePageButtons()
	end


	if self.char_table and not self.char_table.page then
		self.char_table.page = self:FindPageForGUID(guid)
	end

	self:UpdateAccounts()
	C_Timer.After(self:GetNextWeeklyResetTime(), function() self:ValidateReset() end)
end

local CreateFontFrame
do
	local normalFont = CreateFont("MAM_NormalFont")
	normalFont:SetFont("Fonts\\FRIZQT__.TTF", 11)
	normalFont:SetTextColor(1, 1, 1, 1)

	local smallFont = CreateFont("MAM_SmallFont")
	smallFont:SetFont("Fonts\\FRIZQT__.TTF", 9)
	smallFont:SetTextColor(1, 1, 1, 1)

	local function createColumnFont(button, column, alt_data, text, buttonOptions)
		text = text or column.data(alt_data)
		button:SetNormalFontObject(column.small and smallFont or normalFont)
		button:SetText(text)

		local fontString = button:GetFontString()
		if fontString then
			button.fontString = fontString
			fontString:SetSize(105, 20)
			fontString:SetJustifyV(column.justify or "MIDDLE")
			fontString:SetJustifyH(buttonOptions.justifyH)
		end
	end

	local function createLabelFont(button, text, buttonOptions)
		button:SetNormalFontObject(normalFont)
		button:SetText(text .. ":")

		local fontString = button:GetFontString()
		fontString:SetSize(120, 20)
		fontString:SetJustifyV("CENTER")
		fontString:SetJustifyH("RIGHT")
	end

	function CreateFontFrame(parent, column, alt_data, text, index, width)
		local buttonOptions = AltManager.db.global.options.buttons
		local button = CreateFrame("Button", nil, parent)
		button:SetSize(width or buttonOptions.buttonWidth, 20)
		button:SetPushedTextOffset(0, 0)
		--button:SetFrameStrata("MEDIUM")

		if column then
			if not column.hideOption and not column.fakeLabel then
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
		else
			createLabelFont(button, text, buttonOptions)
		end

		return button
	end
end

function AltManager:timeToDaysHoursMinutes(expirationTime)
	if expirationTime == 0 then return 0 end

	local remaining = expirationTime - time()
	local days = floor(remaining / 86400)
	local hours = floor((remaining/3600) - (days * 24))
	local minutes = floor((remaining / 60) - (days * 1440) - (hours * 60))

	return days, hours, minutes
end

function AltManager:ValidateReset()
	local db = self.db.global
	local data = self.account.data

	for account, accountData in pairs(db.accounts) do
		for alt_guid, char_table in pairs(accountData.data) do
			local expiry = char_table.expires or 0
			local daily = char_table.daily or 0
			local biweekly = char_table.biweekly or 0
			local currentTime = time()


			--modernize
			if type(char_table.currencyInfo) ~= "table" then
				char_table.currencyInfo = {}
			end

			if currentTime > expiry then
				wipe(db.completionData)

				-- M0/Raids
				if char_table.instanceInfo then
					char_table.instanceInfo.raids = {}
					char_table.instanceInfo.dungeons = {}
				end

				-- Torghast
				if char_table.torghastInfo then
					wipe(char_table.torghastInfo)
				end

				-- Vault
				if char_table.vaultInfo then
					for activityType, activityInfos in pairs(char_table.vaultInfo) do
						for i, activityInfo in ipairs(activityInfos) do
							activityInfo.level = 0
							activityInfo.progress = 0
						end
					end
				end

				char_table.raidActivityInfo = {}

				-- M+
				char_table.dungeon = "Unknown";
				char_table.level = "?";

				-- Weekly Quests
				if char_table.questInfo and char_table.questInfo.weekly then
					for visibility, quests in pairs(char_table.questInfo.weekly) do
						wipe(char_table.questInfo.weekly[visibility])
					end
				end

				-- Reset
				char_table.expires = currentTime + self:GetNextWeeklyResetTime();
			end

			if currentTime > daily then
				wipe(db.completionData)

				if char_table.completedDailies then
					wipe(char_table.completedDailies)
				end

				-- Callings
				if char_table.callingsUnlocked and char_table.callingInfo and char_table.callingInfo.numCallings and char_table.callingInfo.numCallings < 3 then
					char_table.callingInfo.numCallings = char_table.callingInfo.numCallings + 1
					char_table.callingInfo[#char_table.callingInfo + 1] = currentTime + self:GetNextDailyResetTime() + (86400*2)
				end

				if char_table.covenant and db.currentCallings[char_table.covenant] then
					for questID, currentCallingInfo in pairs(db.currentCallings[char_table.covenant]) do
						if currentCallingInfo.timeRemaining and currentCallingInfo.timeRemaining < time() then
							db.currentCallings[char_table.covenant][questID] = nil
						end
					end
				end

				-- Eye of the Jailer
				if char_table.jailerInfo then
					char_table.jailerInfo.stage = 0
					char_table.jailerInfo.threat = 0
				end

				-- Daily Quests
				if char_table.questInfo and char_table.questInfo.daily then
					for visibility, quests in pairs(char_table.questInfo.daily) do
						wipe(char_table.questInfo.daily[visibility])
					end
				end

				-- Reset
				char_table.daily = currentTime + self:GetNextDailyResetTime()
			end

			if currentTime > biweekly then
				if char_table.questInfo and char_table.questInfo.biweekly then
					for visibility, quests in pairs(char_table.questInfo.biweekly) do
						wipe(char_table.questInfo.biweekly[visibility])
					end
				end

				char_table.biweekly = currentTime + self:GetNextBiWeeklyResetTime()
			end
		end
	end
end

function AltManager:RequestCharacterInfo()
	if not self.isBC then
		RequestRatedInfo()
		CovenantCalling_CheckCallings()
	end
end

function AltManager:UpdateEverything()
	if self.isBC then
		self:UpdateAllBCCQuests()
		self:UpdateLocation()
		self:UpdateProfessions()
		self:UpdateProfessionCDs()
	else
		
		self:UpdateAllRetailQuests()
		self:UpdateTorghast()
		self:UpdateVaultInfo()
		self:UpdateSanctumBuildings()
		self:UpdatePVPRating()
		self:UpdateMythicScore()
	end

	self:CollectData()
	self:UpdateInstanceInfo()
	self:UpdateAllCurrencies()
	self:UpdateFactions()
	self:UpdateItemCounts()
end

function AltManager:UpdateCompletionData()
	local db = self.db.global
	local accountData = db.accounts.main
	for alt_guid, alt_data in pairs(accountData.data) do
		for key, info in pairs(self.columns) do
			if info.isComplete then
				self:SaveCompletionData(key, info.isComplete(alt_data), alt_guid)
			end
		end
	end
end

function AltManager:UpdateCompletionDataForCharacter()
	local char_table = self.validateData()
	if not char_table then return end

	for key, info in pairs(self.columns) do
		if info.isComplete then
			self:SaveCompletionData(key, info.isComplete(char_table), char_table.guid)
		end
	end
end

function AltManager:UpdateGold()
	local char_table = self.validateData()
	if not char_table then return end

	char_table.gold = floor(GetMoney() / (COPPER_PER_SILVER * SILVER_PER_GOLD)) * 10000
end

function AltManager:CollectData()
	local guid = self:getGUID()
	if not guid then return end
	local char_table = self.validateData()
	if not char_table then return end
	char_table.guid = guid

	-- Basic
	local name, realm = UnitFullName('player')
	char_table.name = name
	char_table.realm = realm

	local charLevel = UnitLevel("player")
	char_table.charLevel = charLevel

	local _, class = UnitClass('player')
	char_table.class = class

	local faction = UnitFactionGroup("player")
	char_table.faction = faction

	char_table.gold = floor(GetMoney() / (COPPER_PER_SILVER * SILVER_PER_GOLD)) * 10000

	local currentTime = time()
	char_table.expires = currentTime + self:GetNextWeeklyResetTime()
	char_table.daily = currentTime + self:GetNextDailyResetTime()
	char_table.biweekly = currentTime + self:GetNextBiWeeklyResetTime()

	if not self.isBC then
		local _, ilevel = GetAverageItemLevel()
		char_table.ilevel = ilevel
			-- Keystone
		local ownedKeystone = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local dungeon = "Unknown"
		local level = "?"
		
		if ownedKeystone then
			dungeon = self.keys[ownedKeystone]
			level = C_MythicPlus.GetOwnedKeystoneLevel()
		end
		char_table.dungeon = dungeon
		char_table.level = level

		-- Contracts
		local contract = nil
		local contracts = {[311457] = "CoH",[311458] = "Ascended",[311460] = "UA",[311459] = "WH", [353999] = "DA"}
		for spellId, faction in pairs(contracts) do
			local info = {GetPlayerAuraBySpellID(spellId)}
			if info[1] then
				contract = {faction = faction, duration = info[5], expirationTime = time() + (info[6] - GetTime())}
				break
			end
		end
		char_table.contract = contract

		-- Covenant
		local covenant = C_Covenants.GetActiveCovenantID()
		char_table.covenant = covenant > 0 and covenant

		local renown = C_CovenantSanctumUI.GetRenownLevel()
		char_table.renown = renown

		local callingsUnlocked = C_CovenantCallings.AreCallingsUnlocked()
		char_table.callingsUnlocked = callingsUnlocked
	end
end

function AltManager:UpdateMythicScore()
	local char_table = self.char_table
	if not char_table then return end

	char_table.mythicScore = C_ChallengeMode.GetOverallDungeonScore and C_ChallengeMode.GetOverallDungeonScore()
end

function AltManager:UpdateAccountButtons()
	local db = self.db.global
	if db.numAccounts == 1 then return end
	self.main_frame.accountButtons = self.main_frame.accountButtons or {}

	local accountIndex = 0
	for accountName, accountInfo in self.spairs(db.accounts, function(t, a, b) return a == "main" end) do
		local accountButton = self.main_frame.accountButtons[accountName] or CreateFrame("Button", nil, AltManager.main_frame, "UIPanelButtonTemplate")
		if not self.main_frame.accountButtons[accoutName] then
			accountButton:SetSize(100, 20)
			accountButton:SetText(accountInfo.name or accountName)
			accountButton:Show()
			
			accountButton:SetScript("OnClick", function()
				AltManager.db.global.currentPage = 1
				AltManager.account = accountInfo
				AltManager:RollUpAll()
				AltManager:UpdateAltAnchors("general", self.main_frame.label_column)
				AltManager:PopulateStrings(1, "general")
				AltManager:UpdatePageButtons()
				AltManager:UpdateMainFrameSize()
			end)
		end
		accountButton:SetPoint("BOTTOMLEFT", self.main_frame, "TOPLEFT", accountIndex * 100, 32)
		self.main_frame.accountButtons[accountName] = accountButton
		accountIndex = accountIndex + 1
	end

	for accountName, button in pairs(self.main_frame.accountButtons) do
		if not self.db.global.accounts[accountName] then
			button:Hide()
		end
	end
end

function AltManager:UpdatePageButtons()
	local db = self.db.global
	local pages = self.account.pages
	self.main_frame.pageButtons = self.main_frame.pageButtons or {}


	if #pages == 1 then
		for pageNumber, button in pairs(self.main_frame.pageButtons) do
			button:Hide()
		end
	else
		for pageNumber, alts in pairs(pages) do
			local pageButton = self.main_frame.pageButtons[pageNumber] or CreateFrame("Button", nil, AltManager.main_frame, "UIPanelButtonTemplate")
			if not self.main_frame.pageButtons[pageNumber] then
				pageButton:SetSize(45, 25)
				pageButton:SetText(pageNumber)
				--pageButton:SetFrameStrata("MEDIUM")

				if pageNumber == self.db.global.currentPage then
					pageButton:SetText("[" .. pageNumber .. "]")
				else
					pageButton:SetText(pageNumber)
				end
			end
			pageButton:Show()
			pageButton:SetPoint("TOPLEFT", self.main_frame, "BOTTOMLEFT", (pageNumber - 1) * 45 + 3, -4)
			
			pageButton:SetScript("OnClick", function(self)
				for buttonPageNumber, button in pairs(AltManager.main_frame.pageButtons) do
					button:SetText(buttonPageNumber)
				end

				self:SetText("[" .. pageNumber .. "]")
				AltManager.db.global.currentPage = pageNumber
				AltManager:UpdateAltAnchors("general", AltManager.main_frame.label_column)
				AltManager:PopulateStrings(pageNumber, "general")
				AltManager:UpdateMainFrameSize(true)

				if AltManager.main_frame.openUnroll then
					local category = AltManager.main_frame.openUnroll
					AltManager:UpdateAltAnchors(category, AltManager.main_frame.unrollLabelColumn[category])
					AltManager:PopulateStrings(nil, category)
				end
			end)
			self.main_frame.pageButtons[pageNumber] = pageButton
		end
	end
end


local function UpdateOrCreateMenu(category, anchorFrame, parent)
	local db = AltManager.db.global
	local completionData = db.completionData
	local childs = db.currentCategories[category].childs
	local options = db.currentCategories[category].childOrder
	if not options then return end

	AltManager.main_frame.labels = AltManager.main_frame.labels or {}
	AltManager.main_frame.labels[category] = AltManager.main_frame.labels[category] or {}
	local labels = AltManager.main_frame.labels[category]
	local alts = #AltManager.account.pages[AltManager.db.global.currentPage]

	local enabledRows = 0
	for j, row_iden in pairs(childs) do
		local row = AltManager.columns[row_iden]
		if row and row.label then
			-- parent, column, alt_data, text
			local text = type(row.label) == "function" and row.label() or row.label
			local label_row = labels[row_iden] or CreateFontFrame(parent or anchorFrame, nil, nil, text, nil, 120)
			labels[row_iden] = label_row
			label_row:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, -enabledRows*20)
			label_row:Show()

			if completionData[row_iden] and completionData[row_iden].numCompleted == alts then
				label_row:GetFontString():SetTextColor(0, 1, 0, 1)
			else
				label_row:GetFontString():SetTextColor(1, 1, 1, 1)
			end

			enabledRows = enabledRows + 1
		elseif row and row.fakeLabel then
			enabledRows = enabledRows + 1
		end
	end

	for row_iden, label in pairs(labels) do
		if not options[row_iden] then
			label:Hide()
		end
	end

	return enabledRows
end

local function updateButtonTexture(button, index)
	if button.normalTexture then
		if index % 2 == 0 then
			button.normalTexture:SetColorTexture(0.7, 0.7, 0.7, 0.25)
		else
			button.normalTexture:SetColorTexture(0.3, 0.3, 0.3, 0.25)
		end
	end
end

function AltManager:UpdateButton(button, buttonOptions)
	button:SetWidth(buttonOptions.buttonWidth)

	local fontString = button:GetFontString()
	if fontString then
		fontString:SetJustifyH(buttonOptions.justifyH)
		fontString:SetWidth(buttonOptions.buttonTextWidth)
	end
end

function AltManager:UpdateAltAnchors(category, customAnchorFrame)
	self.main_frame.altColumns[category] = self.main_frame.altColumns[category] or {}

	local db = self.db.global
	local altDataForPage = self.account.pages[db.currentPage or 1]
	if not altDataForPage then return end
	local widthPerAlt = db.options.other.widthPerAlt
	local labelOffset = db.options.other.labelOffset
	local altColumns = self.main_frame.altColumns[category]

	if #altColumns > #altDataForPage then
		for index = #altDataForPage + 1, #altColumns do
			altColumns[index]:Hide()
		end
	end

	for index, alt_guid in ipairs(altDataForPage) do
		local anchorFrame = altColumns[index] or CreateFrame("Button", nil, customAnchorFrame)
		anchorFrame:SetPoint("TOPLEFT", customAnchorFrame, "TOPRIGHT", (widthPerAlt * (index - 1)) + labelOffset, -1)
		anchorFrame:SetPoint("BOTTOMRIGHT", customAnchorFrame, "BOTTOMLEFT", (widthPerAlt * index) + widthPerAlt + labelOffset, 1)
		anchorFrame.GUID = alt_guid
		anchorFrame:Show()

		altColumns[index] = anchorFrame
		anchorFrame.rows = anchorFrame.rows or {}
	end
end

function AltManager:UpdateColumnForAlt(alt_guid, anchorFrame, category)
	local db = self.db.global
	local buttonOptions = db.options.buttons
	local childs = db.currentCategories[category].childs
	local enabledChilds = db.currentCategories[category].childOrder
	local altData = self.account.data[alt_guid]
	if not altData then return end

	local rows = anchorFrame.rows
	local enabledRows = 0
	for index, column_identifier in pairs(childs) do
		local column = self.columns[column_identifier]
		if column and enabledChilds[column_identifier] then
			local text = (column.type and self.functions[column.type](altData, column)) or (column.data and column.data(altData)) or "-"
			local row = rows[column_identifier] or CreateFontFrame(anchorFrame, column, altData, text, enabledRows)
			rows[column_identifier] = row
			row:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, -enabledRows * 20)
			row:SetText(text)
			row:Show()
						
			updateButtonTexture(row, enabledRows)
			self:UpdateButton(row, buttonOptions)

			if column.tooltip then
				row:SetScript("OnEnter", function(self)
					column.tooltip(self, altData)
				end)
				row:SetScript("OnLeave", Tooltip_OnLeave)
			end

			if column.color and row.fontString then
				row.fontString:SetTextColor(column.color(altData):GetRGBA())
			end

			enabledRows = enabledRows + 1
		end
	end

	for column_identifier, row in pairs(rows) do
		if not enabledChilds[column_identifier] then
			row:Hide()
		end
	end
end


function AltManager:PopulateStrings(page, category)
	local db = self.db.global
	local page = self.account.pages[page or self.db.global.currentPage]
	if not page then return end

	local enabledAlts = 1
	for _, alt_guid in ipairs(page) do
		if not db.blacklist[alt_guid] then
			local anchorFrame = self.main_frame.altColumns[category][enabledAlts]

			self:UpdateColumnForAlt(alt_guid, anchorFrame, category)
			enabledAlts = enabledAlts + 1
		end
	end
end

function AltManager:Unroll(button, defaultState, name, category)
	local categoryUnrollLabelColumn = self.main_frame.unrollLabelColumn[category] or CreateFrame("Button", nil, self.main_frame.unrollLabelColumn)
	self.main_frame.unrollLabelColumn[category] = categoryUnrollLabelColumn

	categoryUnrollLabelColumn:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", 0, -self.main_frame.height - 30)
	categoryUnrollLabelColumn.state = defaultState or categoryUnrollLabelColumn.state or "closed"

	if categoryUnrollLabelColumn.state == "closed" then
		local numRows = UpdateOrCreateMenu(category, categoryUnrollLabelColumn)
		self:UpdateAltAnchors(category, categoryUnrollLabelColumn)
		self:PopulateStrings(nil, category)
		categoryUnrollLabelColumn:SetSize(120, (numRows * 20))
		categoryUnrollLabelColumn:Show()
					
		if numRows > 0 then
			local texture = categoryUnrollLabelColumn.unrollTexture or categoryUnrollLabelColumn:CreateTexture()
			categoryUnrollLabelColumn.unrollTexture = texture
			texture:SetColorTexture(0, 0, 0, 0.85)
			texture:ClearAllPoints()
			texture:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", 0, -self.main_frame.height)
			texture:SetPoint("BOTTOMRIGHT", self.main_frame, "TOPRIGHT", 0, -self.main_frame.height - 30)
			--texture:SetDrawLayer("ARTWORK", 7)

			self.main_frame:SetHeight(self.main_frame.height + (numRows * 20) + 30)
			self.main_frame.optionsButton:SetPoint("TOPRIGHT", self.main_frame, "TOPRIGHT", -3, -self.main_frame.height-4)


			button:SetText((name or button.name) .. " <<")

			categoryUnrollLabelColumn.state = "open"
			self.main_frame.openUnroll = category
			self.main_frame.openUnrollRows = numRows
		end
	else
		self:RollUp(button, category)	
	end
end

function AltManager:RollUp(button, category)
	self.main_frame:SetHeight(self.main_frame.height)
	self.main_frame.background:SetAllPoints()
	self.main_frame.optionsButton:SetPoint("TOPRIGHT", self.main_frame, "BOTTOMRIGHT", -3, -4)
	self.main_frame.unrollButtons[category]:SetText(button.name .. " >")

	if self.main_frame.unrollLabelColumn[category] then
		self.main_frame.unrollLabelColumn[category]:Hide()
		self.main_frame.unrollLabelColumn[category].state = "closed"
	end

	if category == self.main_frame.openUnroll then
		self.main_frame.openUnroll = nil
		self.main_frame.openUnrollRows = nil
	end
end

function AltManager:RollUpAll(currentCategory)
	local unrollButtons = self.main_frame.unrollButtons
	if not unrollButtons then return end

	for category, button in pairs(unrollButtons) do
		if category ~= currentCategory then
			self:RollUp(button, category)
		end
	end
end

local function updateOrCreateUnrollButtons()
	local db = AltManager.db.global
	local buttonrows = 0
	local categories = db.currentCategories
	for category, row in AltManager.spairs(categories, function(t, a, b) return t[a].order < t[b].order end) do
		if category ~= "general" and db.currentCategories[category].enabled then
			local unrollButton = AltManager.main_frame.unrollButtons[category] or CreateFrame("Button", addonName .. "UnrollButton" .. category, AltManager.main_frame, "UIPanelButtonTemplate")
			if not AltManager.main_frame.unrollButtons[category] then
				unrollButton:SetText(row.name .. " >")
				unrollButton:SetSize(100, 25)
				unrollButton.name = row.name			
			end
			unrollButton:Show()
			--unrollButton:SetFrameStrata("MEDIUM")
			unrollButton:SetPoint("TOPRIGHT", AltManager.main_frame, "TOPLEFT", 0, -(buttonrows*25) + 30)

			if row.disable_drawLayer then
				unrollButton:DisableDrawLayer("BACKGROUND")
			end
			
			unrollButton:SetScript("OnClick", function()
				AltManager:RollUpAll(category)
				AltManager:Unroll(unrollButton, nil, row.name, category) 
			end)

			AltManager.main_frame.unrollButtons[category] = unrollButton
			buttonrows = buttonrows + 1
		elseif AltManager.main_frame.unrollButtons[category] and not AltManager.db.global.currentCategories[category].enabled then
			AltManager.main_frame.unrollButtons[category]:Hide()
		end
	end
end

function AltManager:UpdateMainFrameSize(widthOnly, heightOnly)
	local alts = #self.account.pages[self.db.global.currentPage]
	local width = ((alts * self.db.global.options.other.widthPerAlt) + 120) - min((self.db.global.options.other.widthPerAlt - self.db.global.options.buttons.buttonWidth), 20)
	local height = self.main_frame.height + ((self.main_frame.openUnrollRows and (self.main_frame.openUnrollRows * 20) + 30) or 0)

	if widthOnly then
		self.main_frame:SetWidth(max(width + self.db.global.options.other.labelOffset + 3, 240))
	elseif heightOnly then
		self.main_frame:SetHeight(height)
	else
		self.main_frame:SetSize(max(width + self.db.global.options.other.labelOffset + 3, 240), height)
	end
	self.main_frame.lowest_point = -self.main_frame.height
end

function AltManager:UpdateMenu(widthOnly, heightOnly)

	self.main_frame.unrollButtons = self.main_frame.unrollButtons or {}
	self.main_frame.optionsButton:SetShown(self.db.global.options.showOptionsButton)
	self.main_frame.guildAttunmentButton:SetShown(self.db.global.options.showGuildAttunementButton)

	local numRows = UpdateOrCreateMenu("general", self.main_frame.label_column)
	updateOrCreateUnrollButtons()

	self.main_frame.height = max(numRows * 20, max(0,(self.numCategories-2) * 30))
	self.main_frame.numRows = numRows
	self:UpdateMainFrameSize(widthOnly, heightOnly)
end

function AltManager:UpdateAnchorsAndSize(category, widthOnly, heightOnly, updateMenu)
	if category == "general" then
		if updateMenu then
			local numRows = UpdateOrCreateMenu("general", self.main_frame.label_column)
			self.main_frame.height = max(numRows * 20, max(0,(self.numCategories-2) * 30))
		end

		self:UpdateAltAnchors("general", self.main_frame.label_column)
		self:PopulateStrings(self.db.global.currentPage, "general")
	end

	if self.main_frame.openUnroll then
		local unrollCategory = self.main_frame.openUnroll
		self:Unroll(AltManager.main_frame.unrollButtons[unrollCategory], "closed", nil, unrollCategory)
	end

	self:UpdateMainFrameSize(widthOnly, heightOnly)
end

function AltManager:CreateMenuButtons()
	-------------------
	-- Close button
	self.main_frame.closeButton = CreateFrame("Button", nil, self.main_frame, "UIPanelCloseButton");
	self.main_frame.closeButton:ClearAllPoints()
	self.main_frame.closeButton:SetPoint("BOTTOMRIGHT", self.main_frame, "TOPRIGHT", -3, -2);
	self.main_frame.closeButton:SetScript("OnClick", function() AltManager:HideInterface(); end);

	-------------------
	-- Options Button
	self.main_frame.optionsButton = CreateFrame("Button", nil, self.main_frame, "UIPanelButtonTemplate")
	self.main_frame.optionsButton:SetSize(80, 20)
	self.main_frame.optionsButton:ClearAllPoints()
	self.main_frame.optionsButton:SetPoint("TOPRIGHT", self.main_frame, "BOTTOMRIGHT", -3, -4)
	self.main_frame.optionsButton:SetFrameLevel(10)
	self.main_frame.optionsButton:SetScript("OnClick", function()
		AltManager:OpenOptions()
	end)
	self.main_frame.optionsButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine("Open Options")
		GameTooltip:Show()
	end)
	self.main_frame.optionsButton:SetScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)
	self.main_frame.optionsButton:SetText("Options")
	--self.main_frame.optionsButton:SetFrameStrata("HIGH")

	-------------------
	-- Guild Attunment Button
	self.main_frame.guildAttunmentButton = CreateFrame("Button", nil, self.main_frame, "UIPanelButtonTemplate")
	self.main_frame.guildAttunmentButton:SetSize(80, 20)
	self.main_frame.guildAttunmentButton:ClearAllPoints()
	self.main_frame.guildAttunmentButton:SetPoint("RIGHT", self.main_frame.optionsButton, "LEFT", -3, 0)
	self.main_frame.guildAttunmentButton:SetText("Attunement")
	--self.main_frame.guildAttunmentButton:SetFrameStrata("HIGH")
	self.main_frame.guildAttunmentButton:SetScript("OnClick", AltManager.ShowGuildAttunements)
end

function AltManager:CreateFractionString(numCompleted, numDesired, abbreviateCompleted, abbreviateDesired)
	if not numCompleted or not numDesired then return end
	local color = (numDesired and numCompleted >= numDesired and "00ff00") or (numCompleted > 0 and "ff9900") or "ffffff"

	numCompleted = abbreviateCompleted and AbbreviateNumbers(numCompleted) or AbbreviateLargeNumbers(numCompleted)
	numDesired = abbreviateDesired and AbbreviateNumbers(numDesired) or numDesired

	return string.format("|cff%s%s|r/%s", color, numCompleted, numDesired)
end

function AltManager:CreateContractString(contractInfo)
	if not contractInfo then return end
	local days, hours, minutes = self:timeToDaysHoursMinutes(contractInfo.expirationTime)

	return string.format("%s - %s", contractInfo.faction, self:CreateTimeString(days, hours, minutes))
end

function AltManager:CreateTimeString(days, hours, minutes)
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

function AltManager:HideInterface()
	if self.db.global.options.unrollOnHide then
		self:RollUpAll()
	end

	if self.db.global.options.savePosition then
		local frame = self.main_frame
		local position = self.db.global.position
		position.point, position.relativeTo, position.relativePoint, position.xOffset, position.yOffset = frame:GetPoint()
	end
	self.main_frame:Hide();
end

function AltManager:ShowInterface()
	self.myGUID = self.myGUID or UnitGUID("player")
	self:UpdateEverything()

	self.main_frame:Show()
	self:UpdateMenu()
	self:PopulateStrings(self.db.global.currentPage, "general")
	if self.main_frame.openUnroll then
		local unrollCategory = self.main_frame.openUnroll
		self:Unroll(self.main_frame.unrollButtons[unrollCategory], "closed", nil, unrollCategory)
	end
end

function AltManager:MakeTopBottomTextures(frame)
	if frame.bottomPanel == nil then
		frame.bottomPanel = frame:CreateTexture(nil)
	end
	if frame.topPanel == nil then
		frame.topPanel = CreateFrame("Frame", "AltManagerTopPanel", frame)
		frame.topPanelTex = frame.topPanel:CreateTexture(nil, "BACKGROUND")
		frame.topPanelTex:SetAllPoints();
		frame.topPanelTex:SetDrawLayer("ARTWORK", -5)
		frame.topPanelTex:SetColorTexture(0, 0, 0, 0.85)
		
		frame.topPanelString = frame.topPanel:CreateFontString()
		frame.topPanelString:SetFont("Fonts\\FRIZQT__.TTF", 18)
		frame.topPanelString:SetTextColor(1, 1, 1, 1)
		frame.topPanelString:SetJustifyH("CENTER")
		frame.topPanelString:SetJustifyV("CENTER")
		frame.topPanelString:SetWidth(260)
		frame.topPanelString:SetHeight(20)
		frame.topPanelString:SetText("Martins Alt Manager")
		frame.topPanelString:ClearAllPoints()
		frame.topPanelString:SetPoint("CENTER", frame.topPanel, "CENTER", 0, 0)
		frame.topPanelString:Show()
		
	end
	frame.bottomPanel:SetColorTexture(0, 0, 0, 0.85)
	frame.bottomPanel:ClearAllPoints()
	frame.bottomPanel:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0)
	frame.bottomPanel:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, 0)
	frame.bottomPanel:SetHeight(30)
	frame.bottomPanel:SetDrawLayer("ARTWORK", 7)

	frame.topPanel:ClearAllPoints()
	frame.topPanel:SetHeight(30)
	frame.topPanel:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 0)
	frame.topPanel:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 0)

	frame:SetMovable(true)
	frame.topPanel:EnableMouse(true)
	frame.topPanel:RegisterForDrag("LeftButton")
	frame.topPanel:SetScript("OnDragStart", function(self,button)
		frame:SetMovable(true)
        frame:StartMoving()
    end);
	frame.topPanel:SetScript("OnDragStop", function(self,button)
        frame:StopMovingOrSizing()
		frame:SetMovable(false)
    end)
end

function AltManager:GetNextWeeklyResetTime()
	local weeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
	return weeklyReset
end

function AltManager:GetNextDailyResetTime()
	local dailyReset = C_DateAndTime.GetSecondsUntilDailyReset()
	return dailyReset
end

function AltManager:GetNextBiWeeklyResetTime()
	local weeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
	if weeklyReset then
		return (weeklyReset >= 302400 and weeklyReset - 302400 or weeklyReset)
	end
end

function AltManager:SaveCompletionData(key, isComplete, guid)
	if not guid then return end

	if self.columns[key] then
		local completionData = self.db.global.completionData[key]

		if not completionData[guid] then
			completionData[guid] = isComplete or nil
			completionData.numCompleted = (completionData.numCompleted or 0) + (isComplete and 1 or 0)
		end
	end
end

function AltManager:PostKeysIntoChat(channel)
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
		if alt_data.level ~= "?" then
			local key = string.format("[%s: %s+%d]",alt_data.name, alt_data.dungeon, alt_data.level)
			tinsert(keys, key)
		end
	end

	local msg = table.concat(keys, " ")
	SendChatMessage(msg, chatChannel)
end

AltManager.functions = {
	quest = function(alt_data, column)
		if not alt_data.questInfo then return "-" end
		if not column.questType or not column.visibility or not column.key then return "-" end

		local required = column.required or 1
		if type(column.required) == "function" then
			required = column.required(alt_data)
		end

		AltManager:Debug(alt_data.name)
		local questInfo = alt_data.questInfo[column.questType] and alt_data.questInfo[column.questType][column.visibility] and alt_data.questInfo[column.questType][column.visibility][column.key]
		if not questInfo then return AltManager:CreateQuestString(0, required) or "-" end

		return AltManager:CreateQuestString(questInfo, required, (column.plus) or (column.plus == nil and required == 1)) or "-"
	end,
	currency = function(alt_data, column)
		if not alt_data.currencyInfo then return "-" end
		local currencyInfo = alt_data.currencyInfo[column.id]

		return AltManager:CreateCurrencyString(currencyInfo, column.abbCurrent, column.abbMax, column.hideMax) or "-"
	end,
	faction = function(alt_data, column)
		if not alt_data.factions then return "-" end

		local factionInfo = alt_data.factions[column.id]
		if not factionInfo then return "-" end

		return AltManager:CreateFactionString(factionInfo) or "-"
	end,
}