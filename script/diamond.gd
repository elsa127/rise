extends Area2D

signal collected

var already_collected = false


func _ready():
	add_to_group("diamond")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if already_collected:
		return

	if body is CharacterBody2D:
		already_collected = true
		collected.emit()
		queue_free()
