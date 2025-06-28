extends Node

@export var bpm := 90.0

# === BASS THUMP (Quarter Notes) ===
@export var bass_note := "C2"
@export var bass_volume := 0.5
@export var bass_duration := 0.12

# === HIGH CHIRP (Sixteenth Notes) ===
@export var chirp_note := "E6"
@export var chirp_volume := 0.15
@export var chirp_duration := 0.04

# === HAUNTING DRONE ===
@export var drone_note := "D#3"
@export var drone_volume := 0.25
@export var drone_vibrato_rate := 0.5  # Hz
@export var drone_vibrato_depth := 4.0  # +/- Hz
@export var drone_envelope_length := 6.0  # seconds (triangle fade in/out)

# === INTERNAL ===
var player: AudioStreamPlayer
var generator: AudioStreamGenerator
var playback: AudioStreamGeneratorPlayback
var time := 0.0

var bass_interval := 0.0
var chirp_interval := 0.0
var last_bass_time := 0.0
var last_chirp_time := 0.0

func _ready():
	player = $AudioStreamPlayer
	generator = AudioStreamGenerator.new()
	generator.mix_rate = 44100
	generator.buffer_length = 0.5
	player.stream = generator
	player.play()
	playback = player.get_stream_playback()

	var beat_sec = 60.0 / bpm
	bass_interval = beat_sec               # quarter note
	chirp_interval = beat_sec / 4.0        # sixteenth note

	set_process(true)

func _process(delta):
	var frames = playback.get_frames_available()
	var bass_freq = note_to_freq(bass_note)
	var chirp_freq = note_to_freq(chirp_note)
	var drone_freq = note_to_freq(drone_note)

	for i in range(frames):
		var t = time + float(i) / generator.mix_rate
		var sample := 0.0

		# === Bass Thump ===
		if t - last_bass_time < bass_duration:
			var local_t = t - last_bass_time
			var envelope = 1.0 - (local_t / bass_duration)
			sample += sin(2.0 * PI * bass_freq * local_t) * envelope * bass_volume
		elif t >= last_bass_time + bass_interval:
			last_bass_time += bass_interval

		# === Chirp Tick ===
		if t - last_chirp_time < chirp_duration:
			var local_t = t - last_chirp_time
			var envelope = 1.0 - (local_t / chirp_duration)
			sample += sin(2.0 * PI * chirp_freq * local_t) * envelope * chirp_volume
		elif t >= last_chirp_time + chirp_interval:
			last_chirp_time += chirp_interval

		# === Haunting Drone ===
		var vibrato = sin(2.0 * PI * drone_vibrato_rate * t) * drone_vibrato_depth
		var final_freq = drone_freq + vibrato

		var fade_cycle = fmod(t, drone_envelope_length * 2.0)
		var fade = (fade_cycle / drone_envelope_length)
		fade = 1.0 - abs(1.0 - fade)  # triangle fade in/out
		var drone = sin(2.0 * PI * final_freq * t) * drone_volume * fade
		sample += drone

		playback.push_frame(Vector2(sample, sample))

	time += float(frames) / generator.mix_rate

# === NOTE TO FREQUENCY ===
func note_to_freq(note: String) -> float:
	var note_names = {
		"C": 0, "C#": 1, "Db": 1,
		"D": 2, "D#": 3, "Eb": 3,
		"E": 4,
		"F": 5, "F#": 6, "Gb": 6,
		"G": 7, "G#": 8, "Ab": 8,
		"A": 9, "A#": 10, "Bb": 10,
		"B": 11
	}

	var regex = RegEx.new()
	regex.compile(r"^([A-Ga-g][#b]?)(-?\d+)$")
	var result = regex.search(note)
	if result == null:
		return 440.0  # fallback: A4

	var note_name = result.get_string(1).to_upper()
	var octave = int(result.get_string(2))

	var semitone = note_names.get(note_name, 0)
	var midi_note = (octave + 1) * 12 + semitone
	return 440.0 * pow(2.0, (midi_note - 69) / 12.0)
