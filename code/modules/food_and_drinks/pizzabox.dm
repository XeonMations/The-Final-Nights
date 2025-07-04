/obj/item/bombcore/miniature/pizza
	name = "pizza bomb"
	desc = "Special delivery!"
	icon_state = "pizzabomb_inactive"
	inhand_icon_state = "eshield0"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "pizzabox"
	inhand_icon_state = "pizzabox"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	custom_materials = list(/datum/material/cardboard = 2000)

	var/open = FALSE
	var/can_open_on_fall = TRUE //if FALSE, this pizza box will never open if it falls from a stack
	var/boxtag = ""
	var/list/boxes = list()

	var/obj/item/food/pizza/pizza

	var/obj/item/bombcore/miniature/pizza/bomb
	var/bomb_active = FALSE // If the bomb is counting down.
	var/bomb_defused = TRUE // If the bomb is inert.
	var/bomb_timer = 1 // How long before blowing the bomb, in seconds.
	/// Min bomb timer allowed in seconds
	var/bomb_timer_min = 1
	/// Max bomb timer allower in seconds
	var/bomb_timer_max = 20

/obj/item/pizzabox/Initialize()
	. = ..()
	update_icon()


/obj/item/pizzabox/Destroy()
	unprocess()
	return ..()

/obj/item/pizzabox/update_icon()
	. = ..()
	// Description
	desc = initial(desc)
	if(open)
		if(pizza)
			desc = "[desc] It appears to have \a [pizza] inside. Use your other hand to take it out."
		if(bomb)
			desc = "[desc] Wait, what?! It has \a [bomb] inside!"
			if(bomb_defused)
				desc = "[desc] The bomb seems inert. Use your other hand to activate it."
			if(bomb_active)
				desc = "[desc] It looks like it's about to go off!"
	else
		var/obj/item/pizzabox/box = boxes.len ? boxes[boxes.len] : src
		if(boxes.len)
			desc = "A pile of boxes suited for pizzas. There appear to be [boxes.len + 1] boxes in the pile."
		if(box.boxtag != "")
			desc = "[desc] The [boxes.len ? "top box" : "box"]'s tag reads: [box.boxtag]"

	// Icon/Overlays
	cut_overlays()
	if(open)
		icon_state = "pizzabox_open"
		if(pizza)
			icon_state = "pizzabox_messy"
			var/mutable_appearance/pizza_overlay = mutable_appearance(pizza.icon, pizza.icon_state)
			pizza_overlay.pixel_y = -3
			add_overlay(pizza_overlay)
		if(bomb)
			bomb.icon_state = "pizzabomb_[bomb_active ? "active" : "inactive"]"
			var/mutable_appearance/bomb_overlay = mutable_appearance(bomb.icon, bomb.icon_state)
			bomb_overlay.pixel_y = 5
			add_overlay(bomb_overlay)
	else
		icon_state = "pizzabox"
		var/current_offset = 3
		for(var/V in boxes)
			var/obj/item/pizzabox/P = V
			var/mutable_appearance/box_overlay = mutable_appearance(P.icon, P.icon_state)
			box_overlay.pixel_y = current_offset
			add_overlay(box_overlay)
			current_offset += 3
		var/obj/item/pizzabox/box = boxes.len ? boxes[boxes.len] : src
		if(box.boxtag != "")
			var/mutable_appearance/tag_overlay = mutable_appearance(icon, "pizzabox_tag")
			tag_overlay.pixel_y = boxes.len * 3
			add_overlay(tag_overlay)

/obj/item/pizzabox/worn_overlays(isinhands, icon_file)
	. = list()
	var/current_offset = 2
	if(isinhands)
		for(var/V in boxes) //add EXTRA BOX per box
			var/mutable_appearance/M = mutable_appearance(icon_file, inhand_icon_state)
			M.pixel_y = current_offset
			current_offset += 2
			. += M

/obj/item/pizzabox/attack_self(mob/user)
	if(boxes.len > 0)
		return
	open = !open
	if(open && !bomb_defused)
		audible_message("<span class='warning'>[icon2html(src, hearers(src))] *beep*</span>")
		bomb_active = TRUE
		START_PROCESSING(SSobj, src)
	else if(!open && !pizza && !bomb)
		var/obj/item/stack/sheet/cardboard/cardboard = new /obj/item/stack/sheet/cardboard(user.drop_location())
		to_chat(user, "<span class='notice'>You fold [src] into [cardboard].</span>")
		user.put_in_active_hand(cardboard)
		qdel(src)
		return
	update_icon()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/pizzabox/attack_hand(mob/user, list/modifiers)
	if(user.get_inactive_held_item() != src)
		return ..()
	if(open)
		if(pizza)
			user.put_in_hands(pizza)
			to_chat(user, "<span class='notice'>You take [pizza] out of [src].</span>")
			pizza = null
			update_icon()
		else if(bomb)
			if(wires.is_all_cut() && bomb_defused)
				user.put_in_hands(bomb)
				to_chat(user, "<span class='notice'>You carefully remove the [bomb] from [src].</span>")
				bomb = null
				update_icon()
				return
			else
				bomb_timer = input(user, "Set the [bomb] timer from [bomb_timer_min] to [bomb_timer_max].", bomb, bomb_timer) as num|null

				if (isnull(bomb_timer))
					return

				bomb_timer = clamp(CEILING(bomb_timer, 1), bomb_timer_min, bomb_timer_max)
				bomb_defused = FALSE

				log_bomber(user, "has trapped a", src, "with [bomb] set to [bomb_timer] seconds")
				bomb.adminlog = "The [bomb.name] in [src.name] that [key_name(user)] activated has detonated!"

				to_chat(user, "<span class='warning'>You trap [src] with [bomb].</span>")
				update_icon()
	else if(boxes.len)
		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		boxes -= topbox
		user.put_in_hands(topbox)
		to_chat(user, "<span class='notice'>You remove the topmost [name] from the stack.</span>")
		topbox.update_icon()
		update_icon()
		user.regenerate_icons()

/obj/item/pizzabox/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pizzabox))
		var/obj/item/pizzabox/newbox = I
		if(!open && !newbox.open)
			var/list/add = list()
			add += newbox
			add += newbox.boxes
			if(!user.transferItemToLoc(newbox, src))
				return
			boxes += add
			newbox.boxes.Cut()
			to_chat(user, "<span class='notice'>You put [newbox] on top of [src]!</span>")
			newbox.update_icon()
			update_icon()
			user.regenerate_icons()
			if(boxes.len >= 5)
				if(prob(10 * boxes.len))
					to_chat(user, "<span class='danger'>You can't keep holding the stack!</span>")
					disperse_pizzas()
				else
					to_chat(user, "<span class='warning'>The stack is getting a little high...</span>")
			return
		else
			to_chat(user, "<span class='notice'>Close [open ? src : newbox] first!</span>")
	else if(istype(I, /obj/item/food/pizza))
		if(open)
			if(pizza)
				to_chat(user, "<span class='warning'>[src] already has \a [pizza.name]!</span>")
				return
			if(!user.transferItemToLoc(I, src))
				return
			pizza = I
			to_chat(user, "<span class='notice'>You put [I] in [src].</span>")
			update_icon()
			return
	else if(istype(I, /obj/item/bombcore/miniature/pizza))
		if(open && !bomb)
			if(!user.transferItemToLoc(I, src))
				return
			wires = new /datum/wires/explosive/pizza(src)
			bomb = I
			to_chat(user, "<span class='notice'>You put [I] in [src]. Sneeki breeki...</span>")
			update_icon()
			return
		else if(bomb)
			balloon_alert(user, "already rigged!")
	else if(IS_WRITING_UTENSIL(I))
		if(!open)
			if(!user.is_literate())
				to_chat(user, "<span class='notice'>You scribble illegibly on [src]!</span>")
				return
			var/obj/item/pizzabox/box = boxes.len ? boxes[boxes.len] : src
			box.boxtag += stripped_input(user, "Write on [box]'s tag:", box, "", 30)
			if(!user.canUseTopic(src, BE_CLOSE))
				return
			balloon_alert(user, "writing box tag...")
			playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
			update_icon()
			return
	else if(is_wire_tool(I))
		if(wires && bomb)
			wires.interact(user)
	else if(istype(I, /obj/item/reagent_containers/food))
		to_chat(user, "<span class='warning'>That's not a pizza!</span>")
	..()

/obj/item/pizzabox/process(delta_time)
	if(bomb_active && !bomb_defused && (bomb_timer > 0))
		playsound(loc, 'sound/items/timer.ogg', 50, FALSE)
		bomb_timer -= delta_time
	if(bomb_active && !bomb_defused && (bomb_timer <= 0))
		if(bomb in src)
			bomb.detonate()
			unprocess()
			qdel(src)
	if(!bomb_active || bomb_defused)
		if(bomb_defused && (bomb in src))
			bomb.defuse()
			bomb_active = FALSE
			unprocess()
	return

/obj/item/pizzabox/attack(mob/living/target, mob/living/user, def_zone)
	. = ..()
	if(boxes.len >= 3 && prob(25 * boxes.len))
		disperse_pizzas()

/obj/item/pizzabox/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(boxes.len >= 2 && prob(20 * boxes.len))
		disperse_pizzas()

/obj/item/pizzabox/proc/disperse_pizzas()
	visible_message("<span class='warning'>The pizzas fall everywhere!</span>")
	for(var/V in boxes)
		var/obj/item/pizzabox/P = V
		var/fall_dir = pick(GLOB.alldirs)
		step(P, fall_dir)
		if(P.pizza && P.can_open_on_fall && prob(50)) //rip pizza
			P.open = TRUE
			P.pizza.forceMove(get_turf(P))
			fall_dir = pick(GLOB.alldirs)
			step(P.pizza, fall_dir)
			P.pizza = null
			P.update_icon()
		boxes -= P
	update_icon()
	if(isliving(loc))
		var/mob/living/L = loc
		L.regenerate_icons()

/obj/item/pizzabox/proc/unprocess()
	STOP_PROCESSING(SSobj, src)
	qdel(wires)
	wires = null
	update_icon()

/obj/item/pizzabox/bomb/Initialize()
	. = ..()
	var/randompizza = pick(subtypesof(/obj/item/food/pizza))
	pizza = new randompizza(src)
	bomb = new(src)
	wires = new /datum/wires/explosive/pizza(src)

/obj/item/pizzabox/margherita/Initialize()
	. = ..()
	AddPizza()
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/margherita/proc/AddPizza()
	pizza = new /obj/item/food/pizza/margherita(src)

/obj/item/pizzabox/margherita/robo/AddPizza()
	pizza = new /obj/item/food/pizza/margherita/robo(src)

/obj/item/pizzabox/vegetable/Initialize()
	. = ..()
	pizza = new /obj/item/food/pizza/vegetable(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/Initialize()
	. = ..()
	pizza = new /obj/item/food/pizza/mushroom(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/Initialize()
	. = ..()
	pizza = new /obj/item/food/pizza/meat(src)
	boxtag = "Meatlover's Supreme"

/obj/item/pizzabox/pineapple/Initialize()
	. = ..()
	pizza = new /obj/item/food/pizza/pineapple(src)
	boxtag = "Honolulu Chew"

//An anomalous pizza box that, when opened, produces the opener's favorite kind of pizza.
/obj/item/pizzabox/infinite
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF //hard to destroy
	can_open_on_fall = FALSE
	var/list/pizza_types = list(
		/obj/item/food/pizza/meat = 1,
		/obj/item/food/pizza/mushroom = 1,
		/obj/item/food/pizza/margherita = 1,
		/obj/item/food/pizza/sassysage = 0.8,
		/obj/item/food/pizza/vegetable = 0.8,
		/obj/item/food/pizza/pineapple = 0.5,
		/obj/item/food/pizza/donkpocket = 0.3,
		/obj/item/food/pizza/dank = 0.1,
	) //pizzas here are weighted by chance to be someone's favorite
	var/static/list/pizza_preferences

/obj/item/pizzabox/infinite/Initialize()
	. = ..()
	if(!pizza_preferences)
		pizza_preferences = list()

/obj/item/pizzabox/infinite/examine(mob/user)
	. = ..()
	if(isobserver(user))
		. += "<span class='deadsay'>This pizza box is anomalous, and will produce infinite pizza.</span>"

/obj/item/pizzabox/infinite/attack_self(mob/living/user)
	QDEL_NULL(pizza)
	if(ishuman(user))
		attune_pizza(user)
	. = ..()

/obj/item/pizzabox/infinite/proc/attune_pizza(mob/living/carbon/human/noms) //tonight on "proc names I never thought I'd type"
	if(!pizza_preferences[noms.ckey])
		pizza_preferences[noms.ckey] = pickweight(pizza_types)
		if(noms.has_quirk(/datum/quirk/pineapple_liker))
			pizza_preferences[noms.ckey] = /obj/item/food/pizza/pineapple
		else if(noms.has_quirk(/datum/quirk/pineapple_hater))
			var/list/pineapple_pizza_liker = pizza_types.Copy()
			pineapple_pizza_liker -= /obj/item/food/pizza/pineapple
			pizza_preferences[noms.ckey] = pickweight(pineapple_pizza_liker)
		else if(noms.mind && noms.mind.assigned_role == "Botanist")
			pizza_preferences[noms.ckey] = /obj/item/food/pizza/dank

	var/obj/item/pizza_type = pizza_preferences[noms.ckey]
	pizza = new pizza_type (src)
	pizza.foodtypes = noms.dna.species.liked_food //it's our favorite!
