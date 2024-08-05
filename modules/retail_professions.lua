local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local options

local module = 'retail_professions'
local labelRows = {
    profession1CDs = {
        label = 'Profession 1 (NYI)',
        tooltip = function(button, alt_data)
            PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, alt_data.professions[1])
        end,
        data = function(alt_data)
            return alt_data.professions and alt_data.professionCDs and PermoksAccountManager:CreateProfessionString(alt_data.professions[1], alt_data.professionCDs) or '-'
        end,
        group = 'profession',
        version = WOW_PROJECT_MAINLINE
    },
    profession2CDs = {
        label = 'Profession 2 (NYI)',
        tooltip = function(button, alt_data)
            PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, alt_data.professions[2])
        end,
        data = function(alt_data)
            return alt_data.professions and alt_data.professionCDs and PermoksAccountManager:CreateProfessionString(alt_data.professions[2], alt_data.professionCDs) or '-'
        end,
        group = 'profession',
        version = WOW_PROJECT_MAINLINE
    },
    profession1_concentration = {
        label = 'Concentration P1 (NYI)',
        tooltip = function(button, alt_data)
            PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, alt_data.professions[1])
        end,
        data = function(alt_data)
            return alt_data.professions and alt_data.professionCDs and PermoksAccountManager:CreateProfessionString(alt_data.professions[2], alt_data.professionCDs) or '-'
        end,
        group = 'profession',
        version = WOW_PROJECT_MAINLINE
    },
    profession2_concentration = {
        label = 'Concentration P2 (NYI)',
        tooltip = function(button, alt_data)
            PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, alt_data.professions[2])
        end,
        data = function(alt_data)
            return alt_data.professions and alt_data.professionCDs and PermoksAccountManager:CreateProfessionString(alt_data.professions[2], alt_data.professionCDs) or '-'
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

local function UpdateChildConcentration(professionChild)

end

local function CalculateConcentration(lastUpdated,professionChild)

end

local function UpdateCharConcentration(charInfo)

    for _, profession in pairs(charInfo.professions) do

        if charInfo.guid == UnitGUID('Player') then
            profession.lastUpdated = time()
            print('yep this is you')
            --SEPARATE FOR INDIVIDUAL UPDATE OF CHILDS
            for _, child in pairs(profession.childProfessions) do
                local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(child.concentrationCurrency)

                child.concentrationMax = currencyInfo.maxQuantity
                child.concentrationQuantity = currencyInfo.quantity
                child.concentrationRechargeTime = 0
            end

        else
            for _, child in pairs(profession.childProfessions) do
                child = CalculateConcentration(profession.lastUpdated, child)
            end

        end
    end
end

function PermoksAccountManager:UpdateConcentration(charInfo)
    local professions = charInfo.professions
    --do something to update professions[profession].childprofessions[child].concentrationQuantity
end

local function UpdateChildProfessionInfo(profession)
    local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(profession.SkillLineID)
    local concentration = C_TradeSkillUI.GetConcentrationCurrencyID(profession.SkillLineID)

    print('updating child: ' ..  info.professionName)

    return {
        SkillLineID = profession.skillLineID,
        name = info.professionName,
        concentrationCurrency = concentration,
        concentrationMax = 0,
        concentrationQuantity = 0,
        concentrationRechargeTime = 0,
        }
end

local function UpdateProfessionInfo(professionID)
    if not professionID then
        return
    end

    local self = PermoksAccountManager
    local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(professionID)

    local childProfessions = {}
    for _, expansion in pairs(self.childProfessions) do
        local child = expansion[professionID]
        if IsPlayerSpell(child.spellID) then
            childProfessions[child['SkillLineID']] = UpdateChildProfessionInfo(child)
        end
    end

    return {
        SkillLineID = professionID,
        name = info.professionName,
        childProfessions = childProfessions,
        lastUpdated = 0,
    }
end

-- Need to rewrite most of this stuff. I hate the classic API
local function UpdateProfessions(charInfo)
    local self = PermoksAccountManager
    --replacing profession-table ID with SkillLineID
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

function PermoksAccountManager:CreateProfessionString(professionInfo, professionCDs)
    
end

function PermoksAccountManager:ProfessionTooltip_OnEnter(button, alt_data, professionInfo)

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
