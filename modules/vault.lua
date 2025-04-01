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
        label = 'Vault World',
        type = 'vault',
        key = 'World',
        tooltip = true,
        group = 'vault',
        version = WOW_PROJECT_MAINLINE
    },
    great_vault_reward_available = {
        label = L['Vault Reward'],
        type = 'vault_reward',
        group = 'vault',
        version = WOW_PROJECT_MAINLINE
    }
}

local function CreateVaultRewardString(vaultRewardInfo)
    if vaultRewardInfo then
        return string.format("|cff00ff00Available|r")
    else
        return "-"
    end
end

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

-- https://github.com/Gethe/wow-ui-source/blob/87c526a3ae979a7f5244d635bd8ae952b4313bd8/Interface/AddOns/Blizzard_WeeklyRewardsUtil/Blizzard_WeeklyRewardsUtil.lua#L16
-- Blizzard doesn't count incomplete runs (runs which were depleted)
local function GetLowestLevelInTopDungeonRuns(numRuns)
	local lowestLevel;
	local lowestCount = 0;

	local numHeroic, numMythic, numMythicPlus = C_WeeklyRewards.GetNumCompletedDungeonRuns();
	-- if there are not enough MythicPlus runs, the lowest level might be either Heroic or Mythic
	if numRuns > numMythicPlus and (numHeroic + numMythic) > 0 then
		-- if there are not enough of both mythics combined, the lowest level might be Heroic
		if numRuns > numMythicPlus + numMythic and numHeroic > 0 then
			lowestLevel = WeeklyRewardsUtil.HeroicLevel;
			lowestCount = numRuns - numMythicPlus - numMythic;
		else
			lowestLevel = WeeklyRewardsUtil.MythicLevel;
			lowestCount = numRuns - numMythicPlus;
		end
		return lowestLevel, lowestCount;
	end

	local runHistory = C_MythicPlus.GetRunHistory(nil, true);
	table.sort(runHistory, function(left, right) return left.level > right.level; end);
	for i = math.min(numRuns, #runHistory), 1, -1 do
		local run = runHistory[i];
		if not lowestLevel then
			lowestLevel = run.level;
		end
		if lowestLevel == run.level then
			lowestCount = lowestCount + 1;
		else
			break;
		end
	end
	return lowestLevel, lowestCount;
end

local function UpdateVaultInfo(charInfo, force)
    local self = PermoksAccountManager

    charInfo.vaultRewardInfo = C_WeeklyRewards.HasAvailableRewards()
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
            activityInfo.level = activityInfo.progress > 0 and GetLowestLevelInTopDungeonRuns(activityInfo.threshold) or activityInfo.level

            local progressChanged = valueChanged(vaultInfo.MythicPlus[activityInfo.index], activityInfo, 'progress')
            local levelChanged = valueChanged(vaultInfo.MythicPlus[activityInfo.index], activityInfo, 'level', true)

            if not vaultInfo.MythicPlus[activityInfo.index] or progressChanged or levelChanged or force then
                vaultInfo.MythicPlus[activityInfo.index] = activityInfo
            end
        elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.World then
            vaultInfo.World = vaultInfo.World or {}
            local progressChanged = valueChanged(vaultInfo.World[activityInfo.index], activityInfo, 'progress')
            local levelChanged = valueChanged(vaultInfo.World[activityInfo.index], activityInfo, 'level', true)

            if not vaultInfo.World[activityInfo.index] or progressChanged or levelChanged then
                vaultInfo.World[activityInfo.index] = activityInfo
            end
        end
    end
end

local function UpdateRaidActivity(charInfo)
    charInfo.raidActivityInfo = C_WeeklyRewards.GetActivityEncounterInfo(Enum.WeeklyRewardChestThresholdType.Raid, 1)
end

local function Update(charInfo)
    UpdateVaultInfo(charInfo, true)
    UpdateRaidActivity(charInfo)
end

local payload = {
    update = Update,
    events = {
        ['UPDATE_INSTANCE_INFO'] = {UpdateVaultInfo, UpdateRaidActivity},
        ['WEEKLY_REWARDS_UPDATE'] = {UpdateVaultInfo, UpdateRaidActivity},
        ['CHALLENGE_MODE_COMPLETED'] = {UpdateVaultInfo, UpdateRaidActivity},
        ['CHALLEGE_MODE_MAPS_UPDATE'] = {UpdateVaultInfo, UpdateRaidActivity}
    },
    share = {
        [UpdateVaultInfo] = 'vaultInfo'
    },
    labels = labelRows
}
local module = PermoksAccountManager:AddModule(module, payload)
module:AddCustomLabelType('vault_reward', CreateVaultRewardString, nil, 'vaultRewardInfo')

local function GetDifficultyString(type, level)
    if type == Enum.WeeklyRewardChestThresholdType.Raid then
        return DifficultyUtil.GetDifficultyName(level):sub(1, 1)
    elseif type == Enum.WeeklyRewardChestThresholdType.Activities then
        return level
    elseif type == Enum.WeeklyRewardChestThresholdType.World then
        return level
    end
end

function PermoksAccountManager:CreateVaultString(vaultInfo)
    local vaultString
    local difficulties = {}

    for i, activityInfo in ipairs(vaultInfo) do
        if not vaultString then
            if activityInfo.progress >= activityInfo.threshold then
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
            if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Activities and activityInfo.level > 10 then
                rewardItemLevel = self.vault_rewards[activityInfo.type][10]
            else
                rewardItemLevel = self.vault_rewards[activityInfo.type][activityInfo.level] or nil
            end
        end

        if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Activities then
            local difficultyName = activityInfo.level and activityInfo.progress >= activityInfo.threshold and '+' .. activityInfo.level

            tooltip:AddLine(i .. '. Reward:', difficultyName or '-', '|', rewardItemLevel or self:CreateQuestString(activityInfo.progress, activityInfo.threshold))
        elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.Raid then
            local difficultyName = activityInfo.level and activityInfo.progress >= activityInfo.threshold and DifficultyUtil.GetDifficultyName(activityInfo.level)

            tooltip:AddLine(i .. '. Reward:', difficultyName or '-', '|', rewardItemLevel or self:CreateQuestString(activityInfo.progress, activityInfo.threshold))
        elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.World then
            local difficultyName = activityInfo.level and activityInfo.progress >= activityInfo.threshold and 'Tier ' .. activityInfo.level

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
