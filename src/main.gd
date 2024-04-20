class_name GameState
extends Node2D

@onready var map: Map = $Map

var moves: Array[GlyphTile] = []

var player: Player = Player.new()

var isReadingWord: bool = false
var currentHoveredGlyph: GlyphTile = null

func _commit_word():
	if moves.size() == 1:
		push_warning("Cannot commit a single glyph")
	player.commit_word()
	var cursorCoords = moves[moves.size() - 1].coordinates
	for glyph in moves:
		map.remove_glyph(glyph.coordinates)
	moves.clear()
	
	map.tumble_glyphs()

func _utter_spell():
	player.utter_spell()

func _undo():
	if moves.size() == 1:
		push_warning("Cannot undo any further")
		return

	player.remove_glyph()
	var cursor = moves[moves.size() - 1]
	cursor.set_marked(false)
	moves.pop_back()

func _cancel_reading():
	for glyph in moves:
		glyph.set_marked(false)
	moves.clear()
	isReadingWord = false

func _tryReadGlyph(glyph: GlyphTile):
	if glyph in moves:
		var index = moves.find(glyph)
		while moves.size() > index + 1:
			_undo()
		return
	
	moves.push_back(glyph)
	print(player.add_glyph(glyph.get_glyph()))
	glyph.set_marked(true)

func _ready() -> void:
	map.glyphHovered.connect(_onGlyphHovered)

func _onGlyphHovered(glyph: GlyphTile) -> void:
	
	if (isReadingWord):
		_tryReadGlyph(glyph)

	currentHoveredGlyph = glyph

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and currentHoveredGlyph != null:
			if event.is_pressed():
				if event.is_echo():
					return
				isReadingWord = true
				assert(moves.size() == 0)
				if currentHoveredGlyph != null:
					moves.push_back(currentHoveredGlyph)
					currentHoveredGlyph.set_marked(true)
			elif isReadingWord:
				_commit_word()
				currentHoveredGlyph = null
				isReadingWord = false
		elif isReadingWord and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			_cancel_reading()
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				_commit_word()
			KEY_ENTER:
				_utter_spell()
