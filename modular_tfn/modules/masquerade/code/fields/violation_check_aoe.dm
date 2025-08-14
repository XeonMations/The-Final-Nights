/datum/proximity_monitor/advanced/violation_check_aoe
	edge_is_a_field = TRUE
	var/datum/component/violation_observer/violation_observer_callback

/datum/proximity_monitor/advanced/violation_check_aoe/New(atom/_host, range, _ignore_if_not_on_turf = TRUE, _violation_observer_callback)
	. = ..()
	violation_observer_callback = violation_observer_callback

/datum/proximity_monitor/advanced/violation_check_aoe/Destroy()
	violation_observer_callback = null
	return ..()

/datum/proximity_monitor/advanced/violation_check_aoe/field_turf_crossed(atom/movable/movable, turf/old_location, turf/new_location)
	RegisterSignal(movable, COMSIG_MASQUERADE_VIOLATION, PROC_REF(violation_observer_breach_callback))

/datum/proximity_monitor/advanced/violation_check_aoe/field_turf_uncrossed(atom/movable/movable, turf/old_location, turf/new_location)
	UnregisterSignal(movable, COMSIG_MASQUERADE_VIOLATION)

/datum/proximity_monitor/advanced/violation_check_aoe/proc/violation_observer_breach_callback(datum/source)
	SIGNAL_HANDLER

	SEND_SIGNAL(host, COMSIG_SEEN_MASQUERADE_VIOLATION, source)
