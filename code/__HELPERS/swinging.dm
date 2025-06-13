/mob/proc/swing_attack()
	var/obj/item/W = get_active_held_item()
	if(!W.force)
		return
	if(W in DirectAccess()) //If we're in an inventory or clicking on a hud object.
		return
	play_attack_animation(claw = FALSE)
	changeNext_move(W.attack_speed)
	var/list/turfs_to_attack = get_nearest_attack_turfs()
	var/list/contents_list = new()
	for(var/turf/turf as anything in turfs_to_attack)
		contents_list += turf.GetAllContents()
	for(var/mob/living/possible_victim in contents_list)
		W.attack(possible_victim, src)
		return

// Simple proc for playing an appropriate attack animation
/mob/proc/play_attack_animation(claw)
	if(claw)
		new /obj/effect/temp_visual/dir_setting/claw_effect(get_turf(src), dir)
	else
		new /obj/effect/temp_visual/dir_setting/swing_effect(get_turf(src), dir)
	playsound(loc, 'code/modules/wod13/sounds/swing.ogg', 50, TRUE)

/mob/proc/get_nearest_attack_turfs()
	var/original_turf = get_open_turf_in_dir(src, dir)
	var/list/turfs = new()
	turfs += original_turf
	turfs += get_open_turf_in_dir(original_turf, turn(dir, -90))
	turfs += get_open_turf_in_dir(original_turf, turn(dir, 90))
	return turfs
