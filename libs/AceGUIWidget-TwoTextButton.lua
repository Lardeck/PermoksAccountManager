--[[-----------------------------------------------------------------------------
Button Widget
Graphical Button.
-------------------------------------------------------------------------------]]
local Type, Version = "TwoTextButton", 24
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent


local normalFont = CreateFont("PAM_TwoTextButtonFont")
normalFont:SetFont("Fonts\\FRIZQT__.TTF", 12)
normalFont:SetTextColor(1, 1, 1, 1)
--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame, ...)
	AceGUI:ClearFocus()
	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	frame.obj:Fire("OnClick", ...)
end

local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(24)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetAutoWidth(false)
		self:SetLeftText()
		self:SetRightText()
	end,

	-- ["OnRelease"] = nil,

	["SetLeftText"] = function(self, text)
		self.text1:SetText(text)
	end,

	["SetRightText"] = function(self, text)
		self.text2:SetText(text)
	end,

	["SetAutoWidth"] = function(self, autoWidth)
		self.autoWidth = autoWidth
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
		else
			self.frame:Enable()
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AceGUI30TwoTextButton" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, UIParent)
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnClick", Button_OnClick)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)

	local texture = frame:CreateTexture()
	texture:SetAllPoints()

	local text1 = frame:CreateFontString()
	text1:SetFontObject(normalFont)
	text1:ClearAllPoints()
	text1:SetPoint("LEFT", 15, -1)
	text1:SetJustifyV("MIDDLE")

	local text2 = frame:CreateFontString()
	text2:SetFontObject(normalFont)
	text2:ClearAllPoints()
	text2:SetPoint("RIGHT", -15, -1)
	text2:SetJustifyV("MIDDLE")

	local widget = {
		text1 = text1,
		text2 = text2,
		texture = texture,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
