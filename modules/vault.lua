local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateVaultInfo()
	local char_table = self.validateData()
	if not char_table then return end

	local vaultInfo = {}
	local activities = C_WeeklyRewards.GetActivities();
	for i, activityInfo in ipairs(activities) do
		if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Raid then
			vaultInfo.Raid = vaultInfo.Raid or {}
			vaultInfo.Raid[activityInfo.index] = activityInfo
		elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.MythicPlus then
			vaultInfo.MythicPlus = vaultInfo.MythicPlus or {}
			vaultInfo.MythicPlus[activityInfo.index] = activityInfo
		elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
			vaultInfo.RankedPvP = vaultInfo.RankedPvP or {}
			vaultInfo.RankedPvP[activityInfo.index] = activityInfo
		end
	end

	char_table.vaultInfo = vaultInfo
end


function AltManager:CreateWeeklyString(vaultInfo)
	if not vaultInfo then return end
	local activityInfo = vaultInfo[1]
	if not activityInfo or activityInfo.level == 0 then return end

	return string.format("+%d", activityInfo.level)
end

function AltManager:CreateVaultString(vaultInfo)
	if not vaultInfo then return end

	local vaultString

	for i, activityInfo in ipairs(vaultInfo) do
		if not vaultString then
			if activityInfo.threshold > activityInfo.progress then
				vaultString = self:CreateQuestString(activityInfo.progress, activityInfo.threshold)
			elseif i == 3 then
				vaultString = self:CreateQuestString(activityInfo.progress, activityInfo.threshold)
			end
		end
	end
	return vaultString
end

function AltManager:VaultTooltip_OnEnter(button, alt_data, name)
	if not alt_data or not alt_data.vaultInfo or not alt_data.vaultInfo[name] then return end
	local vaultInfo = alt_data.vaultInfo[name]
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 4, "LEFT", "CENTER", "CENTER", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader(name, '', '')
	tooltip:AddLine("")
	
	for i, activityInfo in pairs(vaultInfo) do
		local exampleRewardItem, rewardItemLevel
		if activityInfo.progress >= activityInfo.threshold then
			exampleRewardItem = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activityInfo.id)

			if activityInfo.type == Enum.WeeklyRewardChestThresholdType.MythicPlus and activityInfo.level >= 14 then
				rewardItemLevel = 226
			else
				rewardItemLevel = self.vault_rewards[activityInfo.type][activityInfo.level] or (exampleRewardItem and GetDetailedItemLevelInfo(exampleRewardItem)) or nil
			end
		end

		if activityInfo.type == Enum.WeeklyRewardChestThresholdType.MythicPlus then
			local difficultyName = activityInfo.level and activityInfo.level > 0 and "+" .. activityInfo.level

			tooltip:AddLine(i .. ". Reward:", difficultyName or "-", "|", rewardItemLevel or self:CreateQuestString(activityInfo.progress, activityInfo.threshold))
		elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.Raid then
			local difficultyName = activityInfo.level and activityInfo.level > 0 and DifficultyUtil.GetDifficultyName(activityInfo.level)

			tooltip:AddLine(i.. ". Reward:", difficultyName or "-", "|", rewardItemLevel or self:CreateQuestString(activityInfo.progress, activityInfo.threshold))
		elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
			local difficultyName = activityInfo.level and PVPUtil.GetTierName(activityInfo.level)

			tooltip:AddLine(i .. ". Reward:", difficultyName or "-", "|", rewardItemLevel or self:CreateQuestString(activityInfo.progress, activityInfo.threshold))
		end

		if not exampleRewardItem then
			tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, 1, 0, 0)
		else
			tooltip:SetCellTextColor(tooltip:GetLineCount(), 1, 0, 1, 0)
		end
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end