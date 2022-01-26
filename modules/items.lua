local addonName, PermoksAccountManager = ...
local LibQTip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local module = "items"
local labelRows = {
	flask = {
		label = L["Flasks"],
		type = "item",
		key = "flask",
		id = 171276,
		tooltip = true,
		group = "item",
	},
	foodHaste = {
		label = L["Haste Food"],
		type = "item",
		key = "foodHaste",
		id = 172045,
		tooltip = true,
		group = "item",
	},
	augmentRune = {
		label = L["Augment Runes"],
		type = "item",
		key = "augmentRune",
		id = 181468,
		tooltip = true,
		group = "item",
	},
	armorKit = {
		label = L["Armor Kits"],
		type = "item",
		key = "armorKit",
		id = 172347,
		tooltip = true,
		group = "item",
	},
	oilHeal = {
		label = L["Heal Oils"],
		type = "item",
		key = "oilHeal",
		id = 171286,
		tooltip = true,
		group = "item",
	},
	oilDPS = {
		label = L["DPS Oils"],
		type = "item",
		key = "oilDPS",
		id = 171285,
		tooltip = true,
		group = "item",
	},
	potHP = {
		label = L["HP Pots"],
		type = "item",
		key = "potHP",
		id = 171267,
		tooltip = true,
		group = "item",
	},
	drum = {
		label = L["Drums"],
		type = "item",
		key = "drum",
		id = 172233,
		tooltip = true,
		group = "item",
	},
	potManaInstant = {
		label = L["Instant Mana"],
		type = "item",
		key = "potManaInstant",
		id = 171272,
		tooltip = true,
		group = "item",
	},
	potManaChannel = {
		label = L["Channal Mana"],
		type = "item",
		key = "potManaChannel",
		id = 171268,
		tooltip = true,
		group = "item",
	},
	tome = {
		label = L["Tomes"],
		type = "item",
		key = "tome",
		id = 173049,
		tooltip = true,
		group = "item",
	},
	korthiteCrystal = {
		label = L["Korthite Crystals"],
		type = "item",
		key = "korthiteCrystal",
		id = 186017,
		tooltip = true,
		group = "item",
	},
  -- tbc
  shatteredHallsKey = {
		label = "Shattered Halls",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.shatteredHallsKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.shatteredHallsKey.total, 1, true)) or "-" end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
    arcatrazKey = {
		label = "Arcatraz",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.arcatrazKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.arcatrazKey.total, 1, true)) or "-" end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	citadelKey = {
		label = "Hellfire Citadel",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.citadelKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.citadelKey.total, 1, true)) or "-" end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	reservoirKey = {
		label = "Coilfang Reservoir",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.reservoirKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.reservoirKey.total, 1, true)) or "-" end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	auchenaiKey = {
		label = "Auchindoun",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.auchenaiKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.auchenaiKey.total, 1, true)) or "-" end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	warpforgedKey = {
		label = "Tempest Keep",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.warpforgedKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.warpforgedKey.total, 1, true)) or "-" end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	keyOfTime = {
		label = "Caverns of Time",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.keyOfTime and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.keyOfTime.total, 1, true)) or "-" end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirDemonslaying = {
		label = "Elixir of Demonslaying",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirDemonslaying, 9224) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirDemonslaying") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	brilliantWizardOil = {
		label = "Brilliant Wizard Oil",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.brilliantWizardOil, 20749) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "brilliantWizardOil") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	adamantiteSharpeningStone = {
		label = "Adamantite Sharpening Stone",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.adamantiteSharpeningStone, 23529) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "adamantiteSharpeningStone") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	flaskBlindingLight = {
		label = "Flask of Blinding Light",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.flaskBlindingLight, 22861) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "flaskBlindingLight") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirAdept = {
		label = "Adept's Elixir",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirAdept, 28103) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirAdept") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirDraenicWisdom = {
		label = "Elixir of Draenic Wisdom",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirDraenicWisdom, 32067) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirDraenicWisdom") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	flaskSupremePower = {
		label = "Flask of Supreme Power",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.flaskSupremePower, 13512) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "flaskSupremePower") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	potionSuperMana = {
		label = "Super Mana Potion",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.potionSuperMana, 22832) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "potionSuperMana") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	flaskChromaticWonder = {
		label = "Flask of Chromatic Wonder",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.flaskChromaticWonder, 33208) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "flaskChromaticWonder") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirMajorAgility = {
		label = "Elixir of Major Agility",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirMajorAgility, 22831) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirMajorAgility") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	giftOfArthas = {
		label = "Gift of Arthas",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.giftOfArthas, 9088) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "giftOfArthas") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	spiritOfZanza = {
		label = "Spirit of Zanza",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.spiritOfZanza, 20079) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "spiritOfZanza") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	potionIronshield = {
		label = "Ironshield Potion",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.potionIronshield, 22849) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "potionIronshield") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	potionHaste = {
		label = "Haste Potion",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.potionHaste, 22838) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "potionHaste") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	potionFreeAction = {
		label = "Free Action Potion",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.potionFreeAction, 5634
			) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "potionFreeAction") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	adamantiteWeightstone = {
		label = "Adamantite Weightstone",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.adamantiteWeightstone, 28421) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "adamantiteWeightstone") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirHealingPower = {
		label = "Elixir of Healing Power",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirHealingPower, 22825) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirHealingPower") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	superiorWizardOil = {
		label = "Superior Wizard Oil",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.superiorWizardOil, 22522) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "superiorWizardOil") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirMajorMageblood = {
		label = "Elixir of Major Mageblood",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirMajorMageblood, 22840) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirMajorMageblood") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	flaskRelentlessAssault = {
		label = "Flask of Relentless Assault",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.flaskRelentlessAssault, 22854) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "flaskRelentlessAssault") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	flaskPureDeath = {
		label = "Flask of Pure Death",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.flaskPureDeath, 22866) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "flaskPureDeath") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	drumsBattle = {
		label = "Drums of Battle",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.drumsBattle, 29529) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "drumsBattle") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	potionDestruction = {
		label = "Destruction Potion",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.potionDestruction, 22839) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "potionDestruction") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	flaskFortification = {
		label = "Flask of Fortification",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.flaskFortification, 22851) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "flaskFortification") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirMajorDefense = {
		label = "Elixir of Major Defense",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirMajorDefense, 22834) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirMajorDefense") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirMajorShadowPower = {
		label = "Elixir of Major Defense",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirMajorShadowPower, 22835) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirMajorShadowPower") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	elixirEmpowerment = {
		label = "Elixir of Empowerment",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.elixirEmpowerment, 22848) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "elixirEmpowerment") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	swiftnessOfZanza = {
		label = "Swiftness of Zanza",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.swiftnessOfZanza, 20081) end,
		tooltip = function(button, alt_data) PermoksAccountManager:ItemTooltip_OnEnter(button, alt_data, "swiftnessOfZanza") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	thistleTea = {
		label = "Thistle Tea",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.thistleTea, 7676) end,
		tooltip = function(button, alt_data) PermoksAccountManager.ItemTooltip_OnEnter(button, alt_data, "thistleTea") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	flameCap = {
		label = "Flame Cap",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.flameCap, 22788) end,
		tooltip = function(button, alt_data) PermoksAccountManager.ItemTooltip_OnEnter(button, alt_data, "flameCap") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	superSapperCharge = {
		label = "Super Sapper Charge",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.superSapperCharge, 23827) end,
		tooltip = function(button, alt_data) PermoksAccountManager.ItemTooltip_OnEnter(button, alt_data, "superSapperCharge") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	runeDemonic = {
		label = "Demonic Rune",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.runeDemonic, 12662) end,
		tooltip = function(button, alt_data) PermoksAccountManager.ItemTooltip_OnEnter(button, alt_data, "runeDemonic") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
	runeDark = {
		label = "Dark Rune",
		data = function(alt_data) return PermoksAccountManager:CreateItemString(alt_data.itemCounts.runeDark, 20520) end,
		tooltip = function(button, alt_data) PermoksAccountManager.ItemTooltip_OnEnter(button, alt_data, "runeDark") end,
		group = "item",
    version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
	},
}

local function GetAllItemCounts(itemID)
	return GetItemCount(itemID), GetItemCount(itemID, true)
end

local function UpdateItemCounts(charInfo)
	charInfo.itemCounts = charInfo.itemCounts or {}
	local self = PermoksAccountManager
	local  count, bank
	for itemID, info in pairs(self.item) do
		if not charInfo.itemCounts[info.key] then
			local item = Item:CreateFromItemID(itemID)
			if not item:IsItemEmpty() then
				item:ContinueOnItemLoad(function()
					local bagCount, totalCount = GetAllItemCounts(itemID)
					local name = item:GetItemName()
					local icon = item:GetItemIcon()

					charInfo.itemCounts[info.key] = {name = name, bank = (totalCount - bagCount), total = totalCount, bags = bagCount, itemID = itemID}

					if not PermoksAccountManager.db.global.itemIcons[itemID] then
						PermoksAccountManager.db.global.itemIcons[itemID] = icon
					end
				end)
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
		["BAG_UPDATE_DELAYED"] = UpdateItemCounts,
	},
	share = {
		[UpdateItemCounts] = "itemCounts",
	}
}

PermoksAccountManager:AddModule(module, payload)

function PermoksAccountManager:CreateItemString(itemCounts, itemIcon, name)
	local options = self.db.global.options
	local icon = options.itemIcons and itemIcon or ""
	local iconPosition = options.itemIconPosition

	if itemCounts.bank > 0 then
		local iconString = self.ICONBANKSTRINGS[iconPosition]
		if iconPosition == "left" then
			return string.format(iconString, icon, itemCounts.bags, itemCounts.bank)
		end
		return string.format(iconString, itemCounts.bags, itemCounts.bank, icon)
	else
		local iconString = self.ICONSTRINGS[iconPosition]
		if iconPosition == "left" then
			return string.format(iconString, icon, itemCounts.bags)
		end
		return string.format(iconString, itemCounts.bags, icon)
	end
end

function PermoksAccountManager.ItemTooltip_OnEnter(button, altData, labelRow)
	if not altData.itemCounts then return end
	local info = altData.itemCounts[labelRow.key]
	if not info then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader(info.name, '')
	tooltip:AddLine("")
	tooltip:AddLine("Bags:", info.bags)
	tooltip:AddLine("Bank:", info.bank)
	tooltip:AddLine("")
	tooltip:AddLine("|cff00ff00Total:|r", info.total)

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end