/datum/vampire_clan/nosferatu
	name = CLAN_NOSFERATU
	desc = "The Nosferatu wear their curse on the outside. Their bodies horribly twisted and deformed through the Embrace, they lurk on the fringes of most cities, acting as spies and brokers of information. Using animals and their own supernatural capacity to hide, nothing escapes the eyes of the so-called Sewer Rats."
	curse = "Masquerade-violating appearance."
	alt_sprite = "nosferatu"
	clan_disciplines = list(
		/datum/discipline/animalism,
		/datum/discipline/potence,
		/datum/discipline/obfuscate
	)
	clan_traits = list(
		TRAIT_MASQUERADE_VIOLATING_FACE
	)
	male_clothes = /obj/item/clothing/under/vampire/nosferatu
	female_clothes = /obj/item/clothing/under/vampire/nosferatu/female
	accessories = list("nosferatu_ears", "none")
	accessories_layers = list("nosferatu_ears" = UPPER_EARS_LAYER, "none" = UPPER_EARS_LAYER)
	default_accessory = "nosferatu_ears"
	clan_keys = /obj/item/vamp/keys/nosferatu

/datum/vampire_clan/nosferatu/on_gain(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
	H.ventcrawler = VENTCRAWLER_ALWAYS
