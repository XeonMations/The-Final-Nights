/datum/job/vamp/garou/paintedcity
	selection_color = "#7195ad"
	faction = "Vampire"
	exp_type = EXP_TYPE_CREW
	allowed_species = list("Garou")
	allowed_tribes = list("Glasswalkers", "Bone Gnawers", "Children of Gaia")

/datum/job/vamp/garou/paintedcity/council
	title = "Painted City Council Member"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("The Litany")

	total_positions = 3
	spawn_positions = 3
	supervisors = "The Litany and Yourself."

	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_type_department = EXP_TYPE_PAINTED_CITY

	outfit = /datum/outfit/job/garou/citycouncil

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_

	minimal_masquerade = 5
	allowed_auspice =( )

	my_contact_is_important = TRUE
	known_contacts = list(
	)

	v_duty = "You are the top dog of this city."
	experience_addition = 25

/datum/outfit/job/garou/citycouncil
	name = "City Sept Councillor"
	jobtype = /datum/job/vamp/garou/paintedcity/council

	id = /obj/item/card/id/prince
	glasses = /obj/item/clothing/glasses/vampire/sun
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform =  /obj/item/clothing/under/vampire/prince
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/prince
	r_pocket = /obj/item/vamp/keys/prince
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/creditcard/prince=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/datum/outfit/job/garou/cityelder/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/prince/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/garou/painted/council
	name = "City Sept Council"
	icon_state = "Prince"

/datum/job/vamp/garou/paintedcity/keeper
	title = "Painted City Keeper"

/datum/job/vamp/garou/paintedcity/truthcatcher
	title = "Painted City Truthcatcher"

/datum/job/vamp/garou/paintedcity/warder
	title = "Painted City Warder"

/datum/job/vamp/garou/paintedcity/guardian
	title = "Painted City Guardian"
