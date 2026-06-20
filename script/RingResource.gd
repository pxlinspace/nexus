class_name RingResource extends Resource

enum RingType {
	SPADES_UP,
	CLUBS_DOWN,
	HEARTS_LEFT,
	DIAMONDS_RIGHT
}

@export var name: String
@export var desc: String
@export var texture: Texture2D
@export var type: RingType
