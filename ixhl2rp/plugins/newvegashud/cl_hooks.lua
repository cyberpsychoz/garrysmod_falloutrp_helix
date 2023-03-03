local PLUGIN = PLUGIN

function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont("Monofonto_HUD", {
		font = "Monofonto",
		size = 30,
		weight = 500
	})
	surface.CreateFont("Monofonto_HUD_Ammo", {
		font = "Monofonto",
		size = 38,
		weight = 500
	})
	surface.CreateFont("Monofonto_HUD_Ammo_Secondary", {
		font = "Monofonto",
		size = 24,
		weight = 500
	})
	surface.CreateFont("Monofonto_Medium", {
		font = "Monofonto",
		size = 30,
		weight = 500
	})
end

function PLUGIN:CanDrawAmmoHUD()
	return false
end

function PLUGIN:ShouldHideBars()
	return true
end

function PLUGIN:ShouldDrawCrosshair()
	return false
end

function PLUGIN:CharacterLoaded(character)
	if (character and not IsValid(ix.gui.fonvhud)) then
		vgui.Create("fonvHUD")
	end
end

local CROSSHAIR_HOVER_ENTS = {}
CROSSHAIR_HOVER_ENTS["ix_vendor"] = true
CROSSHAIR_HOVER_ENTS["ix_item"] = true
CROSSHAIR_HOVER_ENTS["ix_money"] = true
CROSSHAIR_HOVER_ENTS["ix_shipment"] = true
CROSSHAIR_HOVER_ENTS["ix_container"] = true
CROSSHAIR_HOVER_ENTS["prop_door_rotating"] = true
CROSSHAIR_HOVER_ENTS["prop_ragdoll"] = true

--entity : Entity that you are currently looking at.
function PLUGIN:ShouldNewVegasCrosshairHover(entity)
	if (entity:GetPos():Distance(LocalPlayer():GetPos()) > 100) then return false end
	if (CROSSHAIR_HOVER_ENTS[entity:GetClass()] or entity.crosshairHoverEnt == true) then return true end
end

local EXPLOSIVE_IND_ENTS = {}
EXPLOSIVE_IND_ENTS["npc_grenade_frag"] = true

--entity: Entities in a sphere with a radius of 192 around the player
function PLUGIN:ShouldEntityDrawExplosiveIndicator(entity)
	if (EXPLOSIVE_IND_ENTS[entity:GetClass()] or entity.explosiveIndEnt == true) then return true end
end
