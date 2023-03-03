PLUGIN.name = "Corpse Cleanup"
PLUGIN.description = "Removes corpses of creatures 10 seconds after their death."
PLUGIN.author = "Крыжовник"

if SERVER then
    -- Remove corpses 10 seconds after they are created
    hook.Add("OnEntityCreated", "RemoveCorpseOnDeath", function(ent)
        if ent:GetClass() == "prop_ragdoll" and ent:IsNPC() then
            timer.Simple(10, function()
                if IsValid(ent) then
                    ent:Remove()
                end
            end)
        end
    end)
end