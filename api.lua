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
