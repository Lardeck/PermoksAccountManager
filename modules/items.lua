local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local module = 'items'
local labelRows = {
    flask = {
        label = L['Flasks'],
        type = 'item',
        key = 'flask',
        id = 171276,
        tooltip = true,
        group = 'item'
    },
    foodHaste = {
        label = L['Haste Food'],
        type = 'item',
        key = 'foodHaste',
        id = 172045,
        tooltip = true,
        group = 'item'
    },
    augmentRune = {
        label = L['Augment Runes'],
        type = 'item',
        key = 'augmentRune',
        id = 181468,
        tooltip = true,
        group = 'item'
    },
    armorKit = {
        label = L['Armor Kits'],
        type = 'item',
        key = 'armorKit',
        id = 172347,
        tooltip = true,
        group = 'item'
    },
    oilHeal = {
        label = L['Heal Oils'],
        type = 'item',
        key = 'oilHeal',
        id = 171286,
        tooltip = true,
        group = 'item'
    },
    oilDPS = {
        label = L['DPS Oils'],
        type = 'item',
        key = 'oilDPS',
        id = 171285,
        tooltip = true,
        group = 'item'
    },
    potHP = {
        label = L['HP Pots'],
        type = 'item',
        key = 'potHP',
        id = 171267,
        tooltip = true,
        group = 'item'
    },
    drum = {
        label = L['Drums'],
        type = 'item',
        key = 'drum',
        id = 172233,
        tooltip = true,
        group = 'item'
    },
    potManaInstant = {
        label = L['Instant Mana'],
        type = 'item',
        key = 'potManaInstant',
        id = 171272,
        tooltip = true,
        group = 'item'
    },
    potManaChannel = {
        label = L['Channal Mana'],
        type = 'item',
        key = 'potManaChannel',
        id = 171268,
        tooltip = true,
        group = 'item'
    },
    tome = {
        label = L['Tomes'],
        type = 'item',
        key = 'tome',
        id = 173049,
        tooltip = true,
        group = 'item'
    },
    korthiteCrystal = {
        label = L['Korthite Crystals'],
        type = 'item',
        key = 'korthiteCrystal',
        id = 186017,
        tooltip = true,
        group = 'item'
    },
    -- tbc
    elixirDemonslaying = {
        label = 'Elixir of Demonslaying',
		type = 'item',
		key = "elixirDemonslaying",
		id = 9224,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    brilliantWizardOil = {
        label = 'Brilliant Wizard Oil',
		type = 'item',
		key = "elixirDemonslaying",
		id = 20749,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    adamantiteSharpeningStone = {
        label = 'Adamantite Sharpening Stone',
		type = 'item',
		key = "adamantiteSharpeningStone",
		id = 23529,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskBlindingLight = {
        label = 'Flask of Blinding Light',
		type = 'item',
		key = "flaskBlindingLight",
		id = 22861,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirAdept = {
        label = "Adept's Elixir",
		type = 'item',
		key = "elixirAdept",
		id = 28103,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirDraenicWisdom = {
        label = 'Elixir of Draenic Wisdom',
		type = 'item',
		key = "elixirDraenicWisdom",
		id = 32067,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskSupremePower = {
        label = 'Flask of Supreme Power',
		type = 'item',
		key = "flaskSupremePower",
		id = 13512,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionSuperMana = {
        label = 'Super Mana Potion',
		type = 'item',
		key = "potionSuperMana",
		id = 22832,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskChromaticWonder = {
        label = 'Flask of Chromatic Wonder',
		type = 'item',
		key = "flaskChromaticWonder",
		id = 33208,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirMajorAgility = {
        label = 'Elixir of Major Agility',
		type = 'item',
		key = "elixirMajorAgility",
		id = 22831,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    giftOfArthas = {
        label = 'Gift of Arthas',
		type = 'item',
		key = "giftOfArthas",
		id = 9088,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    spiritOfZanza = {
        label = 'Spirit of Zanza',
		type = 'item',
		key = "spiritOfZanza",
		id = 20079,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionIronshield = {
        label = 'Ironshield Potion',
		type = 'item',
		key = "potionIronshield",
		id = 22849,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionHaste = {
        label = 'Haste Potion',
		type = 'item',
		key = "potionHaste",
		id = 22838,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionFreeAction = {
        label = 'Free Action Potion',
		type = 'item',
		key = "potionFreeAction",
		id = 5634,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    adamantiteWeightstone = {
        label = 'Adamantite Weightstone',
		type = 'item',
		key = "adamantiteWeightstone",
		id = 28421,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirHealingPower = {
        label = 'Elixir of Healing Power',
		type = 'item',
		key = "elixirHealingPower",
		id = 22825,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    superiorWizardOil = {
        label = 'Superior Wizard Oil',
		type = 'item',
		key = "superiorWizardOil",
		id = 22522,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirMajorMageblood = {
        label = 'Elixir of Major Mageblood',
		type = 'item',
		key = "elixirMajorMageblood",
		id = 22840,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskRelentlessAssault = {
        label = 'Flask of Relentless Assault',
		type = 'item',
		key = "flaskRelentlessAssault",
		id = 22854,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskPureDeath = {
        label = 'Flask of Pure Death',
		type = 'item',
		key = "flaskPureDeath",
		id = 22866,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    drumsBattle = {
        label = 'Drums of Battle',
		type = 'item',
		key = "drumsBattle",
		id = 29529,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionDestruction = {
        label = 'Destruction Potion',
		type = 'item',
		key = "potionDestruction",
		id = 22839,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskFortification = {
        label = 'Flask of Fortification',
		type = 'item',
		key = "flaskFortification",
		id = 22851,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirMajorDefense = {
        label = 'Elixir of Major Defense',
		type = 'item',
		key = "elixirMajorDefense",
		id = 22834,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirMajorShadowPower = {
        label = 'Elixir of Major Defense',
		type = 'item',
		key = "elixirMajorShadowPower",
		id = 22835,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirEmpowerment = {
        label = 'Elixir of Empowerment',
		type = 'item',
		key = "elixirEmpowerment",
		id = 22848,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    swiftnessOfZanza = {
        label = 'Swiftness of Zanza',
		type = 'item',
		key = "swiftnessOfZanza",
		id = 20081,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    thistleTea = {
        label = 'Thistle Tea',
		type = 'item',
		key = "thistleTea",
		id = 7676,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flameCap = {
        label = 'Flame Cap',
		type = 'item',
		key = "flameCap",
		id = 22788,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    superSapperCharge = {
        label = 'Super Sapper Charge',
		type = 'item',
		key = "superSapperCharge",
		id = 23827,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    runeDemonic = {
        label = 'Demonic Rune',
		type = 'item',
		key = "runeDemonic",
		id = 12662,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    runeDark = {
        label = 'Dark Rune',
		type = 'item',
		key = "runeDark",
		id = 20520,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    }
}

local function GetAllItemCounts(itemID)
    return GetItemCount(itemID), GetItemCount(itemID, true)
end

local function UpdateItemCounts(charInfo)
    charInfo.itemCounts = charInfo.itemCounts or {}
    local self = PermoksAccountManager
    local count, bank
    for itemID, info in pairs(self.item) do
        if not charInfo.itemCounts[info.key] then
            local item = Item:CreateFromItemID(itemID)
            if not item:IsItemEmpty() then
                item:ContinueOnItemLoad(
                    function()
                        local bagCount, totalCount = GetAllItemCounts(itemID)
                        local name = item:GetItemName()
                        local icon = item:GetItemIcon()

                        charInfo.itemCounts[info.key] = {name = name, bank = (totalCount - bagCount), total = totalCount, bags = bagCount, itemID = itemID}

                        if not PermoksAccountManager.db.global.itemIcons[itemID] then
                            PermoksAccountManager.db.global.itemIcons[itemID] = icon
                        end
                    end
                )
            end
        else
            local bagCount, totalCount = GetAllItemCounts(itemID)
            charInfo.itemCounts[info.key].bank = (totalCount - bagCount)
            charInfo.itemCounts[info.key].bags = bagCount
            charInfo.itemCounts[info.key].total = totalCount
        end
    end
end

local function Update(charInfo)
    UpdateItemCounts(charInfo)
end

local payload = {
    update = Update,
    labels = labelRows,
    events = {
        ['BAG_UPDATE_DELAYED'] = UpdateItemCounts
    },
    share = {
        [UpdateItemCounts] = 'itemCounts'
    }
}

PermoksAccountManager:AddModule(module, payload)

function PermoksAccountManager:CreateItemString(itemCounts, itemIcon, name)
    local options = self.db.global.options
    local icon = options.itemIcons and itemIcon or ''
    local iconPosition = options.itemIconPosition

    if itemCounts.bank > 0 then
        local iconString = self.ICONBANKSTRINGS[iconPosition]
        if iconPosition == 'left' then
            return string.format(iconString, icon, itemCounts.bags, itemCounts.bank)
        end
        return string.format(iconString, itemCounts.bags, itemCounts.bank, icon)
    else
        local iconString = self.ICONSTRINGS[iconPosition]
        if iconPosition == 'left' then
            return string.format(iconString, icon, itemCounts.bags)
        end
        return string.format(iconString, itemCounts.bags, icon)
    end
end

function PermoksAccountManager.ItemTooltip_OnEnter(button, altData, labelRow)
    if not altData.itemCounts then
        return
    end
    local info = altData.itemCounts[labelRow.key]
    if not info then
        return
    end

    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
    button.tooltip = tooltip

    tooltip:AddHeader(info.name, '')
    tooltip:AddLine('')
    tooltip:AddLine('Bags:', info.bags)
    tooltip:AddLine('Bank:', info.bank)
    tooltip:AddLine('')
    tooltip:AddLine('|cff00ff00Total:|r', info.total)

    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end
