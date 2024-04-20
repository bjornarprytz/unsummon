class_name Map
extends Node2D

signal glyphHovered(glyph: GlyphTile)

var height := 5
var width := 9

@onready var glyphs: Node2D = $Glyphs

var _glyph_lookup: Array[Array] = []

func _ready() -> void:
	for y in range(height):
		_glyph_lookup.append([])
		for x in range(width):
			var glyph = _create_glyph(x, y)
			_glyph_lookup[y].append(glyph)

func remove_glyph(coords: Vector2i) -> void:
	var y = coords.y
	var x = coords.x

	if y < 0 or y >= height or x < 0 or x >= width:
		return

	var glyph = _glyph_lookup[y][x]
	glyphs.remove_child(glyph)
	_glyph_lookup[y][x] = null

func cycle_glyphs(coords: Array[Vector2i]) -> void:
	if coords.size() < 2:
		return
	
	var glyphsToCycle: Array[GlyphTile] = []
	
	for i in range(coords.size()):
		var coord = coords[i]
		var glyph = self.get_glyph(coord)
		assert(glyph != null, "Invalid coordinates")
		glyphsToCycle.append(glyph)

	for i in range(coords.size()):
		var nextIndex = (i + 1) % coords.size()
		var glyph = glyphsToCycle[i]
		var targetCoord = coords[nextIndex]
		_move_glyph(glyph, targetCoord)
		_glyph_lookup[targetCoord.y][targetCoord.x] = glyph

func tumble_glyphs() -> void:
	for y in range(height - 1, -1, -1):
		for x in range(width - 1, -1, -1):
			if get_glyph(Vector2i(x, y)) == null:
				# Find next glyph above and move it here
				for i in range(y - 1, -1, -1):
					var glyph = get_glyph(Vector2i(x, i))
					if glyph != null:
						_move_glyph(glyph, Vector2i(x, y))
						_glyph_lookup[y][x] = glyph
						_glyph_lookup[i][x] = null
						break
				# Otherwise, create a new one at the top
				if get_glyph(Vector2i(x, y)) == null:
					var newGlyph = _create_glyph(x, y)
					newGlyph.position = Vector2(x, -(height + 1)) * newGlyph.size

func get_glyph(coordinates: Vector2i) -> GlyphTile:
	var y = coordinates.y
	var x = coordinates.x

	if y < 0 or y >= height or x < 0 or x >= width:
		return null
	
	return _glyph_lookup[y][x]

func get_middle_glyph() -> GlyphTile:
	return get_glyph(Vector2i(int(width / 2.0), int(height / 2.0)))

func _move_glyph(glyph: GlyphTile, targetCoord: Vector2i):
	var tween = create_tween()
	tween.tween_property(glyph, "position", Vector2(targetCoord.x, targetCoord.y) * glyph.size, 0.5)
	glyph.coordinates = targetCoord

func _create_glyph(x: int, y: int) -> GlyphTile:
	var glyph = Create.glyphTile()
	glyph.position = glyph.size * Vector2(x, y)
	glyph.coordinates = Vector2(x, y)
	glyph.map = self
	glyph.hovered.connect(_on_GlyphTile_hovered)
	glyphs.add_child(glyph)
	_move_glyph(glyph, Vector2i(x, y))
	if _glyph_lookup[y].size() > x:
		_glyph_lookup[y][x] = glyph
	else:
		_glyph_lookup[y].append(glyph)

	return glyph

func _on_GlyphTile_hovered(glyph: GlyphTile, hovered: bool) -> void:
	if hovered:
		glyphHovered.emit(glyph)
