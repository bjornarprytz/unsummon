class_name UI
extends VBoxContainer

@onready var _bindingPower: RichTextLabel = $BindingPower/Value
@onready var _fibHarmony: RichTextLabel = $Fib/Value
@onready var _cardHarmony: RichTextLabel = $Cardinal/Value
@onready var _primHarmony: RichTextLabel = $Primal/Value

func update(player: Player):
	_bindingPower.text = "[right]%d" % player.bindingPower
	_fibHarmony.text = "[right]%d" % player.currentWord.fibHarmony
	_cardHarmony.text = "[right]%d" % player.currentWord.cardHarmony
	_primHarmony.text = "[right]%d" % player.currentWord.primHarmony
