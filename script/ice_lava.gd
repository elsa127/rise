extends Area2D

@export var rise_speed: float = 100.0

var triggered = false


func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta):
	global_position.y -= rise_speed * delta


func _on_body_entered(body):
	if triggered:
		return

	if body is CharacterBody2D:
		triggered = true

		var level = get_tree().current_scene

		if level.has_method("instant_game_over"):
			level.instant_game_over()
