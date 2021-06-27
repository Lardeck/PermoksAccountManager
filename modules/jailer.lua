local addonName, AltManager = ...

function AltManager:UpdateJailerInfo(widgetInfo)
	if not widgetInfo or not self.jailerWidgets[widgetInfo.widgetID] then return end
	local char_table = self.validateData()
	if not char_table then return end

	local widgetInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo(widgetInfo.widgetID)

	if widgetInfo and widgetInfo.shownState == 1 then
		local barValue, barMin, barMax = widgetInfo.progressVal, widgetInfo.progressMin, widgetInfo.progressMax
   		local stage = floor(barValue/1000)

		char_table.jailerInfo = {stage = stage, threat = barValue - (stage*1000)}
	end	
end

function AltManager:CreateJailerString(jailerInfo)
	if not jailerInfo then return end

	return string.format("Stage %d - %d", jailerInfo.stage, jailerInfo.stage == 5 and 1000 or jailerInfo.threat)
end

do
	local jailerEvents = {
		"UPDATE_UI_WIDGET",
	}

	local jailerFrame = CreateFrame("Frame")
	FrameUtil.RegisterFrameForEvents(jailerFrame, jailerEvents)

	jailerFrame:SetScript("OnEvent", function(e, widgetInfo)
		if AltManager.addon_loaded then
			AltManager:UpdateJailerInfo(widgetInfo)
			AltManager:UpdateCompletionDataForCharacter()
			AltManager:SendCharacterUpdate("jailerInfo")
		end
	end)
end