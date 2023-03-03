ENT.Type = "anim"
ENT.PrintName = "NPC Spawner"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Enabled")
    self:NetworkVar("Int", 0, "MaxNPCs")
    self:NetworkVar("Int", 1, "SpawnAmount")
    self:NetworkVar("Int", 2, "SpawnInterval")
    self:NetworkVar("Int", 3, "NPCSpawnRadius")
    self:NetworkVar("Int", 4, "PlayerRadius")
    self:NetworkVar("Int", 5, "SpawnedNPCs")
    self:NetworkVar("String", 0, "NPCClass")

    self:SetEnabled(false)
    self:SetMaxNPCs(4)
    self:SetSpawnInterval(60)
    self:SetNPCSpawnRadius(50)
    self:SetPlayerRadius(100)
    self:SetSpawnAmount(1)
    self:SetSpawnedNPCs(0)
    self:SetNPCClass("npc_zombie")

    if (SERVER) then
        self:NetworkVarNotify("Enabled", self.OnEnabled)
        self:NetworkVarNotify("SpawnInterval", self.OnSpawnIntervalChanged)
    end
end

function ENT:Initialize()
    if (SERVER) then
        self.spawnedNPCs = {}

        self:SetModel("models/props_junk/sawblade001a.mdl")
        self:SetRenderMode(RENDERMODE_TRANSCOLOR)
        self:SetColor(Color(255, 255, 255, 85))
        self:SetMaterial("models/debug/debugwhite")

        self:SetUseType(SIMPLE_USE)
        self:SetMoveType(MOVETYPE_NONE)
        self:DrawShadow(false)
        self:SetSolid(SOLID_BBOX)
        self:PhysicsInit(SOLID_BBOX)

        local physObj = self:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end
    end

    self:SetCustomCollisionCheck(true)
end

if (SERVER) then
    function ENT:Use(activator)
        if (activator:CanUseNPCSpawner() and activator:GetMoveType() == MOVETYPE_NOCLIP) then

            net.Start("npcSpawnerOpen")
                net.WriteEntity(self)
            net.Send(activator)
        end
    end

    function ENT:OnSpawnIntervalChanged(name, old, new)
        timer.Adjust(self:EntIndex() .. "_npc_spawner", new, nil, nil)
    end

    function ENT:OnEnabled(name, old, new)
        local timerIdentifier = self:EntIndex() .. "_npc_spawner"

        if (new) then
            timer.Create(timerIdentifier, self:GetSpawnInterval(), 0, function()
                self:SpawnNPCs()
            end)
        else
            if (timer.Exists(timerIdentifier)) then
                timer.Remove(timerIdentifier)
            end
        end
    end

    function ENT:SpawnNPCs()
        local currentNPCs = #self.spawnedNPCs
        local spawnAmount = self:GetSpawnAmount()
        spawnAmount = currentNPCs + spawnAmount <= self:GetMaxNPCs() and spawnAmount or self:GetMaxNPCs() - currentNPCs
        local spawnerPos = self:GetPos()
        local playerRadius = self:GetPlayerRadius()
        local squaredBlockRadius = playerRadius * playerRadius

        if (self:GetEnabled() and self:GetMaxNPCs() > currentNPCs) then
            for k, client in pairs(player.GetAll()) do
                if (client:GetPos():DistToSqr(self:GetPos()) < squaredBlockRadius and client:GetMoveType() != MOVETYPE_NOCLIP) then
                    return
                end
            end

            for i = 1, self:GetSpawnAmount() do
                local randAngle = math.Rand(0, 360)
                local randRadius = math.Rand(-self:GetNPCSpawnRadius(), self:GetNPCSpawnRadius())
                local x, y = randRadius * math.cos(randAngle), randRadius * math.sin(randAngle)
                local position = Vector(spawnerPos.x + x, spawnerPos.y + y, spawnerPos.z)
                local data = {
                    start = position + Vector(0, 0, 36),
                    endpos = position + Vector(0, 0, -100),
                    filter = self
                }
                local trace = util.TraceLine(data)
                local spawnerNPC = ents.Create(self:GetNPCClass())
                spawnerNPC.spawnerEnt = self
                spawnerNPC:SetPos(trace.HitPos + Vector(0, 0, 16))
                local retries = 100
                local npcStuck = util.TraceEntity({start = spawnerNPC:GetPos(), endpos = spawnerNPC:GetPos(), filter = spawnerNPC}, spawnerNPC).StartSolid

                while (npcStuck and retries > 0) do
                    randAngle = math.Rand(0, 360)
                    randRadius = math.Rand(-self:GetNPCSpawnRadius(), self:GetNPCSpawnRadius())
                    x, y = randRadius * math.cos(randAngle), randRadius * math.sin(randAngle)
                    position = Vector(spawnerPos.x + x, spawnerPos.y + y, spawnerPos.z)
                    data.start = position + Vector(0, 0, 36)
                    data.endpos = position + Vector(0, 0, -100)
                    trace = util.TraceLine(data)
                    spawnerNPC:SetPos(trace.HitPos + Vector(0, 0, 16))
                    npcStuck = util.TraceEntity({start = spawnerNPC:GetPos(), endpos = spawnerNPC:GetPos(), filter = spawnerNPC}, spawnerNPC).StartSolid
                    retries = retries - 1

                    if (retries < 1) then
                        ErrorNoHalt("NPC Spawner looped 100 times, discarding NPC")
                        spawnerNPC:Remove()
                    end
                end

                if (spawnerNPC) then
                    spawnerNPC:SetPos(trace.HitPos + Vector(0, 0, 16))
                    spawnerNPC:Spawn()
                    self.spawnedNPCs[#self.spawnedNPCs + 1] = spawnerNPC
                    self:SetSpawnedNPCs(#self.spawnedNPCs)
                end
            end
        end
    end

    function ENT:NPCKilled()
        table.remove(self.spawnedNPCs)
        self:SetSpawnedNPCs(#self.spawnedNPCs)
    end

    function ENT:OnRemove()
        if (timer.Exists(self:EntIndex() .. "_npc_spawner")) then
            timer.Remove(self:EntIndex() .. "_npc_spawner")
        end

        if (#self.spawnedNPCs > 0) then
            for k, v in pairs(self.spawnedNPCs) do
                v:Remove()
            end
        end
    end
else
    function ENT:Draw()
        if (LocalPlayer():CanUseNPCSpawner() and LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP) then
            self:DrawModel()
            if (ix.option.Get("observerESP", true) and ix.option.Get("npcSpawnerShowSpheres", true)) then
                render.SetColorMaterial()
                render.DrawSphere(self:GetPos(), self:GetNPCSpawnRadius(), 50, 50, ix.option.Get("npcSpawnerNpcZoneColor"))

                render.SetColorMaterial()
                render.DrawSphere(self:GetPos(), self:GetPlayerRadius(), 50, 50, ix.option.Get("npcSpawnerPlayerZoneColor"))
            end
        end
    end

    ENT.PopulateEntityInfo = true

    function ENT:OnPopulateEntityInfo(container)
        if (LocalPlayer():CanUseNPCSpawner() and LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP) then
            local name = container:AddRow("name")
            name:SetImportant()
            name:SetText(L"npcSpawner")
            name:SizeToContents()

            local enabled = container:AddRow("enabled")
            enabled:SetText(L"npcSpawnerEnabled" .. ": " .. tostring(self:GetEnabled()))
            enabled:SizeToContents()

            local npcClass = container:AddRow("npcClass")
            npcClass:SetText(L"npcSpawnerNPCClass" .. ": " .. self:GetNPCClass())
            npcClass:SizeToContents()

            local maxNPCs = container:AddRow("maxNPCs")
            maxNPCs:SetText(L"npcSpawnerMaxNPCs" .. ": " .. self:GetMaxNPCs())
            maxNPCs:SizeToContents()

            local spawnInterval = container:AddRow("spawnInterval")
            spawnInterval:SetText(L"npcSpawnerSpawnInterval" .. ": " .. self:GetSpawnInterval())
            spawnInterval:SizeToContents()

            local spawnAmount = container:AddRow("spawnAmount")
            spawnAmount:SetText(L"npcSpawnerSpawnAmount" .. ": " .. self:GetSpawnAmount())
            spawnAmount:SizeToContents()
        end
    end
end

hook.Add("ShouldCollide", "NPCSpawnerCollisionCheck", function(firstEnt, secondEnt)
    local collidingEnt = firstEnt:GetClass() != "npc_spawner" and firstEnt or secondEnt:GetClass() != "npc_spawner" and secondEnt or nil
    local npcSpawnerEnt = firstEnt:GetClass() == "npc_spawner" and firstEnt or secondEnt:GetClass() == "npc_spawner" and secondEnt or nil

    if (npcSpawnerEnt != nil and collidingEnt != nil) then
        return collidingEnt:GetClass() == "worldspawn" or (collidingEnt:IsPlayer() and collidingEnt:CanUseNPCSpawner() and collidingEnt:GetMoveType() == MOVETYPE_NOCLIP and true)
    end
end)
