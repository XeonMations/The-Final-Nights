SUBSYSTEM_DEF(masquerade)
	name = "Masquerade"
	init_order = INIT_ORDER_DEFAULT
	flags = SS_NO_FIRE

	var/masquerade_level = MASQUERADE_MAX_LEVEL
	var/list/masquerade_breachers
	var/static/regex/masquerade_breaching_phrase_regex

/datum/controller/subsystem/masquerade/Initialize()
	masquerade_breachers = new()
	var/list/masquerade_filter = list()
	for(var/line in world.file2list("modular_tfn/modules/masquerade/config/breach_word.txt"))
		if(!line)
			continue
		masquerade_filter += REGEX_QUOTE(line)
	masquerade_breaching_phrase_regex = masquerade_filter.len ? regex("\\b([jointext(masquerade_filter, "|")])\\b", "i") : null
	..()

// Used for the status menu's masquerade breach text.
/datum/controller/subsystem/masquerade/proc/get_description()
	var/return_list = ""
	switch(masquerade_level)
		if(0 to 9)
			return_list += "MASSIVE BREACH: "
		if(10 to 14)
			return_list += "MODERATE VIOLATION: "
		if(15 to 20)
			return_list += "SUSPICIOUS: "
		else
			return_list += "STABLE: "
	return_list += "[masquerade_level]/[MASQUERADE_MAX_LEVEL]"
	return return_list

/*
 / Reinforces a specific player's masquerade and changes the global masquerade level accordingly.
 /
 / source - The object or mob that saw the masquerade breach.
 / player_breacher - The player which caused the masquerade breach.
 / reason - Optional, the reason for the breach. For example,
*/
/datum/controller/subsystem/masquerade/proc/masquerade_reinforce(atom/source, mob/living/player_breacher, reason)
	for(var/masquerade_breach as anything in masquerade_breachers)
		if((source in masquerade_breach) && (reason in masquerade_breach))
			masquerade_breachers -= list(masquerade_breach)
			masquerade_level = min(MASQUERADE_MAX_LEVEL, masquerade_level + 1)
			player_breacher.masquerade_score = min(5, player_breacher.masquerade_score + 1)
	if(player_breacher.masquerade_score == 5)
		if(isgarou(player_breacher))
			GLOB.veil_breakers_list -= player_breacher
		else
			GLOB.masquerade_breakers_list -= player_breacher
	save_persistent_masquerade(player_breacher)

/*
 / Breaches a specific player's masquerade and changes the global masquerade level accordingly.
 /
 / source - The object or mob that saw the masquerade breach.
 / player_breacher - The player which caused the masquerade breach.
 / reason - The reason for the breach. For example,
*/
/datum/controller/subsystem/masquerade/proc/masquerade_breach(atom/source, mob/living/player_breacher, reason)
	player_breacher.masquerade_score = max(0, player_breacher.masquerade_score - 1)
	masquerade_breachers += list(list(player_breacher, source, reason))
	if(isgarou(player_breacher))
		GLOB.veil_breakers_list |= player_breacher
	else
		GLOB.masquerade_breakers_list |= player_breacher
	masquerade_level = max(0, masquerade_level - 1)
	save_persistent_masquerade(player_breacher)

// Used for adding logging messages to every logging_machine in GLOB.loggin_machines
/datum/controller/subsystem/masquerade/proc/log_phone_message(message, obj/phone_source)
	for(var/obj/machinery/logging_machine/logging_machine as anything in GLOB.logging_machines)
		logging_machine.saved_logs += list(list(message, phone_source))

// Save the player's masquerade level to their character sheet.
/datum/controller/subsystem/masquerade/proc/save_persistent_masquerade(mob/living/player_breacher)
	var/datum/preferences/preferences = GLOB.preferences_datums[ckey(player_breacher.key)]
	if(preferences)
		preferences.masquerade_score = player_breacher.masquerade_score
		preferences.save_character()
