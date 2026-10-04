extends Control

@onready var pause_button: TextureButton = $"../PauseButton"
@onready var resume_button: TextureButton = $ResumeButton
@onready var restart_button: TextureButton = $RestartButton
@onready var close_button: TextureButton = $CloseButton
@onready var main_menu_button: TextureButton = $MainMenuButton


func _ready():
	visible = false

	pause_button.pressed.connect(pause_game)
	resume_button.pressed.connect(resume_game)
	close_button.pressed.connect(resume_game)
	restart_button.pressed.connect(restart_game)
	main_menu_button.pressed.connect(go_to_main_menu)


func pause_game():
	get_tree().paused = true
	visible = true


func resume_game():
	visible = false
	get_tree().paused = false


func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()


func go_to_main_menu():
	get_tree().paused = false

	# Nanti ganti path ini sesuai scene Main Menu kamu
	# get_tree().change_scene_to_file("res://scene/main_menu.tscn")
