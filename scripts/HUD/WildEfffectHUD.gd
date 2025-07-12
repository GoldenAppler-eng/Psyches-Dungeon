extends RichTextLabel

@export var card_handler : CardHandler

func _ready() -> void:
	card_handler.card_changed.connect(_on_card_changed)

func _on_card_changed() -> void:
	var current_card_info : CardResource = card_handler.current
	
	text = "[color=" + current_card_info.get_effect_color_hex() + "]" + current_card_info.effect_text + "[/color]"
