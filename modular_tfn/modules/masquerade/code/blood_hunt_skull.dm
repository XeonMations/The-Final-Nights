/obj/item/blood_hunt
	name = "Blood Hunt Announcer"
	desc = "A stylized skull, made out of marble. This thaumaturgically-created artifact allows you to announce a Blood Hunt to the city. Name your target."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "eye"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/blood_hunt/Initialize(mapload)
	. = ..()
	GLOB.blood_hunt_announcers += src

/obj/item/blood_hunt/Destroy()
	GLOB.blood_hunt_announcers -= src
	..()

/obj/item/blood_hunt/attack_self(mob/user)
	. = ..()
	var/chosen_name = tgui_input_text(user, "Write the hunted or forgiven character name:", "Blood Hunt")
	if(!chosen_name)
		return
	chosen_name = sanitize_name(chosen_name)
	var/reason = tgui_input_text(user, "Write the reason of the Blood Hunt:", "Blood Hunt Reason")
	if(!reason)
		reason = "No reason specified."

	for(var/mob/player_mob as anything in GLOB.kindred_list)
		if(player_mob.real_name == chosen_name)
			if(HAS_TRAIT(player_mob, TRAIT_HUNTED))
				end_hunt(user, player_mob)
			else
				start_hunt(user, player_mob, reason)
			return
	to_chat(user, span_warning("There is no such name in the city!"))

/obj/item/blood_hunt/proc/start_hunt(mob/user, mob/target, reason)
	to_chat(user, span_warning("You add [target] to the Hunted list."))
	ADD_TRAIT(target, TRAIT_HUNTED, "bloodhunt")
	log_game("[user] started a bloodhunt on [target] for: [reason]")
	message_admins("[user] started a bloodhunt on [target] for: [reason]")
	for(var/player_mob in GLOB.kindred_list)
		to_chat(player_mob, span_bold("The Blood Hunt after <span class='warning'>[target.real_name]</span> has been announced! <br> Reason: [reason]"))
		SEND_SOUND(player_mob, sound('code/modules/wod13/sounds/announce.ogg'))

/obj/item/blood_hunt/proc/end_hunt(mob/user, mob/target)
	to_chat(user, span_warning("You remove [target] from the Hunted list."))
	REMOVE_TRAIT(target, TRAIT_HUNTED, "bloodhunt")
	log_game("[user] ended a bloodhunt on [target].")
	message_admins("[user] ended a bloodhunt on [target].")
	for(var/player_mob in GLOB.kindred_list)
		to_chat(player_mob, span_bold("The Blood Hunt after <span class='green'>[target.real_name]</span> is over!"))
		SEND_SOUND(player_mob, sound('code/modules/wod13/sounds/announce.ogg'))

// This code is for reinforcing a player's masquerade.
/obj/item/blood_hunt/pre_attack(atom/A, mob/living/user, params)
	if(!ishuman(A))
		return
	if(!iskindred(A))
		return

	to_chat(user, span_notice("You hold \the [src] up to [A]..."))
	if(!do_after(user, 10 SECONDS, A))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	to_chat(user, span_notice("You pardon [A]'s masquerade breach!"))
	SSmasquerade.masquerade_reinforce(list(src), A, MASQUERADE_REASON_PREFERENCES)
	return COMPONENT_CANCEL_ATTACK_CHAIN
