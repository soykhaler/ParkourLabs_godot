extends Area
func _on_Area4_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://endScene.tscn")
