local addonName, AltManager = ...
local AceComm = LibStub("AceComm-3.0")
local accountsPrefix = "MAM_ACCOUNTS"
local requestedAccepts = {}
local requestedSynch


function AltManager:GetNumAccounts()
	local numAccounts = 0
	for accountName in pairs(AltManager.db.global.accounts) do
		numAccounts = numAccounts + 1
	end

	return numAccounts
end


function AltManager:RequestAccountSynch(name, realm)
	if name == UnitName("player") then return end
	if realm then
		local connectedRealms = GetAutoCompleteRealms()
		if not tContains(connectedRealms, realm) then 
			self:Print(realm, "is not a connected realm.")
			return 
		end

		name = name .. "-" .. realm
	end

	if self.db.global.synchedCharacters[name] then
		self:Print("You're already synched with that character. Account:",self.db.global.synchedCharacters[name])
		return
	end

	self:Print("Sending a synch request to:", synchData.name, synchData.realm or "")
	requestedSynch = name
	local message = {type = "synchrequest"}
	self:SendInfo("synchrequest", accountsPrefix, message, "WHISPER", name)
end


function AltManager:ProcessAccountsMessage(prefix, msg, channel, sender, x, y)
	local db = self.db.global
	local deserializedMsg = self:Deserialze(msg)
	if deserializedMsg and deserializedMsg.type then
		if deserializedMsg.type == "synchrequest" then
			if db.blockedCharacters[sender] then return end

			requestedAccepts[sender] = true
			self:Print(sender, "requests a synch. Type |cff00ff00/mam accept name|r to accept it or |cff00ff00/mam block name|r to block it. Don't forget the realm if it's in the name.")
		elseif deserializedMsg.type == "synchaccepted" then
			if requestedSynch and sender == requestedSynch then
				self:Print(sender, "accepted the synch request.")
				self:Print("Don't forget to use the 'Send Upate' button if you add/remove characters afterwards.")
				self:SynchCharacter(sender)

				if deserializedMsg.account then
					self:AddAccount(deserializedMsg.account, sender)
					self:SendAccountUpdate(sender)
				end
			elseif requestedSynch and sender ~= requestedSynch then
				self:Print(requestedSynch, "is not", sender)
			end
		else
			if db.blockedCharacters[sender] or not db.synchedCharacters[sender] then return end
			if deserializedMsg.type == "updateaccount" then
				if deserializedMsg.account then
					self:AddAccount(deserializedMsg.account, sender)
					if deserializedMsg.login then
						self:SendAccountUpdate(sender)
					end
				end
			elseif deserializedMsg.type == "updatecharacter" then
				if deserializedMsg.guid and deserializedMsg.key and deserializedMsg.info then
					self:UpdateCharacter(sender, deserializedMsg.guid, deserializedMsg.key, deserializedMsg.info)
				end
			end
		end
	end
end

function AltManager:AcceptSynch(name)
	if not name then return end
	if not requestedAccepts[name] then self:Print(name, "didn't request to synch.") return end
	self:SynchCharacter(name)

	self:Print("Synch Accepted", name)
	local accountData = self.db.global.accounts.main
	local message = {type = "synchaccepted", account = accountData}
	self:SendInfo("synchaccepted", accountsPrefix, message, "WHISPER", name)

	requestedAccepts[name] = nil
end

function AltManager:SynchCharacter(name)
	local accountName = self.db.global.synchedCharacters[name] or "account" .. #self.db.global.accounts + 2
	self:Print("Synching with character", name)

	self.db.global.synchedCharacters[name] = accountName

end

function AltManager:BlockCharacter(name)
	if not name then return end
	self.db.global.options.blockedCharacters[name] = true
end

function AltManager:RemoveOldAccountData(accountName)
	if not accountName then return end

	for characterName, oldAccountName in pairs(self.db.global.synchedCharacters) do
		if oldAccountName == accountName then
			self.db.global.synchedCharacters[characterName] = nil
		end
	end

	self.db.global.accounts[accountName] = nil
end

function AltManager:AddAccount(account, name)
	local accountName = self.db.global.synchedCharacters[name]
	self:Print("Add/Update Account", accountName, ". Initiated by", name)
	self:RemoveOldAccountData(accountName)

	local realm = GetNormalizedRealmName()
	for alt_guid, alt_data in pairs(account.data) do
		local characterName = alt_data.realm ~= realm and alt_data.name .. "-" .. alt_data.realm or alt_data.name
		self.db.global.synchedCharacters[characterName] = accountName
	end

	account.name = accountName:gsub("^%l", string.upper)
	self.db.global.accounts[accountName] = account
	self.db.global.numAccounts = self:GetNumAccounts()
	self:BefriendEveryoneOfAccount(account)
	self:UpdateAccountButtons()
	requestedSynch = nil
end

function AltManager:SendAccountUpdate(name)
	local message = {type = "updateaccount", account = self.db.global.accounts.main}
	self:SendInfo("updateaccount", accountsPrefix, message, "WHISPER", name)
end

function AltManager:SendAccountUpdates(isLogin)
	if self.db.global.numAccounts == 1 then return end

	local targets = self:GetOnlineSynchedCharacters()
	local message = {type = "updateaccount", account = self.db.global.accounts.main, login = isLogin}


	if #targets == 0 then return end
	for i, target in ipairs(targets) do
		self:SendInfo("updateaccount", accountsPrefix, message, "WHISPER", target)
	end
end

function AltManager:UpdateCharacter(name, guid, key, info)
	local accountName = self.db.global.synchedCharacters[name]
	local accountData = self.db.global.accounts[accountName].data

	if accountData[guid] and accountData[guid][key] then
		accountData[guid][key] = info
	end
end

function AltManager:BefriendEveryoneOfAccount(account)
	local realm = GetNormalizedRealmName()
	for alt_guid, alt_data in pairs(account.data) do
		if not C_FriendList.IsFriend(alt_guid) then
			local characterName = alt_data.realm ~= realm and alt_data.name .. "-" .. alt_data.realm or alt_data.name
			C_FriendList.AddFriend(characterName)
		end
	end
end

function AltManager:GetOnlineSynchedCharacters()
	local targets = {}
	local realm = GetNormalizedRealmName()

	for accountName, accountInfo in pairs(self.db.global.accounts) do
		if accountName ~= "main" then
			for alt_guid, alt_data in pairs(accountInfo.data) do
				local characterName = alt_data.realm ~= realm and alt_data.name .. "-" .. alt_data.realm or alt_data.name
				if not C_FriendList.IsFriend(alt_guid) then
					C_FriendList.AddFriend(characterName)
				end

				local friendInfo = C_FriendList.GetFriendInfo(characterName)
				if friendInfo and friendInfo.connected then
					tinsert(targets, characterName)
					break
				end
			end
		end
	end

	return targets
end

function AltManager:SendCharacterUpdate(key)
	if self.db.global.numAccounts == 1 then return end
	local char_table = self.char_table
	if not char_table then return end

	local targets = self:GetOnlineSynchedCharacters()
	if #targets > 0 then
		--self:Print("Send Update", key)
		local guid = self:getGUID()

		local info = char_table[key]
		local message = {type = "updatecharacter", guid = guid, key = key, info = info}
		for i, target in ipairs(targets) do
			self:SendInfo("updatecharacter", accountsPrefix, message, "WHISPER", target, true)
		end
	end
end

function AltManager:UpdateAccounts()
	if self.db.global.numAccounts > 1 then
		self:Print("Initiating Account Update.")
		self:UpdateAccountButtons()
		C_Timer.After(15, function() AltManager:SendAccountUpdates(true) end)
	end
end

do
	AceComm:RegisterComm(accountsPrefix, function(...) AltManager:ProcessAccountsMessage(...) end)
end