/obj/structure/fermenting_barrel/blood_barrel
	name = "wooden barrel"
	desc = "A large wooden barrel. It seems to have some blood leaking out of it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrel"
	resistance_flags = FLAMMABLE
	density = TRUE
	anchored = FALSE
	max_integrity = 300

/obj/structure/fermenting_barrel/blood_barrel/Initialize()
	. = ..()

	var/data = list()
	data["names"] = list("blood" = 1)
	data["color"] = COLOR_RED
	data["boozepwr"] = 10
	data["tastes"] = list("iron" = 1)
	reagents.add_reagent(/datum/reagent/blood, 300, data)
