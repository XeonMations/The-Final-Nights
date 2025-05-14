/obj/machinery/biogenerator
	name = "biogenerator"
	desc = "Converts plants into biomass, which can be used to construct useful items."
	icon = 'icons/obj/machines/biogenerator.dmi'
	icon_state = "biogen-empty"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	circuit = /obj/item/circuitboard/machine/biogenerator
	var/processing = FALSE
	var/obj/item/reagent_containers/glass/beaker = null
	var/points = 0
	var/efficiency = 0
	var/productivity = 0
	var/max_items = 40
	var/list/show_categories = list("Food", "Botany Chemicals", "Organic Materials")
	/// Currently selected category in the UI
	var/selected_cat

/obj/machinery/biogenerator/Destroy()
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/biogenerator/contents_explosion(severity, target)
	..()
	if(beaker)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += beaker
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += beaker
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += beaker

/obj/machinery/biogenerator/handle_atom_del(atom/A)
	..()
	if(A == beaker)
		beaker = null
		update_appearance()

/obj/machinery/biogenerator/RefreshParts()
	var/E = 0
	var/P = 0
	var/max_storage = 40
	efficiency = E
	productivity = P
	max_items = max_storage

/obj/machinery/biogenerator/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Productivity at <b>[productivity*100]%</b>.<br>Matter consumption reduced by <b>[(efficiency*25)-25]</b>%.<br>Machine can hold up to <b>[max_items]</b> pieces of produce.</span>"

/obj/machinery/biogenerator/update_icon_state()
	if(panel_open)
		icon_state = "biogen-empty-o"
		return ..()
	if(!beaker)
		icon_state = "biogen-empty"
		return ..()
	if(!processing)
		icon_state = "biogen-stand"
		return ..()
	icon_state = "biogen-work"
	return ..()

/obj/machinery/biogenerator/attackby(obj/item/O, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(processing)
		to_chat(user, "<span class='warning'>The biogenerator is currently processing.</span>")
		return

	if(default_deconstruction_screwdriver(user, "biogen-empty-o", "biogen-empty", O))
		if(beaker)
			var/obj/item/reagent_containers/glass/B = beaker
			B.forceMove(drop_location())
			beaker = null
		update_appearance()
		return

	if(default_deconstruction_crowbar(O))
		return

	if(istype(O, /obj/item/reagent_containers/glass))
		. = 1 //no afterattack
		if(!panel_open)
			if(beaker)
				to_chat(user, "<span class='warning'>A container is already loaded into the machine.</span>")
			else
				if(!user.transferItemToLoc(O, src))
					return
				beaker = O
				to_chat(user, "<span class='notice'>You add the container to the machine.</span>")
				update_appearance()
		else
			to_chat(user, "<span class='warning'>Close the maintenance panel first.</span>")
		return

	else if(istype(O, /obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/PB = O
		var/i = 0
		for(var/obj/item/food/grown/G in contents)
			i++
		if(i >= max_items)
			to_chat(user, "<span class='warning'>The biogenerator is already full! Activate it.</span>")
		else
			for(var/obj/item/food/grown/G in PB.contents)
				if(i >= max_items)
					break
				if(SEND_SIGNAL(PB, COMSIG_TRY_STORAGE_TAKE, G, src))
					i++
			if(i<max_items)
				to_chat(user, "<span class='info'>You empty the plant bag into the biogenerator.</span>")
			else if(PB.contents.len == 0)
				to_chat(user, "<span class='info'>You empty the plant bag into the biogenerator, filling it to its capacity.</span>")
			else
				to_chat(user, "<span class='info'>You fill the biogenerator to its capacity.</span>")
		return TRUE //no afterattack

	else if(istype(O, /obj/item/food/grown))
		var/i = 0
		for(var/obj/item/food/grown/G in contents)
			i++
		if(i >= max_items)
			to_chat(user, "<span class='warning'>The biogenerator is full! Activate it.</span>")
		else
			if(user.transferItemToLoc(O, src))
				to_chat(user, "<span class='info'>You put [O.name] in [src.name]</span>")
		return TRUE //no afterattack
	else
		to_chat(user, "<span class='warning'>You cannot put this in [src.name]!</span>")

/obj/machinery/biogenerator/AltClick(mob/living/user)
	. = ..()
	if(user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK) && can_interact(user))
		detach(user)

/**
 * activate: Activates biomass processing and converts all inserted grown products into biomass
 *
 * Arguments:
 * * user The mob starting the biomass processing
 */
/obj/machinery/biogenerator/proc/activate(mob/user)
	if(user.stat != CONSCIOUS)
		return
	if(machine_stat != NONE)
		return
	if(processing)
		to_chat(user, "<span class='warning'>The biogenerator is in the process of working.</span>")
		return
	var/S = 0
	for(var/obj/item/food/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount(/datum/reagent/consumable/nutriment) < 0.1)
			points += 1 * productivity
		else
			points += I.reagents.get_reagent_amount(/datum/reagent/consumable/nutriment) * 10 * productivity
		qdel(I)
	if(S)
		processing = TRUE
		update_appearance()
		playsound(loc, 'sound/machines/blender.ogg', 50, TRUE)
		use_power(S * 30)
		sleep(S + 15 / productivity)
		processing = FALSE
		update_appearance()

/obj/machinery/biogenerator/proc/check_cost(list/materials, multiplier = 1, remove_points = TRUE)
	if(materials.len != 1 || materials[1] != GET_MATERIAL_REF(/datum/material/biomass))
		return FALSE
	if (materials[GET_MATERIAL_REF(/datum/material/biomass)]*multiplier/efficiency > points)
		return FALSE
	else
		if(remove_points)
			points -= materials[GET_MATERIAL_REF(/datum/material/biomass)]*multiplier/efficiency
		update_appearance()
		return TRUE

/obj/machinery/biogenerator/proc/check_container_volume(list/reagents, multiplier = 1)
	var/sum_reagents = 0
	for(var/R in reagents)
		sum_reagents += reagents[R]
	sum_reagents *= multiplier

	if(beaker.reagents.total_volume + sum_reagents > beaker.reagents.maximum_volume)
		return FALSE

	return TRUE

/obj/machinery/biogenerator/proc/detach(mob/living/user)
	if(beaker)
		if(can_interact(user))
			user.put_in_hands(beaker)
		else
			beaker.drop_location(get_turf(src))
		beaker = null
		update_appearance()

/obj/machinery/biogenerator/ui_status(mob/user)
	if(machine_stat & BROKEN || panel_open)
		return UI_CLOSE
	return ..()

/obj/machinery/biogenerator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Biogenerator", name)
		ui.open()

/obj/machinery/biogenerator/ui_data(mob/user)
	var/list/data = list()
	data["beaker"] = beaker ? TRUE : FALSE
	data["biomass"] = points
	data["processing"] = processing
	if(locate(/obj/item/food/grown) in contents)
		data["can_process"] = TRUE
	else
		data["can_process"] = FALSE
	return data

/obj/machinery/biogenerator/ui_static_data(mob/user)
	var/list/data = list()
	data["categories"] = list()

	var/categories = show_categories.Copy()
	for(var/V in categories)
		categories[V] = list()
	for(var/category in categories)
		var/list/cat = list(
			"name" = category,
			"items" = (category == selected_cat ? list() : null))
		for(var/item in categories[category])
		data["categories"] += list(cat)

	return data

/obj/machinery/biogenerator/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("activate")
			activate(usr)
			return TRUE
		if("detach")
			detach(usr)
			return TRUE
		if("create")
			var/amount = text2num(params["amount"])
			amount = clamp(amount, 1, 10)
			if(!amount)
				return
			return TRUE
		if("select")
			selected_cat = params["category"]
			return TRUE
