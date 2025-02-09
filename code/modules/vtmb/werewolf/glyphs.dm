/obj/item/melee/charcoal_stick
    name = "charcoal stick"
    desc = "A piece of burnt charcoal."
    icon = 'icons/obj/crayons.dmi'
    icon_state = "crayonblack"
    w_class = WEIGHT_CLASS_SMALL
    var/list/rituals = list()
    force = 1

/obj/item/melee/charcoal_stick/Initialize()
    . = ..()
    for(var/i in subtypesof(/obj/effect/decal/garou_glyph))
        if(i)
            var/obj/effect/decal/garou_glyph/G = new i(src)
            rituals |= list(G.name)

/obj/item/melee/charcoal_stick/attack_obj(turf/T, mob/living/user)
    if(rituals.len == 0)
        user << "There are no glyphs available."
        return
    else
        var/choice = input(user, "Select a glyph to draw.", "Glyph Selection") in rituals
        if(choice)
            var/obj/effect/decal/garou_glyph/glyph = pick(typesof(/obj/effect/decal/garou_glyph))
            if(glyph)
                drawing = true
                if(do_after(user, 5, user))
                    drawing = FALSE
                    new glyph(T.loc)
                    user.visible_message("<span class='notice'>[user] starts drawing a glyph onto [T]...</span>")
                else
                    drawing = FALSE
            else
                user.visible_message("<span class='notice'>You fail to draw a glyph.</span>")
        return

/obj/effect/decal/garou_glyph
    name = "glyph"
    var/garou_name = "basic glyph"
    desc = "An odd collection of symbols drawn in what seems to be charcoal."
    var/garou_desc = "a basic glyph with no meaning." //This is shown to werewolves who examine the glyph in order to determine its true meaning.
    anchored = TRUE
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "garou"
    resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
    layer = SIGIL_LAYER
    var/scribe_delay = 1 SECONDS //how long the glyph takes to create
	var/drawing = false

/obj/effect/decal/garou_glyph/wyrm
    name = "Strange Funny Glyph"
    garou_name = "wyrm glyph"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "wyrm"
    color = "#000000"
	drawing = true

/obj/effect/decal/garou_glyph/vampire
    name = "Strange Weird Glyph"
    garou_name = "vampire glyph"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "vampire"
    color = "#000000"
	drawing = true

/obj/effect/decal/garou_glyph/kinfolk
    name = "Strange Silly Glyph"
    garou_name = "kinfolk glyph"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "kinfolk"
    color = "#000000"
	drawing = true

/*/obj/item/charcoal_stick
	name = "charcoal stick"
	desc = "A piece of burnt charcoal."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonblack"
	//inhand_icon_state = "charcoal_stick"
	w_class = WEIGHT_CLASS_SMALL
	//actions_types = list(/datum/action/item_action/charcoal_stick)
	var/drawing_glyph = FALSE
	var/list/scribing = list()

	attack_verb_simple = list("attack", "chop", "tear", "beat")
	force = 1

/obj/item/melee/charcoal_stick/Initialize()
	. = ..()
	for(var/i in subtypesof(/obj/garou_glyph))
		if(i)
			var/obj/garou_glyph/G = new i(src)
			scribing |= G

/obj/garou_glyph
	name = "glyph"
	var/garou_name = "basic glyph"
	desc = "An odd collection of symbols drawn in what seems to be charcoal."
	var/garou_desc = "a basic glyph with no meaning." //This is shown to werewolves who examine the glyph in order to determine its true meaning.
	anchored = TRUE
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "garou"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER

	var/scribe_delay = 1 SECONDS //how long the glyph takes to create

/obj/garou_glyph/wyrm
	name = "Strange Glyph"
	garou_name = "wyrm glyph"
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "wyrm"
	color = "#000000"

/obj/garou_glyph/vampire
	name = "Strange Glyph"
	garou_name = "vampire glyph"
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "vampire"
	color = "#000000"

/obj/garou_glyph/kinfolk
	name = "Strange Glyph"
	garou_name = "kinfolk glyph"
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "kinfolk"
	color = "#000000"

/obj/item/charcoal_stick/interact(mob/user)
//obj/item/melee/charcoal_stick/afterattack(atom/target, mob/user, proximity)
	var/turf/T = get_turf(target)
	if(isgarou(user) || iswerewolf(user))
		var/list/glyphs = list()
		for(var/i in subtypesof(/obj/garou_glyph))
			var/obj/garou_glyph/G = new i(user)
				glyphs += i
			qdel(G)
		var/scribing = input(user, "Choose a glyph to draw:") as null|anything in glyphs
		if(scribing)
			var/G = pick(glyphs)
			new scribing(T.loc)
		else
			return
	else
		return
..()
/*	if(istype(M.get_active_held_item(), /obj/item/charcoal_stick))
		var/list/glyphs = list()
		for(var/i in subtypesof(/obj/garou_glyph))
			var/obj/garou_glyph/R = new i(owner)
				glyphs += i
			qdel(R)
		var/scribing = input(owner, "Choose a glyph to draw:") as null|anything in glyphs
		if(ritual)
			drawing = TRUE
			if(do_after(M, 30, M))
				drawing = FALSE
				new ritual(M.loc)
			else
				drawing = FALSE
	else
		var/list/glyphs = list()
		for(var/i in subtypesof(/obj/garou_glpyh))
			var/obj/glyph/R = new i(owner)
			if(R.mystlevel <= level)
				glyphs += i
			qdel(R)
		var/ritual = input(owner, "Choose a glyph to draw:") as null|anything in list("???")
		if(ritual)
			drawing = TRUE
			if(do_after(M, 30, M))
				drawing = FALSE
//				var/list/runes = subtypesof(/obj/abyssrune)
				var/glyph = pick(glyphs)
				new glyph(M.loc)
			else
				drawing = FALSE  */
/*/obj/item/charcoal_stick/attack(atom/target, mob/user)
	if(istype(target,/turf/open/floor/plating))
		if(isgarou(user))
			var/list/glyphs = list()
			for(var/i in subtypesof(/obj/effect/garou_glyph))
				var/obj/effect/garou_glyph/R = new i(owner)
					glyphs += i
				qdel(R)
			var/scribing = input(owner, "Choose a glyph to draw:") as null|anything in glyphs
			if(scribing)
				drawing = TRUE
				if(do_after(user, 30, user))
					drawing = FALSE
					new scribing(user.loc)
				else
					drawing = FALSE
			else
				return
			var/list/glyphs = list()
			for(var/i in subtypesof(/obj/effect/garou_glyph))
				var/obj/effect/garou_glyph/R = new i(owner)
					glyphs += i
				qdel(R)
			var/scribing = input(owner, "Choose a glyph to draw:") as null|anything in glyphs
			if(scribing)
				drawing = TRUE
				if(do_after(user, 30, user))
					drawing = FALSE
					var/glyph = pick(glyphs)
					new glyph(user.loc)
					drawing = FALSE
			else
				return
		else
			return*/

/*
/datum/action/item_action/glyph_drawing
	name = "Draw Glyph"
	desc = "Use the charcoal stick to create a Garou glyph."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"
	buttontooltipstyle = "cult"
	background_icon_state = "bg_demon"
*//*
/datum/action/item_action/glyph_drawing/
	name = "Draw Glyph"
	desc = "Use the charcoal stick to create a Garou glyph."
	var/drawing = FALSE
	var/level = 1

/datum/action/item_action/glyph_drawing/Trigger()
	. = ..() */

	/*/obj/item/charcoal_stick/attack(atom/target, mob/user)
	if(istype(target,/turf/open/floor/plating))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow", "defector graffiti")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti", "Fleet defector graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
			if("defector graffiti")
				to_chat(user, "You start drawing defector graffiti on the [target.name].")
		if(instant || do_after(user, 5 SECONDS, target, DO_PUBLIC_UNIQUE))
			new /obj/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, SPAN_WARNING("You used up your crayon!"))
					qdel(src)
		return TRUE*/ */
