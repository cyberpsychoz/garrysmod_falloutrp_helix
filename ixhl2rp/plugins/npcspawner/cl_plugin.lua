PLUGIN.npcPools = {}

net.Receive("npcSpawnerOpen", function(len)
    local entity = net.ReadEntity()

    ix.gui.npcSpawner = vgui.Create("npcSpawner")
    ix.gui.npcSpawner:Setup(entity)
end)