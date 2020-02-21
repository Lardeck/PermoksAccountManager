local _, AltManager = ...

AltManager = LibStub("AceAddon-3.0"):NewAddon(AltManager, "MethodAltManager", "AceConsole-3.0", "AceEvent-3.0")

local AltManagerLDB = LibStub("LibDataBroker-1.1"):NewDataObject("MethodAltManager", {
	type = "data source",
	text = "Method Alt Manager",
	icon = "Interface\\Icons\\INV_Chest_Cloth_17",
	OnClick = function(self, button)
		if button == "LeftButton" then
			if AltManagerFrame:IsShown() then
				AltManager:HideInterface()
			else
				AltManager:ShowInterface()
			end
		elseif button == "RightButton" then
			
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine("|cfff49b42Method Alt Manager|r")
		tt:AddLine("|cffffffffLeft-click|r to open MethodAltManager")
		tt:AddLine("|cffffffffRight-click|r to open configuration (NYI)")
		tt:AddLine("Type '/mam minimap' to hide the Minimap Button!")
	end
})
local icon = LibStub("LibDBIcon-1.0")

-- Made by: Qooning - Tarren Mill <Method>, 2017

--local sizey = 200;
local sizey = 230;
local y_add = {["8.3"] = 380, ["8.2"] = 260, ["Daily"] = 120, ["Weekly"] = 160, ["Raids"] = 120,["Universal"] = 180,["Tank"] = 160,["Healer"] = 160,["DPS"] = 160}
local xoffset = 0;
local yoffset = 150;
local alpha = 1;
local addon = "MethodAltManager";
local numel = table.getn;

local per_alt_x = 120;

local min_x_size = 360;

local min_level = 120;
local name_label = "Name"
local mythic_done_label = "Highest M+ done"
local mythic_keystone_label = "Keystone"
local seals_owned_label = "Seals owned"
local seals_bought_label = "Seals obtained"
local resources_label = "War Resources"
local hoa_label = "Heart of Azeroth"
local island_label = "Island Expedition"
local heroic_label = "Daily Heroic"
local rndbg_label = "Random BG"
local emissary_label = "Active Emissaries"
local azerite_label = "Azerite Quests"
local arathi_label = "Arathi"
local darkshore_label = "Darkshore"

local VERSION = "1.3"					   
local dungeons = {[244] = "AD", 	-- Atal'dazar
				  [245] = "FH", 	-- Freehold
				  [246] = "TD", 	-- Tol Dagor
				  [247] = "ML", 	-- The Motherload
				  [248] = "WM", 	-- Waycrest Manor
				  [249] = "KR", 	-- Kings' Rest
				  [250] = "TOS",    -- Temple of Sethraliss
				  [251] = "UNDR",   -- The Underrot
				  [252] = "SOTS", 	-- Shrine of the Storm
				  [353] = "SIEGE",	-- Siege of Boralus
				  [369] = "YARD", -- Operation: Mechagon - Junkyard
				  [370] = "WORK", -- Operation: Mechagon - Workshop
				 }

local faction_abb = {
				  ["Champions of Azeroth"] = "CoA",
				  ["Talanji's Expedition"] = "TE",
				  ["Tortollan Seekers"] = "TS", 
				  ["Voldunai"] = "Vol",
				  ["Horde War Effort"] = "HB",
				  ["Zandalari Empire"] = "ZE",
				  ["Alliance War Effort"] = "7L",
				  ["Proudmoore Admiralty"] = "PA",
				  ["Storm's Wake"] = "StW", 
				  ["Order of Embers"] = "OoE",
				  ["The Unshackled"] = "TU",
				  ["Waveblade Ankoan"] = "WbA",
}

local trackedQuests = {
	[56969] = true,
	[57140] = "check",
	[58168] = "check",
	[58155] = "check",
	[58151] = "check",
	[58167] = "check",
	[58156] = "check",
	[57874] = "check",
	
	-- HORDE
	-- vim
	[55664] = "bodyguard_Horde",
	[55872] = "bodyguard_Horde",
	[55874] = "bodyguard_Horde",
	[55875] = "bodyguard_Horde",
	[55876] = "bodyguard_Horde",
	[55877] = "bodyguard_Horde",
	[55878] = "bodyguard_Horde",
	[55980] = "bodyguard_Horde",
	[55984] = "bodyguard_Horde",
	[56222] = "bodyguard_Horde",
	[56224] = "bodyguard_Horde",
	[56226] = "bodyguard_Horde",
	[56231] = "bodyguard_Horde",

	-- poen
	[55871] = "bodyguard_Horde",
	[55767] = "bodyguard_Horde",
	[56035] = "bodyguard_Horde",
	[56233] = "bodyguard_Horde",
	[56264] = "bodyguard_Horde",
	[56151] = "bodyguard_Horde",
	[55883] = "bodyguard_Horde",
	[55715] = "bodyguard_Horde",
	[56265] = "bodyguard_Horde",
	[55751] = "bodyguard_Horde",
	[55766] = "bodyguard_Horde",
	[55665] = "bodyguard_Horde",
	[56075] = "bodyguard_Horde",
	
	-- neri
	[56266] = "bodyguard_Horde",
	[55873] = "bodyguard_Horde",
	[56223] = "bodyguard_Horde",
	[55993] = "bodyguard_Horde",
	[56227] = "bodyguard_Horde",
	[55638] = "bodyguard_Horde",
	[56232] = "bodyguard_Horde",
	[55661] = "bodyguard_Horde",
	[55985] = "bodyguard_Horde",
	[56225] = "bodyguard_Horde",
	[55663] = "bodyguard_Horde",
	[55986] = "bodyguard_Horde",
	[55768] = "bodyguard_Horde",
	
	-- Alliance
	-- inowari
	[55633] = "bodyguard_Alliance",
	[55728] = "bodyguard_Alliance",
	[56153] = "bodyguard_Alliance",
	[56146] = "bodyguard_Alliance",
	[56001] = "bodyguard_Alliance",
	[55845] = "bodyguard_Alliance",
	[55637] = "bodyguard_Alliance",
	[55681] = "bodyguard_Alliance",
	[56154] = "bodyguard_Alliance",
	[55750] = "bodyguard_Alliance",
	[56160] = "bodyguard_Alliance",
	[55773] = "bodyguard_Alliance",
	[55771] = "bodyguard_Alliance",
	
	-- akana
	[54949] = "bodyguard_Alliance",
	[56150] = "bodyguard_Alliance",
	[55659] = "bodyguard_Alliance",
	[56149] = "bodyguard_Alliance",
	[55662] = "bodyguard_Alliance",
	[56000] = "bodyguard_Alliance",
	[56370] = "bodyguard_Alliance",
	[55776] = "bodyguard_Alliance",
	[55032] = "bodyguard_Alliance",
	[55775] = "bodyguard_Alliance",
	[55777] = "bodyguard_Alliance",
	[55701] = "bodyguard_Alliance",
	[56152] = "bodyguard_Alliance",
	
	-- ori
	[56002] = "bodyguard_Alliance",
	[55846] = "bodyguard_Alliance",
	[55770] = "bodyguard_Alliance",
	[55714] = "bodyguard_Alliance",
	[55636] = "bodyguard_Alliance",
	[56157] = "bodyguard_Alliance",
	[55683] = "bodyguard_Alliance",
	[56155] = "bodyguard_Alliance",
	[55774] = "bodyguard_Alliance",
	[55772] = "bodyguard_Alliance",
	[56158] = "bodyguard_Alliance",
	[56159] = "bodyguard_Alliance",
	[55625] = "bodyguard_Alliance",
}

function AltManager:OnInitialize()
  -- init databroker
	self.db = LibStub("AceDB-3.0"):New("MethodAltManagerDB", {
	    profile = {
	      	minimap = {
	        	hide = false,
	    	},
		},
	});

	if type(self.db.profile.blacklist) == "nil" then
		self.db.profile.blacklist = {}
	end

  	icon:Register("MethodAltManager", AltManagerLDB, self.db.profile.minimap)
  	AltManager:RegisterChatCommand('mam', 'HandleChatCommand')
  	AltManager:RegisterChatCommand('alts', 'HandleChatCommand')
end

function AltManager:OnEnable()
	MethodAltManagerDB = MethodAltManagerDB or self:InitDB();

	self.addon_loaded = true

end

function AltManager:OnDisable()

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
            return keys[i], t[keys[i]]
        end
    end
end

function AltManager:HandleChatCommand(cmd)
	local rqst, arg, arg2 = strsplit(' ', cmd)
	if rqst == "purge" then
		AltManager:Purge();
	elseif rqst == "remove" then
		AltManager:RemoveCharactersByName(arg)
	elseif rqst == "minimap" then
		self.db.profile.minimap.hide = not self.db.profile.minimap.hide
		if (self.db.profile.minimap.hide) then
			icon:Hide("MethodAltManager")
		else
			icon:Show("MethodAltManager")
		end
	elseif rqst == "blacklist" then
		self.db.profile.blacklist[arg2] = ((arg == "add" or arg == "a") and true) or ((arg == "remove" or arg == "r") and false)
		if arg == "add" then
			AltManager:RemoveCharactersByName(arg2)
		end
	elseif rqst == "help" then
		print([[|cfff49b42AltManager Commands:|r
|cfff49b42/mam|r - Open the AltManager
|cfff49b42/mam remove name|r - Remove character by name
|cfff49b42/mam minimap|r - Show/Hide the minimap button
|cfff49b42/mam blacklist a/add/r/remove|r - a/add or r/remove a character to/from the blacklist
|cfff49b42/mam help|r - Show this help text]])
	else
		if AltManagerFrame:IsShown() then
			AltManager:HideInterface()
		else
			AltManager:ShowInterface()
		end
	end
end

do
	local main_frame = CreateFrame("frame", "AltManagerFrame", UIParent);
	AltManager.main_frame = main_frame;
	main_frame:SetFrameStrata("MEDIUM");
	main_frame.background = main_frame:CreateTexture(nil, "BACKGROUND");
	main_frame.background:SetAllPoints();
	main_frame.background:SetDrawLayer("ARTWORK", 1);
	main_frame.background:SetColorTexture(0, 0, 0, 0.7);
	
	main_frame.scan_tooltip = CreateFrame('GameTooltip', 'DepletedTooltipScan', UIParent, 'GameTooltipTemplate');
	

	-- Set frame position
	main_frame:ClearAllPoints();
	main_frame:SetPoint("CENTER", UIParent, "CENTER", xoffset, yoffset);
	
	main_frame:RegisterEvent("PLAYER_LOGIN");
	main_frame:RegisterEvent("QUEST_TURNED_IN");
	main_frame:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED");
	main_frame:RegisterEvent("CHAT_MSG_CURRENCY");
	main_frame:RegisterEvent("LFG_COMPLETION_REWARD");
	main_frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	main_frame:RegisterEvent("AZERITE_ESSENCE_CHANGED");
	

	main_frame:SetScript("OnEvent", function(self, ...)
		local event, loaded = ...;
		if event == "PLAYER_LOGIN" then
			main_frame:RegisterEvent("BAG_UPDATE_DELAYED");
			main_frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
			AltManager:OnLogin();
		end
		if event == "AZERITE_ESSENCE_CHANGED" and AltManager.addon_loaded then
			local data = AltManager:UpdateEssences()
			AltManager:StoreData(data)
		end
		if event == "QUEST_TURNED_IN" and trackedQuests[loaded] then
			local data = AltManager:UpdateQuests(loaded)
			AltManager:StoreData(data)
		end
		if (event == "AZERITE_ITEM_EXPERIENCE_CHANGED" or event == "BAG_UPDATE_DELAYED" or event == "QUEST_TURNED_IN" or event == "CHAT_MSG_CURRENCY" or event == "CURRENCY_DISPLAY_UPDATE" or event == "LFG_COMPLETION_REWARD" or event == "UPDATE_BATTLEFIELD_STATUS") and AltManager.addon_loaded then
			local data = AltManager:CollectData();
			AltManager:StoreData(data);
		end
	end)
	
	-- Show Frame
	main_frame:Hide();
end

function AltManager:InitDB()
	local t = {};
	t.alts = 0;
	return t;
end

-- because of guid...
function AltManager:OnLogin()
	self:ValidateReset();
	
	local data1 = self:CollectData()
	self:StoreData(data1);
	local data2 = self:UpdateEssences()
	self:StoreData(data2)
		
	
	local alts = MethodAltManagerDB.alts;
	
	self.main_frame:SetSize(max((alts + 2) * per_alt_x, min_x_size), sizey);
	self.main_frame.background:SetAllPoints();
	
	-- Create menus
	
	AltManager:CreateMenu();
	AltManager:MakeTopBottomTextures(self.main_frame);
	AltManager:MakeBorder(self.main_frame, 5);
end

function AltManager:CreateFontFrame(parent, x_size, height, relative_to, y_offset, label, justify)
	local f = CreateFrame("Button", nil, parent);
	f:SetSize(x_size, height);
	f:SetNormalFontObject(GameFontNormal)
	local font = f:GetNormalFontObject();
	font:SetTextColor(1,1,1,1)
	f:SetNormalFontObject(font)
	f:SetText(label)
	f:SetPoint("TOPLEFT", relative_to, "TOPLEFT", x_size, y_offset);
	f:GetFontString():SetFont(f:GetFontString():GetFont(),11)
	f:GetFontString():SetJustifyH(justify);
	f:GetFontString():SetJustifyV("CENTER");
	f:SetPushedTextOffset(0, 0);
	f:GetFontString():SetWidth(120)
	f:GetFontString():SetHeight(20)
	
	return f;
end

function AltManager:Keyset()
	local keyset = {}
	if MethodAltManagerDB and MethodAltManagerDB.data then
		for k in pairs(MethodAltManagerDB.data) do
			table.insert(keyset, k)
		end
	end
	return keyset
end

function AltManager:ValidateReset()
	local db = MethodAltManagerDB
	if not db then return end;
	if not db.data then return end;
	
	local keyset = {}
	for k in pairs(db.data) do
		table.insert(keyset, k)
	end
	
	for alt = 1, db.alts do
		local expiry = db.data[keyset[alt]].expires or 0;
		local daily = db.data[keyset[alt]].daily or 0
		
		local char_table = db.data[keyset[alt]];
		if time() > expiry then
			-- reset this alt
			
			-- Quests
			char_table.seals_bought = 0;
			char_table.island_expedition = false;
			char_table.bfn_wq = nil;
			char_table.madivas_lab = false;
			char_table.bodyguard_items = {[57139] = false,[57141] = false,[57142] = false,[57143] = false};
			
			char_table.quests = char_table.quests or {};
			for questId, _ in pairs(char_table.quests) do
				char_table.quests[questId] = false;
			end
			
			-- M+
			char_table.dungeon = "Unknown";
			char_table.level = "?";
			char_table.highest_mplus = 0;
			
			-- M0
			char_table.m0 = {};
			char_table.moverall = 0
			char_table.ad = nil
			char_table.fh = nil
			char_table.kr = nil
			char_table.sots = nil
			char_table.siege = nil
			char_table.tos = nil
			char_table.tm = nil
			char_table.undr = nil
			char_table.td = nil
			char_table.wm = nil
			char_table.mechagon = nil
		
			-- Raids
			char_table.uldir_lfr = 0;
			char_table.uldir_normal = 0;
			char_table.uldir_heroic = 0;
			char_table.uldir_mythic = 0;
			char_table.bod_lfr = 0;
			char_table.bod_normal = 0;
			char_table.bod_heroic = 0;
			char_table.bod_mythic = 0;
			char_table.cos_lfr = 0;
			char_table.cos_normal = 0;
			char_table.cos_heroic = 0;
			char_table.cos_mythic = 0;
			char_table.ep_lfr = 0;
			char_table.ep_normal = 0;
			char_table.ep_heroic = 0;
			char_table.ep_mythic = 0;
			char_table.ny_lfr = 0;
			char_table.ny_normal = 0;
			char_table.ny_heroic = 0;
			char_table.ny_mythic = 0;
			
			-- Reset
			char_table.expires = self:GetNextWeeklyResetTime();
		elseif GetServerTime() > daily then
			-- reset this alt
			
			-- Quests
			char_table.quests = char_table.quests or {}

			if char_table.faction then
				char_table.quests["bodyguard_"..char_table.faction] = 0;
			else
				char_table.quests["bodyguard_"..UnitFactionGroup("player")] = 0;
			end

			for i, id in ipairs({57140, 58168, 58155, 58151, 58167, 58156, 57874}) do
				char_table.quests[id] = false
			end
			char_table.d_em = (char_table.d_em and char_table.d_em<3 and char_table.d_em+1) or char_table.d_em
			char_table.em1 = char_table.em2 and char_table.em2
			char_table.em2 = char_table.em3 and char_table.em3
			char_table.em3 = nil
			char_table.bfn = 0;
			char_table.mechagon_wq = nil;
			char_table.voeb_chests = 0
			char_table.voeb_events = 0
			char_table.voeb_rares = 0
			char_table.uldum_chests = 0
			char_table.uldum_events = 0
			char_table.uldum_rares = 0
			char_table.corrupted_creatures = 0

			-- Etc
			char_table.daily_heroic = nil
			char_table.rnd_bg = false

			-- Reset
			char_table.daily = self:GetNextDailyResetTime();
		end
		
	end
end

function AltManager:Purge()
	MethodAltManagerDB = self:InitDB();
end

function AltManager:RemoveCharactersByName(name)
	local db = MethodAltManagerDB;

	local indices = {};
	for guid, data in pairs(db.data) do
		if db.data[guid].name == name then
			indices[#indices+1] = guid
		end
	end

	db.alts = db.alts - #indices;
	for i = 1,#indices do
		db.data[indices[i]] = nil
	end

	print("Found " .. (#indices) .. " characters by the name of " .. name)
	print("Please reload ui to update the displayed info.")

	-- things wont be redrawn
end

function AltManager:StoreData(data)

	if not self.addon_loaded then
		return
	end
	

	-- This can happen shortly after logging in, the game doesn't know the characters guid yet
	if not data or not data.guid then
		return
	end
	
	local db = MethodAltManagerDB;
	local guid = data.guid;
	
	db.data = db.data or {};
	db.alts = db.alts or 0;
	
	local update = false;
	for k, v in pairs(db.data) do
		if k == guid then
			update = true;
		end
	end
	
	if not update then
		db.data[guid] = data;
		db.alts = db.alts + 1;
	else
		db.data[guid] = data;
	end
end

function AltManager:CollectData()
	-- Basic Char Information
	local name = UnitName('player')
	local _, class = UnitClass('player')
	local guid = UnitGUID('player')
	local faction = UnitFactionGroup("player")
	local level = UnitLevel('player')

	if level < min_level or self.db.profile.blacklist[name] then return end;
	
	-- Keystone
	local ownedKeystone = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
	local keystone_found = false
	local dungeon = nil
	local highest_mplus = 0
	local level = nil
	
	C_MythicPlus.RequestMapInfo()
	C_MythicPlus.RequestRewards()
	highest_mplus = C_MythicPlus.GetWeeklyChestRewardLevel()
	
	if ownedKeystone then
		dungeon = dungeons[ownedKeystone]
		level = C_MythicPlus.GetOwnedKeystoneLevel()
		keystone_found = true
	end
	
	if not keystone_found then
		dungeon = "Unknown";
		level = "?"
	end

	-- HoA Level
	local hoa_level = nil
	local neck = GetInventoryItemID("player", 2)
	if neck and neck == 158075 then
		local pos = C_AzeriteItem.FindActiveAzeriteItem()
		local cur, max = C_AzeriteItem.GetAzeriteItemXPInfo(pos)
		hoa_level = string.format("|cff00ff00%d|r - %2d%%",C_AzeriteItem.GetPowerLevel(pos),math.floor((cur/max)*100))
	end
	
	local essence = IsQuestFlaggedCompleted(57010)
	
	-- Island Expedition
	local island_expedition = false
	if IsQuestFlaggedCompleted(53435) then
		island_expedition = -1
	else
		local fulfilled, required = select(4,GetQuestObjectiveInfo(53435,1,false))
		island_expedition = tostring(fulfilled)
	end
	
	-- Warfront
	local warfrontQuests = {}
	local warfrontQuestIDs = {53416, 56137, 52848, 53955, 57959, 54896}
	
	for i,id in ipairs(warfrontQuestIDs) do
		warfrontQuests[i] = {[id] = IsQuestFlaggedCompleted(id) or 0}
	end
	
	-- Order Resources
	local _, war_resources = GetCurrencyInfo(1560)
	
	-- Titan Residium
	local _, titan_residium = GetCurrencyInfo(1718)
	
	-- Mana Pearls
	local _, mana_pearls = GetCurrencyInfo(1721)
	
	LFGRewardsFrame_UpdateFrame(LFDQueueFrameRandomScrollFrameChildFrame, 1671, LFDQueueFrameBackground)
	local daily_heroic
	local done, money = GetLFGDungeonRewards(1671);
	if done and money > 0 then daily_heroic = true end
	
	RequestPVPRewards()
	RequestRandomBattlegroundInstanceInfo()
	local rnd_bg = select(3,C_PvP.GetRandomBGInfo());
	
	-- Check All Quests
	local quests = {}
	
	for questID, mod in pairs(trackedQuests) do
		if mod == "check" then
			quests[questID] = IsQuestFlaggedCompleted(questID)
		elseif type(mod) == "string" then
			quests[mod] = (IsQuestFlaggedCompleted(questID) and ((quests[mod] and (quests[mod]<3 and quests[mod] + 1) or 3) or 1)) or quests[mod] or 0
		end
	end
	
	local seals = nil
	local seals_bought = nil

	
	_, seals = GetCurrencyInfo(1580);
	
	seals_bought = 0
	local gold_1 = IsQuestFlaggedCompleted(52834)
	if gold_1 then seals_bought = seals_bought + 1 end
	local gold_2 = IsQuestFlaggedCompleted(52838)
	if gold_2 then seals_bought = seals_bought + 1 end
	local resources_1 = IsQuestFlaggedCompleted(52837)
	if resources_1 then seals_bought = seals_bought + 1 end
	local resources_2 = IsQuestFlaggedCompleted(52840)
	if resources_2 then seals_bought = seals_bought + 1 end
	local marks_1 = IsQuestFlaggedCompleted(52835)
	if marks_1 then seals_bought = seals_bought + 1 end
	local marks_2 = IsQuestFlaggedCompleted(52839)
	if marks_2 then seals_bought = seals_bought + 1 end
	
	-- Emissaries
	local d_em = nil
	local em1,em2,em3 = nil
	local emissaries = GetQuestBountyInfoForMapID(876)
	d_em = #emissaries
	
	for BountyIndex, BountyInfo in ipairs(emissaries) do
		local title = GetQuestLogTitle(GetQuestLogIndexByID(BountyInfo.questID))
		local timeleft = C_TaskQuest.GetQuestTimeLeftMinutes(BountyInfo.questID)
		local _, _, finished, fulfilled, required = GetQuestObjectiveInfo(BountyInfo.questID, 1, false)
		if timeleft and faction_abb[title] then
			if timeleft > 2880 then
				em3 = {fulfilled,required,faction_abb[title]}
			elseif timeleft > 1440 then
				em2 = {fulfilled,required,faction_abb[title]}
			else
				em1 = {fulfilled,required,faction_abb[title]}
			end
		end
	end
	
	-- BfN
	local bfn_quests = {56882, 56890, 56893, 56894, 56895}
	local bfn = 0
	
	for i, id in ipairs(bfn_quests) do
		bfn = IsQuestFlaggedCompleted(id) and bfn + 1 or bfn;
	end
	
	-- Contract
	local contract = nil
	local contracts = {[256460] = "CoA",[256459] = "ToS",[256456] = "Vol",[256455] = "TE",[256453] = "ZE",[256452] = "StW",[256451] = "OoP",[256434] = "PA",[284277] = "HB",[284275] = "7L"}
	for spellId, faction in pairs(contracts) do
		if AuraUtil.FindAuraByName(GetSpellInfo(spellId),"player") then
			contract = faction
			break
		end
	end
	
	-- Coalescing Visions
	local _, coalescing_visions = GetCurrencyInfo(1755)

	-- Vessels
	local vessels = GetItemCount(173363, true)

	-- Corrupted Mementos
	local _, corrupted_mementos = GetCurrencyInfo(1719)
	local research_cost = 150
	if C_Garrison.GetTalentPointsSpentInTalentTree then
		research_cost = select(3, C_Garrison.GetTalentTreeTalentPointResearchInfo(271,C_Garrison.GetTalentPointsSpentInTalentTree(271),0))
	end



	-- Rajani Reputation
	local rajani_min, rajani_max, rajani_v = select(4, GetFactionInfoByID(2415))
	local rajani = {(rajani_v - rajani_min), (rajani_max - rajani_min)}

	-- Uldum Accord Reputation
	local accord_min, accord_max, accord_v = select(4, GetFactionInfoByID(2417))
	local uldum_accord = {(accord_v - accord_min), (accord_max - accord_min)}

	-- Active POIs
	local uldum_poi, voeb_poi = self:activePois()

	-- Uldum 8.3 Info
	local uldum_chests, uldum_rares, uldum_events, uldum_per_assault = 0, 0, 0, {} 
	local voeb_chests, voeb_rares, voeb_events, voeb_per_assault = 0, 0, 0, {}

	if uldum_poi and voeb_poi then
		local uldum_poi_info = self.objectives[1527][uldum_poi]
		for i, questId in ipairs(uldum_poi_info.chests) do
			if IsQuestFlaggedCompleted(questId) then uldum_chests = uldum_chests + 1 end
		end
		for i, questId in ipairs(uldum_poi_info.rares) do
			if IsQuestFlaggedCompleted(questId) then uldum_rares = uldum_rares + 1 end
		end
		for i, questId in ipairs(uldum_poi_info.events) do
			if IsQuestFlaggedCompleted(questId) then uldum_events = uldum_events + 1 end
		end
		for i, questId in ipairs(uldum_poi_info.assault) do
			tinsert(uldum_per_assault,{[questId] = IsQuestFlaggedCompleted(questId) or 0})
		end

		-- VoEB 8.3 Info
		local voeb_poi_info = self.objectives[1530][voeb_poi]
		for i, questId in ipairs(voeb_poi_info.chests) do
			if IsQuestFlaggedCompleted(questId) then voeb_chests = voeb_chests + 1 end
		end
		for i, questId in ipairs(voeb_poi_info.rares) do
			if IsQuestFlaggedCompleted(questId) then voeb_rares = voeb_rares + 1 end
		end
		for i, questId in ipairs(voeb_poi_info.events) do
			if IsQuestFlaggedCompleted(questId) then voeb_events = voeb_events + 1 end
		end
		for i, questId in ipairs(voeb_poi_info.assault) do
			tinsert(voeb_per_assault,{[questId] = IsQuestFlaggedCompleted(questId) or 0})
		end
	end

	-- Corrupted Creatures
	local corrupted_creatures = 0
	for i, id in ipairs({58688, 58689, 58690, 58691}) do
		if IsQuestFlaggedCompleted(id) then corrupted_creatures = corrupted_creatures + 1 end
	end

	-- Cloak Upgrades
	local cloak = GetInventoryItemLink("player",15)
	local cloak_id = cloak:match(":(%d+)")
	local cloak_upgrades = cloak_id == "169223" and select(15,strsplit(":",cloak))%6271 or 0

	-- Battle for Nazjatar
	local bfn_wq = IsQuestFlaggedCompleted(56050) or C_TaskQuest.GetQuestProgressBarInfo(56050);
	
	-- Mechagon WQ
	local mechagon_wq = IsQuestFlaggedCompleted(55901) or C_TaskQuest.GetQuestProgressBarInfo(55901);
	
	-- Bodyguard XP
	local bodyguard_faction_ids = {2388,2389,2390};
	local bodyguard_xp = 0;
	
	for i=1, #bodyguard_faction_ids do
		local friendRep = select(2,GetFriendshipReputation(bodyguard_faction_ids[i]));
		bodyguard_xp = bodyguard_xp + friendRep;
	end
	
	-- Bodyguard XP Items  Bark  Wing  Leg   Filet
	local bodyguard_ids = {57139,57141,57142,57143};
	local bodyguard_items = {};
	
	for i = 1, #bodyguard_ids do
		if IsQuestFlaggedCompleted(bodyguard_ids[i]) then
			bodyguard_items[i] = {[bodyguard_ids[i]] = true};
		else
			bodyguard_items[i] = {[bodyguard_ids[i]] = 0};
		end
	end
	
	-- Madivas
	local madivas_lab = IsQuestFlaggedCompleted(55121);
	
	-- dungeons/raids
	local fh, kr, undr, mechagon
	local dungeon_names = {["The MOTHERLOAD!!"] = tm,["Freehold"] = fh,["Kings' Rest"] = kr,["Atal'Dazar"] = ad,["Tol Dagor"] = td,["Siege of Boralus"] = siege,["The Underrot"] = undr,["Waycrest Manor"] = wm,
						   ["Shrine of the Storm"] = sots,["Temple of Sethraliss"] = tos}	
	local uldir_lfr, uldir_normal, uldir_heroic, uldir_mythic = 0
	local bod_lfr, bod_normal, bod_heroic, bod_mythic = 0
	local cos_lfr, cos_normal, cos_heroic, cos_mythic = 0
	local ep_lfr, ep_normal, ep_heroic, ep_mythic = 0
	local ny_lfr, ny_normal, ny_heroic, ny_mythic = 0
	local saves = GetNumSavedInstances()
	local moverall = 0
	
	local GetMapNameByID = function(mapId)
		local mapInfo = C_Map.GetMapInfo(mapId)
		return mapInfo and mapInfo.name
	end

	for i = 1, saves do
		local name, _, reset, difficulty, _, _, _, isRaid, _, difficultyName , bosses, killed_bosses = GetSavedInstanceInfo(i);	
		-- check for M0
		if not isRaid and difficulty == 23 and reset > 0 then
			if bosses == killed_bosses or (name == GetMapNameByID(1162) and killed_bosses == 4) then
				moverall = moverall + 1
			end
		
			--if name == GetMapNameByID(934) then	ad = self:MakeDungeonString(killed_bosses,bosses) end
			if name == GetMapNameByID(936) then fh = self:MakeDungeonString(killed_bosses,bosses) end
			if name == GetMapNameByID(1004) then kr = self:MakeDungeonString(killed_bosses,bosses) end
			--if name == GetMapNameByID(1039) then sots = self:MakeDungeonString(killed_bosses,bosses) end
			--if name == GetMapNameByID(1162) then siege = self:MakeDungeonString(killed_bosses,4) end
			--if name == GetMapNameByID(1038) then tos = self:MakeDungeonString(killed_bosses,bosses) end
			--if name == GetMapNameByID(1010) then tm = self:MakeDungeonString(killed_bosses,bosses) end
			if name == GetMapNameByID(1041) then undr = self:MakeDungeonString(killed_bosses,bosses) end
			--if name == GetMapNameByID(974) then td = self:MakeDungeonString(killed_bosses,bosses) end	
			--if name == GetMapNameByID(1015) then wm = self:MakeDungeonString(killed_bosses,bosses) end	
			if name == C_Map.GetAreaInfo(10225) then mechagon = self:MakeDungeonString(killed_bosses,bosses) end
		end
		
		-- check for raids
		-- Uldir
		if name == GetMapNameByID(1148) and reset > 0 then
			if difficulty == 14 then uldir_normal = killed_bosses end
			if difficulty == 15 then uldir_heroic = killed_bosses end
			if difficulty == 16 then uldir_mythic = killed_bosses end
		end
		
		-- BoD
		if name == GetMapNameByID(1358) and reset > 0 then
			if difficulty == 14 then bod_normal = killed_bosses end
			if difficulty == 15 then bod_heroic = killed_bosses end
			if difficulty == 16 then bod_mythic = killed_bosses end
		end
		
		-- EP
		if name == GetMapNameByID(1512) and reset > 0 then
			if difficulty == 14 then ep_normal = killed_bosses end
			if difficulty == 15 then ep_heroic = killed_bosses end
			if difficulty == 16 then ep_mythic = killed_bosses end
		end

		-- Nyalotha
		if name == GetMapNameByID(1580) and reset > 0 then
			if difficulty == 14 then ny_normal = killed_bosses end
			if difficulty == 15 then ny_heroic = killed_bosses end
			if difficulty == 16 then ny_mythic = killed_bosses end
		end
	end

	local uldir_lfr_id = {1731, 1732, 1733}
	local bod_lfr_id = {1948,1949,1950}
	local cos_lfr_id = 1951
	local ep_lfr_id = {2009,2010,2011}
	local ny_lfr_id = {2036,2037,2038,2039}
	
	for _, v in pairs(uldir_lfr_id) do
		local _, killed = GetLFGDungeonNumEncounters(v)
		uldir_lfr = uldir_lfr + killed
	end

	for _, v in pairs(bod_lfr_id) do
		local _, killed = GetLFGDungeonNumEncounters(v)
		bod_lfr = bod_lfr + killed
	end
	
	_,cos_lfr = GetLFGDungeonNumEncounters(cos_lfr_id)

	for _,v in pairs(ep_lfr_id) do
		local _, killed = GetLFGDungeonNumEncounters(v)
		ep_lfr = ep_lfr + killed
	end 

	for _,v in pairs(ny_lfr_id) do
		local _, killed = GetLFGDungeonNumEncounters(v)
		ep_lfr = killed and ep_lfr + killed
	end
	
	local _, ilevel = GetAverageItemLevel()
	-- store data into a table
	local char_table = MethodAltManagerDB.data and MethodAltManagerDB.data[guid] or {}
	if not char_table then return end
	
	char_table.guid = guid or UnitGUID('player')
	char_table.name = name
	char_table.class = class
	char_table.faction = faction;
	char_table.ilevel = ilevel
	char_table.seals = seals
	char_table.seals_bought = seals_bought
	char_table.d_em = d_em
	char_table.essence = essence
	char_table.em1 = em1
	char_table.em2 = em2
	char_table.em3 = em3
	char_table.contract = contract
	char_table.moverall = moverall
	char_table.rajani = rajani
	char_table.uldum_accord = uldum_accord
	char_table.voeb_poi = voeb_poi
	char_table.uldum_poi = uldum_poi
	char_table.voeb_chests = voeb_chests
	char_table.voeb_rares = voeb_rares
	char_table.voeb_events = voeb_events
	char_table.voeb_per_assault = voeb_per_assault
	char_table.uldum_chests = uldum_chests
	char_table.uldum_rares = uldum_rares
	char_table.uldum_events = uldum_events
	char_table.uldum_per_assault = uldum_per_assault
	char_table.corrupted_creatures = corrupted_creatures
	char_table.cloak_upgrades = cloak_upgrades

	--char_table.ad = ad
	char_table.fh = fh
	char_table.kr = kr
	--char_table.sots = sots
	--char_table.siege = siege
	--char_table.tos = tos
	--char_table.tm = tm
	char_table.undr = undr
	char_table.mechagon = mechagon
	--char_table.td = td
	--char_table.wm = wm
	char_table.dungeon = dungeon
	char_table.level = level
	char_table.highest_mplus = highest_mplus
	char_table.quests = char_table.quests or {}

	for questID, bool in pairs(quests) do
		char_table.quests[questID] = bool
	end
	
	char_table.madivas_lab = madivas_lab;
	char_table.bodyguard_xp = bodyguard_xp;
	char_table.bfn_wq = bfn_wq;
	char_table.bfn = bfn;
	char_table.mechagon_wq = mechagon_wq;
	char_table.bodyguard_items = bodyguard_items;
	char_table.uldir_lfr = uldir_lfr
	char_table.uldir_normal = uldir_normal
	char_table.uldir_heroic = uldir_heroic
	char_table.uldir_mythic = uldir_mythic
	char_table.bod_lfr = bod_lfr
	char_table.bod_normal = bod_normal
	char_table.bod_heroic = bod_heroic
	char_table.bod_mythic = bod_mythic
	char_table.cos_lfr = cos_lfr
	char_table.cos_normal = cos_normal
	char_table.cos_heroic = cos_heroic
	char_table.cos_mythic = cos_mythic
	char_table.ep_lfr = ep_lfr
	char_table.ep_normal = ep_normal
	char_table.ep_heroic = ep_heroic
	char_table.ep_mythic = ep_mythic
	char_table.ny_lfr = ny_lfr
	char_table.ny_normal = ny_normal
	char_table.ny_heroic = ny_heroic
	char_table.ny_mythic = ny_mythic
	
	char_table.warfrontQuests = warfrontQuests
	char_table.island_expedition = island_expedition
	char_table.hoa_level = hoa_level
	char_table.war_resources = war_resources
	char_table.titan_residium = titan_residium
	char_table.mana_pearls = mana_pearls
	char_table.corrupted_mementos = corrupted_mementos
	char_table.research_cost = research_cost
	char_table.coalescing_visions = coalescing_visions
	char_table.vessels = vessels
	char_table.daily_heroic = daily_heroic
	char_table.rnd_bg = rnd_bg
	char_table.expires = self:GetNextWeeklyResetTime()
	char_table.daily = self:GetNextDailyResetTime()

	return char_table;
end

function AltManager:UpdateEssences()
	if UnitLevel('player') < min_level or self.db.profile.blacklist[UnitName('player')] then return end;
	
	-- Basic Char Information
	local guid = UnitGUID('player')
	
	local char_table = guid and MethodAltManagerDB.data and MethodAltManagerDB.data[guid]
	if not char_table then return end;
	
	local universal_essences = {32,12,27,15,22,4,37};
	local tank_essences = {25,7,13,3,2,34,33};
	local heal_essences = {18,17,20,19,21,24,16};
	local dps_essences = {23,5,14,6,28,35,36};
	
	local essences = {}
	
	for i,essenceID in ipairs(universal_essences) do
		local info = C_AzeriteEssence.GetEssenceInfo(essenceID)
		if info and info.unlocked then
			essences[essenceID] = info.rank
		end
	end
	
	for i,essenceID in ipairs(tank_essences) do
		local info = C_AzeriteEssence.GetEssenceInfo(essenceID)
		if info and info.unlocked then
			essences[essenceID] = info.rank
		end
	end
	
	for i,essenceID in ipairs(heal_essences) do
		local info = C_AzeriteEssence.GetEssenceInfo(essenceID)
		if info and info.unlocked then
			essences[essenceID] = info.rank
		end
	end	
		
	for i,essenceID in ipairs(dps_essences) do
		local info = C_AzeriteEssence.GetEssenceInfo(essenceID)
		if info and info.unlocked then
			essences[essenceID] = info.rank
		end
	end	
	
	char_table.essences = essences;
	
	return char_table;
end

function AltManager:UpdateQuests(questID)
	if UnitLevel('player') < min_level or self.db.profile.blacklist[UnitName('player')] then return end;
	
	-- Basic Char Information
	local guid = UnitGUID('player')
	
	local char_table = guid and MethodAltManagerDB.data and MethodAltManagerDB.data[guid]
	if not char_table then return end;
	
	local quest = trackedQuests[questID]=="check" and IsQuestFlaggedCompleted(questID) or true
	
	char_table.quests = char_table.quests or {}
	char_table.quests[questID] = quest;
	
	return char_table;
end

function AltManager:PopulateStrings()
	local font_height = 20;
	local db = MethodAltManagerDB;
	
	local keyset = {}
	for k in pairs(db.data) do
		table.insert(keyset, k)
	end
	
	self.main_frame.alt_columns = self.main_frame.alt_columns or {};
	
	local alt = 0
	for alt_guid, alt_data in spairs(db.data, function(t, a, b) return t[a].ilevel > t[b].ilevel end) do
		alt = alt + 1
		-- create the frame to which all the fontstrings anchor
		local anchor_frame = self.main_frame.alt_columns[alt] or CreateFrame("Button", nil, self.main_frame);
		if not self.main_frame.alt_columns[alt] then
			self.main_frame.alt_columns[alt] = anchor_frame;
		end
		anchor_frame:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", per_alt_x * alt, -1);
		anchor_frame:SetSize(per_alt_x, sizey);
		-- init table for fontstring storage
		self.main_frame.alt_columns[alt].label_columns = self.main_frame.alt_columns[alt].label_columns or {};
		local label_columns = self.main_frame.alt_columns[alt].label_columns;
		-- create / fill fontstrings
		local i = 1;
		for column_iden, column in spairs(self.columns_table, function(t, a, b) return t[a].order < t[b].order end) do
			-- only display data with values
			if type(column.data) == "function" then
				local current_row = label_columns[i] or self:CreateFontFrame(self.main_frame, per_alt_x, column.font_height or font_height, anchor_frame, -(i - 1) * font_height, column.data(alt_data), "CENTER");
				-- insert it into storage if just created
				if not self.main_frame.alt_columns[alt].label_columns[i] then
					self.main_frame.alt_columns[alt].label_columns[i] = current_row;
				end
				if column.color then
					local color = column.color(alt_data)
					current_row:GetFontString():SetTextColor(color.r, color.g, color.b, 1);
				end
				current_row:SetText(column.data(alt_data))
				if column.font then
					current_row:GetFontString():SetFont(column.font, 8)
				else
					--current_row:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 14)
				end
				if column.justify then
					current_row:GetFontString():SetJustifyV(column.justify);
				end
			end
			i = i + 1
		end
		
	end
	
end

function AltManager:Unroll(button, my_rows, default_state, name, icon)
	local add = y_add[name]

	self.unroll_state = self.unroll_state or {}
	self.unroll_state[name] = self.unroll_state[name] or {}
	local lu = self.unroll_state[name]
	lu.state = default_state or lu.state or "closed";
	lu.icon = lu.icon or icon

	lu.unroll_frame = lu.unroll_frame or CreateFrame("Button", nil, self.main_frame);
	lu.unroll_frame:SetSize(per_alt_x, add);
	lu.unroll_frame:SetPoint("TOPLEFT",self.main_frame, "TOPLEFT", 4, self.main_frame.lowest_point + 110);
				
	if lu.state == "closed" then
		-- do unroll
		lu.unroll_frame:Show();
					
		local font_height = 20
		-- create the rows for the unroll
		if not lu.labels then
			lu.labels = {}
			local i = 1
			for row_identifier, row in spairs(my_rows, function(t, a, b) return t[a].order < t[b].order end) do
				if row.label then
					-- parent, 			x_size,    height, 	    relative_to,     y_offset,           label,          justify
					local label_row = self:CreateFontFrame(lu.unroll_frame, per_alt_x, font_height, lu.unroll_frame, (-(i-1)*font_height) + 45, row.label, "RIGHT");
					table.insert(lu.labels, label_row)
				end
				i = i + 1
			end
		end
					
		-- populate it for alts
		lu.alt_columns = lu.alt_columns or {};
		local alt = 0
		local db = MethodAltManagerDB;
		for alt_guid, alt_data in spairs(db.data, function(t, a, b) return t[a].ilevel > t[b]. ilevel end) do
			alt = alt + 1
			-- create the frame to which all the fontstrings anchor
			local anchor_frame = lu.alt_columns[alt] or CreateFrame("Button", nil, lu.unroll_frame);
			if not lu.alt_columns[alt] then
				lu.alt_columns[alt] = anchor_frame;
			end
			anchor_frame:SetPoint("TOPLEFT", lu.unroll_frame, "TOPLEFT", per_alt_x * alt, -1);
			anchor_frame:SetSize(per_alt_x, add);
			-- init table for fontstring storage
			lu.alt_columns[alt].label_columns = lu.alt_columns[alt].label_columns or {};
			local label_columns = lu.alt_columns[alt].label_columns;
			-- create / fill fontstrings
			local i = 1;
			for column_iden, column in spairs(my_rows, function(t, a, b) return t[a].order < t[b].order end) do
				local current_row = label_columns[i] or self:CreateFontFrame(lu.unroll_frame, per_alt_x, column.font_height or font_height, anchor_frame, (-(i - 1) * font_height) + 45, column.data(alt_data), "CENTER");
				-- insert it into storage if just created
				if not lu.alt_columns[alt].label_columns[i] then
					lu.alt_columns[alt].label_columns[i] = current_row;
				end
				current_row:SetText(column.data(alt_data))
				i = i + 1
			end
		end
					
		-- fixup the background
		self.main_frame:SetSize(max((alt+2) * per_alt_x, min_x_size), sizey + add);
		self.main_frame.background:SetAllPoints();
		
		if not icon then
			button:SetText(name .. " <<");
		else
			button:SetText(icon)
			button:SetNormalTexture("Interface\\AddOns\\MethodAltManager\\textures\\normalTexture.blp")
		end
		
		lu.state = "open";
	else
		self:RollUp(button, name, icon)
		
	end
end

function AltManager:RollUp(button, name, icon)
	self.main_frame:SetSize(max((MethodAltManagerDB.alts + 2) * per_alt_x, min_x_size), sizey);
	self.main_frame.background:SetAllPoints();
	self.unroll_state[name].unroll_frame:Hide();
	
	if not icon then
		button:SetText(name .. " >");
	else
		button:SetNormalTexture("")
	end
	self.unroll_state[name].state = "closed";
end


function AltManager:CreateMenu()

	-- Close button
	self.main_frame.closeButton = CreateFrame("Button", "CloseButton", self.main_frame, "UIPanelCloseButton");
	self.main_frame.closeButton:ClearAllPoints()
	self.main_frame.closeButton:SetPoint("BOTTOMRIGHT", self.main_frame, "TOPRIGHT", -10, -2);
	self.main_frame.closeButton:SetScript("OnClick", function() AltManager:HideInterface(); end);
	--self.main_frame.closeButton:SetSize(32, h);

	local column_table = {
		name = {
			order = 0.1,
			label = name_label..":",
			data = function(alt_data) return alt_data.name end,
			color = function(alt_data) return RAID_CLASS_COLORS[alt_data.class] end,
		},
		ilevel = {
			order = 0.15,
			data = function(alt_data) return string.format("%.2f", alt_data.ilevel or 0) end,
			justify = "TOP",
			font = "Fonts\\FRIZQT__.TTF",
		},
		mplus = {
			order = 0.2,
			label = mythic_done_label..":",
			data = function(alt_data) return tostring(alt_data.highest_mplus) end, 
		},
		keystone = {
			order = 0.25,
			label = mythic_keystone_label..":",
			data = function(alt_data) return (dungeons[alt_data.dungeon] or alt_data.dungeon) .. " +" .. tostring(alt_data.level); end,
		},
		space1 = {
			order = 0.3,
			data = function(alt_data) return " " end,
		},
		seals_owned = {
			order = 0.35,
			label = seals_owned_label..":",
			data = function(alt_data) return alt_data.seals and tostring(alt_data.seals) or "0" end,
		},
		seals_bought = {
			order = 0.4,
			label = seals_bought_label..":",
			data = function(alt_data) return alt_data.seals_bought and (alt_data.seals_bought == 0 and string.format("|cffff0000%s",alt_data.seals_bought) or tostring(alt_data.seals_bought))  or "0" end,
		},
		war_resources = {
			order = 0.45,
			label = resources_label..":",
			data = function(alt_data) return alt_data.war_resources and AbbreviateNumbers(alt_data.war_resources) or "0" end,
		},
		titan_residium = {
			order = 0.5,
			label = "Titan Residuum:",
			data = function(alt_data) return alt_data.titan_residium and alt_data.titan_residium or "-" end,
		},
		hoa_level = {
			order = 0.55,
			label = hoa_label..":",
			data = function(alt_data) return alt_data.hoa_level and tostring(alt_data.hoa_level) or "-" end,
		},
		island_expedition = {
			order = 0.6,
			label = island_label..":",
			data = function(alt_data) return (alt_data.island_expedition and (alt_data.island_expedition == -1 and "|cff00ff00X|r") or (alt_data.island_expedition=="0" and "\45") or alt_data.island_expedition) or "\45" end,
		},
		dummy_empty_line = {
			order = 0.65,
			data = function(alt_data) return " " end,
		},
		universal_essence = {
			order = 1.1,
			data = "unroll",
			button_pos = 120,
			w_size = 25,
			h_size = 25,
			disable_drawLayer = true,
			name = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:24:24:0:0:64:64:0:19:1:20|t",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Universal", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:24:24:0:0:64:64:0:19:1:20|t") end,
			rows = {
				essence = {
					order = 1,
					label = "First Essence:",
					data = function(alt_data) return alt_data.essence and "|cff00ff00X|r" or "-" end,
				},
				conflict_and_strife = {
					order = 2,
					label = "Conflict \124T3015742:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[32]) or "-") end,
				},
				crucible_of_flame = {
					order = 3,
					label = "Crucible \124T3015740:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[12]) or "-") end,
				},
				formless_void = {
					order = 4,
					label = "Formless Void \124T3193845:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[37]) or "-") end,
				},
				memory_of_lucid_dreams = {
					order = 5,
					label = "Lucid Dreams \124T2967104:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[27]) or "-") end,
				},
				ripple_in_space =  {
					order = 6,
					label = "Ripple in Space \124T2967109:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[15]) or "-") end,
				},
				vision_of_perfection = {
					order = 7,
					label = "Vision \124T3015743:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[22]) or "-") end,
				},
				worldvein_resonance = {
					order = 8,
					label = "Worldvein \124T2065619:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[4]) or "-") end,
				},
			}
		},
		tank_essence = {
			order = 1.2,
			data = "unroll",
			button_pos = 80,
			w_size = 25,
			h_size = 25,
			disable_drawLayer = true,
			name = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:24:24:0:0:64:64:0:19:22:41|t",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Tank", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:24:24:0:0:64:64:0:19:22:41|t") end,
			rows = {
				aegis_of_the_deep = {
					order = 1,
					label = "Aegis \124T2967110:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[25]) or "-") end,
				},
				anima_of_life_and_death = {
					order = 2,
					label = "Anima of L.&D.\124T2967105:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[7]) or "-") end,
				},	
				nullification_dynamo = {
					order = 3,
					label = "Null. Dynamo \124T3015741:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[13]) or "-") end,
				},
				sphere_of_supression = {
					order = 4,
					label = "Sphere of Supr. \124T2065602:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[3]) or "-") end,
				},
				touch_of_the_everlasting = {
					order = 5,
					label = "Touch \124T3193847:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[33]) or "-") end,
				},
				azeroths_undying_gift = {
					order = 6,
					label = "Undying Gift \124T2967107:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[2]) or "-") end,
				},
				strength_of_the_warden = {
					order = 7,
					label = "Warden \124T3193846:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[34]) or "-") end,
				},
			}
		},
		healer_essence = {
			order = 1.3,
			data = "unroll",
			button_pos = 40,
			w_size = 25,
			h_size = 25,
			disable_drawLayer = true,
			name = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:24:24:0:0:64:64:20:39:1:20|t",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Healer", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:24:24:0:0:64:64:20:39:1:20|t") end,
			rows = {
				artifice_of_time = {
					order = 1,
					label = "Artifice of Time \124T2967112:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[18]) or "-") end,
				},
				ever_rising_tide = {
					order = 2,
					label = "Ever Rising Tide \124T2967108:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[17]) or "-") end,
				},
				life_binders_invocation = {
					order = 3,
					label = "Life Binder \124T2967106:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[20]) or "-") end,
				},
				spirit_of_preservation = {
					order = 4,
					label = "Spirit of Pres. \124T2967101:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[24]) or "-") end,
				},
				unwavering_ward = {
					order = 5,
					label = "Unwavering Ward \124T3193842:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[16]) or "-") end,
				},
				well_of_existence = {
					order = 6,
					label = "Well of Existence \124T516796:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[19]) or "-") end,
				},
				vitality_conduit = {
					order = 7,
					label = "Vitality Conduit \124T2967100:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[21]) or "-") end,
				},
			}
		},
		dps_essence = {
			order = 1.4,
			data = "unroll",
			button_pos = 0,
			w_size = 25,
			h_size = 25,
			disable_drawLayer = true,
			name = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:24:24:0:0:64:64:20:39:22:41|t",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "DPS", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:24:24:0:0:64:64:20:39:22:41|t") end,
			rows = {
				blood_of_the_enemy = {
					order = 1,
					label = "Blood \124T2032580:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[23]) or "-") end,
				},
				breath_of_the_dying = {
					order = 2,
					label = "Breath \124T3193844:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[35]) or "-") end,
				},
				essence_of_the_focusing_iris = {
					order = 3,
					label = "Focusing Iris \124T2967111:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[5]) or "-") end,
				},
				condensed_life_force = {
					order = 4,
					label = "Life-Force \124T2967113:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[14]) or "-") end,
				},
				purification_protocol = {
					order = 5,
					label = "Purification PROT \124T2967103:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[6]) or "-") end,
				},
				spark_of_inspiration = {
					order = 6,
					label = "Spark \124T3193843:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[36]) or "-") end,
				},
				unbound_force = {
					order = 7,
					label = "Unbound Force \124T2967102:16:16\124t:",
					data = function(alt_data) return (alt_data.essences and self:MakeEssenceString(alt_data.essences[28]) or "-") end,
				},
			}
		},
		third_patch_unroll = {
			order = 2,
			data = "unroll",
			button_pos = 0,
			name = "8.3 >",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "8.3") end,
			rows = {
				cloak_upgrades = {
					order = 1,
					label = "Cloak Rank:",
					data = function(alt_data) return alt_data.cloak_upgrades and self:MakeColoredString({alt_data.cloak_upgrades,15}) or "-" end,
				},
				coalescing_visions = {
					order = 1.1,
					label = "Coalescing Visions:",
					data = function(alt_data) return alt_data.coalescing_visions and AbbreviateNumbers(alt_data.coalescing_visions) or "-" end,
				},
				vessel_of_horrific_visions = {
					order = 1.2,
					label = "Vessels:",
					data = function(alt_data) return alt_data.vessels and alt_data.vessels or "-" end,
				},
				corrupted_mementos = {
					order = 2,
					label = "Corrupted Memes:",
					data = function(alt_data) return alt_data.corrupted_mementos and alt_data.research_cost and self:MakeReputationString({alt_data.corrupted_mementos, alt_data.research_cost}) or "-" end,
				},
				corrupted_creatures = {
					order = 2.1,
					label = "Corrupted Creatures:",
					data = function(alt_data) return alt_data.corrupted_creatures and self:MakeColoredString({alt_data.corrupted_creatures,4}) or "-" end,
				},
				lesser_vision = {
					order = 2.2,
					label = "Lesser Vision:",
					data = function(alt_data) return (alt_data.quests and (alt_data.quests[58168] or alt_data.quests[58155] or alt_data.quests[58151] or alt_data.quests[58167] or alt_data.quests[58156] or alt_data.quests[57874]) and "|cff00ff00X|r") or "-" end,
				},
				dummy_empty_line1 = {
					order = 3,
					data = function(alt_data) return " " end,
				},
				rajani = {
					order = 4,
					label = "Rajani:",
					data = function(alt_data) return alt_data.rajani and self:MakeReputationString(alt_data.rajani) or "-" end,
				},
				voeb_per_assault = {
					order = 4.1,
					label = "Assault/Strongbox:",
					data = function(alt_data) return alt_data.voeb_per_assault and alt_data.voeb_poi and self:MakeQuestString(alt_data.voeb_per_assault,{[56064] = "A", [57008] = "A", [57728] = "A", [57628] = "S", [57214] = "S", [58770] = "S"}) or "-" end,
				},
				voeb_chests = {
					order = 4.2,
					label = "Chests:",
					data = function(alt_data) return alt_data.voeb_chests and alt_data.voeb_poi and self:MakeColoredString({alt_data.voeb_chests,#self.objectives[1530][alt_data.voeb_poi].chests})  or "-" end,
				},
				voeb_events = {
					order = 4.3,
					label = "Events:",
					data = function(alt_data) return alt_data.voeb_events and alt_data.voeb_poi and self:MakeColoredString({alt_data.voeb_events,6})  or "-" end,
				},
				voeb_rares = {
					order = 4.4,
					label = "Rares:",
					data = function(alt_data) return alt_data.voeb_rares and alt_data.voeb_poi and self:MakeColoredString({alt_data.voeb_rares,#self.objectives[1530][alt_data.voeb_poi].rares})  or "-" end,
				},
				dummy_empty_line2 = {
					order = 4.5,
					data = function(alt_data) return " " end,
				},
				uldum_accord = {
					order = 5,
					label = "Uldum Accord:",
					data = function(alt_data) return alt_data.rajani and self:MakeReputationString(alt_data.uldum_accord) or "-" end,
				},
				uldum_per_assault = {
					order = 5.1,
					label = "Assault/Strongbox:",
					data = function(alt_data) return alt_data.uldum_per_assault and alt_data.uldum_poi and self:MakeQuestString(alt_data.uldum_per_assault,{[57157] = "A", [55350] = "A", [56308] = "A", [57628] = "S", [55692] = "S", [58137] = "S"}) or "-" end,
				},
				uldum_chests = {
					order = 5.2,
					label = "Chests:",
					data = function(alt_data) return alt_data.uldum_chests and alt_data.uldum_poi and self:MakeColoredString({alt_data.uldum_chests,#self.objectives[1527][alt_data.uldum_poi].chests})  or "-" end,
				},
				uldum_events = {
					order = 5.3,
					label = "Events:",
					data = function(alt_data) return alt_data.uldum_events and alt_data.uldum_poi and self:MakeColoredString({alt_data.uldum_events,6})  or "-" end,
				},
				uldum_rares = {
					order = 5.4,
					label = "Rares:",
					data = function(alt_data) return alt_data.uldum_rares and alt_data.uldum_poi and self:MakeColoredString({alt_data.uldum_rares,#self.objectives[1527][alt_data.uldum_poi].rares})  or "-" end,
				},
			}
		},
		second_patch_unroll = {
			order = 3,
			data = "unroll",
			button_pos = 0,
			name = "8.2 >",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "8.2") end,
			rows = {
				mana_pearls = {
					order = 1,
					label = "Mana Pearls:",
					data = function(alt_data) return alt_data.mana_pearls and AbbreviateNumbers(alt_data.mana_pearls) or "-" end,
				},
				battle_for_nazjatar = {
					order = 2,
					label = "BfN:",
					data = function(alt_data) return alt_data.bfn and (alt_data.bfn == 5 and "|cff00ff00X|r" or alt_data.bfn.."/5") or "-" end,
				},
				battle_for_nazjatar_wq = {
					order = 3,
					label = "BfN WQ:",
					data = function(alt_data) return (alt_data.bfn_wq and (type(alt_data.bfn_wq)=="number" and alt_data.bfn_wq .. "%") or (type(alt_data.bfn_wq) == "boolean" and "|cff00ff00X|r")) or "0%" end,
				},
				madivas_lab = {
					order = 4,
					label = "Madivas Lab:",
					data = function(alt_data) return (alt_data.madivas_lab and "|cff00ff00X|r") or "-" end,
				},
				dummy_empty_line1 = {
					order = 5,
					data = function(alt_data) return " " end,
				},
				bodyguard_xp = {
					order = 6,
					label = "Bodyguard XP:",
					data = function(alt_data) return (alt_data.bodyguard_xp and alt_data.bodyguard_xp) or "-" end,
				},
				bodyguard_quests = {
					order = 7,
					label = "Bodyguard Qs:",
					data = function(alt_data) return (alt_data.faction and alt_data.quests["bodyguard_"..alt_data.faction] and self:MakeColoredString({alt_data.quests["bodyguard_"..alt_data.faction],3})) or "-" end,
				},
				ancient_bark = {
					order = 8,
					label = "|cff0070ddAncient Bark:",
					data = function(alt_data) return (alt_data.quests and alt_data.quests[57140] and "|cff00ff00X|r") or "-" end,
				},
				green_bodyguard_itms = {
					order = 9,
					label = "|cff1eff00Bark|r/|cff1eff00Wing|r/|cff1eff00Leg|r/|cff1eff00Filet|r:",
					data = function(alt_data) return (alt_data.bodyguard_items and type(alt_data.bodyguard_items[1]) == "table" and self:MakeQuestString(alt_data.bodyguard_items,{[57139] = "B",[57141] = "W",[57142] = "L",[57143] = "F"})) or "-" end,
				},
				dummy_empty_line2 = {
					order = 10,
					data = function(alt_data) return " " end,
				},
				mechagon_wq = {
					order = 11,
					label = "Mecha WQ:",
					data = function(alt_data) return (alt_data.mechagon_wq and (type(alt_data.mechagon_wq)=="number" and alt_data.mechagon_wq .. "%") or (type(alt_data.mechagon_wq) == "boolean" and "|cff00ff00X|r")) or "0%" end,
				},
				operation_mechagon = {
					order = 12,
					label = "Operation: Mecha:",
					data = function(alt_data) return alt_data.mechagon or "-" end,
				},
			}
		},
		daily_unroll = {
			order = 4,
			data = "unroll",
			button_pos = 0,
			name = "Daily >",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Daily") end,
			rows = {
				--[[daily_heroic = {
					order = 0.5,
					label = heroic_label,
					data = function(alt_data) return alt_data.daily_heroic and "|cff00ff00+|r" or "\45" end,
				},
				rnd_bg = {
					order = 1,
					label = rndbg_label,
					data = function(alt_data) return (alt_data.rnd_bg==true and "|cff00ff00+|r") or "\45" end,
				},	
				line = {
					order = 1.5,
					data = function(alt_data) return " " end,
				},]]
				d_em = {
					order = 2,
					label = emissary_label..":",
					data = function(alt_data) return alt_data.d_em and (alt_data.d_em == 3 and "|cffff00003/3|r" or alt_data.d_em.."/3") or "\45" end,
				},
				em1 = {
					order = 2.5,
					label = "Emissary 1:",
					data = function(alt_data) return alt_data.em1 and self:MakeColoredString(alt_data.em1) or "\45" end,
				},
				em2 = {
					order = 3,
					label = "Emissary 2:",
					data = function(alt_data) return alt_data.em2 and self:MakeColoredString(alt_data.em2) or "\45" end,
				},
				em3 = {
					order = 3.5,
					label = "Emissary 3:",
					data = function(alt_data) return alt_data.em3 and self:MakeColoredString(alt_data.em3) or "\45" end,
				},
				contract = {
					order = 4,
					label = "Contract:",
					data = function(alt_data) return alt_data.contract and alt_data.contract or "\45" end,
				}
			}		
		},		
		weekly_unroll = {
			order = 5,
			data = "unroll",
			button_pos = 0,
			name = "Weekly >",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Weekly") end,
			rows = {
				arathi = {
					order = 1.5,
					label = "Arathi:",
					data = function(alt_data) return alt_data.warfrontQuests and self:MakeQuestString(alt_data.warfrontQuests,{[53416] = "Q", [56137] = "HC", [52848] = "WB"},1,3) end,
				},
				darkshore = {
					order = 2,
					label = "Darkshore:",
					data = function(alt_data) return alt_data.warfrontQuests and self:MakeQuestString(alt_data.warfrontQuests,{[53955] = "Q", [57959] = "HC", [54896] = "WB"},4,6)  end,
				},
				dummy_empty_line2 = {
					order = 2.5,
					data = function(alt_data) return " " end,
				},
				mythics_done = {
					order = 3,
					data = function(alt_data) return alt_data.moverall and self:MakeColoredString({alt_data.moverall,10}) or "-" end
				},	
				freehold = {
					order = 3.5,
					label = "FH:",
					data = function(alt_data) return alt_data.fh or "-" end
				},
				kingsrest = {
					order = 4,
					label = "KR:",
					data = function(alt_data) return alt_data.kr or "-" end
				},
				underrot = {
					order = 4.5,
					label = "UNDR:",
					data = function(alt_data) return alt_data.undr or "-" end
				},
			}
		},
		raid_unroll = {
			order = 6,
			data = "unroll",
			button_pos = 0,
			name = "Raids >",
			unroll_function = function(button, my_rows, default_state) AltManager:Unroll(button, my_rows, default_state, "Raids") end,
			rows = {
				uldir = {
					order = 0.5,
					label = "Uldir:",
					data = function(alt_data) return self:MakeRaidString(alt_data.uldir_lfr, alt_data.uldir_normal, alt_data.uldir_heroic, alt_data.uldir_mythic) end
				},
				bod = {
					order = 1,
					label = "BoD:",
					data = function(alt_data) return self:MakeRaidString(alt_data.bod_lfr, alt_data.bod_normal, alt_data.bod_heroic, alt_data.bod_mythic) end 
				},
				cos_raid = {
					order = 1.5,
					label = "CoS:",
					data = function(alt_data) return self:MakeRaidString(alt_data.cos_lfr, alt_data.cos_normal, alt_data.cos_heroic, alt_data.cos_mythic) end
				},
				ep_raid = {
					order = 2,
					label = "EP:",
					data = function(alt_data) return self:MakeRaidString(alt_data.ep_lfr, alt_data.ep_normal, alt_data.ep_heroic, alt_data.ep_mythic) end
				},
				nyalotha_raid = {
					order = 2.5,
					label = "Nyalotha:",
					data = function(alt_data) return self:MakeRaidString(alt_data.ny_lfr, alt_data.ny_normal, alt_data.ny_heroic, alt_data.ny_mythic) end,
				}
			}
		},
	}
	self.columns_table = column_table;

	-- create labels and unrolls
	local font_height = 20;
	local label_column = self.main_frame.label_column or CreateFrame("Button", nil, self.main_frame);
	if not self.main_frame.label_column then self.main_frame.label_column = label_column; end
	label_column:SetSize(per_alt_x, sizey);
	label_column:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", 4, -1);

	local i = 1;
	local buttonrows = {}
	for row_iden, row in spairs(self.columns_table, function(t, a, b) return t[a].order < t[b].order end) do
		if row.label then
			local label_row = self:CreateFontFrame(self.main_frame, per_alt_x, font_height, label_column, -(i-1)*font_height, row.label, "RIGHT");
			self.main_frame.lowest_point = -(i-1)*font_height;
		end
		if row.data == "unroll" then
			local bp = row.button_pos
			local order = row.order
			local w,h = row.w_size or 100, row.h_size or 25
			-- create a button that will unroll it
			local unroll_button = CreateFrame("Button", "UnrollButton"..i, self.main_frame, "UIPanelButtonTemplate");
			table.insert(buttonrows,{row_iden, row, unroll_button})
			unroll_button:SetText(row.name);
			unroll_button:SetFrameStrata("HIGH");
			--unroll_button:SetFrameLevel(self.main_frame:GetFrameLevel() - 1);
			unroll_button:SetSize(w, h);
			unroll_button:SetPoint("BOTTOMRIGHT", self.main_frame, "TOPLEFT", per_alt_x-(bp/1.6), -(floor(order))*h);
			
			if row.disable_drawLayer then
				unroll_button:DisableDrawLayer("BACKGROUND")
			end
			
			unroll_button:SetScript("OnClick", 
			function() 
				for x,r in ipairs(buttonrows) do
					local r_i, ro, u_b = r[1], r[2], r[3]
					if r_i ~= row_iden then
						ro.unroll_function(u_b, nil, "open")
					end
				end
				
				row.unroll_function(unroll_button, row.rows) 
			end);
			self.main_frame.lowest_point = -(i-1)*font_height;
		end
		i = i + 1
	end

end
function AltManager:activePois()
	local areaPoiIds = {[1527] = {6486, 6487, 6488}, [1530] = {6489, 6490, 6491}}

	local uldum, voeb, parentId
	for uiMapId, poiIds in pairs(areaPoiIds) do
		mapInfo = C_Map.GetMapInfo(uiMapId)
		for i=1, #poiIds do
			local active = mapInfo and C_AreaPoiInfo.GetAreaPOIInfo(mapInfo.parentMapID, poiIds[i])
			if uiMapId == 1527 and active then uldum = poiIds[i] end
			if uiMapId == 1530 and active then voeb = poiIds[i] end
		end
	end
	return uldum, voeb
end

function AltManager:MakeDungeonString(killed_bosses, bosses)
	local string = "-"
	if killed_bosses == bosses then 
		string = "|cff00ff00X|r"
	else
		string = killed_bosses .. "/" .. bosses
	end
	return string
end

function AltManager:MakeReputationString(rep)
	local value, max = rep[1], rep[2]
	max = max > 0 and max or 3000

	if max == 10000 then
		return string.format("|cff4287f5%s|r / %s",AbbreviateNumbers(value), AbbreviateNumbers(max))
	else
		return string.format("|cff00ff00%s|r / %s",AbbreviateNumbers(value), AbbreviateNumbers(max))
	end
end

function AltManager:MakeRaidString(lfr, normal, heroic, mythic)
	if not normal then normal = 0 end
	if not heroic then heroic = 0 end
	if not mythic then mythic = 0 end
	if not lfr then lfr = 0 end
	local string = ""
	if mythic > 0 then string = string .. tostring(mythic) .. "M" end
	if heroic > 0 and mythic > 0 then string = string .. "-" end
	if heroic > 0 then string = string .. tostring(heroic) .. "H" end
	if normal > 0 and (mythic > 0 or heroic > 0) then string = string .. "-" end
	if normal > 0 then string = string .. tostring(normal) .. "N" end
	if lfr > 0 and (mythic > 0 or heroic > 0 or normal > 0) then string = string .. "-" end
	if lfr > 0 then string = string .. tostring(lfr) .. "L" end
	return string == "" and "-" or string
end

function AltManager:MakeColoredString(emi)
	if type(emi) == "string" then return "old" end
	local fulfilled,required,title = unpack(emi)
	local progress
	if fulfilled >= required then
		progress = string.format("|cff00ff00%d / %d|r",fulfilled,required)
	elseif fulfilled > 0 then
		progress = string.format("|cffFF7D0A%d / %d|r",fulfilled,required)
	else
		progress = fulfilled .. " / " .. required
	end
	return title and string.format("%s - %s",title,progress) or progress
end

function AltManager:MakeQuestString(val, text, minI, maxI)
	local s
	local v, t

	if type(val[1]) == "table" then
		local min, max = 1, #val
		if minI and maxI then
			min, max = minI, maxI
		end

		local tbl
		for i=min, max do
			tbl = val[i]
			for id, v in pairs(tbl) do
				t = text[id]
				if v and t then
					if v == 0 then 
						s = s and s .. "/|cffff0000" .. t .. "|r" or "|cffff0000" .. t .. "|r"
					else
						s = s and s .. "/|cff00ff00" .. t .. "|r" or "|cff00ff00" .. t .. "|r"
					end
				end
			end
		end
	elseif #val==0 then
		for id, v in pairs(val) do
			t = text[id]
			if v and t then
				if v == 0 then 
					s = s and s .. "/|cffff0000" .. t .. "|r" or "|cffff0000" .. t .. "|r"
				else
					s = s and s .. "|/cff00ff00" .. t .. "|r" or "|cff00ff00" .. t .. "|r"
				end
			end
		end
	end
	
	return s
end

function AltManager:MakeEssenceString(rank)
	local coloredRank
	if rank == 1 then coloredRank = "|cff1eff00"..rank.."|r"
	elseif rank == 2 then coloredRank = "|cff0070dd"..rank.."|r"
	elseif rank == 3 then coloredRank = "|cffa335ee"..rank.."|r"
	elseif rank == 4 then coloredRank = "|cffff8000"..rank.."|r"
	end
	
	return coloredRank or "-"
end

function AltManager:HideInterface()
	if type(self.unroll_state) == "table" then
		for name, tbl in pairs(self.unroll_state) do
			if tbl.state == "open" then self:RollUp(tbl.unroll_frame, name, tbl.icon) end
		end
	end
	self.main_frame:Hide();
end

function AltManager:ShowInterface()
	self.main_frame:Show();
	self:StoreData(self:CollectData())
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
		
		frame.topPanelString = frame.topPanel:CreateFontString("Method name");
		frame.topPanelString:SetFont("Fonts\\FRIZQT__.TTF", 20)
		frame.topPanelString:SetTextColor(1, 1, 1, 1);
		frame.topPanelString:SetJustifyH("CENTER")
		frame.topPanelString:SetJustifyV("CENTER")
		frame.topPanelString:SetWidth(260)
		frame.topPanelString:SetHeight(20)
		frame.topPanelString:SetText("Method Alt Manager");
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
	if not self.resetDays then
		local region = self:GetRegion()
		if not region then return nil end
		self.resetDays = {}
		self.resetDays.DLHoffset = 0
		if region == "US" then
			self.resetDays["2"] = true -- tuesday
			-- ensure oceanic servers over the dateline still reset on tues UTC (wed 1/2 AM server)
			self.resetDays.DLHoffset = -3 
		elseif region == "EU" then
			self.resetDays["3"] = true -- wednesday
		elseif region == "CN" or region == "KR" or region == "TW" then -- XXX: codes unconfirmed
			self.resetDays["4"] = true -- thursday
		else
			self.resetDays["2"] = true -- tuesday?
		end
	end
	local offset = (self:GetServerOffset() + self.resetDays.DLHoffset) * 3600
	local nightlyReset = self:GetNextDailyResetTime()
	if not nightlyReset then return nil end
	while not self.resetDays[date("%w",nightlyReset+offset)] do
		nightlyReset = nightlyReset + 24 * 3600
	end
	return nightlyReset
end

function AltManager:GetNextDailyResetTime()
	local resettime = GetQuestResetTime()
	if not resettime or resettime <= 0 or resettime > 24*3600+30 then
		-- ticket 43: can fail during startup
		-- also right after a daylight savings rollover, when it returns negative values >.<
		-- can also be wrong near reset in an instance
		return
	end
	return resettime+GetServerTime()
end

function AltManager:GetServerOffset()
	local serverDay = C_DateAndTime.GetTodaysDate().weekDay - 1 -- 1-based starts on Sun
	local localDay = tonumber(date("%w")) -- 0-based starts on Sun
	local serverHour, serverMinute = GetGameTime()
	local localHour, localMinute = tonumber(date("%H")), tonumber(date("%M"))
	if serverDay == (localDay + 1)%7 then -- server is a day ahead
		serverHour = serverHour + 24
	elseif localDay == (serverDay + 1)%7 then -- local is a day ahead
		localHour = localHour + 24
	end
	local server = serverHour + serverMinute / 60
	local localT = localHour + localMinute / 60
	local offset = floor((server - localT) * 2 + 0.5) / 2
	return offset
end

function AltManager:GetRegion()
	if not self.region then
		local reg
		reg = GetCVar("portal")
		if reg == "public-test" then -- PTR uses US region resets, despite the misleading realm name suffix
			reg = "US"
		end
		if not reg or #reg ~= 2 then
			local gcr = GetCurrentRegion()
			reg = gcr and ({ "US", "KR", "EU", "TW", "CN" })[gcr]
		end
		if not reg or #reg ~= 2 then
			reg = (GetCVar("realmList") or ""):match("^(%a+)%.")
		end
		if not reg or #reg ~= 2 then -- other test realms?
			reg = (GetRealmName() or ""):match("%((%a%a)%)")
		end
		reg = reg and reg:upper()
		if reg and #reg == 2 then
			self.region = reg
		end
	end
	return self.region
end

function AltManager:GetWoWDate()
	local hour = tonumber(date("%H"));
	local day = C_DateAndTime.GetTodaysDate().weekDay
	return day, hour;
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
