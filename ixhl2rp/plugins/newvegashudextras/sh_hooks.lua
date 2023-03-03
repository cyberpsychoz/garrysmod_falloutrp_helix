local PLUGIN = PLUGIN

do
    local KEY_BLACKLIST = IN_ATTACK + IN_ATTACK2

    function PLUGIN:StartCommand(client, cmd)
        if (client:GetNetVar("activeWeaponCondition", 100) <= 0) then
            cmd:RemoveKey(KEY_BLACKLIST)
        end
    end
end