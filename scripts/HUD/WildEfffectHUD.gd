extends RichTextLabel

@export var card_handler : CardHandler

func _ready() -> void:
	card_handler.card_changed.connect(_on_card_changed)

func _on_card_changed() -> void:
	text = card_handler.current.effect_text
