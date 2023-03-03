
FACTION.name = "Синты"
FACTION.description = "Просто роботы."
FACTION.color = Color(100, 100, 150)
FACTION.models = {
	"models/arachnit/fallout4/synths/synthgeneration1.mdl",
}
FACTION.isDefault = false

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("suitcase", 1)
end

function FACTION:GetDefaultName(client)
	return "SYNTH." .. Schema:ZeroNumber(math.random(1, 999), 3), true
end

function FACTION:OnTransferred(character)
	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

FACTION_ROBOTS = FACTION.index
