
/datum/job/vamp/citizen
	title = "Citizen"
	faction = "Vampire"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the Traditions"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/citizen
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_CITIZEN

	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf", "Kuei-Jin")

	v_duty = "Follow the traditions of the Camarilla. Obey the Prince and their authority. The city belongs to him. Aligning yourself with your clan members would be of benefit."
	duty = "Obey the authorities... Or don't. You are up late tonight for one reason or another."
	minimal_masquerade = 0
	allowed_bloodlines = list(CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_SETITES, CLAN_NONE, CLAN_CAPPADOCIAN, CLAN_GARGOYLE, CLAN_LASOMBRA, CLAN_TZIMISCE, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_SALUBRI, CLAN_NAGARAJA, CLAN_BAALI, CLAN_KIASYD, CLAN_BANU_HAQIM, CLAN_GIOVANNI, CLAN_OLD_TZIMISCE, CLAN_TRUE_BRUJAH)

/datum/outfit/job/citizen
	name = "Citizen"
	jobtype = /datum/job/vamp/citizen
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock

/datum/outfit/job/citizen/pre_equip(mob/living/carbon/human/H)
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
	if(H.clane)
		if(H.clane.name == CLAN_LASOMBRA)
			backpack_contents = list(/obj/item/passport =1, /obj/item/vamp/creditcard=1)
		if(H.clane.name == CLAN_KIASYD)
			backpack_contents = list(/obj/item/passport =1, /obj/item/vamp/creditcard=1)
	if(!H.clane)
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	if(H.clane && H.clane.name != CLAN_LASOMBRA && H.clane.name != CLAN_KIASYD)
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/citizen
	name = "Citizen"
	icon_state = "Assistant"
