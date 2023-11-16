local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local options

local module = 'vault'
local labelRows = {
    great_vault_mplus = {
        label = L['Vault M+'],
        type = 'vault',
        key = 'MythicPlus',
        tooltip = true,
        group = 'vault',
        version = WOW_PROJECT_MAINLINE
    },
    great_vault_raid = {
        label = L['Vault Raid'],
        type = 'vault',
        key = 'Raid',
        tooltip = true,
        group = 'vault',
        version = WOW_PROJECT_MAINLINE
    },
    great_vault_pvp = {
        label = L['Vault PVP'],
        type = 'vault',
        key = 'RankedPvP',
        tooltip = true,
        group = 'vault',
        version = WOW_PROJECT_MAINLINE
    }
}

local function valueChanged(oldTable, newTable, key, checkUneven)
    if not oldTable or not newTable or not key then
        return false
    end
    if not oldTable[key] or not newTable[key] then
        return false
    end

    if checkUneven then
        return newTable[key] ~= oldTable[key]
    else
        return newTable[key] > oldTable[key]
    end
end

local function UpdateVaultInfo(charInfo)
    local self = PermoksAccountManager

    charInfo.vaultInfo = charInfo.vaultInfo or {}
    local vaultInfo = charInfo.vaultInfo
    local activities = C_WeeklyRewards.GetActivities()
    for i, activityInfo in ipairs(activities) do
        if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Raid then
            vaultInfo.Raid = vaultInfo.Raid or {}
            local progressChanged = valueChanged(vaultInfo.Raid[activityInfo.index], activityInfo, 'progress')
            local levelChanged = valueChanged(vaultInfo.Raid[activityInfo.index], activityInfo, 'level', true)

            if not vaultInfo.Raid[activityInfo.index] or progressChanged or levelChanged then
                vaultInfo.Raid[activityInfo.index] = activityInfo
            end
        elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.Activities then
            vaultInfo.MythicPlus = vaultInfo.MythicPlus or {}
            local progressChanged = valueChanged(vaultInfo.MythicPlus[activityInfo.index], activityInfo, 'progress')
            local levelChanged = valueChanged(vaultInfo.MythicPlus[activityInfo.index], activityInfo, 'level', true)

            if not vaultInfo.MythicPlus[activityInfo.index] or progressChanged or levelChanged then
                vaultInfo.MythicPlus[activityInfo.index] = activityInfo
            end
        elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
            vaultInfo.RankedPvP = vaultInfo.RankedPvP or {}
            local progressChanged = valueChanged(vaultInfo.RankedPvP[activityInfo.index], activityInfo, 'progress')
            local levelChanged = valueChanged(vaultInfo.RankedPvP[activityInfo.index], activityInfo, 'level', true)

            if not vaultInfo.RankedPvP[activityInfo.index] or progressChanged or levelChanged then
                vaultInfo.RankedPvP[activityInfo.index] = activityInfo
            end
        end
    end
end

local function UpdateRaidActivity(charInfo)
    charInfo.raidActivityInfo = C_WeeklyRewards.GetActivityEncounterInfo(Enum.WeeklyRewardChestThresholdType.Raid, 1)
end

local function Update(charInfo)
    UpdateVaultInfo(charInfo)
    UpdateRaidActivity(charInfo)
end

local payload = {
    update = Update,
    events = {
        ['UPDATE_INSTANCE_INFO'] = {UpdateVaultInfo, UpdateRaidActivity},
        ['WEEKLY_REWARDS_UPDATE'] = {UpdateVaultInfo, UpdateRaidActivity},
        ['CHALLENGE_MODE_COMPLETED'] = {UpdateVaultInfo, UpdateRaidActivity}
    },
    share = {
        [UpdateVaultInfo] = 'vaultInfo'
    },
    labels = labelRows
}
PermoksAccountManager:AddModule(module, payload)

local function GetDifficultyString(type, level)
    if type == Enum.WeeklyRewardChestThresholdType.Raid then
        return DifficultyUtil.GetDifficultyName(level):sub(1, 1)
    elseif type == Enum.WeeklyRewardChestThresholdType.Activities then
        return level
    elseif type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
        return PVPUtil.GetTierName(level):sub(1, 2)
    end
end

function PermoksAccountManager:CreateVaultString(vaultInfo)
    local vaultString
    local difficulties = {}

    for i, activityInfo in ipairs(vaultInfo) do
        if not vaultString then
            if activityInfo.level > 0 then
                tinsert(difficulties, GetDifficultyString(activityInfo.type, activityInfo.level))
            end

            if activityInfo.threshold > activityInfo.progress or i == 3 then
                if #difficulties > 0 then
                    vaultString = string.format('%s (%s)', self:CreateFractionString(activityInfo.progress, activityInfo.threshold), table.concat(difficulties, '\124\124'))
                else
                    vaultString = self:CreateFractionString(activityInfo.progress, activityInfo.threshold)
                end
            end
        end
    end

    return vaultString
end

function PermoksAccountManager.VaultTooltip_OnEnter(button, altData, labelRow)
    if not altData or not altData.vaultInfo or not altData.vaultInfo[labelRow.key] then
        return
    end

    local self = PermoksAccountManager
    local vaultInfo = altData.vaultInfo[labelRow.key]
    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 4, 'LEFT', 'CENTER', 'CENTER', 'RIGHT')
    button.tooltip = tooltip

    tooltip:AddHeader(labelRow.label, '', '')
    tooltip:AddLine('')

    for i, activityInfo in pairs(vaultInfo) do
        local rewardItemLevel

        if activityInfo.progress >= activityInfo.threshold then
            if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Activities and activityInfo.level > 20 then
                rewardItemLevel = self.vault_rewards[activityInfo.type][20]
            else
                rewardItemLevel = self.vault_rewards[activityInfo.type][activityInfo.level] or nil
            end
        end

        if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Activities then
            local difficultyName = activityInfo.level and activityInfo.level > 0 and '+' .. activityInfo.level

            tooltip:AddLine(i .. '. Reward:', difficultyName or '-', '|', rewardItemLevel or self:CreateQuestString(activityInfo.progress, activityInfo.threshold))
        elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.Raid then
            local difficultyName = activityInfo.level and activityInfo.level > 0 and DifficultyUtil.GetDifficultyName(activityInfo.level)

            tooltip:AddLine(i .. '. Reward:', difficultyName or '-', '|', rewardItemLevel or self:CreateQuestString(activityInfo.progress, activityInfo.threshold))
        elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
            local difficultyName = activityInfo.level and PVPUtil.GetTierName(activityInfo.level)

            tooltip:AddLine(i .. '. Reward:', difficultyName or '-', '|', rewardItemLevel or self:CreateQuestString(activityInfo.progress, activityInfo.threshold))
        end

        if not rewardItemLevel then
            tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, 1, 0, 0)
        else
            tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, 0, 1, 0)
        end
    end

    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end
