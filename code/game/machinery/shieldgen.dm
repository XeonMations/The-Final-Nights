/obj/structure/emergency_shield
	name = "emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = TRUE
	move_resist = INFINITY
	opacity = FALSE
	anchored = TRUE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	max_integrity = 200 //The shield can only take so much beating (prevents perma-prisons)

/obj/structure/emergency_shield/Initialize()
	. = ..()
	setDir(pick(GLOB.cardinals))

/obj/structure/emergency_shield/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			take_damage(50, BRUTE, ENERGY, 0)

/obj/structure/emergency_shield/play_attack_sound(damage, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BURN)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)
		if(BRUTE)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)

/obj/structure/emergency_shield/take_damage(damage, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage was dealt
		new /obj/effect/temp_visual/impact_effect/ion(loc)


/obj/structure/emergency_shield/cult
	name = "cult barrier"
	desc = "A shield summoned by cultists to keep heretics away."
	max_integrity = 100
	icon_state = "shield-red"

/obj/structure/emergency_shield/cult/emp_act(severity)
	return

/obj/structure/emergency_shield/cult/narsie
	name = "sanguine barrier"
	desc = "A potent shield summoned by cultists to defend their rites."
	max_integrity = 60

/obj/structure/emergency_shield/cult/weak
	name = "Invoker's Shield"
	desc = "A weak shield summoned by cultists to protect them while they carry out delicate rituals."
	color = "#FF0000"
	max_integrity = 20
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER

/obj/structure/emergency_shield/cult/barrier
	density = FALSE //toggled on right away by the parent rune
	///The rune that created the shield itself. Used to delete the rune when the shield is destroyed.
	var/obj/effect/rune/parent_rune

/obj/structure/emergency_shield/cult/barrier/attack_hand(mob/living/user, list/modifiers)
	parent_rune.attack_hand(user, modifiers)

/obj/structure/emergency_shield/cult/barrier/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if(iscultist(user))
		parent_rune.attack_animal(user)
	else
		..()

/obj/structure/emergency_shield/cult/barrier/Destroy()
	if(parent_rune)
		parent_rune.visible_message("<span class='danger'>The [parent_rune] fades away as [src] is destroyed!</span>")
		QDEL_NULL(parent_rune)
	return ..()

/**
*Turns the shield on and off.
*
*The shield has 2 states: on and off. When on, it will block movement,projectiles, items, etc. and be clearly visible, and block atmospheric gases.
*When off, the rune no longer blocks anything and turns invisible.
*The barrier itself is not intended to interact with the conceal runes cult spell for balance purposes.
*/
/obj/structure/emergency_shield/cult/barrier/proc/Toggle()
	density = !density
	invisibility = initial(invisibility)
	if(!density)
		invisibility = INVISIBILITY_OBSERVER

/obj/machinery/shieldgen
	name = "anti-breach shielding projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	req_access = list(ACCESS_ENGINE)
	max_integrity = 100
	var/active = FALSE
	var/list/deployed_shields
	var/locked = FALSE
	var/shield_range = 4

/obj/machinery/shieldgen/Initialize(mapload)
	. = ..()
	deployed_shields = list()
	if(mapload && active && anchored)
		shields_up()

/obj/machinery/shieldgen/Destroy()
	QDEL_LIST(deployed_shields)
	return ..()


/obj/machinery/shieldgen/proc/shields_up()
	active = TRUE
	update_appearance()
	move_resist = INFINITY

	for(var/turf/target_tile in range(shield_range, src))
		if(isspaceturf(target_tile) && !(locate(/obj/structure/emergency_shield) in target_tile))
			if(!(machine_stat & BROKEN) || prob(33))
				deployed_shields += new /obj/structure/emergency_shield(target_tile)

/obj/machinery/shieldgen/proc/shields_down()
	active = FALSE
	move_resist = initial(move_resist)
	update_appearance()
	QDEL_LIST(deployed_shields)

/obj/machinery/shieldgen/process(delta_time)
	if((machine_stat & BROKEN) && active)
		if(deployed_shields.len && DT_PROB(2.5, delta_time))
			qdel(pick(deployed_shields))


/obj/machinery/shieldgen/deconstruct(disassembled = TRUE)
	atom_break()
	locked = pick(0,1)

/obj/machinery/shieldgen/interact(mob/user)
	. = ..()
	if(.)
		return
	if(locked && !issilicon(user))
		to_chat(user, "<span class='warning'>The machine is locked, you are unable to use it!</span>")
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>The panel must be closed before operating this machine!</span>")
		return

	if (active)
		user.visible_message("<span class='notice'>[user] deactivated \the [src].</span>", \
			"<span class='notice'>You deactivate \the [src].</span>", \
			"<span class='hear'>You hear heavy droning fade out.</span>")
		shields_down()
	else
		if(anchored)
			user.visible_message("<span class='notice'>[user] activated \the [src].</span>", \
				"<span class='notice'>You activate \the [src].</span>", \
				"<span class='hear'>You hear heavy droning.</span>")
			shields_up()
		else
			to_chat(user, "<span class='warning'>The device must first be secured to the floor!</span>")
	return

/obj/machinery/shieldgen/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		W.play_tool_sound(src, 100)
		panel_open = !panel_open
		if(panel_open)
			to_chat(user, "<span class='notice'>You open the panel and expose the wiring.</span>")
		else
			to_chat(user, "<span class='notice'>You close the panel.</span>")
	else if(istype(W, /obj/item/stack/cable_coil) && (machine_stat & BROKEN) && panel_open)
		var/obj/item/stack/cable_coil/coil = W
		if (coil.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one length of cable to repair [src]!</span>")
			return
		to_chat(user, "<span class='notice'>You begin to replace the wires...</span>")
		if(do_after(user, 30, target = src))
			if(coil.get_amount() < 1)
				return
			coil.use(1)
			atom_integrity = max_integrity
			set_machine_stat(machine_stat & ~BROKEN)
			to_chat(user, "<span class='notice'>You repair \the [src].</span>")
			update_appearance()

	else if(W.tool_behaviour == TOOL_WRENCH)
		if(locked)
			to_chat(user, "<span class='warning'>The bolts are covered! Unlocking this would retract the covers.</span>")
			return
		if(!anchored && !isinspace())
			W.play_tool_sound(src, 100)
			to_chat(user, "<span class='notice'>You secure \the [src] to the floor!</span>")
			set_anchored(TRUE)
		else if(anchored)
			W.play_tool_sound(src, 100)
			to_chat(user, "<span class='notice'>You unsecure \the [src] from the floor!</span>")
			if(active)
				to_chat(user, "<span class='notice'>\The [src] shuts off!</span>")
				shields_down()
			set_anchored(FALSE)

	else if(W.GetID())
		if(allowed(user) && !(obj_flags & EMAGGED))
			locked = !locked
			to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] the controls.</span>")
		else if(obj_flags & EMAGGED)
			to_chat(user, "<span class='danger'>Error, access controller damaged!</span>")
		else
			to_chat(user, "<span class='danger'>Access denied.</span>")

	else
		return ..()

/obj/machinery/shieldgen/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		to_chat(user, "<span class='warning'>The access controller is damaged!</span>")
		return
	obj_flags |= EMAGGED
	locked = FALSE
	playsound(src, "sparks", 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(user, "<span class='warning'>You short out the access controller.</span>")

/obj/machinery/shieldgen/update_icon_state()
	icon_state = "shield[active ? "on" : "off"][(machine_stat & BROKEN) ? "br" : null]"
	return ..()

#define ACTIVE_SETUPFIELDS 1
#define ACTIVE_HASFIELDS 2
/obj/machinery/power/shieldwallgen
	name = "shield wall generator"
	desc = "A shield generator."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "shield_wall_gen"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_TELEPORTER)
	flags_1 = CONDUCT_1
	use_power = NO_POWER_USE
	idle_power_usage = 10
	active_power_usage = 50
	max_integrity = 300
	var/active = FALSE
	var/locked = TRUE
	var/shield_range = 8
	var/obj/structure/cable/attached // the attached cable

/obj/machinery/power/shieldwallgen/xenobiologyaccess		//use in xenobiology containment
	name = "xenobiology shield wall generator"
	desc = "A shield generator meant for use in xenobiology."
	req_access = list(ACCESS_XENOBIOLOGY)

/obj/machinery/power/shieldwallgen/anchored
	anchored = TRUE

/obj/machinery/power/shieldwallgen/Initialize()
	. = ..()
	if(anchored)
		connect_to_network()
	RegisterSignal(src, COMSIG_ATOM_SINGULARITY_TRY_MOVE, PROC_REF(block_singularity_if_active))

/obj/machinery/power/shieldwallgen/Destroy()
	for(var/d in GLOB.cardinals)
		cleanup_field(d)
	return ..()

/obj/machinery/power/shieldwallgen/should_have_node()
	return anchored

/obj/machinery/power/shieldwallgen/connect_to_network()
	if(!anchored)
		return FALSE
	. = ..()

/obj/machinery/power/shieldwallgen/process()
	if(active)
		icon_state = "shield_wall_gen_on"
		if(active == ACTIVE_SETUPFIELDS)
			var/fields = 0
			for(var/d in GLOB.cardinals)
				if(setup_field(d))
					fields++
			if(fields)
				active = ACTIVE_HASFIELDS
		if(!active_power_usage || surplus() >= active_power_usage)
			add_load(active_power_usage)
		else
			visible_message("<span class='danger'>The [src.name] shuts down due to lack of power!</span>", \
				"If this message is ever seen, something is wrong.",
				"<span class='hear'>You hear heavy droning fade out.</span>")
			icon_state = "shield_wall_gen"
			active = FALSE
			log_game("[src] deactivated due to lack of power at [AREACOORD(src)]")
			for(var/d in GLOB.cardinals)
				cleanup_field(d)
	else
		icon_state = "shield_wall_gen"
		for(var/d in GLOB.cardinals)
			cleanup_field(d)

/// Constructs the actual field walls in the specified direction, cleans up old/stuck shields before doing so
/obj/machinery/power/shieldwallgen/proc/setup_field(direction)
	if(!direction)
		return

	var/turf/T = loc
	var/obj/machinery/power/shieldwallgen/G
	var/steps = 0
	var/opposite_direction = turn(direction, 180)

	for(var/i in 1 to shield_range) //checks out to 8 tiles away for another generator
		T = get_step(T, direction)
		G = locate(/obj/machinery/power/shieldwallgen) in T
		if(G)
			if(!G.active)
				return
			G.cleanup_field(opposite_direction)
			break
		else
			steps++

	if(!G || !steps) //no shield gen or no tiles between us and the gen
		return

	for(var/i in 1 to steps) //creates each field tile
		T = get_step(T, opposite_direction)
		new/obj/machinery/shieldwall(T, src, G)
	return TRUE

/// cleans up fields in the specified direction if they belong to this generator
/obj/machinery/power/shieldwallgen/proc/cleanup_field(direction)
	var/obj/machinery/shieldwall/F
	var/obj/machinery/power/shieldwallgen/G
	var/turf/T = loc

	for(var/i in 1 to shield_range)
		T = get_step(T, direction)

		G = (locate(/obj/machinery/power/shieldwallgen) in T)
		if(G && !G.active)
			break

		F = (locate(/obj/machinery/shieldwall) in T)
		if(F && (F.gen_primary == src || F.gen_secondary == src)) //it's ours, kill it.
			qdel(F)

/obj/machinery/power/shieldwallgen/proc/block_singularity_if_active()
	SIGNAL_HANDLER

	if (active)
		return SINGULARITY_TRY_MOVE_BLOCK

/obj/machinery/power/shieldwallgen/can_be_unfasten_wrench(mob/user, silent)
	if(active)
		if(!silent)
			to_chat(user, "<span class='warning'>Turn off the shield generator first!</span>")
		return FAILED_UNFASTEN
	return ..()


/obj/machinery/power/shieldwallgen/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	. |= default_unfasten_wrench(user, I, 0)
	var/turf/T = get_turf(src)
	update_cable_icons_on_turf(T)
	if(. == SUCCESSFUL_UNFASTEN && anchored)
		connect_to_network()


/obj/machinery/power/shieldwallgen/attackby(obj/item/W, mob/user, params)
	if(W.GetID())
		if(allowed(user) && !(obj_flags & EMAGGED))
			locked = !locked
			to_chat(user, "<span class='notice'>You [src.locked ? "lock" : "unlock"] the controls.</span>")
		else if(obj_flags & EMAGGED)
			to_chat(user, "<span class='danger'>Error, access controller damaged!</span>")
		else
			to_chat(user, "<span class='danger'>Access denied.</span>")

	else
		add_fingerprint(user)
		return ..()

/obj/machinery/power/shieldwallgen/interact(mob/user)
	. = ..()
	if(.)
		return
	if(!anchored)
		to_chat(user, "<span class='warning'>\The [src] needs to be firmly secured to the floor first!</span>")
		return
	if(locked && !issilicon(user))
		to_chat(user, "<span class='warning'>The controls are locked!</span>")
		return
	if(!powernet)
		to_chat(user, "<span class='warning'>\The [src] needs to be powered by a wire!</span>")
		return

	if(active)
		user.visible_message("<span class='notice'>[user] turned \the [src] off.</span>", \
			"<span class='notice'>You turn off \the [src].</span>", \
			"<span class='hear'>You hear heavy droning fade out.</span>")
		active = FALSE
		log_game("[src] was deactivated by [key_name(user)] at [AREACOORD(src)]")
	else
		user.visible_message("<span class='notice'>[user] turned \the [src] on.</span>", \
			"<span class='notice'>You turn on \the [src].</span>", \
			"<span class='hear'>You hear heavy droning.</span>")
		active = ACTIVE_SETUPFIELDS
		log_game("[src] was activated by [key_name(user)] at [AREACOORD(src)]")
	add_fingerprint(user)

/obj/machinery/power/shieldwallgen/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		to_chat(user, "<span class='warning'>The access controller is damaged!</span>")
		return
	obj_flags |= EMAGGED
	locked = FALSE
	playsound(src, "sparks", 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(user, "<span class='warning'>You short out the access controller.</span>")

//////////////Containment Field START
/obj/machinery/shieldwall
	name = "shield wall"
	desc = "An energy shield."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	light_range = 3
	var/needs_power = FALSE
	var/obj/machinery/power/shieldwallgen/gen_primary
	var/obj/machinery/power/shieldwallgen/gen_secondary

/obj/machinery/shieldwall/Initialize(mapload, obj/machinery/power/shieldwallgen/first_gen, obj/machinery/power/shieldwallgen/second_gen)
	. = ..()
	gen_primary = first_gen
	gen_secondary = second_gen
	if(gen_primary && gen_secondary)
		needs_power = TRUE
		setDir(get_dir(gen_primary, gen_secondary))
	for(var/mob/living/L in get_turf(src))
		visible_message("<span class='danger'>\The [src] is suddenly occupying the same space as \the [L]!</span>")
		L.gib()
	RegisterSignal(src, COMSIG_ATOM_SINGULARITY_TRY_MOVE, PROC_REF(block_singularity))

/obj/machinery/shieldwall/Destroy()
	gen_primary = null
	gen_secondary = null
	return ..()

/obj/machinery/shieldwall/process()
	if(needs_power)
		if(!gen_primary || !gen_primary.active || !gen_secondary || !gen_secondary.active)
			qdel(src)
			return

		drain_power(10)

/obj/machinery/shieldwall/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BURN)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)
		if(BRUTE)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)

//the shield wall is immune to damage but it drains the stored power of the generators.
/obj/machinery/shieldwall/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(damage_type == BRUTE || damage_type == BURN)
		drain_power(damage_amount)

/// succs power from the connected shield wall generator
/obj/machinery/shieldwall/proc/drain_power(drain_amount)
	if(needs_power && gen_primary)
		gen_primary.add_load(drain_amount * 0.5)
		if(gen_secondary) //using power may cause us to be destroyed
			gen_secondary.add_load(drain_amount * 0.5)

/obj/machinery/shieldwall/proc/block_singularity()
	SIGNAL_HANDLER

	return SINGULARITY_TRY_MOVE_BLOCK

/obj/machinery/shieldwall/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return prob(20)
	else
		if(istype(mover, /obj/projectile))
			return prob(10)

#undef ACTIVE_SETUPFIELDS
#undef ACTIVE_HASFIELDS
