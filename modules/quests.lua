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
        isCompleteTest = true,
        isComplete = function(alt_data)
            return alt_data.questInfo and alt_data.questInfo.weekly and PermoksAccountManager:GetNumCompletedQuests(alt_data.questInfo.weekly.hidden.world_boss) == 2
        end,
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    korthia_world_boss = {
        label = 'Korthia WB',
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    anima_weekly = {
        label = L['1k Anima'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
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
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    wrath = {
        label = L['Wrath of the Jailer'],
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
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
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    zereth_mortis_dailies = {
        label = 'Dailies',
        type = 'quest',
        questType = 'daily',
        visibility = 'visible',
        required = 2,
		unlock = {
            key = 'zereth_mortis_three_dailies',
            charKey = 'researchInfo',
			required = 3,
        },
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    zereth_mortis_weekly = {
        label = 'Weekly',
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    },
    zereth_mortis_wqs = {
        label = 'ZM WQs',
        type = 'quest',
        questType = 'weekly',
        visibility = 'visible',
        required = 2,
        unlock = {
            key = 'zereth_mortis_three_wqs',
            charKey = 'researchInfo',
			required = 3,
        },
        group = 'resetDaily',
        version = WOW_PROJECT_MAINLINE
    },
    zereth_mortis_world_boss = {
        label = 'ZM WB',
        type = 'quest',
        questType = 'weekly',
        visibility = 'hidden',
        group = 'resetWeekly',
        version = WOW_PROJECT_MAINLINE
    }
}

local function AddBCDaily(charInfo, questID, key, unique)
    if unique then
        if not charInfo.completedDailies[key] then
            charInfo.completedDailies[key] = true
            charInfo.completedDailies.num = charInfo.completedDailies.num + 1
        end
    elseif not charInfo.completedDailies[questID] then
        charInfo.completedDailies[questID] = true
        charInfo.completedDailies.num = charInfo.completedDailies.num + 1
    end
end

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
                charInfo.completedDailies = charInfo.completedDailies or {}
                currentQuestInfo[questID] = currentQuestInfo[questID] or isComplete or nil

                if info.questType == 'daily' and isComplete then
                    AddBCDaily(charInfo, questID, key, info.unique)
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
            for key, _ in pairs(keys.hidden) do
                if self.quests[key] then
                    for questID, _ in pairs(self.quests[key]) do
                        local isComplete = charInfo.questInfo[questType].hidden[key][questID] or C_QuestLog.IsQuestFlaggedCompleted(questID)
                        charInfo.questInfo[questType].hidden[key][questID] = isComplete or nil
                    end
                end
            end
        end
    end
end

local HiddenQuestTimer
do
    local timer
    function HiddenQuestTimer(charInfo)
        if not timer then
            local function HiddenQuestTimerCallback()
                UpdateAllHiddenQuests(charInfo)
                timer = nil
            end
            timer = C_Timer.NewTimer(1, HiddenQuestTimerCallback)
        end
    end
end

local function AddQuest(_, questID, questLogIndex, questInfo)
    local self = PermoksAccountManager
    local questLogIndex = questLogIndex or (self.isBC and GetQuestLogIndexByID(questID) or C_QuestLog.GetLogIndexForQuestID(questID))
    if questLogIndex then
        local questInfo = questInfo or GetQuestInfo(questLogIndex)
        self.db.global.quests[questID] = {frequency = questInfo.frequency, name = questInfo.title}
    end
end

local function RemoveQuest(_, questID)
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

local function UpdateQuest(charInfo, questID)
    if not questID then
        return
    end

    local self = PermoksAccountManager
    if not charInfo.questInfo then
        UpdateAllQuests(charInfo)
    end

    local key = self:FindQuestKeyByQuestID(questID)
    if not key then
        return
    end

    local questInfo = self.quests[key][questID]
    local questType, visibility = questInfo.questType, questInfo.log and 'visible' or 'hidden'
    self:Debug('Update', questType, visibility, key, questID)
    if questType and visibility and key and charInfo.questInfo[questType][visibility][key] then
        if self.isBC and questType == 'daily' then
            AddBCDaily(charInfo, questID, key, questInfo.unique)
        end

        charInfo.questInfo[questType][visibility][key][questID] = true
        RemoveQuest(charInfo, questID)
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

    for _, questCompleted in pairs(questInfo) do
        numCompleted = questCompleted and numCompleted + 1 or numCompleted
    end

    return numCompleted
end

function PermoksAccountManager:CreateQuestString(questInfo, numDesired, replaceWithPlus)
    if not questInfo or not numDesired then
        return
    end
    local numCompleted = type(questInfo) == 'table' and self:GetNumCompletedQuests(questInfo) or questInfo
    if replaceWithPlus and numCompleted >= numDesired then
        return string.format('|cff00ff00%s|r', self.db.global.options.questCompletionString)
    else
        return self:CreateFractionString(numCompleted, numDesired)
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
