local addonName, AltManager = ...
local locale = GetLocale()
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")


AltManager.columns_table_test2 = {
	general = {
		name = "General",
		args = {
			character_name = {
				hidden = true, 
				name = "Name",
				data = function(alt_data) return alt_data.name end,
				color = function(alt_data) return RAID_CLASS_COLORS[alt_data.class] end,
			},
			ilevel = {
				hidden = true,
				data = function(alt_data) return string.format("%.2f", alt_data.ileve or 0) end,
				justify = "TOP",
				font = "Fonts\\FRIZQT__.TTF",
			},
			gold = {
				group = true,
				toggle = true,
				name = "Gold",
				args = {

				}
			},

		}
	}
}


function AltManager:CreateOptions()
	local CreateOptionsRecursive = function(options, args)
		local i = 0
		for category, infos in pairs(args) do
			i = i + 0.1
			if infos.toggle then
				options[category .. "_toggle"] = {
					name = infos.name,
					type = "toggle"
				}
			end

			if infos.group then
				options[category .. "_group"] = {
					order = i + 0.05,
					name = infos.name,
					type = "group",
					args = {}
				}

				CreateOptionsRecursive(options[category .. "_group"], infos.args)
			end
		end
	end

	local options = {
		type = "group",
		name = addonName,
		get  = function(info) 
			if #info > 1 then
				return AltManager.db.global.options[info[#info-1]][info[#info]].enabled
			else
				return AltManager.db.global.options[info[#info]].enabled
			end
		end,
		set = function(info, val)
			if #info > 1 then
				AltManager.db.global.options[info[#info-1]][info[#info]].enabled = val
			else
				AltManager.db.global.options[info[#info]].enabled = val
			end
		end,
		args = {

		}
	}

	CreateOptionsRecursive(options)
end

local function test_new_options()
	AceConfigDialog:Open(addonName)

	for column_iden, column in AltManager.spairs(AltManager.columns_table_test.args, function(t, a, b) return t[a].order < t[b].order end) do
	end
end

AceConfigRegistry:RegisterOptionsTable(addonName, AltManager.columns_table_test, true)
AltManager:RegisterChatCommand('abcdefg', test_new_options)