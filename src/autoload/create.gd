class_name Factory
extends Node2D

@onready var glyphFactory = preload ("res://systems/map/glyph_tile.tscn")

static var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

func glyphTile(character: String="") -> GlyphTile:
	if character == "":
		character = alphabet.pick_random()

	assert(character.length() == 1, "Character must be a single character")
	var glyphScene = glyphFactory.instantiate() as GlyphTile
	glyphScene.character = character
	
	return glyphScene
