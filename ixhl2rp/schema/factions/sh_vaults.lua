
FACTION.name = "Жители убежища"
FACTION.description = "Те, кому повезло остаться в живых."
FACTION.color = Color(135, 206, 250)
FACTION.models = {
	{"models/thespireroleplay/humans/group010/female_01.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_02.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_03.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_04.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_05.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_06.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_07.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_08.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_09.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_10.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_11.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/female_12.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_01.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_02.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_03.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_04.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_05.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_06.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_07.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_08.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_09.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_10.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_11.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_12.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_13.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_14.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_15.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_16.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_17.mdl", nil, "022200012"},
	{"models/thespireroleplay/humans/group010/male_18.mdl", nil, "022200012"},
}
FACTION.isDefault = true

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("suitcase", 1)

end

FACTION_VAULTS = FACTION.index
