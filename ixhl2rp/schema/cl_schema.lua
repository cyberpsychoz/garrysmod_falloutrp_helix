ix.bar.Add(function()
    return math.max(LocalPlayer():GetCharacter():GetData("hunger") / LocalPlayer():GetCharacter():GetData("hunger"), 0)
end, Color(205,133,63), nil, "hunger")

ix.bar.Add(function()
    return math.max(LocalPlayer():GetCharacter():GetData("thirst") / LocalPlayer():GetCharacter():GetData("thirst"), 0)
end, Color(70,130,180), nil, "thirst")

function Schema:AddCombineDisplayMessage(text, color, ...)
	if (LocalPlayer():IsCombine() and IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, ...)
	end
end
