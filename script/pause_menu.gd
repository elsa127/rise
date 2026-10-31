extends Control


# =====================================================
# SCENE TUJUAN
# Drag main_menu.tscn ke Inspector
# =====================================================

@export var main_menu_scene: PackedScene


# =====================================================
# NODE
# =====================================================

@onready var pause_button: TextureButton = $"../PauseButton"

@onready var close_button: TextureButton = $CloseButton
@onready var resume_button: TextureButton = $ResumeButton
@onready var restart_button: TextureButton = $RestartButton
@onready var main_menu_button: TextureButton = $MainMenuButton


# =====================================================
# READY
# =====================================================

func _ready():

	# Supaya PauseMenu tetap bisa menerima klik
	# saat game pause maupun tidak pause
	process_mode = Node.PROCESS_MODE_ALWAYS

	visible = false


	pause_button.disabled = false
	close_button.disabled = false
	resume_button.disabled = false
	restart_button.disabled = false
	main_menu_button.disabled = false


	pause_button.pressed.connect(_on_pause_pressed)
	close_button.pressed.connect(_on_close_pressed)
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


# =====================================================
# PAUSE
# =====================================================

func _on_pause_pressed():

	print("PAUSE BUTTON DIPENCET")

	visible = true

	get_tree().paused = true


# =====================================================
# CLOSE
# =====================================================

func _on_close_pressed():

	print("CLOSE BUTTON DIPENCET")

	resume_game()


# =====================================================
# RESUME
# =====================================================

func _on_resume_pressed():

	print("RESUME BUTTON DIPENCET")

	resume_game()


func resume_game():

	visible = false

	get_tree().paused = false


# =====================================================
# RESTART
# =====================================================

func _on_restart_pressed():

	print("RESTART BUTTON DIPENCET")

	get_tree().paused = false

	get_tree().reload_current_scene()


# =====================================================
# MAIN MENU
# =====================================================

func _on_main_menu_pressed():

	print("MAIN MENU PAUSE DIPENCET")

	get_tree().paused = false


	if main_menu_scene == null:

		print("ERROR: MAIN MENU SCENE BELUM DIISI!")

		return


	get_tree().change_scene_to_packed(
		main_menu_scene
	)


# =====================================================
# ESC
# =====================================================

func _unhandled_input(event):

	if event.is_action_pressed("ui_cancel"):

		if get_tree().paused:

			resume_game()

		else:

			_on_pause_pressed()
