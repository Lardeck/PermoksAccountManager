local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local module = 'currencies'
local labelRows = {
    soul_cinders = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1906].name or 'Soul Cinders'
        end,
        type = 'currency',
        key = 1906,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    soul_ash = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1828].name or 'Soul Ash'
        end,
        type = 'currency',
        key = 1828,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    stygia = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1767].name or 'Stygia'
        end,
        type = 'currency',
        key = 1767,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    conquest = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1602].name or 'Conquest'
        end,
        type = 'currency',
        key = 1602,
        hideMax = true,
        tooltip = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    honor = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1792].name or 'Honor'
        end,
        type = 'currency',
        key = 1792,
        abbCurrent = true,
        abbMax = true,
        tooltip = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    honorBCC = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1901] and PermoksAccountManager.db.global.currencyInfo[1901].name or 'Honor'
        end,
        type = 'currency',
        key = 1901,
		abbMax = true,
        customIcon = {
            height = 32,
            width = 32,
            xOffset = -5,
            yOffset = -5
        },
        group = 'currency',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    arenaPoints = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1900] and PermoksAccountManager.db.global.currencyInfo[1900].name or 'Arena Points'
        end,
        type = 'currency',
        key = 1900,
        group = 'currency',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    valor = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1191].name or 'Valor'
        end,
        type = 'currency',
        key = 1191,
        hideMax = true,
        tooltip = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    tower_knowledge = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1904].name or 'Tower Knowledge'
        end,
        type = 'currency',
        key = 1904,
        hideMax = true,
        tooltip = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    stygian_ember = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1977].name or 'Stygian Ember'
        end,
        type = 'currency',
        key = 1977,
        customTooltip = function(button, alt_data)
            PermoksAccountManager:StygianEmbersTooltip_OnEnter(button, alt_data)
        end,
        tooltip = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    cataloged_research = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1931].name or 'Cataloged Research'
        end,
        type = 'currency',
        key = 1931,
        abbMax = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
	redeemed_soul = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1810].name or 'Redeemed Soul'
        end,
        type = 'currency',
		customTooltip = function(button, altData, labelRow)
			PermoksAccountManager:CustomCovenantCurrencyTooltip(button, altData, labelRow)
		end,
		tooltip = true,
		tooltipKeyPath = {'covenantInfo', 'souls'},
        key = 1810,
        group = 'sanctum',
        version = WOW_PROJECT_MAINLINE
    },
    reservoir_anima = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1813].name or 'Reservoir Anima'
        end,
		type = 'currency',
		customTooltip = function(button, altData, labelRow)
			PermoksAccountManager:CustomCovenantCurrencyTooltip(button, altData, labelRow)
		end,
		tooltip = true,
		tooltipKeyPath = {'covenantInfo', 'anima'},
        key = 1813,
        hideMax = true,
        group = 'sanctum',
        version = WOW_PROJECT_MAINLINE
    },

	-- 9.2
	cosmic_flux = {
		label = function()
            return PermoksAccountManager.db.global.currencyInfo[2009] and PermoksAccountManager.db.global.currencyInfo[2009].name or 'Cosmic Flux'
        end,
		type = 'currency',
		key = 2009,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
	},
	cyphers = {
		label = L['Cyphers'],
		type = 'currency',
		key = 1979,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
	},
	catalyst_charges = {
		label = L['Catalyst Charges'],
		type = 'catalystcharges',
		key = 2912,
		hideIcon = true,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
	},

    --10.0
    dragon_isles_supplies = {
		label = 'Dragon Isles Supplies',
		type = 'currency',
		key = 2003,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
	},
    elemental_overflow = {
		label = 'Elemental Overflow',
		type = 'currency',
		key = 2118,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
	},
    bloody_tokens = {
		label = 'Bloody Tokens',
		type = 'currency',
		key = 2123,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
	},
    storm_sigil = {
		label = 'Storm Sigil',
		type = 'currency',
		key = 2122,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
	},

    --10.1
    whelpling_crest_earned = {
        label = 'Whelpling earned',
		type = 'currency',
		key = 2409,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
    },
    drake_crest_earned = {
        label = 'Drake earned',
		type = 'currency',
		key = 2410,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
    },
    wyrm_crest_earned = {
        label = 'Wyrm earned',
		type = 'currency',
		key = 2411,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
    },
    aspect_crest_earned = {
        label = 'Aspect earned',
		type = 'currency',
		key = 2412,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
    },
    flightstones = {
        label = 'Flightstones',
		type = 'currency',
		key = 2245,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
    },

    -- 10.1.5
    paracausal_flakes = {
        label = 'Paracausal Flakes',
		type = 'currency',
		key = 2594,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_MAINLINE
    },

    -- 10.2
    whelpling_crest_s3 = {
        label = 'Whelpling Crests',
        type = 'crestcurrency',
        key = 2706,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    drake_crest_s3 = {
        label = 'Drake Crests',
        type = 'crestcurrency',
        key = 2707,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    wyrm_crest_s3 = {
        label = 'Wyrm Crests',
        type = 'crestcurrency',
        key = 2708,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    aspect_crest_s3 = {
        label = 'Aspect Crests',
        type = 'crestcurrency',
        key = 2709,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    emerald_dewdrop = {
        label = 'Emerald Dewdrop',
        type = 'currency',
        key = 2650,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    seedbloom = {
        label = 'Seedbloom',
        type = 'currency',
        key = 2651,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    dream_infusion = {
        label = 'Dream Infusion',
        type = 'currency',
        key = 2777,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },

    -- 10.2.7
    whelpling_crest_s4 = {
        label = 'Whelpling Crests',
        type = 'crestcurrency',
        key = 2806,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    drake_crest_s4 = {
        label = 'Drake Crests',
        type = 'crestcurrency',
        key = 2807,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    wyrm_crest_s4 = {
        label = 'Wyrm Crests',
        type = 'crestcurrency',
        key = 2809,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    aspect_crest_s4 = {
        label = 'Aspect Crests',
        type = 'crestcurrency',
        key = 2812,
        passRow = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },

    -- 11.0 Prepatch
    residual_memories = {
        label = 'Residual Memories',
        type = 'currency',
        key = 3089,
        passRow = true,
        group = 'currency',
        warband = 'unique',
        version = WOW_PROJECT_MAINLINE
    },

    -- 11.0
    


    -- wotlk-classic
    emblem_of_heroism = {
        label = 'Heroism Emblems',
		type = 'currency',
		key = 101,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    emblem_of_valor = {
        label = 'Valor Emblems',
		type = 'currency',
		key = 102,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    emblem_of_conquest = {
        label = 'Conq. Emblems',
		type = 'currency',
		key = 221,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    emblem_of_triumph = {
        label = 'Triumph Emblems',
		type = 'currency',
		key = 301,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    emblem_of_frost = {
        label = 'Frost Emblems',
		type = 'currency',
		key = 341,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    sidereal_essence = {
        label = 'Sidereal Essence',
		type = 'currency',
		key = 2589,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    defilers_scourgestone = {
        label = 'Scourgestones',
		type = 'currency',
		key = 2711,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    stone_keepers_shard = {
        label = 'Stone Keeper\'s Shard',
		type = 'currency',
		key = 161,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    justice_points = {
        label = 'Justice Points',
		type = 'currency',
		key = 395,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    valor_points = {
        label = 'Valor Points',
		type = 'valor',
		key = 396,
        abbMax = true,
        passRow = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    conquest_points = {
        label = 'Conquest',
		type = 'currency',
		key = 390,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    tol_barad_commendations = {
        label = 'Commendations',
		type = 'currency',
		key = 391,
        abbMax = true,
		group = 'currency',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
}

local function UpdateAllCurrencies(charInfo)
    local self = PermoksAccountManager
    charInfo.currencyInfo = charInfo.currencyInfo or {}

    local currencyInfo = charInfo.currencyInfo
    for currencyType, offset in pairs(self.currency) do
        local info = C_CurrencyInfo.GetCurrencyInfo(currencyType)
        if info then
            currencyInfo[currencyType] = charInfo.currencyInfo[currencyType] or {name = info.name}

            currencyInfo[currencyType].currencyType = currencyType
            currencyInfo[currencyType].quantity = info.quantity + offset
            currencyInfo[currencyType].maxQuantity = info.maxQuantity and info.maxQuantity > 0 and info.maxQuantity or nil
            currencyInfo[currencyType].totalEarned = info.totalEarned
            currencyInfo[currencyType].maxWeeklyQuantity = info.maxWeeklyQuantity
            currencyInfo[currencyType].quantityEarnedThisWeek = info.quantityEarnedThisWeek

            self.db.global.currencyInfo[currencyType] = self.db.global.currencyInfo[currencyType] or {icon = info.iconFileID, name = info.name}
            self.db.global.currencyInfo[currencyType].maxQuantity = info.maxQuantity and info.maxQuantity > 0 and info.maxQuantity or self.db.global.currencyInfo[currencyType].maxQuantity
        end
    end
end

local function Update(charInfo)
    UpdateAllCurrencies(charInfo)
end

local function UpdateCurrency(charInfo, currencyType, quantity, quantityChanged)
    local self = PermoksAccountManager
    if not currencyType or not self.currency[currencyType] then
        return
    end

    local currencyInfo = charInfo.currencyInfo[currencyType]
	if self.isRetail then
    	currencyInfo.totalEarned = quantityChanged + (currencyInfo.totalEarned or 0)
	end

    local customOptions = self.currencyCustomOptions and self.currencyCustomOptions[currencyType]
    if customOptions then
        if customOptions.forceUpdate then
            local newCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyType)
            currencyInfo.quantity = newCurrencyInfo.quantity
            currencyInfo.totalEarned = newCurrencyInfo.totalEarned
            currencyInfo.quantityEarnedThisWeek = newCurrencyInfo.quantityEarnedThisWeek
            currencyInfo.maxWeeklyQuantity = newCurrencyInfo.maxWeeklyQuantity
            currencyInfo.maxQuantity = newCurrencyInfo.maxQuantity and newCurrencyInfo.maxQuantity > 0 and newCurrencyInfo.maxQuantity or nil
        elseif customOptions.currencyUpdate and charInfo.currencyInfo[customOptions.currencyUpdate] then
            charInfo.currencyInfo[customOptions.currencyUpdate].quantity = C_CurrencyInfo.GetCurrencyInfo(customOptions.currencyUpdate).quantity
        end
    else
        charInfo.currencyInfo[currencyType].quantity = quantity + self.currency[currencyType]
    end
end

local function UpdateCatalystCharges(charInfo)
    if not charInfo.currencyInfo or not charInfo.currencyInfo[2912] then
        UpdateAllCurrencies(charInfo)
    end

    charInfo.currencyInfo[2912].quantity = C_CurrencyInfo.GetCurrencyInfo(2912).quantity
end

local function CreateCatalystChargeString(currencyInfo)
	local catalystCharges = currencyInfo and currencyInfo[2912]
	if not catalystCharges then return '-' end

	return PermoksAccountManager:CreateFractionString(catalystCharges.quantity, catalystCharges.maxQuantity)
end

local function CreateCrestString(labelRow, currencyInfo)
	local crestInfo = currencyInfo and currencyInfo[labelRow.key]
    if crestInfo then
        if crestInfo.maxQuantity and crestInfo.maxQuantity > 0 then
            local currencyString = PermoksAccountManager:CreateCurrencyString(crestInfo, labelRow.abbCurrent, labelRow.abbMax, labelRow.hideMaximum, labelRow.customIcon, labelRow.hideIcon, crestInfo.totalEarned)
            return string.format("%d - %s", crestInfo.quantity, currencyString)
        elseif currencyInfo then
            return PermoksAccountManager:CreateCurrencyString(crestInfo, labelRow.abbCurrent, labelRow.abbMax, labelRow.hideMaximum, labelRow.customIcon, labelRow.hideIcon)
        end
    elseif currencyInfo then
        return PermoksAccountManager:CreateCurrencyString({currencyType = labelRow.key}, labelRow.abbCurrent, labelRow.abbMax, labelRow.hideMaximum, labelRow.customIcon, labelRow.hideIcon, 0)
    else
        return '-'
    end
end

local function CreateValorString(labelRow, currencyInfo)
    local info = currencyInfo and currencyInfo[labelRow.key]
    if info then
        local globalCurrencyInfo = PermoksAccountManager.db.global.currencyInfo[labelRow.key]
        local maxQuantity = (info.maxQuantity and info.maxQuantity > 0 and info.maxQuantity) or (globalCurrencyInfo and globalCurrencyInfo.maxQuantity or 0)
        return string.format("%s - %s", AbbreviateNumbers(info.quantity), PermoksAccountManager:CreateFractionString(info.totalEarned or 0, maxQuantity or 0))
    end
end

local payload = {
    update = Update,
    labels = labelRows,
    events = {
        ['CURRENCY_DISPLAY_UPDATE'] = UpdateCurrency,
        ['PERKS_ACTIVITIES_UDPATED'] = UpdateCatalystCharges,
    },
    share = {
        [UpdateCurrency] = 'currencyInfo'
    }
}
local module = PermoksAccountManager:AddModule(module, payload)
module:AddCustomLabelType('catalystcharges', CreateCatalystChargeString, nil, 'currencyInfo')
module:AddCustomLabelType('crestcurrency', CreateCrestString, nil, 'currencyInfo')
module:AddCustomLabelType('valor', CreateValorString, nil, 'currencyInfo')

-- TODO Create a CreateIconString function instead of two functions for items and currencies
function PermoksAccountManager:CreateCurrencyString(currencyInfo, abbreviateCurrent, abbreviateMaximum, hideMaximum, customIcon, hideIcon, customQuantitiy)
    if not currencyInfo then
        return
    end

    local iconString = ''
    local options = self.db.global.options
    local globalCurrencyInfo = self.db.global.currencyInfo[currencyInfo.currencyType]
    local currencyIcon = globalCurrencyInfo.icon
    if not hideIcon and currencyIcon and options.currencyIcons then
        if customIcon then
            iconString = string.format('\124T%s:%d:%d:%d:%d\124t', customIcon.path or currencyIcon, customIcon.height or 18, customIcon.width or 18, customIcon.xOffset or 0, customIcon.yOffset or 0)
        else
            iconString = string.format('\124T%d:18:18\124t', currencyIcon)
        end
    end

    if currencyInfo.maxQuantity and currencyInfo.maxQuantity > 0 and (currencyInfo.quantity or 0) > currencyInfo.maxQuantity then
        currencyInfo.quantity = currencyInfo.quantity / 100
    end

    local currencyString
    local quantity = customQuantitiy or currencyInfo.quantity
    if not hideMaximum and ((currencyInfo.maxQuantity and currencyInfo.maxQuantity > 0) or (currencyInfo.maxWeeklyQuantity and currencyInfo.maxWeeklyQuantity > 0)) then
        currencyString = self:CreateFractionString(quantity, globalCurrencyInfo.maxQuantity or currencyInfo.maxQuantity  or currencyInfo.maxWeeklyQuantity, abbreviateCurrent, abbreviateMaximum)
    else
        currencyString = abbreviateCurrent and AbbreviateNumbers(quantity) or AbbreviateLargeNumbers(quantity)
    end

    local iconPosition = options.currencyIconPosition
    if iconPosition == 'left' then
        return string.format('%s %s', iconString, currencyString)
    end
    return string.format('%s %s', currencyString, iconString)
end

function PermoksAccountManager.CurrencyTooltip_OnEnter(button, altData, labelRow)
    if not altData.currencyInfo then
        return
    end

    local self = PermoksAccountManager
    local currencyInfo = altData.currencyInfo[labelRow.key]
    local globalCurrencyInfo = self.db.global.currencyInfo[labelRow.key]
    if not currencyInfo or not currencyInfo.name then
        return
    end

    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
    button.tooltip = tooltip

    tooltip:AddHeader(currencyInfo.name)
    tooltip:AddLine('')

    tooltip:AddLine('Total Earned:', self:CreateFractionString(currencyInfo.totalEarned, globalCurrencyInfo.maxQuantity or currencyInfo.maxQuantity))

    if ((globalCurrencyInfo.maxQuantity or currencyInfo.maxQuantity) or 0) > currencyInfo.totalEarned then
        tooltip:AddLine('Left:', (globalCurrencyInfo.maxQuantity or currencyInfo.maxQuantity) - currencyInfo.totalEarned)
    end

    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end

do
    local torghastSoulCinders = {
        [8] = 50,
        [9] = 90,
        [10] = 120,
        [11] = 150,
        [12] = 180
    }

    function PermoksAccountManager:SoulCindersTooltip_OnEnter(button, alt_data)
        if not alt_data or not alt_data.questInfo or not alt_data.torghastInfo then
            return
        end
        local torghastInfo = alt_data.torghastInfo
        local weekly = alt_data.questInfo.weekly

        local assaults = PermoksAccountManager:GetNumCompletedQuests(weekly.hidden.assault) * 50
        local tormentors = min(self:GetNumCompletedQuests(weekly.hidden.tormentors_weekly) * 50, 50)

        local torghast = 0
        for layer, completed in pairs(torghastInfo) do
            if torghastSoulCinders[completed] then
                torghast = torghast + torghastSoulCinders[completed]
            end
        end

        local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
        button.tooltip = tooltip
        tooltip:AddHeader(alt_data.currencyInfo[1906].name)
        tooltip:AddSeparator(2, 1, 1, 1)
        tooltip:AddLine('Assaults:', PermoksAccountManager:CreateFractionString(assaults, 100))
        tooltip:AddLine('Tormentors:', PermoksAccountManager:CreateFractionString(tormentors, 50))
        tooltip:AddLine('Torghast:', PermoksAccountManager:CreateFractionString(torghast, 360))
        tooltip:AddSeparator(2, 1, 1, 1)
        tooltip:AddLine('|cff00f7ffTotal:|r', PermoksAccountManager:CreateFractionString(assaults + tormentors + torghast, 510))
        tooltip:SmartAnchorTo(button)
        tooltip:Show()
    end
end

do
    local raidBossEmbers = {
        [17] = 1,
        [14] = 2,
        [15] = 3,
        [16] = 4
    }

    local function GetEmbersForDifficulty(embersTable, difficulty)
        local totalNumEmbers = 0
        for boss, numEmbers in pairs(embersTable) do
            if numEmbers >= raidBossEmbers[difficulty] then
                totalNumEmbers = totalNumEmbers + 1
            end
        end

        return totalNumEmbers
    end

    local function GetTotalNumRaidEmbers(embersTable)
        local total = 0
        for _, numEmbers in ipairs(embersTable) do
            total = total + numEmbers
        end

        return total
    end

    function PermoksAccountManager:StygianEmbersTooltip_OnEnter(button, alt_data)
        if not alt_data or not alt_data.raidActivityInfo or not alt_data.questInfo or not alt_data.questInfo.weekly or not alt_data.questInfo.weekly.visible then
            return
        end
        local raidActivityInfo = alt_data.raidActivityInfo
        local questInfo = alt_data.questInfo.weekly

        local embersFromRaidBosses = {}
        for i, encounter in ipairs(raidActivityInfo) do
            if raidBossEmbers[encounter.bestDifficulty] then
                embersFromRaidBosses[encounter.uiOrder] = (embersFromRaidBosses[encounter.uiOrder] or 0) + raidBossEmbers[encounter.bestDifficulty]
            end
        end

        local embersFromShapingFate = questInfo.visible.korthia_weekly and next(questInfo.visible.korthia_weekly) and 10 or 0
        local embersFromWB = questInfo.hidden.world_boss and questInfo.hidden.world_boss[64531] and 1 or 0
        local embersFromNormalRaidTrash = self:GetNumCompletedQuests(questInfo.hidden.sanctum_normal_embers_trash)
        local embersFromHeroicRaidTrash = self:GetNumCompletedQuests(questInfo.hidden.sanctum_heroic_embers_trash)
        local total = GetTotalNumRaidEmbers(embersFromRaidBosses) + embersFromShapingFate + embersFromWB + embersFromNormalRaidTrash + embersFromHeroicRaidTrash

        local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
        button.tooltip = tooltip
        tooltip:AddHeader(alt_data.currencyInfo[1977].name)
        tooltip:AddSeparator(2, 1, 1, 1)
        tooltip:AddLine('LFR Raid:', PermoksAccountManager:CreateFractionString(GetEmbersForDifficulty(embersFromRaidBosses, 17), 10))
        tooltip:AddLine('Normal Raid:', PermoksAccountManager:CreateFractionString(GetEmbersForDifficulty(embersFromRaidBosses, 14), 10))
        tooltip:AddLine('Heroic Raid:', PermoksAccountManager:CreateFractionString(GetEmbersForDifficulty(embersFromRaidBosses, 15), 10))
        tooltip:AddLine('Mythic Raid:', PermoksAccountManager:CreateFractionString(GetEmbersForDifficulty(embersFromRaidBosses, 16), 10))
        tooltip:AddSeparator(2, 1, 1, 1)
        tooltip:AddLine('Normal Trash:', PermoksAccountManager:CreateFractionString(embersFromNormalRaidTrash, 5))
        tooltip:AddLine('Heroic Trash:', PermoksAccountManager:CreateFractionString(embersFromHeroicRaidTrash, 5))
        tooltip:AddSeparator(2, 1, 1, 1)
        tooltip:AddLine('Shaping Fate:', PermoksAccountManager:CreateFractionString(embersFromShapingFate, 10))
        tooltip:AddSeparator(2, 1, 1, 1)
        tooltip:AddLine('World Boss:', PermoksAccountManager:CreateFractionString(embersFromWB, 1))
        tooltip:AddSeparator(2, 1, 1, 1)
        tooltip:AddLine('|cff00f7ffTotal:|r', PermoksAccountManager:CreateFractionString(total, 61))
        tooltip:SmartAnchorTo(button)
        tooltip:Show()
    end
end
