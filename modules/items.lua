local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateItemCounts()
	local char_table = self.validateData()
	if not char_table then return end

	local  count, bank
	char_table.itemCounts = char_table.itemCounts or {}
	for itemID, info in pairs(self.items) do
		local item = Item:CreateFromItemID(itemID)
		item:ContinueOnItemLoad(function()
			local bagCount = GetItemCount(itemID)
			local totalCount = GetItemCount(itemID, true)
			local name = item:GetItemName()
			local icon = item:GetItemIcon()

			char_table.itemCounts[info.key] = {name = name, bank = (totalCount - bagCount), total = totalCount, bags = bagCount}

			if not AltManager.db.global.itemIcons[itemID] then
				AltManager.db.global.itemIcons[itemID] = icon
			end
		end)
	end
end

function AltManager:CreateItemString(itemCounts, itemID)
	local itemIcon = self.db.global.itemIcons[itemID]
	local iconString
	if itemIcon and self.db.global.options.itemIcons then
		iconString = string.format("\124T%d:20:20\124t", itemIcon)
	end
	
	return string.format("%s%d", iconString or "", itemCounts and itemCounts.bags or 0)
end

function AltManager:ItemTooltip_OnEnter(button, alt_data, key)
	if not alt_data or not alt_data.itemCounts then return end
	local info = alt_data.itemCounts[key]
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