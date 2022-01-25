local addonName, PermoksAccountManager = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local default_categories = {
	general = {
		order = 0,
		name = "General",
		childs = {"characterName", "characterLevel", "gold", "location", "profession1CDs", "profession2CDs", "honorBCC", "arenaPoints", "dailyQuestCounter"},
		childOrder = {characterName = 1, characterLevel = 2, gold = 3, location = 4, profession1CDs = 5, profession2CDs = 6, honorBCC = 7, arenaPoints = 8, dailyQuestCounter = 9},
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
		"separator3", "hyjal", "blacktemple", "separator4", "zulaman", "separator5", "sunwell"},
		childOrder = {heroicsDone = 1, separator1 = 2, karazhan = 3, magtheridon = 4, gruul = 5, separator2 = 6, serpentshrine = 7, tempestkeep = 8,
		separator3 = 9, hyjal = 10, blacktemple = 11, separator4 = 12, zulaman = 13, separator5 = 14, sunwell = 15},
		enabled = true,
	},
	attunements = {
		order = 5,
		name = "Attunements",
		childs = {"hillsbradAttunement", "blackmorassAttunement", "shatteredHallsKey", "arcatrazKey", "separator1", "citadelKey", "reservoirKey", "auchenaiKey", "warpforgedKey", "keyOfTime", "separator2", "karazhanAttunement", "serpentshrineAttunement", "theEyeAttunement", "hyjalSummitAttunement" , "blackTempleAttunement"},
		childOrder = {hillsbradAttunement = 1, blackmorassAttunement = 2, shatteredHallsKey = 3, arcatrazKey = 4, separator1 = 5, citadelKey = 6, reservoirKey = 7, auchenaiKey = 8, warpforgedKey = 9, keyOfTime = 10, separator2 = 11, karazhanAttunement = 12, serpentshrineAttunement = 13, theEyeAttunement = 14, hyjalSummitAttunement = 15, blackTempleAttunement = 16},
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

PermoksAccountManager.groups = {
	attunement = {
		label = L["Attunements"],
    order = 3,
	},
  character = {
		label = L["Character"],
		order = 2,
	},
	currency = {
		label = L["Currency"],
    order = 4,
	},
	resetDaily = {
		label = L["Daily Reset"],
    order = 5,
	},
	resetWeekly = {
		label = L["Weekly Reset"],
    order = 6,
	},
	dungeons = {
		label = L["Dungeons"],
    order = 7,
	},
	raids = {
		label = L["Raids"],
    order = 8,
	},
	reputation = {
		label = L["Reputation"],
    order = 9,
	},
	buff = {
		label = L["Buff"],
    order = 10,
	},
	separator = {
		label = L["Separator"],
    order = 1,
	},
	item = {
		label = L["Items"],
    order = 11,
	},
	extra = {
		label = L["Extra"],
    order = 12,
	},
	profession = {
		label = L["Professions"],
    order = 13,
	},
  other = {
		label = L["Other"],
    order = 14,
	}
}

PermoksAccountManager.labelRows = {
	separator1 = {
		hideLabel = true,
		label = "Separator1",
		data = function() return "" end,
		group = "separator",
	},
	separator2 = {
		hideLabel = true,
		label = "Separator2",
		data = function() return "" end,
		group = "separator",
	},
	separator3 = {
		hideLabel = true,
		label = "Separator3",
		data = function() return "" end,
		group = "separator",
	},
	separator4 = {
		hideLabel = true,
		label = "Separator4",
		data = function() return "" end,
		group = "separator",
	},
	separator5 = {
		hideLabel = true,
		label = "Separator5",
		data = function() return "" end,
		group = "separator",
	},
	separator6 = {
		hideLabel = true,
		label = "Separator6",
		data = function() return "" end,
		group = "separator",
	},
}

PermoksAccountManager.raids = {
	[GetRealZoneText(532)] = {instanceID = 532, englishName = "karazhan"},
	[GetRealZoneText(534)] = {instanceID = 534, englishName = "hyjal"},
	[GetRealZoneText(544)] = {instanceID = 544, englishName = "magtheridon"},
	[GetRealZoneText(548)] = {instanceID = 548, englishName = "serpentshrine"},
	[GetRealZoneText(550)] = {instanceID = 550, englishName = "tempestkeep"},
	[GetRealZoneText(564)] = {instanceID = 564, englishName = "blacktemple"},
	[GetRealZoneText(565)] = {instanceID = 565, englishName = "gruul"},
	[GetRealZoneText(568)] = {instanceID = 580, englishName = "zulaman"},
	[GetRealZoneText(580)] = {instanceID = 580, englishName = "sunwell"},
}

PermoksAccountManager.numDungeons = 16
PermoksAccountManager.dungeons = {
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

PermoksAccountManager.item = {
	[24490] = {key = "mastersKey"}, -- Karazhan Key
	[28395] = {key = "shatteredHallsKey"}, -- Shattered Halls Key
	[31084] = {key = "arcatrazKey"}, -- Shattered Halls Key
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

PermoksAccountManager.faction = {
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

PermoksAccountManager.currency = {
  [1900] = 0,
  [1901] = 0,
}

PermoksAccountManager.professionCDs = {
	[L["Tailoring"]] = {
		cds = {
			[26751] = L["Primal Mooncloth"], -- Primal Mooncloth
			[31373] = L["Spellcloth"], -- Spellcloth
			[36686] = L["Shadowcloth"], -- Shadowcloth
		},
		items = {
			[26751] = 21845,
			[31373] = 24271,
			[36686] = 24272,
		},
		icon = 136249,
		num = 3,
	},
	[L["Alchemy"]] = {
		cds = {
			[29688]  = L["Transmute"], -- Transmute: Primal Might
		},
		items = {
			[29688] = 23571,
		},
		icon = 136240,
		num = 1,
	},
	[L["Leatherworking"]] = {
		cds = {
			[19566] = L["Salt Shaker"], -- Salt Shaker
		},
		items = {
			[19566] = 15846,
		},
		icon = 133611,
		num = 1,
	},
	[L["Enchanting"]] = {
		cds = {
			[28027] = L["Void Sphere"], -- Void Sphere
		},
		items = {
			[28027] = 22459,
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
		items = {
			[47280] = 35945,
		},
		icon = 134071,
		num = 1,
	}
}
-- TODO: change structure
PermoksAccountManager.quest = {
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
		[10901] = {key = "serpentshrine"},
		[10445] = {key = "hyjal"},
    [10985] = {key = "blacktemple"},
		[10277] = {key = "hillsbrad"},
		[10285] = {key = "blackmorass"},
	}
}

function PermoksAccountManager:getDefaultCategories(key)
  return key and default_categories[key] or default_categories
end

PermoksAccountManager.ICONSTRINGS = {
	left = "\124T%d:18:18\124t %s",
	right = "%s \124T%d:18:18\124t",
	leftBank = "\124T%d:18:18\124t %s (%s)",
	rightBank = "%s (%s) \124T%d:18:18\124t",
}