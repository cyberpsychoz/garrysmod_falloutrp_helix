
ITEM.name = "Стимулятор"
ITEM.model = Model("models/fnv/clutter/health/stimpak01.mdl")
ITEM.description = "Обыкновенный стимулятор."
ITEM.category = "Medical"
ITEM.price = 40

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 20, client:GetMaxHealth()))
	end
}
