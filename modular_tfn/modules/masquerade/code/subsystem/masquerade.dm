SUBSYSTEM_DEF(masquerade)
	name = "Masquerade"
	init_order = INIT_ORDER_DEFAULT
	flags = SS_NO_FIRE

	var/masquerade_level = 25
	var/list/masquerade_breachers

/datum/controller/subsystem/masquerade/Initialize()
	masquerade_breachers = new()
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
	return_list += "[masquerade_level]/25"
	return return_list

/datum/controller/subsystem/masquerade/proc/masquerade_reinforce(datum/source, mob/living/player_breacher)
	for(var/masquerade_breach as anything in masquerade_breachers)
		if(source in masquerade_breach)
			masquerade_breachers -= masquerade_breach
			player_breacher.masquerade = min(5, player_breacher.masquerade + 1)
			masquerade_level = min(25, masquerade_level + 1)
	if(player_breacher.masquerade == 5)
		GLOB.masquerade_breakers_list -= player_breacher

/datum/controller/subsystem/masquerade/proc/masquerade_breach(datum/source, mob/living/player_breacher)
	var/temporary_masq_check = player_breacher.masquerade
	player_breacher.masquerade = max(0, player_breacher.masquerade - 1)
	masquerade_breachers += list(list(player_breacher, source))
	GLOB.masquerade_breakers_list |= player_breacher
	if(temporary_masq_check == player_breacher.masquerade) //We're only letting one player tank the masquerade to the max of 5 points
		return
	masquerade_level = max(0, masquerade_level - 1)
