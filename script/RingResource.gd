class_name RingResource extends Resource

enum RingType {
	NOTHING,
	SPADES_BOTTOM_LEFT,
	CLUBS_BOTTOM_RIGHT,
	HEARTS_LEFT,
	DIAMONDS_RIGHT,
	HEAVY,
	THORN,
	ONE_RING,
	WEDDING
}

@export var name: String
@export var desc: String
@export var desc_graphic: Texture2D
@export var texture: Texture2D
@export var finger_texture: Texture2D
@export var type: RingType
@export var turn_lifespan: int = 9
