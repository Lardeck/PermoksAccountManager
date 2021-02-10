local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateAllCurrencies()
	local char_table = self.validateData()
	if not char_table then return end
	char_table.currencyInfo = char_table.currencyInfo or {}

	local currencyInfo = {}
	for currencyType in pairs(self.currencies) do
		local info = C_CurrencyInfo.GetCurrencyInfo(currencyType)
		currencyInfo[currencyType] = (type(char_table.currencyInfo[currencyType]) == "table" and char_table.currencyInfo[currencyType]) or {name = info.name}
		currencyInfo[currencyType].quantity = info.quantity
		currencyInfo[currencyType].maxQuantity = info.maxQuantity
		currencyInfo[currencyType].totalEarned = info.totalEarned
	end

	char_table.currencyInfo = currencyInfo
end

function AltManager:UpdateCurrency(currencyType, quantity, quantityChange, gained, lost)
	if not currencyType or not self.currencies[currencyType] then return end
	local char_table = self.validateData()
	if not char_table then return end
	if type(char_table.currencyInfo[currencyType]) ~= "table" then AltManager:UpdateAllCurrencies() end

	char_table.currencyInfo[currencyType].quantity = quantity
end

function AltManager:CreateCurrencyString(currencyInfo, abbreviateCurrent, abbreviateMaximum, hideMaximum)
	if not currencyInfo or type(currencyInfo) ~= "table" then return end

	if not hideMaximum and currencyInfo.maxQuantity and currencyInfo.maxQuantity > 0 then
		return self:CreateFractionString(currencyInfo.quantity, currencyInfo.maxQuantity, abbreviateCurrent, abbreviateMaximum)
	else
		return abbreviateCurrent and AbbreviateNumbers(currencyInfo.quantity) or AbbreviateLargeNumbers(currencyInfo.quantity)
	end
end

function AltManager:CurrencyTooltip_OnEnter(button, alt_data, currencyId)
	if not alt_data or not alt_data.currencyInfo then return end
	local currencyInfo = alt_data.currencyInfo[currencyId]
	if not currencyInfo or not currencyInfo.name or (currencyInfo.totalEarned or 0) == 0 then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader(currencyInfo.name)
	tooltip:AddLine("")

	tooltip:AddLine("Total Earned:", self:CreateFractionString(currencyInfo.totalEarned, currencyInfo.maxQuantity))

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end