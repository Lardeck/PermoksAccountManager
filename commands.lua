local addonName, PermoksAccountManager = ...
local LibIcon = LibStub("LibDBIcon-1.0")

local commandInfo = {
	commands = {
		"/pam", 
		"/pam help", 
		"/pam minimap", 
		"/pam options", 
		"/pam version", 
		"/pam keys [party | raid | guild]",
		"/pam remove name",
		"/pam filter (a | add) name",
		"/pam filter (r | remove) name",
		"/pam filter (p | print)"
	},
	helpText = {
		"Show/Hide PermoksAccountManager.", 
		"Print this help text.",
		"Show/Hide the minimap button.", 
		"Show the options.",
		"Print the current version.",
		"Print keys of all characters in party > guild chat (or specified channel)",
		"Remove character by name",
		"Add character to filter",
		"Remove character from filter",
		"Print filter list"
	},
}

function PermoksAccountManager:Print(...)
	local pattern = "|cfff49b42PermoksAccountManager|r"
	print(pattern, ...)
end

local function PrintCommandList()
	print("|cfff49b42PermoksAccountManager Commands:|r")
	for index, command in ipairs(commandInfo.commands) do
		print(("|cfff49b42%s|r - %s"):format(command, commandInfo.helpText[index]))
	end
end

function PermoksAccountManager:ToggleMinimap()
	self.db.profile.minimap.hide = not self.db.profile.minimap.hide
	if (self.db.profile.minimap.hide) then
		LibIcon:Hide("PermoksAccountManager")
	else
		LibIcon:Show("PermoksAccountManager")
	end
end

function PermoksAccountManager:isBlacklisted(guid)
	return PermoksAccountManager.db.global.blacklist[guid]
end


local commands = {}
function commands:PURGE()
	PermoksAccountManager:Purge()
end

function commands:REMOVE(characterName, realm)
	PermoksAccountManager:RemoveCharacterFromDBByName(characterName, realm)
end

function commands:MINIMAP()
	PermoksAccountManager:ToggleMinimap()
end

function commands:FILTER(subCommand, characterName, realm)
	if subCommand == "p" then
		PermoksAccountManager:PrintFilter(PermoksAccountManager.db.global.blacklist, "Filter")
	else
		PermoksAccountManager:UpdateCharacterFilter(characterName, realm, (subCommand == "a" or subCommand == "add"))
	end
end

function commands:HELP()
	PrintCommandList()
end

function commands:VERSION()
	PermoksAccountManager:Print("|cfff49b42Version:|r", PermoksAccountManager.db.global.version)
end

function commands:KEYS(channel)
	PermoksAccountManager:PostKeysIntoChat(channel)
end

function commands:ACCEPT(characterName)
	PermoksAccountManager:AcceptSync(characterName)
end

function commands:BLOCK(characterName)
	PermoksAccountManager:BlockAccount(characterName)
end

function commands:DEBUG()
	PermoksAccountManager.db.global.options.debug = not PermoksAccountManager.db.global.options.debug
end

function commands:OPTIONS()
	PermoksAccountManager:OpenOptions()
end

function PermoksAccountManager:HandleChatCommand(chatString)
	local command, nextposition = PermoksAccountManager:GetArgs(chatString, 1)
	if command then
		commands[string.upper(command)](PermoksAccountManager:GetArgs(chatString, 3, nextposition))
	else
		if PermoksAccountManagerFrame:IsShown() then
			PermoksAccountManager:HideInterface()
		else
			PermoksAccountManager:ShowInterface()
		end
	end
end

function PermoksAccountManager:RemoveCharacterFromDBByName(name, realm)
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

function PermoksAccountManager:PrintFilter(tbl, listName)
	local list = {}
	for guid, info in pairs(tbl) do
		local color = info.class and CreateColor(GetClassColor(info.class))
		local coloredName = color and ((info.realm and color:WrapTextInColorCode(info.name .."-"..info.realm)) or color:WrapTextInColorCode(info.name)) or info.name
		tinsert(list, coloredName)
	end

	self:Print(listName)
	print(table.concat(list, ", "))
end

function PermoksAccountManager:FindCharacterInDBByName(name, filter, realm)
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

function PermoksAccountManager:RemoveCharacterFromDB(guid)
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

function PermoksAccountManager:HandleFilterAction(guid, filter, info)
	if filter then
		self.db.global.blacklist[guid] = info
		self:RemoveCharacterFromDB(guid)
	else
		self.db.global.blacklist[guid] = nil
	end
end

function PermoksAccountManager:UpdateCharacterFilter(characterName, realm, filter)
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

function PermoksAccountManager:Purge()
	local blacklist = self.db.global.blacklist
	local internalVersion = self.db.global.internalVersion

	self.db = self.db:ResetDB()
	self.db.global.blacklist = blacklist
	self.db.global.internalVersion = internalVersion

	self:OnLogin()

	self:Print("Please reload your interface to update the displayed info.")
end