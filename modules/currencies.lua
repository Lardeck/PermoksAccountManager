local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateAllCurrencies()
	local char_table = self.validateData()
	if not char_table then return end
	char_table.currencyInfo = char_table.currencyInfo or {}

	local currencyInfo = {}
	for currencyType in pairs(self.currencies) do
		local info = C_CurrencyInfo.GetCurrencyInfo(currencyType)
		if info then
			currencyInfo[currencyType] = (type(char_table.currencyInfo[currencyType]) == "table" and char_table.currencyInfo[currencyType]) or {name = info.name}

			if currencyType ~= 1810 and info.maxQuantity > 0 and info.quantity > info.maxQuantity then
				info.quantity = info.quantity / 100
			end			

			currencyInfo[currencyType].currencyType = currencyType
			currencyInfo[currencyType].quantity = info.quantity
			currencyInfo[currencyType].maxQuantity = info.maxQuantity
			currencyInfo[currencyType].totalEarned = info.totalEarned
			
			if not self.db.global.currencyIcons[info.name] then
				self.db.global.currencyIcons[info.name] = info.iconFileID
			end
		end
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

	local iconString
	local currencyIcon = self.db.global.currencyIcons[currencyInfo.name] 
	if currencyIcon and self.db.global.options.currencyIcons then
		iconString = string.format("\124T%d:18:18\124t", currencyIcon)
	end

	local currencyString
	if not hideMaximum and currencyInfo.maxQuantity and currencyInfo.maxQuantity > 0 then
		currencyString = self:CreateFractionString(currencyInfo.quantity, currencyInfo.maxQuantity, abbreviateCurrent, abbreviateMaximum)
	else
		currencyString = abbreviateCurrent and AbbreviateNumbers(currencyInfo.quantity) or AbbreviateLargeNumbers(currencyInfo.quantity)
	end

	return string.format("%s %s", currencyString, iconString or "")
end

function AltManager:CurrencyTooltip_OnEnter(button, alt_data, currencyId)
	if not alt_data or not alt_data.currencyInfo then return end
	local currencyInfo = alt_data.currencyInfo[currencyId]
	if not currencyInfo or not currencyInfo.name then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader(currencyInfo.name)
	tooltip:AddLine("")

	tooltip:AddLine("Total Earned:", self:CreateFractionString(currencyInfo.totalEarned, currencyInfo.maxQuantity))

	if (currencyInfo.maxQuantity or 0) > currencyInfo.totalEarned then
		tooltip:AddLine("Left:", currencyInfo.maxQuantity - currencyInfo.totalEarned)
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end

do
	local currencyEvents = {
		"CURRENCY_DISPLAY_UPDATE",
	}

	local currencyFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(currencyFrame, currencyEvents)

	currencyFrame:SetScript("OnEvent", function(self, e, ...)
		if AltManager.addon_loaded then
			AltManager:UpdateCurrency(...)
			AltManager:UpdateCompletionDataForCharacter()
			AltManager:SendCharacterUpdate("currencyInfo")
		end
	end)
end