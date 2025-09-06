/datum/preferences
	var/stat_points = 35

	// Pooled
	var/permanent_willpower = 1
	var/temporary_willpower = 1

	// Physical
	var/strength = 1
	var/dexterity = 1
	var/stamina = 1

	// Social
	var/charisma = 1
	var/manipulation = 1
	var/appearance = 1

	// Mental
	var/perception = 1
	var/intelligence = 1
	var/wits = 1

	// Talents
	var/alertness = 1
	var/athletics = 1
	var/awareness = 1
	var/brawl = 1
	var/empathy = 1
	var/expression = 1
	var/intimidation = 1
	var/leadership = 1
	var/streetwise = 1
	var/subterfuge = 1

	// Skills
	var/animal_ken = 1
	var/crafts = 1
	var/drive = 1
	var/etiquette = 1
	var/firearms = 1
	var/larceny = 1
	var/melee = 1
	var/performance = 1
	var/stealth = 1
	var/survival = 1

	// Knowledges
	var/academics = 1
	var/computer = 1
	var/finance = 1
	var/investigation = 1
	var/law = 1
	var/medicine = 1
	var/occult = 1
	var/politics = 1
	var/science = 1
	var/technology = 1

	//"So, while a character with Conscience, Self-Control, and Courage is created with one free dot in each Virtue,
	// then has seven points to spend on Virtues, a character with Conviction, Self-Control, and Courage begins with
	// only two free dots (in Self-Control and Courage)."
	//Virtues
	var/conscience = 1
	var/self_control = 1
	var/conviction = 0
	var/instinct = 0
	var/courage = 1

/datum/preferences/proc/load_stats(savefile/S)
	READ_FILE(S["stat_points"], stat_points)

	READ_FILE(S["permanent_willpower"], permanent_willpower)
	READ_FILE(S["temporary_willpower"], temporary_willpower)

	//Physical
	READ_FILE(S["strength"], strength)
	READ_FILE(S["dexterity"], dexterity)
	READ_FILE(S["stamina"], stamina)

	//Social
	READ_FILE(S["charisma"], charisma)
	READ_FILE(S["manipulation"], manipulation)
	READ_FILE(S["appearance"], appearance)

	//Social
	READ_FILE(S["perception"], perception)
	READ_FILE(S["intelligence"], intelligence)
	READ_FILE(S["wits"], wits)

	//Talents
	READ_FILE(S["alertness"], alertness)
	READ_FILE(S["athletics"], athletics)
	READ_FILE(S["awareness"], awareness)
	READ_FILE(S["brawl"], brawl)
	READ_FILE(S["empathy"], empathy)
	READ_FILE(S["expression"], expression)
	READ_FILE(S["intimidation"], intimidation)
	READ_FILE(S["leadership"], leadership)
	READ_FILE(S["streetwise"], streetwise)
	READ_FILE(S["subterfuge"], subterfuge)

	//Skills
	READ_FILE(S["animal_ken"], animal_ken)
	READ_FILE(S["crafts"], crafts)
	READ_FILE(S["drive"], drive)
	READ_FILE(S["etiquette"], etiquette)
	READ_FILE(S["firearms"], firearms)
	READ_FILE(S["larceny"], larceny)
	READ_FILE(S["melee"], melee)
	READ_FILE(S["performance"], performance)
	READ_FILE(S["stealth"], stealth)
	READ_FILE(S["survival"], survival)

	//Knowledges
	READ_FILE(S["academics"], academics)
	READ_FILE(S["computer"], computer)
	READ_FILE(S["finance"], finance)
	READ_FILE(S["investigation"], investigation)
	READ_FILE(S["law"], law)
	READ_FILE(S["medicine"], medicine)
	READ_FILE(S["occult"], occult)
	READ_FILE(S["politics"], politics)
	READ_FILE(S["science"], science)
	READ_FILE(S["technology"], technology)

	//Virtues
	READ_FILE(S["conscience"], conscience)
	READ_FILE(S["self_control"], self_control)
	READ_FILE(S["conviction"], conviction)
	READ_FILE(S["instinct"], instinct)
	READ_FILE(S["courage"], courage)

/datum/preferences/proc/save_stats(savefile/S)
	WRITE_FILE(S["stat_points"], stat_points)

	WRITE_FILE(S["permanent_willpower"], permanent_willpower)
	WRITE_FILE(S["temporary_willpower"], temporary_willpower)

	//Physical
	WRITE_FILE(S["strength"], strength)
	WRITE_FILE(S["dexterity"], dexterity)
	WRITE_FILE(S["stamina"], stamina)

	//Social
	WRITE_FILE(S["charisma"], charisma)
	WRITE_FILE(S["manipulation"], manipulation)
	WRITE_FILE(S["appearance"], appearance)

	//Social
	WRITE_FILE(S["perception"], perception)
	WRITE_FILE(S["intelligence"], intelligence)
	WRITE_FILE(S["wits"], wits)

	//Talents
	WRITE_FILE(S["alertness"], alertness)
	WRITE_FILE(S["athletics"], athletics)
	WRITE_FILE(S["awareness"], awareness)
	WRITE_FILE(S["brawl"], brawl)
	WRITE_FILE(S["empathy"], empathy)
	WRITE_FILE(S["expression"], expression)
	WRITE_FILE(S["intimidation"], intimidation)
	WRITE_FILE(S["leadership"], leadership)
	WRITE_FILE(S["streetwise"], streetwise)
	WRITE_FILE(S["subterfuge"], subterfuge)

	//Skills
	WRITE_FILE(S["animal_ken"], animal_ken)
	WRITE_FILE(S["crafts"], crafts)
	WRITE_FILE(S["drive"], drive)
	WRITE_FILE(S["etiquette"], etiquette)
	WRITE_FILE(S["firearms"], firearms)
	WRITE_FILE(S["larceny"], larceny)
	WRITE_FILE(S["melee"], melee)
	WRITE_FILE(S["performance"], performance)
	WRITE_FILE(S["stealth"], stealth)
	WRITE_FILE(S["survival"], survival)

	//Knowledges
	WRITE_FILE(S["academics"], academics)
	WRITE_FILE(S["computer"], computer)
	WRITE_FILE(S["finance"], finance)
	WRITE_FILE(S["investigation"], investigation)
	WRITE_FILE(S["law"], law)
	WRITE_FILE(S["medicine"], medicine)
	WRITE_FILE(S["occult"], occult)
	WRITE_FILE(S["politics"], politics)
	WRITE_FILE(S["science"], science)
	WRITE_FILE(S["technology"], technology)

	//Virtues
	WRITE_FILE(S["conscience"], conscience)
	WRITE_FILE(S["self_control"], self_control)
	WRITE_FILE(S["conviction"], conviction)
	WRITE_FILE(S["instinct"], instinct)
	WRITE_FILE(S["courage"], courage)


/datum/preferences/proc/reset_stats()
	stat_points = initial(stat_points)

	// Pooled
	permanent_willpower = initial(permanent_willpower)
	temporary_willpower = initial(temporary_willpower)

	// Physical
	strength = initial(strength)
	dexterity = initial(dexterity)
	stamina = initial(stamina)

	// Social
	charisma = initial(charisma)
	manipulation = initial(manipulation)
	appearance = initial(appearance)

	// Mental
	perception = initial(perception)
	intelligence = initial(intelligence)
	wits = initial(wits)

	// Talents
	alertness = initial(alertness)
	athletics = initial(athletics)
	awareness = initial(awareness)
	brawl = initial(brawl)
	empathy = initial(empathy)
	expression = initial(expression)
	intimidation = initial(intimidation)
	leadership = initial(leadership)
	streetwise = initial(streetwise)
	subterfuge = initial(subterfuge)

	// Skills
	animal_ken = initial(animal_ken)
	crafts = initial(crafts)
	drive = initial(drive)
	etiquette = initial(etiquette)
	firearms = initial(firearms)
	larceny = initial(larceny)
	melee = initial(melee)
	performance = initial(performance)
	stealth = initial(stealth)
	survival = initial(survival)

	// Knowledges
	academics = initial(academics)
	computer = initial(computer)
	finance = initial(finance)
	investigation = initial(investigation)
	law = initial(law)
	medicine = initial(medicine)
	occult = initial(occult)
	politics = initial(politics)
	science = initial(science)
	technology = initial(technology)

	//Virtues
	conscience = initial(conscience)
	self_control = initial(self_control)
	conviction = initial(conviction)
	instinct = initial(instinct)
	courage = initial(courage)

/datum/preferences/proc/sanitize_stats()
	stat_points = sanitize_integer(stat_points, 0, 35, initial(stat_points))

	permanent_willpower = sanitize_integer(permanent_willpower, 0, 10, initial(permanent_willpower))
	temporary_willpower = sanitize_integer(temporary_willpower, 0, 10, initial(temporary_willpower))

	//Physical
	strength = sanitize_integer(strength, 1, 5, initial(strength))
	dexterity = sanitize_integer(dexterity, 1, 5, initial(dexterity))
	stamina = sanitize_integer(stamina, 1, 5, initial(stamina))

	//Social
	charisma = sanitize_integer(charisma, 1, 5, initial(charisma))
	manipulation = sanitize_integer(manipulation, 1, 5, initial(manipulation))
	appearance = sanitize_integer(appearance, 1, 5, initial(appearance))

	//Mental
	perception = sanitize_integer(perception, 1, 5, initial(perception))
	intelligence = sanitize_integer(intelligence, 1, 5, initial(intelligence))
	wits = sanitize_integer(wits, 1, 5, initial(wits))

	//Talents
	alertness = sanitize_integer(alertness, 1, 5, initial(alertness))
	athletics = sanitize_integer(athletics, 1, 5, initial(athletics))
	awareness = sanitize_integer(awareness, 1, 5, initial(awareness))
	brawl = sanitize_integer(brawl, 1, 5, initial(brawl))
	empathy = sanitize_integer(empathy, 1, 5, initial(empathy))
	expression = sanitize_integer(expression, 1, 5, initial(expression))
	intimidation = sanitize_integer(intimidation, 1, 5, initial(intimidation))
	leadership = sanitize_integer(leadership, 1, 5, initial(leadership))
	streetwise = sanitize_integer(streetwise, 1, 5, initial(streetwise))
	subterfuge = sanitize_integer(subterfuge, 1, 5, initial(subterfuge))

	//Talents
	animal_ken = sanitize_integer(animal_ken, 1, 5, initial(animal_ken))
	crafts = sanitize_integer(crafts, 1, 5, initial(crafts))
	drive = sanitize_integer(drive, 1, 5, initial(drive))
	etiquette = sanitize_integer(etiquette, 1, 5, initial(etiquette))
	firearms = sanitize_integer(firearms, 1, 5, initial(firearms))
	larceny = sanitize_integer(larceny, 1, 5, initial(larceny))
	melee = sanitize_integer(melee, 1, 5, initial(melee))
	performance = sanitize_integer(performance, 1, 5, initial(performance))
	stealth = sanitize_integer(stealth, 1, 5, initial(stealth))
	survival = sanitize_integer(survival, 1, 5, initial(survival))

	//Knowledges
	academics = sanitize_integer(academics, 1, 5, initial(academics))
	computer = sanitize_integer(computer, 1, 5, initial(computer))
	finance = sanitize_integer(finance, 1, 5, initial(finance))
	investigation = sanitize_integer(investigation, 1, 5, initial(investigation))
	law = sanitize_integer(law, 1, 5, initial(law))
	medicine = sanitize_integer(medicine, 1, 5, initial(medicine))
	occult = sanitize_integer(occult, 1, 5, initial(occult))
	politics = sanitize_integer(politics, 1, 5, initial(politics))
	science = sanitize_integer(science, 1, 5, initial(science))
	technology = sanitize_integer(technology, 1, 5, initial(technology))

	//Virtues
	conscience = sanitize_integer(conscience, 0, 5, initial(conscience))
	self_control = sanitize_integer(self_control, 0, 5, initial(self_control))
	conviction = sanitize_integer(conviction, 0, 5, initial(conviction))
	instinct = sanitize_integer(instinct, 0, 5, initial(instinct))
	courage = sanitize_integer(courage, 1, 5, initial(courage))
