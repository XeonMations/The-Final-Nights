/mob/proc/swing_attack()
	play_attack_animation(claw = FALSE)
	var/turfs_to_attack = get_nearest_attack_turfs()
	var/attacking_target
	for(var/possible_victim as anything in turfs_to_attack)
		if(istype(possible_victim, /mob/living))
			attacking_target = possible_victim
			break
		if(istype(possible_victim, /obj))
			attacking_target = possible_victim
			break
	
	ClickOn(attacking_target)

// Simple proc for playing an appropriate attack animation
/mob/proc/play_attack_animation(claw)
	if(claw)
		new /obj/effect/temp_visual/dir_setting/claw_effect(get_turf(src), dir)
	else
		new /obj/effect/temp_visual/dir_setting/swing_effect(get_turf(src), dir)
	playsound(loc, 'code/modules/wod13/sounds/swing.ogg', 50, TRUE)

/mob/proc/get_nearest_attack_turfs()
	var/original_turf = get_step(src, dir)
	var/list/turfs = original_turf
	turfs += get_step(original_turf, turn(dir, -90))
	turfs += get_step(original_turf, turn(dir, 90))
	return turfs

