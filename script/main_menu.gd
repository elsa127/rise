extends Control


# ==========================================
# SCENE
# ==========================================

@export var level_select_scene: PackedScene


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
