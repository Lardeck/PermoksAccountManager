local addonName, AltManager = ...
local LibQTip = LibStub("LibQTip-1.0")

function AltManager:UpdateTorghast()
	local char_table = self.validateData()
	if not char_table then return end
	local widgetSetInfo = C_UIWidgetManager.GetAllWidgetsBySetID(399)

	local torghastNames = {}
	local torghastInfo = char_table.torghastInfo or {}
	if not widgetSetInfo then return end
	for i, uiWidetInfo in ipairs(widgetSetInfo) do
		local widgetInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(uiWidetInfo.widgetID)
		if widgetInfo and widgetInfo.shownState == 1 then
			if widgetInfo.orderIndex%2 == 0 then
				torghastNames[widgetInfo.orderIndex + 1] = widgetInfo.text:gsub("\124n", "")
			elseif torghastNames[widgetInfo.orderIndex] then
				local layer = tonumber(widgetInfo.text:match("(%d)%)"))
				local prevLayer = char_table.torghastInfo and tonumber(char_table.torghastInfo[torghastNames[widgetInfo.orderIndex]])
				torghastInfo[torghastNames[widgetInfo.orderIndex]] = prevLayer or 0

				if layer and layer > torghastInfo[torghastNames[widgetInfo.orderIndex]] then
					torghastInfo[torghastNames[widgetInfo.orderIndex]] = layer
				end
			end
		end
	end

	char_table.torghastInfo = torghastInfo
	char_table.torghastInfo["PLEASE"] = nil
	char_table.torghastInfo["LOGIN"] = nil
end

function AltManager:CreateTorghastString(torghastInfo)
	if not torghastInfo then return end

	local torghastString
	for wingName, completedLayer in pairs(torghastInfo) do
		local color = completedLayer and completedLayer == 8 and "00ff00" or "ff000"
		torghastString = string.format("%s|cff%s%d|r",  torghastString and (torghastString .. " - ") or "", color, completedLayer)
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