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

-- Made by: Qooning - Tarren Mill, 2017

local sizey = 200;
local per_alt_x = 120;
local min_x_size = 240;
local min_level = GetMaxLevelForExpansionLevel(GetExpansionLevel());
local locale = GetLocale()

local VERSION = "9.0.18.1"

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
			daily = true,
			weekly = true,
			reputation = true,
			raid = true,
			sanctum = true,
			general = true,
			savePosition = false,
			showOptionsButton = true,
			customCategories = {
				general = {
					childOrder = {characterName = 0, ilevel = 0.5}, 
					childs = {"characterName", "ilevel"}, 
					order = 0, 
					hideToggle = true, 
					name = "General", 
				},
				['**'] = {childOrder = {}, childs = {}, info = {}}
			},
		},
		currentCallings = {},
		position = {},
		version = VERSION,
	},
}

local altManagerEvents = {
	"BAG_UPDATE_DELAYED",
	"CURRENCY_DISPLAY_UPDATE",
	"COVENANT_CALLINGS_UPDATED",
	"QUEST_TURNED_IN",
	"LFG_COMPLETION_REWARD",
	"UPDATE_BATTLEFIELD_STATUS",
	"UPDATE_FACTION",
	"UPDATE_INSTANCE_INFO",
	"COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED",
	"UPDATE_UI_WIDGET",
	"WEEKLY_REWARDS_UPDATE",
	"COVENANT_SANCTUM_INTERACTION_STARTED",
	"CHALLENGE_MODE_COMPLETED",
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

function AltManager:OnInitialize()
  -- init databroker
	self.db = LibStub("AceDB-3.0"):New("MartinsAltManagerDB", defaultDB, true);
	self:LoadOptions()
	self.spairs = spairs

  	LibIcon:Register("MartinsAltManager", AltManagerLDB, self.db.profile.minimap)
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
  	if self.db.global.options["savePosition"] then
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
				AltManager:OnLogin()
				FrameUtil.RegisterFrameForEvents(main_frame, altManagerEvents)
			end
		end
		
		if AltManager.addon_loaded then
			if event == "QUEST_TURNED_IN" then
				AltManager:UpdateQuest(...)
			elseif event == "COVENANT_CALLINGS_UPDATED" then
				AltManager:UpdateCallings(...)
			elseif event == "CURRENCY_DISPLAY_UPDATE" then
				AltManager:UpdateCurrency(...)
				AltManager:UpdateTorghast()
			elseif (event == "BAG_UPDATE_DELAYED" or event == "LFG_COMPLETION_REWARD" or event == "UPDATE_BATTLEFIELD_STATUS") then
				AltManager:CollectData();
			elseif event == "UPDATE_FACTION" then
				AltManager:UpdateFactions()
			elseif event == "UPDATE_INSTANCE_INFO" then
				AltManager:UpdateInstanceInfo()
				AltManager:UpdateVaultInfo()
			elseif event == "UPDATE_UI_WIDGET" then
				AltManager:UpdateJailerInfo(...)
			elseif event == "WEEKLY_REWARDS_UPDATE" or event == "CHALLENGE_MODE_COMPLETED" then
				AltManager:UpdateVaultInfo()
			elseif event == "COVENANT_SANCTUM_INTERACTION_ENDED" then
				AltManager:UpdateSanctumBuildings()
			end
		end
	end)

	self.db.global.currentCategories = self.db.global.custom and self.db.global.options.customCategories or self.db.global.options.defaultCategories
end

function AltManager:OnEnable()
	self.addon_loaded = true
end

function AltManager:OnDisable()
	self.addon_loaded = false
end

function AltManager:getGUID()
	self.myGUID = self.myGUID or UnitGUID("player")
	return self.myGUID
end

local function CreateMoneyButtonNormalTexture(button, iconWidth, buttonWidth)
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

local function Tooltip_OnLeave(self)
	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil
	end
end

function AltManager.isBlacklisted(guid)
	return AltManager.db.global.blacklist[guid]
end

function AltManager.validateData()
	local guid = AltManager:getGUID()
	if not guid then return end
	if AltManager.isBlacklisted() then return end

	local db = AltManager.db.global
	local char_table = db.data[guid]

	return char_table
end

function AltManager:HandleChatCommand(cmd)
	local rqst, arg, arg2, arg3 = strsplit(' ', cmd)
	if rqst == "purge" then
		AltManager:Purge()
	elseif rqst == "remove" then
		AltManager:RemoveCharacterByName(arg, arg2)
	elseif rqst == "minimap" then
		self.db.profile.minimap.hide = not self.db.profile.minimap.hide
		if (self.db.profile.minimap.hide) then
			LibIcon:Hide("MartinsAltManager")
		else
			LibIcon:Show("MartinsAltManager")
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

-- because of guid...
function AltManager:OnLogin()
	self:ValidateReset();

	local db = self.db.global
	local guid = self:getGUID()
	local level = UnitLevel("player")

	if guid and not db.data[guid] then
		if not self.isBlacklisted(guid) and not (level < min_level) then
			db.data[guid] = {}
			db.alts = db.alts + 1
		end
	end
	self:UpdateEverything()
	
	local alts = db.alts;
	
	self.main_frame.background:SetAllPoints();
	
	-- Create menus
	self:CreateMenu(alts);
	self:MakeTopBottomTextures(self.main_frame);
	self:MakeBorder(self.main_frame, 5);
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
		local char_table = db.data[keyset[alt]];
		local expiry = char_table.expires or 0
		local daily = char_table.daily or 0


		--modernize
		if type(char_table.currencyInfo) ~= "table" then
			char_table.currencyInfo = {}
		end

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
	self.db = self.db:ResetDB()
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

	local _, ilevel = GetAverageItemLevel()
	char_table.ilevel = ilevel

	local gold = BreakUpLargeNumbers(floor(GetMoney() / (COPPER_PER_SILVER * SILVER_PER_GOLD)))
	char_table.gold = gold


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
	local contracts = {[311457] = "CoH",[311458] = "Ascended",[311460] = "UA",[311459] = "WH"}
	for spellId, faction in pairs(contracts) do
		local info = {GetPlayerAuraBySpellID(spellId)}
		if info[1] then
			contract = {faction = faction, duration = info[5], expirationTime = time() + (info[6] - GetTime())}
			break
		end
	end
	char_table.contract = contract


	-- IDs
	local nathria_lfr_ids = {2096, 2092, 2091, 2090}
	local nathria_lfr = 0
	
	for _, v in pairs(nathria_lfr_ids) do
		local _, killed = GetLFGDungeonNumEncounters(v)
		nathria_lfr = nathria_lfr + killed
	end
	char_table.nathria_lfr = nathrya_lfr


	-- Covenant
	local covenant = C_Covenants.GetActiveCovenantID()
	char_table.covenant = covenant > 0 and covenant

	local renown = C_CovenantSanctumUI.GetRenownLevel()
	char_table.renown = renown

	local callingsUnlocked = C_CovenantCallings.AreCallingsUnlocked()
	char_table.callingsUnlocked = callingsUnlocked
	
	char_table.expires = self:GetNextWeeklyResetTime()
	char_table.daily = self:GetNextDailyResetTime()
end



function AltManager:PopulateStrings()
	local font_height = 20;
	local db = self.db.global;
	
	local keyset = self:Keyset()
	
	self.main_frame.alt_columns = self.main_frame.alt_columns or {};
	
	local options = self.db.global.currentCategories.general.childOrder
	local alt = 0
	for alt_guid, alt_data in self.spairs(db.data, function(t, a, b)  return (t[a].ilevel or 0) > (t[b].ilevel or 0) end) do
		if not self.db.global.blacklist[alt_guid] then
			alt = alt + 1
			-- create the frame to which all the fontstrings anchor
			local anchor_frame = self.main_frame.alt_columns[alt] or CreateFrame("Button", nil, self.main_frame);
			if not self.main_frame.alt_columns[alt] then
				self.main_frame.alt_columns[alt] = anchor_frame;
			end
			anchor_frame:SetPoint("TOPLEFT", self.main_frame.label_column, "TOPLEFT", per_alt_x * alt, -1);
			anchor_frame:SetSize(per_alt_x, font_height);
			-- init table for fontstring storage
			self.main_frame.alt_columns[alt].label_columns = self.main_frame.alt_columns[alt].label_columns or {};
			local label_columns = self.main_frame.alt_columns[alt].label_columns;
			-- create / fill fontstrings
			local i = 1;
			local columns = self.db.global.currentCategories.general
			for j, column_iden in ipairs(columns.childs) do
				-- only display data with values
				local column = self.columns[column_iden]
				if column and type(column.data) == "function" and options[column_iden] then
					local current_row = label_columns[column_iden] or self:CreateFontFrame(self.main_frame, per_alt_x, column.font_height or font_height, anchor_frame, -(i - 1) * font_height, column.data(alt_data), "CENTER", nil, column.option);
					current_row:SetPoint("TOPLEFT", anchor_frame, "TOPLEFT", 0, -(i - 1) * font_height);
					current_row:Show()

					if current_row.texture then
						current_row.texture:Show()
					end

					-- insert it into storage if just created
					if not self.main_frame.alt_columns[alt].label_columns[column_iden] then
						self.main_frame.alt_columns[alt].label_columns[column_iden] = current_row;
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

			for column_iden, row in pairs(label_columns) do
				if not options[column_iden] then
					if row.texture then
						row.texture:Hide()
					end
					row:Hide()
				end
			end
		end
	end
end

function AltManager:Unroll(button, my_rows, default_state, name, category)
	self.unroll_state = self.unroll_state or {}
	self.unroll_state[name] = self.unroll_state[name] or {}
	local lu = self.unroll_state[name]
	lu.state = default_state or lu.state or "closed";

	lu.unroll_frame = lu.unroll_frame or CreateFrame("Button", nil, self.main_frame);
	lu.unroll_frame:SetPoint("TOPLEFT",self.main_frame, "TOPLEFT", 0, self.main_frame.lowest_point - 30);

	if lu.state == "closed" then
		-- do unroll
					
		local font_height = 20
		-- create the rows for the unroll
		lu.labels = lu.labels or {}
		local numRows = 0
		local options = self.db.global.currentCategories[category].childOrder
		for i, row_identifier in ipairs(my_rows) do
			if options[row_identifier] then
				local row = self.columns[row_identifier]
				if row.label then
					-- parent, 			x_size,    height, 	    relative_to,     y_offset,           label,          justify, x_offset, option
					local label_row = lu.labels[row_identifier] or self:CreateFontFrame(lu.unroll_frame, per_alt_x, font_height, lu.unroll_frame, -(numRows*font_height), row.label, "RIGHT", 0)
					label_row:Show()
					label_row:SetPoint("TOPLEFT", lu.unroll_frame, "TOPLEFT", 0, -(numRows*font_height));
					lu.labels[row_identifier] = label_row
				else
					lu.labels[row_identifier] = true
				end
				numRows = numRows + 1
			end
		end

		for row_iden, label in pairs(lu.labels) do
			if not options[row_iden] then
				label:Hide()
				lu.labels[row_iden] = nil
			end
		end
					
		-- populate it for alts
		lu.alt_columns = lu.alt_columns or {};
		local alt = 0
		local db = self.db.global;
		for alt_guid, alt_data in self.spairs(db.data, function(t, a, b) return (t[a].ilevel or 0) > (t[b].ilevel or 0) end) do
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
				for j, column_iden in ipairs(my_rows) do
					if lu.labels[column_iden] then
						local column = self.columns[column_iden]
						local current_row = label_columns[column_iden] or self:CreateFontFrame(lu.unroll_frame, per_alt_x, column.font_height or font_height, anchor_frame, (-(i - 1) * font_height), column.data(alt_data), "CENTER", 0);
						current_row:Show()
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
					end
				end

				for column_iden, label in pairs(lu.alt_columns[alt].label_columns) do
					if not lu.labels[column_iden] then
						label:Hide()
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
			self.main_frame:SetHeight(self.main_frame.height + (numRows * font_height) + 30)
			self.main_frame.optionsButton:SetPoint("TOPRIGHT", self.main_frame, "TOPRIGHT", -3, -self.main_frame.height-4)
			self.main_frame.background:SetAllPoints()

			button:SetText(name .. " <<")

			lu.state = "open"
		end
	else
		self:RollUp(button, name)	
	end
end

function AltManager:RollUp(button, name)
	local db = self.db.global
	self.main_frame:SetHeight(self.main_frame.height)
	self.main_frame.background:SetAllPoints();
	self.main_frame.optionsButton:SetPoint("TOPRIGHT", self.main_frame, "BOTTOMRIGHT", -3, -4)
	self.unroll_state[name].unroll_frame:Hide();

	if self.unroll_state[name].unroll_frame.unroll_texture then
		self.unroll_state[name].unroll_frame.unroll_texture:Hide()
	end

	self.main_frame.unroll_buttons[name]:SetText(name .. " >");
	self.unroll_state[name].state = "closed";
end

function AltManager:UpdateMenu()
	local alts = self.db.global.alts
	if not self.main_frame.label_column then self:CreateMenu(alts) end
	self.main_frame.label_column:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", 0, 0);

	if not self.db.global.options.showOptionsButton then
		self.main_frame.optionsButton:Hide()
	else
		self.main_frame.optionsButton:Show()
	end

	local i = 0
	local font_height = 20
	
	local label_column = self.main_frame.label_column
	local options = self.db.global.currentCategories.general.childOrder
	local general = self.db.global.currentCategories.general.childs

	for j, row_iden in ipairs(general) do
		local row = self.columns[row_iden]
		if row.label then
			-- parent, x_size, height, relative_to, y_offset, label, justify, x_offset, option
			local label_row = self.main_frame.label_rows[row_iden] or self:CreateFontFrame(self.main_frame, per_alt_x, font_height, label_column, -i*font_height, row.label, "RIGHT", 0)
			self.main_frame.label_rows[row_iden] = label_row

			label_row:SetPoint("TOPLEFT", label_column, "TOPLEFT", 0, -i*font_height)
			label_row:Show()

			i = i + 1
		elseif row.fakeLabel then
			i = i + 1
		end
	end

	for row_iden, label in pairs(self.main_frame.label_rows) do
		if not options[row_iden] then
			label:Hide()
		end
	end

	local buttonrows = {}
	local categories = self.db.global.currentCategories
	for category, row in self.spairs(categories, function(t, a, b) return t[a].order < t[b].order end) do
		if category ~= "general" and self.db.global.options[category] then
			local bp = row.button_pos
			local order = row.order
			local w,h = row.w_size or 100, row.h_size or 25
			-- create a button that will unroll it
			local unroll_button = self.main_frame.unroll_buttons[row.name] or CreateFrame("Button", addonName .. "UnrollButton" .. category, self.main_frame, "UIPanelButtonTemplate")
			unroll_button:Show()
			unroll_button:SetText(row.name .. " >");
			unroll_button:SetFrameStrata("HIGH");
			--unroll_button:SetFrameLevel(self.main_frame:GetFrameLevel() - 1);
			unroll_button:SetSize(w, h)
			unroll_button:SetPoint("TOPRIGHT", self.main_frame, "TOPLEFT", 0, -(#buttonrows*h) + 30)
			
			if row.disable_drawLayer then
				unroll_button:DisableDrawLayer("BACKGROUND")
			end
			
			unroll_button:SetScript("OnClick", function() 
				for x,r in ipairs(buttonrows) do
					local r_i, ro, u_b = r[1], r[2], r[3]
					if r_i ~= category then
						AltManager:Unroll(u_b, nil, "open", ro.name, category)
					end
				end
				
				AltManager:Unroll(unroll_button, row.childs, nil, row.name, category) 
			end)
			table.insert(buttonrows,{category, row, unroll_button})
			self.main_frame.unroll_buttons[row.name] = unroll_button
		elseif self.main_frame.unroll_buttons[row.name] and not self.db.global.options[category] then
			self.main_frame.unroll_buttons[row.name]:Hide()
		end
	end

	self.main_frame.height = max(i*font_height, max(0,(self.numCategories-2)*30))
	self.main_frame:SetSize(max((alts + 1) * per_alt_x, min_x_size), self.main_frame.height);
	self.main_frame.lowest_point = -self.main_frame.height;
	self.main_frame.numRows = i
end

function AltManager:CreateMenu(alts)
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
	self.main_frame.optionsButton:SetFrameStrata("HIGH")
	--createExpandButton()

	-------------------
	-- create labels and unrolls
	self.main_frame.unroll_buttons = self.main_frame.unroll_buttons or {}
	self.main_frame.label_rows = self.main_frame.label_rows or {}
	local font_height = 20
	local label_column = self.main_frame.label_column or CreateFrame("Button", nil, self.main_frame);
	self.main_frame.label_column = self.main_frame.label_column or label_column
	label_column:SetSize(per_alt_x, sizey)

	local i = 0;
	local buttonrows = {}
	local general = self.db.global.currentCategories.general.childs
	local categories = self.db.global.currentCategories

	for j, row_iden in ipairs(general) do
		local row = self.columns[row_iden]
		if row.label then
			local label_row = self:CreateFontFrame(self.main_frame, per_alt_x, font_height, label_column, -i*font_height, row.label, "RIGHT", 0);
			self.main_frame.label_rows[row_iden] = label_row
			i = i + 1
		elseif row.fakeLabel then
			i = i + 1
		end
	end

	for category, row in self.spairs(categories, function(t, a, b) return t[a].order < t[b].order end) do
		if category ~= "general" and self.db.global.options[category] then
			local bp = row.button_pos
			local order = row.order
			local w,h = row.w_size or 100, row.h_size or 25
			-- create a button that will unroll it
			local unroll_button = self.main_frame.unroll_buttons[row.unroll_name] or CreateFrame("Button", addonName .. "UnrollButton" .. category, self.main_frame, "UIPanelButtonTemplate");
			unroll_button:SetText(row.name .. " >");
			unroll_button:SetFrameStrata("HIGH");
			--unroll_button:SetFrameLevel(self.main_frame:GetFrameLevel() - 1);
			unroll_button:SetSize(w, h);
			unroll_button:SetPoint("TOPRIGHT", self.main_frame, "TOPLEFT", 0, -(#buttonrows*h) + 30)
			
			if row.disable_drawLayer then
				unroll_button:DisableDrawLayer("BACKGROUND")
			end
			
			unroll_button:SetScript("OnClick", function() 
				for x,r in ipairs(buttonrows) do
					local r_i, ro, u_b = r[1], r[2], r[3]
					if r_i ~= category then
						AltManager:Unroll(u_b, nil, "open", ro.name, category)
					end
				end
				
				AltManager:Unroll(unroll_button, row.childs, nil, row.name, category) 
			end)
			table.insert(buttonrows,{category, row, unroll_button})
			self.main_frame.unroll_buttons[row.name] = unroll_button
		end
	end

	self.main_frame.height = max(i*font_height, max(0,(self.numCategories-2)*30))
	self.main_frame:SetSize(max((alts + 1) * per_alt_x, min_x_size), self.main_frame.height);
	self.main_frame.lowest_point = -self.main_frame.height;
	self.main_frame.numRows = i
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

function AltManager:HideInterface()
	if type(self.unroll_state) == "table" then
		for name, tbl in pairs(self.unroll_state) do
			if tbl.state == "open" then self:RollUp(tbl.unroll_frame, name) end
		end
	end

	if self.db.global.options["savePosition"] then
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
	self:PopulateStrings()
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
		frame.topPanelString:SetFont("Fonts\\FRIZQT__.TTF", 18)
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
	frame.bottomPanel:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0)
	frame.bottomPanel:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, 0)
	frame.bottomPanel:SetHeight(30);
	frame.bottomPanel:SetDrawLayer("ARTWORK", 7);

	frame.topPanel:ClearAllPoints();
	frame.topPanel:SetHeight(30);
	frame.topPanel:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 0)
	frame.topPanel:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 0)

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