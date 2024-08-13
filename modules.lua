local addonName, PermoksAccountManager = ...
PermoksAccountManager.isBC = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

local ModuleMixin = {}
function ModuleMixin:Init(moduleName, payload)
    self.name = moduleName
    self.events = payload.events
    self.share = payload.share
    self.payload = payload
    self.forceLabelUpdate = {}
    self.labelFunctions = {}
    self.labelArgs = {}
    self.loadedLabelRows = {}
    self.IDs = {}
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
    self.labelFunctions[customType] = { callback = callback, args = { ... } }
    self.labelArgs[customType] = {}
end

function ModuleMixin:GenerateLabelArgs(altData, labelType, update)
    if not labelType or not altData then
        return
    end

    local labelArgKey = altData.guid or altData.name

    if self.labelArgs[labelType][labelArgKey] and not self.forceLabelUpdate[labelType] and not update then
        return self.labelArgs[labelType][labelArgKey]
    end

    local args = {}
    for _, key in ipairs(self.labelFunctions[labelType].args) do
        if altData[key] then
            tinsert(args, altData[key])
        end
    end

    self.labelArgs[labelType][labelArgKey] = args
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

local function AddIDsToDatabase(module, row, key)
    if not row or not row.IDs then return end
    key = row.key or key

    if not row.IDs and row.customIDs and row.customData then
        row.IDs = row.customIDs(row.customData)
    end

    local ID
    for i=1, #row.IDs do
        ID = row.IDs[i]
        module.IDs[row.type][ID] = key
    end
end

local function AddLabelRows(module, rows)
    if not rows then
        return
    end

    for row_identifier, row in pairs(rows) do
        if row.version == false or row.version == WOW_PROJECT_ID and row.type then
            if enums[row_identifier] then
                PermoksAccountManager:Print("Identifier already in use:", row_identifier, "by", enums[row_identifier].name)
            else
                module.loadedLabelRows[row_identifier] = true
                module.IDs[row.type] = module.IDs[row.type] or {}
                AddIDsToDatabase(module, row, row_identifier)
                PermoksAccountManager.labelRows[row_identifier] = row
                enums[row_identifier] = module
            end
        end
    end
end

local function CallFunction(module, func, charInfo, ...)
    func(module, charInfo, ...)

    if module.share and module.share[func] then
        PermoksAccountManager:SendCharacterUpdate(module.share[func])
    end
end

local function RegisterModuleEvent(event)
    if functions[event] then
        return
    end

    functions[event] = function(charInfo, ...)
        for i, module in ipairs(events[event]) do
            if type(module.events[event]) == "table" then
                for _, functionName in ipairs(module.events[event]) do
                    if type(functionName) == "string" and module[functionName] then
                        CallFunction(module, module[functionName], charInfo, ...)
                    -- for backwards compatibility (for now)
                    elseif type(functionName) == "function" then
                        CallFunction(module, functionName, charInfo, ...)
                    end
                end
            elseif type(module.events[event]) == "string" and module.events[event] then
                CallFunction(module, module[module.events[event]], charInfo, ...)
            elseif type(module.events[event]) == "function" then
                CallFunction(module, module.events[event], charInfo, ...)
            end
        end
    end

    pcall(
        function()
            modulesEventFrame:RegisterEvent(event)
        end
    )
end

local function AddEvents(module)
    local moduleEvents = module.events
    if not moduleEvents then
        return
    end

    for event, v in pairs(moduleEvents) do
        events[event] = events[event] or {}
        tinsert(events[event], module)

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

    AddEvents(module)

    if self.charInfo and module.Update then
        module:Update(self.charInfo)
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
