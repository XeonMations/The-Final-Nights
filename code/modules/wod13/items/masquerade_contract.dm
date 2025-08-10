/obj/item/masquerade_contract
	name = "\improper elegant scroll"
	desc = "This piece of thaumaturgy shows Masquerade breakers. <b>CLICK ON the Contract to see possible breakers for catching. PUSH the target in torpor, to restore the Masquerade.</b>"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "masquerade"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/masquerade_contract/attack_self(mob/user)
	. = ..()
	var/current_location = get_turf(user)
	to_chat(user, "<b>YOU</b>, [get_area_name(user)] X:[current_location.x] Y:[current_location.y]")
	for(var/mob/living/breacher as anything in GLOB.masquerade_breakers_list)
		var/location_info
		if(breacher.masquerade <= 2)
			location_info = "[get_area_name(H)] X:[TT.x] Y:[TT.y]"
		else
			location_info = "[get_area_name(H)]"
		to_chat(user, span_info("[breacher.real_name], Masquerade: [breacher.masquerade], Diablerist: [breacher.diablerist ? "<b>YES</b>" : "NO"], [location_info]"))

	if(!GLOB.masquerade_breakers_list)
		to_chat(user, span_info("No available Masquerade breakers in city..."))

/obj/item/masquerade_contract/veil_contract
	name = "\improper brass pocketwatch"
	desc = "The hands do not tell the time, but a spirit's blessing on this fetish points you to dangers to the veil. <b>CLICK ON the clock to see possible breakers for catching. Shame or execute the offender for crimes against the nation.</b>"
	icon = 'icons/obj/items_and_weapons.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "pocketwatch"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/masquerade_contract/veil_contract/attack_self(mob/user)
	. = ..()
	var/current_location = get_turf(user)
	to_chat(user, "<b>YOU</b>, [get_area_name(user)] X:[current_location.x] Y:[current_location.y]")
	for(var/mob/living/breacher as anything in GLOB.veil_breakers_list)
		var/location_info
		if(breacher.masquerade <= 2)
			location_info = "[get_area_name(H)] X:[TT.x] Y:[TT.y]"
		else
			location_info = "[get_area_name(H)]"
		to_chat(user, span_info("[breacher.real_name], Veil: [breacher.masquerade], [location_info]"))

	if(!GLOB.veil_breakers_list)
		to_chat(user, span_info("No available Veil breakers in city..."))v
