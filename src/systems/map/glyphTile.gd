class_name GlyphTile
extends Node2D

var character: String:
	set(value):
		if value == character:
			return
		
		if value.length() != 1:
			return

		character = value
		_update_glyph()

var glyph: RichTextLabel:
	get:
		return $Glyph
	
var explanation: RichTextLabel:
	get:
		return $Explanation

var size: Vector2:
	get:
		return glyph.get_rect().size

func _update_glyph():
	glyph.text = "[center]%s" % character
	explanation.text = character
