class_name Player
extends Resource

var currentWord: Language.Word = Language.Word.new()
var currentSpell: Language.Spell = Language.Spell.new()
var spells: Array[Language.Spell] = []

var bindingPower: int = 0:
	set(value):
		if value == bindingPower:
			return
		
		bindingPower = value
		emit_changed()

func add_glyph(glyph: Language.Glyph) -> int:
	currentWord.append([glyph])
	print("Added glyph: ", glyph._character)

	emit_changed()
	return currentWord.harmony()

func remove_glyph():
	currentWord.pop_glyph()

	print("Removed glyph")

	emit_changed()
	return currentWord.harmony()

func clear_word():
	currentWord = Language.Word.new()

	print("Cleared word")

	emit_changed()

func commit_word() -> bool:
	if currentWord.is_valid():
		var power = currentWord.harmony()
		currentSpell.add_word(currentWord)
		currentWord = Language.Word.new()

		bindingPower += power
	
		emit_changed()
		return true
	return false

func utter_spell() -> bool:
	if currentSpell.is_valid():
		
		bindingPower += currentSpell.compute_harmony()

		spells.append(currentSpell)
		currentSpell = Language.Spell.new()
	
		emit_changed()
		return true
	return false
