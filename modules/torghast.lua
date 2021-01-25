local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateTorghast()
	local char_table = self.validateData()
	if not char_table then return end
	local widgetSetInfo = C_UIWidgetManager.GetAllWidgetsBySetID(399)

	local torghastNames = {}
	local torghastInfo = {}
	if not widgetSetInfo then return end
	for i, uiWidetInfo in ipairs(widgetSetInfo) do
		local widgetInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(uiWidetInfo.widgetID)
		if widgetInfo and widgetInfo.shownState == 1 then
			if widgetInfo.orderIndex%2 == 0 then
				torghastNames[widgetInfo.orderIndex + 1] = widgetInfo.text:gsub("\124n", "")
			elseif torghastNames[widgetInfo.orderIndex] then
				torghastInfo[torghastNames[widgetInfo.orderIndex]] = widgetInfo.text:match("(%d)%)") or widgetInfo.text
			end
		end
	end

	char_table.torghastInfo = torghastInfo
end

function AltManager:CreateTorghastString(torghastInfo)
	if not torghastInfo then return end

	local torghastString
	for wingName, completedLayer in pairs(torghastInfo) do
		torghastString = string.format("%s%d",  torghastString and (torghastString .. " - ") or "", completedLayer)
	end

	return torghastString
end

function AltManager:TorghastTooltip_OnEnter(button, alt_data)
	if not alt_data or not alt_data.torghastInfo then return end

	local info = alt_data.torghastInfo
	local tooltip = LibQTip:Acquire(addonName .. "Tooltip", 3, "LEFT", "CENTER", "RIGHT")
	button.tooltip = tooltip

	tooltip:AddHeader('Wing', '', 'Layer')
	tooltip:AddLine("")
	for wingName, completedLayer in pairs(info) do
		tooltip:AddLine(wingName, "   ", completedLayer)
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end