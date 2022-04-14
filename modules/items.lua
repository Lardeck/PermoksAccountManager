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
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
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
    }
}

local function GetAllItemCounts(itemID)
    return GetItemCount(itemID), GetItemCount(itemID, true)
end

local SaveItemCounts
do
	local cachedItemInfo = {}
	function SaveItemCounts(charInfo, itemID)
		if not cachedItemInfo[itemID] then
			local item = Item:CreateFromItemID(itemID)
			if not item:IsItemEmpty() then
				item:ContinueOnItemLoad(
					function()
						cachedItemInfo[itemID] = true
						local bagCount, totalCount = GetAllItemCounts(itemID)
						local name = item:GetItemName()
						local icon = item:GetItemIcon()
						charInfo.itemCounts[itemID] = {name = name, bank = (totalCount - bagCount), total = totalCount, bags = bagCount, itemID = itemID, icon = icon}
					end
				)
			end
		else
			local bagCount, totalCount = GetAllItemCounts(itemID)
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

function PermoksAccountManager:CreateItemString(itemInfo)
    local options = self.db.global.options
    local icon = options.itemIcons and itemInfo.icon or ''
    local iconPosition = options.itemIconPosition

    if itemInfo.bank > 0 then
        local iconString = self.ICONBANKSTRINGS[iconPosition]
        if iconPosition == 'left' then
            return string.format(iconString, icon, itemInfo.bags, itemInfo.bank)
        end
        return string.format(iconString, itemInfo.bags, itemInfo.bank, icon)
    else
        local iconString = self.ICONSTRINGS[iconPosition]
        if iconPosition == 'left' then
            return string.format(iconString, icon, itemInfo.bags)
        end
        return string.format(iconString, itemInfo.bags, icon)
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
