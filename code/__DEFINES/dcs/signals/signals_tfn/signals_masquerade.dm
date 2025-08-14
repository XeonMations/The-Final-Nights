// These two signals are related to NPC masquerade violation spotting and handling code.

// /datum/proximity_monitor/advanced/violation_check_aoe
#define COMSIG_MASQUERADE_VIOLATION "masquerade_violation"
// /datum/component/violation_observer
#define COMSIG_SEEN_MASQUERADE_VIOLATION "seen_masquerade_violation"

// The actual signal that lowers a player's masquerade by one, because we should never need to do it more than once.
#define COMSIG_MASQUERADE_BREACH "masquerade_breach"
