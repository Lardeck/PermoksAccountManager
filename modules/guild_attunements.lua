local addonName, AltManager = ...


local LibQTip = LibStub("LibQTip-1.0")
local AceGUI = LibStub("AceGUI-3.0")


local lastTimeUpdate = GetTime()
local prefix = "MAM_ATTUNEMENTS"
local defaultCategories


local function GetAttunementInfoForData(altData)
	if not altData then return end

	local attunementKeys = AltManager:getDefaultCategories("attunements").childs
	local attunements = {}
	for i, attunement in ipairs(attunementKeys) do
		attunements[attunement] = AltManager.columns[attunement].data(altData)
	end

	return attunements
end


local function UpdateOwnAttunementInfo()
	local guildInfo = AltManager.db.global.guildInfo[AltManager.currentGuild]

	for altGUID, altData in pairs(AltManager.account.data) do
		if altData.guildRank and guildInfo[altData.guildRank] and guildInfo[altData.guildRank].player[altGUID] then
			guildInfo[altData.guildRank].player[altGUID].attunements = GetAttunementInfoForData(altData)
		end
	end
end


local function GetRankTree()
	local tree = {}

	for rankIndex = 0, #AltManager.db.global.guildInfo[AltManager.currentGuild] do
		local rankInfo = AltManager.db.global.guildInfo[AltManager.currentGuild][rankIndex]
		if rankInfo then
			tinsert(tree, {value = rankIndex, text = rankInfo.rankName, children = {}})
			for guid, playerInfo in pairs(rankInfo.player) do
				local text = WrapTextInColorCode(playerInfo.name, playerInfo.completed and "ff00ff00" or "ffff0000")
				tinsert(tree[#tree].children, {value = guid, text = text})
			end
		end
	end

	return tree
end


local function CreateAttunementFrame()
	local attunementFrame = AceGUI:Create("SimpleGroup")
	AltManager.guildAttunementFrame = attunementFrame
	attunementFrame.frame:EnableMouse(true)
	attunementFrame.frame:SetMovable(true)
	attunementFrame:SetWidth(450)
	attunementFrame:SetHeight(350)
	attunementFrame:SetLayout("Fill")
	attunementFrame:SetPoint("CENTER")

	local titleBackground = attunementFrame.frame:CreateTexture()
	titleBackground:SetColorTexture(0.1, 0.1, 0.1, 0.5)
	titleBackground:SetPoint("BOTTOM", attunementFrame.frame, "TOP", 0, 0)
	titleBackground:SetSize(attunementFrame.frame:GetWidth(), 30)

	local title = CreateFrame("Frame", nil, attunementFrame.frame, "BackdropTemplate")
	title:EnableMouse(true)
	title:SetScript("OnMouseDown", function() attunementFrame.frame:StartMoving() end)
	title:SetScript("OnMouseUp", function() attunementFrame.frame:StopMovingOrSizing() end)
	title:SetAllPoints(titleBackground)
	title:SetBackdrop(BACKDROP_TOOLTIP_8_8_1111)

	local titleText = title:CreateFontString(nil, "OVERLAY", "SystemFont_Large")
	titleText:SetPoint("TOP", title, "TOP", 0, -7)
	titleText:SetText("Guild Attunements")

	local closebutton = CreateFrame("Button", nil, title, "UIPanelCloseButton")
	closebutton:SetPoint("TOPRIGHT", title, "TOPRIGHT", 0, 1)
	closebutton:SetScript("OnClick", function() attunementFrame.frame:Hide() end)

	local rankTree = AceGUI:Create("TreeGroup")
	rankTree:SetFullHeight(true)
	rankTree:SetLayout("Flow")
	rankTree:SetTree(GetRankTree())
	rankTree.treeframe:SetResizable(false)
	rankTree.dragger:Hide()
	rankTree.treeframe:SetWidth(140)
	attunementFrame:AddChild(rankTree)
	attunementFrame.tree = rankTree

	rankTree:SetCallback("OnGroupSelected", function(container, a, selected)
		container:ReleaseChildren()

		local rankIndex, guid = strsplit("\001", selected)
		if guid then
			AltManager:DrawPlayerGroup(container, rankIndex, guid)
		end
	end)

	local updateGuildButton = CreateFrame("Button", nil, rankTree.content, "UIPanelButtonTemplate")
	updateGuildButton:SetPoint("BOTTOMLEFT", rankTree.content, "BOTTOMLEFT", 5, 5)
	updateGuildButton:SetSize(140, 25)
	updateGuildButton:SetText("Update Guild")
	updateGuildButton:SetScript("OnClick", function() AltManager:UpdateGuildRoster() end)

	local requestGuildButton = CreateFrame("Button", nil, rankTree.content, "UIPanelButtonTemplate")
	requestGuildButton:SetPoint("BOTTOMRIGHT", rankTree.content, "BOTTOMRIGHT", -5, 5)
	requestGuildButton:SetSize(140, 25)
	requestGuildButton:SetText("Update Attunements")
	requestGuildButton:SetScript("OnClick", function() AltManager:RequestData(prefix, "GUILD") end)
end


function AltManager:DrawPlayerGroup(group, rankIndex, guid)
	local playerInfo = self.db.global.guildInfo[self.currentGuild][tonumber(rankIndex)].player[guid]
	if not playerInfo then return end

    local groupScrollContainer = AceGUI:Create("SimpleGroup")
    groupScrollContainer:SetFullWidth(true)
    groupScrollContainer:SetFullHeight(true)
    groupScrollContainer:SetLayout("Fill")
    group:AddChild(groupScrollContainer)
 
    local groupScrollFrame = AceGUI:Create("ScrollFrame")
    groupScrollFrame:SetFullWidth(true)
    groupScrollFrame:SetLayout("List")
    groupScrollContainer:AddChild(groupScrollFrame)

    local index = 0
    for attunement, completion in self.spairs(playerInfo.attunements, function(t, a, b) return defaultCategories.attunements.childOrder[a] < defaultCategories.attunements.childOrder[b] end) do
    	if self.columns[attunement].label then
	    	local button = AceGUI:Create("TwoTextButton")
	    	button:SetLeftText(self.columns[attunement].label)
	    	button:SetRightText(completion)
	    	button:SetWidth(groupScrollFrame.frame:GetWidth())


	    	local color = (0.25 * (index % 2)) + 0.25
			button.texture:SetColorTexture(color, color, color, 0.65)
	    	groupScrollFrame:AddChild(button)
	    	index = index + 1
	    end
    end
end


function AltManager:ShowGuildAttunements()
	if not AltManager.guildAttunementFrame then
		CreateAttunementFrame()
	elseif not AltManager.guildAttunementFrame.frame:IsShown() then
		AltManager.guildAttunementFrame.frame:Show()
		AltManager.guildAttunementFrame.tree:SetTree(GetRankTree())
	end

end


function AltManager:ProcessAttunementMessage(msg)
	if msg == "request" then
		local guid = self:getGUID()
		local altData = self.account.data[guid]
		local attunements = GetAttunementInfoForData(altData)

		if attunements then
			local guildName, _, rankIndex = GetGuildInfo("player")
			local message = {guid, guildName, rankIndex, attunements}
			self:SendInfo(guildName, prefix, message, "GUILD")
		end
	else
		if not self.db.global.guildInfo then self:UpdateGuildRoster() return end
		local playerInfo = self:Deserialze(msg)
		if playerInfo then
			local guid, guildName, rankIndex, attunements = unpack(playerInfo)
			if not self.db.global.guildInfo[guildName] then return end
			local guildInfo = self.db.global.guildInfo[guildName]

			rankIndex = tonumber(rankIndex)
			if not guildInfo[rankIndex] or not guildInfo[rankIndex].player[guid] then return end
			guildInfo[rankIndex].player[guid].attunements = attunements
		end
	end
end


function AltManager:UpdateGuildRoster(firstUpdate)
	if not firstUpdate and GetTime() - lastTimeUpdate < 10 then return end

	local guildName = GetGuildInfo("player")
	if not guildName then return end
	self.currentGuild = guildName
	self.db.global.guildInfo = self.db.global.guildInfo or {}
	self.db.global.guildInfo[guildName] = self.db.global.guildInfo[guildName] or {}
	local guildInfo = self.db.global.guildInfo[guildName]

	for index = 1, GetNumGuildMembers() do
		local name, rankName, rankIndex, level, classDisplayName, _, _, _, _, _, class, _, _, _, _, _, GUID = GetGuildRosterInfo(index)
		if level == 70 then
			guildInfo[rankIndex] = guildInfo[rankIndex] or {rankName = rankName, player = {}, numPlayers = 0}

			if not guildInfo[rankIndex].player[GUID] then
				guildInfo[rankIndex].numPlayers = guildInfo[rankIndex].numPlayers + 1
				guildInfo[rankIndex].player[GUID] = {class = class, name = Ambiguate(name, "guild"), guid = GUID, attunements = {}}
			end

			if self.account.data[GUID] then
				self.account.data[GUID].guildRank = rankIndex
			end
		end
	end

	if #guildInfo == 0 then
		C_Timer.After(1, function() AltManager:UpdateGuildRoster() end)
		return
	end

	guildInfo.attunements = {}
	self.db.global.guildInfo[guildName] = guildInfo
	UpdateOwnAttunementInfo()
	lastTimeUpdate = GetTime()

	if firstUpdate then
		self:RequestData(prefix, "GUILD")
	end
end


do
	local guildEvents = {
		"PLAYER_ENTERING_WORLD",
		"GUILD_ROSTER_UPDATE",
		"CHAT_MSG_ADDON",
	}

	local guildFrame = CreateFrame("Frame")
	guildFrame.update = true
	FrameUtil.RegisterFrameForEvents(guildFrame, guildEvents)
	C_ChatInfo.RegisterAddonMessagePrefix("MAM_ATTUNEMENTS")

	guildFrame:SetScript("OnEvent", function(self, event, ...)
		if AltManager.addon_loaded then
			if event == "GUILD_ROSTER_UPDATE" and self.update then
				self.update = false
				AltManager:UpdateGuildRoster(true)
				defaultCategories = AltManager:getDefaultCategories()
			elseif event == "CHAT_MSG_ADDON" then
				local prefix = ...
				if prefix == "MAM_ATTUNEMENTS" then
					AltManager:ProcessAttunementMessage(select(2, ...))
				end
			end
		end
	end)
end