class_name Map
extends Node2D

var height := 5
var width := 9

@onready var glyphs: Node2D = $Glyphs

var _glyph_lookup: Array[Array] = []

func _ready() -> void:
	for y in range(height):
		_glyph_lookup.append([])
		for x in range(width):
			var glyph = Create.glyphTile()
			
			glyph.position = glyph.size * Vector2(x, y)
			glyph.coordinates = Vector2(x, y)
			glyph.map = self
			glyphs.add_child(glyph)

			_glyph_lookup[y].append(glyph)

func get_glyph(coordinates: Vector2i) -> GlyphTile:
	var y = coordinates.y
	var x = coordinates.x

	if y < 0 or y >= height or x < 0 or x >= width:
		return null
	
	return _glyph_lookup[y][x]
