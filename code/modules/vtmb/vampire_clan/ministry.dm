/datum/vampire_clan/ministry
	name = CLAN_SETITES
	desc = "The Ministry, also called the Ministry of Set, Followers of Set, or Setites, are a clan of vampires who believe their founder was the Egyptian god Set."
	curse = "Decreased moving speed in lighted areas."
	clan_disciplines = list(
		/datum/discipline/obfuscate,
		/datum/discipline/presence,
		/datum/discipline/serpentis
	)
	male_clothes = /obj/item/clothing/under/vampire/slickback
	female_clothes = /obj/item/clothing/under/vampire/burlesque
	clan_keys = /obj/item/vamp/keys/setite

/datum/vampire_clan/ministry/on_gain(mob/living/carbon/human/H)
	. = ..()
	H.add_quirk(/datum/quirk/lightophobia)
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
