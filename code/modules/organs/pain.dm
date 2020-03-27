/mob/living/flash_weakest_pain()
	if(HUDtech.Find("pain"))
		flick("weakest_pain", HUDtech["pain"])

/mob/living/flash_weak_pain()
	if(HUDtech.Find("pain"))
		flick("weak_pain", HUDtech["pain"])

/mob/living/flash_pain()
	if(HUDtech.Find("pain"))
		flick("pain", HUDtech["pain"])

mob/var/list/pain_stored = list()
mob/var/last_pain_message = ""
mob/var/next_pain_time = 0

// partname is the name of a body part
// amount is a num from 1 to 100
mob/living/carbon/proc/pain(var/partname, var/amount, var/force, var/burning = 0)
	if(stat >= UNCONSCIOUS)
		return
	if(species && (species.flags & NO_PAIN))
		return
	if(analgesic > 40)
		return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 10 && ishuman(src))
		if(src:paralysis)
			src:paralysis = max(0, src:paralysis-round(amount/10))
	if(amount > 50 && prob(amount / 5))
		src:drop_item()
	var/msg
	if(burning)
		switch(amount)
			if(1 to 10)
				flash_weakest_pain()
			if(11 to 90)
				flash_weak_pain()
			if(91 to 10000)
				flash_pain()
	else
		switch(amount)
			if(1 to 10)
				flash_weakest_pain()
			if(11 to 90)
				flash_weak_pain()
			if(91 to 10000)
				flash_pain()
	if(msg && (msg != last_pain_message || prob(10)))
		last_pain_message = msg
		to_chat(src, msg)
	next_pain_time = world.time + (100 - amount)


// message is the custom message to be displayed
// flash_strength is 0 for weak pain flash, 1 for strong pain flash
mob/living/carbon/human/proc/custom_pain(message, flash_strength)
	if(stat >= UNCONSCIOUS)
		return
	if(species.flags & NO_PAIN)
		return

	if(analgesic >= 100)
		return
	else if(analgesic >= 50)
		flash_strength -= 1
		if(flash_strength < 0)
			return

	var/msg = "\red <b>[message]</b>"
	if(flash_strength >= 1)
		msg = "\red <font size=3><b>[message]</b></font>"

	// Anti message spam checks
	if(msg && ((msg != last_pain_message) || (world.time >= next_pain_time)))
		last_pain_message = msg
		to_chat(src, msg)
	next_pain_time = world.time + 100

mob/living/carbon/human/proc/handle_pain()
	// not when sleeping

	if(species.flags & NO_PAIN) return

	if(stat >= DEAD)
		return
	if(analgesic > 70)
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		if(E.status&ORGAN_DEAD || BP_IS_ROBOTIC(E))
			continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ)
		pain(damaged_organ.name, maxdam, 0)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/I in internal_organs)
		if(I.status&ORGAN_DEAD || BP_IS_ROBOTIC(I))
			continue
		if(I.damage > 2) if(prob(2))
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			src.custom_pain("You feel a sharp pain in your [parent.name]", 1)

	var/toxDamageMessage = null
	var/toxMessageProb = 1
	switch(getToxLoss())
		if(1 to 5)
			toxMessageProb = 1
			toxDamageMessage = "Your body stings slightly."
		if(6 to 10)
			toxMessageProb = 2
			toxDamageMessage = "Your whole body hurts a little."
		if(11 to 15)
			toxMessageProb = 2
			toxDamageMessage = "Your whole body hurts."
		if(15 to 25)
			toxMessageProb = 3
			toxDamageMessage = "Your whole body hurts badly."
		if(26 to INFINITY)
			toxMessageProb = 5
			toxDamageMessage = "Your body aches all over, it's driving you mad."

	if(toxDamageMessage && prob(toxMessageProb))
		src.custom_pain(toxDamageMessage, getToxLoss() >= 15)