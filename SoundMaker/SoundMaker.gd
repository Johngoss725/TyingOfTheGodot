extends Control

var player: AudioStreamPlayer
var generator: AudioStreamGenerator
var playback: AudioStreamGeneratorPlayback

func _ready():
	player = $AudioStreamPlayer
	generator = AudioStreamGenerator.new()
	generator.mix_rate = 44100
	generator.buffer_length = 0.5
	player.stream = generator
	player.play()
	playback = player.get_stream_playback()

	# Play one of three zombie sounds
	match  2:
		0:
			zombie_growl()
		1:
			zombie_glitch()
		2:
			zombie_grunt()

func zombie_growl():
	var duration = 0.5
	var samples = int(generator.mix_rate * duration)
	for i in range(samples):
		var t = i / generator.mix_rate
		var growl = sin(2.0 * PI * 80.0 * t + randf() * 0.5)
		growl *= exp(-5 * t)  # decay
		playback.push_frame(Vector2(growl, growl))

		#playback.push_frame(AudioFrame(growl, growl))

func zombie_glitch():
	var duration = 0.3
	var samples = int(generator.mix_rate * duration)
	for i in range(samples):
		var t = i / generator.mix_rate
		var glitch = sign(sin(2.0 * PI * 120.0 * t)) * randf() * 0.6
		glitch *= exp(-4 * t)
		playback.push_frame(Vector2(glitch, glitch))

func zombie_grunt():
	var duration = 0.2
	var samples = int(generator.mix_rate * duration)
	for i in range(samples):
		var t = i / generator.mix_rate
		var pitch = 50.0 + randf() * 20.0
		var grunt = sin(2.0 * PI * pitch * t) * (1.0 - t)
		playback.push_frame(Vector2(grunt, grunt))
