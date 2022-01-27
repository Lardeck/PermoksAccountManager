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
        id = 1906,
        customTooltip = function(button, alt_data)
            PermoksAccountManager:SoulCindersTooltip_OnEnter(button, alt_data)
        end,
        tooltip = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    soul_ash = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1828].name or 'Soul Ash'
        end,
        type = 'currency',
        id = 1828,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    stygia = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1767].name or 'Stygia'
        end,
        type = 'currency',
        id = 1767,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    conquest = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1602].name or 'Conquest'
        end,
        type = 'currency',
        id = 1602,
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
        id = 1792,
        abbCurrent = true,
        abbMax = true,
        tooltip = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    honorBCC = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1901].name or 'Honor'
        end,
        type = 'currency',
        id = 1901,
        customIcon = {
            height = 32,
            width = 32,
            xOffset = -5,
            yOffset = -5
        },
        group = 'currency',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    arenaPoints = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1900].name or 'Arena Points'
        end,
        type = 'currency',
        id = 1900,
        group = 'currency',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    valor = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1191].name or 'Valor'
        end,
        type = 'currency',
        id = 1191,
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
        id = 1904,
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
        id = 1977,
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
        id = 1931,
        abbMax = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    reservoir_anima = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1813].name or 'Reservoir Anima'
        end,
        type = 'currency',
        id = 1813,
        hideMax = true,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    redeemed_soul = {
        label = function()
            return PermoksAccountManager.db.global.currencyInfo[1810].name or 'Redeemed Soul'
        end,
        type = 'currency',
        id = 1810,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    }
}

local function UpdateAllCurrencies(charInfo)
    local self = PermoksAccountManager
    charInfo.currencyInfo = charInfo.currencyInfo or {}

    local currencyInfo = charInfo.currencyInfo
    for currencyType, offset in pairs(self.currency) do
        local info = C_CurrencyInfo.GetCurrencyInfo(currencyType)
        if info then
            currencyInfo[currencyType] = charInfo.currencyInfo[currencyType] or {name = info.name}

            -- Fix for returning the wrong quantity
            if currencyType ~= 1810 and info.maxQuantity > 0 and info.quantity > info.maxQuantity then
                info.quantity = info.quantity / 100
            end

            currencyInfo[currencyType].currencyType = currencyType
            currencyInfo[currencyType].quantity = info.quantity + offset
            currencyInfo[currencyType].maxQuantity = info.maxQuantity
            currencyInfo[currencyType].totalEarned = info.totalEarned

            self.db.global.currencyInfo[currencyType] = self.db.global.currencyInfo[currencyType] or {icon = info.iconFileID, name = info.name}
            self.db.global.currencyInfo[currencyType].maxQuantity = info.maxQuantity
        end
    end
end

local function Update(charInfo)
    UpdateAllCurrencies(charInfo)
end

local function UpdateCurrency(charInfo, currencyType, quantity)
    local self = PermoksAccountManager
    if not currencyType or not self.currency[currencyType] then
        return
    end

    charInfo.currencyInfo[currencyType].quantity = quantity + self.currency[currencyType]
end

local payload = {
    update = Update,
    labels = labelRows,
    events = {
        ['CURRENCY_DISPLAY_UPDATE'] = UpdateCurrency
    },
    share = {
        [UpdateCurrency] = 'currencyInfo'
    }
}
PermoksAccountManager:AddModule(module, payload)

-- TODO Create a CreateIconString function instead of two functions for items and currencies
function PermoksAccountManager:CreateCurrencyString(currencyInfo, abbreviateCurrent, abbreviateMaximum, hideMaximum, customIcon)
    if not currencyInfo then
        return
    end

    local iconString = ''
    local options = self.db.global.options
    local globalCurrencyInfo = self.db.global.currencyInfo[currencyInfo.currencyType]
    local currencyIcon = globalCurrencyInfo.icon
    if currencyIcon and options.currencyIcons then
        if customIcon then
            iconString = string.format('\124T%s:%d:%d:%d:%d\124t', customIcon.path or currencyIcon, customIcon.height or 18, customIcon.width or 18, customIcon.xOffset or 0, customIcon.yOffset or 0)
        else
            iconString = string.format('\124T%d:18:18\124t', currencyIcon)
        end
    end

    local currencyString
    if not hideMaximum and currencyInfo.maxQuantity and currencyInfo.maxQuantity > 0 then
        currencyString = self:CreateFractionString(currencyInfo.quantity, globalCurrencyInfo.maxQuantity or currencyInfo.maxQuantity, abbreviateCurrent, abbreviateMaximum)
    else
        currencyString = abbreviateCurrent and AbbreviateNumbers(currencyInfo.quantity) or AbbreviateLargeNumbers(currencyInfo.quantity)
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
    local currencyInfo = altData.currencyInfo[labelRow.id]
    local globalCurrencyInfo = self.db.global.currencyInfo[labelRow.id]
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
