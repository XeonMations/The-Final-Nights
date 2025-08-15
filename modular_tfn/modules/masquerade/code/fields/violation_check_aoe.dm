/datum/proximity_monitor/advanced/violation_check_aoe
	edge_is_a_field = TRUE
	var/datum/component/violation_observer/violation_observer_callback
	var/list/tracking_mobs

/datum/proximity_monitor/advanced/violation_check_aoe/New(atom/_host, range, _ignore_if_not_on_turf = TRUE, _violation_observer_callback)
	. = ..()
	violation_observer_callback = violation_observer_callback
	tracking_mobs = new()

/datum/proximity_monitor/advanced/violation_check_aoe/Destroy()
	violation_observer_callback = null
	tracking_mobs = null
	return ..()

/datum/proximity_monitor/advanced/violation_check_aoe/on_entered(turf/source, atom/movable/entered, turf/old_loc)
	. = ..()
	if(!isliving(entered))
		return
	if(entered in tracking_mobs)
		return
	tracking_mobs |= entered
	RegisterSignal(entered, COMSIG_MASQUERADE_VIOLATION, PROC_REF(violation_observer_breach_callback))

/datum/proximity_monitor/advanced/violation_check_aoe/on_uncrossed(turf/source, atom/movable/gone, direction)
	. = ..()
	if(!isliving(gone))
		return
	if(!(gone in tracking_mobs))
		return
	tracking_mobs -= gone
	UnregisterSignal(gone, COMSIG_MASQUERADE_VIOLATION)

/datum/proximity_monitor/advanced/violation_check_aoe/proc/violation_observer_breach_callback(mob/living/source)
	SIGNAL_HANDLER

	if(!GLOB.canon_event)
		return
	var/mob/living/host_mob = host
	if(host_mob.incapacitated() || host_mob.stat >= SOFT_CRIT || host_mob.IsSleeping() || host_mob.IsParalyzed())
		return
	if(!isInSight(host_mob, source))
		return
	if(HAS_TRAIT(source, TRAIT_OBFUSCATED))
		return
	if(!CheckZoneMasquerade(host_mob))
		return
	if(!COOLDOWN_FINISHED(source, masquerade_timer))
		return
	COOLDOWN_START(source, masquerade_timer, 10 SECONDS)
	SEND_SIGNAL(host_mob, COMSIG_SEEN_MASQUERADE_VIOLATION, source)
