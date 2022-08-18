local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local module = 'instances'
local labelRows = {
    mythics_done = {
        label = L['Mythic+0'],
        tooltip = true,
        customTooltip = function(button, alt_data)
            PermoksAccountManager:DungeonTooltip_OnEnter(button, alt_data)
        end,
        data = function(alt_data)
            return alt_data.instanceInfo and PermoksAccountManager:CreateDungeonString(alt_data.instanceInfo.dungeons) or '-'
        end,
        group = 'dungeons',
        version = WOW_PROJECT_MAINLINE
    },
    nathria = {
        label = function()
            return PermoksAccountManager.raids[2296].name or L['Nathria']
        end,
        id = 2296,
        type = 'raid',
        key = 'nathria',
        tooltip = true,
        group = 'raids',
        version = WOW_PROJECT_MAINLINE
    },
    sanctum_of_domination = {
        label = function()
            return PermoksAccountManager.raids[2450].name or L['SoD']
        end,
        id = 2450,
        type = 'raid',
        key = 'sanctum_of_domination',
        tooltip = true,
        group = 'raids',
        version = WOW_PROJECT_MAINLINE
    },
	sepulcher_of_the_first_ones = {
		label = function()
            return PermoksAccountManager.raids[2481].name or L['SotFO']
        end,
		id = 2481,
		type = 'raid',
		key = 'sepulcher_of_the_first_ones',
		tooltip = true,
		group = 'raids',
		version = WOW_PROJECT_MAINLINE
	},
    -- tbc
    karazhan_attunement = {
        label = 'Karazhan',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.mastersKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.mastersKey.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    serpentshrine_attunement = {
        label = 'Serpentshrine',
        type = 'quest',
        visibility = 'visible',
        questType = 'attunement',
        key = 'serpentshrine_attunement',
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    the_eye_attunement = {
        label = 'Tempest Keep',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.tempestKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.tempestKey.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    hyjal_summit_attunement = {
        label = 'Hyjal Summit',
        type = 'quest',
        visibility = 'visible',
        questType = 'attunement',
        key = 'hyjal_summit_attunement',
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    black_temple_attunement = {
        label = 'Black Temple',
        type = 'quest',
        visibility = 'visible',
        questType = 'attunement',
        key = 'black_temple_attunement',
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    hillsbrad_attunement = {
        label = 'Hillsbrad',
        type = 'quest',
        visibility = 'visible',
        questType = 'attunement',
        key = 'hillsbrad_attunement',
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    blackmorass_attunement = {
        label = 'Black Morass',
        type = 'quest',
        visibility = 'visible',
        questType = 'attunement',
        key = 'blackmorass_attunement',
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    shatteredHallsKey = {
        label = 'Shattered Halls',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.shatteredHallsKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.shatteredHallsKey.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    arcatrazKey = {
        label = 'Arcatraz',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.arcatrazKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.arcatrazKey.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    citadelKey = {
        label = 'Hellfire Citadel',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.citadelKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.citadelKey.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    reservoirKey = {
        label = 'Coilfang Reservoir',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.reservoirKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.reservoirKey.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    auchenaiKey = {
        label = 'Auchindoun',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.auchenaiKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.auchenaiKey.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    warpforgedKey = {
        label = 'Tempest Keep',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.warpforgedKey and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.warpforgedKey.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    keyOfTime = {
        label = 'Caverns of Time',
        data = function(alt_data)
            return (alt_data.itemCounts and alt_data.itemCounts.keyOfTime and PermoksAccountManager:CreateQuestString(alt_data.itemCounts.keyOfTime.total, 1, true)) or '-'
        end,
        group = 'attunement',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    heroicsDone = {
        label = 'Heroic Dungeons',
        tooltip = function(button, alt_data)
            PermoksAccountManager:DungeonTooltip_OnEnter(button, alt_data)
        end,
        data = function(alt_data)
            return alt_data.instanceInfo and PermoksAccountManager:CreateDungeonString(alt_data.instanceInfo.dungeons) or '-'
        end,
        group = 'dungeons',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    karazhan = {
        key = 'karazhan',
        label = 'Karazhan',
        type = 'raid',
        id = 532,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    hyjal = {
        key = 'hyjal',
        label = 'Hyjal Summit',
        type = 'raid',
        id = 534,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    magtheridon = {
        key = 'magtheridon',
        label = 'Magtheridon',
        type = 'raid',
        id = 544,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    serpentshrine = {
        key = 'serpentshrine',
        label = 'Serpentshrine',
        type = 'raid',
        id = 548,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    tempestkeep = {
        key = 'tempestkeep',
        label = 'Tempest Keep',
        type = 'raid',
        id = 550,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    blacktemple = {
        key = 'blacktemple',
        label = 'Black Temple',
        type = 'raid',
        id = 564,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    gruul = {
        key = 'gruul',
        label = 'Gruul',
        type = 'raid',
        id = 565,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    zulaman = {
        key = 'zulaman',
        label = "Zul'Aman",
        type = 'raid',
        id = 568,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    sunwell = {
        key = 'sunwell',
        label = 'Sunwell Plateau',
        type = 'raid',
        id = 580,
        group = 'raids',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    }
}

local function UpdateInstanceInfo(charInfo)
    charInfo.instanceInfo = charInfo.instanceInfo or {raids = {}, dungeons = {}}

    local self = PermoksAccountManager
	self.raidEncounterNames = self.raidEncounterNames or {}

    local instanceInfo = charInfo.instanceInfo
    local name, difficulty, locked, extended, difficultyName, numEncounters, encounterProgress, _
    for i = 1, GetNumSavedInstances() do
        local link = GetSavedInstanceChatLink(i)
        local mapID, _ = link:match(':(%d+):%d+:%d+\124h%[(.+)%]\124h')
        mapID = tonumber(mapID)
        name, _, _, difficulty, locked, extended, _, _, _, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)

		local raidInfo
        if locked or extended then
            if self.raids[mapID] or (self.isBC and self.raids[name]) then
                local info = self.raids[mapID] or self.raids[name]
                instanceInfo.raids[info.englishName] = instanceInfo.raids[info.englishName] or {}
				instanceInfo.raids[info.englishName][difficulty] =  instanceInfo.raids[info.englishName][difficulty] or {
					difficulty = difficultyName,
					numEncounters = numEncounters
				}

                local oldInstanceInfo = instanceInfo.raids[info.englishName][difficulty]
                if not oldInstanceInfo.defeatedEncounters or oldInstanceInfo.defeatedEncounters < encounterProgress then
                    instanceInfo.raids[info.englishName][difficulty].defeatedEncounters = encounterProgress
                end

				raidInfo = oldInstanceInfo
            elseif (self.dungeons[mapID] and difficulty == 23) or (self.isBC and self.dungeons[name] and difficulty == 174) then
                instanceInfo.dungeons[mapID or self.dungeons[name]] = {
                    numEncounters = numEncounters,
                    defeatedEncounters = encounterProgress,
                    completed = numEncounters == encounterProgress
                }
            end
        end

		if raidInfo then
			local index = self.raids[mapID].startIndex - 1
			raidInfo.defeatedEncountersInfo = {}
			self.raidEncounterNames[mapID] = self.raidEncounterNames[mapID] or {}
			for boss = 1, numEncounters do
				local encounterName, _, isKilled = GetSavedInstanceEncounterInfo(i, boss)
				raidInfo.defeatedEncountersInfo[index + boss] = isKilled
				self.raidEncounterNames[mapID][boss] = encounterName
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
            ['UPDATE_INSTANCE_INFO'] = UpdateInstanceInfo,
			['WEEKLY_REWARDS_UPDATE']  = UpdateInstanceInfo,
            ['INSTANCE_LOCK_STOP'] = UpdateInstanceInfo,
        },
        share = {
            [UpdateInstanceInfo] = 'instanceInfo'
        }
    }
    PermoksAccountManager:AddModule(module, payload)
end

function PermoksAccountManager:CreateDungeonString(savedInfo)
    if not savedInfo then
        return '-'
    end
    local numCompletedDungeons = 0

    for _, info in pairs(savedInfo) do
        if info.numEncounters == info.defeatedEncounters then
            numCompletedDungeons = numCompletedDungeons + 1
        end
    end

    if numCompletedDungeons == self.numDungeons then
        return '|cff00ff00+|r'
    else
        return numCompletedDungeons .. '/' .. self.numDungeons
    end
end

local retailDifficultyOrder = {
	[17] = 1,
	[14] = 2,
	[15] = 3,
	[16] = 4,
}

function PermoksAccountManager:CreateRaidString(savedInfo, hideDifficulty)
    local raidString = ''

    local highestDifficulty = 0
    for difficulty in pairs(savedInfo) do
        if (not self.isBC and retailDifficultyOrder[difficulty] > (retailDifficultyOrder[highestDifficulty] or highestDifficulty)) or (self.isBC and difficulty > highestDifficulty) then
            highestDifficulty = difficulty
        end
    end

    local raidInfo = savedInfo[highestDifficulty]
	if not raidInfo then return end
    local raidDifficulty = self.isBC and '' or raidInfo.difficulty:sub(1, 1)

    if raidInfo then
        raidString = string.format('%s%s', self:CreateQuestString(raidInfo.defeatedEncounters, raidInfo.numEncounters), hideDifficulty and '' or raidDifficulty)
        return raidString
    end
end

function PermoksAccountManager:DungeonTooltip_OnEnter(button, alt_data)
    if not alt_data or not alt_data.instanceInfo then
        return
    end
    local dungeonInfo = alt_data.instanceInfo.dungeons
    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 3, 'LEFT', 'CENTER', 'RIGHT')
    button.tooltip = tooltip

    for key, value in self.spairs(
        self.dungeons,
        function(t, a, b)
            return t[a] < t[b]
        end
    ) do
        local left = self.isBC and key or value
        local info = self.isBC and dungeonInfo[value] or dungeonInfo[key]
        local right = '|cffff0000-|r'

        if info then
            right = self:CreateQuestString(info.defeatedEncounters, info.numEncounters)
        end
        tooltip:AddLine(left, '   ', right)
    end

    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end

function PermoksAccountManager.RaidTooltip_OnEnter(button, altData, labelRow)
    local self = PermoksAccountManager
    if not altData.instanceInfo or not self.raids[labelRow.id] or not self.raidEncounterNames[labelRow.id] then
        return
    end

	local dbInfo = self.raids[labelRow.id]
    local raidInfo = altData.instanceInfo.raids[dbInfo.englishName]
	local raidEncounterNames = self.raidEncounterNames[labelRow.id]
    if not raidInfo then
        return
    end

    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
    button.tooltip = tooltip

    tooltip:AddHeader(dbInfo.name)
    tooltip:AddLine('')


    for difficulty, info in self.spairs(
        raidInfo,
        function(_, a, b)
            if a == 17 or b == 17 then
                return b < a
            else
                return a < b
            end
        end
    ) do
        tooltip:AddLine(info.difficulty .. ':', self:CreateQuestString(info.defeatedEncounters, info.numEncounters))
		local raidActivityInfo = difficulty==16 and altData.raidActivityInfo
		if info.defeatedEncountersInfo and difficulty < 17 then
			local bossIndex = 1
			for index = dbInfo.startIndex, dbInfo.endIndex do
				local bossInfo = info.defeatedEncountersInfo[index]
				local text = L['Unsaved']
				local color = "00ff00"

				if raidActivityInfo and raidActivityInfo[index] and raidActivityInfo[index].bestDifficulty == difficulty then
					color = "ff0000"
					text = L['Saved']
				elseif bossInfo then
					color = "ff9933"
					text = L['Saved']
				end

				tooltip:AddLine(bossIndex .. " " .. raidEncounterNames[bossIndex], string.format("|cff%s%s|r", color, text))
				bossIndex = bossIndex + 1
			end
		end
		tooltip:AddSeparator(2, 1, 1, 1)
    end

    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end
