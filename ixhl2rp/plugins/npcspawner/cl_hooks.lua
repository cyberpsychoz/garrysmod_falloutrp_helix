function PLUGIN:HUDPaint()
    if (ix.option.Get("observerESP", true) and ix.option.Get("npcSpawnerShowSpawnedNpcs") and LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP) then
        local scrW, scrH = ScrW(), ScrH()

        for k, v in pairs(ents.FindByClass("npc_spawner")) do
            if (LocalPlayer():GetAimVector():Dot((v:GetPos() - LocalPlayer():GetPos()):GetNormal()) < 0.65) then
                continue
            end

            local screenPosition = v:GetPos():ToScreen()
            local marginX, marginY = scrH * .1, scrH * .1
            local x, y = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
            local distance = LocalPlayer():GetPos():Distance(v:GetPos())
            local factor = 1 - math.Clamp(distance / 1024, 0, 1)
            local size = math.max(10, 32 * factor)
            local alpha = math.max(255 * factor, 80)

            ix.util.DrawText(L("npcSpawner"), x, y - size, ColorAlpha(Color(255, 255, 255), alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
            ix.util.DrawText(v:GetSpawnedNPCs() .. " / " .. v:GetMaxNPCs(), x, y, ColorAlpha(Color(255, 255, 255), alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
        end
    end
end