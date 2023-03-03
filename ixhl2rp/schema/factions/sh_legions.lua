FACTION.name = "Легион цезаря"
FACTION.description = "Аве Цезарь!"
FACTION.color = Color(255, 0, 0)
FACTION.models = {
	"models/cl/military/legionrecruit.mdl",
}
FACTION.isDefault = false

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("spear", 1)
	inventory:Add("health_kit", 2)
	inventory:Add("suitcase", 1)
	inventory:Add("flashlight", 1)

end

FACTION_LEGION = FACTION.index