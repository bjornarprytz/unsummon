class_name GameState
extends Node2D

@onready var map: Map = $Map

var player: Player = Player.new()

func _commit_word():
    player.commit_word()

func _utter_spell():
    player.utter_spell()

func _undo():
    player.remove_glyph()
    # TODO: Retrace the glyphs in the current word

func _read(character: String):
    assert(character.length() == 1, "Can only read 1 character at a time")

    if !Language.is_letter(character):
        return
    
    var options: Array[GlyphTile] = []

    # TODO: Find all options (glyphs that match the character)
    
    if options.size() == 1:
        var targetGlyph = options[0]
        # TODO: Move, and update player object
        return

func _ready() -> void:
    # TODO: Set initial conditions for cursor
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
            _:
                var val = char(event.keycode).to_lower()
                _read(val)
