
ITEM.name = "Бинты"
ITEM.model = Model("models/mosi/fallout4/props/junk/components/cloth.mdl")
ITEM.description = "Обрывки какой-то ткани."
ITEM.category = "Medical"
ITEM.price = 18

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 20, 100))
	end
}
