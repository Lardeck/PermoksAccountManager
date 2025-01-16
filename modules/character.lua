local addonName, PermoksAccountManager = ...
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local LibQTip = LibStub('LibQTip-1.0')
local options

local module = 'character'
local labelRows = {
	characterName = {
		hideLabel = true,
		label = L['Name'],
		hideOption = true,
		warband = true,
		big = true,
		offset = 1.5,
		type = 'characterName',
		tooltip = true,
		customTooltip = function(button, altData, labelRow)
			PermoksAccountManager:CustomEquippedItemsTooltip_OnEnter(button, altData, labelRow)
		end,
		data = function(alt_data)
			return PermoksAccountManager:CreateCharacterString(alt_data.name, alt_data.specInfo)
		end,
		color = function(alt_data)
			if alt_data.class then
				return RAID_CLASS_COLORS[alt_data.class]
			end
		end,
		version = false
	},
	characterLevel = {
		label = L['Level'],
		type = 'charLevel',
		data = function(alt_data)
			return alt_data.charLevel or '-'
		end,
		group = 'character',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
	},
	location = {
		label = L['Location'],
		data = function(alt_data)
			return (alt_data.location and PermoksAccountManager:CreateLocationString(alt_data.location)) or '-'
		end,
		group = 'character',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
	},
	ilevel = {
		label = L['Item Level'],
		data = function(alt_data)
			return alt_data.ilevel and string.format('%.2f', alt_data.ilevel) or '-'
		end,
		version = WOW_PROJECT_MAINLINE
	},
	ilevel_wrath = {
		label = L['Item Level'],
		data = function(alt_data)
			return string.format('%.2f', alt_data.ilevel or 0)
		end,
		group = 'character',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
	},
	gearScore = {
		label = L['Gear Score'],
		data = function(alt_data)
			local gearScore = alt_data.gearScore or 0
			return gearScore or '-'
		end,
		color = function(alt_data)
			local gearScore = alt_data.gearScore or 0
			local gearScoreRed = alt_data.gearScoreRed or 1
			local gearScoreGreen = alt_data.gearScoreGreen or 1
			local gearScoreBlue = alt_data.gearScoreBlue or 1

			if gearScore == 0 then
				return CreateColor(0.5, 0.5, 0.5)
			end

			return CreateColor(gearScoreRed, gearScoreGreen, gearScoreBlue, 1)
		end,
		group = 'character',
		version = WOW_PROJECT_CATACLYSM_CLASSIC
	},
	gold = {
		label = L['Gold'],
		type = 'gold',
		group = 'currency',
		version = false
	},
	keystone = {
		label = L['Keystone'],
		type = 'keystone',
		group = 'dungeons',
		version = WOW_PROJECT_MAINLINE,
		OnClick = function(button, altData)
			if button == "LeftButton" and IsShiftKeyDown() then
				PermoksAccountManager:PostKeyIntoChat(altData)
			end
		end,
	},
	tw_keystone = {
		label = L['TW Keystone'],
		type = 'twkeystone',
		group = 'dungeons',
		version = WOW_PROJECT_MAINLINE
	},
	weekly_key = {
		label = L['Highest Key'],
		type = 'weeklyKey',
		tooltip = true,
		customTooltip = function(button, alt_data)
			PermoksAccountManager:HighestKeyTooltip_OnEnter(button, alt_data)
		end,
		isComplete = function(alt_data)
			return alt_data.vaultInfo and alt_data.vaultInfo.MythicPlus and alt_data.vaultInfo.MythicPlus[1].level >= 15
		end,
		group = 'character',
		version = WOW_PROJECT_MAINLINE
	},
	mplus_score = {
		label = L['Mythic+ Score'],
		outline = "OUTLINE",
		type = 'dungeonScore',
		group = 'character',
		version = WOW_PROJECT_MAINLINE
	},
	contract = {
		label = L['Contract'],
		type = 'contract',
		group = 'character',
		version = WOW_PROJECT_MAINLINE
	}
}

local gsItemTypes = {
	["INVTYPE_RELIC"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
	["INVTYPE_TRINKET"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 33, ["Enchantable"] = false },
	["INVTYPE_2HWEAPON"] = { ["SlotMOD"] = 2.000, ["ItemSlot"] = 16, ["Enchantable"] = true },
	["INVTYPE_WEAPONMAINHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 16, ["Enchantable"] = true },
	["INVTYPE_WEAPONOFFHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
	["INVTYPE_RANGED"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = true },
	["INVTYPE_THROWN"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
	["INVTYPE_RANGEDRIGHT"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
	["INVTYPE_SHIELD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
	["INVTYPE_WEAPON"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 36, ["Enchantable"] = true },
	["INVTYPE_HOLDABLE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = false },
	["INVTYPE_HEAD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 1, ["Enchantable"] = true },
	["INVTYPE_NECK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 2, ["Enchantable"] = false },
	["INVTYPE_SHOULDER"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 3, ["Enchantable"] = true },
	["INVTYPE_CHEST"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
	["INVTYPE_ROBE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
	["INVTYPE_WAIST"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 6, ["Enchantable"] = false },
	["INVTYPE_LEGS"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 7, ["Enchantable"] = true },
	["INVTYPE_FEET"] = { ["SlotMOD"] = 0.75, ["ItemSlot"] = 8, ["Enchantable"] = true },
	["INVTYPE_WRIST"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 9, ["Enchantable"] = true },
	["INVTYPE_HAND"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 10, ["Enchantable"] = true },
	["INVTYPE_FINGER"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 31, ["Enchantable"] = false },
	["INVTYPE_CLOAK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 15, ["Enchantable"] = true },
	["INVTYPE_BODY"] = { ["SlotMOD"] = 0, ["ItemSlot"] = 4, ["Enchantable"] = false },
}

local gsFormula = {
	["A"] = {
		[4] = { ["A"] = 91.4500, ["B"] = 0.6500 },
		[3] = { ["A"] = 81.3750, ["B"] = 0.8125 },
		[2] = { ["A"] = 73.0000, ["B"] = 1.0000 }
	},
	["B"] = {
		[4] = { ["A"] = 26.0000, ["B"] = 1.2000 },
		[3] = { ["A"] = 0.7500, ["B"] = 1.8000 },
		[2] = { ["A"] = 8.0000, ["B"] = 2.0000 },
		[1] = { ["A"] = 0.0000, ["B"] = 2.2500 }
	}
}

local gsQuality = {
	[6000] = {
		["Red"] = { ["A"] = 0.94, ["B"] = 5000, ["C"] = 0.00006, ["D"] = 1 },
		["Green"] = { ["A"] = 0.47, ["B"] = 5000, ["C"] = 0.00047, ["D"] = -1 },
		["Blue"] = { ["A"] = 0, ["B"] = 0, ["C"] = 0, ["D"] = 0 },
		["Description"] = "Legendary"
	},
	[5000] = {
		["Red"] = { ["A"] = 0.69, ["B"] = 4000, ["C"] = 0.00025, ["D"] = 1 },
		["Green"] = { ["A"] = 0.28, ["B"] = 4000, ["C"] = 0.00019, ["D"] = 1 },
		["Blue"] = { ["A"] = 0.97, ["B"] = 4000, ["C"] = 0.00096, ["D"] = -1 },
		["Description"] = "Epic"
	},
	[4000] = {
		["Red"] = { ["A"] = 0.0, ["B"] = 3000, ["C"] = 0.00069, ["D"] = 1 },
		["Green"] = { ["A"] = 0.5, ["B"] = 3000, ["C"] = 0.00022, ["D"] = -1 },
		["Blue"] = { ["A"] = 1, ["B"] = 3000, ["C"] = 0.00003, ["D"] = -1 },
		["Description"] = "Superior"
	},
	[3000] = {
		["Red"] = { ["A"] = 0.12, ["B"] = 2000, ["C"] = 0.00012, ["D"] = -1 },
		["Green"] = { ["A"] = 1, ["B"] = 2000, ["C"] = 0.00050, ["D"] = -1 },
		["Blue"] = { ["A"] = 0, ["B"] = 2000, ["C"] = 0.001, ["D"] = 1 },
		["Description"] = "Uncommon"
	},
	[2000] = {
		["Red"] = { ["A"] = 1, ["B"] = 1000, ["C"] = 0.00088, ["D"] = -1 },
		["Green"] = { ["A"] = 1, ["B"] = 000, ["C"] = 0.00000, ["D"] = 0 },
		["Blue"] = { ["A"] = 1, ["B"] = 1000, ["C"] = 0.001, ["D"] = -1 },
		["Description"] = "Common"
	},
	[1000] = {
		["Red"] = { ["A"] = 0.55, ["B"] = 0, ["C"] = 0.00045, ["D"] = 1 },
		["Green"] = { ["A"] = 0.55, ["B"] = 0, ["C"] = 0.00045, ["D"] = 1 },
		["Blue"] = { ["A"] = 0.55, ["B"] = 0, ["C"] = 0.00045, ["D"] = 1 },
		["Description"] = "Trash"
	},
}

local function GearScoreGetEnchantInfo(ItemLink, ItemEquipLoc)
	local _, _, ItemSubString = string.find(ItemLink, "^|c%x+|H(.+)|h%[.*%]");
	local ItemSubStringTable = {}

	for v in string.gmatch(ItemSubString, "[^:]+") do
		tinsert(ItemSubStringTable, v)
	end

	ItemSubString = ItemSubStringTable[2] .. ":" .. ItemSubStringTable[3], ItemSubStringTable[2]
	local StringStart, _ = string.find(ItemSubString, ":")
	ItemSubString = string.sub(ItemSubString, StringStart + 1)
	if (ItemSubString == "0") and (gsItemTypes[ItemEquipLoc]["Enchantable"]) then
		local percent = (floor((-2 * (gsItemTypes[ItemEquipLoc]["SlotMOD"])) * 100) / 100);
		return (1 + (percent / 100));
	else
		return 1;
	end
end

local function GearScoreGetQuality(ItemScore)
	ItemScore = tonumber(ItemScore)
	if (not ItemScore) then
		return 0, 0, 0, "Trash"
	end

	if (ItemScore > 5999) then
		ItemScore = 5999
	end

	for i = 0, 6 do
		if ((ItemScore > i * 1000) and (ItemScore <= ((i + 1) * 1000))) then
			local Red = gsQuality[(i + 1) * 1000].Red["A"] +
				(((ItemScore - gsQuality[(i + 1) * 1000].Red["B"]) * gsQuality[(i + 1) * 1000].Red["C"]) * gsQuality[(i + 1) * 1000].Red["D"])
			local Blue = gsQuality[(i + 1) * 1000].Green["A"] +
				(((ItemScore - gsQuality[(i + 1) * 1000].Green["B"]) * gsQuality[(i + 1) * 1000].Green["C"]) * gsQuality[(i + 1) * 1000].Green["D"])
			local Green = gsQuality[(i + 1) * 1000].Blue["A"] +
				(((ItemScore - gsQuality[(i + 1) * 1000].Blue["B"]) * gsQuality[(i + 1) * 1000].Blue["C"]) * gsQuality[(i + 1) * 1000].Blue["D"])
			-- we swap up blue and green because for some reason the coloring of level power works like that
			return Red, Blue, Green, gsQuality[(i + 1) * 1000].Description
		end
	end
	return 0.1, 0.1, 0.1, "Trash"
end

local function GearScoreGetItemScore(ItemLink)
	local QualityScale = 1
	local PVPScale = 1
	local PVPScore = 0
	local GearScore = 0

	if not (ItemLink) then
		return 0, 0
	end

	local _, ItemLink, ItemRarity, ItemLevel, _, _, _, _, ItemEquipLoc, _ = GetItemInfo(ItemLink)
	local Table = {}
	local Scale = 1.8618

	if (ItemRarity == 5) then
		QualityScale = 1.3
		ItemRarity = 4
	elseif (ItemRarity == 1) then
		QualityScale = 0.005
		ItemRarity = 2
	elseif (ItemRarity == 0) then
		QualityScale = 0.005
		ItemRarity = 2
	end

	if (ItemRarity == 7) then
		ItemRarity = 3
		ItemLevel = 187.05;
	end

	if (gsItemTypes[ItemEquipLoc]) then
		if (ItemLevel > 120) then
			Table = gsFormula["A"]
		else
			Table = gsFormula["B"]
		end
		if (ItemRarity >= 2) and (ItemRarity <= 4) then
			GearScore = floor(((ItemLevel - Table[ItemRarity].A) / Table[ItemRarity].B) *
				gsItemTypes[ItemEquipLoc].SlotMOD * Scale * QualityScale)

			if (ItemLevel == 187.05) then
				ItemLevel = 0
			end

			if (GearScore < 0) then
				GearScore = 0
			end

			if (PVPScale == 0.75) then
				PVPScore = 1
				GearScore = GearScore * 1
			else
				PVPScore = GearScore * 0
			end

			local percent = (GearScoreGetEnchantInfo(ItemLink, ItemEquipLoc) or 1)
			GearScore = floor(GearScore * percent)
			PVPScore = floor(PVPScore)

			return GearScore, ItemLevel
		end
	end

	return -1, ItemLevel
end

local function GearScoreGetScore(Name, Target)
	if (UnitIsPlayer(Target)) then
		local _, PlayerEnglishClass = UnitClass(Target)
		local TempScore, _ = nil
		local GearScore = 0
		local ItemCount = 0
		local LevelTotal = 0
		local TitanGrip = 1

		local mainHandItemLink = GetInventoryItemLink(Target, 16)
		local offhandItemLink = GetInventoryItemLink(Target, 17)

		if (mainHandItemLink) and (offhandItemLink) then
			local _, _, _, _, _, _, _, _, ItemEquipLoc, _ = GetItemInfo(mainHandItemLink)
			if (ItemEquipLoc == "INVTYPE_2HWEAPON") then
				TitanGrip = 0.5
			end
		end

		if (offhandItemLink) then
			local _, _, _, _, _, _, _, _, ItemEquipLoc, _ = GetItemInfo(offhandItemLink)
			if (ItemEquipLoc == "INVTYPE_2HWEAPON") then
				TitanGrip = 0.5
			end

			local TempScore, ItemLevel = GearScoreGetItemScore(offhandItemLink)
			if (PlayerEnglishClass == "HUNTER") then
				TempScore = TempScore * 0.3164
			end

			-- failsafe because sometimes it seems to be nil
			if ItemLevel == nil then
				ItemLevel = 0
			end

			GearScore = GearScore + TempScore * TitanGrip
			ItemCount = ItemCount + 1
			LevelTotal = LevelTotal + ItemLevel
		end

		for i = 1, 18 do
			if (i ~= 4) and (i ~= 17) then
				local ItemLink = GetInventoryItemLink(Target, i)
				if (ItemLink) then
					local _, ItemLink, _, ItemLevel, _, _, _, _, _, _ = GetItemInfo(ItemLink)
					TempScore, _ = GearScoreGetItemScore(ItemLink)

					if (i == 16) and (PlayerEnglishClass == "HUNTER") then
						TempScore = TempScore * 0.3164
					end

					if (i == 18) and (PlayerEnglishClass == "HUNTER") then
						TempScore = TempScore * 5.3224
					end

					if (i == 16) then
						TempScore = TempScore * TitanGrip
					end

					-- failsafe because sometimes it seems to be nil
					if ItemLevel == nil then
						ItemLevel = 0
					end

					GearScore = GearScore + TempScore
					ItemCount = ItemCount + 1
					LevelTotal = LevelTotal + ItemLevel
				end
			end
		end

		if (GearScore <= 0) and (Name ~= UnitName("player")) then
			GearScore = 0
			return 0, 0
		elseif (Name == UnitName("player")) and (GearScore <= 0) then
			GearScore = 0
		end

		if (ItemCount == 0) then
			LevelTotal = 0
		end

		return floor(GearScore), LevelTotal / ItemCount
	end
end

local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID or GetPlayerAuraBySpellID
local function UpdateGeneralData(charInfo)
	local self = PermoksAccountManager

	if self.isRetail then
		charInfo.ilevel = select(2, GetAverageItemLevel())

		-- Contracts
		local contract = nil
		local contracts = { [311457] = 'CoH', [311458] = 'Ascended', [311460] = 'UA', [311459] = 'WH', [353999] = 'DA' }
		for spellId, faction in pairs(contracts) do
			local info = { GetPlayerAuraBySpellID(spellId) }
			if info[1] then
				contract = { faction = faction, duration = info[5], expirationTime = time() + (info[6] - GetTime()) }
				break
			end
		end
		charInfo.contract = contract

		-- Covenant
		local covenant = C_Covenants and C_Covenants.GetActiveCovenantID()
		charInfo.covenant = covenant and covenant > 0 and covenant or nil
		charInfo.callingsUnlocked = C_CovenantCallings and C_CovenantCallings.AreCallingsUnlocked()
	elseif self.isWOTLK or self.isCata then
		-- Gear Score and Item Level
		local gearScore, ilvl = GearScoreGetScore(UnitName('player'), 'player')
		local red, green, blue = GearScoreGetQuality(gearScore)

		charInfo.gearScore = gearScore
		charInfo.gearScoreRed = red
		charInfo.gearScoreGreen = green
		charInfo.gearScoreBlue = blue
		charInfo.ilevel = ilvl
	end
end

local function UpdateKeystones(charInfo)
	if not PermoksAccountManager.isRetail then return end

	charInfo.keyInfo = charInfo.keyInfo or {}
	C_Timer.After(0.5, function()
		local ownedKeystone = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local keyInfo = charInfo.keyInfo
		keyInfo.keyDungeon = ownedKeystone and PermoksAccountManager.keys[ownedKeystone] or L['No Key']
		keyInfo.keyLevel = ownedKeystone and C_MythicPlus.GetOwnedKeystoneLevel() or 0
		keyInfo.keyMapID = ownedKeystone

		local activityID, _, keyLevel = C_LFGList.GetOwnedKeystoneActivityAndGroupAndLevel(true)
		local keyDungeonID = PermoksAccountManager.activityIDToKeys[activityID]
		keyInfo.twKeyDungeon = keyDungeonID and PermoksAccountManager.keys[keyDungeonID] or L['No Key']
		keyInfo.twKeyLevel = keyDungeonID and keyLevel or 0
	end)
end

local function UpdateGold(charInfo)
	charInfo.gold = floor(GetMoney() / (COPPER_PER_SILVER * SILVER_PER_GOLD)) * 10000
end

local function UpdateILevel(charInfo)
	if not PermoksAccountManager.isBC then
		charInfo.ilevel = select(2, GetAverageItemLevel())
	end
end

local function UpdateEquip(charInfo, ...)
	local equipmentSlot, isEmpty = ...

	charInfo.equippedItems = charInfo.equippedItems or {}

	if isEmpty then
		charInfo.equippedItems[equipmentSlot] = nil
	else
		local itemID = GetInventoryItemID("player", equipmentSlot)
		if itemID then
			local itemObject = Item:CreateFromItemID(itemID)
			itemObject:ContinueOnItemLoad(function()
				local itemLink = GetInventoryItemLink("player", equipmentSlot)
				local itemName = itemObject:GetItemName()
				local itemQuality = itemObject:GetItemQuality()
				local itemEquipLoc = itemObject:GetInventoryTypeName()

				charInfo.equippedItems[equipmentSlot] = {
					equipmentSlot = equipmentSlot,
					itemTexture = GetInventoryItemTexture("player", equipmentSlot),
					itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink),
					itemName = itemName,
					itemQuality = itemQuality,
					itemID = itemID,
					itemLink = itemLink,
					itemSlot = _G[itemEquipLoc],
				}
			end)
		else
			charInfo.equippedItems[equipmentSlot] = nil
		end
	end
end

local function UpdateCharacterEquip(charInfo)
	for equipmentSlot = 1, 18 do
		UpdateEquip(charInfo, equipmentSlot)
	end
end

local function UpdateMythicScore(charInfo)
	if not PermoksAccountManager.isRetail then return end

	C_MythicPlus.RequestMapInfo()
	charInfo.mythicScore = C_ChallengeMode.GetOverallDungeonScore()
end

local function UpdateMythicPlusHistory(charInfo)
	charInfo.mythicPlusHistory = C_MythicPlus and C_MythicPlus.GetRunHistory(nil, true)
end

local function UpdatePlayerSpecialization(charInfo)
	if GetSpecializationInfo then
		charInfo.specInfo = { GetSpecializationInfo(GetSpecialization()) }
	elseif GetTalentTabInfo then
		local primaryTalentTree = GetPrimaryTalentTree()
		if primaryTalentTree then
			charInfo.specInfo = { GetTalentTabInfo(primaryTalentTree) }
		end
	end
end

local function UpdatePlayerLevel(charInfo, level)
	charInfo.charLevel = level or UnitLevel('player')
end

local function UpdateLocation(charInfo)
	charInfo.location = C_Map.GetBestMapForUnit('player')
end

local function Update(charInfo)
	UpdateGeneralData(charInfo)
	UpdateGold(charInfo)

	if PermoksAccountManager.isBC then
		UpdatePlayerLevel(charInfo)
		UpdateLocation(charInfo)
	else
		UpdateILevel(charInfo)
		UpdateCharacterEquip(charInfo)
		UpdatePlayerSpecialization(charInfo)
		UpdateMythicScore(charInfo)
		UpdateMythicPlusHistory(charInfo)
	end
end

local function CreateGoldString(gold)
	return gold and tonumber(gold) and GetMoneyString(gold, true) or '-'
end

local function CreateCharacterString(name, specInfo)
	if not name then
		return '-'
	end

	local specString
	if specInfo and PermoksAccountManager.db.global.options.showCurrentSpecIcon then
		specString = string.format('\124T%d:0\124t', specInfo[4])
	end

	return string.format('%s %s', name, specString or '')
end

local function CreateKeystoneString(name, keyInfo)
	if name == 'Warband' then
		return '-'
	elseif not keyInfo or not type(keyInfo) == "table" or not keyInfo.keyDungeon then
		return 'Unknown'
	end

	if keyInfo.keyLevel == 0 then
		return string.format('%s', keyInfo.keyDungeon)
	end

	return string.format('%s+%d', keyInfo.keyDungeon, keyInfo.keyLevel)
end

local function CreateTWKeystoneString(keyInfo)
	if not keyInfo or not type(keyInfo) == "table" or not keyInfo.twKeyDungeon then
		return 'Unknown'
	end

	if keyInfo.twKeyLevel == 0 then
		return string.format('%s', keyInfo.twKeyDungeon)
	end

	return string.format('%s+%d', keyInfo.twKeyDungeon, keyInfo.twKeyLevel)
end

local function CreateDungeonScoreString(score)
	if not score then
		return '-'
	end

	if PermoksAccountManager.db.global.options.useScoreColor then
		local color = C_ChallengeMode.GetDungeonScoreRarityColor(score)
		return color:WrapTextInColorCode(AbbreviateLargeNumbers(score))
	else
		return AbbreviateLargeNumbers(score)
	end
end

local function CreateWeeklyString(vaultInfo)
	if not vaultInfo or not vaultInfo.MythicPlus then
		return '-'
	end

	local activityInfo = vaultInfo.MythicPlus[1]
	if not activityInfo or activityInfo.level <= 0 then
		return '-'
	end

	return string.format('+%d', activityInfo.level)
end

local function CreateContractString(contractInfo)
	if not contractInfo then
		return '-'
	end

	local seconds = PermoksAccountManager:GetSecondsRemaining(contractInfo.expirationTime)
	local timeString = SecondsToTime(seconds)
	return string.format('%s - %s', contractInfo.faction, PermoksAccountManager:FormatTimeString(seconds, timeString))
end

local payload = {
	update = Update,
	events = {
		['PLAYER_MONEY'] = UpdateGold,
		['PLAYER_AVG_ITEM_LEVEL_UPDATE'] = UpdateILevel,
		['PLAYER_EQUIPMENT_CHANGED'] = { UpdateILevel, UpdateEquip },
		['PLAYER_SPECIALIZATION_CHANGED'] = UpdatePlayerSpecialization,
		['CHALLENGE_MODE_MAPS_UPDATE'] = { UpdateMythicScore, UpdateMythicPlusHistory },
		['BAG_UPDATE_DELAYED'] = { UpdateGeneralData, UpdateKeystones },
		['ITEM_CHANGED'] = UpdateKeystones,
		['WEEKLY_REWARDS_UPDATE'] = UpdateMythicScore,
		['PLAYER_LEVEL_UP'] = UpdatePlayerLevel,
		['ZONE_CHANGED'] = UpdateLocation,
		['ZONE_CHANGED_NEW_AREA'] = UpdateLocation,
		['ZONE_CHANGED_INDOORS'] = UpdateLocation
	},
	share = {
		[UpdateGold] = 'gold',
		[UpdateILevel] = 'ilevel',
		[UpdatePlayerSpecialization] = 'specInfo',
		[UpdateMythicPlusHistory] = 'mythicPlusHistory',
		[UpdateMythicScore] = 'mythicScore',
		[UpdatePlayerLevel] = 'charLevel'
	},
	labels = labelRows
}
local module = PermoksAccountManager:AddModule(module, payload)
module:AddCustomLabelType('gold', CreateGoldString, true, 'gold')
module:AddCustomLabelType('characterName', CreateCharacterString, nil, 'name', 'specInfo')
module:AddCustomLabelType('keystone', CreateKeystoneString, nil, 'name', 'keyInfo')
module:AddCustomLabelType('twkeystone', CreateTWKeystoneString, nil, 'keyInfo')
module:AddCustomLabelType('dungeonScore', CreateDungeonScoreString, true, 'mythicScore')
module:AddCustomLabelType('weeklyKey', CreateWeeklyString, nil, 'vaultInfo')
module:AddCustomLabelType('contract', CreateContractString, nil, 'contractInfo')

function PermoksAccountManager:CreateLocationString(mapId)
	if not mapId then
		return
	end
	local mapInfo = C_Map.GetMapInfo(mapId)
	return mapInfo and mapInfo.name
end

local function reverseSort(a, b)
	return a > b
end

function PermoksAccountManager:HighestKeyTooltip_OnEnter(button, alt_data)
	if not alt_data or not alt_data.mythicPlusHistory or #alt_data.mythicPlusHistory == 0 then
		return
	end

	local runs = {}
	local runPerDungeon = {}
	for _, info in ipairs(alt_data.mythicPlusHistory) do
		runPerDungeon[info.mapChallengeModeID] = runPerDungeon[info.mapChallengeModeID] or {}
		runPerDungeon[info.mapChallengeModeID][info.level] = (runPerDungeon[info.mapChallengeModeID][info.level] or 0) +
			1

		tinsert(runs, info.level)
	end

	table.sort(runs, reverseSort)

	for i in ipairs(runs) do
		if i == 1 or i == 4 or i == 8 then
			runs[i] = string.format('|cff00f7ff+%d|r', runs[i])
		else
			runs[i] = "+" .. runs[i]
		end
	end

	local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'LEFT')
	button.tooltip = tooltip
	tooltip:SetBackdropColor(0, 0, 0, 1)
	tooltip:AddLine('Vault Keys:', table.concat(runs, ', ', 1, (min(#runs, 8))))
	tooltip:AddLine('')
	tooltip:AddSeparator(2, 1, 1, 1)

	local total = 0
	for mapChallengeModeID, levels in pairs(runPerDungeon) do
		local keys = {}
		for level, count in self.spairs(levels, function(_, a, b) return a > b end) do
			tinsert(keys, string.format('+%d (%d)', level, count))
			total = total + count
		end
		tooltip:AddLine(PermoksAccountManager.keys[mapChallengeModeID], table.concat(keys, ', '))
	end

	tooltip:AddSeparator(2, 1, 1, 1)
	tooltip:AddLine(string.format("|cff03fc52Total:|r"), total)

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end

local equipmentSlotOrdered = { 1, 2, 3, 15, 5, 4, 19, 9, 10, 6, 7, 8, 11, 12, 13, 14, 16, 17, 18 }

function PermoksAccountManager:CustomEquippedItemsTooltip_OnEnter(button, altData, labelRow)
	if not altData or not altData.equippedItems then
		return
	end

	local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 2, 'LEFT', 'LEFT')
	button.tooltip = tooltip
	tooltip:SetBackdropColor(0, 0, 0, 1)
	tooltip:AddHeader('Equipment:')
	tooltip:AddSeparator(2, 1, 1, 1)

	for _, equipmentSlot in ipairs(equipmentSlotOrdered) do
		local item = altData.equippedItems[equipmentSlot]
		if item then
			if (not item.itemName or not item.itemTexture or not item.itemQuality or not item.itemLink or not item.itemSlot) and item.itemID then
				local itemObject = Item:CreateFromItemID(item.itemID)
				local y, x = tooltip:AddLine()
				itemObject:ContinueOnItemLoad(function()
					item.itemLink = itemObject:GetItemLink()
					item.itemQuality = itemObject:GetItemQuality()
					item.itemName = itemObject:GetItemName()
					item.itemSlot = _G[itemObject:GetInventoryTypeName()]
					item.itemTexture = itemObject:GetItemIcon()

					if tooltip:IsAcquiredBy(addonName .. 'Tooltip') then
						tooltip:SetCell(y, 1, string.format("%s:", item.itemSlot))
						tooltip:SetCell(y, 2,
							string.format("|T%d:0|t|c%s[%s]|r [%s]", item.itemTexture,
								ITEM_QUALITY_COLORS[item.itemQuality].color:GenerateHexColor(), item.itemName,
								item.itemLevel or "N/A"))
					end
				end)
			else
				if not item.itemLevel and altData.GUID == UnitGUID("player") then

				end

				tooltip:AddLine(string.format("%s:", item.itemSlot),
					string.format("|T%d:0|t|c%s[%s]|r [%s]", item.itemTexture,
						ITEM_QUALITY_COLORS[item.itemQuality].color:GenerateHexColor(), item.itemName,
						item.itemLevel or "N/A"))
			end
		end
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end
