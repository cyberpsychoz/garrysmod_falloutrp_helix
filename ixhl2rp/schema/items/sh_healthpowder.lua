ITEM.name = "Целебный порошок"
ITEM.model = Model("models/fnv/clutter/healingpowder/healingpowder.mdl")
ITEM.description = "Лечебный порошок изготовленный из разных трав."
ITEM.category = "Medical"
ITEM.price = 35

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))
	end
}
