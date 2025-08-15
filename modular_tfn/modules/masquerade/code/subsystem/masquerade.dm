SUBSYSTEM_DEF(masquerade)
	name = "Masquerade"
	init_order = INIT_ORDER_DEFAULT
	wait = 1200
	priority = FIRE_PRIORITY_VERYLOW

	var/masquerade_level = 25

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
	player_breacher.masquerade += 1
	masquerade_level += 1

/datum/controller/subsystem/masquerade/proc/masquerade_breach(datum/source, mob/living/player_breacher)
	player_breacher.masquerade -= 1
	masquerade_level -= 1
