
ITEM.name = "Фонарик"
ITEM.model = Model("models/mosi/fallout4/props/junk/recorder.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Теперь тут не так темно, правда?"
ITEM.category = "Tools"

ITEM:Hook("drop", function(item)
    item.player:SetNWBool("ixFlashlight", false)
end)
