/obj/machinery/pdapainter
	name = "\improper PDA painter"
	desc = "A PDA painting machine. To use, simply insert your PDA and choose the desired preset paint scheme."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdapainter"
	base_icon_state = "pdapainter"
	density = TRUE
	max_integrity = 200
	var/obj/item/pda/storedpda = null
	var/list/colorlist = list()

/obj/machinery/pdapainter/update_icon_state()
	if(machine_stat & BROKEN)
		icon_state = "[base_icon_state]-broken"
		return ..()
	icon_state = "[base_icon_state][powered() ? null : "-off"]"
	return ..()

/obj/machinery/pdapainter/update_overlays()
	. = ..()

	if(machine_stat & BROKEN)
		return

	if(storedpda)
		. += "[initial(icon_state)]-closed"

/obj/machinery/pdapainter/Initialize()
	. = ..()
	var/list/blocked = list(
		/obj/item/pda/ai/pai,
		/obj/item/pda/ai,
		/obj/item/pda/heads,
		/obj/item/pda/clear,
		/obj/item/pda/syndicate,
		/obj/item/pda/chameleon,
		/obj/item/pda/chameleon/broken)

	for(var/P in typesof(/obj/item/pda) - blocked)
		var/obj/item/pda/D = new P

		//D.name = "PDA Style [colorlist.len+1]" //Gotta set the name, otherwise it all comes up as "PDA"
		D.name = D.icon_state //PDAs don't have unique names, but using the sprite names works.

		src.colorlist += D

/obj/machinery/pdapainter/Destroy()
	QDEL_NULL(storedpda)
	return ..()

/obj/machinery/pdapainter/on_deconstruction()
	if(storedpda)
		storedpda.forceMove(loc)
		storedpda = null

/obj/machinery/pdapainter/contents_explosion(severity, target)
	if(storedpda)
		storedpda.ex_act(severity, target)

/obj/machinery/pdapainter/handle_atom_del(atom/A)
	if(A == storedpda)
		storedpda = null
		update_appearance()

/obj/machinery/pdapainter/attackby(obj/item/O, mob/living/user, params)
	if(machine_stat & BROKEN)
		if(O.tool_behaviour == TOOL_WELDER && !user.combat_mode)
			if(!O.tool_start_check(user, amount=0))
				return
			user.visible_message("<span class='notice'>[user] is repairing [src].</span>", \
							"<span class='notice'>You begin repairing [src]...</span>", \
							"<span class='hear'>You hear welding.</span>")
			if(O.use_tool(src, user, 40, volume=50))
				if(!(machine_stat & BROKEN))
					return
				to_chat(user, "<span class='notice'>You repair [src].</span>")
				set_machine_stat(machine_stat & ~BROKEN)
				atom_integrity = max_integrity
				update_appearance(UPDATE_ICON)
			return
		return ..()
	else if(default_unfasten_wrench(user, O))
		power_change()
		return

	else if(istype(O, /obj/item/pda))
		if(storedpda)
			to_chat(user, "<span class='warning'>There is already a PDA inside!</span>")
			return
		else if(!user.transferItemToLoc(O, src))
			return
		storedpda = O
		O.add_fingerprint(user)
		update_appearance()

	else
		return ..()

/obj/machinery/pdapainter/deconstruct(disassembled = TRUE)
	atom_break()

/obj/machinery/pdapainter/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(storedpda)
		if(machine_stat & BROKEN)	//otherwise the PDA is stuck until repaired
			ejectpda()
			to_chat(user, "<span class='info'>You manage to eject the loaded PDA.</span>")
		else
			var/obj/item/pda/P
			P = input(user, "Select your color!", "PDA Painting") as null|anything in sort_names(colorlist)
			if(!P)
				return
			if(!in_range(src, user))
				return
			if(!storedpda)//is the pda still there?
				return
			storedpda.icon_state = P.icon_state
			storedpda.desc = P.desc
			ejectpda()

	else
		to_chat(user, "<span class='warning'>[src] is empty!</span>")


/obj/machinery/pdapainter/verb/ejectpda()
	set name = "Eject PDA"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	if(storedpda)
		storedpda.forceMove(drop_location())
		storedpda = null
		update_appearance()
	else
		to_chat(usr, "<span class='warning'>[src] is empty!</span>")
