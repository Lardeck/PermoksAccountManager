local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local module = 'items'
local labelRows = {
    flask = {
        label = L['Flasks'],
        type = 'item',
        key = 171276,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    foodHaste = {
        label = L['Haste Food'],
        type = 'item',
        key = 172045,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    augmentRune = {
        label = L['Augment Runes'],
        type = 'item',
        key = 181468,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    armorKit = {
        label = L['Armor Kits'],
        type = 'item',
        key = 172347,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    oilHeal = {
        label = L['Heal Oils'],
        type = 'item',
        key = 171286,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    oilDPS = {
        label = L['DPS Oils'],
        type = 'item',
        key = 171285,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    potHP = {
        label = L['HP Pots'],
        type = 'item',
        key = 171267,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    drum = {
        label = L['Drums'],
        type = 'item',
        key = 172233,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    potManaInstant = {
        label = L['Instant Mana'],
        type = 'item',
        key = 171272,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    potManaChannel = {
        label = L['Channal Mana'],
        type = 'item',
        key = 171268,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    tome = {
        label = L['Tomes'],
        type = 'item',
        key = 173049,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    korthiteCrystal = {
        label = L['Korthite Crystals'],
        type = 'item',
        key = 186017,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    progenitorEssentia = {
        label = L['Progenitor Essentia'],
        type = 'item',
        key = 187707,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    potCosmicHP = {
        label = L['Cosmic HP Pots'],
        type = 'item',
        key = 187802,
        tooltip = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    primevalEssence = {
        label = 'Primeval Essence',
        type = 'item',
        key = 199211,
        group = 'currency',
        version = WOW_PROJECT_MAINLINE
    },
    vaultKey = {
        label = 'Zskera Vault Key',
        type = 'item',
        key = 202196,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    whelpling_crest = {
        label = 'Whelpling Crest (S2)',
        type = 'crest',
        fragment = 204075,
        crest = 204193,
        passRow = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    drake_crest = {
        label = 'Drake Crest (S2)',
        type = 'crest',
        fragment = 204076,
        crest = 204195,
        passRow = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    wyrm_crest = {
        label = 'Wyrm Crest (S2)',
        type = 'crest',
        fragment = 204077,
        crest = 204196,
        passRow = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    aspect_crest = {
        label = 'Aspect Crest (S2)',
        type = 'crest',
        fragment = 204078,
        crest = 204194,
        passRow = true,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    spark_ingenuity = {
        label = 'Spark - Ingenuity',
        type = 'spark',
        passRow = true,
        key = 190453,
        reagent = 199197,
        reagentRequired = 1,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    spark_shadowflame = {
        label = 'Spark - Shadowflame',
        type = 'spark',
        passRow = true,
        key = 204440,
        reagent = 204717,
        reagentRequired = 2,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    unearthed_fragrant_coin = {
        label = "Unearthed Coin",
        type = 'item',
        key = 204715,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    barter_brick = {
        label = "Barter Brick",
        type = 'item',
        key = 204985,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    obsidian_flightstone = {
        label = "Obsidian Flightstone",
        type = 'item',
        key = 202171,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    dilated_time_capsule = {
        label = "Time Capsule",
        type = 'item',
        key = 207030,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },

    -- 10.1.7
    dreamsurge_coalescence = {
        label = 'Dream Coalescence',
        type = 'item',
        key = 207026,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    dreamsurge_chrysalis = {
        label = 'Dream Chrysalis',
        type = 'item',
        key = 208153,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },

    -- 10.2
    spark_dreams = {
        label = 'Spark - Dreams',
        type = 'spark',
        passRow = true,
        key = 206959,
        reagent = 208396,
        reagentRequired = 2,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    dreamseeds = {
        label = 'Dreamseeds',
        type = 'dreamseeds',
        passRow = true,
        seed1 = 208066,
        seed2 = 208067,
        seed3 = 208047,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    dilated_time_pod = {
        label = "Time Pod",
        type = 'item',
        key = 209856,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },
    dreamsurge_cocoon = {
        label = 'Dream Cocoon',
        type = 'item',
        key = 210254,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },

    -- 10.2.6
    spark_awakening = {
        label = 'Spark - Awakening',
        type = 'spark',
        passRow = true,
        key = 211516,
        reagent = 211515,
        reagentRequired = 2,
        group = 'item',
        version = WOW_PROJECT_MAINLINE
    },

    -- tbc
    elixirDemonslaying = {
        label = 'Elixir of Demonslaying',
        type = 'item',
        key = 9224,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    brilliantWizardOil = {
        label = 'Brilliant Wizard Oil',
        type = 'item',
        key = 20749,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    adamantiteSharpeningStone = {
        label = 'Adamantite Sharpening Stone',
        type = 'item',
        key = 23529,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskBlindingLight = {
        label = 'Flask of Blinding Light',
        type = 'item',
        key = 22861,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirAdept = {
        label = "Adept's Elixir",
        type = 'item',
        key = 28103,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirDraenicWisdom = {
        label = 'Elixir of Draenic Wisdom',
        type = 'item',
        key = 32067,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskSupremePower = {
        label = 'Flask of Supreme Power',
        type = 'item',
        key = 13512,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionSuperMana = {
        label = 'Super Mana Potion',
        type = 'item',
        key = 22832,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskChromaticWonder = {
        label = 'Flask of Chromatic Wonder',
        type = 'item',
        key = 33208,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirMajorAgility = {
        label = 'Elixir of Major Agility',
        type = 'item',
        key = 22831,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    giftOfArthas = {
        label = 'Gift of Arthas',
        type = 'item',
        key = 9088,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    spiritOfZanza = {
        label = 'Spirit of Zanza',
        type = 'item',
        key = 20079,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionIronshield = {
        label = 'Ironshield Potion',
        type = 'item',
        key = 22849,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionHaste = {
        label = 'Haste Potion',
        type = 'item',
        key = 22838,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionFreeAction = {
        label = 'Free Action Potion',
        type = 'item',
        key = 5634,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    adamantiteWeightstone = {
        label = 'Adamantite Weightstone',
        type = 'item',
        key = 28421,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirHealingPower = {
        label = 'Elixir of Healing Power',
        type = 'item',
        key = 22825,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    superiorWizardOil = {
        label = 'Superior Wizard Oil',
        type = 'item',
        key = 22522,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirMajorMageblood = {
        label = 'Elixir of Major Mageblood',
        type = 'item',
        key = 22840,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskRelentlessAssault = {
        label = 'Flask of Relentless Assault',
        type = 'item',
        key = 22854,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskPureDeath = {
        label = 'Flask of Pure Death',
        type = 'item',
        key = 22866,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    drumsBattle = {
        label = 'Drums of Battle',
        type = 'item',
        key = 29529,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    potionDestruction = {
        label = 'Destruction Potion',
        type = 'item',
        key = 22839,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flaskFortification = {
        label = 'Flask of Fortification',
        type = 'item',
        key = 22851,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirMajorDefense = {
        label = 'Elixir of Major Defense',
        type = 'item',
        key = 22834,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirMajorShadowPower = {
        label = 'Elixir of Major Defense',
        type = 'item',
        key = 22835,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    elixirEmpowerment = {
        label = 'Elixir of Empowerment',
        type = 'item',
        key = 22848,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    swiftnessOfZanza = {
        label = 'Swiftness of Zanza',
        type = 'item',
        key = 20081,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    thistleTea = {
        label = 'Thistle Tea',
        type = 'item',
        key = 7676,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    flameCap = {
        label = 'Flame Cap',
        type = 'item',
        key = 22788,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    superSapperCharge = {
        label = 'Super Sapper Charge',
        type = 'item',
        key = 23827,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    runeDemonic = {
        label = 'Demonic Rune',
        type = 'item',
        key = 12662,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    runeDark = {
        label = 'Dark Rune',
        type = 'item',
        key = 20520,
        group = 'item',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },

    -- wotlk
    flaskEndlessRage = {
        label = 'Flask of Endless Rage',
        type = 'item',
        key = 46377,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    flaskStoneblood = {
        label = 'Flask of Stoneblood',
        type = 'item',
        key = 46379,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    flaskFrostWyrm = {
        label = 'Flask of Frost Wyrm',
        type = 'item',
        key = 46376,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    flaskPureMojo = {
        label = 'Flask of Pure Mojo',
        type = 'item',
        key = 46378,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    foodFishFeast = {
        label = 'Fish Feast',
        type = 'item',
        key = 43015,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    foodSpicedMammothTreats = {
        label = 'Spiced Mammoth Treats',
        type = 'item',
        key = 43005,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    foodDragonfinFilet = {
        label = 'Dragonfin Filet',
        type = 'item',
        key = 42999,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    foodBlackenedDragonfin = {
        label = 'Blackened Dragonfin',
        type = 'item',
        key = 43000,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    foodFirecrackerSalmon = {
        label = 'Firecracker Salmon',
        type = 'item',
        key = 34767,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    foodTenderShoveltuskSteak = {
        label = 'Tender Shoveltusk Steak',
        type = 'item',
        key = 34755,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    potionOfSpeed = {
        label = 'Potion of Speed',
        type = 'item',
        key = 40211,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    potionOfWildMagic = {
        label = 'Potion of Wild Magic',
        type = 'item',
        key = 40212,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    potionIndestructible = {
        label = 'Indestructible Potion',
        type = 'item',
        key = 40093,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    potionRunicManaInjector = {
        label = 'Runic Mana Injector',
        type = 'item',
        key = 42545,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    potionRunicHealingInjector = {
        label = 'Runic Healing Injector',
        type = 'item',
        key = 41166,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    potionRunicMana = {
        label = 'Runic Mana Potion',
        type = 'item',
        key = 33448,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    potionRunicHealing = {
        label = 'Runic Healing Potion',
        type = 'item',
        key = 33447,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    engiGlobalThermalSapperCharge = {
        label = 'Global Thermal Sapper Charge',
        type = 'item',
        key = 42641,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    engiSaroniteBomb = {
        label = 'Saronite Bomb',
        type = 'item',
        key = 41119,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    trophyOfTheCrusade = {
        label = 'Trophy of the Crusade',
        type = 'item',
        key = 47242,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    frozenOrb = {
        label = 'Frozen Orb',
        type = 'item',
        key = 43102,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    runedOrb = {
        label = 'Runed Orb',
        type = 'item',
        key = 45087,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    crusaderOrb = {
        label = 'Crusader Orb',
        type = 'item',
        key = 47556,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
    primordialSaronite = {
        label = 'Primordial Saronite',
        type = 'item',
        key = 49908,
        group = 'item',
        version = WOW_PROJECT_CATACLYSM_CLASSIC
    },
}

local function GetAllItemCounts(itemID)
    return C_Item.GetItemCount(itemID), C_Item.GetItemCount(itemID, true)
end

local SaveItemCounts
do
    local cachedItemInfo = {}
    function SaveItemCounts(charInfo, itemID)
        if not cachedItemInfo[itemID] then
            local item = Item:CreateFromItemID(itemID)
            if not item:IsItemEmpty() and C_Item.GetItemInfoInstant(itemID) then
                item:ContinueOnItemLoad(
                    function()
                        cachedItemInfo[itemID] = true
                        local bagCount, totalCount = GetAllItemCounts(itemID)
                        local name = item:GetItemName()
                        local icon = item:GetItemIcon()
                        charInfo.itemCounts[itemID] = { name = name, bank = (totalCount - bagCount), total = totalCount,
                            bags = bagCount, itemID = itemID, icon = icon }
                    end
                )
            end
        else
            local bagCount, totalCount = GetAllItemCounts(itemID)
            charInfo.itemCounts[itemID] = charInfo.itemCounts[itemID] or {}
            charInfo.itemCounts[itemID].bank = (totalCount - bagCount)
            charInfo.itemCounts[itemID].bags = bagCount
            charInfo.itemCounts[itemID].total = totalCount
        end
    end
end

local function UpdateItemCounts(charInfo)
    charInfo.itemCounts = charInfo.itemCounts or {}
    local self = PermoksAccountManager
    for itemID, _ in pairs(self.item) do
        SaveItemCounts(charInfo, itemID)
    end
end

local function Update(charInfo)
    UpdateItemCounts(charInfo)
end

local function CreateCrestString(labelRow, itemCounts)
    local fragmentInfo = itemCounts[labelRow.fragment]
    local fragmentCount = fragmentInfo and itemCounts[labelRow.fragment].total
    local crestInfo = itemCounts[labelRow.crest]
    local crestCount = crestInfo and itemCounts[labelRow.crest].total

    local crestString = PermoksAccountManager:CreateItemString(nil, (crestCount or 0), crestInfo and crestInfo.icon)
    local fragmentString = PermoksAccountManager:CreateItemString(nil, (fragmentCount or 0), fragmentInfo and fragmentInfo.icon)
    return string.format("%s - %s", crestString, fragmentString)
end

local function CreateSparkString(labelRow, itemCounts)
    local sparkInfo = itemCounts[labelRow.key]
    local reagentInfo = itemCounts[labelRow.reagent]

    local total = 0
    if sparkInfo then
        total = total + sparkInfo.total
    end

    if reagentInfo then
        total = total + (reagentInfo.total / labelRow.reagentRequired)
    end

    return PermoksAccountManager:CreateItemString(nil, total, (sparkInfo and sparkInfo.icon or C_Item.GetItemIcon(labelRow.key)))
end

local function CreateDreamSeedString(labelRow, itemCounts)
    if itemCounts then
        local seed1Info = itemCounts[labelRow.seed1]
        local seed2Info = itemCounts[labelRow.seed2]
        local seed3Info = itemCounts[labelRow.seed3]

        local strings = {}
        tinsert(strings, PermoksAccountManager:CreateItemString(nil, seed1Info.total, (seed1Info and seed1Info.icon)))
        tinsert(strings, PermoksAccountManager:CreateItemString(nil, seed2Info.total, (seed2Info and seed2Info.icon)))
        tinsert(strings, PermoksAccountManager:CreateItemString(nil, seed3Info.total, (seed3Info and seed3Info.icon)))


        return table.concat(strings, " ")
    end

    return " "
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
local module = PermoksAccountManager:AddModule(module, payload)
module:AddCustomLabelType('crest', CreateCrestString, nil, 'itemCounts')
module:AddCustomLabelType('spark', CreateSparkString, nil, 'itemCounts')
module:AddCustomLabelType('dreamseeds', CreateDreamSeedString, nil, 'itemCounts')


function PermoksAccountManager:CreateItemString(itemInfo, total, icon)
    local options = self.db.global.options
    local icon = options.itemIcons and (itemInfo and itemInfo.icon or icon) or ''
    local iconPosition = options.itemIconPosition

    local bank, bags = 0, total
    if itemInfo then
        bank, bags = itemInfo.bank, itemInfo.bags
    end

    if bank > 0 then
        local iconString = self.ICONBANKSTRINGS[iconPosition]
        if iconPosition == 'left' then
            return string.format(iconString, icon, bags, bank)
        end
        return string.format(iconString, bags, bank, icon)
    else
        local iconString = self.ICONSTRINGS[iconPosition]
        if iconPosition == 'left' then
            return string.format(iconString, icon, bags)
        end
        return string.format(iconString, bags, icon)
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
