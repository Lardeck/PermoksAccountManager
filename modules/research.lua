local addonName, PermoksAccountManager = ...
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local module = 'research'
local labelRows = {
}


local function UpdateCypherResearch(charInfo)
	local self = PermoksAccountManager
	charInfo.researchInfo = charInfo.researchInfo or {}

	for talentID, key in pairs(self.research) do
		charInfo.researchInfo[key] = C_Garrison.GetTalentInfo(talentID).researched
	end
end

local function Update(charInfo)
	UpdateCypherResearch(charInfo)
end

local payload = {
	update = Update,
	labels = labelRows,
	events = {
		['GARRISON_TALENT_UPDATE'] = UpdateCypherResearch,
	},
	share = {
		[UpdateCypherResearch] = 'researchInfo'
	}
}
PermoksAccountManager:AddModule(module, payload)
