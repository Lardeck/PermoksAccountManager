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
    }
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

-- Need to rewrite most of this stuff. I hate the classic API
local function UpdateProfessions(charInfo)
    local profession1, profession2 = GetProfessions()
    charInfo.professions = {
        profession1 and select(7, GetProfessionInfo(profession1)),
        profession2 and select(7, GetProfessionInfo(profession2)),
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
end

local payload = {
    update = Update,
    events = {
        ['TRADE_SKILL_UPDATE'] = UpdateProfessions,
        --['BAG_UPDATE_DELAYED'] = UpdateProfessionCDs
    },
    labels = labelRows
}
PermoksAccountManager:AddModule(module, payload)
