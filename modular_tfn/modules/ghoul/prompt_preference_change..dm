/proc/prompt_permenant_ghouling(mob/living/carbon/human/thrall)
	thrall.set_species(/datum/species/ghoul)
	var/response_g = tgui_input_list(thrall, "Do you wish to keep being a ghoul on your save slot?(Yes will be a permanent choice and you can't go back)", "Ghouling", list("Yes", "No"), "No")
	if(response_g == "Yes")
		var/datum/preferences/thrall_prefs_g = thrall.client.prefs
		if(thrall_prefs_g.discipline_types.len == 3)
			for (var/i in 1 to 3)
				var/removing_discipline = thrall_prefs_g.discipline_types[1]
				if (removing_discipline)
					var/index = thrall_prefs_g.discipline_types.Find(removing_discipline)
					thrall_prefs_g.discipline_types.Cut(index, index + 1)
					thrall_prefs_g.discipline_levels.Cut(index, index + 1)
		thrall_prefs_g.pref_species.name = "Ghoul"
		thrall_prefs_g.pref_species.id = "ghoul"
		thrall_prefs_g.save_character()
