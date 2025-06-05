
///called on /living when attempting to pick up an item, from base of /mob/living/put_in_hand_check(): (obj/item/I)
#define COMSIG_LIVING_TRY_PUT_IN_HAND "living_try_put_in_hand"
	/// Can't pick up
	#define COMPONENT_LIVING_CANT_PUT_IN_HAND (1<<0)

// Organ signals
/// Called on the organ when it is implanted into someone (mob/living/carbon/receiver)
#define COMSIG_ORGAN_IMPLANTED "organ_implanted"
/// Called on the organ when it is removed from someone (mob/living/carbon/old_owner)
#define COMSIG_ORGAN_REMOVED "organ_removed"
/// Called when an organ is being regenerated with a new copy in species regenerate_organs (obj/item/organ/replacement)
#define COMSIG_ORGAN_BEING_REPLACED "organ_being_replaced"
/// Called when an organ gets surgically removed (mob/living/user, mob/living/carbon/old_owner, target_zone, obj/item/tool)
#define COMSIG_ORGAN_SURGICALLY_REMOVED "organ_surgically_removed"
/// Called when using the *wag emote
#define COMSIG_ORGAN_WAG_TAIL "wag_tail"

///from base of mob/update_transform()
#define COMSIG_LIVING_POST_UPDATE_TRANSFORM "living_post_update_transform"

///from /obj/structure/door/crush(): (mob/living/crushed, /obj/machinery/door/crushing_door)
#define COMSIG_LIVING_DOORCRUSHED "living_doorcrush"
///from base of mob/living/resist() (/mob/living)
#define COMSIG_LIVING_RESIST "living_resist"
///from base of mob/living/ignite_mob() (/mob/living)
#define COMSIG_LIVING_IGNITED "living_ignite"
///from base of mob/living/extinguish_mob() (/mob/living)
#define COMSIG_LIVING_EXTINGUISHED "living_extinguished"
///from base of mob/living/electrocute_act(): (shock_damage, source, siemens_coeff, flags)
#define COMSIG_LIVING_ELECTROCUTE_ACT "living_electrocute_act"
///sent when items with siemen coeff. of 0 block a shock: (power_source, source, siemens_coeff, dist_check)
#define COMSIG_LIVING_SHOCK_PREVENTED "living_shock_prevented"
///sent by stuff like stunbatons and tasers: ()
#define COMSIG_LIVING_MINOR_SHOCK "living_minor_shock"
///from base of mob/living/revive() (full_heal, admin_revive)
#define COMSIG_LIVING_REVIVE "living_revive"
///from base of mob/living/set_buckled(): (new_buckled)
#define COMSIG_LIVING_SET_BUCKLED "living_set_buckled"
///from base of mob/living/set_body_position()
#define COMSIG_LIVING_SET_BODY_POSITION  "living_set_body_position"
///From post-can inject check of syringe after attack (mob/user)
#define COMSIG_LIVING_TRY_SYRINGE "living_try_syringe"
///From living/Life(). (deltatime, times_fired)
#define COMSIG_LIVING_LIFE "living_life"
	/// Block the Life() proc from proceeding... this should really only be done in some really wacky situations.
	#define COMPONENT_LIVING_CANCEL_LIFE_PROCESSING (1<<0)
///From living/set_resting(): (new_resting, silent, instant)
#define COMSIG_LIVING_RESTING "living_resting"

///from base of element/bane/activate(): (item/weapon, mob/user)
#define COMSIG_LIVING_BANED "living_baned"

///from base of element/bane/activate(): (item/weapon, mob/user)
#define COMSIG_OBJECT_PRE_BANING "obj_pre_baning"
	#define COMPONENT_CANCEL_BANING (1<<0)

///from base of element/bane/activate(): (item/weapon, mob/user)
#define COMSIG_OBJECT_ON_BANING "obj_on_baning"

// adjust_x_loss messages sent from /mob/living/proc/adjust[x]Loss
/// Returned from all the following messages if you actually aren't going to apply any change
#define COMPONENT_IGNORE_CHANGE (1<<0)
// Each of these messages sends the damagetype even though it is inferred by the signal so you can pass all of them to the same proc if required
/// Send when bruteloss is modified (type, amount, forced)
#define COMSIG_LIVING_ADJUST_BRUTE_DAMAGE "living_adjust_brute_damage"
/// Send when fireloss is modified (type, amount, forced)
#define COMSIG_LIVING_ADJUST_BURN_DAMAGE "living_adjust_burn_damage"
/// Send when oxyloss is modified (type, amount, forced)
#define COMSIG_LIVING_ADJUST_OXY_DAMAGE "living_adjust_oxy_damage"
/// Send when toxloss is modified (type, amount, forced)
#define COMSIG_LIVING_ADJUST_TOX_DAMAGE "living_adjust_tox_damage"
/// Send when cloneloss is modified (type, amount, forced)
#define COMSIG_LIVING_ADJUST_CLONE_DAMAGE "living_adjust_clone_damage"
/// Send when staminaloss is modified (type, amount, forced)
#define COMSIG_LIVING_ADJUST_STAMINA_DAMAGE "living_adjust_stamina_damage"

/// List of signals sent when you receive any damage except stamina
#define COMSIG_LIVING_ADJUST_STANDARD_DAMAGE_TYPES list(\
	COMSIG_LIVING_ADJUST_BRUTE_DAMAGE,\
	COMSIG_LIVING_ADJUST_BURN_DAMAGE,\
	COMSIG_LIVING_ADJUST_CLONE_DAMAGE,\
	COMSIG_LIVING_ADJUST_OXY_DAMAGE,\
	COMSIG_LIVING_ADJUST_TOX_DAMAGE,\
)
/// List of signals sent when you receive any kind of damage at all
#define COMSIG_LIVING_ADJUST_ALL_DAMAGE_TYPES (COMSIG_LIVING_ADJUST_STANDARD_DAMAGE_TYPES + COMSIG_LIVING_ADJUST_STAMINA_DAMAGE)


/// from base of mob/living/updatehealth()
#define COMSIG_LIVING_HEALTH_UPDATE "living_health_update"
///from base of mob/living/death(): (gibbed)
#define COMSIG_LIVING_DEATH "living_death"

///from base of mob/living/gib(): (drop_bitflags)
///Note that it is fired regardless of whether the mob was dead beforehand or not.
#define COMSIG_LIVING_GIBBED "living_gibbed"

///from base of mob/living/Write_Memory(): (dead, gibbed)
#define COMSIG_LIVING_WRITE_MEMORY "living_write_memory"
	#define COMPONENT_DONT_WRITE_MEMORY (1<<0)

/// from /proc/healthscan(): (list/scan_results, advanced, mob/user, mode)
/// Consumers are allowed to mutate the scan_results list to add extra information
#define COMSIG_LIVING_HEALTHSCAN "living_healthscan"

//ALL OF THESE DO NOT TAKE INTO ACCOUNT WHETHER AMOUNT IS 0 OR LOWER AND ARE SENT REGARDLESS!

///from base of mob/living/Stun() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_STUN "living_stun"
///from base of mob/living/Knockdown() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_KNOCKDOWN "living_knockdown"
///from base of mob/living/Paralyze() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_PARALYZE "living_paralyze"
///from base of mob/living/Immobilize() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_IMMOBILIZE "living_immobilize"
///from base of mob/living/incapacitate() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_INCAPACITATE "living_incapacitate"
///from base of mob/living/Unconscious() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_UNCONSCIOUS "living_unconscious"
///from base of mob/living/Sleeping() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_SLEEP "living_sleeping"
/// from mob/living/check_stun_immunity(): (check_flags)
#define COMSIG_LIVING_GENERIC_STUN_CHECK "living_check_stun"
	#define COMPONENT_NO_STUN (1<<0) //For all of them
///from base of /mob/living/can_track(): (mob/user)
#define COMSIG_LIVING_CAN_TRACK "mob_cantrack"
	#define COMPONENT_CANT_TRACK (1<<0)
///from end of fully_heal(): (heal_flags)
#define COMSIG_LIVING_POST_FULLY_HEAL "living_post_fully_heal"
/// from start of /mob/living/handle_breathing(): (seconds_per_tick, times_fired)
#define COMSIG_LIVING_HANDLE_BREATHING "living_handle_breathing"
///from /obj/item/hand_item/slapper/attack_atom(): (source=mob/living/slammer, obj/structure/table/slammed_table)
#define COMSIG_LIVING_SLAM_TABLE "living_slam_table"
///from /obj/item/hand_item/slapper/attack(): (source=mob/living/slapper, mob/living/slapped)
#define COMSIG_LIVING_SLAP_MOB "living_slap_mob"
///from /obj/item/hand_item/slapper/attack(): (source=mob/living/slapper, mob/living/slapped)
#define COMSIG_LIVING_SLAPPED "living_slapped"

/// from /mob/living/*/UnarmedAttack(), before sending [COMSIG_LIVING_UNARMED_ATTACK]: (mob/living/source, atom/target, proximity, modifiers)
/// The only reason this exists is so hulk can fire before Fists of the North Star.
/// Note that this is called before [/mob/living/proc/can_unarmed_attack] is called, so be wary of that.
#define COMSIG_LIVING_EARLY_UNARMED_ATTACK "human_pre_attack_hand"
/// from mob/living/*/UnarmedAttack(): (mob/living/source, atom/target, proximity, modifiers)
#define COMSIG_LIVING_UNARMED_ATTACK "living_unarmed_attack"
