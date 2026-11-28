extends Control


# ==========================================
# SCENE
# ==========================================

@export var level_select_scene: PackedScene


# ==========================================
# AUDIO MENU
# ==========================================
@onready var menu_music: AudioStreamPlayer = get_node_or_null("MenuMusic")


# ==========================================
# BUTTON
# ==========================================

@onready var play_button: TextureButton = $PlayButton
@onready var skin_button: TextureButton = $SkinButton
@onready var exit_button: TextureButton = $ExitButton


# ==========================================
# READY
# ==========================================

func _ready():

	get_tree().paused = false

	# Putar musik menu saat game dibuka
	if menu_music != null and not menu_music.playing:
		menu_music.volume_db = -8.0
		menu_music.play()

	play_button.pressed.connect(
		_on_play_pressed
	)

	skin_button.pressed.connect(
		_on_skin_pressed
	)

	exit_button.pressed.connect(
		_on_exit_pressed
	)


# ==========================================
# PLAY
# ==========================================

func _on_play_pressed():

	print("PLAY DIPENCET → LEVEL SELECT")

	# Hentikan musik menu sebelum pindah scene
	if menu_music != null:
		menu_music.stop()

	if level_select_scene == null:

		print("ERROR: LEVEL SELECT SCENE BELUM DIISI!")

		return


	get_tree().change_scene_to_packed(
		level_select_scene
	)


# ==========================================
# SKIN
# ==========================================

func _on_skin_pressed():

	print("SKIN DIPENCET")

	# Nanti kita buat halaman Skin


# ==========================================
# EXIT
# ==========================================

func _on_exit_pressed():

	print("EXIT DIPENCET")

	get_tree().quit()
