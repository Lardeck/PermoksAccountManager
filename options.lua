local addonName, AltManager = ...

local function CreateOptionsMenu(frame, panel, unroll)
	local title = panel.title or frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	panel.title = title
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(panel.name)

    local rows = AltManager.columns_table[unroll].rows

    local enableButton = panel["enableButton"] or CreateFrame("CheckButton", nil, frame, "InterfaceOptionsCheckButtonTemplate")
    panel["enableButton"] = enableButton
    enableButton:RegisterForClicks("LeftButtonUp")
    enableButton:SetChecked(AltManager.db.global.options[unroll].enabled)
    enableButton:SetScript("OnClick", function(button) AltManager.db.global.options[unroll].enabled = button:GetChecked() end)
    enableButton:SetPoint("TOPLEFT", title, "TOPLEFT", 0, -25)
    enableButton.Text:SetText("Show Button (Requires Reload)")

    local numFrames = 0
    for row_identifier, row in AltManager.spairs(rows, function(t, a, b) return t[a].order < t[b].order end) do
    	if row.label then
	    	local rowOption = panel[row_identifier] or CreateFrame("CheckButton", nil, frame, "InterfaceOptionsCheckButtonTemplate")
	    	panel[row_identifier] = rowOption
	    	rowOption:RegisterForClicks("LeftButtonUp")
	    	rowOption:SetChecked(AltManager.db.global.options[unroll][row_identifier].enabled)
	    	rowOption:SetScript("OnClick", function(button)	AltManager.db.global.options[unroll][row_identifier].enabled = button:GetChecked() end)

	    	local numColumn = numFrames % 3
	    	local numRow = floor(numFrames/3) + 1
	    	rowOption:SetPoint("TOPLEFT", enableButton, "TOPLEFT", (numColumn * 150), numRow * (-25))
	    	rowOption.Text:SetText(row.label)
	    	numFrames = numFrames + 1
	    end
    end
end

function AltManager:CreateOptions(name, unroll)
    local childPanel = self[name .. "Panel"] or CreateFrame("Frame", addonName .. name .. "ConfigFrame", self.panel)
    self[name .. "Panel"] = childPanel
    childPanel.name = name
    childPanel.parent = self.panel.name
    childPanel:SetScript("OnShow", function(frame) CreateOptionsMenu(frame, childPanel, unroll) end)
    childPanel:Hide()

    InterfaceOptions_AddCategory(childPanel)
end