local addonName, PermoksAccountManager = ...
local AceComm = LibStub("AceComm-3.0")
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")
local lastTimeSend = {}


function PermoksAccountManager:Deserialze(msg)
	local decoded = LibDeflate:DecodeForWoWAddonChannel(msg)
    if not decoded then return end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return end
    local success, data = LibSerialize:Deserialize(decompressed)
    if not success then return end

	return data
end

function PermoksAccountManager:Serialize(msg)
	local serialized = LibSerialize:Serialize(msg)
	local compressed = LibDeflate:CompressDeflate(serialized)
	local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)

	return encoded
end

function PermoksAccountManager:RequestData(prefix, channel, target)
	AceComm:SendCommMessage(prefix, "request", channel, target or nil)
end

local function SendCallback(data, done, total)
	if done == total then 
		if data[2] then
			PermoksAccountManager:Print(string.format(data[1] .. " done! This message has to appear on both accounts before you can reload or log out."))
		elseif data[1] then
			PermoksAccountManager:Print(string.format(data[1] .. " done!"))
		end
	end
end

function PermoksAccountManager:SendInfo(type, prefix, msg, channel, target, overrideLimit, useCallback, isSynch)
	if not overrideLimit and GetTime() - (lastTimeSend[type] or 0) < 5 then return end

	if msg then
		local encoded = self:Serialize(msg)

    	target = target and Ambiguate(target, "none")
		if useCallback then
			self:Print("Sending Data ...")
		end

    	AceComm:SendCommMessage(prefix, encoded, channel, target or nil, nil, useCallback and SendCallback or nil, useCallback and {target, isSynch} or nil)

    	lastTimeSend[type] = GetTime()
	end
end