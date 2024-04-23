class_name GameState
extends Node2D

@onready var map: Map = $Map
@onready var ui: UI = $UI

var moves: Array[GlyphTile] = []

var player: Player = Player.new()

var isReadingWord: bool = false
var currentHoveredGlyph: GlyphTile = null

func _commit_word():
	print("Committing word")
	if moves.size() == 1:
		push_warning("Cannot commit a single glyph")
		return
	
	if player.commit_word(): # Check if word is valid
		print("Word is valid")
		for glyph in moves:
			map.remove_glyph(glyph.coordinates)
	else:
		print("Word is invalid")
		player.clear_word()
		for glyph in moves:
			glyph.set_marked(false)
			
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

func _tryReadGlyph(tile: GlyphTile):
	if tile in moves:
		var index = moves.find(tile)
		while moves.size() > index + 1:
			_undo()
		return
	
	moves.push_back(tile)
	player.add_glyph(tile.get_glyph())
	tile.set_marked(true)

func _ready() -> void:
	map.glyphHovered.connect(_onGlyphHovered)
	player.changed.connect(_onPlayerChanged)

func _onPlayerChanged() -> void:
	ui.update(player)

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
				if currentHoveredGlyph != null:
					_tryReadGlyph(currentHoveredGlyph)
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
