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
    dragonscale_expedition = {
        label = function()
            return PermoksAccountManager.factions[2507].localName or 'Expedition'
        end,
        type = 'faction',
        key = 2507,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    iskaara_tuskar = {
        label = function()
            return PermoksAccountManager.factions[2511].localName or 'Iskaara Tuskar'
        end,
        type = 'faction',
        key = 2511,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    maruuk_centaur = {
        label = function()
            return PermoksAccountManager.factions[2503].localName or 'Maruuk Centaur'
        end,
        type = 'faction',
        key = 2503,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    valdrakken_akkord = {
        label = function()
            return PermoksAccountManager.factions[2510].localName or 'Valdrakken Akkord'
        end,
        type = 'faction',
        key = 2510,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    winterpelt_furbolg = {
        label = function()
            return PermoksAccountManager.factions[2526].localName or 'Winterpelt Furbolg'
        end,
        type = 'faction',
        key = 2526,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    artisan_consortium = {
        label = function()
            return PermoksAccountManager.factions[2544].localName or "Artisan's Consortium"
        end,
        type = 'faction',
        key = 2544,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    cobalt_assembly = {
        label = function()
            return PermoksAccountManager.factions[2550].localName or "Cobalt Assembly"
        end,
        type = 'faction',
        key = 2550,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    sabellian = {
        label = function()
            return PermoksAccountManager.factions[2518].localName or 'Sabellian'
        end,
        type = 'faction',
        key = 2518,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    wrathion = {
        label = function()
            return PermoksAccountManager.factions[2517].localName or 'Wrathion'
        end,
        type = 'faction',
        key = 2517,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    loam_niffen = {
        label = function()
            return PermoksAccountManager.factions[2564].localName or 'Loam Niffen'
        end,
        type = 'faction',
        key = 2564,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    dream_wardens = {
        label = function()
            return PermoksAccountManager.factions[2574].localName or 'Dream Wardens'
        end,
        type = 'faction',
        key = 2574,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    soridormi = {
        label = function()
            return PermoksAccountManager.factions[2553].localName or 'Soridormi'
        end,
        type = 'faction',
        key = 2553,
        group = 'reputation',
        version = WOW_PROJECT_MAINLINE
    },
    keg_legs_crew = {
        label = function()
            return PermoksAccountManager.factions[2593].localName or 'Keg Leg\'s Crew'
        end,
        type = 'faction',
        key = 2593,
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
--TODO: Rework after DF launch
local function GetFactionOrFriendshipInfo(factionId, factionType)
    local hasReward, renown
    local name, _, standing, barMin, barMax, barValue = GetFactionInfoByID(factionId)
    local isParagon = C_Reputation.IsFactionParagon(factionId)
    
    if isParagon then
        barValue, barMax, _, hasReward = C_Reputation.GetFactionParagonInfo(factionId)
        barMin, standing, barValue = 0, 9, barValue % barMax
    elseif factionType == 'renown' then
        renown = C_MajorFactions.GetCurrentRenownLevel(factionId)
        local majorFactionInfo = C_MajorFactions.GetMajorFactionData(factionId)
        if majorFactionInfo then
            barMin = 0
            barValue = majorFactionInfo.renownReputationEarned
            barMax = majorFactionInfo.renownLevelThreshold
        end
    elseif factionType == 'friend' then
        local friendshipInfo = C_GossipInfo.GetFriendshipReputation(factionId)
        if friendshipInfo then
            barMin = friendshipInfo.reactionThreshold
            barValue = friendshipInfo.standing
            barMax = friendshipInfo.nextThreshold or friendshipInfo.reactionThreshold
            standing = friendshipInfo.reaction
        end
    end

    if not barMax or not barMin then
        return
    end

    return barValue - barMin, (barMax - barMin), standing, name, hasReward, renown
end

local function UpdateFactions(charInfo)
    local self = PermoksAccountManager

    charInfo.factions = charInfo.factions or {}
    local factions = charInfo.factions

    for factionId, info in pairs(self.factions) do
        local current, maximum, standing, name, hasReward, renown = GetFactionOrFriendshipInfo(factionId, info.type)

        factions[factionId] = factions[factionId] or {}
        factions[factionId].standing = standing
        factions[factionId].current = current
        factions[factionId].max = maximum
        factions[factionId].type = info.type
        factions[factionId].hasReward = hasReward
        factions[factionId].renown = renown
        factions[factionId].exalted = not info.paragon and standing == 8
        factions[factionId].maximum = info.type == "friend" and current >= maximum

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
    elseif factionInfo.maximum then
        return string.format('|cff00ff00%s|r', 'Maximum')
    end

    local standingColor, standing = FACTION_BAR_COLORS_CUSTOM[5], FACTION_STANDING_LABEL_CUSTOM[factionInfo.standing]
    local color = factionInfo.hasReward and '00ff00' or 'ffffff'
    if standing then
        standingColor = FACTION_BAR_COLORS_CUSTOM[factionInfo.standing]
    else
        standing = factionInfo.standing
    end

    if factionInfo.renown then
        return string.format('%s - %s/%s', BLUE_FONT_COLOR:WrapTextInColorCode(factionInfo.renown), AbbreviateNumbers(factionInfo.current or 0), AbbreviateNumbers(factionInfo.max or 0))
    elseif factionInfo.max then
        return string.format('|cff%s%s/%s|r |cff%02X%02X%02X%s|r', color, AbbreviateNumbers(factionInfo.current or 0), AbbreviateNumbers(factionInfo.max or 0), standingColor.r, standingColor.g, standingColor.b, standing)
    end
end
