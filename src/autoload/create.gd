class_name Factory
extends Node2D

@onready var glyphFactory = preload ("res://systems/map/glyph_tile.tscn")

func glyphTile(character: String="") -> GlyphTile:
	if character == "":
		character = Language.random_letter()

	assert(character.length() == 1, "Character must be a single character")
	var glyphScene = glyphFactory.instantiate() as GlyphTile
	glyphScene.character = character
	
	return glyphScene
