GLOBAL_LIST_EMPTY(npc_spawn_points)
SUBSYSTEM_DEF(humannpcpool)
	name = "Human NPC Pool"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_VERYLOW
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 30

	var/list/currentrun = list()
	var/npc_max = 220

/datum/controller/subsystem/humannpcpool/stat_entry(msg)
	var/list/activelist = GLOB.npc_list
	var/list/living_list = GLOB.alive_npc_list
	msg = "NPCS:[length(activelist)] Living: [length(living_list)]"
	return ..()

/datum/controller/subsystem/humannpcpool/fire(resumed = FALSE)

	if (!resumed)
		var/list/activelist = GLOB.npc_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/carbon/human/npc/NPC = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(NPC)) // Some issue causes nulls to get into this list some times. This keeps it running, but the bug is still there.
			GLOB.npc_list -= NPC		//HUH??? A BUG? NO WAY
			GLOB.alive_npc_list -= NPC
			log_world("Found a null in npc list!")
			continue

		//!NPC.route_optimisation()
		if(MC_TICK_CHECK)
			return
		NPC.handle_automated_movement()

/datum/controller/subsystem/humannpcpool/proc/npclost()
	while(length(GLOB.alive_npc_list) < npc_max)
		var/atom/kal
		if(length(GLOB.npc_spawn_points) > 0)
			kal = pick(GLOB.npc_spawn_points)
		var/NEPIS = pick(/mob/living/carbon/human/npc/police, /mob/living/carbon/human/npc/bandit, /mob/living/carbon/human/npc/hobo, /mob/living/carbon/human/npc/walkby, /mob/living/carbon/human/npc/business)
		new NEPIS(get_turf(kal))

