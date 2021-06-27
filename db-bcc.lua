local addonName, AltManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local default_categories = {
	general = {
		order = 0,
		name = "General",
		childs = {"characterName", "characterLevel", "gold", "location", "profession1CDs", "profession2CDs", "dailyQuestCounter"},
		childOrder = {characterName = 1, characterLevel = 2, gold = 3, location = 4, profession1CDs = 5, profession2CDs = 6, dailyQuestCounter = 7},
		hideToggle = true,
		enabled = true,
	},
	sharedFactions = {
		order = 3.1,
		name = "Shared Rep",
		childs = {"theAldor", "theScryers", "separator1", "theShatar", "cenarionExpedition", "keepersOfTime", "lowerCity", "separator2",
		"theConsortium", "theVioletEye", "sporeggar", "theScaleOfTheSands", "netherwing", "ogrila", "shatteredSunOffensive"},
		childOrder = {theAldor = 1, theScryers = 2, separator1 = 3, theShatar = 4, cenarionExpedition = 5, keepersOfTime = 6, lowerCity = 7, separator2 = 8,
		theConsortium = 9, theVioletEye = 10, sporeggar = 11, theScaleOfTheSands = 12, netherwing = 13, ogrila = 14, shatteredSunOffensive = 15},
		enabled = true,
	},
	allianceFactions = {
		order = 3.2,
		name = "Alliance Rep",
		childs = {"exodar", "honorHold", "kurenai"},
		childOrder = {exodar = 1, honorHold = 2, kurenai = 3},
		enabled = true,
	},
	hordeFactions = {
		order = 3.3,
		name = "Horde Rep",
		childs = {"silvermoonCity", "theMaghar", "thrallmar"},
		childOrder = {silvermoonCity = 1, theMaghar = 2, thrallmar = 3},
		enabled = true,
	},
	lockouts = {
		order = 4,
		name = "Lockouts",
		childs = {"heroicsDone", "separator1", "karazhan", "magtheridon", "gruul", "separator2", "serpentshrine", "tempestkeep",
		"separator3", "hyjal", "blacktemple", "separator4", "sunwell"},
		childOrder = {heroicsDone = 1, separator1 = 2, karazhan = 3, magtheridon = 4, gruul = 5, separator2 = 6, serpentshrine = 7, tempestkeep = 8,
		separator3 = 9, hyjal = 10, blacktemple = 11, separator4 = 12, sunwell = 13},
		enabled = true,
	},
	attunements = {
		order = 5,
		name = "Attunements",
		childs = {"shatteredHallsKey", "citadelKey", "reservoirKey", "auchenaiKey", "warpforgedKey", "keyOfTime", "hillsbradAttunement", "blackmorassAttunement", "separator1", "karazhanAttunement", "serpentshrineAttunement",
		"theEyeAttunement", "hyjalSummitAttunement"},
		childOrder = {shatteredHallsKey = 1, citadelKey = 2, reservoirKey = 3, auchenaiKey = 4, warpforgedKey = 5, keyOfTime = 6, hillsbradAttunement = 6.1, blackmorassAttunement = 6.2, separator1 = 7, karazhanAttunement = 8, serpentshrineAttunement = 9,
		theEyeAttunement = 10, hyjalSummitAttunement = 11},
		enabled = true,
	},
	consumables = {
		order = 6,
		name = "Consumables",
		childs = {},
		childOrder = {},
		enabled = false
	},
	items = {
		order = 7,
		name = "Items",
		childs = {},
		childOrder = {},
		enabled = false,
	}
}

AltManager.groups = {
	attunement = {
		label = "Attunements"
	},
	currency = {
		label = "Currency",
	},
	resetDaily = {
		label = "Daily Reset",
	},
	resetWeekly = {
		label = "Weekly Reset",
	},
	dungeons = {
		label = "Dungeons",
	},
	raids = {
		label = "Raids",
	},
	reputation = {
		label = "Reputation",
	},
	buff = {
		label = "Buff",
	},
	separator = {
		label = "Separator",
	},
	item = {
		label = "Items",
	},
	extra = {
		label = "Extra",
	},
	profession = {
		label = "Professions",
	}
}

AltManager.groupOrder = {"separator", "currency", "resetDaily", "resetWeekly", "dungeons", "raids", "reputation", "buff", "item", "extra", "profession"}

AltManager.columns = {
	characterName = {
		order = 0.1,
		fakeLabel = "Name",
		hideOption = true,
		data = function(alt_data) return alt_data.name end,
		color = function(alt_data) return RAID_CLASS_COLORS[alt_data.class] end,
	},
	characterLevel = {
		fakeLabel = "Level",
		justify = "TOP",
		data = function(alt_data) return alt_data.charLevel or "-" end,
		small = true,
	},
	gold = {
		label = "Gold",
		option = "gold",
		data = function(alt_data) return alt_data.gold and tonumber(alt_data.gold) and GetMoneyString(alt_data.gold, true) or "-" end,
		group = "currency",
	},
	location = {
		label = "Location",
		data = function(alt_data) return (alt_data.location and AltManager:CreateLocationString(alt_data.location)) or "-" end,
		group = "extra",
	},
	profession1CDs = {
		label = "Profession 1",
		tooltip = function(button, alt_data) AltManager:ProfessionTooltip_OnEnter(button, alt_data, alt_data.professions[1]) end,
		data = function(alt_data) return alt_data.professions and AltManager:CreateProfessionString(alt_data.professions[1]) or "-" end,
		group = "profession",
	},
	profession2CDs = {
		label = "Profession 2",
		tooltip = function(button, alt_data) AltManager:ProfessionTooltip_OnEnter(button, alt_data, alt_data.professions[2]) end,
		data = function(alt_data) return alt_data.professions and AltManager:CreateProfessionString(alt_data.professions[2]) or "-" end,
		group = "profession",
	},
	dailyQuestCounter = {
		label = "Daily Quests",
		data = function(alt_data) return alt_data.completedDailies and alt_data.completedDailies.num and AltManager:CreateFractionString(alt_data.completedDailies.num, 30) or "Login" end,
		group = "resetDaily",
	},
	theAldor = {
		label = function() return AltManager.factions.faction[932].localName or AltManager.factions.faction[932].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[932])) or "-" end,
		group = "reputation",
	},
	theScryers = {
		label = function() return AltManager.factions.faction[934].localName or AltManager.factions.faction[934].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[934])) or "-" end,
		group = "reputation",
	},
	silvermoonCity = {
		label = function() return AltManager.factions.faction[911].localName or AltManager.factions.faction[911].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[911])) or "-" end,
		group = "reputation",
	},
	exodar = {
		label = function() return AltManager.factions.faction[930].localName or AltManager.factions.faction[930].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[930])) or "-" end,
		group = "reputation",
	},
	theShatar = {
		label = function() return AltManager.factions.faction[935].localName or AltManager.factions.faction[935].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[935])) or "-" end,
		group = "reputation",
	},
	cenarionExpedition = {
		label = function() return AltManager.factions.faction[942].localName or AltManager.factions.faction[942].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[942])) or "-" end,
		group = "reputation",
	},
	honorHold = {
		label = function() return AltManager.factions.faction[946].localName or AltManager.factions.faction[946].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[946])) or "-" end,
		group = "reputation",
	},
	thrallmar = {
		label = function() return AltManager.factions.faction[947].localName or AltManager.factions.faction[947].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[947])) or "-" end,
		group = "reputation",
	},
	keepersOfTime = {
		label = function() return AltManager.factions.faction[989].localName or AltManager.factions.faction[989].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[989])) or "-" end,
		group = "reputation",
	},
	lowerCity = {
		label = function() return AltManager.factions.faction[1011].localName or AltManager.factions.faction[1011].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[1011])) or "-" end,
		group = "reputation",
	},
	theConsortium = {
		label = function() return AltManager.factions.faction[933].localName or AltManager.factions.faction[933].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[933])) or "-" end,
		group = "reputation",
	},
	theVioletEye = {
		label = function() return AltManager.factions.faction[967].localName or AltManager.factions.faction[967].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[967])) or "-" end,
		group = "reputation",
	},
	sporeggar = {
		label = function() return AltManager.factions.faction[970].localName or AltManager.factions.faction[970].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[970])) or "-" end,
		group = "reputation",
	},
	theScaleOfTheSands = {
		label = function() return AltManager.factions.faction[990].localName or AltManager.factions.faction[990].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[990])) or "-" end,
		group = "reputation",
	},
	netherwing = {
		label = function() return AltManager.factions.faction[1015].localName or AltManager.factions.faction[1015].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[1015])) or "-" end,
		group = "reputation",
	},
	ogrila = {
		label = function() return AltManager.factions.faction[1038].localName or AltManager.factions.faction[1038].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[1038])) or "-" end,
		group = "reputation",
	},
	shatteredSunOffensive = {
		label = function() return AltManager.factions.faction[1077].localName or AltManager.factions.faction[1077].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[1077])) or "-" end,
		group = "reputation",
	},
	theMaghar = {
		label = function() return AltManager.factions.faction[941].localName or AltManager.factions.faction[941].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[941])) or "-" end,
		group = "reputation",
	},
	kurenai = {
		label = function() return AltManager.factions.faction[978].localName or AltManager.factions.faction[978].name end,
		data = function(alt_data) return (alt_data.factions and AltManager:CreateFactionString(alt_data.factions[978])) or "-" end,
		group = "reputation",
	},
	karazhanAttunement = {
		label = "Karazhan",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.mastersKey and AltManager:CreateQuestString(alt_data.itemCounts.mastersKey.total, 1, true)) or "-" end,
		group = "attunement",
	},
	serpentshrineAttunement = {
		label = "Serpentshrine",
		data = function(alt_data) return (alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.attunements.serpentshrine, 1, true)) or "-" end,
		group = "attunement",
	},
	theEyeAttunement = {
		label = "Tempest Keep",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.tempestKey and AltManager:CreateQuestString(alt_data.itemCounts.tempestKey.total, 1, true)) or "-" end,
		group = "attunement",
	},
	hyjalSummitAttunement = {
		label = "Hyjal Summit",
		data = function(alt_data) return (alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.attunements.hyjal, 1, true)) or "-" end,
		group = "attunement",
	},
	hillsbradAttunement = {
		label = "Hillsbrad",
		data = function(alt_data) return (alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.attunements.hillsbrad, 1, true)) or "-" end,
		group = "attunement",
	},
	blackmorassAttunement = {
		label = "Black Morass",
		data = function(alt_data) return (alt_data.questInfo and AltManager:CreateQuestString(alt_data.questInfo.attunements.blackmorass, 1, true)) or "-" end,
		group = "attunement",
	},
	heroicsDone = {
		label = "Heroic Dungeons",
		tooltip = function(button, alt_data) AltManager:DungeonTooltip_OnEnter(button, alt_data) end,
		data = function(alt_data) return alt_data.instanceInfo and AltManager:CreateDungeonString(alt_data.instanceInfo.dungeons) or "-" end,
		group = "dungeons",
	},
	karazhan = {
		label = "Karazhan",
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.karazhan, true)) or "-" end,
		group = "raids",
	},
	hyjal = {
		label = "Hyjal Summit",
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.hyjal, true)) or "-" end,
		group = "raids",
	},
	magtheridon = {
		label = "Magtheridon",
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.magtheridon, true)) or "-" end,
		group = "raids",
	},
	serpentshrine = {
		label = "Serpentshrine",
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.serpentshrine, true)) or "-" end,
		group = "raids",
	},
	tempestkeep = {
		label = "Tempest Keep",
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.tempestkeep, true)) or "-" end,
		group = "raids",
	},
	blacktemple = {
		label = "Black Temple",
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.blacktemple, true)) or "-" end,
		group = "raids",
	},
	gruul = {
		label = "Gruul",
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.gruul, true)) or "-" end,
		group = "raids",
	},
	sunwell = {
		label = "Sunwell Plateau",
		data = function(alt_data) return (alt_data.instanceInfo and AltManager:CreateRaidString(alt_data.instanceInfo.raids.sunwell, true)) or "-" end,
		group = "raids",
	},
	separator1 = {
		fakeLabel = "Separator1",
		data = function() return "" end,
		group = "separator",
	},
	separator2 = {
		fakeLabel = "Separator2",
		data = function() return "" end,
		group = "separator",
	},
	separator3 = {
		fakeLabel = "Separator3",
		data = function() return "" end,
		group = "separator",
	},
	separator4 = {
		fakeLabel = "Separator4",
		data = function() return "" end,
		group = "separator",
	},
	separator5 = {
		fakeLabel = "Separator5",
		data = function() return "" end,
		group = "separator",
	},
	separator6 = {
		fakeLabel = "Separator6",
		data = function() return "" end,
		group = "separator",
	},

	-- Items
	shatteredHallsKey = {
		label = "Shattered Halls",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.shatteredHallsKey and AltManager:CreateQuestString(alt_data.itemCounts.shatteredHallsKey.total, 1, true)) or "-" end,
		group = "item",
	},
	citadelKey = {
		label = "Hellfire Citadel",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.citadelKey and AltManager:CreateQuestString(alt_data.itemCounts.citadelKey.total, 1, true)) or "-" end,
		group = "item",
	},
	reservoirKey = {
		label = "Coilfang Reservoir",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.reservoirKey and AltManager:CreateQuestString(alt_data.itemCounts.reservoirKey.total, 1, true)) or "-" end,
		group = "item",
	},
	auchenaiKey = {
		label = "Auchindoun",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.auchenaiKey and AltManager:CreateQuestString(alt_data.itemCounts.auchenaiKey.total, 1, true)) or "-" end,
		group = "item",
	},
	warpforgedKey = {
		label = "TP Dungeons",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.warpforgedKey and AltManager:CreateQuestString(alt_data.itemCounts.warpforgedKey.total, 1, true)) or "-" end,
		group = "item",
	},
	keyOfTime = {
		label = "Caverns of Time",
		data = function(alt_data) return (alt_data.itemCounts and alt_data.itemCounts.keyOfTime and AltManager:CreateQuestString(alt_data.itemCounts.keyOfTime.total, 1, true)) or "-" end,
		group = "item",
	},
	elixirDemonslaying = {
		label = "Elixir of Demonslaying",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirDemonslaying, 9224) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirDemonslaying") end,
		group = "item",
	},
	brilliantWizardOil = {
		label = "Brilliant Wizard Oil",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.brilliantWizardOil, 20749) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "brilliantWizardOil") end,
		group = "item",
	},
	adamantiteSharpeningStone = {
		label = "Adamantite Sharpening Stone",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.adamantiteSharpeningStone, 23529) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "adamantiteSharpeningStone") end,
		group = "item",
	},
	flaskBlindingLight = {
		label = "Flask of Blinding Light",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.flaskBlindingLight, 22861) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "flaskBlindingLight") end,
		group = "item",
	},
	elixirAdept = {
		label = "Adept's Elixir",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirAdept, 28103) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirAdept") end,
		group = "item",
	},
	elixirDraenicWisdom = {
		label = "Elixir of Draenic Wisdom",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirDraenicWisdom, 32067) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirDraenicWisdom") end,
		group = "item",
	},
	flaskSupremePower = {
		label = "Flask of Supreme Power",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.flaskSupremePower, 13512) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "flaskSupremePower") end,
		group = "item",
	},
	potionSuperMana = {
		label = "Super Mana Potion",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.potionSuperMana, 22832) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "potionSuperMana") end,
		group = "item",
	},
	flaskChromaticWonder = {
		label = "Flask of Chromatic Wonder",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.flaskChromaticWonder, 33208) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "flaskChromaticWonder") end,
		group = "item",
	},
	elixirMajorAgility = {
		label = "Elixir of Major Agility",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirMajorAgility, 22831) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirMajorAgility") end,
		group = "item",
	},
	giftOfArthas = {
		label = "Gift of Arthas",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.giftOfArthas, 9088) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "giftOfArthas") end,
		group = "item",
	},
	spiritOfZanza = {
		label = "Spirit of Zanza",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.spiritOfZanza, 20079) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "spiritOfZanza") end,
		group = "item",
	},
	potionIronshield = {
		label = "Ironshield Potion",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.potionIronshield, 22849) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "potionIronshield") end,
		group = "item",
	},
	potionHaste = {
		label = "Haste Potion",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.potionHaste, 22838) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "potionHaste") end,
		group = "item",
	},
	potionFreeAction = {
		label = "Free Action Potion",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.potionFreeAction, 5634
			) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "potionFreeAction") end,
		group = "item",
	},
	adamantiteWeightstone = {
		label = "Adamantite Weightstone",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.adamantiteWeightstone, 28421) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "adamantiteWeightstone") end,
		group = "item",
	},
	elixirHealingPower = {
		label = "Elixir of Healing Power",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirHealingPower, 22825) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirHealingPower") end,
		group = "item",
	},
	superiorWizardOil = {
		label = "Superior Wizard Oil",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.superiorWizardOil, 22522) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "superiorWizardOil") end,
		group = "item",
	},
	elixirMajorMageblood = {
		label = "Elixir of Major Mageblood",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirMajorMageblood, 22840) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirMajorMageblood") end,
		group = "item",
	},
	flaskRelentlessAssault = {
		label = "Flask of Relentless Assault",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.flaskRelentlessAssault, 22854) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "flaskRelentlessAssault") end,
		group = "item",
	},
	flaskPureDeath = {
		label = "Flask of Pure Death",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.flaskPureDeath, 22866) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "flaskPureDeath") end,
		group = "item",
	},
	drumsBattle = {
		label = "Drums of Battle",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.drumsBattle, 29529) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "drumsBattle") end,
		group = "item",
	},
	potionDestruction = {
		label = "Destruction Potion",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.potionDestruction, 22839) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "potionDestruction") end,
		group = "item",
	},
	flaskFortification = {
		label = "Flask of Fortification",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.flaskFortification, 22851) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "flaskFortification") end,
		group = "item",
	},
	elixirMajorDefense = {
		label = "Elixir of Major Defense",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirMajorDefense, 22834) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirMajorDefense") end,
		group = "item",
	},
	elixirMajorShadowPower = {
		label = "Elixir of Major Defense",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirMajorShadowPower, 22835) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirMajorShadowPower") end,
		group = "item",
	},
	elixirEmpowerment = {
		label = "Elixir of Empowerment",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.elixirEmpowerment, 22848) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "elixirEmpowerment") end,
		group = "item",
	},
	swiftnessOfZanza = {
		label = "Swiftness of Zanza",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.swiftnessOfZanza, 20081) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "swiftnessOfZanza") end,
		group = "item",
	},
	thistleTea = {
		label = "Thistle Tea",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.thistleTea, 7676) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "thistleTea") end,
		group = "item",
	},
	flameCap = {
		label = "Flame Cap",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.flameCap, 22788) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "flameCap") end,
		group = "item",
	},
	superSapperCharge = {
		label = "Super Sapper Charge",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.superSapperCharge, 23827) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "superSapperCharge") end,
		group = "item",
	},
	runeDark = {
		label = "Dark Rune",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.runeDark, 20520) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "runeDark") end,
		group = "item",
	},
	runeDemonic = {
		label = "Demonic Rune",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.runeDemonic, 12662) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "runeDemonic") end,
		group = "item",
	},
	runeDark = {
		label = "Dark Rune",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.runeDark, 20520) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "runeDark") end,
		group = "item",
	},
	runeDark = {
		label = "Dark Rune",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.runeDark, 20520) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "runeDark") end,
		group = "item",
	},
	runeDark = {
		label = "Dark Rune",
		data = function(alt_data) return AltManager:CreateItemString(alt_data.itemCounts.runeDark, 20520) end,
		tooltip = function(button, alt_data) AltManager:ItemTooltip_OnEnter(button, alt_data, "runeDark") end,
		group = "item",
	},
}

AltManager.raids = {
	[GetRealZoneText(532)] = {instanceID = 532, englishName = "karazhan"},
	[GetRealZoneText(534)] = {instanceID = 534, englishName = "hyjal"},
	[GetRealZoneText(544)] = {instanceID = 544, englishName = "magtheridon"},
	[GetRealZoneText(548)] = {instanceID = 548, englishName = "serpentshrine"},
	[GetRealZoneText(550)] = {instanceID = 550, englishName = "tempestkeep"},
	[GetRealZoneText(564)] = {instanceID = 564, englishName = "blacktemple"},
	[GetRealZoneText(565)] = {instanceID = 565, englishName = "gruul"},
	[GetRealZoneText(580)] = {instanceID = 580, englishName = "sunwell"},
}

AltManager.numDungeons = 16
AltManager.dungeons = {
	[GetRealZoneText(269)] = 269, -- Opening of the Dark Portal
	[GetRealZoneText(540)] = 540, -- The Shattered Halls
	[GetRealZoneText(542)] = 542, -- The Blood Furnace
	[GetRealZoneText(543)] = 543, -- Ramparts
	[GetRealZoneText(545)] = 545, -- The Steamvault
	[GetRealZoneText(546)] = 546, -- The Underbog
	[GetRealZoneText(547)] = 547, -- The Slave Pens
	[GetRealZoneText(552)] = 552, -- The Arcatraz
	[GetRealZoneText(553)] = 553, -- The Botanica
	[GetRealZoneText(554)] = 554, -- The Mechanar
	[GetRealZoneText(555)] = 555, -- Shadow Labyrinth
	[GetRealZoneText(556)] = 556, -- Sethekk Halls
	[GetRealZoneText(557)] = 557, -- Mana Tombs
	[GetRealZoneText(558)] = 558, -- Auchenai Crypts
	[GetRealZoneText(560)] = 560, -- The Escape From Durnholde
	[GetRealZoneText(585)] = 585, -- Magister's Terrace
}

AltManager.items = {
	[24490] = {key = "mastersKey"}, -- Karazhan Key
	[28395] = {key = "shatteredHallsKey"}, -- Shattered Halls Key
	[30622] = {key = "citadelKey"}, -- Hellfire Citadel Key
	[30623] = {key = "reservoirKey"}, -- Reservoir Key
	[30633] = {key = "auchenaiKey"}, -- Auchenai Key
	[30634] = {key = "warpforgedKey"}, -- Warpforged Key
	[30635] = {key = "keyOfTime"}, -- Key of Time
	[31704] = {key = "tempestKey"}, -- Tempest Key

	[5634] = {key = "potionFreeAction"}, -- Free Action Potion
	[7676] = {key = "thistleTea"}, -- Thistle Tea
	[9088] = {key = "giftOfArthas"}, -- Gift of Arthas
	[9224] = {key = "elixirDemonslaying"}, -- Elixier of Demonslaying
	[12662] = {key = "runeDemonic"}, -- Demonic Rune
	[13512] = {key = "flaskSupremePower"}, -- Flask of Supreme Power
	[20079] = {key = "spiritOfZanza"}, -- Spirit of Zanza
	[20081] = {key = "swiftnessOfZanza"}, -- Swiftness of Zanza
	[20520] = {key = "runeDark"}, -- Dark Rune
	[20749] = {key = "brilliantWizardOil"}, -- Brilliant Wizard Oil
	[22522] = {key = "superiorWizardOil"}, -- Superior Wizard Oil
	[22788] = {key = "flameCap"}, -- Flame Cap
	[22825] = {key = "elixirHealingPower"}, -- Elixir of Healing Power
	[22831] = {key = "elixirMajorAgility"}, -- Elixir of Major Agility
	[22832] = {key = "potionSuperMana"}, -- Super Mana Potion
	[22834] = {key = "elixirMajorDefense"}, -- Elixir of Major Defense
	[22835] = {key = "elixirMajorShadowPower"}, -- Elixir of Major Shadow Power
	[22838] = {key = "potionHaste"}, -- Haste Potion
	[22839] = {key = "potionDestruction"}, -- Destruction Potion
	[22840] = {key = "elixirMajorMageblood"}, -- Elixir of Major Mageblood
	[22848] = {key = "elixirEmpowerment"}, -- Elixir of Empowerment
	[22849] = {key = "potionIronshield"}, -- Ironshield Potion
	[22851] = {key = "flaskFortification"}, -- Flask of Fortifications
	[22854] = {key = "flaskRelentlessAssault"}, -- Flask of Relentless Assault
	[22861] = {key = "flaskBlindingLight"}, -- Flask of Blinding Light
	[22866] = {key = "flaskPureDeath"}, -- Flask of Pure Death
	[23827] = {key = "superSapperCharge"}, -- Super Sapper Charge
	[29529] = {key = "drumsBattle"}, -- Drums of Battle
	[23529] = {key = "adamantiteSharpeningStone"}, -- Adamantite Sharpening Stone
	[28103] = {key = "elixirAdept"}, -- Adept's Elixir
	[28421] = {key = "adamantiteWeightstone"}, -- Adamantite Weightstone
	[32067] = {key = "elixirDraenicWisdom"}, -- Elixir of Draenic Wisdom
	[33208] = {key = "flaskChromaticWonder"}, -- Flask of Chromatic Wonder
}

AltManager.factions = {
	faction = {
		[911] = {name = "Silvermoon City", faction = "Horde"},
		[930] = {name = "Exodar", faction = "Alliance"},
		[932] = {name = "The Aldor"},
		[933] = {name = "The Consortium"},
		[934] = {name = "The Scryers"},
		[935] = {name = "The Sha'tar"},
		[941] = {name = "The Mag'har", faction = "Horde"},
		[942] = {name = "Cenarion Expedition"},
		[946] = {name = "Honor Hold", faction = "Alliance"},
		[947] = {name = "Thrallmar", faction = "Horde"},
		[967] = {name = "The Violet Eye"},
		[970] = {name = "Sporeggar"},
		[978] = {name = "Kurenai", faction = "Alliance"},
		[989] = {name = "Keepers of Time"},
		[990] = {name = "The Scale of the Sands"},
		[1011] = {name = "Lower City"},
		[1015] = {name = "Netherwing"},
		[1038] = {name = "Ogri'la"},
		[1077] = {name = "Shattered Sun Offensive"},
	}
}

AltManager.currencies = {
}

AltManager.professionCDs = {
	[L["Tailoring"]] = {
		cds = {
			[26751] = L["Primal Mooncloth"], -- Primal Mooncloth
			[31373] = L["Spellcloth"], -- Spellcloth
			[36686] = L["Shadowcloth"], -- Shadowcloth
		},
		icon = 136249,
		num = 3,
	},
	[L["Alchemy"]] = {
		cds = {
			[29688]  = L["Transmute"], -- Transmute: Primal Might
		},
		icon = 136240,
		num = 1,
	},
	[L["Leatherworking"]] = {
		cds = {
			[19566] = L["Salt Shaker"], -- Salt Shaker
		},
		icon = 133611,
		num = 1,
	},
	[L["Enchanting"]] = {
		cds = {
			[28027] = L["Void Sphere"], -- Void Sphere
		},
		icon = 136244,
		num = 1,
	},
	[L["Engineering"]] = {
		icon = 136243,
		num = 0,
	},
	[L["Blacksmithing"]] = {
		icon = 136241,
		num = 0,
	},
	[L["Herbalism"]] = {
		icon = 136246,
		num = 0,
	},
	[L["Mining"]] = {
		icon = 136248,
		num = 0,
	},
	[L["Skinning"]] = {
		icon = 134366,
		num = 0,
	},
	[L["Jewelcrafting"]] = {
		cds = {
			[47280] = L["Brilliant Glass"], -- Brilliant Glass
		},
		icon = 134071,
		num = 1,
	}
}



AltManager.quests = {
	daily = {
		[10110] = {key = "thrallmar", faction = "Horde"}, -- Hellfire Fortifications
		[10106] = {key = "honor_hold", faction = "Alliance"}, -- Hellfire Fortifications
		
		[11502] = {key = "halaa", faction = "Alliance"}, -- In Defense of Halaa
		[11503] = {key = "halaa", faction = "Horde"}, -- Enemies, Old and New

		[11505] = {key = "auchindoun", faction = "Alliance"}, -- Spirits of Auchindoun
		[11506] = {key = "auchindoun", faction = "Horde"}, -- Spirits of Auchindoun

		[11335] = {key = "call_to_arms", faction = "Alliance"}, -- Arathi Basin
		[11336] = {key = "call_to_arms", faction = "Alliance"}, -- Alterac Valley
		[11337] = {key = "call_to_arms", faction = "Alliance"}, -- Eye of the Storm
		[11338] = {key = "call_to_arms", faction = "Alliance"}, -- Warsong Gulch
		[11339] = {key = "call_to_arms", faction = "Horde"}, -- Arathi Basin
		[11340] = {key = "call_to_arms", faction = "Horde"}, -- Alterac Valley
		[11341] = {key = "call_to_arms", faction = "Horde"}, -- Eye of the Storm
		[11342] = {key = "call_to_arms", faction = "Horde"}, -- Warsong Gulch

		[11364] = {key = "dungeon_normal", unique = true}, -- The Shattered Halls
		[11371] = {key = "dungeon_normal", unique = true}, -- The Steamvault
		[11376] = {key = "dungeon_normal", unique = true}, -- Shadow Labyrinth
		[11383] = {key = "dungeon_normal", unique = true}, -- The Black Morass
		[11385] = {key = "dungeon_normal", unique = true}, -- The Botanica
		[11387] = {key = "dungeon_normal", unique = true}, -- The Mechanar
		[11389] = {key = "dungeon_normal", unique = true}, -- The Arcatraz
		[11500] = {key = "dungeon_normal", unique = true}, -- Magister's Terrace

		[11354] = {key = "dungeon_heroic", unique = true}, -- Hellfire Ramparts
		[11362] = {key = "dungeon_heroic", unique = true}, -- The Blood Furnace
		[11363] = {key = "dungeon_heroic", unique = true}, -- The Shattered Halls
		[11368] = {key = "dungeon_heroic", unique = true}, -- The Slave Pens
		[11369] = {key = "dungeon_heroic", unique = true}, -- The Underbog
		[11370] = {key = "dungeon_heroic", unique = true}, -- The Steamvault
		[11372] = {key = "dungeon_heroic", unique = true}, -- Sethekk Halls
		[11373] = {key = "dungeon_heroic", unique = true}, -- Mana-Tombs
		[11374] = {key = "dungeon_heroic", unique = true}, -- Auchenai Crypts
		[11375] = {key = "dungeon_heroic", unique = true}, -- Shadow Labyrinth
		[11378] = {key = "dungeon_heroic", unique = true}, -- The Escape From Durnholde
		[11382] = {key = "dungeon_heroic", unique = true}, -- The Black Morass
		[11384] = {key = "dungeon_heroic", unique = true}, -- The Botanica
		[11386] = {key = "dungeon_heroic", unique = true}, -- The Mechanar
		[11388] = {key = "dungeon_heroic", unique = true}, -- The Arcatraz

		[11377] = {key = "cooking"}, -- Revenge is Tasty
		[11379] = {key = "cooking"}, -- Super Hot Stew
		[11380] = {key = "cooking"}, -- Manalicious
		[11381] = {key = "cooking"}, -- Soup for the Soul

		[11665] = {key = "fishing"}, -- Crocolisks in the City
		[11666] = {key = "fishing"}, -- Bait Bandits
		[11667] = {key = "fishing"}, -- The One That Got Away
		[11668] = {key = "fishing"}, -- Shrimpin' Ain't Easy
		[11669] = {key = "fishing"}, -- Felblood Fillet

		[11015] = {key = "netherwing"}, -- Netherwing Crystals
		[11016] = {key = "netherwing"}, -- Nethermine Flayer Hide
		[11017] = {key = "netherwing"}, -- Netherdust Pollen
		[11018] = {key = "netherwing"}, -- Nethercite Ore
		[11020] = {key = "netherwing"}, -- A Slow Death
		[11035] = {key = "netherwing"}, -- The Not-So-Friendly Skies...
		[11055] = {key = "netherwing"}, -- The Booterang: A Cure For The Common Worthless Peon
		[11076] = {key = "netherwing"}, -- Picking Up The Pieces...
		[11077] = {key = "netherwing"}, -- Dragons are the Least of Our Problems
		[11086] = {key = "netherwing"}, -- Disrupting the Twilight Portal
		[11097] = {key = "netherwing"}, -- The Deadliest Trap Ever Laid (Scryer)
		[11101] = {key = "netherwing"}, -- The Deadliest Trap Ever Laid (Aldor)

		[11008] = {key = "shatari"}, -- Fires Over Skettis
		[11085] = {key = "shatari"}, -- Escape from Skettis

		[11051] = {key = "ogrila"}, -- Banish More Demons
		[11080] = {key = "ogrila"}, -- The Relic's Emanation

		[11023] = {key = "shatariogrila"}, -- Bomb Them Again
		[11066] = {key = "shatariogrila"}, -- Wrangle More 
	},
	attunements = {
		[13431] = {key = "serpentshrine"},
		[10445] = {key = "hyjal"},
		[10277] = {key = "hillsbrad"},
		[10285] = {key = "blackmorass"},
	}
}

function AltManager:getDefaultCategories(key)
	return key and default_categories[key] or default_categories
end