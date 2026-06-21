extends AudioStreamPlayer

@export var hit: AudioStream
@export var buzzer: AudioStream
@export var explosion: AudioStream
@export var bump: AudioStream

func play_sound(sound: AudioStream, randomness: float = 0, new_volume_db: float = 0):
	var player = AudioStreamPlayer.new()
	player.pitch_scale = randf_range(1 - randomness, 1 + randomness)
	player.stream = sound
	player.volume_db = new_volume_db
	player.connect("finished", player.queue_free)
	add_child(player)
	player.play()
