#define SHADOW_REGEN_RATE 1.5

/obj/effect/proc_holder/spell/targeted/shadowwalk
	name = "Shadow Walk"
	desc = "Grants unlimited movement in darkness."
	charge_max = 0
	clothes_req = FALSE
	antimagic_allowed = TRUE
	phase_allowed = TRUE
	selection_type = "range"
	range = -1
	include_user = TRUE
	cooldown_min = 0
	overlay = null
	action_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	action_icon_state = "ninja_cloak"
	action_background_icon_state = "bg_alien"
	var/activating = FALSE

/obj/effect/proc_holder/spell/targeted/shadowwalk/cast(list/targets,mob/living/user = usr)
	var/L = user.loc

	if(istype(user.loc, /obj/effect/dummy/phased_mob/shadow))
		var/obj/effect/dummy/phased_mob/shadow/S = L
		S.end_jaunt(FALSE)
		return

	//If activated on a dark tile, makes you invisible and lets you phase through walls until you hit a lit up tile
	else
		var/turf/T = get_turf(user)
		var/light_amount = T.get_lumcount()
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			playsound(get_turf(user), 'sound/magic/ethereal_enter.ogg', 50, TRUE, -1)
			visible_message(span_boldwarning("[user] melts into the shadows!"))
			user.SetAllImmobility(0)
			user.setStaminaLoss(0, 0)
			var/obj/effect/dummy/phased_mob/shadow/S2 = new(get_turf(user.loc))
			user.forceMove(S2)
			S2.jaunter = user
		else
			to_chat(user, span_warning("It isn't dark enough here!"))

/obj/effect/dummy/phased_mob/shadow
	var/mob/living/jaunter
	var/last_go = 0

/obj/effect/dummy/phased_mob/shadow/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/dummy/phased_mob/shadow/Destroy()
	jaunter = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/dummy/phased_mob/shadow/process(delta_time)
//	var/turf/T = get_turf(src)
//	var/light_amount = T.get_lumcount()
	if(!jaunter || jaunter.loc != src)
		qdel(src)
//	if (light_amount < 0.2 && (!QDELETED(jaunter))) //heal in the dark
//		jaunter.heal_overall_damage((SHADOW_REGEN_RATE * delta_time), (SHADOW_REGEN_RATE * delta_time), 0, BODYPART_ORGANIC)
	check_light_level()


/obj/effect/dummy/phased_mob/shadow/relaymove(mob/living/user, direction)
	if(last_go+2 > world.time)
		return
	last_go = world.time
	var/turf/oldloc = loc
	. = ..()
	if(loc != oldloc)
		if(!check_light_level())
			user.forceMove(oldloc)

/obj/effect/dummy/phased_mob/shadow/phased_check(mob/living/user, direction)
	. = ..()
	if(. && isspaceturf(.))
		to_chat(user, span_warning("It really would not be wise to go into space."))
		return FALSE

/obj/effect/dummy/phased_mob/shadow/proc/check_light_level()
	var/turf/T = get_turf(src)
	var/light_amount = T.get_lumcount()
	if(light_amount > 0.2) // jaunt ends
		end_jaunt(TRUE)
		return FALSE
	else
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.name == "San Francisco")
				end_jaunt(TRUE)
				return FALSE
		else
			end_jaunt(TRUE)
			return FALSE
	return TRUE

/obj/effect/dummy/phased_mob/shadow/proc/end_jaunt(forced = FALSE)
	if(jaunter)
		if(forced)
			visible_message(span_boldwarning("[jaunter] is revealed by the light!"))
		else
			visible_message(span_boldwarning("[jaunter] emerges from the darkness!"))
		playsound(loc, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	qdel(src)


#undef SHADOW_REGEN_RATE
