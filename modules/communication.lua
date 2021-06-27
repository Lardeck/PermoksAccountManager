local addonName, AltManager = ...
local AceComm = LibStub("AceComm-3.0")
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")
local lastTimeSend = {}


function AltManager:Deserialze(msg)
	local decoded = LibDeflate:DecodeForWoWAddonChannel(msg)
    if not decoded then return end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return end
    local success, data = LibSerialize:Deserialize(decompressed)
    if not success then return end

	return data
end

function AltManager:Serialize(msg)
	local serialized = LibSerialize:Serialize(msg)
	local compressed = LibDeflate:CompressDeflate(serialized)
	local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)

	return encoded
end

function AltManager:RequestData(prefix, channel, target)
	AceComm:SendCommMessage(prefix, "request", channel, target or nil)
end

function AltManager:SendInfo(type, prefix, msg, channel, target, overrideLimit)
	if not overrideLimit and GetTime() - (lastTimeSend[type] or 0) < 5 then return end

	if msg then
		local encoded = self:Serialize(msg)

    	target = target and Ambiguate(target, "none")
    	AceComm:SendCommMessage(prefix, encoded, channel, target or nil)

    	lastTimeSend[type] = GetTime()
	end
end