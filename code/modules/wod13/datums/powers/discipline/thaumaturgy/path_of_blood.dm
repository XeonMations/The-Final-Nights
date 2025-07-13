/datum/discipline/thaumaturgy
	name = "Thaumaturgy"
	desc = "Opens the secrets of blood magic and how you use it, allows to steal other's blood. Violates Masquerade."
	icon_state = "thaumaturgy"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/thaumaturgy

/datum/discipline/thaumaturgy/post_gain()
	. = ..()
	owner.faction |= CLAN_TREMERE
	var/datum/action/thaumaturgy/thaumaturgy = new()
	thaumaturgy.Grant(owner)
	thaumaturgy.level = level
	ADD_TRAIT(owner, TRAIT_THAUMATURGY_KNOWLEDGE, DISCIPLINE_TRAIT)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/arctome)

/datum/discipline_power/thaumaturgy
	name = "Thaumaturgy power name"
	desc = "Thaumaturgy power description"

	activate_sound = 'code/modules/wod13/sounds/thaum.ogg'

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 1 TURNS
	var/success_count

/datum/discipline_power/thaumaturgy/activate(atom/target)
	. = ..()
	//Thaumaturgy powers have different effects based off the amount of successes. I dont want to copy paste the code, so this is being put here.
	success_count = SSroll.storyteller_roll(dice = owner.get_total_mentality(), difficulty = (level + 3), numerical = TRUE, mobs_to_show_output = owner, force_chat_result = TRUE)


//------------------------------------------------------------------------------------------------

/datum/discipline_power/thaumaturgy/a_taste_for_blood
	name = "A Taste for Blood"
	desc = "Touch the blood of a subject and gain information about the subject."

	level = 1
	range = 1
	check_flags = DISC_CHECK_FREE_HAND | DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	target_type = TARGET_OBJ
	aggravating = FALSE
	hostile = FALSE
	violates_masquerade = FALSE

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/theft_of_vitae,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

// This'd also should show the last time the blood owner's person last fed, but we dont track that and I frankly dont want to.
/datum/discipline_power/thaumaturgy/a_taste_for_blood/activate(atom/target)
	. = ..()
	var/datum/reagent/blood/blood = target.reagents.has_reagent(/datum/reagent/blood) || target.reagents.has_reagent(/datum/reagent/blood/vitae)
	if(!blood)
		to_chat(owner, span_notice("This blood tastes bland."))
		return

	var/mob/living/carbon/human/blood_owner = blood.data["donor"]
	if(!blood_owner)
		to_chat(owner, span_notice("This blood tastes bland."))
		return

	var/list/message = list()

	if(rand(1, success_count) > 1)
		message += span_notice("The owner of the blood has [blood_owner.bloodpool] blood points left.")
	else
		message += span_notice("The owner of the blood has [rand(1, blood_owner.bloodpool)] blood points left.")

	if(rand(1, success_count) > 2)
		if(iskindred(blood_owner))
			message += span_notice("The blood tastes like a kindred's blood.")
		else
			message += span_danger("The blood doesn't taste like that of a kindred's.")
	else
		message += span_danger("The blood doesn't taste like that of a kindred's.")

	if(rand(1, success_count) > 3)
		if(blood_owner.client.prefs.diablerist)
			message += span_danger("The owner of this blood has commmited the act of Diablerie in their past.")
	else if(success_count <= 0) //Botches.
		message += span_danger("The owner of this blood has commmited the act of Diablerie in their past.")

	if(rand(1, success_count) > 4)
		message += span_notice("This blood tastes like that of the [blood_owner.generation]\th generation.")
	else
		message += span_notice("This blood tastes like that of the [rand(LOWEST_GENERATION_LIMIT, blood_owner.generation)]\th generation.")

	to_chat(owner, boxed_message(jointext(message, "\n")))

//------------------------------------------------------------------------------------------------

/datum/discipline_power/thaumaturgy/blood_rage
	name = "Blood Rage"
	desc = "Impose your will on another Kindred's vitae and force them to spend it as you wish."

	level = 2

	cooldown_length = 2.5 SECONDS

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/theft_of_vitae,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

/datum/discipline_power/thaumaturgy/blood_rage/activate(mob/living/target)
	. = ..()

//------------------------------------------------------------------------------------------------

/datum/discipline_power/thaumaturgy/blood_of_potency
	name = "Blood of Potency"
	desc = "Supernaturally thicken your vitae as if you were of a lower Generation."

	level = 3

	cooldown_length = 1 SECONDS

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/theft_of_vitae,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

/datum/discipline_power/thaumaturgy/blood_of_potency/activate(mob/living/target)
	. = ..()

//------------------------------------------------------------------------------------------------

/datum/discipline_power/thaumaturgy/theft_of_vitae
	name = "Theft of Vitae"
	desc = "Draw your target's blood to you, supernaturally absorbing it as it flies."

	level = 4

	effect_sound = 'code/modules/wod13/sounds/vomit.ogg'

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

/datum/discipline_power/thaumaturgy/theft_of_vitae/activate(mob/living/target)
	. = ..()

//------------------------------------------------------------------------------------------------

//CAULDRON OF BLOOD
/datum/discipline_power/thaumaturgy/cauldron_of_blood
	name = "Cauldron of Blood"
	desc = "Boil your target's blood in their body, killing almost anyone."

	cooldown_length = 15.0 SECONDS
	level = 5

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/theft_of_vitae
	)

/datum/discipline_power/thaumaturgy/cauldron_of_blood/activate(mob/living/target)
	. = ..()
