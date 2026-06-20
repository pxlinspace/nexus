extends CanvasLayer

@onready var flashbang: ColorRect = $Flashbang

func _ready() -> void:
	flashbang.color.a = 0

func flash():
	var tween = create_tween()
	flashbang.color.a = 0.8
	tween.tween_property(flashbang, "color:a", 0, 0.2)
