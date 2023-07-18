local addonName, PermoksAccountManager = ...
PermoksAccountManager.isBC = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

local ModuleMixin = {}
function ModuleMixin:Init(moduleName, payload)
    self.name = moduleName
    self.events = payload.events
    self.share = payload.share
    self.update = payload.update
    self.payload = payload
	self.forceLabelUpdate = {}
    self.labelFunctions = {}
	self.labelArgs = {}
end

---Adds a custom label type
---@param customType string
---@param callback function
---@param alwaysForceUpdate boolean
---@param ... string
function ModuleMixin:AddCustomLabelType(customType, callback, alwaysForceUpdate, ...)
    if self.labelFunctions[customType] then
        PermoksAccountManager:Print(string.format('[%s] - Custom Type [%s] already exists.', self.name, customType))
        return
    end

	self.forceLabelUpdate[customType] = alwaysForceUpdate
    self.labelFunctions[customType] = {callback = callback, args = {...}}
	self.labelArgs[customType] = {}
end

function ModuleMixin:GenerateLabelArgs(altData, labelType, update)
	if not labelType or not altData then
        return
    end

	if self.labelArgs[labelType][altData.guid] and not self.forceLabelUpdate[labelType] and not update then
		return self.labelArgs[labelType][altData.guid]
	end

    local args = {}
    for _, key in ipairs(self.labelFunctions[labelType].args) do
        if altData[key] then
            tinsert(args, altData[key])
        end
    end

	self.labelArgs[labelType][altData.guid] = args
    return args
end

local modules = {}
local enums = {}
local events = {}
local functions = {}
local modulesEventFrame = CreateFrame('Frame')
local currentCharInfo
local function SetEventScript(charInfo)
    if not charInfo then
        return
    end

    if not currentCharInfo then
        currentCharInfo = charInfo
    end

    modulesEventFrame:SetScript(
        'OnEvent',
        function(self, event, ...)
            if functions[event] then
                --if not charInfo then PermoksAccountManager:Debug("CharInfo is not loaded yet") return end

                functions[event](charInfo, ...)
            end
        end
    )
end

local function AddLabelRows(module, rows)
    if not rows then
        return
    end

    for row_identifier, row in pairs(rows) do
        if row.version == false or row.version == WOW_PROJECT_ID then
            PermoksAccountManager.labelRows[row_identifier] = row
            if enums[row_identifier] then
                PermoksAccountManager:Print('Please use another identifier for', module.name, row_identifier, '. Module', enums[row_identifier].name, 'already uses it.')
            else
                enums[row_identifier] = module
            end
        end
    end
end

local function RegisterModuleEvent(event)
    if functions[event] then
        return
    end

    functions[event] = function(charInfo, ...)
        for func, shareKey in pairs(events[event]) do
            func(charInfo, ...)

            if shareKey then
                PermoksAccountManager:SendCharacterUpdate(shareKey)
            end
        end
    end
    pcall(
        function()
            modulesEventFrame:RegisterEvent(event)
        end
    )
end

local function AddEvents(moduleEvents, share)
    if not moduleEvents then
        return
    end

    for event, v in pairs(moduleEvents) do
        events[event] = events[event] or {}

        if type(v) == 'table' then
            for _, func in pairs(v) do
                events[event][func] = share and share[func] or false
            end
        else
            events[event][v] = share and share[v] or false
        end

        RegisterModuleEvent(event)
    end
end

local function CreateNewModule(moduleName, payload)
    local module = CreateAndInitFromMixin(ModuleMixin, moduleName, payload)
    return module
end

function PermoksAccountManager:AddModule(moduleName, payload, load)
    if type(payload) ~= 'table' then
        self:Print(moduleName, ' - Payload is not a table')
        return
    end
    if modules[moduleName] then
        self:Print('Module', moduleName, 'already exists.')
        return
    end

    local module = CreateNewModule(moduleName, payload)
    modules[moduleName] = module
    AddLabelRows(module, payload.labels)

    if load then
        self:LoadModule(module)
    end

    return module
end

function PermoksAccountManager:GetPAMModule(moduleName)
    if modules[moduleName] then
        return modules[moduleName], currentCharInfo
    end
end

function PermoksAccountManager:LoadAllModules(charInfo)
    for moduleName, module in pairs(modules) do
        self:LoadModule(moduleName, module)
    end

    SetEventScript(charInfo)
end

function PermoksAccountManager:LoadModule(moduleName, module)
    if not modules[moduleName] then
        return
    end

    AddEvents(module.events, module.share)

    if self.charInfo then
        module.update(self.charInfo)
    end
end

function PermoksAccountManager:GetModuleForRow(row_identifier)
    return enums[row_identifier]
end

function PermoksAccountManager:IterateAccModules()
    local m = {}
    for k in pairs(modules) do
        tinsert(m, k)
    end

    local index = 0
    return function()
        index = index + 1
        if m[index] then
            return m[index], modules[m[index]]
        end
    end
end

function PermoksAccountManager:PrintRegisteredEvents()
    local e = {}
    for event in pairs(events) do
        tinsert(e, event)
    end

    self:Print(table.concat(e, ', '))
end
