FACTION.name = "НКР"
FACTION.description = "Народная калифорнийская республика"
FACTION.color = Color(255, 140, 0)
FACTION.models = {
	"models/ncr/female_01.mdl",
	"models/ncr/female_02.mdl",
	"models/ncr/female_03.mdl",
	"models/ncr/female_04.mdl",
	"models/ncr/female_06.mdl",
	"models/ncr/female_07.mdl",
	"models/ncr/ncr_01.mdl",
	"models/ncr/ncr_02.mdl",
	"models/ncr/ncr_03.mdl",
	"models/ncr/ncr_04.mdl",
	"models/ncr/ncr_05.mdl",
	"models/ncr/ncr_06.mdl",
	"models/ncr/ncr_07.mdl",
	"models/ncr/ncr_08.mdl",
	"models/ncr/ncr_09.mdl",
}
FACTION.isDefault = false

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("varmint_rifle", 1)
	inventory:Add("556ammo", 2)
	inventory:Add("handheld_radio", 1)
	inventory:Add("suitcase", 1)

end

FACTION_NCR = FACTION.index