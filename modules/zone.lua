local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateLocation()
	local char_table = self.validateData()
	if not char_table then return end
	
	char_table.location = C_Map.GetBestMapForUnit("player")
end

function AltManager:CreateLocationString(mapId)
	if not mapId then return end
	local mapInfo = C_Map.GetMapInfo(mapId)
	return mapInfo and mapInfo.name
end

do
	local zoneEvents = {
		"ZONE_CHANGED",
		"ZONE_CHANGED_NEW_AREA",
		"ZONE_CHANGED_INDOORS",
	}

	local zoneFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(zoneFrame, zoneEvents)

	zoneFrame:SetScript("OnEvent", function(self, e, ...)
		if AltManager.addon_loaded then
			AltManager:UpdateLocation()
			AltManager:SendCharacterUpdate("location")
		end
	end)
end