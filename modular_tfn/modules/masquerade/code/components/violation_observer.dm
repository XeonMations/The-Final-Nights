// Used for things that detect masquerade violations.
// Usually NPCs or cameras.
/datum/component/violation_observer
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/proximity_monitor/advanced/violation_check_aoe/area_of_effect
	/// Time between us checking for violations
	COOLDOWN_DECLARE(scan_cooldown)
	var/breached_player

/datum/component/violation_observer/Initialize()
	area_of_effect = new(parent, 7)

/datum/component/violation_observer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_SEEN_MASQUERADE_VIOLATION, PROC_REF(on_observed_violation))

/datum/component/violation_observer/UnregisterFromParent(force, silent)
	QDEL_NULL(area_of_effect)
	breached_player = null
	UnregisterSignal(parent, COMSIG_SEEN_MASQUERADE_VIOLATION)
	UnregisterSignal(parent, COMSIG_MASQUERADE_REINFORCE)
	UnregisterSignal(parent, COMSIG_LIVING_DEATH)

/datum/component/violation_observer/proc/on_observed_violation(datum/source, mob/living/player_breacher)
	SIGNAL_HANDLER

	var/atom/atom_parent = source
	if(isliving(atom_parent))
		var/mob/living/mob_parent = source
		if(!mob_parent.incapacitated(ignore_restraints = 1))
			mob_parent.face_atom(player_breacher)
	atom_parent.do_alert_animation()
	playsound(player_breacher, 'modular_tfn/modules/masquerade/sound/masquerade_violation.ogg', 50, FALSE, -5)
	to_chat(player_breacher, span_userdanger("Masquerade breach!"))
	atom_parent.AddComponent(/datum/component/masquerade_hud, player_breacher)
	RegisterSignal(atom_parent, COMSIG_MASQUERADE_REINFORCE, PROC_REF(on_masquerade_violation_reinforced))
	RegisterSignal(atom_parent, COMSIG_LIVING_DEATH, PROC_REF(on_masquerade_violation_reinforced))
	breached_player = player_breacher
	SSmasquerade.masquerade_breach(source, player_breacher)

/datum/component/violation_observer/proc/on_masquerade_violation_reinforced(mob/living/source)
	SIGNAL_HANDLER

	SEND_SIGNAL(source, COMSIG_MASQUERADE_HUD_DELETE)
	SSmasquerade.masquerade_reinforce(source, breached_player)
	to_chat(breached_player, span_nicegreen("Masquerade reinforced!"))
	playsound(breached_player, 'modular_tfn/modules/masquerade/sound/masquerade_reinforce.ogg', 50, FALSE, -5)
