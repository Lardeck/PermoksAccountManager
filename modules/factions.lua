local addonName, PermoksAccountManager = ...
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local FACTION_BAR_COLORS_CUSTOM, FACTION_STANDING_LABEL_CUSTOM = {}, {}
do
    for standingID, color in pairs(FACTION_BAR_COLORS) do
        FACTION_BAR_COLORS_CUSTOM[standingID] = {r = color.r * 256, g = color.g * 256, b = color.b * 256}
    end
    FACTION_BAR_COLORS_CUSTOM[9] = {r = 16, g = 165, b = 202}

    for i = 1, 8 do
        FACTION_STANDING_LABEL_CUSTOM[i] = GetText('FACTION_STANDING_LABEL' .. i)
    end
    FACTION_STANDING_LABEL_CUSTOM[9] = 'Paragon'
end

local labelRows = {
    archivists = {
        label = L['Archivists'],
        type = 'faction',
        key = 2472,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    deaths_advance = {
        label = function()
            return PermoksAccountManager.factions[2470].localName or L["Death's Advance"]
        end,
        type = 'faction',
        key = 2470,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    venari = {
        label = function()
            return PermoksAccountManager.factions[2432].localName or L["Ve'nari"]
        end,
        type = 'faction',
        key = 2432,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    ascended = {
        label = function()
            return PermoksAccountManager.factions[2407].localName or L['Ascended']
        end,
        type = 'faction',
        key = 2407,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    wild_hunt = {
        label = function()
            return PermoksAccountManager.factions[2465].localName or L['Wild Hunt']
        end,
        type = 'faction',
        key = 2465,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    undying_army = {
        label = function()
            return PermoksAccountManager.factions[2410].localName or L['Undying Army']
        end,
        type = 'faction',
        key = 2410,
        group = 'reputation'
    },
    court_of_harvesters = {
        label = function()
            return PermoksAccountManager.factions[2413].localName or L['Court of Harvesters']
        end,
        type = 'faction',
        key = 2413,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    the_enlightened = {
        label = function()
            return PermoksAccountManager.factions[2478].localName or L['The Enlightened']
        end,
        type = 'faction',
        key = 2478,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    automaton = {
        label = function()
            return PermoksAccountManager.factions[2480].localName or L['Automaton']
        end,
        type = 'faction',
        key = 2480,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    -- tbc
    theAldor = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[932]
            return factionInfo.localName or factionInfo.name
        end,
        key = 932,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    theScryers = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[934]
            return factionInfo.localName or factionInfo.name
        end,
        key = 934,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    silvermoonCity = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[911]
            return factionInfo.localName or factionInfo.name
        end,
        key = 911,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    exodar = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[930]
            return factionInfo.localName or factionInfo.name
        end,
        key = 930,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    theShatar = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[935]
            return factionInfo.localName or factionInfo.name
        end,
        key = 935,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    cenarionExpedition = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[942]
            return factionInfo.localName or factionInfo.name
        end,
        key = 942,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    honorHold = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[946]
            return factionInfo.localName or factionInfo.name
        end,
        key = 946,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    thrallmar = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[947]
            return factionInfo.localName or factionInfo.name
        end,
        key = 947,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    keepersOfTime = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[989]
            return factionInfo.localName or factionInfo.name
        end,
        key = 989,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    lowerCity = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1011]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1011,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    theConsortium = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[933]
            return factionInfo.localName or factionInfo.name
        end,
        key = 933,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    theVioletEye = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[967]
            return factionInfo.localName or factionInfo.name
        end,
        key = 967,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    sporeggar = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[970]
            return factionInfo.localName or factionInfo.name
        end,
        key = 970,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    theScaleOfTheSands = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[990]
            return factionInfo.localName or factionInfo.name
        end,
        key = 990,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    netherwing = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1015]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1015,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    ogrila = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1038]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1038,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    shatteredSunOffensive = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1077]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1077,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    theMaghar = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[941]
            return factionInfo.localName or factionInfo.name
        end,
        key = 941,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    },
    kurenai = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[978]
            return factionInfo.localName or factionInfo.name
        end,
        key = 978,
        type = 'faction',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
        group = 'reputation'
    }
}

local function GetFactionOrFriendshipInfo(factionId, factionType)
    local hasReward
    local name, _, standing, barMin, barMax, barValue = GetFactionInfoByID(factionId)
    local isParagon = C_Reputation.IsFactionParagon(factionId)

    if isParagon then
        barValue, barMax, _, hasReward = C_Reputation.GetFactionParagonInfo(factionId)
        barMin, standing, barValue = 0, 9, barValue % barMax
    elseif factionType == 'friend' then
        barValue, _, _, _, _, standing, barMin, barMax = select(2, GetFriendshipReputation(factionId))
    end

    if not barMax or not barMin then
        return
    end
    return barValue - barMin, (barMax - barMin), standing, name, hasReward
end

local function UpdateFactions(charInfo)
    local self = PermoksAccountManager

    charInfo.factions = charInfo.factions or {}
    local factions = charInfo.factions

    for factionId, info in pairs(self.factions) do
        local current, maximum, standing, name, hasReward = GetFactionOrFriendshipInfo(factionId, info.type)

        factions[factionId] = factions[factionId] or {}
        factions[factionId].standing = standing
        factions[factionId].current = current
        factions[factionId].max = maximum
        factions[factionId].type = info.type
        factions[factionId].hasReward = hasReward
        factions[factionId].exalted = not info.paragon and standing == 8

        if not info.localName then
            info.localName = name
        end
    end
end

local function Update(charInfo)
    UpdateFactions(charInfo)
end

local module = 'factions'
local payload = {
    update = Update,
    labels = labelRows,
    events = {
        ['UPDATE_FACTION'] = UpdateFactions
    },
    share = {
        [UpdateFactions] = 'factions'
    }
}
PermoksAccountManager:AddModule(module, payload)

function PermoksAccountManager:CreateFactionString(factionInfo)
    if not factionInfo then
        return
    end
    if not factionInfo.standing then
        return 'No Data'
    end
    if factionInfo.exalted then
        return string.format('|cff00ff00%s|r', L['Exalted'])
    end

    local standingColor, standing = FACTION_BAR_COLORS_CUSTOM[5], FACTION_STANDING_LABEL_CUSTOM[factionInfo.standing]
    local color = factionInfo.hasReward and '00ff00' or 'ffffff'
    if standing then
        standingColor = FACTION_BAR_COLORS_CUSTOM[factionInfo.standing]
    else
        standing = factionInfo.standing
    end

    if factionInfo.max then
        return string.format('|cff%s%s/%s|r |cff%02X%02X%02X%s|r', color, AbbreviateNumbers(factionInfo.current or 0), AbbreviateNumbers(factionInfo.max or 0), standingColor.r, standingColor.g, standingColor.b, standing)
    end
end
