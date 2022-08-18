local addonName, PermoksAccountManager = ...
local LibIcon = LibStub("LibDBIcon-1.0")

function PermoksAccountManager:isBlacklisted(guid)
	return PermoksAccountManager.db.global.blacklist[guid]
end

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

local function PrintFilter(tbl, listName)
	local list = {}
	for _, info in pairs(tbl) do
		local color = info.class and CreateColor(GetClassColor(info.class))
		local coloredName = color and ((info.realm and color:WrapTextInColorCode(info.name .."-"..info.realm)) or color:WrapTextInColorCode(info.name)) or info.name
		tinsert(list, coloredName)
	end

	PermoksAccountManager:Print(listName .. "\n" .. table.concat(list, ", "))
end

local function ToggleMinimap()
	PermoksAccountManager.db.profile.minimap.hide = not PermoksAccountManager.db.profile.minimap.hide
	if (PermoksAccountManager.db.profile.minimap.hide) then
		LibIcon:Hide(addonName)
	else
		LibIcon:Show(addonName)
	end
end

local function FindCharactersByName(name, isFilter, realm)
	local numCharacters = 0
	local characters = {}
	local data = isFilter and PermoksAccountManager.db.global.accounts.main.data or PermoksAccountManager.db.global.blacklist
	for alt_guid, altData in pairs(data) do
		if altData.name == name and (not realm or (realm == altData.realm)) then
			characters[alt_guid] = {name = altData.name, realm = altData.realm, class = altData.class}
			numCharacters = numCharacters + 1
		end
	end

	if numCharacters > 1 and not realm then
		PermoksAccountManager:Print("Found more than one character, please specify the realm.")
		PrintFilter(characters, "Characters")
		return
	end

	return characters
end

local function RemoveCharacterFromDB(guid)
	PermoksAccountManager.db.global.accounts.main.data[guid] = nil
	PermoksAccountManager.db.global.alts = PermoksAccountManager.db.global.alts - 1
end

local function RemoveCharacterFromPage(guid)
	local page = PermoksAccountManager.db.global.accounts.main.data[guid].page

	tDeleteItem(PermoksAccountManager.db.global.accounts.main.pages[page], guid)
	return page
end



local function RemoveCharacterByName(name, realm)
	local characters = FindCharactersByName(name, true, realm)
	if characters then
		local guid, _ = next(characters)
		if guid then
			PermoksAccountManager:RemoveCharacter(guid)
			return
		end
	end
end

local function HandleFilterAction(guid, isAddToFilter, info)
	if isAddToFilter then
		PermoksAccountManager.db.global.blacklist[guid] = info
		PermoksAccountManager:RemoveCharacter(guid)
	else
		PermoksAccountManager.db.global.blacklist[guid] = nil
	end
end

local function UpdateCharacterFilter(characterName, realm, isAdd)
	local characters = FindCharactersByName(characterName, isAdd, realm)
	if characters then
		local guid, info = next(characters.guids)
		if guid then
			HandleFilterAction(guid, isAdd, info)
			return
		end
	end
end

function PermoksAccountManager:RemoveCharacter(guid)
	local page = RemoveCharacterFromPage(guid)
	RemoveCharacterFromDB(guid)
	PermoksAccountManager:UpdateManagerFrame(page)
end

function PermoksAccountManager:AddChracterToFilterFromOptions(guid, accountName)
	local altData = PermoksAccountManager.db.global.accounts[accountName].data[guid]
	PermoksAccountManager.db.global.blacklist[guid] = {name = altData.name, realm = altData.realm, class = altData.class}
	self:RemoveCharacter(guid)
end

local commands = {}
function commands.PURGE()
	PermoksAccountManager:Purge()
end

function commands.REMOVE(characterName, realm)
	RemoveCharacterByName(characterName, realm)
end

function commands.MINIMAP()
	ToggleMinimap()
end

function commands.FILTER(subCommand, characterName, realm)
	if subCommand == "p" then
		PrintFilter(PermoksAccountManager.db.global.blacklist, "Filter")
	else
		UpdateCharacterFilter(characterName, realm, (subCommand == "a" or subCommand == "add"))
	end
end

function commands.HELP()
	PrintCommandList()
end

function commands.VERSION()
	PermoksAccountManager:Print("|cfff49b42Version:|r", PermoksAccountManager.db.global.version)
end

function commands.KEYS(channel)
	PermoksAccountManager:PostKeysIntoChat(channel)
end

function commands.ACCEPT(characterName)
	PermoksAccountManager:AcceptSync(characterName)
end

function commands.DEBUG()
	PermoksAccountManager.db.global.options.debug = not PermoksAccountManager.db.global.options.debug
end

function commands.OPTIONS()
	PermoksAccountManager:OpenOptions()
end

function commands.SECRET()
	if not PermoksAccountManager.db.global.secret then
		PermoksAccountManager.db.global.secret = true
		PermoksAccountManager:RegisterChatCommand('mam', 'HandleChatCommand')
	end
end

function PermoksAccountManager:HandleChatCommand(chatString)
	local command, nextposition = PermoksAccountManager:GetArgs(chatString, 1)

	if command then
		command = string.upper(command)
		if not commands[command] then return end
		commands[command](PermoksAccountManager:GetArgs(chatString, 3, nextposition))
	else
		if PermoksAccountManagerFrame:IsShown() then
			self:HideInterface()
		else
			self:ShowInterface()
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

function PermoksAccountManager:HandleSecretPsst()
	if self.db.global.secret then
		PermoksAccountManager:RegisterChatCommand('mam', 'HandleChatCommand')
	end
end
