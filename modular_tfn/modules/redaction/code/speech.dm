#define REDACTION_FILTER_CHECK(T) (SSredaction.redacted_words_regex && findtext(T, SSredaction.redacted_words_regex))

#define REDACTION "█"

/mob/living/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!lowertext(REDACTION_FILTER_CHECK(message)))
		return ..()

	var/character_count = length(SSredaction.redacted_words_regex.match)

	var/generated_redaction = ""
	for(var/i in 1 to character_count)
		generated_redaction += REDACTION

	var/redacted_sentence = replace_text(message, SSredaction.redacted_words_regex.match, generated_redaction)

	message = redacted_sentence
	..()

#undef REDACTION_FILTER_CHECK
