local PLUGIN = PLUGIN

PLUGIN.name = "MatSpecular"
PLUGIN.author = "Horny"
PLUGIN.description = "Off specular."

function PLUGIN:PlayerLoadedCharacter(player, character)
    local identifier = "ixHuitaPolnaya"..player:SteamID()

    if timer.Exists(identifier) then
        timer.Remove(identifier)
    end

    timer.Create(identifier, 30, 0, function()
        if !IsValid(player) or !character then
            return
        end

        if !player:Alive() then
            return
        end

        RunConsoleCommand("mat_specular", 0)
    end)
end