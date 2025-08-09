/datum/status_effect/inspiration
	id = "inspiration"
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/inspiration

/datum/status_effect/inspiration/tick()
	if(stat != DEAD)
		adjustBruteLoss(-10, TRUE)
		var/obj/effect/celerity/C = new(get_turf(src))
		C.appearance = appearance
		C.dir = dir
		var/matrix/ntransform = matrix(C.transform)
		ntransform.Scale(2, 2)
		animate(C, transform = ntransform, alpha = 0, time = 3)
	return ..()

/atom/movable/screen/alert/status_effect/inspiration
	name = "Inspiration"
	desc = "You feel inspired!"
	icon_state = "duskndawn"
