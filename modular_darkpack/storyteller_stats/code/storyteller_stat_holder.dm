/// This is the object used to store and manage a character's st_stats.
/datum/storyteller_stats
	/// A dictionary of st_stats. K: path -> V: instance.
	VAR_PRIVATE/list/st_stats = list()

/datum/storyteller_stats/New()
	. = ..()
	for(var/datum/path as anything in subtypesof(/datum/st_stat))
		var/datum/st_stat/new_trait = new path
		st_stats[path] = new_trait

	for(var/datum/path as anything in subtypesof(/datum/st_stat))
		var/datum/st_stat/A = st_stats[path]
		set_stat(path, A.starting_score)

	recalculate_all_willpower()

/datum/storyteller_stats/Destroy()
	QDEL_LIST(st_stats)
	return ..()

/// Return the total or pure score of the given stat.
/datum/storyteller_stats/proc/get_stat(stat_path, include_bonus = TRUE)
	var/datum/st_stat/A = st_stats[stat_path]
	return A.get_score(include_bonus)

/// Sets the score of the given stat.
/datum/storyteller_stats/proc/set_stat(stat_path, amount)
	var/datum/st_stat/A = st_stats[stat_path]
	var/score_applied = A.set_score(amount)
	recalculate_stats(stat_path)
	return score_applied

/// Return the instance of the given stat.
/datum/storyteller_stats/proc/get_stat_datum(stat_path)
	RETURN_TYPE(/datum/st_stat)
	var/datum/st_stat/A = st_stats[stat_path]
	return A

/datum/storyteller_stats/proc/add_stat_mod(stat_path, amount, source)
	var/datum/st_stat/A = get_stat_datum(stat_path)
	LAZYSET(A.modifiers, source, amount)
	A.update_modifiers()
	recalculate_stats(stat_path)

/datum/storyteller_stats/proc/remove_stat_mod(stat_path, source)
	var/datum/st_stat/A = get_stat_datum(stat_path)
	if(LAZYACCESS(A.modifiers, source))
		A.modifiers -= source
		A.update_modifiers()
		recalculate_stats(stat_path)

/datum/storyteller_stats/proc/get_stat_mod(trait, source)
	var/datum/st_stat/checking_trait = get_stat_datum(trait)
	return LAZYACCESS(checking_trait.modifiers, source)

/datum/storyteller_stats/proc/randomize_attributes(min_score, max_score)
	for(var/datum/path as anything in subtypesof(/datum/st_stat/attribute))
		var/datum/st_stat/A = st_stats[path]
		A.set_score(rand(min_score, max_score))

/datum/storyteller_stats/proc/randomize_abilities(min_score, max_score)
	for(var/datum/path as anything in subtypesof(/datum/st_stat/ability))
		var/datum/st_stat/A = st_stats[path]
		A.set_score(rand(min_score, max_score))

/datum/storyteller_stats/proc/is_health_affecting(stat_path)
	var/datum/st_stat/A = get_stat_datum(stat_path)
	if(!A)
		return FALSE
	return A.affects_health_pool

/datum/storyteller_stats/proc/is_willpower_affecting(stat_path)
	var/datum/st_stat/A = get_stat_datum(stat_path)
	return A.affects_willpower

/datum/storyteller_stats/proc/decrease_score(stat_path, amount)
	var/datum/st_stat/A = get_stat_datum(stat_path)
	return A.decrease_score(amount)

/datum/storyteller_stats/proc/increase_score(stat_path, amount)
	var/datum/st_stat/A = get_stat_datum(stat_path)
	return A.increase_score(amount)

/datum/storyteller_stats/proc/build_attribute_score(stat_path, show_bonus = FALSE)
	var/datum/st_stat/A = get_stat_datum(stat_path)
	var/dots
	var/score = A.score
	if(show_bonus)
		score += A.bonus_score
	for(var/a in 1 to score)
		dots += "•"
	var/leftover_circles = A.max_score - (A.score + A.bonus_score) //5 is the default number of blank circles
	for(var/c in 1 to leftover_circles)
		dots += "o"
	return dots

/datum/storyteller_stats/proc/recalculate_stats(stat_path)
	if(is_willpower_affecting(stat_path))
		if(stat_path == STAT_PERMANENT_WILLPOWER)
			recalculate_all_willpower()
		else
			recalculate_all_willpower(TRUE)

/datum/storyteller_stats/proc/recalculate_all_willpower(updating_permanent_willpower = FALSE)
	if(updating_permanent_willpower)
		remove_stat_mod(STAT_PERMANENT_WILLPOWER, "COURAGE")
		add_stat_mod(STAT_PERMANENT_WILLPOWER, clamp(-(get_stat(STAT_PERMANENT_WILLPOWER, include_bonus = FALSE) - 10), 0, get_stat(STAT_COURAGE)), "COURAGE")
	set_stat(STAT_TEMPORARY_WILLPOWER, get_stat(STAT_PERMANENT_WILLPOWER))
