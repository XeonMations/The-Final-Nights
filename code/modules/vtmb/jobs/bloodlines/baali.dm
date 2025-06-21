/datum/job/vamp/baali
	title = "Counselor"
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Traditions"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/baali
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_BAALI

	allowed_species = list("Vampire")

	v_duty = "You are a member of the Order of Moloch! Acting as an alcoholics anonymous counselor, your kin have etched out a cover as members of alcoholics anonymous. Good luck."
	duty = "You are a member of the Order of Moloch! Acting as an alcoholics anonymous counselor, your kin have etched out a cover as members of alcoholics anonymous. Good luck."
	minimal_masquerade = 0
	allowed_bloodlines = list(CLAN_BAALI)

/datum/outfit/job/baali
	name = "Counselor"
	jobtype = /datum/job/vamp/baali
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/flashlight=1,
		/obj/item/vamp/creditcard=1,
	)

/datum/outfit/job/baali/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clane.male_clothes)
				uniform = H.clane.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clane.female_clothes)
				uniform = H.clane.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/baali
	name = "Counselor"
	icon_state = "Assistant"
