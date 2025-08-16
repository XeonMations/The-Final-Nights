/obj/item/clothing/suit/costume/rose_dress
	name = "rose dress"
	desc = "A fancy rose dress."
	icon = 'modular_tfn/modules/wedding/icons/dress.dmi'
	worn_icon = 'modular_tfn/modules/wedding/icons/dress.dmi'
	icon_state = "rose_dress"
	body_parts_covered = CHEST|GROIN|LEGS|FEET
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/head/veil
	name = "veil"
	desc = "It's a wedding veil."
	icon = 'modular_tfn/modules/wedding/icons/dress.dmi'
	worn_icon = 'modular_tfn/modules/wedding/icons/dress.dmi'
	icon_state = "veil_off"
	inhand_icon_state = "veil_off"
	var/flipped = FALSE

/obj/item/clothing/head/veil/dropped()
	icon_state = "veil_off"
	flipped = FALSE
	..()

/obj/item/clothing/head/veil/AltClick(mob/user)
	..()
	if(user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		flip(user)

/obj/item/clothing/head/veil/proc/flip(mob/user)
	if(!user.incapacitated())
		flipped = !flipped
		if(flipped)
			icon_state = "veil_on"
			to_chat(user, "<span class='notice'>You flip the veil backwards.</span>")
		else
			icon_state = "veil_off"
			to_chat(user, "<span class='notice'>You flip the veil back in normal position.</span>")
		usr.update_inv_head()	//so our mob-overlays update

/obj/item/clothing/head/veil/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click the veil to flip it [flipped ? "forwards" : "backwards"].</span>"

