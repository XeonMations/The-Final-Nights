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
		embracer.attempt_embrace_target()
		return
	var/mob/living/carbon/human/victim = exposed_mob
	prompt_permenant_ghouling(victim)
	var/datum/species/ghoul/ghoul = victim.dna.species
	if(victim.mind.enslaved_to != data["donor"])
		victim.mind.enslave_mind_to_creator(data["donor"])
		to_chat(victim, span_userdanger("<b>AS PRECIOUS VITAE ENTER YOUR MOUTH, YOU NOW ARE IN THE BLOODBOND OF [data["donor"]]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b>"))
		ghoul.master = data["donor"]
