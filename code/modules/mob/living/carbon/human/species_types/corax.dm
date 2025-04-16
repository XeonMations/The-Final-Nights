/datum/species/corax
	name = "Corax"
	id = "corax"
	say_mod = "squaks"
	default_color = "00FF00"
	species_traits = list(LIPS, NOEYESPRITES, HAS_FLESH, HAS_BONE, HAS_MARKINGS)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BIRD
	mutant_bodyparts = list()
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/moth
	wings_icon = "Crow"
	flying_species = TRUE
	has_innate_wings = TRUE
	whitelisted = TRUE
	selectable = TRUE
