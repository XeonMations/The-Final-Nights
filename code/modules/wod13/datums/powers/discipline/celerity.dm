/datum/discipline/celerity
	name = "Celerity"
	desc = "Boosts your speed. Violates Masquerade."
	icon_state = "celerity"
	power_type = /datum/discipline_power/celerity

/datum/discipline_power/celerity
	name = "Celerity power name"
	desc = "Celerity power description"

	activate_sound = 'code/modules/wod13/sounds/celerity_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/celerity_deactivate.ogg'


/datum/discipline_power/celerity/proc/celerity_visual(datum/discipline_power/celerity/source, atom/newloc, dir)
	SIGNAL_HANDLER

	spawn()
		var/obj/effect/celerity/C = new(owner.loc)
		C.name = owner.name
		C.appearance = owner.appearance
		C.dir = owner.dir
		animate(C, pixel_x = rand(-16, 16), pixel_y = rand(-16, 16), alpha = 0, time = 0.5 SECONDS)
		SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

/datum/discipline_power/celerity/proc/temporis_explode(datum/source, datum/discipline_power/power, atom/target)
	SIGNAL_HANDLER

	if (!istype(power, /datum/discipline_power/temporis/cowalker) && !istype(power, /datum/discipline_power/temporis/clothos_gift))
		return

	to_chat(owner, "<span class='userdanger'>You try to use Temporis, but your active Celerity accelerates your temporal field out of your control!</span>")
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "scream")
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, gib)), 3 SECONDS)

	return POWER_CANCEL_ACTIVATION

/obj/effect/celerity
	name = "Afterimage"
	desc = "..."
	anchored = TRUE

/obj/effect/celerity/Initialize()
	. = ..()
	spawn(0.5 SECONDS)
		qdel(src)

//CELERITY 1
/datum/movespeed_modifier/celerity
	multiplicative_slowdown = -0.5

/datum/discipline_power/celerity/one
	name = "Celerity 1"
	desc = "Enhances your speed to make everything a little bit easier."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five,
		/datum/discipline_power/celerity/six
	)

/datum/discipline_power/celerity/one/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(celerity_visual))

	//put this out of its misery
	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/celerity)
	owner.dexterity += 1

/datum/discipline_power/celerity/one/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/celerity)
	owner.dexterity -= 1

//CELERITY 2
/datum/movespeed_modifier/celerity2
	multiplicative_slowdown = -0.75

/datum/discipline_power/celerity/two
	name = "Celerity 2"
	desc = "Significantly improves your speed and reaction time."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five,
		/datum/discipline_power/celerity/six
	)

/datum/discipline_power/celerity/two/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(celerity_visual))

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/celerity2)
	owner.dexterity += 2

/datum/discipline_power/celerity/two/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/celerity2)
	owner.dexterity -= 2

//CELERITY 3
/datum/movespeed_modifier/celerity3
	multiplicative_slowdown = -1

/datum/discipline_power/celerity/three
	name = "Celerity 3"
	desc = "Move faster. React in less time. Your body is under perfect control."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five,
		/datum/discipline_power/celerity/six
	)

/datum/discipline_power/celerity/three/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(celerity_visual))

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/celerity3)
	owner.dexterity += 3

/datum/discipline_power/celerity/three/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/celerity3)
	owner.dexterity -= 3

//CELERITY 4
/datum/movespeed_modifier/celerity4
	multiplicative_slowdown = -1.25

/datum/discipline_power/celerity/four
	name = "Celerity 4"
	desc = "Breach the limits of what is humanly possible. Move like a lightning bolt."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/five,
		/datum/discipline_power/celerity/six
	)

/datum/discipline_power/celerity/four/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(celerity_visual))

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/celerity4)
	owner.dexterity += 4

/datum/discipline_power/celerity/four/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/celerity4)
	owner.dexterity -= 4

//CELERITY 5
/datum/movespeed_modifier/celerity5
	multiplicative_slowdown = -1.5

/datum/discipline_power/celerity/five
	name = "Celerity 5"
	desc = "You are like light. Blaze your way through the world."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/six
	)

/datum/discipline_power/celerity/five/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(celerity_visual))

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/celerity5)
	owner.dexterity += 5

/datum/discipline_power/celerity/five/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/celerity5)

/datum/discipline_power/celerity/six
	name = "Flawless Parry"
	desc = "Make perfect defensive motions at the expense of taking no other action."

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/six/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))

	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_PERFECT_DEFENCE, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCK_PROJECTILES, MAGIC_TRAIT)

	owner.status_flags |= GODMODE //Temp fix until hands_block_projectiles gets fixed.
	owner.dexterity += 6

	for(var/obj/stuff in owner.contents) //no disarm
		ADD_TRAIT(stuff, TRAIT_NODROP, MAGIC)

/datum/discipline_power/celerity/six/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)

	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_PERFECT_DEFENCE, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCK_PROJECTILES, MAGIC_TRAIT)

	owner.status_flags &= ~GODMODE
	owner.dexterity -= 6

	for(var/obj/stuff in owner.contents)
		REMOVE_TRAIT(stuff, TRAIT_NODROP, MAGIC)
