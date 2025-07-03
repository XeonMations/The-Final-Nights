/mob/living/carbon/human/proc/attempt_embrace_target(mob/living/carbon/human/childe)
	if(!childe.can_be_embraced)
		to_chat(src, span_notice("[childe.name] doesn't respond to your Vitae."))
		return
		// If they've been dead for more than 5 minutes, then nothing happens.
	if(childe.mind.damned)
		to_chat(src, span_notice("[childe.name] doesn't respond to your Vitae."))
		return
	if(!((childe.timeofdeath + 5 MINUTES) > world.time))
		to_chat(src, span_notice("[childe] is totally <b>DEAD</b>!"))
		return FALSE

	if(childe.auspice?.level) //here be Abominations
		attempt_abomination_embrace(childe)
	embrace_target(childe)

/mob/living/carbon/human/proc/embrace_target(mob/living/carbon/human/childe)
	log_game("[key_name(src)] has Embraced [key_name(childe)].")
	message_admins("[ADMIN_LOOKUPFLW(src)] has Embraced [ADMIN_LOOKUPFLW(childe)].")
	var/response_v
	if(childe.revive(full_heal = TRUE, admin_revive = TRUE))
		childe.grab_ghost(force = TRUE)
		to_chat(childe, span_userdanger("You rise with a start, you're alive! Or not... You feel your soul going somewhere, as you realize you are embraced by a vampire..."))
		response_v = tgui_input_list(childe, "Do you wish to keep being a vampire on your save slot?(Yes will be a permanent choice and you can't go back!)", "Embrace", list("Yes", "No"), "No")

	childe.set_species(/datum/species/kindred)
	childe.set_clan(clan)
	childe.generation = generation + 1

	childe.skin_tone = get_vamp_skin_color(childe.skin_tone)
	childe.update_body()

	if(prob(5))
		childe.set_clan(/datum/vampire_clan/caitiff)

	if(childe.clan.alt_sprite)
		childe.skin_tone = "albino"
		childe.update_body()

	//Gives the Childe the src's first three Disciplines

	var/list/disciplines_to_give = list()
	for (var/i in 1 to min(3, client.prefs.discipline_types.len))
		disciplines_to_give += client.prefs.discipline_types[i]
	childe.create_disciplines(FALSE, disciplines_to_give)
	// TODO: Rework the max blood pool calculations.
	childe.maxbloodpool = 10+((13-min(13, childe.generation))*3)
	childe.clan.is_enlightened = clan.is_enlightened

	//Verify if they accepted to save being a vampire
	if(response_v != "Yes")
		return
	var/datum/preferences/childe_prefs_v = childe.client.prefs

	childe_prefs_v.pref_species.id = "kindred"
	childe_prefs_v.pref_species.name = "Vampire"
	childe_prefs_v.clan = childe.clan

	childe_prefs_v.skin_tone = get_vamp_skin_color(childe.skin_tone)
	childe_prefs_v.clan.is_enlightened = clan.is_enlightened

	//Rarely the new mid round vampires get the 3 brujah skil(it is default)
	//This will remove if it happens
	// Or if they are a ghoul with abunch of disciplines
	if(childe_prefs_v.discipline_types.len > 0)
		for (var/i in 1 to childe_prefs_v.discipline_types.len)
			var/removing_discipline = childe_prefs_v.discipline_types[1]
			if (removing_discipline)
				var/index = childe_prefs_v.discipline_types.Find(removing_discipline)
				childe_prefs_v.discipline_types.Cut(index, index + 1)
				childe_prefs_v.discipline_levels.Cut(index, index + 1)

	if(childe_prefs_v.discipline_types.len == 0)
		for (var/i in 1 to 3)
			childe_prefs_v.discipline_types += childe_prefs_v.clan.clan_disciplines[i]
			childe_prefs_v.discipline_levels += 1

	childe_prefs_v.save_character()

/mob/living/carbon/human/proc/attempt_abomination_embrace(mob/living/carbon/human/childe)
	if(!(childe.auspice?.level)) //here be Abominations
		return
	if(childe.auspice.force_abomination)
		to_chat(src, span_danger("Something terrible is happening."))
		to_chat(childe, span_userdanger("Gaia has forsaken you."))
		message_admins("[ADMIN_LOOKUPFLW(src)] has turned [ADMIN_LOOKUPFLW(childe)] into an Abomination through an admin setting the force_abomination var.")
		log_game("[key_name(src)] has turned [key_name(childe)] into an Abomination through an admin setting the force_abomination var.")
	else
		switch(SSroll.storyteller_roll(childe.auspice.level))
			if(ROLL_BOTCH)
				to_chat(src, span_danger("Something terrible is happening."))
				to_chat(childe, span_userdanger("Gaia has forsaken you."))
				message_admins("[ADMIN_LOOKUPFLW(src)] has turned [ADMIN_LOOKUPFLW(childe)] into an Abomination.")
				log_game("[key_name(src)] has turned [key_name(childe)] into an Abomination.")
				embrace_target(childe)
				return
			if(ROLL_FAILURE)
				childe.visible_message(span_warning("[childe.name] convulses in sheer agony!"))
				childe.Shake(15, 15, 5 SECONDS)
				playsound(childe.loc, 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE)
				childe.can_be_embraced = FALSE
				return
			if(ROLL_SUCCESS)
				to_chat(src, span_notice("[childe.name] does not respond to your Vitae..."))
				childe.can_be_embraced = FALSE
				return
