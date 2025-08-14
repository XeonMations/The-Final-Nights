// Used for things that detect masquerade violations.
// Usually NPCs or cameras.
/datum/component/violation_observer
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/proximity_monitor/advanced/violation_check_aoe/area_of_effect
	/// Time between us checking for violations
	COOLDOWN_DECLARE(scan_cooldown)

/datum/component/violation_observer/Initialize()
	area_of_effect = new(parent, 7)

/datum/component/violation_observer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_SEEN_MASQUERADE_VIOLATION, PROC_REF(on_observed_violation))

/datum/component/violation_observer/UnregisterFromParent(force, silent)
	QDEL_NULL(area_of_effect)
	UnregisterSignal(parent, COMSIG_SEEN_MASQUERADE_VIOLATION)

/datum/component/violation_observer/proc/on_observed_violation(datum/source, datum/player_breacher)
	SIGNAL_HANDLER

	to_chat(world, span_alertwarning("[source] observed a masquerade breach!"))
	var/atom/atom_parent = source
	if(isliving(atom_parent))
		var/mob/living/mob_parent = source
		if(!mob_parent.incapacitated(ignore_restraints = 1))
			mob_parent.face_atom(player_breacher)
	atom_parent.do_alert_animation()
	playsound(parent, 'code/modules/wod13/sounds/snake.ogg', 50, FALSE, -5)
