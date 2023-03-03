local PLUGIN = PLUGIN
local playerMeta = FindMetaTable("Player")

function playerMeta:addHunger(amount)
	local char = self:GetCharacter()

	if !char then return end

	char:SetData("hunger", math.Clamp((char:GetData("hunger", PLUGIN.defaultMax) + amount), 0, PLUGIN.defaultMax))
	notifyHunger(self)
end

function playerMeta:setHunger(amount)
	local char = self:GetCharacter()
	
	if !char then return end

	char:SetData("hunger", math.Clamp(amount, 0, PLUGIN.defaultMax))
	notifyHunger(self)
end

function playerMeta:addThirst(amount)
	local char = self:GetCharacter()

	if !char then return end

	char:SetData("thirst", math.Clamp((char:GetData("thirst", PLUGIN.defaultMax) + amount), 0 , PLUGIN.defaultMax))
	notifyThirst(self)
end

function playerMeta:setThirst(amount)
	local char = self:GetCharacter()
	
	if !char then return end

	char:SetData("thirst", math.Clamp(amount, 0, PLUGIN.defaultMax))
	notifyThirst(self)
end

function PLUGIN:PlayerDeath(client)
	client.refill = true
end

function PLUGIN:PlayerSpawn(client)
	local char = client:GetCharacter()

	if !char then return end

	if(client.refill or false) then
		char:SetData("hunger", PLUGIN.defaultMax)
		char:SetData("thirst", PLUGIN.defaultMax)
		client.refill = false
	end
end

function PLUGIN:PlayerPostThink(client)
	local time = CurTime()
	local char = client:GetCharacter()
	
	if !char or !client:Alive() then return end

	if (client.nextCooldownHunger or 0) < time then
		char:SetData("hunger", char:GetData("hunger", PLUGIN.defaultMax) - 1)
		notifyExactHunger(client)

		client.nextCooldownHunger = time + 180 + (char:GetAttribute("hungerlifetime") or 0)
	end

	if (client.nextCooldownThirst or 0) < time then
		char:SetData("thirst", char:GetData("thirst", PLUGIN.defaultMax) - 1)
		notifyExactThirst(client)

		client.nextCooldownThirst = time + 120 + (char:GetAttribute("thirstlifetime") or 0)
	end

	if (char:GetData("hunger") < 1) or (char:GetData("thirst") < 1) then
		client:SetHealth(client:Health() - 1)
		if client:Health() < 1 then
			client:TakeDamage(999)
		end
	end
end

function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	character:SetData("hunger", character:GetData("hunger", PLUGIN.defaultMax))
	character:SetData("thirst", character:GetData("thirst", PLUGIN.defaultMax))
end

-- these functions are made to be used to generalize the result of adding hunger/thirst
function notifyHunger(client)
	hungStat = client:GetCharacter():GetData("hunger", PLUGIN.defaultMax)

	if hungStat > 90 then
		client:ChatNotify("Вы сыты.")
	elseif hungStat > 80 then
		client:ChatNotify("Вы слегка проголодались.")
	elseif hungStat > 60 then
		client:ChatNotify("Вы голодны.")
	elseif hungStat > 30 then
		client:ChatNotify("Вы смертельно голодны.")
	elseif hungStat > 0 then
		client:ChatNotify("Вы чувствуете как ваш желудок разъедает себя изнутри.")
	elseif hungStat == 0 then
		client:ChatNotify("Ваше зрение начинает тускнеть от голода.")
	end
end

function notifyThirst(client)
	thirStat = client:GetCharacter():GetData("thirst", PLUGIN.defaultMax)

	if thirStat > 90 then
		client:ChatNotify("Вы не хотите пить.")
	elseif thirStat > 80 then
		client:ChatNotify("Вас немного мучает жажда.")
	elseif thirStat > 60 then
		client:ChatNotify("Вы хотите пить.")
	elseif thirStat > 30 then
		client:ChatNotify("Вы очень сильно хотите пить.")
	elseif thirStat > 0 then
		client:ChatNotify("Вы чувствуете недомогание из-за сильной жажды.")
	elseif thirStat == 0 then
		client:ChatNotify("Ваше зрение начинает тускнеть из-за обезвоживания.")
	end
end

-- "exact" functions are made to only be used in playerpostthink so the player isn't spammed every decrement
function notifyExactHunger(client)
	hungStat = client:GetCharacter():GetData("hunger", PLUGIN.defaultMax)

	if hungStat == 100 then
		client:ChatNotify("Вы сыты.")
	elseif hungStat == 75 then
		client:ChatNotify("Вы слегка проголодались.")
	elseif hungStat == 50 then
		client:ChatNotify("Вы голодны.")
	elseif hungStat == 25 then
		client:ChatNotify("Вы смертельно голодны.")
	elseif hungStat == 5 then
		client:ChatNotify("Вы чувствуете как ваш желудок разъедает себя изнутри.")
	elseif hungStat == 0 then
		client:ChatNotify("Ваше зрение начинает тускнеть от голода.")
	end
end

function notifyExactThirst(client)
	thirStat = client:GetCharacter():GetData("thirst", PLUGIN.defaultMax)

	if thirStat == 100 then
		client:ChatNotify("Вы не хотите пить.")
	elseif thirStat == 75 then
		client:ChatNotify("Вас немного мучает жажда.")
	elseif thirStat == 50 then
		client:ChatNotify("Вы хотите пить.")
	elseif thirStat == 25 then
		client:ChatNotify("Вы очень сильно хотите пить.")
	elseif thirStat == 5 then
		client:ChatNotify("Вы чувствуете недомогание из-за сильной жажды.")
	elseif thirStat == 0 then
		client:ChatNotify("Ваше зрение начинает тускнеть из-за обезвоживания.")
	end
end
