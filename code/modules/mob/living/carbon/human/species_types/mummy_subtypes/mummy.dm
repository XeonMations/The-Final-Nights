//Base mummy subtype. Used by all the mummy subtypes for special shenanigens.
/datum/species/human/mummy
	name = "Mummy"
	id = "mummy"
	selectable = FALSE
	whitelisted = TRUE

/datum/species/human/mummy/on_species_gain(mob/living/carbon/human/C)
	. = ..()

	ADD_TRAIT(C, MUMMY_REVIVAL, SPECIES_MUMMY)
