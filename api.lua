local addonName, PermoksAccountManager = ...
_G.PAMAPI = {}

local api = _G.PAMAPI

function api.AddModule(...)
	if ... then
		local added = PermoksAccountManager:AddModule(...)
		if added then
			PermoksAccountManager.UpdateCustomLabelOptions()
		end
	end
end

function api.GetCharacterInfo(key)
	if key and PermoksAccountManager.charInfo then
		return PermoksAccountManager.charInfo[key]
	end
end

function api.GetCharactersForAccount(account)
	if PermoksAccountManager.db.global.accounts[account] then
		return PermoksAccountManager.db.global.accounts[account].data
	end
end

function api.Import(importString)
	local data = PermoksAccountManager:ParseImportString(importString)
	if data then
		PermoksAccountManager.db.global.custom = data.custom
		PermoksAccountManager.db.global.options = data.options
		PermoksAccountManager.db.global.internalVersion = data.internalVersion
	end

	--TODO: Handle the import more gracefully. This should work for now. Forcing a reload would probably be more secure.
	PermoksAccountManager:OnLogin()
end
