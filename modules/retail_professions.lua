local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local options

local module = 'retail_professions'
local labelRows = {
    profession1CDs = {
        label = 'Profession 1 (NYI)',
        tooltip = function(button, alt_data)
            PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, alt_data.professions.profession1)
        end,
        data = function(alt_data)
            return alt_data.professions and alt_data.professionCDs and PermoksAccountManager:CreateProfessionString(alt_data.professions.profession1, alt_data.professionCDs) or '-'
        end,
        group = 'profession',
        version = WOW_PROJECT_MAINLINE
    },
    profession2CDs = {
        label = 'Profession 2 (NYI)',
        tooltip = function(button, alt_data)
            PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, alt_data.professions.profession2)
        end,
        data = function(alt_data)
            return alt_data.professions and alt_data.professionCDs and PermoksAccountManager:CreateProfessionString(alt_data.professions.profession2, alt_data.professionCDs) or '-'
        end,
        group = 'profession',
        version = WOW_PROJECT_MAINLINE
    },
    profession1_concentration_df = {
        label = 'DF Concentration P1 (NYI)',
        type = 'concentration',
        key = 'df_profession',
        passRow = true,
        tooltip = true,
        customTooltip = function(button, alt_data)
            if alt_data.professions and alt_data.professions.profession1 then
                PermoksAccountManager:ConcentrationTooltip_OnEnter(button, alt_data, alt_data.professions.profession1)
            end
        end,
        group = 'profession',
        version = WOW_PROJECT_MAINLINE
    },
    profession2_concentration_df = {
        label = 'DF Concentration P2 (NYI)',
        type = 'concentration',
        key = 'df_profession',
        passRow = true,
        tooltip = true,
        customTooltip = function(button, alt_data)
            if alt_data.professions and alt_data.professions.profession2 then
                PermoksAccountManager:ConcentrationTooltip_OnEnter(button, alt_data, alt_data.professions.profession2)
            end
        end,
        group = 'profession',
        version = WOW_PROJECT_MAINLINE        
    },
}

-- https://github.com/Stanzilla/WoWUIBugs/issues/47
local function GetCooldownLeft(start, duration)
    -- Before restarting the GetTime() will always be greater than [start]
    -- After the restart, [start] is technically always bigger because of the 2^32 offset thing
    if start < GetTime() then
        local cdEndTime = start + duration
        local cdLeftDuration = cdEndTime - GetTime()

        return cdLeftDuration
    end

    local time = time()
    local startupTime = time - GetTime()
    -- just a simplification of: ((2^32) - (start * 1000)) / 1000
    local cdTime = (2 ^ 32) / 1000 - start
    local cdStartTime = startupTime - cdTime
    local cdEndTime = cdStartTime + duration
    local cdLeftDuration = cdEndTime - time

    return cdLeftDuration
end

local function UpdateChildConcentration(child)
    local concentrationInfo = C_CurrencyInfo.GetCurrencyInfo(child.concentrationCurrency)

    child.lastUpdated =  GetServerTime()
    child.concentrationQuantity = concentrationInfo.quantity
    
    local concentrationDelta = child.concentrationMax - concentrationInfo.quantity
    if concentrationDelta == 0 then
        child.concentrationCapTime = 0
    elseif concentrationDelta > 0 then
        local timeTilMax = math.ceil(concentrationDelta * child.concentrationSecondsPerRecharge)
        child.concentrationCapTime = child.lastUpdated + timeTilMax
    end

    local formattedDate = date("%Y-%m-%d %H:%M:%S", child.concentrationCapTime)
    print(child.name .. ' concentration capped at ' .. formattedDate)
end

local function CalculateChildConcentration(child)
    if child.concentrationCapTime and child.concentrationCapTime > 0 then
        child.lastUpdated = GetServerTime()

        local timeUntilMax = math.max(child.concentrationCapTime - child.lastUpdated, 0)

        if timeUntilMax > 0 then
            local concentrationDelta = timeUntilMax / child.concentrationSecondsPerRecharge
            child.concentrationQuantity = math.floor(child.concentrationMax - concentrationDelta)
        else
            child.concentrationQuantity = child.concentrationMax
            child.concentrationCapTime = 0
        end
    end
end

local function UpdateCharConcentration(charInfo)
    local isPlayer = charInfo.guid == UnitGUID('Player')

    for _, profession in pairs(charInfo.professions) do
        if profession.childProfessions then
            for _, child in pairs(profession.childProfessions) do

                if isPlayer and child.concentrationCurrency then
                    UpdateChildConcentration(child)
                elseif child.concentrationCurrency then
                    CalculateChildConcentration(child)
                end

            end
        end
    end
end

function PermoksAccountManager:UpdateConcentration()
    for _, char in pairs(self.account.data) do
        UpdateCharConcentration(char)
    end
end

local function UpdateChildProfessionInfo(profession)
    local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(profession.skillLineID)
    local concentration = C_TradeSkillUI.GetConcentrationCurrencyID(profession.skillLineID)

    if concentration == 0 then
        return {
            skillLineID = profession.skillLineID,
            name = info.professionName,
        }
    end

    local concentrationInfo = C_CurrencyInfo.GetCurrencyInfo(concentration)

    print('updating child: ' ..  info.professionName .. 'skillLineID ' .. profession.skillLineID)

    return {
        skillLineID = profession.skillLineID,
        name = info.professionName,
        concentrationCurrency = concentration,
        concentrationMax = concentrationInfo.maxQuantity,
        concentrationSecondsPerRecharge = concentrationInfo.rechargingCycleDurationMS / (concentrationInfo.rechargingAmountPerCycle * 1000),
        concentrationQuantity = 0,
        concentrationCapTime = 0,
        lastUpdated = 0,
        }
end

local function UpdateProfessionInfo(professionID)
    if not professionID then
        return
    end

    local self = PermoksAccountManager
    local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(professionID)

    local childProfessions = {}
    for expansion, profession in pairs(self.childProfessions) do
        local child = profession[professionID]
        if IsPlayerSpell(child.spellID) then
            childProfessions[expansion] = UpdateChildProfessionInfo(child)
        end
    end

    return {
        skillLineID = professionID,
        name = info.professionName,
        childProfessions = childProfessions,
    }
end

-- Need to rewrite most of this stuff. I hate the classic API
local function UpdateProfessions(charInfo)
    local self = PermoksAccountManager
    --replacing profession-table ID with skillLineID
    local profession1, profession2 = GetProfessions()
    profession1 = profession1 and select(7, GetProfessionInfo(profession1))
    profession2 = profession2 and select(7, GetProfessionInfo(profession2))

    charInfo.professions = {
        profession1 = UpdateProfessionInfo(profession1),
        profession2 = UpdateProfessionInfo(profession2),
    }
end

local function UpdateProfessionCDs(charInfo)

end

function PermoksAccountManager:CreateProfessionString(professions, professionCDs)
    
end

local function CreateConcentrationString(labelRow, professions)
    if not professions then return '-' end
    return labelRow.key
end

function PermoksAccountManager:ConcentrationTooltip_OnEnter(button, altData, labelRow)
    if not altData.professions and altData.professions then
        return
    end

end

function PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, professions)

end



local function Update(charInfo)
    UpdateProfessions(charInfo)
    UpdateProfessionCDs(charInfo)
    UpdateCharConcentration(charInfo)
end

local payload = {
    update = Update,
    events = {
        ['TRADE_SKILL_UPDATE'] = UpdateProfessions,
        --['BAG_UPDATE_DELAYED'] = UpdateProfessionCDs
    },
    labels = labelRows
}
local module = PermoksAccountManager:AddModule(module, payload)
module:AddCustomLabelType('concentration', CreateConcentrationString, nil, 'professions')
