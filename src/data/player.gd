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

func add_glyph(glyph: Language.Glyph):
    currentWord.append([glyph])

func remove_glyph():
    currentWord.pop_glyph()

func commit_word():
    if currentWord.is_valid():
        currentSpell.add_word(currentWord)
        currentWord = Language.Word.new()

func utter_spell():
    if currentSpell.is_valid():
        
        bindingPower += currentSpell.compute_harmony()

        spells.append(currentSpell)
        currentSpell = Language.Spell.new()