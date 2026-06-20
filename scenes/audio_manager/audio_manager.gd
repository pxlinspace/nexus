extends AudioStreamPlayer

@export var hit: AudioStream
@export var buzzer: AudioStream

func play_sound(sound: AudioStream, randomness: float = 0):
	var player = AudioStreamPlayer.new()
	player.pitch_scale = randf_range(1 - randomness, 1 + randomness)
	player.stream = sound
	player.connect("finished", player.queue_free)
	add_child(player)
	player.play()
