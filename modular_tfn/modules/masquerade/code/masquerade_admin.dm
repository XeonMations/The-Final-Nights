/mob/living/carbon/human/proc/AdjustMasquerade(value)
	if(!iskindred(src) && !isghoul(src) && !iscathayan(src) && !iszombie(src) && !isgarou(src))
		return
	if(!GLOB.canon_event)
		return

	switch(value)
		if(1)
			SSmasquerade.masquerade_reinforce("admin", src)
		if(-1)
			SSmasquerade.masquerade_breach("admin", src)
