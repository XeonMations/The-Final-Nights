/obj/item/charcoal_stick
    name = "charcoal stick"
    desc = "A piece of burnt charcoal."
    icon = 'icons/obj/crayons.dmi'
    icon_state = "crayonblack"
    w_class = WEIGHT_CLASS_SMALL
    var/list/rituals = list()

/obj/effect/decal/garou_glyph
    name = "glyph"
    var/garou_name = "basic glyph"
    desc = "An odd collection of symbols drawn in what seems to be charcoal."
    var/garou_desc = "a basic glyph with no meaning." // This is shown to werewolves who examine the glyph in order to determine its true meaning.
    anchored = TRUE
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "garou"
    color = "#000000"
    resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
    layer = SIGIL_LAYER

/obj/effect/decal/garou_glyph/wyrm
    name = "Strange Funny Glyph"
    garou_name = "wyrm glyph"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "wyrm"
    color = "#000000"

/obj/effect/decal/garou_glyph/vampire
    name = "Strange Weird Glyph"
    garou_name = "vampire glyph"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "vampire"
    color = "#000000"

/obj/effect/decal/garou_glyph/kinfolk
    name = "Strange Silly Glyph"
    garou_name = "kinfolk glyph"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "kinfolk"
    color = "#000000"

/obj/item/charcoal_stick/Initialize()
    . = ..()
    for(var/i in subtypesof(/obj/effect/decal/garou_glyph))
        if(i)
            var/obj/effect/decal/garou_glyph/G = new i(src)
            rituals |= list(G.name)

/obj/item/charcoal_stick/attack_obj(turf/T, mob/living/user)
    if(rituals.len == 0)
        user << "There are no glyphs available."
        return
    else
        var/choice = input(user, "Select a glyph to draw.", "Glyph Selection") in rituals
        if(choice)
            var/obj/effect/decal/garou_glyph/glyph = pick(typesof(/obj/effect/decal/garou_glyph))
            if(glyph)
                if(do_after(user, 5, user))
                    new glyph(T.loc)
                    user.visible_message("<span class='notice'>[user] starts drawing a glyph onto [T]...</span>")
            else
                user.visible_message("<span class='notice'>You fail to draw a glyph.</span>")
        return
