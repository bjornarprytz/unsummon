class_name Map
extends Node2D

var height := 5
var width := 9

@onready var glyphs: Node2D = $Glyphs

func _ready() -> void:
	for y in range(height):
		for x in range(width):
			var glyph = Create.glyphTile()
			
			glyph.position = glyph.size * Vector2(x, y)
			glyphs.add_child(glyph)
