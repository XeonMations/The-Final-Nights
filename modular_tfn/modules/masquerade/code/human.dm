/mob/proc/clear_blood_hunt()
	SSbloodhunt.hunted -= src
	REMOVE_TRAIT(src, TRAIT_HUNTED, "bloodhunt")
	SSbloodhunt.update_alert()
	for(var/player_mob in GLOB.kindred_list)
		to_chat(player_mob, span_bold("The Blood Hunt after <span class='green'>[real_name]</span> is over!"))
		SEND_SOUND(player_mob, sound('code/modules/wod13/sounds/announce.ogg'))
