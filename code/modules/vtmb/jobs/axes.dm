
/datum/job/vamp/axe_gang
	title = "Axe Gang"
	faction = "Vampire"
	total_positions = 8
	spawn_positions = 8
	supervisors = "the other Axes"
	selection_color = "#bb9d3d"

	outfit = /datum/outfit/job/axe_gangster

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_AXE_GANGSTER
	exp_type_department = EXP_TYPE_GANG

	allowed_species = list("Human", "Ghoul", "Werewolf", "Vampire")
	allowed_bloodlines = list(CLAN_NONE)
	allowed_tribes = list("Ronin", "Glass Walkers")


	duty = "Make money, do drugs, fight law. Your hideout is the laundromat in Chinatown."
	experience_addition = 10
	minimal_masquerade = 0

/datum/outfit/job/axe_gangster/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/cantonese)
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/axe_gangster
	name = "Axe Gangster"
	jobtype = /datum/job/vamp/axe_gang
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone/axe_gangster
	r_pocket = /obj/item/vamp/keys/axes
	backpack_contents = list(/obj/item/flashlight=1, /obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/clothing/mask/vampire/balaclava =1, /obj/item/gun/ballistic/automatic/vampire/beretta=2,/obj/item/ammo_box/magazine/semi9mm=2, /obj/item/melee/vampirearms/knife)

/obj/effect/landmark/start/axe_gang
	name = "Axe Gang"
	icon_state = "bouncer"
