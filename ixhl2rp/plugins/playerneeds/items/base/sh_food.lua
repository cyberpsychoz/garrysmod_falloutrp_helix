ITEM.name = "foodBase"
ITEM.description = "Food Base"
ITEM.model = "models/error.mdl"
ITEM.category = "Food"
ITEM.portions = 4

ITEM.restFood = 1
ITEM.sound = "physics/flesh/flesh_squishy_impact_hard4.wav"

ITEM.functions.eat = {
	name = "Eat All",
	icon = "icon16/cake.png",
	OnRun = function(item)
        -- lowercase "item" in variable calls
		item.player:addHunger(item.restFood * (item:GetData("portions", item.portions) / item.portions))
		item.player:EmitSound(item.sound)
	end
}

ITEM.functions.eatPortion = {
	name = "Eat Portion",
	icon = "icon16/heart.png",
	OnRun = function(item)
        -- lowercase "item" in variable calls
		item.player:addHunger(item.restFood / item.portions)
		item.player:EmitSound(item.sound)
		 
		item:SetData("portions", item:GetData("portions", item.portions) - 1)

		if item:GetData("portions") < 1 then
			return true
		end
		return false
	end
}

function ITEM:PopulateTooltip(tooltip)
	local panel = tooltip:AddRowAfter("name", "portions")
	panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
	panel:SetText("Portions: " .. (self:GetData("portions", self.portions)))
	panel:SizeToContents()
end