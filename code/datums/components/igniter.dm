/datum/component/igniter
	var/fire_stacks

/datum/component/igniter/Initialize(fire_stacks=1)
	if(!isitem(parent) && !ishostile(parent) && !isgun(parent) && !ismachinery(parent) && !isstructure(parent))
		return COMPONENT_INCOMPATIBLE

	src.fire_stacks = fire_stacks

/datum/component/igniter/RegisterWithParent()
	if(ismachinery(parent) || isstructure(parent) || isgun(parent)) // turrets, etc
		RegisterSignal(parent, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	else if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else if(ishostile(parent))
		RegisterSignal(parent, COMSIG_HOSTILE_POST_ATTACKINGTARGET, PROC_REF(hostile_attackingtarget))

/datum/component/igniter/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_AFTERATTACK, COMSIG_HOSTILE_POST_ATTACKINGTARGET, COMSIG_PROJECTILE_ON_HIT))

/datum/component/igniter/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	SIGNAL_HANDLER

	if(!proximity_flag)
		return
	do_igniter(target)

/datum/component/igniter/proc/hostile_attackingtarget(mob/living/simple_animal/hostile/attacker, atom/target)
	SIGNAL_HANDLER

	do_igniter(target)

/datum/component/igniter/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER

	do_igniter(target)

/datum/component/igniter/proc/do_igniter(atom/target)
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(fire_stacks)
		L.IgniteMob()
