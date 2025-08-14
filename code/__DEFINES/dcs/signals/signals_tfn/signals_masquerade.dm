// These signals are related to NPC masquerade violation and handling code.

// /datum/proximity_monitor/advanced/violation_check_aoe
#define COMSIG_MASQUERADE_VIOLATION "masquerade_violation"
// /datum/component/violation_observer
#define COMSIG_SEEN_MASQUERADE_VIOLATION "seen_masquerade_violation"
// /datum/component/violation_observer
#define COMSIG_MASQUERADE_VIOLATION_REINFORCED "masquerade_violation_reinforced"

// The actual signal that lowers a player's masquerade by one, because we should never need to do it more than once.
#define COMSIG_MASQUERADE_BREACH "masquerade_breach"
// The signal that is sent for when a player deals with a masquerade breach.
#define COMSIG_MASQUERADE_REINFORCE "masquerade_reinforce"
