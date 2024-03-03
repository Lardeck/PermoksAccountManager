local addonName, PermoksAccountManager = ...
PermoksAccountManager.modules = {}
local AceComm = LibStub('AceComm-3.0')
local accountsPrefix = 'PAM_ACCOUNTS'
local requestedAccepts = {}
local requestedSyncs = {}

local onlineFriends = {}
local UpdateOnlineFriends
do
    function UpdateOnlineFriends()
        wipe(onlineFriends)
        local realm = GetNormalizedRealmName()
        local connectedRealms = GetAutoCompleteRealms()

        local faction = UnitFactionGroup("player")
        for accountName, accountInfo in pairs(PermoksAccountManager.db.global.accounts) do
            if accountName ~= 'main' then
                for alt_guid, alt_data in pairs(accountInfo.data) do
                    if alt_data.realm == realm or tContains(connectedRealms, alt_data.realm) then
                        local characterName = alt_data.realm ~= realm and alt_data.name .. '-' .. alt_data.realm or alt_data.name

                        local friendInfo = C_FriendList.GetFriendInfo(characterName)
                        if not friendInfo and ((alt_data.faction or '') == faction) then
                            C_FriendList.AddFriend(characterName)
                            friendInfo = C_FriendList.GetFriendInfo(characterName)
                        end

                        if friendInfo and friendInfo.connected then
                            tinsert(onlineFriends, characterName)
                            break
                        end
                    end
                end
            end
        end

        PermoksAccountManager:Debug(#onlineFriends, table.concat(onlineFriends, ', '))
    end

    local module = 'accounts'
    local function Update()
        UpdateOnlineFriends()
    end

    local payload = {
        update = Update,
        events = {
            ['FRIENDLIST_UPDATE'] = UpdateOnlineFriends
        }
    }
    PermoksAccountManager:AddModule(module, payload)
    AceComm:RegisterComm(
        accountsPrefix,
        function(...)
            PermoksAccountManager:ProcessAccountMessage(...)
        end
    )
end

function PermoksAccountManager:ProcessAccountMessage(prefix, msg, channel, sender, target)
    if sender == target then return end

    local db = self.db.global
    local deserializedMsg = self:Deserialze(msg)
    if deserializedMsg and deserializedMsg.type then
        if deserializedMsg.type == 'syncrequest' then
            if db.blockedCharacters[sender] then
                return
            end

            requestedAccepts[sender] = true
            self:Print(sender, "requests a sync. Type |cff00ff00/pam accept name|r to accept it or |cff00ff00/pam block name|r to block it. Don't forget the realm if it's in the name.")
        elseif deserializedMsg.type == 'syncaccepted' then
            if requestedSyncs[sender] then
                self:Print(sender, 'accepted the sync request.')
                self:Print("Don't forget to use the 'Send Update' button if you add/remove characters afterwards.")
                self:SyncCharacter(sender)

                if deserializedMsg.account then
                    self:AddAccount(deserializedMsg.account, sender)
                    self:SendAccountUpdate(sender, true)
                end
            else
                self:Print(sender, 'tried to sync with you.')
            end
        else
            if db.blockedCharacters[sender] or not db.synchedCharacters[sender] then
                return
            end
            if deserializedMsg.type == 'updateaccount' then
                if deserializedMsg.account then
                    self:AddAccount(deserializedMsg.account, sender)

                    if deserializedMsg.login then
                        self:SendAccountUpdate(sender)
                    end
                end
            elseif deserializedMsg.type == 'updatecharacter' then
                if deserializedMsg.guid and deserializedMsg.key and deserializedMsg.info then
                    self:UpdateCharacter(sender, deserializedMsg.guid, deserializedMsg.key, deserializedMsg.info)
                end
            end
        end
    end
end

function PermoksAccountManager:GetNumAccounts()
    local numAccounts = 0
    for accountName in pairs(PermoksAccountManager.db.global.accounts) do
        numAccounts = numAccounts + 1
    end

    return numAccounts
end

function PermoksAccountManager:RequestAccountSync(name, realm)
    if name == UnitName('player') then
        return
    end
    if realm then
        local connectedRealms = GetAutoCompleteRealms()
        if not tContains(connectedRealms, realm) then
            self:Print(realm, 'is not a connected realm.')
            return
        end

        name = name .. '-' .. realm
    end

    if self.db.global.synchedCharacters[name] then
        self:Print("You're already synced with that character. Account:", self.db.global.synchedCharacters[name])
        return
    end

    requestedSyncs[name] = true

    self:Print('Sending a sync request to:', name, realm or '')
    local message = {type = 'syncrequest'}
    self:SendInfo('syncrequest', accountsPrefix, message, 'WHISPER', name)
end

function PermoksAccountManager:AcceptSync(name)
    if not name then
        return
    end
    if not requestedAccepts[name] then
        self:Print(name, "is currently not requesting to sync.")
        return
    end

    self:SyncCharacter(name)
    self:Print('Sync Accepted', name)
    local accountData = self.db.global.accounts.main
    local message = {type = 'syncaccepted', account = accountData}
    self:SendInfo('syncaccepted', accountsPrefix, message, 'WHISPER', name, true, true)
end

local function GetFreeAccountName()
    local start = 2
    local accountName = 'account' .. start
    while PermoksAccountManager.db.global.accounts[accountName] or PermoksAccountManager.db.global.syncedAccountKeys[accountName] do
        start = start + 1
        accountName = 'account' .. start
    end

    return accountName
end

function PermoksAccountManager:SyncCharacter(name)
    if self.db.global.synchedCharacters[name] then
        return
    end

    local accountName = self.db.global.synchedCharacters[name] or GetFreeAccountName()
    self:Print('Syncing with character', name, 'Account Name: ', accountName)

    self.db.global.syncedAccountKeys[accountName] = true
    self.db.global.synchedCharacters[name] = accountName
end

function PermoksAccountManager:BlockCharacter(name)
    if not name then
        return
    end
    self.db.global.options.blockedCharacters[name] = true
end

function PermoksAccountManager:RemoveOldAccountData(accountName)
    if not accountName then
        return
    end

    for characterName, oldAccountName in pairs(self.db.global.synchedCharacters) do
        if oldAccountName == accountName then
            self.db.global.synchedCharacters[characterName] = nil
        end
    end

    self.db.global.accounts[accountName] = nil
end

function PermoksAccountManager:AddAccount(account, name)
    local accountName = self.db.global.synchedCharacters[name]
    if not accountName then return end

    self:Print('Add/Update Account', accountName, '. Initiated by', name)

    local realm = GetNormalizedRealmName()
    for alt_guid, alt_data in pairs(account.data) do
        local characterName = alt_data.realm ~= realm and alt_data.name .. '-' .. alt_data.realm or alt_data.name
        self.db.global.synchedCharacters[characterName] = accountName
    end

    account.name = self.db.global.accounts[accountName] and self.db.global.accounts[accountName].name or accountName:gsub('^%l', string.upper)
    self.db.global.accounts[accountName] = account
    self:AddAccountToOptions(accountName)
    self.db.global.numAccounts = self:GetNumAccounts()
    self:BefriendEveryoneOfAccount(account)
    self:UpdateAccountButtons()

    requestedAccepts[name] = nil
    requestedSyncs[name] = nil
end

function PermoksAccountManager:UnsyncAccount(accountKey)
    self.db.global.syncedAccountKeys[accountKey] = nil

    for characterName, accountName in pairs(self.db.global.synchedCharacters) do
        if accountName == accountKey then
            self.db.global.synchedCharacters[characterName] = nil
        end
    end

    local accounts = self.db.global.accounts
    if self.managerFrame:IsShown() and self.account == accounts[accountKey] then
        self.managerFrame.accountButtons.main:Click()
    end
    accounts[accountKey] = nil
    self.db.global.numAccounts = self:GetNumAccounts()
    self:UpdateAccountButtons()
end

function PermoksAccountManager:SendAccountUpdate(name, force)
    UpdateOnlineFriends()
    if not force and (self.db.global.numAccounts == 1 or #onlineFriends == 0) then return end

    local message = {type = 'updateaccount', account = self.db.global.accounts.main}
    self:SendInfo('updateaccount', accountsPrefix, message, 'WHISPER', name, force, force)
end

function PermoksAccountManager:SendAccountUpdates(isLogin)
    if self.db.global.numAccounts == 1 or #onlineFriends == 0 then
        return
    end

    local message = {type = 'updateaccount', account = self.db.global.accounts.main, login = isLogin and 1}
    for i, target in ipairs(onlineFriends) do
        self:SendInfo('updateaccount', accountsPrefix, message, 'WHISPER', target, isLogin, isLogin)
    end
end

function PermoksAccountManager:UpdateCharacter(name, guid, key, info)
    local accountName = self.db.global.synchedCharacters[name]
    local accountData = self.db.global.accounts[accountName].data

    if accountData[guid] and accountData[guid][key] then
        accountData[guid][key] = info
    end
end

function PermoksAccountManager:BefriendEveryoneOfAccount(account)
    local realm = GetNormalizedRealmName()
    local faction = UnitFactionGroup("player")
    for alt_guid, alt_data in pairs(account.data) do
        if not C_FriendList.IsFriend(alt_guid) and (alt_data.faction or '') == faction then
            local characterName = alt_data.realm ~= realm and alt_data.name .. '-' .. alt_data.realm or alt_data.name
            C_FriendList.AddFriend(characterName)
        end
    end
end

function PermoksAccountManager:SendCharacterUpdate(key)
    if self.db.global.numAccounts == 1 then
        return
    end
    local charInfo = self.charInfo
    if not charInfo then
        return
    end

    if #onlineFriends > 0 then
        --self:Print("Send Update", key)
        local guid = self:GetGUID()

        local info = charInfo[key]
        local message = {type = 'updatecharacter', guid = guid, key = key, info = info}
        for i, target in ipairs(onlineFriends) do
            self:SendInfo('updatecharacter', accountsPrefix, message, 'WHISPER', target, true)
        end
    end
end

function PermoksAccountManager:UpdateAccounts()
    self.db.global.numAccounts = self:GetNumAccounts()

    if self.db.global.numAccounts > 1 then
        self:Print('Initiating Account Update.')
        C_Timer.After(
            15,
            function()
                UpdateOnlineFriends()
                PermoksAccountManager:SendAccountUpdates(true)
            end
        )
    end
end
