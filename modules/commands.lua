local addonName, AltManager = ...
local LibIcon = LibStub("LibDBIcon-1.0")

local commands = {
	["/mam"] = "Toggle AltManager",
	["/mam minimap"] = "Toggle the minimap button",
	["/mam remove name"] = "Remove character by name",
	["/mam filter a/add name"] = "Add character to filter",
	["/mam filter r/remove name"] = "Remove character from filter",
	["/mam filter p/print"] = "Print filter list",
	["/mam version"] = "Print version number",
	["/mam keys [party | raid | guild]"] = "Print keys of all characters into party > guild chat (or specified channel)",
	["/mam help"] = "Print help text",
}

function AltManager:Print(...)
	local pattern = "|cfff49b42AltManager|r %s"
	print(string.format(pattern, ...))
end

function AltManager:PrintCommandList()
	print("|cfff49b42AltManager Commands:|r")
	for command, helpText in pairs(commands) do
		print(("|cfff49b42%s|r - %s"):format(command, helpText))
	end
end
function AltManager:ToggleMinimap()
	self.db.profile.minimap.hide = not self.db.profile.minimap.hide
	if (self.db.profile.minimap.hide) then
		LibIcon:Hide("MartinsAltManager")
	else
		LibIcon:Show("MartinsAltManager")
	end
end

function AltManager:isBlacklisted(guid)
	return AltManager.db.global.blacklist[guid]
end

function AltManager:HandleChatCommand(chatString)
	local command, nextposition = AltManager:GetArgs(chatString, 1)
	if command == "purge" then
		AltManager:Purge()
	elseif command == "remove" then
		local characterName, realm = AltManager:GetArgs(chatString, 2, nextposition)
		AltManager:RemoveCharacterFromDBByName(characterName, realm)
	elseif command == "minimap" then
		AltManager:ToggleMinimap()
	elseif command == "filter" then
		local subCommand, characterName, realm = AltManager:GetArgs(chatString, 3, nextposition)
		if subCommand then
			if subCommand == "a" or subCommand == "add" then
				AltManager:UpdateCharacterFilter(characterName, realm, true)
			elseif subCommand == "r" or subCommand == "remove" then
				AltManager:UpdateCharacterFilter(characterName, realm)
			elseif subCommand == "p" or subCommand == "print" then
				AltManager:PrintFilter(AltManager.db.global.blacklist, "Filter")
			end
		end
	elseif command == "help" then
		AltManager:PrintCommandList()
	elseif command == "version" then
		print("|cfff49b42AltManager Version:|r", AltManager.db.global.version)
	elseif command == "keys" then
		local channel = AltManager:GetArgs(chatString, 1, nextposition)
		AltManager:PostKeysIntoChat(channel)
	elseif command == "accept" then
		local characterName = AltManager:GetArgs(chatString, 1, nextposition)
		AltManager:AcceptSync(characterName)
	elseif command == "block" then
		local characterName = AltManager:GetArgs(chatString, 1, nextposition)
		AltManager:BlockAccount(characterName)
	elseif command == "debug" then
		AltManager.db.global.options.debug = not AltManager.db.global.options.debug
	else
		if AltManagerFrame:IsShown() then
			AltManager:HideInterface()
		else
			AltManager:ShowInterface()
		end
	end
end

function AltManager:RemoveCharacterFromDBByName(name, realm)
	local characters = self:FindCharacterInDBByName(name, true, realm)
	if characters then
		if realm then
			for alt_guid, info in pairs(characters.guids) do
				if info.realm == realm then
					self:RemoveCharacterFromDB(alt_guid)
					return
				end
			end
		else
			local guid, info = next(characters.guids)
			if guid then
				self:RemoveCharacterFromDB(guid)
				return
			end
		end
	end
end

function AltManager:PrintFilter(tbl, listName)
	local list = {}
	for guid, info in pairs(tbl) do
		local color = info.class and CreateColor(GetClassColor(info.class))
		local coloredName = color and ((info.realm and color:WrapTextInColorCode(info.name .."-"..info.realm)) or color:WrapTextInColorCode(info.name)) or info.name
		tinsert(list, coloredName)
	end

	self:Print(listName)
	print(table.concat(list, ", "))
end

function AltManager:FindCharacterInDBByName(name, filter, realm)
	local characters = {num = 0, guids = {}}
	local data = filter and self.db.global.accounts.main.data or self.db.global.blacklist
	for alt_guid, alt_data in pairs(data) do
		if alt_data.name == name then
			characters.guids[alt_guid] = filter and {name = alt_data.name, realm = alt_data.realm, class = alt_data.class} or alt_data
			characters.num = characters.num + 1
		end
	end

	if characters.num > 1 and not realm then
		self:Print("Found more than one character with that name. please specify a realm.")
		self:PrintFilter(characters, "Characters")
		return
	end

	return characters
end

function AltManager:RemoveCharacterFromDB(guid)
	local page = self.db.global.accounts.main.data[guid].page

	self.db.global.accounts.main.data[guid] = nil
	self.db.global.alts = self.db.global.alts - 1

	tDeleteItem(self.db.global.accounts.main.pages[page], guid)
	if page == self.db.global.currentPage then
		self:SortPages()
		self:UpdatePageButtons()
		self:UpdateAnchorsAndSize("general")
	end
end

function AltManager:HandleFilterAction(guid, filter, info)
	if filter then
		self.db.global.blacklist[guid] = info
		self:RemoveCharacterFromDB(guid)
	else
		self.db.global.blacklist[guid] = nil
	end
end

function AltManager:UpdateCharacterFilter(characterName, realm, filter)
	local characters = self:FindCharacterInDBByName(characterName, filter)
	if characters then
		if realm then
			for alt_guid, info in pairs(characters.guids) do
				if info.realm == realm then
					self:HandleFilterAction(alt_guid, filter, info)
					return
				end
			end
		else
			local guid, info = next(characters.guids)
			if guid then
				self:HandleFilterAction(guid, filter, info)
				return
			end
		end
	end
end

function AltManager:Purge()
	local blacklist = self.db.global.blacklist
	local internalVersion = self.db.global.internalVersion

	self.db = self.db:ResetDB()
	self.db.global.blacklist = blacklist
	self.db.global.internalVersion = internalVersion

	self:OnLogin()

	self:Print("Please reload your interface to update the displayed info.")
end