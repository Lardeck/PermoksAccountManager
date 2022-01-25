local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local options

local module = "character"
local labelRows = {
	characterName = {
		hideLabel = true,
		label = L["Name"],
		hideOption = true,
		big = true,
		offset = 1.5,
		data = function(alt_data) return PermoksAccountManager:CreateCharacterString(alt_data.name, alt_data.specInfo) end,
		color = function(alt_data) return RAID_CLASS_COLORS[alt_data.class] end,
    version = false,
	},
  characterLevel = {
		label = L["Level"],
		data = function(alt_data) return alt_data.charLevel or "-" end,
		group = "character",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
  location = {
		label = L["Location"],
		data = function(alt_data) return (alt_data.location and PermoksAccountManager:CreateLocationString(alt_data.location)) or "-" end,
		group = "character",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	ilevel = {
		label = L["Item Level"],
		data = function(alt_data) return string.format("%.2f", alt_data.ilevel or 0) end,
    version = WOW_PROJECT_MAINLINE,
	},
	gold = {
		label = L["Gold"],
		option = "gold",
		data = function(alt_data) return alt_data.gold and tonumber(alt_data.gold) and GetMoneyString(alt_data.gold, true) or "-" end,
		group = "currency",
    version = false,
	},	
	keystone = {
		label = L["Keystone"],
		data = function(alt_data) return PermoksAccountManager:CreateKeystoneString(alt_data.keyDungeon, alt_data.keyLevel) end,
		group = "dungeons",
    version = WOW_PROJECT_MAINLINE,
	},
	weekly_key = {
		label = L["Highest Key"],
		data = function(alt_data) return alt_data.vaultInfo and PermoksAccountManager:CreateWeeklyString(alt_data.vaultInfo.MythicPlus) or "-" end,
		tooltip = true,
		customTooltip = function(button, alt_data) PermoksAccountManager:HighestKeyTooltip_OnEnter(button, alt_data) end,
		isComplete = function(alt_data) return alt_data.vaultInfo and alt_data.vaultInfo.MythicPlus and alt_data.vaultInfo.MythicPlus[1].level >= 15 end,
		group = "character",
    version = WOW_PROJECT_MAINLINE,
	},
	mplus_score = {
		label = L["Mythic+ Score"],
		--outline = "OUTLINE",
		data = function(alt_data) return PermoksAccountManager:CreateScoreString(alt_data.mythicScore) or "-" end,
		group = "character",
    version = WOW_PROJECT_MAINLINE,
	},	
	contract = {
		label = L["Contract"],
		data = function(alt_data) return alt_data.contract and PermoksAccountManager:CreateContractString(alt_data.contract) or "-" end,
		group = "character",
    version = WOW_PROJECT_MAINLINE,
	},
}

local function UpdateGeneralData(charInfo)
	local self = PermoksAccountManager

	if not self.isBC then
		charInfo.ilevel = select(2, GetAverageItemLevel())

		-- Keystone
		local ownedKeystone = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		charInfo.keyDungeon = ownedKeystone and self.keys[ownedKeystone] or L["No Key"]
		charInfo.keyLevel = ownedKeystone and C_MythicPlus.GetOwnedKeystoneLevel() or 0

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
		charInfo.contract = contract

		-- Covenant
		local covenant = C_Covenants.GetActiveCovenantID()
		charInfo.covenant = covenant > 0 and covenant or nil
		charInfo.callingsUnlocked = C_CovenantCallings.AreCallingsUnlocked()
	end
end

local function UpdateGold(charInfo)
	charInfo.gold = floor(GetMoney() / (COPPER_PER_SILVER * SILVER_PER_GOLD)) * 10000
end

local function UpdateILevel(charInfo)
	charInfo.ilevel = select(2, GetAverageItemLevel())
end

local function UpdateMythicScore(charInfo)
	charInfo.mythicScore = C_ChallengeMode.GetOverallDungeonScore and C_ChallengeMode.GetOverallDungeonScore()
end

local function UpdateMythicPlusHistory(charInfo)
	charInfo.mythicPlusHistory = C_MythicPlus.GetRunHistory()
end

local function UpdatePlayerSpecialization(charInfo)
	charInfo.specInfo = {GetSpecializationInfo(GetSpecialization())}
end

local function UpdatePlayerLevel(charInfo, level)
	charInfo.charLevel = level or UnitLevel("player")
end

local function UpdateLocation(charInfo)	
	charInfo.location = C_Map.GetBestMapForUnit("player")
end

local function Update(charInfo)
	UpdateGeneralData(charInfo)
	UpdateGold(charInfo)

  if PermoksAccountManager.isBC then
    UpdatePlayerLevel(charInfo)
    UpdateLocation(charInfo)
  else
    UpdateILevel(charInfo)
    UpdatePlayerSpecialization(charInfo)
    UpdateMythicScore(charInfo)
    UpdateMythicPlusHistory(charInfo)
  end
end

function PermoksAccountManager:CreateLocationString(mapId)
	if not mapId then return end
	local mapInfo = C_Map.GetMapInfo(mapId)
	return mapInfo and mapInfo.name
end

local payload = {
	update = Update,
	events = {
		["PLAYER_MONEY"] = UpdateGold,
		["PLAYER_AVG_ITEM_LEVEL_UPDATE"] = UpdateILevel,
		["PLAYER_SPECIALIZATION_CHANGED"] = UpdatePlayerSpecialization,
		["CHALLENGE_MODE_MAPS_UPDATE"] = {UpdateMythicScore, UpdateMythicPlusHistory},
		["BAG_UPDATE_DELAYED"] = UpdateGeneralData,
		["WEEKLY_REWARDS_UPDATE"] = UpdateMythicScore,
		["PLAYER_LEVEL_UP"] = UpdatePlayerLevel,
    ["ZONE_CHANGED"] = UpdateLocation,
    ["ZONE_CHANGED_NEW_AREA"] = UpdateLocation,
    ["ZONE_CHANGED_INDOORS"] = UpdateLocation,
	},
	share = {
		[UpdateGold] = "gold",
		[UpdateILevel] = "ilevel",
		[UpdatePlayerSpecialization] = "specInfo",
		[UpdateMythicPlusHistory] = "mythicPlusHistory",
		[UpdateMythicScore] = "mythicScore",
		[UpdatePlayerLevel] = "charLevel"
	},
	labels = labelRows
}
PermoksAccountManager:AddModule(module, payload)

function PermoksAccountManager:CreateCharacterString(name, specInfo)
	if not name then return "-" end

	local specString
	if specInfo and self.db.global.options.showCurrentSpecIcon then
		specString = string.format("\124T%d:0\124t", specInfo[4])
	end

	return string.format("%s %s", name, specString or "")
end

function PermoksAccountManager:CreateKeystoneString(dungeon, level)
	if not dungeon or not level then return "-" end

	if level == 0 then
		return dungeon
	else
		return string.format("%s+%d", dungeon, level)
	end
end

function PermoksAccountManager:CreateScoreString(score)
	if not score then return end


	if self.db.global.options.useScoreColor then
		local color = C_ChallengeMode.GetDungeonScoreRarityColor(score)
		return color:WrapTextInColorCode(AbbreviateLargeNumbers(score))
	else
		return AbbreviateLargeNumbers(score)
	end
end

function PermoksAccountManager:CreateWeeklyString(vaultInfo)
	if not vaultInfo then return end
	local activityInfo = vaultInfo[1]
	if not activityInfo or activityInfo.level == 0 then return end

	return string.format("+%d", activityInfo.level)
end

function PermoksAccountManager:CreateContractString(contractInfo)
	if not contractInfo then return end
	local days, hours, minutes = self:TimeToDaysHoursMinutes(contractInfo.expirationTime)

	return string.format("%s - %s", contractInfo.faction, self:CreateTimeString(days, hours, minutes))
end