ATTRIBUTE.name = "Стойкость"
ATTRIBUTE.desc = "How resistant you are to damage."
ATTRIBUTE.default = 0
ATTRIBUTE.noStartBonus = false

function ATTRIBUTE:onSetup(client, value)
    client:SetNW2Int(self.name, value)
end

function ATTRIBUTE:onGet(client, value)
    return client:GetNW2Int(self.name, value)
end