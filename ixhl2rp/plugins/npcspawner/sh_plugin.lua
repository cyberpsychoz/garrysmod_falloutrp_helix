local PLUGIN = PLUGIN

PLUGIN.name = "NPC Spawner"
PLUGIN.description = "Spawns NPCs."
PLUGIN.author = "milk man"

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_hooks.lua")

CAMI.RegisterPrivilege({
    Name = "Helix - NPC Spawner",
    MinAccess = "admin"
})

if (SERVER) then
    function PLUGIN:OnNPCKilled(npc, attacker, inflictor)
        if (npc.spawnerEnt) then
            npc.spawnerEnt:NPCKilled()
        end
    end
end

local playerMeta = FindMetaTable("Player")
function playerMeta:CanUseNPCSpawner()
    return CAMI.PlayerHasAccess(self, "Helix - NPC Spawner", nil)
end

ix.option.Add("npcSpawnerShowSpheres", ix.type.bool, true, {
    category = "npcSpawner",
    hidden = function()
        return !LocalPlayer():CanUseNPCSpawner()
    end
})

ix.option.Add("npcSpawnerShowSpawnedNpcs", ix.type.bool, true, {
    category = "npcSpawner",
    hidden = function()
        return !LocalPlayer():CanUseNPCSpawner()
    end
})

ix.option.Add("npcSpawnerPlayerZoneColor", ix.type.color, Color(180, 0, 0, 155), {
    category = "npcSpawner",
    hidden = function()
        return !LocalPlayer():CanUseNPCSpawner()
    end
})

ix.option.Add("npcSpawnerNpcZoneColor", ix.type.color, Color(0, 180, 25, 155), {
    category = "npcSpawner",
    hidden = function()
        return !LocalPlayer():CanUseNPCSpawner()
    end
})

--makes it so only people in observer can right click in context menu
function PLUGIN:CanProperty(client, property, entity)
    if (entity:GetClass() == "npc_spawner" and client:GetMoveType() != MOVETYPE_NOCLIP) then
        return false
    end
end

properties.Add("npcspawner_edit", {
    MenuLabel = "NPC Spawner Edit",
    Order = 999,
    MenuIcon = "icon16/user_edit.png",

    Filter = function(self, entity, client)
        if (!IsValid(entity)) then return false end
        if (entity:GetClass() != "npc_spawner") then return false end
        if (!gamemode.Call( "CanProperty", client, "npcspawner_edit", entity)) then return false end

        return CAMI.PlayerHasAccess(client, "Helix - NPC Spawner", nil)
    end,

    Action = function(self, entity)
        self:MsgStart()
            net.WriteEntity(entity)
        self:MsgEnd()
    end,

    Receive = function(self, length, client)
        local entity = net.ReadEntity()

        if (!IsValid(entity)) then return end
        if (!self:Filter(entity, client)) then return end

        net.Start("npcSpawnerOpen")
            net.WriteEntity(entity)
        net.Send(client)
    end
    })