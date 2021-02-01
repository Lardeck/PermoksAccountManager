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
			AltManager:ShowOptions()
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine("|cfff49b42Martins Alt Manager|r")
		tt:AddLine("|cffffffffLeft-click|r to open MartinsAltManager")
		tt:AddLine("|cffffffffRight-click|r to open options")
		tt:AddLine("Type '/mam minimap' to hide the Minimap Button!")
	end
})
local icon = LibStub("LibDBIcon-1.0")
local LibQTip = LibStub("LibQTip-1.0")

-- Made by: Qooning - Tarren Mill, 2017

local sizey = 200;
local per_alt_x = 120;
local min_x_size = 360;
local min_level = GetMaxLevelForExpansionLevel(GetExpansionLevel());
local locale = GetLocale()

local VERSION = "9.0.17.0"

local defaultDB = {
    profile = {
      	minimap = {
        	hide = false,
    	},
	},
	global = {
		blacklist = {},
		data = {},
		alts = 0,
		options = {
			['**'] = {
				['**'] = {
					enabled = true,
				},
			},
			daily_unroll = {
				conductor = {
					enabled = false,
				},
				sanctum = {
					enabled = false,
				},
				['**'] = {
					enabled = true,
				}
			}
		},
		currentCallings = {},
		position = {},
		version = VERSION,
	},
}

function AltManager:OnInitialize()
  -- init databroker
	self.db = LibStub("AceDB-3.0"):New("MartinsAltManagerDB", defaultDB);

  	icon:Register("MartinsAltManager", AltManagerLDB, self.db.profile.minimap)
  	AltManager:RegisterChatCommand('mam', 'HandleChatCommand')
  	AltManager:RegisterChatCommand('alts', 'HandleChatCommand')

	local main_frame = CreateFrame("frame", "AltManagerFrame", UIParent);
	AltManager.main_frame = main_frame;
	main_frame:SetFrameStrata("MEDIUM");
	main_frame.background = main_frame:CreateTexture(nil, "BACKGROUND");
	main_frame.background:SetAllPoints();
	main_frame.background:SetDrawLayer("ARTWORK", 1);
	main_frame.background:SetColorTexture(0, 0, 0, 0.7);
	
	main_frame.scan_tooltip = CreateFrame('GameTooltip', 'DepletedTooltipScan', UIParent, 'GameTooltipTemplate');
	
	main_frame:ClearAllPoints();
  	if self.db.global.options["savePosition"].enabled then
		local position = self.db.global.position
		main_frame:SetPoint(position.point or "TOP", WorldFrame, position.relativePoint or "TOP", position.xOffset or 0, position.yOffset or -300);
	else
		main_frame:SetPoint("TOP", WorldFrame, "TOP", 0, -300)
	end
	main_frame:Hide();
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")

	main_frame:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			local isLogin, isReload = ...

			if isLogin or isReload then
				AltManager:OnLogin();

				main_frame:RegisterEvent("BAG_UPDATE_DELAYED");
				main_frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
				main_frame:RegisterEvent("COVENANT_CALLINGS_UPDATED")
				main_frame:RegisterEvent("QUEST_TURNED_IN")
				main_frame:RegisterEvent("LFG_COMPLETION_REWARD")
				main_frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
				main_frame:RegisterEvent("UPDATE_FACTION")
				main_frame:RegisterEvent("UPDATE_INSTANCE_INFO")
				main_frame:RegisterEvent("COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED")
				main_frame:RegisterEvent("UPDATE_UI_WIDGET")
				main_frame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
				main_frame:RegisterEvent("COVENANT_SANCTUM_INTERACTION_STARTED")

				--UIParentLoadAddOn("Blizzard_CovenantSanctum")
			end
		end
		
		if AltManager.addon_loaded then
			if event == "QUEST_TURNED_IN" then
				AltManager:UpdateQuest(...)
			elseif event == "COVENANT_CALLINGS_UPDATED" then
				AltManager:UpdateCallings(...)
			elseif event == "CURRENCY_DISPLAY_UPDATE" then
				AltManager:UpdateCurrency(...)
			elseif (event == "BAG_UPDATE_DELAYED" or event == "LFG_COMPLETION_REWARD" or event == "UPDATE_BATTLEFIELD_STATUS") then
				AltManager:CollectData();
			elseif event == "UPDATE_FACTION" then
				AltManager:UpdateFactions()
			elseif event == "UPDATE_INSTANCE_INFO" then
				AltManager:UpdateInstanceInfo()
			elseif event == "UPDATE_UI_WIDGET" then
				AltManager:UpdateJailerInfo(...)
			elseif event == "WEEKLY_REWARDS_UPDATE" then
				AltManager:UpdateVaultInfo()
			elseif event == "COVENANT_SANCTUM_INTERACTION_ENDED" then
				AltManager:UpdateSanctumBuildings()
			end
		end
	end)
	
	-- Show Frame
end

function AltManager:OnEnable()
	self.addon_loaded = true
end

function AltManager:OnDisable()
	self.addon_loaded = false
end

function AltManager:getGUID()
	return self.myGUID or UnitGUID("player")
end

local function CreateMoneyButtonNormalTexture (button, iconWidth, buttonWidth)
	local texture = button:CreateTexture()
	texture:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
	texture:SetWidth(iconWidth)
	texture:SetHeight(iconWidth)
	texture:SetPoint("LEFT", button, "CENTER", button:GetTextWidth()/2, 1)
	button:SetNormalTexture(texture)
	
	return texture
end

local function get_key_for_value( t, value )
  for k,v in pairs(t) do
    if v==value then return k end
  end
  
  return nil
end

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
AltManager.spairs = spairs

local function toggleTotalFrame(button)
	if not AltManager.totalFrame then
		local totalFrame = CreateFrame("frame", "AltManagerTotalFrame", AltManager.main_frame, "BackdropTemplate")
		AltManager.totalFrame = totalFrame
		totalFrame:SetFrameStrata("MEDIUM")
		totalFrame.background = totalFrame:CreateTexture(nil, "BACKGROUND")
		totalFrame.background:SetAllPoints()
		totalFrame.background:SetDrawLayer("ARTWORK", 1)
		totalFrame.background:SetColorTexture(0, 0, 0, 0.7)
		totalFrame:SetSize(100, sizey)
		totalFrame:ClearAllPoints()
		totalFrame:SetPoint("TOPLEFT", AltManager.main_frame, "TOPRIGHT")

		local bottomPanel = totalFrame:CreateTexture()
		totalFrame.bottomPanel = bottomPanel
		bottomPanel:SetColorTexture(0, 0, 0, 0.85)
		bottomPanel:SetPoint("TOPRIGHT", totalFrame, "BOTTOMRIGHT", 0, 0)
		bottomPanel:SetSize(totalFrame:GetWidth(), 30)
		bottomPanel:SetDrawLayer("ARTWORK", 7)

		local topPanel = totalFrame:CreateTexture()
		totalFrame.topPanel = topPanel
		topPanel:SetColorTexture(0, 0, 0, 0.85)
		topPanel:SetPoint("BOTTOMLEFT", totalFrame, "TOPLEFT", 0, 0)
		topPanel:SetSize(totalFrame:GetWidth(), 30)
		topPanel:SetDrawLayer("ARTWORK", 7)

		local seperator = totalFrame:CreateTexture()
		totalFrame.seperator = seperator
		seperator:SetColorTexture(1, 1, 1, 0.85)
		seperator:SetPoint("TOPLEFT", AltManager.main_frame, "TOPRIGHT", -1)
		seperator:SetSize(2, sizey)
		seperator:SetDrawLayer("ARTWORK", 7)

		local title = totalFrame:CreateFontString()
		totalFrame.title = title
		title:SetFont("Fonts\\FRIZQT__.TTF", 20)
		title:SetTextColor(1, 1, 1, 1)
		title:SetJustifyH("CENTER")
		title:SetJustifyV("CENTER")
		title:SetWidth(topPanel:GetWidth())
		title:SetHeight(20)
		title:SetText("Total")
		title:SetPoint("CENTER", topPanel, "CENTER", 0, 0)

		local ULx,ULy,LLx,LLy,URx,URy,LRx,LRy = button:GetNormalTexture():GetTexCoord()
		button:GetNormalTexture():SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy)
		button:GetPushedTexture():SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy)

		totalFrame:Show()
	else
		AltManager.totalFrame:SetShown(not AltManager.totalFrame:IsShown())

		local ULx,ULy,LLx,LLy,URx,URy,LRx,LRy = button:GetNormalTexture():GetTexCoord()
		button:GetNormalTexture():SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy)
		button:GetPushedTexture():SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy)
	end
end

local function createExpandButton()
	local self = AltManager
	self.main_frame.totalButton = CreateFrame("Button", nil, self.main_frame)
	self.main_frame.totalButton:SetPoint("TOPRIGHT", self.main_frame, "BOTTOMRIGHT", -10, 2)
	self.main_frame.totalButton:SetSize(32, 32)
	self.main_frame.totalButton:SetText("TEST")
	self.main_frame.totalButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Expandbutton-Up")
	self.main_frame.totalButton:GetNormalTexture():SetRotation(math.rad(90))
	self.main_frame.totalButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-Expandbutton-Down")
	self.main_frame.totalButton:GetPushedTexture():SetRotation(math.rad(90))
	self.main_frame.totalButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	self.main_frame.totalButton:SetScript("OnClick", toggleTotalFrame)
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

	local db = AltManager.db.global
	local char_table = db.data[guid]
	if not char_table then return end;

	if db.blacklist[guid] then return end

	return char_table
end

function AltManager:HandleChatCommand(cmd)
	local rqst, arg, arg2, arg3 = strsplit(' ', cmd)
	if rqst == "purge" then
		AltManager:Purge();
	elseif rqst == "remove" then
		AltManager:RemoveCharacterByName(arg, arg2)
	elseif rqst == "minimap" then
		self.db.profile.minimap.hide = not self.db.profile.minimap.hide
		if (self.db.profile.minimap.hide) then
			icon:Hide("MartinsAltManager")
		else
			icon:Show("MartinsAltManager")
		end
	elseif rqst == "blacklist" then
		AltManager:Blacklist(arg, arg2, arg3)
	elseif rqst == "help" then
		print([[|cfff49b42AltManager Commands:|r
|cfff49b42/mam|r - Open the AltManager
|cfff49b42/mam remove name|r - Remove character by name
|cfff49b42/mam minimap|r - Show/Hide the minimap button
|cfff49b42/mam blacklist a/add/r/remove|r - a/add or r/remove a character to/from the blacklist
|cfff49b42/mam help|r - Show this help text]])
	elseif rqst == "version" then
		print("|cfff49b42MartinsAltManager Version:|r", VERSION)
	else
		if AltManagerFrame:IsShown() then
			AltManager:HideInterface()
		else
			AltManager:ShowInterface()
		end
	end
end

-- Will probably switch to AceDBConfig in an upcoming version
local function CreateOptionsMenu(frame, panel)
	local title = panel.title or frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	panel.title = title
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(panel.name)

    local savePosition = panel["savePosition"] or CreateFrame("CheckButton", nil, frame, "InterfaceOptionsCheckButtonTemplate")
    panel["savePosition"] = savePosition
    savePosition:RegisterForClicks("LeftButtonUp")
    savePosition:SetChecked(AltManager.db.global.options["savePosition"].enabled)
    savePosition:SetScript("OnClick", function(button) AltManager.db.global.options["savePosition"].enabled = button:GetChecked() end)
    savePosition:SetPoint("TOPLEFT", title, "TOPLEFT", 0, -25)
    savePosition.Text:SetText("Save Position Between Reloads")

    local rows = AltManager.columns_table
    local numFrames = 0
    for row_identifier, row in AltManager.spairs(rows, function(t, a, b) return t[a].order < t[b].order end) do
    	if row.data ~= "unroll" and row.enabled and not row.hideOption then
	    	local rowOption = panel[row_identifier] or CreateFrame("CheckButton", nil, frame, "InterfaceOptionsCheckButtonTemplate")
	    	panel[row_identifier] = rowOption
	    	rowOption:RegisterForClicks("LeftButtonUp")
	    	rowOption:SetChecked(AltManager.db.global.options[row_identifier].enabled)
	    	rowOption:SetScript("OnClick", function(button)	AltManager.db.global.options[row_identifier].enabled = button:GetChecked() end)

	    	local numColumn = numFrames % 3
	    	local numRow = floor(numFrames/3) + 1
	    	rowOption:SetPoint("TOPLEFT", savePosition, "TOPLEFT", (numColumn * 150), numRow * (-25))
	    	rowOption.Text:SetText(row.label)
	    	numFrames = numFrames + 1
	    end
    end
end

function AltManager:CreateMainOptions()
	local panel = CreateFrame("Frame", addonName .. "ConfigFrame", UIParent)
	AltManager.panel = panel
	panel.name = addonName
	panel:SetScript("OnShow", function(frame) CreateOptionsMenu(frame, panel) end)
	panel:Hide()

	InterfaceOptions_AddCategory(panel)
end

function AltManager:ShowOptions()
	InterfaceOptionsFrame_OpenToCategory(AltManager.panel)
	InterfaceOptionsFrame_OpenToCategory(AltManager.panel)
end

-- because of guid...
function AltManager:OnLogin()
	self:ValidateReset();

	local db = self.db.global
	local guid = UnitGUID("player")
	local level = UnitLevel("player")

	if guid and not db.data[guid] and not db.blacklist[guid] and not (level < min_level) then
		db.data[guid] = {}
		db.alts = db.alts + 1
	end
	
	self:UpdateEverything()
	
	local alts = db.alts;
	
	self.main_frame.background:SetAllPoints();
	
	-- Create menus
	
	self:CreateMenu(alts);
	self:MakeTopBottomTextures(self.main_frame);
	self:MakeBorder(self.main_frame, 5);

	self:CreateMainOptions()
	for unroll, info in self.spairs(self.columns_table, function(t, a, b) return t[a].order < t[b].order end) do
		if info.data == "unroll" then
			self:CreateOptions(info.unroll_name, unroll)
		end
	end

	AltManager.myGUID = UnitGUID("player")
end

function AltManager:CreateFontFrame(parent, x_size, height, relative_to, y_offset, label, justify, x_offset, option)
	if not label then return end
	local f = CreateFrame("Button", nil, parent);
	f:SetSize(x_size, height);
	f:SetNormalFontObject(GameFontNormal)
	local font = f:GetNormalFontObject();
	font:SetTextColor(1,1,1,1)
	f:SetNormalFontObject(font)
	f:SetText(label .. ":")
	f:SetPoint("TOPLEFT", relative_to, "TOPLEFT", x_offset or x_size, y_offset);
	f:GetFontString():SetFont(f:GetFontString():GetFont(),11)
	f:GetFontString():SetJustifyH(justify);
	f:GetFontString():SetJustifyV("CENTER");
	f:SetPushedTextOffset(0, 0);
	f:GetFontString():SetWidth(120)
	f:GetFontString():SetHeight(20)
	f:SetFrameStrata("MEDIUM")
	
	if option and option == "gold" then
		local texture = CreateMoneyButtonNormalTexture(f, 14, x_size)
		f.texture = texture
		texture:SetTexCoord(0, 0.25, 0, 1)
	end

	return f;
end

function AltManager:timeToDaysHoursMinutes(expirationTime)
	local remaining = expirationTime - time()
	local days = floor(remaining / 86400)
	local hours = floor((remaining/3600) - (days * 24))
	local minutes = floor((remaining / 60) - (days * 1440) - (hours * 60))

	return days, hours, minutes
end

function AltManager:Keyset()
	local keyset = {}
	local db = self.db.global

	for k in pairs(db.data) do
		table.insert(keyset, k)
	end

	return keyset
end

function AltManager:ValidateReset()
	local db = self.db.global
	local keyset = self:Keyset()
	
	for alt = 1, db.alts do
		local expiry = db.data[keyset[alt]].expires or 0
		local daily = db.data[keyset[alt]].daily or 0
		local hunt = db.data[keyset[alt]].huntReset or 0
		
		local char_table = db.data[keyset[alt]];
		if time() > expiry then
			-- M0/Raids
			if char_table.instanceInfo then
				char_table.instanceInfo.raids = {}
				char_table.instanceInfo.dungeons = {}
			end

			-- Torghast
			if char_table.torghastInfo then
				wipe(char_table.torghastInfo)
				char_table.torghastInfo["PLEASE"] = 0
				char_table.torghastInfo["LOGIN"] = 0
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

			-- M+
			char_table.dungeon = "Unknown";
			char_table.level = "?";

			-- Weekly Quests
			if char_table.questInfo and char_table.questInfo.weekly then
				for key, quests in pairs(char_table.questInfo.weekly) do
					if not quests then break end
					for questID in pairs(quests) do
						char_table.questInfo.weekly[key][questID] = false
					end
				end
			end

			-- Reset
			char_table.expires = self:GetNextWeeklyResetTime();
		end

		if time() > daily then

			-- Callings
			if char_table.callingsUnlocked and char_table.callingInfo and char_table.callingInfo.numCallings and char_table.callingInfo.numCallings < 3 then
				char_table.callingInfo.numCallings = char_table.callingInfo.numCallings + 1
				char_table.callingInfo[#char_table.callingInfo + 1] = self:GetNextDailyResetTime() + (86400*2)
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
				for key, quests in pairs(char_table.questInfo.daily) do
					if not quests then break end
					for questID in pairs(quests) do
						char_table.questInfo.daily[key][questID] = false
					end
				end
			end
			
			-- Etc
			char_table.daily_heroic = nil
			char_table.rnd_bg = nil

			-- Reset
			char_table.daily = self:GetNextDailyResetTime();
		end
	end
end

function AltManager:Purge()
	MartinsAltManagerDB = nil
	self.db = LibStub("AceDB-3.0"):New("MartinsAltManagerDB", defaultDB);
	print("[|cfff49b42MartinsAltManager|r] Please reload your interface to update the displayed info.")
end

function AltManager:FindCharacterByName(name, num, func, blacklist)
	local db = self.db.global;
	local indices = {}
	local found = {}

	if not blacklist  or (blacklist == "add" or blacklist == "a") then
		for guid, data in pairs(db.data) do
			if db.data[guid].name == name then
				indices[#indices+1] = guid
			end
		end
	elseif blacklist == "remove" or blacklist == "r" then
		for guid, char_name in pairs(self.db.global.blacklist) do
			if char_name == name then
				indices[#indicies+1] = guid
			end
		end
	end

	if #indices > 1 and not num then
		print("Found " .. (#indices) .. " characters by the name of " .. name)
		for i=1, #indices do
			print(i .. " " .. db.data[indices[i]].name .. ((db.data[indices[i]].realm and "-"..db.data[indices[i]].realm) or (" "..select(7,GetPlayerInfoByGUID(indices[i])))))
		end
		print("Please specify the character. E.g. \"/mam " .. func .. " " .. name .. " 1\" to" .. (blacklist and " blacklist " or "remove") ..  "the first one.")
	elseif #indices == 1 or num then
		return indices[num or 1]
	elseif #indices == 0 then
		if name then
			print("Could not find the character \"" .. name .. "\"")
		else
			print("Please specify a name.")
		end
	end
end

function AltManager:Blacklist(arg, name, num)
	local valid_args = {["add"] = true, ["a"] = true, ["remove"] = true, ["r"] = true, ["p"] = true, ["print"] = true}
	if not arg then
		print("Please specify if you want to a/add or r/remove a character to/from the blacklist or p/print it.")
		return 
	elseif not valid_args[arg] then
		print("\"" .. arg .. "\" is not a valid argument.")
		print("|cfff49b42Valid arguments:|r a/add, r/remove, p/print.")
		return
	end

	local db = self.db.global
	local blacklist = db.blacklist


	if arg == "p" or arg == "print" then
		print("|cfff49b42MartinsAltManager|r Blacklist:")
		local list = {}
		for guid, name in pairs(blacklist) do
			local color = db.data[guid].class and CreateColor(GetClassColor(db.data[guid].class))
			local coloredName = color and ((db.data[guid].realm and color:WrapTextInColorCode(name .."-"..db.data[guid].realm)) or color:WrapTextInColorCode(name)) or name
			tinsert(list, coloredName)
		end
		print(table.concat(list, ", "))
	else
		local num = num and assert(tonumber(num), "The second argument ist not a number")
		local guid = self:FindCharacterByName(name, num, "blacklist " .. arg, arg)

		if guid then
			local check = ((arg == "add" or arg == "a") and name) or ((arg == "remove" or arg == "r") and nil)
			blacklist[guid] = check

			if check then
				db.alts = db.alts - 1
			end
			print("[|cfff49b42MartinsAltManager|r] Please reload your interface to update the displayed info.")
		end
	end
end

function AltManager:RemoveCharacterByName(name, num)
	local db = self.db.global;
	local num = num and assert(tonumber(num), "The second argument ist not a number")

	local guid = self:FindCharacterByName(name, num, "remove")
	
	if guid then
		db.alts = db.alts - 1
		db.data[guid] = nil
		print("[|cfff49b42MartinsAltManager|r] Please reload your interface to update the displayed info.")
	end
	-- things wont be redrawn
end

function AltManager:UpdateEverything()
	CovenantCalling_CheckCallings()
	self:UpdateInstanceInfo()
	self:UpdateAllCurrencies()
	self:UpdateSanctumBuildings()
	self:UpdateAllQuests()
	self:UpdateFactions()
	self:UpdateTorghast()
	self:UpdateVaultInfo()
	self:CollectData()
end

function AltManager:CollectData()
	local guid = self:getGUID()
	if not guid then return end
	
	-- Basic Char Information
	local name, realm = UnitFullName('player')
	local _, class = UnitClass('player')
	local faction = UnitFactionGroup("player")
	local level = UnitLevel('player')
	local _, ilevel = GetAverageItemLevel()
	local gold = BreakUpLargeNumbers(floor(GetMoney() / (COPPER_PER_SILVER * SILVER_PER_GOLD)))
	local covenant = C_Covenants.GetActiveCovenantID()

	if level < min_level then return end
	
	local char_table = self.validateData()
	if not char_table then return end

	-- Keystone
	local ownedKeystone = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
	local keystone_found = false
	local dungeon = nil
	local level = nil
	
	if ownedKeystone then
		dungeon = self.keys[ownedKeystone]
		level = C_MythicPlus.GetOwnedKeystoneLevel()
		keystone_found = true
	end
	
	if not keystone_found then
		dungeon = "Unknown";
		level = "?"
	end

	--LFGRewardsFrame_UpdateFrame(LFDQueueFrameRandomScrollFrameChildFrame, 1671, LFDQueueFrameBackground)
	--local daily_heroic
	--local done, money = GetLFGDungeonRewards(1671);
	--if done and money > 0 then daily_heroic = true end
	
	--RequestPVPRewards()
	--RequestRandomBattlegroundInstanceInfo()
	--local rnd_bg = select(3,C_PvP.GetRandomBGRewards());

	-- Contract
	local contract = nil
	local contracts = {[311457] = "CoH",[311458] = "Ascended",[311460] = "UA",[311459] = "WH"}
	for spellId, faction in pairs(contracts) do
		local info = {GetPlayerAuraBySpellID(spellId)}
		if info[1] then
			contract = {faction = faction, duration = info[5], expirationTime = time() + (info[6] - GetTime())}
			break
		end
	end

	-- dungeons/raids
	local nathria_lfr_ids = {2096, 2092, 2091, 2090}
	local nathria_lfr = 0
	
	for _, v in pairs(nathria_lfr_ids) do
		local _, killed = GetLFGDungeonNumEncounters(v)
		nathria_lfr = nathria_lfr + killed
	end
	
	local renown = C_CovenantSanctumUI.GetRenownLevel()
	local callingsUnlocked = C_CovenantCallings.AreCallingsUnlocked()
	-- store data into a table

	char_table.guid = guid
	char_table.name = name
	char_table.realm = realm
	char_table.class = class
	char_table.faction = faction;
	char_table.ilevel = ilevel
	char_table.gold = gold
	char_table.covenant = covenant > 0 and covenant
	char_table.renown = renown
	char_table.contract = contract
	char_table.callingsUnlocked = callingsUnlocked

	char_table.dungeon = dungeon
	char_table.level = level
	
	char_table.nathria = nathria
	char_table.nathria_lfr = nathrya_lfr
	char_table.mythicDungeons = mythicDungeons
	
	char_table.daily_heroic = daily_heroic
	char_table.rnd_bg = rnd_bg
	char_table.expires = self:GetNextWeeklyResetTime()
	char_table.daily = self:GetNextDailyResetTime()

	return char_table;
end

function AltManager:UpdateJailerInfo(widgetInfo)
	if not widgetInfo or not self.jailerWidgets[widgetInfo.widgetID] then return end
	local char_table = self.validateData()
	if not char_table then return end

	local widgetInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo(widgetInfo.widgetID)

	if widgetInfo and widgetInfo.shownState == 1 then
		local barValue, barMin, barMax = widgetInfo.progressVal, widgetInfo.progressMin, widgetInfo.progressMax
   		local stage = floor(barValue/1000)

		char_table.jailerInfo = {stage = stage, threat = barValue - (stage*1000)}
	end	
end

function AltManager:PopulateStrings()
	local font_height = 20;
	local db = self.db.global;
	
	local keyset = self:Keyset()
	
	self.main_frame.alt_columns = self.main_frame.alt_columns or {};
	
	local options = self.db.global.options
	local alt = 0
	for alt_guid, alt_data in self.spairs(db.data, function(t, a, b)  return t[a].ilevel > t[b].ilevel end) do
		if not self.db.global.blacklist[alt_guid] then
			alt = alt + 1
			-- create the frame to which all the fontstrings anchor
			local anchor_frame = self.main_frame.alt_columns[alt] or CreateFrame("Button", nil, self.main_frame);
			if not self.main_frame.alt_columns[alt] then
				self.main_frame.alt_columns[alt] = anchor_frame;
			end
			anchor_frame:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", per_alt_x * alt, -1);
			anchor_frame:SetSize(per_alt_x, font_height);
			-- init table for fontstring storage
			self.main_frame.alt_columns[alt].label_columns = self.main_frame.alt_columns[alt].label_columns or {};
			local label_columns = self.main_frame.alt_columns[alt].label_columns;
			-- create / fill fontstrings
			local i = 1;
			for column_iden, column in self.spairs(self.columns_table, function(t, a, b) return t[a].order < t[b].order end) do
				-- only display data with values
				if type(column.data) == "function" and column.enabled and column.enabled(options, column_iden) then
					local current_row = label_columns[i] or self:CreateFontFrame(self.main_frame, per_alt_x, column.font_height or font_height, anchor_frame, -(i - 1) * font_height, column.data(alt_data), "CENTER", nil, column.option);
					-- insert it into storage if just created
					if not self.main_frame.alt_columns[alt].label_columns[i] then
						self.main_frame.alt_columns[alt].label_columns[i] = current_row;
					end

					if column.tooltip then
						current_row:SetScript("OnEnter", function(self) column.tooltip(self, alt_data) end)
						current_row:SetScript("OnLeave", Tooltip_OnLeave)
					end

					if column.color then
						local color = column.color(alt_data)
						current_row:GetFontString():SetTextColor(color.r, color.g, color.b, 1);
					end
					current_row:SetText(column.data(alt_data))
					if column.font then
						current_row:GetFontString():SetFont(column.font, 8)
						--current_row:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 14)
					end
					if column.justify then
						current_row:GetFontString():SetJustifyV(column.justify);
					end
					i = i + 1
				end
			end
		end
	end
	
end

function AltManager:Unroll(button, my_rows, default_state, name, option, icon)
	self.unroll_state = self.unroll_state or {}
	self.unroll_state[name] = self.unroll_state[name] or {}
	local lu = self.unroll_state[name]
	lu.state = default_state or lu.state or "closed";
	lu.icon = lu.icon or icon

	--frame.bottomPanel:SetColorTexture(0, 0, 0, 0.85);
	--frame.bottomPanel:ClearAllPoints();
	--frame.bottomPanel:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0);
	--frame.bottomPanel:SetSize(frame:GetWidth(), 30);
	--frame.bottomPanel:SetDrawLayer("ARTWORK", 7);
	lu.unroll_frame = lu.unroll_frame or CreateFrame("Button", nil, self.main_frame);
	lu.unroll_frame:SetPoint("TOPLEFT",self.main_frame, "TOPLEFT", per_alt_x, self.main_frame.lowest_point - 30);

	if lu.state == "closed" then
		-- do unroll
					
		local font_height = 20
		-- create the rows for the unroll
		lu.labels = lu.labels or {}
		local numRows = 0
		local prev_identifier
		for row_identifier, row, next_identifier in self.spairs(my_rows, function(t, a, b) return t[a].order < t[b].order end) do
			if row.enabled and row.enabled(option, row_identifier) then
				if row.label then
					-- parent, 			x_size,    height, 	    relative_to,     y_offset,           label,          justify, x_offset, option
					local label_row = lu.labels[row_identifier] or self:CreateFontFrame(lu.unroll_frame, per_alt_x, font_height, lu.unroll_frame, -(numRows*font_height), row.label, "RIGHT", 0);
					label_row:SetPoint("TOPLEFT", lu.unroll_frame, "TOPLEFT", 0, -(numRows*font_height));
					lu.labels[row_identifier] = label_row
				else
					lu.labels[row_identifier] = true
				end
				numRows = numRows + 1
				prev_identifier = row_identifier
			elseif lu.labels[row_identifier] then
				lu.labels[row_identifier]:Hide()
				lu.labels[row_identifier] = nil
			end
		end
					
		-- populate it for alts
		lu.alt_columns = lu.alt_columns or {};
		local alt = 0
		local db = self.db.global;
		for alt_guid, alt_data in self.spairs(db.data, function(t, a, b) return t[a].ilevel > t[b]. ilevel end) do
			if not self.db.global.blacklist[alt_guid] then
				alt = alt + 1
				-- create the frame to which all the fontstrings anchor
				local anchor_frame = lu.alt_columns[alt] or CreateFrame("Button", nil, lu.unroll_frame);
				if not lu.alt_columns[alt] then
					lu.alt_columns[alt] = anchor_frame;
				end
				anchor_frame:SetPoint("TOPLEFT", lu.unroll_frame, "TOPLEFT", per_alt_x * alt, 0);
				anchor_frame:SetSize(per_alt_x, font_height);
				anchor_frame:SetFrameStrata("LOW")

				-- init table for fontstring storage
				lu.alt_columns[alt].label_columns = lu.alt_columns[alt].label_columns or {};
				local label_columns = lu.alt_columns[alt].label_columns;
				-- create / fill fontstrings
				local i = 1;
				for column_iden, column in self.spairs(my_rows, function(t, a, b) return t[a].order < t[b].order end) do
					if lu.labels[column_iden] then
						local current_row = label_columns[column_iden] or self:CreateFontFrame(lu.unroll_frame, per_alt_x, column.font_height or font_height, anchor_frame, (-(i - 1) * font_height), column.data(alt_data), "CENTER", 0);
						current_row:SetPoint("TOPLEFT", anchor_frame, "TOPLEFT", 0, (-(i - 1) * font_height));

						if column.tooltip then
							current_row:SetScript("OnEnter", function(self) column.tooltip(self, alt_data) end)
							current_row:SetScript("OnLeave", Tooltip_OnLeave)
						end
						-- insert it into storage if just created
						if not lu.alt_columns[alt].label_columns[column_iden] then
							lu.alt_columns[alt].label_columns[column_iden] = current_row;
						end

						current_row:SetText(column.data(alt_data))
						i = i + 1
					elseif lu.alt_columns[alt].label_columns[column_iden] then
						lu.alt_columns[alt].label_columns[column_iden]:Hide()
					end
				end
			end
		end
					
		if numRows > 0 then
			local texture = lu.unroll_frame.unroll_texture or lu.unroll_frame:CreateTexture()
			lu.unroll_frame.unroll_texture = texture
			texture:SetColorTexture(0, 0, 0, 0.85)
			texture:ClearAllPoints()
			texture:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", 0, self.main_frame.lowest_point)
			texture:SetSize(self.main_frame:GetWidth(), 30)
			texture:SetDrawLayer("ARTWORK", 7)


			lu.unroll_frame:SetSize(per_alt_x, numRows * font_height);
			lu.unroll_frame:Show();
			lu.unroll_frame.unroll_texture:Show()

			local beforeTop = self.main_frame:GetTop()
			self.main_frame:SetSize(max((alt+2) * per_alt_x, min_x_size), self.main_frame.height + (numRows * font_height) + 30);
			self.main_frame.background:SetAllPoints();

			if not icon then
				button:SetText(name .. " <<");
			else
				button:SetText(icon)
				button:SetNormalTexture("Interface\\AddOns\\MartinsAltManager\\textures\\normalTexture.blp")
			end
			
			--self.main_frame:SetPoint("CENTER", WorldFrame, "CENTER", xoffset, yoffset);
			lu.state = "open";
		end
	else
		self:RollUp(button, name, icon)	
	end
end

function AltManager:RollUp(button, name, icon)
	local db = self.db.global
	self.main_frame:SetSize(max((db.alts + 2) * per_alt_x, min_x_size), self.main_frame.height);
	self.main_frame.background:SetAllPoints();
	self.unroll_state[name].unroll_frame:Hide();

	if self.unroll_state[name].unroll_frame.unroll_texture then
		self.unroll_state[name].unroll_frame.unroll_texture:Hide()
	end

	if not icon then
		self.main_frame.unroll_buttons[name]:SetText(name .. " >");
	else
		self.main_frame.unroll_buttons[name]:SetNormalTexture("")
	end
	self.unroll_state[name].state = "closed";
end

function AltManager:CreateMenu(alts)
	-- Close button
	self.main_frame.closeButton = CreateFrame("Button", nil, self.main_frame, "UIPanelCloseButton");
	self.main_frame.closeButton:ClearAllPoints()
	self.main_frame.closeButton:SetPoint("BOTTOMRIGHT", self.main_frame, "TOPRIGHT", -10, -2);
	self.main_frame.closeButton:SetScript("OnClick", function() AltManager:HideInterface(); end);
	--self.main_frame.closeButton:SetSize(32, h);

	self.main_frame.optionsButton = CreateFrame("Button", nil, self.main_frame, "UIPanelButtonTemplate")
	self.main_frame.optionsButton:SetSize(20, 18)
	self.main_frame.optionsButton:ClearAllPoints()
	self.main_frame.optionsButton:SetPoint("RIGHT", self.main_frame.closeButton, "LEFT", 0, 1)
	self.main_frame.optionsButton:SetScript("OnClick", function()
		AltManager:ShowOptions()
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
	self.main_frame.optionsButton:SetText("O")
	self.main_frame.optionsButton:SetFrameStrata("HIGH")
	--createExpandButton()

	-- create labels and unrolls
	self.main_frame.unroll_buttons = self.main_frame.unroll_buttons or {}
	local font_height = 20;
	local label_column = self.main_frame.label_column or CreateFrame("Button", nil, self.main_frame);
	self.main_frame.label_column = self.main_frame.label_column or label_column
	label_column:SetSize(per_alt_x, sizey);
	label_column:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", per_alt_x, 0);

	local i = 0;
	local buttonrows = {}
	local options = self.db.global.options
	for row_iden, row in self.spairs(self.columns_table, function(t, a, b) return t[a].order < t[b].order end) do
		if row.enabled and row.enabled(options, row_iden) then
			if row.label then
				local label_row = self:CreateFontFrame(self.main_frame, per_alt_x, font_height, label_column, -i*font_height, row.label, "RIGHT", 0);
				i = i + 1
			elseif row.fakeLabel then
				i = i + 1
			elseif row.data == "unroll" then
				local bp = row.button_pos
				local order = row.order
				local w,h = row.w_size or 100, row.h_size or 25
				-- create a button that will unroll it
				local unroll_button = self.main_frame.unroll_buttons[row.unroll_name] or CreateFrame("Button", addonName .. "UnrollButton" .. i, self.main_frame, "UIPanelButtonTemplate");
				table.insert(buttonrows,{row_iden, row, unroll_button})
				unroll_button:SetText(row.name);
				unroll_button:SetFrameStrata("HIGH");
				--unroll_button:SetFrameLevel(self.main_frame:GetFrameLevel() - 1);
				unroll_button:SetSize(w, h);
				unroll_button:SetPoint("BOTTOMRIGHT", self.main_frame, "TOPLEFT", per_alt_x, -(#buttonrows*h));
				
				if row.disable_drawLayer then
					unroll_button:DisableDrawLayer("BACKGROUND")
				end
				
				unroll_button:SetScript("OnClick", 
				function() 
					for x,r in ipairs(buttonrows) do
						local r_i, ro, u_b = r[1], r[2], r[3]
						if r_i ~= row_iden then
							ro.unroll_function(u_b, nil, "open", row)
						end
					end
					
					row.unroll_function(unroll_button, row.rows) 
				end);
				self.main_frame.unroll_buttons[row.unroll_name] = unroll_button
			end
		end
	end

	self.main_frame.height = i*font_height
	self.main_frame:SetSize(max((alts + 2) * per_alt_x, min_x_size), self.main_frame.height);
	self.main_frame.lowest_point = -self.main_frame.height;
	self.main_frame.numRows = i
end

function AltManager:CreateQuestString(questInfo, numDesired, replaceWithPlus)
	if not questInfo then return end
	local numCompleted = 0

	if type(questInfo) == "table" then
		for questID, questCompleted in pairs(questInfo) do
			numCompleted = questCompleted and numCompleted + 1 or numCompleted
		end
	elseif type(questInfo) == "number" then
		numCompleted = questInfo
	end

	local color = (numDesired and numCompleted >= numDesired and "00ff00") or (numCompleted > 0 and "ff9900") or "ffffff"

	if numDesired then
		if replaceWithPlus and numCompleted >= numDesired then
			return string.format("|cff%s+|r", color)
		else
			return string.format("|cff%s%d|r/%d", color, numCompleted, numDesired)
		end
	else
		return string.format("|cff%s%d|r", color, numCompleted)
	end
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
	local dayGreaterZero = days > 0
	local color = "ff0000"
	local firstNumber = hours
	local secondNumber = minutes
	local firstAbbreviation = "h"
	local secondAbbreviation = "m"

	if dayGreaterZero then
		color = "00ff00"
		firstNumber = days
		secondNumber = hours
		firstAbbreviation = "d"
		secondAbbreviation = "h"
	end

	return string.format("|cff%s%02d%s %02d%s|r", color, firstNumber, firstAbbreviation, secondNumber, secondAbbreviation)
end

function AltManager:CreateJailerString(jailerInfo)
	if not jailerInfo then return end

	return string.format("Stage %d - %d", jailerInfo.stage, jailerInfo.stage == 5 and 1000 or jailerInfo.threat)
end

function AltManager:HideInterface()
	if type(self.unroll_state) == "table" then
		for name, tbl in pairs(self.unroll_state) do
			if tbl.state == "open" then self:RollUp(tbl.unroll_frame, name, tbl.icon) end
		end
	end

	if self.db.global.options["savePosition"].enabled then
		local frame = self.main_frame
		local position = self.db.global.position
		position.point, position.relativeTo, position.relativePoint, position.xOffset, position.yOffset = frame:GetPoint()
	end
	self.main_frame:Hide();
end

function AltManager:ShowInterface()
	self.myGUID = self.myGUID or UnitGUID("player")
	self:UpdateEverything()

	self.main_frame:Show();
	self:PopulateStrings();
end

function AltManager:MakeTopBottomTextures(frame)
	if frame.bottomPanel == nil then
		frame.bottomPanel = frame:CreateTexture(nil);
	end
	if frame.topPanel == nil then
		frame.topPanel = CreateFrame("Frame", "AltManagerTopPanel", frame);
		frame.topPanelTex = frame.topPanel:CreateTexture(nil, "BACKGROUND");
		--frame.topPanelTex:ClearAllPoints();
		frame.topPanelTex:SetAllPoints();
		--frame.topPanelTex:SetSize(frame:GetWidth(), 30);
		frame.topPanelTex:SetDrawLayer("ARTWORK", -5);
		frame.topPanelTex:SetColorTexture(0, 0, 0, 0.85);
		
		frame.topPanelString = frame.topPanel:CreateFontString();
		frame.topPanelString:SetFont("Fonts\\FRIZQT__.TTF", 20)
		frame.topPanelString:SetTextColor(1, 1, 1, 1);
		frame.topPanelString:SetJustifyH("CENTER")
		frame.topPanelString:SetJustifyV("CENTER")
		frame.topPanelString:SetWidth(260)
		frame.topPanelString:SetHeight(20)
		frame.topPanelString:SetText("Martins Alt Manager");
		frame.topPanelString:ClearAllPoints();
		frame.topPanelString:SetPoint("CENTER", frame.topPanel, "CENTER", 0, 0);
		frame.topPanelString:Show();
		
	end
	frame.bottomPanel:SetColorTexture(0, 0, 0, 0.85);
	frame.bottomPanel:ClearAllPoints();
	frame.bottomPanel:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0);
	frame.bottomPanel:SetSize(frame:GetWidth(), 30);
	frame.bottomPanel:SetDrawLayer("ARTWORK", 7);

	frame.topPanel:ClearAllPoints();
	frame.topPanel:SetSize(frame:GetWidth(), 30);
	frame.topPanel:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 0);

	frame:SetMovable(true);
	frame.topPanel:EnableMouse(true);
	frame.topPanel:RegisterForDrag("LeftButton");
	frame.topPanel:SetScript("OnDragStart", function(self,button)
		frame:SetMovable(true);
        frame:StartMoving();
    end);
	frame.topPanel:SetScript("OnDragStop", function(self,button)
        frame:StopMovingOrSizing();
		frame:SetMovable(false);
    end);
end

function AltManager:MakeBorderPart(frame, x, y, xoff, yoff, part)
	if part == nil then
		part = frame:CreateTexture(nil);
	end
	part:SetTexture(0, 0, 0, 1);
	part:ClearAllPoints();
	part:SetPoint("TOPLEFT", frame, "TOPLEFT", xoff, yoff);
	part:SetSize(x, y);
	part:SetDrawLayer("ARTWORK", 7);
	return part;
end

function AltManager:MakeBorder(frame, size)
	if size == 0 then
		return;
	end
	frame.borderTop = self:MakeBorderPart(frame, frame:GetWidth(), size, 0, 0, frame.borderTop); -- top
	frame.borderLeft = self:MakeBorderPart(frame, size, frame:GetHeight(), 0, 0, frame.borderLeft); -- left
	frame.borderBottom = self:MakeBorderPart(frame, frame:GetWidth(), size, 0, -frame:GetHeight() + size, frame.borderBottom); -- bottom
	frame.borderRight = self:MakeBorderPart(frame, size, frame:GetHeight(), frame:GetWidth() - size, 0, frame.borderRight); -- right
end

-- shamelessly stolen from saved instances
function AltManager:GetNextWeeklyResetTime()
	local weeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
	return weeklyReset and time() + weeklyReset
end

function AltManager:GetNextDailyResetTime()
	local weeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
	return weeklyReset and time() + (weeklyReset % 86400)
end

function AltManager:GetNextHuntResetTime()
	local weeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
	if not weeklyReset then return end

	if weeklyReset <= (86400 * 3.5) then
		return time() + weeklyReset
	else
		return time() + (weeklyReset - (86400 * 3.5))
	end
end

function AltManager:TimeString(length)
	if length == 0 then
		return "Now";
	end
	if length < 3600 then
		return string.format("%d mins", length / 60);
	end
	if length < 86400 then
		return string.format("%d hrs %d mins", length / 3600, (length % 3600) / 60);
	end
	return string.format("%d days %d hrs", length / 86400, (length % 86400) / 3600);
end