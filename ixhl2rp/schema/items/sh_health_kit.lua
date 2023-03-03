
ITEM.name = "Докторский саквояж"
ITEM.model = Model("models/fnv/clutter/health/doctorbag.mdl")
ITEM.description = "Пила, молоток, пинцет и бинты..."
ITEM.category = "Medical"
ITEM.price = 65

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 50, 100))
	end
}
