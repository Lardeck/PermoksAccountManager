local addonName, PermoksAccountManager = ...
PermoksAccountManager.isBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC

do
	local modules = {}
	local enums = {}
	local events = {}
	local functions = {}
	local typeDefaults = {
		currency = 0,

	}
	local modulesEventFrame = CreateFrame("Frame")

	local function SetEventScript(charInfo)
		if not charInfo then return end

		modulesEventFrame:SetScript("OnEvent", function(self, event, ...)
			if functions[event] then
				if not charInfo then PermoksAccountManager:Debug("CharInfo is not loaded yet") return end

				functions[event](charInfo, ...)
			end
		end)
	end

	local function AddLabelRows(module, rows)
		if not rows then return end

		for row_identifier, row in pairs(rows) do
      if row.version == false or row.version == WOW_PROJECT_ID then
        PermoksAccountManager.labelRows[row_identifier] = row

        if enums[row_identifier] then 
          PermoksAccountManager:Print("Please use another identifier for", module, row_identifier, ". Module", enums[row_identifier], "already uses it.")
        else
          enums[row_identifier] = module
        end

        if PermoksAccountManager[row.type] then
          
        end	
      end
		end
	end

	local function AddEvents(moduleEvents, share)
		if not moduleEvents then return end

		for event, v in pairs(moduleEvents) do
			events[event] = events[event] or {}

			if type(v) == "table" then
				for _, func in pairs(v) do
					events[event][func] = share and share[func] or false
				end
			else
				events[event][v] = share and share[v] or false
			end

			if not functions[event] then
				functions[event] = function(charInfo, ...)
					for func, key in pairs(events[event]) do
						func(charInfo, ...)
						
						if key then
							PermoksAccountManager:SendCharacterUpdate(key)
						end
					end
				end
        pcall(function() modulesEventFrame:RegisterEvent(event) end)
			end
		end
	end

	function PermoksAccountManager:AddModule(module, payload, load)
		if type(payload) ~= "table" then self:Print(module, " - Payload is not a table") return end
		if modules[module] then self:Print("Module", module, "already exists.") return end

		modules[module] = payload
		AddLabelRows(module, payload.labels)

		if load then
			self:LoadModule(module)
		end

		return true
	end

	function PermoksAccountManager:LoadAllModules(charInfo)
		for module, info in pairs(modules) do
			self:LoadModule(module)
		end

		SetEventScript(charInfo)
	end

	function PermoksAccountManager:LoadModule(module)
		if not modules[module] then return end

		local info = modules[module]
		AddEvents(info.events, info.share)

		if self.charInfo then
			info.update(self.charInfo)
		end
	end

	function PermoksAccountManager:GetModuleForRow(row_identifier)
		if enums[row_identifier] then
			return enums[row_identifier]
		end
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

		self:Print(table.concat(e, ", ")) 
	end
end