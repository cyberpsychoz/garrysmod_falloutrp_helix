
ITEM.name = "Ручная рация"
ITEM.model = Model("models/props_trainstation/payphone_reciever001a.mdl")
ITEM.description = "Ручная рация с регулятором частоты.\nВ данный момент %s%s."
ITEM.cost = 250
ITEM.classes = {CLASS_EMP, CLASS_EOW}
ITEM.flag = "v"

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("enabled")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:GetDescription()
	local enabled = self:GetData("enabled")
	return string.format(self.description, enabled and "включена и" or "выключена", enabled and (" работает на частоте " .. self:GetData("frequency", "100.0")) or "")
end

function ITEM.postHooks.drop(item, status)
	item:SetData("enabled", false)
end

ITEM.functions.Frequency = {
	OnRun = function(itemTable)
		netstream.Start(itemTable.player, "Frequency", itemTable:GetData("frequency", "000.0"))

		return false
	end
}

ITEM.functions.Toggle = {
	OnRun = function(itemTable)
		local character = itemTable.player:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("handheld_radio", true)
		local bCanToggle = true

		-- don't allow someone to turn on another radio when they have one on already
		if (#radios > 1) then
			for k, v in ipairs(radios) do
				if (v != itemTable and v:GetData("enabled", false)) then
					bCanToggle = false
					break
				end
			end
		end

		if (bCanToggle) then
			itemTable:SetData("enabled", !itemTable:GetData("enabled", false))
			itemTable.player:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 0.25)
		else
			itemTable.player:NotifyLocalized("radioAlreadyOn")
		end

		return false
	end
}
