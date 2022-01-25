local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local customCovenantColors = {
	[1] = CreateColorFromHexString("ffb1e6f5"),
	[2] = COVENANT_COLORS[2],
	[3] = CreateColorFromHexString("ff4257ff"),
	[4] = COVENANT_COLORS[4],
}


local labelRows = {
	covenant = {
		label = L["Covenant"],
		type = "covenant",
		data = function(alt_data) return PermoksAccountManager:CreateCovenantString(alt_data) end,
		version = WOW_PROJECT_MAINLINE,
	},
	renown = {
		label = L["Renown"],
		data = function(alt_data) return PermoksAccountManager:CreateRenownString(alt_data) end,
		version = WOW_PROJECT_MAINLINE,
	},
	callings = {
		label = L["Callings"],
		customTooltip = function(button, alt_data) PermoksAccountManager:CallingTooltip_OnEnter(button, alt_data) end,
		tooltip = true,
		data = function(alt_data) return PermoksAccountManager:CreateCallingString(alt_data.callingInfo) end,
		group = "resetDaily",
		version = WOW_PROJECT_MAINLINE,
	},
	transport_network = {
		label = L["Transport Network"],
		type = "sanctum",
		key = 2,
		group = "sanctum",
		version = WOW_PROJECT_MAINLINE,
	},
	anima_conductor = {
		label = L["Anima Conductor"],
		type = "sanctum",
		key = 1,
		group = "sanctum",
		version = WOW_PROJECT_MAINLINE,
	},
	command_table = {
		label = L["Command Table"],
		type = "sanctum",
		key = 3,
		group = "sanctum",
		version = WOW_PROJECT_MAINLINE,
	},
	sanctum_unique = {
		label = L["Unique"],
		type = "sanctum",
		key = 5,
		group = "sanctum",
		version = WOW_PROJECT_MAINLINE,
	},
	sanctum_quests = {
		label = L["Covenant Specific"],
		data = function(alt_data) 
			if alt_data.covenant then
				local covenant = alt_data.covenant
				local rightFeatureType = (covenant == 3 and 2) or (covenant == 4 and 5) or 0
				return (alt_data.questInfo and alt_data.questInfo.daily and PermoksAccountManager:CreateSanctumString(alt_data.sanctumInfo, rightFeatureType, alt_data.questInfo.daily.visible.transport_network, alt_data.questInfo.maxnfTransport or 1)) or "-" 
			else
				return "-"
			end
		end,
		group = "resetDaily",
		version = WOW_PROJECT_MAINLINE,
	},
}

local function GetCurrentTier(talents)
	local currentTier = 0;
	for i, talentInfo in ipairs(talents) do
		if talentInfo.talentAvailability == Enum.GarrisonTalentAvailability.UnavailableAlreadyHave then
			currentTier = currentTier + 1;
		end
	end
	return currentTier
end

local function UpdateCallings(charInfo, callings)
	local self = PermoksAccountManager
	if not callings and not IsAddOnLoaded("Blizzard_CovenantCallings") then 
		UIParentLoadAddOn("Blizzard_CovenantCallings") 
		self:RequestCharacterInfo() 
		return 
	end

	if not charInfo.covenant or not charInfo.callingsUnlocked then charInfo.callingInfo = nil return end
	self.db.global.currentCallings[charInfo.covenant] = self.db.global.currentCallings[charInfo.covenant] or {}
	charInfo.callingInfo = charInfo.callingInfo or {}

	local callingInfo = charInfo.callingInfo
	local currentCallings = self.db.global.currentCallings[charInfo.covenant]

	callingInfo.numCallings = 0
	for index = 1, Constants.Callings.MaxCallings do
		local calling = callings[index];
		if calling then
			local timeLeft = C_TaskQuest.GetQuestTimeLeftSeconds(calling.questID)
			local oldTimeRemaining = charInfo.callingInfo and charInfo.callingInfo[calling.questID]
			local timeLeftInTime = (oldTimeRemaining and oldTimeRemaining > time() and oldTimeRemaining) or timeLeft and time() + timeLeft
			callingInfo[calling.questID] = timeLeftInTime
			callingInfo.numCallings = callingInfo.numCallings + 1
			currentCallings[calling.questID] = {name = C_QuestLog.GetTitleForQuestID(calling.questID), timeRemaining = timeLeftInTime}
		end
	end
end

local function UpdateSanctumBuildings(charInfo)
	local self = PermoksAccountManager
	local covenant = charInfo.covenant or C_Covenants.GetActiveCovenantID()
	if not covenant or not self.sanctum[covenant] then return end
	charInfo.sanctumInfo = charInfo.sanctumInfo or {}

	local sanctumInfo = charInfo.sanctumInfo
	for featureType, talentTreeID in pairs(self.sanctum[covenant]) do
		local talentTree = C_Garrison.GetTalentTreeInfo(talentTreeID)
		if talentTree then
			local oldTier = sanctumInfo[featureType] and sanctumInfo[featureType].tier
			local currentTier = GetCurrentTier(talentTree.talents)
			sanctumInfo[featureType] = ((not oldTier or currentTier > oldTier) and {tier = currentTier, name = talentTree.title}) or sanctumInfo[featureType]
		end
	end
end

local function UpdateRenown(charInfo, newRenown)
	if type(charInfo.renown) ~= "table" then
		charInfo.renown = {}
	end

	charInfo.renown = charInfo.renown or {}

	C_Timer.After(0.5, function()
		charInfo.renown[charInfo.covenant] = newRenown or C_CovenantSanctumUI.GetRenownLevel()
	end)
end

local function UpdateCovenant(charInfo, covenant)
	covenant = covenant or C_Covenants.GetActiveCovenantID()
	charInfo.covenant = covenant
end

local function Update(charInfo)
	UpdateSanctumBuildings(charInfo)
	UpdateCallings(charInfo)
	UpdateCovenant(charInfo)
	UpdateRenown(charInfo)
end


local function CreateCallingString(callingInfo)
	if not callingInfo then return "-" end

	local leastTimeLeft
	for questID, timeLeft in pairs(callingInfo) do
		if type(questID) == "number" then
			if timeLeft > time() and (not leastTimeLeft or timeLeft < leastTimeLeft) then
				leastTimeLeft = timeLeft
			end
		end
	end

	if leastTimeLeft then
		local days, hours, minutes = self:TimeToDaysHoursMinutes(leastTimeLeft)
		return string.format("%s - %s", self:CreateQuestString(3 - callingInfo.numCallings, 3), self:CreateTimeString(days, hours, minutes))
	else
		return string.format("%s", self:CreateQuestString(3 - callingInfo.numCallings, 3))
	end
end

local function CreateCovenantString(charInfo)
end

local moduleName = "covenant"
local payload = {
	update = Update,
	events = {
		["COVENANT_CALLINGS_UPDATED"] = UpdateCallings,
		["COVENANT_SANCTUM_INTERACTION_ENDED"] = UpdateSanctumBuildings,
		["COVENANT_CHOSEN"] = UpdateCovenant,
		["COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED"] = UpdateRenown,
	},
	share = {
		[UpdateCallings] = "callingInfo",
		[UpdateSanctumBuildings] = "sanctumInfo",
		[UpdateCovenant] = "covenantInfo",
		[UpdateRenown] = "covenantInfo",
	},
	functionInfo = {
		[UpdateCallings] = {
			share = true,
			infoKey = "callingInfo",
		},
		[UpdateSanctumBuildings] = {
			share = true,
			infoKey = "sanctumInfo",
		},
	},
	labels = labelRows
}
local module = PermoksAccountManager:AddModule(moduleName, payload)
module:AddCustomLabelType("calling", CreateCallingString, "callingInfo")
module:AddCustomLabelType("covenant", CreateCovenantString, "covenant")
module:AddCustomLabelType("renown", CreateRenownString, "renwon")

function PermoksAccountManager:CreateCallingString(callingInfo)
	if not callingInfo then return "-" end

	local leastTimeLeft
	for questID, timeLeft in pairs(callingInfo) do
		if type(questID) == "number" then
			if timeLeft > time() and (not leastTimeLeft or timeLeft < leastTimeLeft) then
				leastTimeLeft = timeLeft
			end
		end
	end

	if leastTimeLeft then
		local days, hours, minutes = self:TimeToDaysHoursMinutes(leastTimeLeft)
		return string.format("%s - %s", self:CreateQuestString(3 - callingInfo.numCallings, 3), self:CreateTimeString(days, hours, minutes))
	else
		return string.format("%s", self:CreateQuestString(3 - callingInfo.numCallings, 3))
	end
end

function PermoksAccountManager:CreateSanctumString(sanctumInfo, featureType, numQuestCompleted, numRequiredQuests)
	if not sanctumInfo or not sanctumInfo[featureType] or not numQuestCompleted then return end

	local shortenedName = sanctumInfo[featureType].name:gsub("(%w)%w*-?", function(a) return a end)
	return string.format("%s - %s", shortenedName, self:CreateQuestString(numQuestCompleted, numRequiredQuests))
end

function PermoksAccountManager:CreateRenownString(altData)
	if not altData or not altData.renown then return end
	
	local renown
	local renownTbl = {}
	if type(altData.renown) == "table" then
		for covenant=4, 1, -1 do
			renown = altData.renown[covenant]
			renownTbl[covenant] = customCovenantColors[covenant]:WrapTextInColorCode(renown or "X")
		end
		return table.concat(renownTbl, " ")
	elseif customCovenantColors[altData.covenant] then
		return string.format("%s", customCovenantColors[altData.covenant]:WrapTextInColorCode(altData.renown))
	end
end


function PermoksAccountManager:CallingTooltip_OnEnter(button, alt_data)
	if not alt_data or not alt_data.callingInfo then return end
	local currentCallings = self.db.global.currentCallings[alt_data.covenant]
	if not currentCallings then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 3, "LEFT", "CENTER", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader("Callings")
	tooltip:AddLine("")
	
	for questID, covenantCallingInfo in PermoksAccountManager.spairs(currentCallings, function(t, a, b) return (t[a].timeRemaining or 0) < (t[b].timeRemaining or 0) end) do
		if alt_data.callingInfo[questID] and (covenantCallingInfo.timeRemaining or 0) > time() then
			tooltip:AddLine(covenantCallingInfo.name, "", self:CreateTimeString(self:TimeToDaysHoursMinutes(covenantCallingInfo.timeRemaining)) or "")
		end
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end
