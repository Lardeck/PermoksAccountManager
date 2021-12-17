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
	local icon = self.db.global.options.itemIcons and itemIcon or ""
	
	if itemCounts.bank > 0 then
		return string.format(self.currentString.itemWithBank, itemCounts.bags, itemCounts.bank, icon)
	else
		return string.format(self.currentString.item, itemCounts.bags, icon)
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