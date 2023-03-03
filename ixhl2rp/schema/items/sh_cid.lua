
ITEM.name = "Паспорт жителя Бирмингема"
ITEM.model = Model("models/mosi/fallout4/props/junk/keycard.mdl")
ITEM.description = "Паспорт на имя %s."

function ITEM:GetDescription()
	return string.format(self.description, self:GetData("name", "nobody"))
end
