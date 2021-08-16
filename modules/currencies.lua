local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

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
	local torghastSoulCinders = {
		[8] = 50,
		[9] = 90,
		[10] = 120,
		[11] = 150,
		[12] = 180,
	}

	function AltManager:SoulCindersTooltip_OnEnter(button, alt_data)
		if not alt_data or not alt_data.questInfo or not alt_data.questInfo.biweekly or not alt_data.torghastInfo then return end
		local torghastInfo = alt_data.torghastInfo
		local weekly = alt_data.questInfo.weekly
		local biweekly = alt_data.questInfo.biweekly

		local assaults = AltManager:GetNumCompletedQuests(biweekly.hidden.assault) * 50
		local tormentors = weekly.hidden.tormentors_weekly and next(weekly.hidden.tormentors_weekly) and 50 or 0

		local torghast = 0
		for layer, completed in pairs(torghastInfo) do
			if torghastSoulCinders[completed] then
				torghast = torghast + torghastSoulCinders[completed]
			end
		end

		local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
		button.tooltip = tooltip
		tooltip:AddHeader(alt_data.currencyInfo[1906].name)
		tooltip:AddLine("Assaults:", AltManager:CreateFractionString(assaults, 100))
		tooltip:AddLine("Tormentors:", AltManager:CreateFractionString(tormentors, 50))
		tooltip:AddLine("Torghast:", AltManager:CreateFractionString(torghast, 360))
		tooltip:AddSeparator(2, 1, 1, 1)
		tooltip:AddLine("|cff00f7ffTotal:|r", AltManager:CreateFractionString(assaults + tormentors + torghast, 510))
		tooltip:SmartAnchorTo(button)
		tooltip:Show()
	end
end

do 
	local raidBossEmbers = {
		[17] = 1,
		[14] = 2,
		[15] = 3,
		[16] = 4,
	}

	local function GetEmbersForDifficulty(embersTable, difficulty)

		local totalNumEmbers = 0
		for boss, numEmbers in ipairs(embersTable) do
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

	function AltManager:StygianEmbersTooltip_OnEnter(button, alt_data)
		if not alt_data or not alt_data.raidActivityInfo or not alt_data.questInfo then return end
		local raidActivityInfo = alt_data.raidActivityInfo
		local questInfo = alt_data.questInfo.weekly

		local embersFromRaidBosses = {}
		for i, encounter in ipairs(raidActivityInfo) do
	        if raidBossEmbers[encounter.bestDifficulty] then
	            embersFromRaidBosses[encounter.uiOrder] = (embersFromRaidBosses[encounter.uiOrder] or 0) + raidBossEmbers[encounter.bestDifficulty]
	        end
	    end

	    local embersFromShapingFate = next(questInfo.visible.korthia_weekly) and 10 or 0
	    local embersFromWB = questInfo.hidden.world_boss[64531] and 1 or 0
	    local embersFromNormalRaidTrash = self:GetNumCompletedQuests(questInfo.hidden.sanctum_normal_embers_trash)
	    local embersFromHeroicRaidTrash = self:GetNumCompletedQuests(questInfo.hidden.sanctum_heroic_embers_trash)
	    local total = GetTotalNumRaidEmbers(embersFromRaidBosses) + embersFromShapingFate + embersFromWB + embersFromNormalRaidTrash + embersFromHeroicRaidTrash

		local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
		button.tooltip = tooltip
		tooltip:AddHeader(alt_data.currencyInfo[1977].name)
		tooltip:AddLine("LFR Raid:", AltManager:CreateFractionString(GetEmbersForDifficulty(embersFromRaidBosses, 17), 10))
		tooltip:AddLine("Normal Raid:", AltManager:CreateFractionString(GetEmbersForDifficulty(embersFromRaidBosses, 14), 10))
		tooltip:AddLine("Heroic Raid:", AltManager:CreateFractionString(GetEmbersForDifficulty(embersFromRaidBosses, 15), 10))
		tooltip:AddLine("Mythic Raid:", AltManager:CreateFractionString(GetEmbersForDifficulty(embersFromRaidBosses, 16), 10))
		tooltip:AddSeparator(2, 1, 1, 1)
		tooltip:AddLine("Normal Trash:", AltManager:CreateFractionString(embersFromNormalRaidTrash, 5))
		tooltip:AddLine("Heroic Trash:", AltManager:CreateFractionString(embersFromHeroicRaidTrash, 5))
		tooltip:AddSeparator(2, 1, 1, 1)
		tooltip:AddLine("Shaping Fate:", AltManager:CreateFractionString(embersFromShapingFate, 10))
		tooltip:AddSeparator(2, 1, 1, 1)
		tooltip:AddLine("World Boss:", AltManager:CreateFractionString(embersFromWB, 1))
		tooltip:AddSeparator(2, 1, 1, 1)
		tooltip:AddLine("|cff00f7ffTotal:|r", AltManager:CreateFractionString(total, 61))
		tooltip:SmartAnchorTo(button)
		tooltip:Show()
	end
end