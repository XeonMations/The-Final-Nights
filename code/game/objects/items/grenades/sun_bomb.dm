/obj/item/grenade/sun_bomb
	name = "\"Sun\" Bomb"
	desc = "A specialized device that supposedly contains a sun in a small space. It's warm to the touch and vibrates faintly."
	icon_state = "pyrog"
	inhand_icon_state = "bomb"
	worn_icon_state = "pyrog"
	lefthand_file = 'icons/mob/inhands/weapons/bombs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/bombs_righthand.dmi'
	item_flags = NOBLUDGEON
	flags_1 = NONE
	det_time = 50400 // 1.3 hours
	display_timer = TRUE
	w_class = WEIGHT_CLASS_SMALL
	var/range = 10

/obj/item/grenade/sun_bomb/Initialize()
	. = ..()
	wires = new /datum/wires/explosive/sun_bomb(src)

/obj/item/grenade/sun_bomb/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_WIRES)

/obj/item/grenade/sun_bomb/Destroy()
	QDEL_NULL(wires)
	..()

/obj/item/grenade/sun_bomb/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, "<span class='notice'>The wire panel can be accessed without a screwdriver.</span>")
	else if(is_wire_tool(I))
		wires.interact(user)
	else
		return ..()

/obj/item/grenade/sun_bomb/detonate(mob/living/lanced_by)
	. = ..()
	update_mob()
	var/flashbang_turf = get_turf(src)
	for(var/i in 1 to 6)
		do_sparks(rand(5, 9), FALSE, src)
	playsound(flashbang_turf, 'sound/effects/supermatter.ogg', 100, TRUE, 8, 0.9)
	new /obj/effect/dummy/lighting_obj (flashbang_turf, range + 10, 4, LIGHT_COLOR_YELLOW, 2)
	for(var/mob/living/M in get_hearers_in_view(range, flashbang_turf))
		bang(get_turf(M), M)
	qdel(src)

/obj/item/grenade/sun_bomb/proc/bang(turf/T, mob/living/M)
	M.show_message(span_warning("BANG"), MSG_AUDIBLE)
	var/distance = max(0,get_dist(get_turf(src),T))

	//Flash
	if(M.flash_act())
		M.Paralyze(max(20/max(1,distance), 5))
		M.Knockdown(max(200/max(1,distance), 60))

	//Bang
	if(iskindred(M))
		M.Paralyze(2 SECONDS)
		M.Knockdown(10 SECONDS)
		M.soundbang_act(1, 200, 10, 15)
		addtimer(CALLBACK(src, PROC_REF(fuck_you_kindred), M), 8 SECONDS)

/obj/item/grenade/sun_bomb/proc/fuck_you_kindred(mob/living/M)
	M.adjustFireLoss(500) // Fuck you, sun upon yee.
