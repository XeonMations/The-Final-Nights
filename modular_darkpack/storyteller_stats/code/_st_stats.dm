
/datum/st_stat
	var/name = ""
	var/description = ""
	var/score = 0
	var/bonus_score = 0
	//The minimum score this stat can be.
	var/min_score = 0
	//The maximum score this stat can be.
	var/max_score = 5

	//determines the base type for this class, so we don't add in empty types
	var/base_type = /datum/st_stat

	//if a stat affects the hp pool, recalculate the hp of the mob when changed.
	var/affects_health_pool = FALSE

	/// A dictionary of modifiers to this attribute.
	var/list/modifiers = list()

	//How many points this stat category the player can use to upgrade the stats in this category.
	var/points = 0

/datum/st_stat/proc/get_score(include_bonus = TRUE)
	if(include_bonus)
		return score + bonus_score
	else
		return score

/datum/st_stat/proc/set_score(amount)
	score = clamp(amount, min_score, max_score)

/datum/st_stat/proc/update_modifiers()
	SHOULD_NOT_OVERRIDE(TRUE)
	bonus_score = initial(bonus_score)
	for(var/source in modifiers)
		bonus_score += modifiers[source]
	bonus_score = clamp(bonus_score, 0, 10)
