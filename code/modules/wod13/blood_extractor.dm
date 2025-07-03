/obj/structure/bloodextractor
	name = "blood extractor"
	desc = "Extract blood in packs."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "bloodextractor"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	COOLDOWN_DECLARE(last_extracted)

/obj/structure/bloodextractor/MouseDrop_T(mob/living/target, mob/living/user)
	. = ..()
	if(user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_UI_BLOCKED) || !Adjacent(user) || !target.Adjacent(user) || !ishuman(target))
		return
	if(!target.buckled)
		to_chat(user, span_warning("You need to buckle [target] before using the extractor!"))
		return
	if(iszombie(target))
		to_chat(user, span_warning("[target]'s still, rotten blood cannot be drawn!"))
		return
	if(!COOLDOWN_FINISHED(src, last_extracted))
		to_chat(user, span_warning("The [src] isn't ready yet!"))
		return
	COOLDOWN_START(src, last_extracted, 20 SECONDS)
	if(!do_after(target, 5 SECONDS, src))
		return
	if(iskindred(target))
		if(target.bloodpool < 4)
			to_chat(user, span_warning("The [src] can't find enough blood in [target]'s body!"))
			return
		var/obj/item/reagent_containers/blood/vitae/vitae_bloodpack = new /obj/item/reagent_containers/blood/vitae(get_turf(src))
		target.transfer_blood_to(vitae_bloodpack, 200, TRUE)
		vitae_bloodpack.update_appearance()
		target.bloodpool = max(0, target.bloodpool - 4)
		return

	if(target.bloodpool < 2)
		to_chat(user, span_warning("The [src] can't find enough blood in [target]'s body!"))
		return
	if(HAS_TRAIT(target, TRAIT_POTENT_BLOOD))
		var/obj/item/reagent_containers/blood/elite/elite_bloodpack = new /obj/item/reagent_containers/blood/elite(get_turf(src))
		target.transfer_blood_to(elite_bloodpack, 200, TRUE)
		elite_bloodpack.update_appearance()
	else
		var/obj/item/reagent_containers/empty/bloodpack = new /obj/item/reagent_containers/blood(get_turf(src))
		target.transfer_blood_to(bloodpack, 200, TRUE)
		bloodpack.update_appearance()
	target.bloodpool = max(0, target.bloodpool - 2)
