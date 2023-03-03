local PLUGIN = PLUGIN

PLUGIN.name = "Fallout: New Vegas HUD"
PLUGIN.description = "Adds a Fallout: New Vegas styled HUD."
PLUGIN.author = "_HappyGoLucky"

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_meta.lua")

ix.option.Add("hudColor", ix.type.color, Color(255,111,76,255), {
    category = "fonvHUD"
})

ix.config.Add("showExplosiveIndicator", true, "Should the explosive indicator show?", nil, {
    category = "fonvHUDConfig"
})
