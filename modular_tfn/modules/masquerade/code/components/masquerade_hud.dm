#define HUD_LIST_MASQUERADE "masquerade"

//Component that replaces all turfs and wallpapers with horrifying meat alternatives
/datum/component/masquerade_hud
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/client/masquerade_breacher
	var/image/new_masquerade_image

/datum/component/masquerade_hud/Initialize(mob/_masquerade_breacher)
	if(!_masquerade_breacher.client)
		return COMPONENT_INCOMPATIBLE

	masquerade_breacher = _masquerade_breacher.client

	create_masquerade_overlay()

/datum/component/masquerade_hud/Destroy(force)
	masquerade_breacher = null
	new_masquerade_image = null
	..()

/datum/component/masquerade_hud/proc/create_masquerade_overlay()
	SIGNAL_HANDLER

	var/atom/atom_parent = parent
	if(!atom_parent.hud_list)
		atom_parent.hud_list = list()

	if(!atom_parent.hud_list[HUD_LIST_MASQUERADE])
		atom_parent.hud_list[HUD_LIST_MASQUERADE] = image(icon = 'icons/obj/closet.dmi', loc = atom_parent, icon_state = "cardboard_special", layer = ABOVE_ALL_MOB_LAYER, pixel_z = 32)
		atom_parent.hud_list[HUD_LIST_MASQUERADE].appearance_flags |= TILE_BOUND
	new_masquerade_image = atom_parent.hud_list[HUD_LIST_MASQUERADE]
	masquerade_breacher.images |= new_masquerade_image

/datum/component/masquerade_hud/UnregisterFromParent()
	masquerade_breacher.images -= new_masquerade_image

#undef HUD_LIST_MASQUERADE
