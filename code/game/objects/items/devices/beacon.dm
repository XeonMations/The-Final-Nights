/obj/item/beacon
	name = "\improper tracking beacon"
	desc = "A beacon used by a teleporter."
	icon = 'icons/obj/device.dmi'
	icon_state = "beacon"
	inhand_icon_state = "beacon"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	var/enabled = TRUE
	var/renamed = FALSE

/obj/item/beacon/Initialize()
	. = ..()
	if (enabled)
		GLOB.teleportbeacons += src
	else
		icon_state = "beacon-off"

/obj/item/beacon/Destroy()
	GLOB.teleportbeacons.Remove(src)
	return ..()

/obj/item/beacon/attack_self(mob/user)
	enabled = !enabled
	if (enabled)
		icon_state = "beacon"
		GLOB.teleportbeacons += src
	else
		icon_state = "beacon-off"
		GLOB.teleportbeacons.Remove(src)
	to_chat(user, "<span class='notice'>You [enabled ? "enable" : "disable"] the beacon.</span>")
	return

/obj/item/beacon/attackby(obj/item/W, mob/user)
	if(IS_WRITING_UTENSIL(W)) // needed for things that use custom names like the locator
		var/new_name = tgui_input_text(user, "What would you like the name to be?", "Beacon", max_length = MAX_NAME_LEN)
		if(!user.canUseTopic(src))
			return
		if(new_name)
			name = new_name
			renamed = TRUE
		return
	else
		return ..()
