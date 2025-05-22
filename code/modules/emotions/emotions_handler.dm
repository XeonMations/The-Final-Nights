/datum/mind
	//The current mind's emotion!
	var/datum/emotion/current_emotion

/datum/emotion
	var/name = "Default Emotion"
	var/greyscale_color = "#000000"

/**
 * Add a note to the mind datum
 */
/mob/living/carbon/verb/set_emotion()
	set name = "Set Emotion"
	set category = "IC"

	set_emotion(usr)

/mob/living/carbon/proc/set_emotion(mob/living/carbon/user)
	if(!user)
		return

	var/list/datum/emotion/emotions_list = subtypesof(/datum/emotion)

	var/selected_emotion = tgui_input_list(user, "Set Emotion", "Select an emotion to set", emotions_list.name)
	if(!selected_emotion)
		return

	selected_emotion = text2path(selected_emotion)
