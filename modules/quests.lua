local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local frequencyNames = {
    [0] = 'default',
    [1] = 'daily',
    [2] = 'weekly'
}

local default = {
    daily = {
        visible = {},
        hidden = {}
    },
    weekly = {
        visible = {},
        hidden = {}
    },
    biweekly = {
        visible = {},
        hidden = {}
    },
    relics = {
        visible = {},
        hidden = {}
    },
    unlocks = {
        visible = {},
        hidden = {}
    }
}

local module = 'quests'
local labelRows = {
    korthia_dailies = {
        label = L['Korthia Dailies'],
        type = 'quest',
        questType = 'daily',
        visibility = 'visible',
        key = 'korthia_dailies',
        required = function(alt_data)
            local unlocks = alt_data.questInfo.unlocks and alt_data.questInfo.unlocks.visible
            if unlocks then
                local _, unlocked = next(unlocks.korthia_five_dailies)
                return unlocked and 4 or 3
            end
            return 3
        end,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.daily and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.visible.korthia_dailies) >= 3
        end,
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    riftbound_cache = {
        label = L['Riftbound Caches'],
        type = 'quest',
        questType = 'daily',
        visibility = 'hidden',
        key = 'riftbound_cache',
        required = 4,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.daily and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.riftbound_cache) >= 4
        end,
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    relic_creatures = {
        label = L['Relic Creatures'],
        type = 'quest',
        questType = 'daily',
        visibility = 'hidden',
        key = 'relic_creatures',
        required = 15,
        plus = true,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.daily and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.relic_creatures) >= 15
        end,
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    dailyQuestCounter = {
        label = 'Daily Quests',
        data = function(alt_data)
            return alt_data.completedDailies and alt_data.completedDailies.num and PermoksAccountManager:CreateFractionString(alt_data.completedDailies.num, 30) or 'Login'
        end,
        group = 'resetDaily',
        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
    },
    relic_gorger = {
        label = L['Relic Gorger'],
        type = 'quest',
        questType = 'daily',
        visibility = 'hidden',
        key = 'relic_gorger',
        required = 4,
        plus = true,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.daily and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.relic_gorger) >= 4
        end,
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    helsworn_chest = {
        label = L['Helsworn Chest'],
        type = 'quest',
        questType = 'daily',
        visibility = 'hidden',
        key = 'helsworn_chest',
        plus = true,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.daily and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.helsworn_chest) >= 1
        end,
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    assault_vessels = {
        label = L['Assault Vessels'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'assault_vessels',
        required = 4,
        tooltip = function(button, alt_data, column)
            PermoksAccountManager:QuestTooltip_OnEnter(button, alt_data, column)
        end,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.assault_vessels) >= 2
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    rift_vessels = {
        label = L['Rift Vessels'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'rift_vessels',
        required = 3,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.rift_vessels) >= 3
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    adamant_vault_conduit = {
        label = L['AV Conduit'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'adamant_vault_conduit',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.adamant_vault_conduit) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    maw_dailies = {
        label = L['Maw Dailies'],
        type = 'quest',
        questType = 'daily',
        visibility = 'visible',
        key = 'maw_dailies',
        required = 2,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.daily and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.daily.maw_dailies) >= 2
        end,
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    dungeon_quests = {
        label = L['Dungeon Quests'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'dungeon_quests',
        required = 2,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekl and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.dungeon_quests) == 2
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    pvp_quests = {
        label = L['PVP Quests'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'pvp_quests',
        required = 2,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.pvp_quests) == 2
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    weekend_event = {
        label = L['Weekend Event'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'weekend_event',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.weekend_event) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    world_boss = {
        label = L['World Boss'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'world_boss',
        isCompleteTest = true,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.world_boss) == 2
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    korthia_world_boss = {
        label = L['World Boss'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'korthia_world_boss',
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    anima_weekly = {
        label = L['1k Anima'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'anima_weekly',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.visible.anima_weekly) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    maw_souls = {
        label = L['Return Souls'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'maw_souls',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.visible.maw_souls) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    korthia_weekly = {
        label = L['Korthia Weekly'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'korthia_weekly',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.visible.korthia_weekly) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    tormentors_weekly = {
        label = L['Tormentors'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'tormentors_weekly',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.tormentors_weekly) >= 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    tormentors_locations = {
        label = L['Tormentors Rep'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'tormentors_locations',
        required = 6,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.tormentors_locations) >= 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    maw_assault = {
        label = L['Maw Assault'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'assault',
        required = 2,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.assault) >= 2
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    battle_plans = {
        label = L['Maw Battle Plans'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'battle_plans',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.battle_plans) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    korthia_supplies = {
        label = L['Korthia Supplies'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'korthia_supplies',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.korthia_supplies) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    containing_the_helsworn = {
        label = L['Maw WQ'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'containing_the_helsworn',
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    wrath = {
        label = L['Wrath of the Jailer'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'wrath',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.wrath) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    hunt = {
        label = L['The Hunt'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'hunt',
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hunt) == 1
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    --- 9.2
    sandworn_chest = {
        label = 'Sandworn Chest',
        type = 'quest',
        questType = 'daily',
        visibility = 'hidden',
        key = 'sandworn_chest',
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    zereth_mortis_dailies = {
        label = 'Dailies',
        type = 'quest',
        questType = 'daily',
        visibility = 'visible',
        key = 'zereth_mortis_dailies',
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    zereth_mortis_weekly = {
        label = 'Weekly',
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        key = 'zereth_mortis_weekly',
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    zereth_mortis_wqs = {
        label = 'ZM World Quests',
        type = 'quest',
        questType = 'weekly',
        key = 'zereth_mortis_wqs',
        required = 3,
        unlock = true,
        unlockKey = 'zereth_mortis_three_dailies',
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    zereth_mortis_world_boss = {
        label = 'World Boss',
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        key = 'zereth_mortis_world_boss',
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    }
}

local function GetQuestInfo(questLogIndex)
    if PermoksAccountManager.isBC then
        local title, _, _, isHeader, _, _, frequency, questID, _, _, _, _, _, _, _, isHidden = GetQuestLogTitle(questLogIndex)
        return {title = title, isHeader = isHeader, frequency = frequency, isHidden = isHidden, questID = questID}
    else
        return C_QuestLog.GetInfo(questLogIndex)
    end
end

local function UpdateAllQuests(charInfo)
    local self = PermoksAccountManager
    charInfo.questInfo = charInfo.questInfo or default

    local covenant = not self.isBC and (charInfo.covenant or C_Covenants.GetActiveCovenantID())
    local questInfo = charInfo.questInfo
    for key, quests in pairs(self.quests) do
        for questID, info in pairs(quests) do
            local visibleType = info.log and 'visible' or 'hidden'

            questInfo[info.questType] = questInfo[info.questType] or {}
            questInfo[info.questType][visibleType] = questInfo[info.questType][visibleType] or {}
            questInfo[info.questType][visibleType][key] = questInfo[info.questType][visibleType][key] or {}
            local currentQuestInfo = questInfo[info.questType][visibleType][key]
            local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questID)

            if not self.isBC then
                if info.covenant and covenant == info.covenant then
                    local sanctumTier
                    if info.sanctum and charInfo.sanctumInfo then
                        sanctumTier = charInfo.sanctumInfo[info.sanctum] and charInfo.sanctumInfo[info.sanctum].tier or 0
                        questInfo['max' .. key] = max(1, sanctumTier)
                    end

                    if not info.sanctum or (sanctumTier and sanctumTier >= info.minSanctumTier) then
                        currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil
                    end
                elseif not info.covenant then
                    currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil
                end
            else
                currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil

                if info.questType == 'daily' and isComplete then
                    if info.unique then
                        if not charInfo.completedDailies[key] then
                            charInfo.completedDailies.num = charInfo.completedDailies.num + 1
                            charInfo.completedDailies[key] = true
                        end
                    else
                        charInfo.completedDailies[questID] = true
                        charInfo.completedDailies.num = charInfo.completedDailies.num + 1
                    end
                end
            end
        end
    end
end

local function UpdateAllHiddenQuests(charInfo)
    local self = PermoksAccountManager
    if not charInfo.questInfo then
        UpdateAllQuests(charInfo)
    end
    self:Debug('Update Hidden Quests')

    for questType, keys in pairs(charInfo.questInfo) do
        if type(keys) == 'table' and keys.hidden then
            for key, quests in pairs(keys.hidden) do
                for questID, _ in pairs(self.quests[key]) do
                    local isComplete = charInfo.questInfo[questType].hidden[key][questID] or C_QuestLog.IsQuestFlaggedCompleted(questID)
                    charInfo.questInfo[questType].hidden[key][questID] = isComplete or nil
                end
            end
        end
    end
end

local timer

local function HiddenQuestTimerCallback(charInfo)
    UpdateAllHiddenQuests(charInfo)
    timer = nil
end

local function HiddenQuestTimer(charInfo)
    timer = timer or C_Timer.NewTimer(1, HiddenQuestTimerCallback(charInfo))
end

local function AddQuest(charInfo, questID, questLogIndex, questInfo)
    local self = PermoksAccountManager
    local questLogIndex = questLogIndex or (self.isBC and GetQuestLogIndexByID(questID) or C_QuestLog.GetLogIndexForQuestID(questID))
    if questLogIndex then
        local questInfo = questInfo or GetQuestInfo(questLogIndex)
        local title = questInfo.title

        self.db.global.quests[questID] = {frequency = questInfo.frequency, name = questInfo.title}
    end
end

local function RemoveQuest(charInfo, questID)
    if questID then
        PermoksAccountManager.db.global.quests[questID] = nil
    end
end

local function UpdateCurrentlyActiveQuests(charInfo)
    local numQuests = PermoksAccountManager.isBC and GetNumQuestLogEntries() or C_QuestLog.GetNumQuestLogEntries()
    local info
    for questLogIndex = 1, numQuests do
        info = GetQuestInfo(questLogIndex)
        if info and not info.isHeader and not info.isHidden then
            AddQuest(charInfo, info.questID, questLogIndex, info)
        end
    end
end

local function UpdateBCCQuest(charInfo, questID)
    local self = PermoksAccountManager
    if not charInfo.questInfo then
        UpdateAllBCCQuests(charInfo)
    end

    local resetKey, key = self:FindQuestByQuestID(questID)
    if resetKey and key and charInfo.questInfo[resetKey][key] then
        charInfo.questInfo[resetKey][key][questID] = true
        if resetKey == 'daily' then
            if self.quests[resetKey][questID].unique then
                if not charInfo.completedDailies[key] then
                    charInfo.completedDailies[key] = true
                    charInfo.completedDailies.num = charInfo.completedDailies.num + 1
                end
            elseif not charInfo.completedDailies[questID] then
                charInfo.completedDailies[questID] = true
                charInfo.completedDailies.num = charInfo.completedDailies.num + 1
            end
        end
        RemoveQuest(charInfo, questID)
    end
end

local function UpdateRetailQuest(charInfo, questID)
    local self = PermoksAccountManager
    if not charInfo.questInfo then
        UpdateAllRetailQuests(charInfo)
    end

    local key = self:FindQuestKeyByQuestID(questID)
    if not key then
        return
    end

    local questInfo = self.quests[key][questID]
    local questType, visibility = questInfo.questType, questInfo.log and 'visible' or 'hidden'
    self:Debug('Update', questType, visibility, key, questID)
    if questType and visibility and key and charInfo.questInfo[questType][visibility][key] then
        charInfo.questInfo[questType][visibility][key][questID] = true
        RemoveQuest(charInfo, questID)
    end
end

local function UpdateQuest(charInfo, questID)
    if not questID then
        return
    end
    if PermoksAccountManager.isBC then
        UpdateBCCQuest(charInfo, questID)
    else
        UpdateRetailQuest(charInfo, questID)
    end
end

local function Update(charInfo)
    UpdateAllQuests(charInfo)
    UpdateCurrentlyActiveQuests(charInfo)
end

local payload = {
    update = Update,
    labels = labelRows,
    events = {
        ['QUEST_ACCEPTED'] = AddQuest,
        ['QUEST_TURNED_IN'] = UpdateQuest,
        ['QUEST_REMOVED'] = RemoveQuest,
        ['QUEST_LOG_UPDATE'] = HiddenQuestTimer
    },
    share = {
        [HiddenQuestTimer] = 'questInfo',
        [UpdateQuest] = 'questInfo'
    }
}
PermoksAccountManager:AddModule(module, payload)

function PermoksAccountManager:FindQuestKeyByQuestID(questID)
    for key, quests in pairs(self.quests) do
        if quests[questID] then
            return key
        end
    end
end

function PermoksAccountManager:FindQuestByQuestID(questID)
    local resetKey, key
    if self.db.global.quests[questID] then
        local questInfo = self.db.global.quests[questID]
        resetKey = frequencyNames[questInfo.frequency]
        if self.quests[resetKey] then
            key = self.quests[resetKey][questID]
        end
    else
        for reset, quests in pairs(self.quests) do
            if quests[questID] then
                return reset, quests[questID].key
            end
        end
    end

    return resetKey, key
end

function PermoksAccountManager:GetNumCompletedQuests(questInfo)
    if not questInfo then
        return 0
    end
    local numCompleted = 0

    for questID, questCompleted in pairs(questInfo) do
        numCompleted = questCompleted and numCompleted + 1 or numCompleted
    end

    return numCompleted
end

function PermoksAccountManager:CreateQuestString(questInfo, numDesired, replaceWithPlus)
    if not questInfo then
        return
    end
    if not numDesired then
        return
    end
    local numCompleted = 0
    if type(questInfo) == 'table' then
        numCompleted = self:GetNumCompletedQuests(questInfo)
    else
        numCompleted = questInfo
    end

    local isComplete = numCompleted >= numDesired
    local color = (isComplete and '00ff00') or (numCompleted > 0 and 'ff9900') or 'ffffff'

    if numDesired then
        if replaceWithPlus and isComplete then
            return string.format('|cff%s%s|r', color, self.db.global.options.questCompletionString)
        else
            return string.format('|cff%s%d|r/%d', color, numCompleted, numDesired)
        end
    else
        return string.format('|cff%s%d|r', color, numCompleted)
    end
end

function PermoksAccountManager:QuestTooltip_OnEnter(button, alt_data, column)
    if not alt_data or not alt_data.questInfo or not alt_data.questInfo[column.reset] or not alt_data.questInfo[column.reset][column.visibility] then
        return
    end
    local info = alt_data.questInfo[column.questType][column.visibility][column.key]
    if not info then
        return
    end

    local quests = self.quests[column.key]
    local completedByName = {}
    for questId, isComplete in pairs(info) do
        if isComplete and quests[questId] and quests[questId].name then
            completedByName[quests[questId].name] = completedByName[quests[questId].name] or {num = 0, total = quests[questId].total}
            completedByName[quests[questId].name].num = completedByName[quests[questId].name].num + 1
        end
    end

    if not next(completedByName) then
        return
    end
    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'RIGHT')
    button.tooltip = tooltip
    for name, completionInfo in pairs(completedByName) do
        tooltip:AddLine(name, self:CreateFractionString(completionInfo.num, completionInfo.total))
    end

    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end
