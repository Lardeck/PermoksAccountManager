local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local module = 'torghast'
local labelRows = {
    torghast_layer = {
        label = L['Torghast'],
        tooltip = true,
        customTooltip = function(button, alt_data)
            PermoksAccountManager:TorghastTooltip_OnEnter(button, alt_data)
        end,
        type = 'torghast',
        isComplete = function(alt_data)
            return alt_data.torghastInfo and PermoksAccountManager:CompletedTorghastLayers(alt_data.torghastInfo)
        end,
        group = 'torghast'
    }
}

local function UpdateTorghast(charInfo)
    -- Should probably switch to quests at some point
    charInfo.torghastInfo = charInfo.torghastInfo or {}

    local widgetSetInfo = C_UIWidgetManager.GetAllWidgetsBySetID(399)
    if not widgetSetInfo then
        return
    end

    local torghastNames = {}
    local torghastInfo = charInfo.torghastInfo
    for i, uiWidetInfo in ipairs(widgetSetInfo) do
        local widgetInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(uiWidetInfo.widgetID)
        if widgetInfo and widgetInfo.shownState == 1 then
            if widgetInfo.orderIndex % 2 == 0 then
                torghastNames[widgetInfo.orderIndex + 1] = widgetInfo.text:gsub('\124n', '')
            elseif torghastNames[widgetInfo.orderIndex] then
                local layer = tonumber(widgetInfo.text:match('(%d+)%)'))
                local prevLayer = charInfo.torghastInfo and tonumber(charInfo.torghastInfo[torghastNames[widgetInfo.orderIndex]])
                torghastInfo[torghastNames[widgetInfo.orderIndex]] = prevLayer or 0

                if layer and layer > torghastInfo[torghastNames[widgetInfo.orderIndex]] then
                    torghastInfo[torghastNames[widgetInfo.orderIndex]] = layer
                end
            end
        end
    end
end



local function CreateTorghastString(torghastInfo)
    if not torghastInfo then
        return
    end

    local torghastString
    for _, completedLayer in pairs(torghastInfo) do
        local color = completedLayer and completedLayer == 16 and '00ff00' or 'ff0000'
        torghastString = string.format('%s|cff%s%d|r', torghastString and (torghastString .. ' - ') or '', color, completedLayer)
    end

    return torghastString
end



local function Update(charInfo)
    UpdateTorghast(charInfo)
end

local payload = {
    update = Update,
    labels = labelRows,
    events = {
        ['CURRENCY_DISPLAY_UPDATE'] = UpdateTorghast
    },
    share = {
        [UpdateTorghast] = 'torghastInfo'
    }
}
local module = PermoksAccountManager:AddModule(module, payload)
module:AddCustomLabelType('torghast', CreateTorghastString, nil, 'torghastInfo')

function PermoksAccountManager:CompletedTorghastLayers(torghastInfo)
    if not torghastInfo then
        return
    end

    local completedLayerTotal = 0
    for _, completedLayer in pairs(torghastInfo) do
        completedLayerTotal = completedLayerTotal + completedLayer
    end

    return completedLayerTotal == 32
end

function PermoksAccountManager:TorghastTooltip_OnEnter(button, alt_data)
    if not alt_data or not alt_data.torghastInfo then
        return
    end

    local info = alt_data.torghastInfo
    local tooltip = LibQTip:Acquire(addonName .. 'Tooltip', 3, 'LEFT', 'CENTER', 'RIGHT')
    button.tooltip = tooltip

    tooltip:AddHeader('Wing', '', 'Layer')
    tooltip:AddLine('')
    for wingName, completedLayer in pairs(info) do
        tooltip:AddLine(wingName, '   ', completedLayer)
    end

    tooltip:SmartAnchorTo(button)
    tooltip:Show()
end
