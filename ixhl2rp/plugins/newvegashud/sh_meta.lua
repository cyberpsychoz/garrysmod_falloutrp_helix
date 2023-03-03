local playerMeta = FindMetaTable("Player")

if (CLIENT) then
    function playerMeta:NewVegasNotify(text, icon, duration)
        if (not text or not isstring(text)) then error("Please enter a valid string!") end
        if (not duration) then duration = 3 end
        if (not isnumber(duration)) then error("Please enter a valid integer!") end
        icon = icon or "default_icon"

        ix.gui.fonvhud:AddNotification(text, icon, duration)
    end

    net.Receive("ixNewVegasNotification", function(length)
        LocalPlayer():NewVegasNotify(net.ReadString(), net.ReadString(), net.ReadUInt(8))
    end)
else
    util.AddNetworkString("ixNewVegasNotification")

    function playerMeta:NewVegasNotify(text, icon, duration)
        if (not text or not isstring(text)) then error("Please enter a valid string!") end
        if (not duration) then duration = 3 end
        if (not isnumber(duration)) then error("Please enter a valid integer!") end
        icon = icon or "messageNeutral"

        net.Start("ixNewVegasNotification")
            net.WriteString(text)
            net.WriteString(icon)
            net.WriteUInt(duration, 8)
        net.Send(self)
    end
end