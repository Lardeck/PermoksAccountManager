local addonName, PermoksAccountManager = ...
local LibQTip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

do
	local module = "zone"
	local function functionOnLoad()
		local zoneEvents = {
			"ZONE_CHANGED",
			"ZONE_CHANGED_NEW_AREA",
			"ZONE_CHANGED_INDOORS",
		}

		local zoneFrame = CreateFrame("Frame")
		FrameUtil.RegisterFrameForEvents(zoneFrame, zoneEvents)

		zoneFrame:SetScript("OnEvent", function(self, e, ...)
			PermoksAccountManager:UpdateLocation()
			PermoksAccountManager:SendCharacterUpdate("location")
		end)
	end
	PermoksAccountManager:AddModule(module, functionOnLoad)
end

function PermoksAccountManager:UpdateLocation()
	local charInfo = self.charInfo
	if not charInfo then return end
	
	charInfo.location = C_Map.GetBestMapForUnit("player")
end

function PermoksAccountManager:CreateLocationString(mapId)
	if not mapId then return end
	local mapInfo = C_Map.GetMapInfo(mapId)
	return mapInfo and mapInfo.name
end