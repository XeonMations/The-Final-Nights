//Base mummy subtype. Used by all the mummy subtypes for special shenanigens.
/datum/species/human/mummy
	name = "Mummy"
	id = "mummy"
	selectable = FALSE
	whitelisted = TRUE

/datum/species/human/mummy/on_species_gain(mob/living/carbon/human/C)
	. = ..()
	var/datum/discipline/mummy_revival/revival_discipline = new()
	C.give_discipline(revival_discipline)


/datum/species/human/mummy/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()

/datum/discipline/mummy_revival
	name = "REPORT TO CODERBUS IF SEEN"
	desc = "REPORT TO CODERBUS IF SEEN"
	icon_state = "auspex"
	power_type = /datum/discipline_power/mummy_revival

/datum/discipline_power/mummy_revival
	name = "mummy_revival"
	desc = ""

	activate_sound = 'code/modules/wod13/sounds/auspex.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/auspex_deactivate.ogg'

	level = 1
	check_flags = DISC_CHECK_TORPORED
	vitae_cost = 0
	grouped_powers = list(
		/datum/discipline_power/mummy_revival/chaskimallki,
		/datum/discipline_power/mummy_revival/intimallki,
		/datum/discipline_power/mummy_revival/pachamallki,
		/datum/discipline_power/mummy_revival/uchumallki
	)

/datum/discipline_power/mummy_revival/activate()






/datum/discipline/mummy/sting_action(mob/living/user)
	..()
	if(revive_ready)
		INVOKE_ASYNC(src, PROC_REF(revive), user)
		revive_ready = FALSE
		name = "Reviving Stasis"
		desc = "We fall into a stasis, allowing us to regenerate and trick our enemies."
		button_icon_state = "fake_death"
		UpdateButtonIcon()
		to_chat(user, "<span class='notice'>We have revived ourselves.</span>")
	else
		to_chat(user, "<span class='notice'>We begin our stasis, preparing energy to arise once more.</span>")
		user.fakedeath("changeling") //play dead
		addtimer(CALLBACK(src, PROC_REF(ready_to_regenerate), user), LING_FAKEDEATH_TIME, TIMER_UNIQUE)
	return TRUE

/datum/discipline/mummy/proc/revive(mob/living/user)
	if(!user || !istype(user))
		return
	user.cure_fakedeath("changeling")
	user.revive(full_heal = TRUE, admin_revive = FALSE)
	var/list/missing = user.get_missing_limbs()
	missing -= BODY_ZONE_HEAD // headless changelings are funny
	if(missing.len)
		playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)
		user.visible_message("<span class='warning'>[user]'s missing limbs \
			reform, making a loud, grotesque sound!</span>",
			"<span class='userdanger'>Your limbs regrow, making a \
			loud, crunchy sound and giving you great pain!</span>",
			"<span class='hear'>You hear organic matter ripping \
			and tearing!</span>")
		user.emote("scream")
		user.regenerate_limbs(0, list(BODY_ZONE_HEAD))
	user.regenerate_organs()

/datum/discipline/mummy/proc/ready_to_regenerate(mob/user)
	if(user?.mind)
		var/datum/antagonist/changeling/C = user.mind.has_antag_datum(/datum/antagonist/changeling)
		if(C?.purchasedpowers)
			to_chat(user, "<span class='notice'>We are ready to revive.</span>")
			name = "Revive"
			desc = "We arise once more."
			button_icon_state = "revive"
			UpdateButtonIcon()
			chemical_cost = 0
			revive_ready = TRUE
