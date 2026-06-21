class_name PlayerData extends Node

enum RING_RARITY {
	COMMON,
	UNCOMMON,
	RARE
}

const RARITY_RING_MAP: Dictionary[RING_RARITY, Array] = {
	RING_RARITY.COMMON: [
		"res://resources/normal.tres",
		# "res://resources/double.tres",
	],
	RING_RARITY.UNCOMMON: [
		"res://resources/clubs_bottom_right.tres",
		"res://resources/diamonds_right.tres",
		"res://resources/hearts_left.tres",
		"res://resources/spades_bottom_left.tres",
		"res://resources/copy.tres"
	],
	RING_RARITY.RARE: [
		"res://resources/heavy.tres",
		"res://resources/thorn.tres",
		"res://resources/copy.tres",
		"res://resources/wedding.tres",
	],
}

const RING_COUNT: int = 5
const NORMAL = preload("uid://devp2cw6v1fru")

@export var ring_resources = []
var ring_ages: Array[int] = []


func _ready() -> void:
	for i in RING_COUNT:
		#ring_resources.append(_get_random_ring_resource())
		ring_resources.append(NORMAL)
		ring_ages.append(0)


func replace_ring(index) -> void:
	ring_resources[index] = _get_random_ring_resource()


func increment_ring_ages() -> void:
	for i in RING_COUNT:
		ring_ages[i] += 1
		if ring_ages[i] >= ring_resources[i].turn_lifespan:
			ring_ages[i] = 0
			replace_ring(i)


func _get_random_ring_resource() -> RingResource:
	var rarity_rand: float = randf()
	var rarity: RING_RARITY
	if rarity_rand < 0.1:
		rarity = RING_RARITY.RARE
	elif rarity_rand < 0.4:
		rarity = RING_RARITY.UNCOMMON
	else:
		rarity = RING_RARITY.COMMON
	var ring_array: Array = RARITY_RING_MAP[rarity]
	var ring_resource_path: String = ring_array[randi_range(0, ring_array.size()-1)]
	return load(ring_resource_path)
