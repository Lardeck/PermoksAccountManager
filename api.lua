local addonName, PermoksAccountManager = ...
_G.PAMAPI = {}

local api = _G.PAMAPI

--[[
PAM API quick reference

How to add a module
1. Create a unique module name.
2. Build a payload table:
   - update(charInfo): fills or refreshes data on the current character.
   - labels: table of rowIdentifier = labelRow.
   - events: eventName = callback or { callbackA, callbackB }.
     Every callback receives (charInfo, ...eventArgs).
   - share: optional map of callbackFunction = charInfoKey.
     After that callback runs, PAM shares charInfo[charInfoKey] with synced accounts.
3. Register the module with:
   local module = _G.PAMAPI.AddModule("my_module", payload, true)
   Pass true for forceLoad when you want the module to register events and run update() immediately.
4. Keep every row identifier unique across all PAM modules.

Minimal complete example
local api = _G.PAMAPI

local function UpdateExample(charInfo)
    charInfo.exampleModule = charInfo.exampleModule or {}
    charInfo.exampleModule.status = IsResting() and "Resting" or "Awake"
end

local payload = {
    update = UpdateExample,
    labels = {
        example_status = {
            label = "Example Status",
            group = "other",
            version = false,
            data = function(altData)
                return altData.exampleModule and altData.exampleModule.status or "-"
            end,
        },
    },
    events = {
        PLAYER_ENTERING_WORLD = UpdateExample,
        PLAYER_UPDATE_RESTING = UpdateExample,
    },
    share = {
        [UpdateExample] = "exampleModule",
    },
}

api.AddModule("example_module", payload, true)

Built-in labelRow.type values supported by PAM without custom registration
- quest: reads altData.questInfo[questType][visibility][key].
- currency: reads altData.currencyInfo[key].
- faction: reads altData.factions[key].
- item: reads altData.itemCounts[key].
- sanctum: reads altData.sanctumInfo with labelRow.key.
- raid: reads altData.instanceInfo.raids[key].
- pvp: reads altData.pvp[key].
- vault: reads altData.vaultInfo[key].

If you do not want to use one of the built-in types, set data = function(altData, labelRow, rowIdentifier)
on the row instead. Bundled types such as gold, keystone, spark, worldquest, renown, and similar module-
specific types are not core defaults; they are registered by their owning modules.

Common label row fields
- label: string or function returning the row name shown in the UI.
- type: optional string; use one of the built-in types above or a custom type you registered yourself.
- data: optional fallback renderer used when no built-in/custom type is needed.
- key: optional lookup key used by most built-in types.
- group: optional group/category key such as character, currency, item, dungeons, raids, reputation,
  profession, resetDaily, resetWeekly, or other.
- version: false for all game versions, or a specific WOW_PROJECT_* constant.
- tooltip: true to use the default tooltip for the type, or a function for a custom tooltip.
- customTooltip: function(button, altData, labelRow, rowIdentifier) for full tooltip control.
- color: function(altData) returning a ColorMixin.
- OnClick: function(buttonName, altData) for row click handling.
- warband: true to show in the warband column, "unique" for warband-only rows.
- passKey: for custom label types, prepends labelRow.key or rowIdentifier to the callback arguments.
- passRow: for custom label types, prepends the full labelRow to the callback arguments.

Available functions
- PAMAPI.AddModule(moduleName, payload, forceLoad)
  moduleName: unique string used to register the module.
  payload: table containing update, labels, optional events, and optional share.
  forceLoad: boolean; pass true to load the module immediately.
  returns: the created module object, or nil when registration fails.

- module:AddCustomLabelType(customType, callback, alwaysForceUpdate, ...)
  customType: string that your label rows use in labelRow.type.
  callback: renderer called with the altData fields named in ... after PAM extracts them.
  alwaysForceUpdate: boolean; when true, callback arguments are rebuilt every refresh instead of cached.
  ...: one or more altData keys, for example "itemCounts", "currencyInfo", or "exampleModule".

- PAMAPI.GetCharacterInfo(key)
  key: string key from the current character info table.
  returns: PermoksAccountManager.charInfo[key], or nil.

- PAMAPI.GetCharactersForAccount(account)
  account: account key from db.global.accounts, for example "main" or a synced account id.
  returns: db.global.accounts[account].data, or nil.

- PAMAPI.Import(importString)
  importString: export string created by PAM.
  effect: overwrites the imported custom/category/options data and reruns OnLogin() to refresh state.
]]


function api.AddModule(moduleName, payload, forceLoad)
	if moduleName and payload then
		local added = PermoksAccountManager:AddModule(moduleName, payload, forceLoad)
		if added then
			PermoksAccountManager.UpdateCustomLabelOptions()
		end
		return added
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
