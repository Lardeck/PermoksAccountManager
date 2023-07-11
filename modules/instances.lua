local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local module = 'instances'
local labelRows = {
    mythics_done = {
        label = 'Mythic Dungeons',
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
    vault_of_the_incarnates = {
		label = function()
            return PermoksAccountManager.raids[2522].name or 'VotI'
        end,
		id = 2522,
		type = 'raid',
		key = 'vault_of_the_incarnates',
		tooltip = true,
		group = 'raids',
		version = WOW_PROJECT_MAINLINE
    },
    aberrus_the_shadowed_crucible = {
		label = function()
            return PermoksAccountManager.raids[2569].name or 'Aberrus'
        end,
		id = 2569,
		type = 'raid',
		key = 'aberrus_the_shadowed_crucible',
		tooltip = true,
		group = 'raids',
		version = WOW_PROJECT_MAINLINE
    },

    -- wotlk
	-- TOOD: Change db structure so you can get the locale name without calling the function again
	naxxramas = {
		label = GetRealZoneText(533),
		id = 533,
		type = 'raid',
		key = 'naxxramas',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
	ulduar = {
		label = GetRealZoneText(603),
		id = 603,
		type = 'raid',
		key = 'ulduar',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
	obsidian_sanctum = {
		label = GetRealZoneText(615),
		id = 615,
		type = 'raid',
		key = 'obsidian_sanctum',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
	eye_of_eternity = {
		label = GetRealZoneText(616),
		id = 616,
		type = 'raid',
		key = 'eye_of_eternity',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
	vault_of_archavon = {
		label = GetRealZoneText(624),
		id = 624,
		type = 'raid',
		key = 'vault_of_archavon',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
	icecrown_citadel = {
		label = GetRealZoneText(631),
		id = 631,
		type = 'raid',
		key = 'icecrown_citadel',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
	trial_of_the_crusader = {
		label = GetRealZoneText(649),
		id = 649,
		type = 'raid',
		key = 'trial_of_the_crusader',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
    onyxias_lair = {
		label = GetRealZoneText(249),
		id = 249,
		type = 'raid',
		key = 'onyxias_lair',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},    
	ruby_sanctum = {
		label = GetRealZoneText(724),
		id = 724,
		type = 'raid',
		key = 'ruby_sanctum',
		group = 'raids',
		tooltip = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
    -- old mount drop raids (optional)
    zul_gurub = {
		label = GetRealZoneText(309),
		id = 309,
		type = 'raid',
		key = 'zul_gurub',
		group = 'raids',
		tooltip = true,
        hasSingularLockout = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
    karazhan = {
		label = GetRealZoneText(532),
		id = 532,
		type = 'raid',
		key = 'karazhan',
		group = 'raids',
		tooltip = true,
        hasSingularLockout = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
    tempest_keep = {
		label = GetRealZoneText(550),
		id = 550,
		type = 'raid',
		key = 'tempest_keep',
		group = 'raids',
		tooltip = true,
        hasSingularLockout = true,
		version = WOW_PROJECT_WRATH_CLASSIC,
	},
    heroics_done = {
        label = 'Heroic Dungeons',
        tooltip = function(button, alt_data)
            PermoksAccountManager:DungeonTooltip_OnEnter(button, alt_data)
        end,
        data = function(alt_data)
            return alt_data.instanceInfo and PermoksAccountManager:CreateDungeonString(alt_data.instanceInfo.dungeons) or '-'
        end,
        group = 'dungeons',
        version = WOW_PROJECT_WRATH_CLASSIC
    },
}

local function UpdateInstanceInfo(charInfo)
    charInfo.instanceInfo = charInfo.instanceInfo or {raids = {}, dungeons = {}, customRaids = {}}
    local self = PermoksAccountManager
    local instanceInfo = charInfo.instanceInfo
    local name, difficulty, locked, extended, difficultyName, numEncounters, encounterProgress, _
    for i = 1, GetNumSavedInstances() do
        local link = GetSavedInstanceChatLink(i)
        local mapID, _ = link:match(':(%d+):%d+:%d+\124h%[(.+)%]\124h')
        mapID = tonumber(mapID)
        name, _, _, difficulty, locked, extended, _, _, _, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
		local raidInfo
        if locked or extended then
            if self.raids[mapID] or (self.isWOTLK and self.raids[name]) then
                local info = self.raids[mapID] or self.raids[name]
                instanceInfo.raids[info.englishID] = instanceInfo.raids[info.englishID] or {}
				instanceInfo.raids[info.englishID][difficulty] =  instanceInfo.raids[info.englishID][difficulty] or {
                    key = info.englishID,
					difficulty = difficultyName,
					numEncounters = numEncounters
				}

                if not instanceInfo.raids[info.englishID][difficulty].key then
                    instanceInfo.raids[info.englishID][difficulty].key = info.englishID
                end
                
                local oldInstanceInfo = instanceInfo.raids[info.englishID][difficulty]
                if not oldInstanceInfo.defeatedEncounters or oldInstanceInfo.defeatedEncounters < encounterProgress then
                    instanceInfo.raids[info.englishID][difficulty].defeatedEncounters = encounterProgress
                end

				raidInfo = oldInstanceInfo
            elseif (self.dungeons[mapID] and difficulty == 23) or (self.isWOTLK and self.dungeons[name] and difficulty == 2) then
                local completed = numEncounters == encounterProgress

                -- find out if last boss is killed, since in wotlk the dungeon is completed if last boss is killed
                if self.isWOTLK then
                    -- for Ahn'kahet: The Old Kingdom we need to subtract 1 from numEncounters, since the last boss from API is the heroic only boss
                    local lastBossIndex = numEncounters
                    if(mapID == 619) then
                        lastBossIndex = lastBossIndex - 1
                    end

                    local _, _, isKilled = GetSavedInstanceEncounterInfo(i, lastBossIndex)
                    completed = isKilled
                end

                instanceInfo.dungeons[mapID or self.dungeons[name]] = {
                    numEncounters = numEncounters,
                    defeatedEncounters = encounterProgress,
                    completed = completed
                }
            elseif self.customRaids and self.customRaids[name] then
                local info = self.customRaids[name]
                instanceInfo.customRaids = instanceInfo.customRaids or {}
                instanceInfo.customRaids[info.englishID] = instanceInfo.customRaids[info.englishID] or {}
				instanceInfo.customRaids[info.englishID][difficulty] =  instanceInfo.customRaids[info.englishID][difficulty] or {
                    key = info.englishID,
					difficulty = difficultyName,
					numEncounters = numEncounters
				}

                if not instanceInfo.customRaids[info.englishID][difficulty].key then
                    instanceInfo.customRaids[info.englishID][difficulty].key = info.englishID
                end
                
                local oldInstanceInfo = instanceInfo.customRaids[info.englishID][difficulty]
                if not oldInstanceInfo.defeatedEncounters or oldInstanceInfo.defeatedEncounters < encounterProgress then
                    instanceInfo.customRaids[info.englishID][difficulty].defeatedEncounters = encounterProgress
                end

				raidInfo = oldInstanceInfo
            end
        end

		if not self.isWOTLK and raidInfo then
			local index = self.raids[mapID].startIndex - 1
			raidInfo.defeatedEncountersInfo = raidInfo.defeatedEncountersInfo or {}
			for boss = 1, numEncounters do
				local isKilled = select(3, GetSavedInstanceEncounterInfo(i, boss))
				raidInfo.defeatedEncountersInfo[index + boss] = isKilled
			end
        elseif self.isWOTLK and raidInfo then
            raidInfo.defeatedEncountersInfo = raidInfo.defeatedEncountersInfo or {} 
            for bossIndex = 1, raidInfo.numEncounters do
                local name, _, isKilled = GetSavedInstanceEncounterInfo(i, bossIndex)
                raidInfo.defeatedEncountersInfo[bossIndex] = {
                    name = name,
                    isKilled = isKilled
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
        if info.completed then
            numCompletedDungeons = numCompletedDungeons + 1
        end
    end

	return self:CreateFractionString(numCompletedDungeons, self.numDungeons)
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
        if (not self.isWOTLK and (retailDifficultyOrder[difficulty] > (retailDifficultyOrder[highestDifficulty] or highestDifficulty))) or (self.isWOTLK and (difficulty > highestDifficulty)) then
            highestDifficulty = difficulty
        end
    end

    if self.isWOTLK then
        -- for wrath we want to show all difficulties
        for difficulty in PermoksAccountManager.spairs(savedInfo, function(_, a, b) return a < b end) do
            local difficultyString = ''
            local raidInfo = savedInfo[difficulty]

            -- add failsafe if saved data is not updated with key
            local hasSingularLockout = false
            if labelRows[raidInfo.key] and labelRows[raidInfo.key].hasSingularLockout then
                hasSingularLockout = labelRows[raidInfo.key].hasSingularLockout
            end 

            if hasSingularLockout then
                difficultyString = self:CreateFractionString(raidInfo.defeatedEncounters, raidInfo.numEncounters)
            else
                difficultyString = string.format('%s %s', PermoksAccountManager.raidDifficultyLabels[difficulty], self:CreateFractionString(raidInfo.defeatedEncounters, raidInfo.numEncounters))
            end

            raidString = string.format('%s%s%s', raidString, difficultyString, difficulty == highestDifficulty and '' or ' ')
        end
    else
        local raidInfo = savedInfo[highestDifficulty]
        if not raidInfo then return end
        local raidDifficulty = raidInfo.difficulty:sub(1, 1)

        -- for retail we only want to show the highest difficulty
        raidString = string.format('%s%s', self:CreateFractionString(raidInfo.defeatedEncounters, raidInfo.numEncounters), hideDifficulty and '' or raidDifficulty)
    end

    return raidString
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
        local left = self.isWOTLK and key or value
        local info = self.isWOTLK and dungeonInfo[value] or dungeonInfo[key]
        local right = '|cffff0000-|r'

        if info then
            right = self:CreateQuestString(info.defeatedEncounters, info.numEncounters)
        end
        tooltip:AddLine(left, '   ', right)
    end

    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end

local function RetailRaid_OnEnter(tooltip, altData, dbInfo, raidInfo)
    local self = PermoksAccountManager

    local raidActivityInfo = altData.raidActivityInfo
    local localRaidActivityInfo = {}
    for _, info in pairs(raidActivityInfo) do
        if info.instanceID == dbInfo.instanceID then
            localRaidActivityInfo[info.uiOrder] = info
        end
    end

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

        if info.defeatedEncountersInfo and difficulty < 17 then
            local bossIndex = 1
                for index = dbInfo.startIndex, dbInfo.endIndex do
                    local bossInfo = info.defeatedEncountersInfo[index]
                    local text = L['Unsaved']
                    local color = "00ff00"
    
                    if difficulty == 16 and localRaidActivityInfo[bossIndex] and localRaidActivityInfo[bossIndex].bestDifficulty == difficulty then
                        text = L['Killed']
                        color = "ff0000"
                    elseif bossInfo then
                        text = L['Saved']
                        color = "ff9933"
                    end
    
                    tooltip:AddLine(bossIndex .. " " .. EJ_GetEncounterInfo(localRaidActivityInfo[bossIndex].encounterID), string.format("|cff%s%s|r", color, text))
                    bossIndex = bossIndex + 1
                end
        end
        tooltip:AddSeparator(2, 1, 1, 1)
    end
end

local function WOTLKRaid_OnEnter(tooltip, raidInfo)
    local self = PermoksAccountManager

    for _, info in self.spairs(raidInfo, function(_, a, b) return a < b end) do
        tooltip:AddLine(info.difficulty .. ':', self:CreateQuestString(info.defeatedEncounters, info.numEncounters))

        if info.defeatedEncountersInfo then
            for bossIndex = 1, info.numEncounters do
                local bossName = info.defeatedEncountersInfo[bossIndex] and info.defeatedEncountersInfo[bossIndex].name
                local text = L['Alive']
                local color = "00ff00"

                if info.defeatedEncountersInfo[bossIndex] and info.defeatedEncountersInfo[bossIndex].isKilled == true then
                    text = L['Killed']
                    color = "ff0000"
                end

                tooltip:AddLine(bossName or L['Unknown'], string.format("|cff%s%s|r", color, text))
                bossIndex = bossIndex + 1
            end
        end
        tooltip:AddSeparator(2, 1, 1, 1)
    end
end

function PermoksAccountManager.RaidTooltip_OnEnter(button, altData, labelRow)
    local self = PermoksAccountManager

    if not altData.instanceInfo or (not self.raids[labelRow.id] and not self.raids[labelRow.label]) then
        return
    end

    local dbInfo = self.raids[labelRow.id] or self.raids[labelRow.label]
    local raidInfo = dbInfo and altData.instanceInfo.raids[dbInfo.englishID]
    if not raidInfo then return end

    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
    button.tooltip = tooltip

    tooltip:AddHeader(dbInfo.name or labelRow.label)
    tooltip:AddLine('')
        
    if self.isWOTLK then
        WOTLKRaid_OnEnter(tooltip, raidInfo)
    elseif not self.isBC and not self.isWOTLK then
        RetailRaid_OnEnter(tooltip, altData, dbInfo, raidInfo)
    end
    
    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end
