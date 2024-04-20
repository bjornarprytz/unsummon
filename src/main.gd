class_name GameState
extends Node2D

@onready var map: Map = $Map

var moves: Array[GlyphTile] = []

var player: Player = Player.new()

func _commit_word():
	if moves.size() == 1:
		push_warning("Cannot commit a single glyph")
	player.commit_word()
	var cursorCoords = moves[moves.size() - 1].coordinates
	for glyph in moves:
		map.remove_glyph(glyph.coordinates)
	moves.clear()
	
	map.tumble_glyphs()

	var initialGlyph = map.get_glyph(cursorCoords)
	moves.push_back(initialGlyph)
	player.add_glyph(initialGlyph.get_glyph())
	initialGlyph.modulate = Color(1, 0, 0)

func _utter_spell():
	player.utter_spell()

func _undo():
	if moves.size() == 1:
		push_warning("Cannot undo any further")
		return

	print(player.remove_glyph())
	var cursor = moves[moves.size() - 1]
	cursor.modulate = Color(1, 1, 1, 1)
	moves.pop_back()

func _read(direction: Vector2i):
	print("Reading in direction: ", direction)
	var cursor = moves[moves.size() - 1]
	var next = cursor.get_relative_glyph(direction)

	if next in moves:
		push_warning("Cannot move to the same glyph twice")
		return
	
	if next != null:
		moves.push_back(next)
		print(player.add_glyph(next.get_glyph()))
		next.modulate = Color(1, 0, 0)
	else:
		push_warning("No glyph in that direction")

func _ready() -> void:
	var cursor = map.get_middle_glyph()
	moves.push_back(cursor)
	player.add_glyph(cursor.get_glyph())
	cursor.modulate = Color(1, 0, 0)

	pass

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				_commit_word()
			KEY_ENTER:
				_utter_spell()
			KEY_BACKSPACE:
				_undo()
			KEY_UP, KEY_W:
				_read(Vector2i.UP)
			KEY_DOWN, KEY_S:
				_read(Vector2i.DOWN)
			KEY_LEFT, KEY_A:
				_read(Vector2i.LEFT)
			KEY_RIGHT, KEY_D:
				_read(Vector2i.RIGHT)
