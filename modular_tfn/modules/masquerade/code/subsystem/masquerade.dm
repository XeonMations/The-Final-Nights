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

/datum/controller/subsystem/masquerade/proc/masquerade_reinforce(atom/source, mob/living/player_breacher)
	for(var/masquerade_breach as anything in masquerade_breachers)
		if(source in masquerade_breach)
			masquerade_breachers -= list(masquerade_breach)
			masquerade_level = min(MASQUERADE_MAX_LEVEL, masquerade_level + 1)
			player_breacher.masquerade = min(5, player_breacher.masquerade + 1)
	if(player_breacher.masquerade == 5)
		if(isgarou(player_breacher))
			GLOB.veil_breakers_list -= player_breacher
		else
			GLOB.masquerade_breakers_list -= player_breacher

/datum/controller/subsystem/masquerade/proc/masquerade_breach(atom/source, mob/living/player_breacher, reason)
	player_breacher.masquerade = max(0, player_breacher.masquerade - 1)
	masquerade_breachers += list(list(player_breacher, source, reason))
	if(isgarou(player_breacher))
		GLOB.veil_breakers_list |= player_breacher
	else
		GLOB.masquerade_breakers_list |= player_breacher
	if(player_breacher.masquerade <= 0) //We're only letting one player tank the masquerade to the max of 5 points
		return
	masquerade_level = max(0, masquerade_level - 1)

/datum/controller/subsystem/masquerade/proc/log_phone_message(message, obj/phone_source)
	for(var/obj/machinery/logging_machine/logging_machine as anything in GLOB.logging_machines)
		logging_machine.saved_logs += list(list(message, phone_source))
