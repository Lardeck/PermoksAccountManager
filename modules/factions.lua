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

    -- wotlk
    alliance_vanguard = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1037]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1037,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    valiance_expedition = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1050]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1050,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    horde_expedition = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1052]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1052,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_taunka = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1064]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1064,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_hand_of_vengeance = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1067]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1067,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    explorers_league = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1068]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1068,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_kaluak = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1073]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1073,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    warsong_offensive = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1085]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1085,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    kirin_tor = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1090]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1090,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_wyrmrest_accord = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1091]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1091,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_silver_covenant = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1094]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1094,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    knights_of_the_ebon_blade = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1098]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1098,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    frenzyheart_tribe = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1104]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1104,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_oracles = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1105]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1105,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    argent_crusade = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1106]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1106,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_sons_of_hodir = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1119]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1119,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_sunreavers = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1124]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1124,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
    the_frostborn = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1126]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1126,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    },
	the_ashen_verdict = {
        label = function()
            local factionInfo = PermoksAccountManager.factions[1156]
            return factionInfo.localName or factionInfo.name
        end,
        key = 1156,
        type = 'faction',
        version = WOW_PROJECT_WRATH_CLASSIC,
        group = 'reputation'
    }
}

local GetFriendshipReputation = C_GossipInfo and C_GossipInfo.GetFriendshipReputation or GetFriendshipReputation
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
