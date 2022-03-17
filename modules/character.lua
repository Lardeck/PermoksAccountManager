local addonName, PermoksAccountManager = ...
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local LibQTip = LibStub('LibQTip-1.0')
local options

local module = 'character'
local labelRows = {
    characterName = {
        hideLabel = true,
        label = L['Name'],
        hideOption = true,
        big = true,
        offset = 1.5,
		type = 'characterName',
        data = function(alt_data)
            return PermoksAccountManager:CreateCharacterString(alt_data.name, alt_data.specInfo)
        end,
        color = function(alt_data)
            return RAID_CLASS_COLORS[alt_data.class]
        end,
        version = false
    },
    characterLevel = {
        label = L['Level'],
		type = 'charLevel',
        data = function(alt_data)
            return alt_data.charLevel or '-'
        end,
        group = 'character',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    location = {
        label = L['Location'],
        data = function(alt_data)
            return (alt_data.location and PermoksAccountManager:CreateLocationString(alt_data.location)) or '-'
        end,
        group = 'character',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    ilevel = {
        label = L['Item Level'],
        data = function(alt_data)
            return string.format('%.2f', alt_data.ilevel or 0)
        end,
        version = WOW_PROJECT_MAINLINE
    },
    gold = {
        label = L['Gold'],
		type = 'gold',
        group = 'currency',
        version = false
    },
    keystone = {
        label = L['Keystone'],
		type = 'keystone',
        group = 'dungeons',
        version = WOW_PROJECT_MAINLINE
    },
    weekly_key = {
        label = L['Highest Key'],
		type = 'weeklyKey',
        tooltip = true,
        customTooltip = function(button, alt_data)
            PermoksAccountManager:HighestKeyTooltip_OnEnter(button, alt_data)
        end,
        isComplete = function(alt_data)
            return alt_data.vaultInfo and alt_data.vaultInfo.MythicPlus and alt_data.vaultInfo.MythicPlus[1].level >= 15
        end,
        group = 'character',
        version = WOW_PROJECT_MAINLINE
    },
    mplus_score = {
        label = L['Mythic+ Score'],
        outline = "OUTLINE",
		type = 'dungeonScore',
        group = 'character',
        version = WOW_PROJECT_MAINLINE
    },
    contract = {
        label = L['Contract'],
		type = 'contract',
        group = 'character',
        version = WOW_PROJECT_MAINLINE
    }
}

local function UpdateGeneralData(charInfo)
    local self = PermoksAccountManager

    if not self.isBC then
        charInfo.ilevel = select(2, GetAverageItemLevel())

        -- Contracts
        local contract = nil
        local contracts = {[311457] = 'CoH', [311458] = 'Ascended', [311460] = 'UA', [311459] = 'WH', [353999] = 'DA'}
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

local function UpdateKeystones(charInfo)
    if PermoksAccountManager.isBC then return end


    charInfo.keyInfo = charInfo.keyInfo or {}
	C_Timer.After(0.5, function()
		local ownedKeystone = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local keyInfo = charInfo.keyInfo
		keyInfo.keyDungeon = ownedKeystone and PermoksAccountManager.keys[ownedKeystone] or L['No Key']
		keyInfo.keyLevel = ownedKeystone and C_MythicPlus.GetOwnedKeystoneLevel() or 0
	end)
end

local function UpdateGold(charInfo)
    charInfo.gold = floor(GetMoney() / (COPPER_PER_SILVER * SILVER_PER_GOLD)) * 10000
end

local function UpdateILevel(charInfo)
    if not PermoksAccountManager.isBC then
        charInfo.ilevel = select(2, GetAverageItemLevel())
    end
end

local function UpdateMythicScore(charInfo)
   if PermoksAccountManager.isBC then return end

    C_MythicPlus.RequestMapInfo()
    charInfo.mythicScore = C_ChallengeMode.GetOverallDungeonScore()

end

local function UpdateMythicPlusHistory(charInfo)
    charInfo.mythicPlusHistory = C_MythicPlus.GetRunHistory(nil, true)
end

local function UpdatePlayerSpecialization(charInfo)
    charInfo.specInfo = {GetSpecializationInfo(GetSpecialization())}
end

local function UpdatePlayerLevel(charInfo, level)
    charInfo.charLevel = level or UnitLevel('player')
end

local function UpdateLocation(charInfo)
    charInfo.location = C_Map.GetBestMapForUnit('player')
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

local function CreateGoldString(gold)
	return gold and tonumber(gold) and GetMoneyString(gold, true) or '-'
end

local function CreateCharacterString(name, specInfo)
    if not name then
        return '-'
    end

    local specString
    if specInfo and PermoksAccountManager.db.global.options.showCurrentSpecIcon then
        specString = string.format('\124T%d:0\124t', specInfo[4])
    end

    return string.format('%s %s', name, specString or '')
end

local function CreateKeystoneString(keyInfo)
    if not keyInfo or not type(keyInfo) == "table" then
        return 'Unknown'
    end

	if keyInfo.keyLevel == 0 then
		return string.format('%s', keyInfo.keyDungeon)
	end
    return string.format('%s+%d', keyInfo.keyDungeon, keyInfo.keyLevel)
end

local function CreateDungeonScoreString(score)
    if not score then
        return '-'
    end

    if PermoksAccountManager.db.global.options.useScoreColor then
        local color = C_ChallengeMode.GetDungeonScoreRarityColor(score)
        return color:WrapTextInColorCode(AbbreviateLargeNumbers(score))
    else
        return AbbreviateLargeNumbers(score)
    end
end

local function CreateWeeklyString(vaultInfo)
    if not vaultInfo or not vaultInfo.MythicPlus then
        return '-'
    end

    local activityInfo = vaultInfo.MythicPlus[1]
    if not activityInfo or activityInfo.level == 0 then
        return '-'
    end

    return string.format('+%d', activityInfo.level)
end

local function CreateContractString(contractInfo)
    if not contractInfo then
        return '-'
    end

	local seconds = PermoksAccountManager:GetSecondsRemaining(contractInfo.expirationTime)
	local timeString = SecondsToTime(seconds)
    return string.format('%s - %s', contractInfo.faction, PermoksAccountManager:FormatTimeString(seconds, timeString))
end

local payload = {
    update = Update,
    events = {
        ['PLAYER_MONEY'] = UpdateGold,
        ['PLAYER_AVG_ITEM_LEVEL_UPDATE'] = UpdateILevel,
        ['PLAYER_SPECIALIZATION_CHANGED'] = UpdatePlayerSpecialization,
        ['CHALLENGE_MODE_MAPS_UPDATE'] = {UpdateMythicScore, UpdateMythicPlusHistory},
        ['BAG_UPDATE_DELAYED'] = {UpdateGeneralData, UpdateKeystones},
		['ITEM_CHANGED'] = UpdateKeystones,
        ['WEEKLY_REWARDS_UPDATE'] = UpdateMythicScore,
        ['PLAYER_LEVEL_UP'] = UpdatePlayerLevel,
        ['ZONE_CHANGED'] = UpdateLocation,
        ['ZONE_CHANGED_NEW_AREA'] = UpdateLocation,
        ['ZONE_CHANGED_INDOORS'] = UpdateLocation
    },
    share = {
        [UpdateGold] = 'gold',
        [UpdateILevel] = 'ilevel',
        [UpdatePlayerSpecialization] = 'specInfo',
        [UpdateMythicPlusHistory] = 'mythicPlusHistory',
        [UpdateMythicScore] = 'mythicScore',
        [UpdatePlayerLevel] = 'charLevel'
    },
    labels = labelRows
}
local module = PermoksAccountManager:AddModule(module, payload)
module:AddCustomLabelType('gold', CreateGoldString, true, 'gold')
module:AddCustomLabelType('characterName', CreateCharacterString, nil, 'name', 'specInfo')
module:AddCustomLabelType('keystone', CreateKeystoneString, nil, 'keyInfo')
module:AddCustomLabelType('dungeonScore', CreateDungeonScoreString, true, 'mythicScore')
module:AddCustomLabelType('weeklyKey', CreateWeeklyString, nil, 'vaultInfo')
module:AddCustomLabelType('contract', CreateContractString, nil, 'contractInfo')

function PermoksAccountManager:CreateLocationString(mapId)
    if not mapId then
        return
    end
    local mapInfo = C_Map.GetMapInfo(mapId)
    return mapInfo and mapInfo.name
end

function PermoksAccountManager:HighestKeyTooltip_OnEnter(button, alt_data)
    if not alt_data or not alt_data.mythicPlusHistory or #alt_data.mythicPlusHistory < 2 then
        return
    end

    local runs = {}
    for run, info in ipairs(alt_data.mythicPlusHistory) do
        tinsert(runs, info.level)
    end

    table.sort(
        runs,
        function(a, b)
            return a > b
        end
    )

    for i in ipairs(runs) do
        if i == 1 or i == 4 or i == 8 then
            runs[i] = string.format('|cff00f7ff%d|r', runs[i])
        end
    end

    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 1, 'LEFT')
    button.tooltip = tooltip

    tooltip:AddLine(table.concat(runs, ', '))
    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end
