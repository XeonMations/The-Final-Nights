/datum/vampire_clan
	/// Name of the Clan
	var/name
	/// Description of the Clan
	var/desc
	/// Description of the Clan's supernatural curse
	var/curse

	/// List of Disciplines that are innate to this Clan
	var/list/clan_disciplines = list()
	/// List of Disciplines that are rejected by this Clan
	var/list/restricted_disciplines = list()
	//Discs that you don't start with but are easier to purchase like catiff instead of non clan discs
	var/list/common_disciplines = list()
	/// List of traits that are applied to members of this Clan
	var/list/clan_traits = list()

	/// The Clan's unique body sprite
	var/alt_sprite
	/// If the Clan's unique body sprites need to account for skintone
	var/alt_sprite_greyscale
	/// If members of this Clan can't have hair
	var/no_hair
	/// If members of this Clan can't have facial hair
	var/no_facial

	/// Default clothing for male members of this Clan
	var/male_clothes
	/// Default clothing for female members of this Clan
	var/female_clothes
	/// Keys for this Clan's exclusive hideout
	var/clan_keys

	/// List of unnatural features that members of this Clan can choose
	var/list/accessories
	/// Associative list of layers for unnatural features that members of this Clan can choose
	var/list/accessories_layers
	/// Clan accessory that's selected by default
	var/default_accessory

	/// Morality level that characters of this Clan start with
	var/start_humanity = 7
	/// If members of this Clan are on a Path of Enlightenment by default
	var/is_enlightened

	/// If this Clan needs a whitelist to select and play
	var/whitelisted

/**
 * Applies Clan-specific effects to the mob
 * gaining this Clan. Will alter the mob's
 * sprite according to the alternate sprite
 * and appearance variables, and apply the
 * Clan's traits to the mob. If the Clan is
 * being given as the mob joins the round,
 * it'll cause on_join_round to trigger when the
 * client logs into the mob.
 *
 * Arguments:
 * * vampire - Human being given the Clan
 * * joining_round - If this Clan is being applied as the mob joins the round
 */
/datum/vampire_clan/proc/on_gain(mob/living/carbon/human/vampire, joining_round)
	SHOULD_CALL_PARENT(TRUE)

	// Apply alternative sprites
	if (alt_sprite)
		if (!alt_sprite_greyscale)
			vampire.skin_tone = "albino"
		vampire.set_body_sprite(alt_sprite)

	// Remove hair if the Clan demands it
	if (no_hair)
		vampire.hairstyle = "Bald"

	// Remove facial hair if the Clan demands it
	if (no_facial)
		vampire.facial_hairstyle = "Shaved"

	// Add unique Clan features as traits
	for (var/trait in clan_traits)
		ADD_TRAIT(vampire, trait, CLAN_TRAIT)

	//this needs to be adjusted to be more accurate for blood spending rates
	var/datum/discipline/bloodheal/giving_bloodheal = new(clamp(11 - vampire.generation, 1, 10))
	vampire.give_discipline(giving_bloodheal)

	// Applies on_join_round effects when a client logs into this mob
	if (joining_round)
		RegisterSignal(vampire, COMSIG_MOB_LOGIN, PROC_REF(on_join_round), override = TRUE)

	vampire.update_body_parts()
	vampire.update_body()
	vampire.update_icon()

/**
 * Undoes the effects of on_gain to more or less
 * remove the effects of gaining the Clan. By default,
 * this proc only removes unique traits and resets
 * the mob's alternative sprite.
 *
 * Arguments:
 * * vampire - Human losing the Clan.
 */
/datum/vampire_clan/proc/on_lose(mob/living/carbon/human/vampire)
	SHOULD_CALL_PARENT(TRUE)

	// Remove unique Clan feature traits
	for (var/trait in clan_traits)
		REMOVE_TRAIT(vampire, trait, CLAN_TRAIT)

	var/datum/species/kindred/vampire_species = vampire?.dna.species
	var/datum/discipline/bloodheal/removing_bloodheal = vampire_species.get_discipline(/datum/discipline/bloodheal)
	qdel(removing_bloodheal)

	// Sets the vampire back to their default body sprite
	if (alt_sprite && (GET_BODY_SPRITE(vampire) == alt_sprite))
		vampire.set_body_sprite(initial(vampire.dna.species.limbs_id))

	// Remove Clan accessories
	if (vampire.client?.prefs?.clan_accessory)
		var/equipped_accessory = accessories_layers[vampire.client.prefs.clan_accessory]
		vampire.remove_overlay(equipped_accessory)

	vampire.update_body()

/**
 * Applies Clan-specific effects when the
 * mob that has the Clan logs into their mob
 * at roundstart. Anything that's not innate
 * to the Clan and more part of its social
 * structure or whatnot should go in here.
 * Will teleport Masquerade-breaching Clans to
 * safe areas and give them their Clan keys by
 * default.
 *
 * Arguments:
 * * vampire - Human with this Clan joining the round.
 */
/datum/vampire_clan/proc/on_join_round(mob/living/carbon/human/vampire)
	SIGNAL_HANDLER

	SHOULD_CALL_PARENT(TRUE)

	if (HAS_TRAIT(vampire, TRAIT_MASQUERADE_VIOLATING_FACE))
		if (length(GLOB.masquerade_latejoin))
			var/obj/effect/landmark/latejoin_masquerade/LM = pick(GLOB.masquerade_latejoin)
			if (LM)
				vampire.forceMove(LM.loc)

	if (clan_keys)
		vampire.put_in_r_hand(new clan_keys(vampire))

	UnregisterSignal(vampire, COMSIG_MOB_LOGIN)

/**
 * Gives the human a vampiric Clan, applying
 * on_gain effects and on_gain effects if the
 * parameter is true. Can also remove Clans
 * with or without a replacement, and apply
 * on_lose effects. Will have no effect the human
 * is being given the Clan it already has.
 *
 * Arguments:
 * * setting_clan - Typepath or Clan singleton to give to the human
 * * joining_round - If this Clan is being given at roundstart and should call on_join_round
 */
/mob/living/carbon/human/proc/set_clan(setting_clan, joining_round)
	var/datum/vampire_clan/previous_clan = clan

	// Convert typepaths to Clan singletons, or just directly assign if already singleton
	var/datum/vampire_clan/new_clan = ispath(setting_clan) ? GLOB.vampire_clans[setting_clan] : setting_clan

	// Handle losing Clan
	previous_clan?.on_lose(src)

	clan = new_clan

	// Clan's been cleared, don't apply effects
	if (!new_clan)
		return

	// Gaining Clan effects
	clan.on_gain(src, joining_round)
