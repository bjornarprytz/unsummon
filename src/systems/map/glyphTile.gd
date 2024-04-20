class_name GlyphTile
extends Node2D

signal hovered(glyph: GlyphTile, hovered: bool)

var character: String:
	set(value):
		if value == character:
			return
		
		if value.length() != 1:
			return

		character = value
		_update_glyph()

var coordinates: Vector2i = Vector2i.ZERO
var map: Map

func get_glyph() -> Language.Glyph:
	return Language.Glyph.new(character)

var _glyph: RichTextLabel:
	get:
		return $Glyph
	
var _explanation: RichTextLabel:
	get:
		return $Explanation

var size: Vector2:
	get:
		return _glyph.get_rect().size

func set_marked(mark: bool):
	if mark:
		_glyph.modulate = Color(1, 0, 0)
	else:
		_glyph.modulate = Color(1, 1, 1)

func get_relative_glyph(vec: Vector2i) -> GlyphTile:
	return map.get_glyph(coordinates + vec)

func get_neighbours() -> Array:
	var neighbours = []
	for vec in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
		var neighbour = get_relative_glyph(vec)
		if neighbour != null:
			neighbours.append(neighbour)
	return neighbours

func _update_glyph():
	_glyph.text = "[center]%s" % character
	_explanation.text = "%d" % Language.Glyph.new(character).cardinal()

func _on_glyph_mouse_entered() -> void:
	hovered.emit(self, true)

func _on_glyph_mouse_exited() -> void:
	hovered.emit(self, false)
