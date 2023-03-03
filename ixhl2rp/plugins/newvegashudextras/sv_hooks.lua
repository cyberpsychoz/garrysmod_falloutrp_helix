local PLUGIN = PLUGIN

--Remove default oxygen system from HELIX because its based on seconds not a oxygen value
timer.Adjust("ixLifeGuard", 1, 0, function()
	for _, v in ipairs(player.GetAll()) do
		local oxygenLevel = v:GetLocalVar("o2", 100)

		if (v:GetCharacter() and v:Alive() and hook.Run("ShouldPlayerDrowned", v) ~= false) then
			if (v:WaterLevel() >= 3) then
				local oxygenDrain = ix.config.Get("oxygenDrain", 3)

				if (oxygenLevel > 0) then
					v:SetLocalVar("o2", math.Clamp(v:GetLocalVar("o2", 100) - oxygenDrain, 0, 100))
				else
					v:ScreenFade(1, Color(0, 0, 255, 100), 1, 0)
					v:TakeDamage(ix.config.Get("drowningDamage", 10))
				end
			else
				local oxygenRegain = ix.config.Get("oxygenRegain", 10)

				v:SetLocalVar("o2", math.Clamp(v:GetLocalVar("o2", 95) + oxygenRegain, 0, 100))
			end
		end
	end
end)

function PLUGIN:ShouldPlayerDrowned(client)
	if (client:GetMoveType() == MOVETYPE_NOCLIP) then
		return false
	end
end

function PLUGIN:PlayerLoadedCharacter(client, character, currentCharacter)
	timer.Simple(0.25, function()
		client:SetLocalVar("o2", character:GetData("oxygen", 100))
	end)
end

function PLUGIN:CharacterPreSave(character)
	local client = character:GetPlayer()

	if (IsValid(client)) then
		character:SetData("oxygen", client:GetLocalVar("o2", 0))
	end
end

function PLUGIN:EntityFireBullets(entity, bulletInfo)
	local weaponItem = entity:GetActiveWeapon().ixItem
	if (not weaponItem) then return end
	local itemConditionDrainFactor = weaponItem.conditionDrainFactor or 1
	local weaponConditionDrain = ix.config.Get("weaponConditionDrainRate", 1) * itemConditionDrainFactor

	if (entity:IsPlayer() and weaponItem) then
		local condition = weaponItem:GetData("condition", 100)

		weaponItem:SetData("condition", math.Clamp(math.Round(condition - weaponConditionDrain, 2), 0, 100))
		entity:SetLocalVar("activeWeaponCondition", math.Clamp(math.Round(condition - weaponConditionDrain, 2), 0, 100))

		if (weaponItem:GetData("condition") <= 0) then
			weaponItem:OnBreak(entity)
		end
	end
end

function PLUGIN:EntityTakeDamage(victim, dmgInfo)
	local attacker = dmgInfo:GetAttacker()

	if (attacker:IsPlayer()) then
		local weaponItem = dmgInfo:GetAttacker():GetActiveWeapon().ixItem
		if (not weaponItem) then return end
		local condition = weaponItem:GetData("condition", 100)

		if (ix.config.Get("bulletDamageBasedOnWeaponCondition", true)) then
			condition = condition / 100
			condition = 0.5 + math.min((0.5 * condition / 0.75), 0.5)

			dmgInfo:SetDamage(math.Round(dmgInfo:GetDamage() * condition, 2))
		end
	end
end

function PLUGIN:PlayerSwitchWeapon(client, oldWeapon, newWeapon)
	if (newWeapon.ixItem) then
		client:SetLocalVar("activeWeaponCondition", newWeapon.ixItem:GetData("condition", 100))
	else
		client:SetLocalVar("activeWeaponCondition", nil)
	end
end
