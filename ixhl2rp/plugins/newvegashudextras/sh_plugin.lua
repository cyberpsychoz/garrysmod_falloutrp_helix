local PLUGIN = PLUGIN

PLUGIN.name = "Fallout: New Vegas HUD Extras"
PLUGIN.description = "Adds a Fallout: New Vegas stuff for my HUD."
PLUGIN.author = "_HappyGoLucky"

ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")

--Oxygen Stuff
ix.config.Add("oxygenDrain", 3, "The amount of oxygen drained (out of 100) per second.", nil, {
    data = {min = 0, max = 100},
    category = "fonvOxygenConfig"
})

ix.config.Add("oxygenRegain", 10, "The amount of oxygen regained (out of 100) per second.", nil, {
    data = {min = 0, max = 100},
    category = "fonvOxygenConfig"
})

ix.config.Add("drowningDamage", 10, "The amount of damage you take for drowning per second.", nil, {
    data = {min = 0, max = 100},
    category = "fonvOxygenConfig"
})

--Weapon Condition Stuff
ix.config.Add("weaponConditionDrainRate", 0.05, "The amount a weapon will drain (pre-modifiers) per shot.", nil, {
    data = {min = 0.0, max = 1.0, decimals = 2},
    category = "fonvWeaponConditionConfig"
})

ix.config.Add("bulletDamageBasedOnWeaponCondition", true, "Modify the bullets damage based on the condition of your gun.", nil, {
    category = "fonvWeaponConditionConfig"
})

-- stack overflow if autorefreshed do not autorefresh
do
    for k, v in pairs(ix.item.list) do
        if (v.base == "base_weapons" and v.isGrenade == false) then
            --with a broken weapon you can load comes a need for the ability to take that ammo out
            
            v.functions.Repair = {
                name = "Repair",
                tip = "repairTip",
                icon = "icon16/wrench.png",
                OnRun = function(item)
                    item:SetData("condition", 100)
                    item.player:NewVegasNotify("You repaired your " .. item.name .. ".", "messageSuccess", 5)
                    return true
                end,
                OnCanRun = function(item)
                    return item:GetData("condition", 100) < 100
                end
        }
            v.functions.Unload = {
                name = "Разрядить",
                tip = "unloadTip",
                icon = "icon16/box.png",
                OnRun = function(item)
                    local client = item.player
                    local weapon = client.carryWeapons[item.weaponCategory]

                    if (weapon:IsWeapon()) then
                        client:GiveAmmo(weapon:Clip1(), game.GetAmmoName(weapon:GetPrimaryAmmoType()))
                        weapon:SetClip1(0)
                        item:Unequip(client, true)

                        return false
                    end
                end,
                OnCanRun = function(item)
                    local client = item.player
                    --cant find a way to get ammo from weapon class so gotta be equipped
                    return IsValid(client) and item:GetData("equip") == true
                end
            }
            if (CLIENT) then
                v.oldTooltip = v.PopulateTooltip

                function v:PopulateTooltip(tooltip)
                    local condition = tooltip:AddRow("condition")
                    condition:SetText(L("condition") .. " : " .. self:GetData( "condition", 100 ))
                    condition:SizeToContents()
                    self:oldTooltip(tooltip)
                end
            end

            function v:OnInstanced()
                self:SetData("condition", self:GetData( "condition", 100 ))
            end

            function v:OnEquipWeapon(client, weapon)
                client:SetLocalVar("activeWeaponCondition", self:GetData("condition", 100))
            end

            function v:OnBreak(client)
                client:NewVegasNotify("Your " .. self.name .. " broke!", "messageSurprise", 5)
                local random = {1, 4, 5}
                client:EmitSound("physics/metal/metal_solid_impact_hard" .. table.Random(random) .. ".wav")
            end
        end
    end
end