extends Area2D

var finished: bool = false


func _ready():
	print("FINISH LINE SIAP!")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	print("FINISH MENDETEKSI: ", body.name)

	if finished:
		return

	if body is CharacterBody2D:
		finished = true

		print("NARA MASUK FINISH!")

		var level = get_tree().current_scene

		if level.has_method("level_complete"):
			print("MEMANGGIL LEVEL COMPLETE!")
			level.level_complete()
