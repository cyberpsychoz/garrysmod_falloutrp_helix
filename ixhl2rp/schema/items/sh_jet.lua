ITEM.name = "Винт"
ITEM.model = Model("models/fnv/clutter/chems/jet01.mdl")
ITEM.description = "Единственный послевоенный наркотик, представлет улучшенную версию метамфетамина."
ITEM.category = "Medical"
ITEM.price = 30

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 20, client:GetMaxHealth()))
	end
}
