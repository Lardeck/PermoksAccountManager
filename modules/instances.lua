local addonName, PermoksAccountManager = ...
local LibQTip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local module = "instances"
local labelRows = {
	mythics_done = {
		label = L["Mythic+0"],
		tooltip = true,
		customTooltip = function(button, alt_data) PermoksAccountManager:DungeonTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return alt_data.instanceInfo and PermoksAccountManager:CreateDungeonString(alt_data.instanceInfo.dungeons) or "-" end,
		group = "dungeons",
	},
	nathria = {
		label = function() return PermoksAccountManager.raids[2296].name or L["Nathria"] end,
		id = 2296,
		type = "raid",
		key = "nathria",
		tooltip = true,
		isComplete = function(alt_data) return alt_data.instanceInfo and alt_data.instanceInfo.raids.nathria and alt_data.instanceInfo.raids.nathria.defeatedEncounters == 10 end,
		group = "raids",
	},
	sanctum_of_domination = {
		label = function() return PermoksAccountManager.raids[2450].name or L["SoD"] end,
		id = 2450,
		type = "raid",
		key = "sanctum_of_domination",
		tooltip = true,
		isComplete = function(alt_data) return alt_data.instanceInfo and alt_data.instanceInfo.raids.sanctum_of_domination and alt_data.instanceInfo.raids.sanctum_of_domination.defeatedEncounters == 10 end,
		group = "raids",
	},
}

local function UpdateInstanceInfo(charInfo)
	charInfo.instanceInfo = charInfo.instanceInfo or {raids = {}, dungeons = {}}

	local self = PermoksAccountManager
	local instanceInfo = charInfo.instanceInfo
	local name, difficulty, locked, isRaid, difficultyName, numEncounters, encounterProgress, _
	for i=1, GetNumSavedInstances() do
		local link = GetSavedInstanceChatLink(i)
		local instanceID, instanceName = link:match(":(%d+):%d+:%d+\124h%[(.+)%]\124h")
		instanceID = tonumber(instanceID)
		name, _, _, difficulty, locked, extended, _, isRaid, _, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)

		if locked or (extended and encounterProgress>0) then
			if self.raids[instanceID] or (self.isBC and self.raids[name]) then
				local info = self.raids[instanceID] or self.raids[name]

				instanceInfo.raids[info.englishName] = instanceInfo.raids[info.englishName] or {}
				instanceInfo.raids[info.englishName][difficulty] = {difficulty = difficultyName, numEncounters = numEncounters, defeatedEncounters = encounterProgress}
			elseif (self.dungeons[instanceID] and difficulty == 23) or ((self.isBC and self.dungeons[name] and difficulty == 174)) then
				instanceInfo.dungeons[instanceID or self.dungeons[name]] = {
					numEncounters = numEncounters, 
					defeatedEncounters = encounterProgress,
					completed = numEncounters == encounterProgress,
				}
			end
		end
	end
end

local function Update(charInfo)
	UpdateInstanceInfo(charInfo)
end

do
	local payload = {
		update = Update,
		labels = labelRows,
		events = {
			["UPDATE_INSTANCE_INFO"] = UpdateInstanceInfo,
		},
		share = {
			[UpdateInstanceInfo] = "instanceInfo",
		},
	}
	PermoksAccountManager:AddModule(module, payload)
end


function PermoksAccountManager:CreateDungeonString(savedInfo)
	if not savedInfo then return "-" end
	local numCompletedDungeons = 0

	for instanceID, info in pairs(savedInfo) do
		if info.numEncounters == info.defeatedEncounters then
			numCompletedDungeons = numCompletedDungeons + 1
		end
	end

	if numCompletedDungeons == self.numDungeons then
		return "|cff00ff00+|r"
	else
		return numCompletedDungeons .. "/" .. self.numDungeons
	end
end

function PermoksAccountManager:CreateRaidString(savedInfo, hideDifficulty)
	local raidString = ""
	local maxDifficultyId = self.isBC and 175 or 16

	local highestDifficulty = 0
	for difficulty in pairs(savedInfo) do
		if difficulty <= maxDifficultyId and difficulty > highestDifficulty then
			highestDifficulty = difficulty
		end
	end

	local raidInfo = savedInfo[highestDifficulty]
	if raidInfo then
		raidString = string.format("%s%s", self:CreateQuestString(raidInfo.defeatedEncounters, raidInfo.numEncounters), hideDifficulty and "" or raidInfo.difficulty:sub(1,1))
		return raidString
	end
end

function PermoksAccountManager:DungeonTooltip_OnEnter(button, alt_data)
	if not alt_data or not alt_data.instanceInfo then return end
	local dungeonInfo = alt_data.instanceInfo.dungeons
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 3, "LEFT", "CENTER", "RIGHT")
	button.tooltip = tooltip

	for key, value in self.spairs(self.dungeons, function(t, a, b) return t[a] < t[b] end) do
		local left = self.isBC and key or value
		local info = self.isBC and dungeonInfo[value] or dungeonInfo[key]
		local right = "|cffff0000-|r"

		if info then
			right = self:CreateQuestString(info.defeatedEncounters, info.numEncounters)
		end
		tooltip:AddLine(left, "   ", right)
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end

function PermoksAccountManager.RaidTooltip_OnEnter(button, altData, labelRow)
	local self = PermoksAccountManager
	if not altData.instanceInfo or not self.raids[labelRow.id] then return end
	local raidInfo = altData.instanceInfo.raids[self.raids[labelRow.id].englishName]
	if not raidInfo then return end

	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 2, "LEFT", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader(self.raids[labelRow.id].name)
	tooltip:AddLine("")

	for difficulty, info in self.spairs(raidInfo, function(t, a, b) if a == 17 then return b < a else return a < b end end) do
		tooltip:AddLine(info.difficulty..":", self:CreateQuestString(info.defeatedEncounters, info.numEncounters))
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end