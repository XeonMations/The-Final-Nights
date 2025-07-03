/datum/reagent/blood/vitae
	name = "Vitae"
	description = "It seems to be slightly glowing blood."
	reagent_state = LIQUID
	color = "#fc0000"

/datum/reagent/blood/vitae/on_mob_life(mob/living/carbon/human/victim)
	//Cant use a switch here since isblank checks dont have proper syntax.
	if(isghoul(victim) || iskindred(victim))
		if(current_cycle >= 10)
			victim.bloodpool = min(victim.maxbloodpool, victim.bloodpool+1)
			victim.update_blood_hud()
	return ..()

/datum/reagent/blood/vitae/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()

	if(!ishumanbasic(exposed_mob))
		return
	if(exposed_mob.stat == DEAD && data["donor"])
		var/mob/living/carbon/human/embracer = data["donor"]
		embracer.attempt_embrace_target(exposed_mob, (usr == data["donor"]) ? null : usr)
		return
	var/mob/living/carbon/human/victim = exposed_mob
	victim.ghoulificate(data["donor"])
	victim.prompt_permenant_ghouling()
