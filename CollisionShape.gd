extends CollisionShape
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.translation = Vector3(2.738,2.382,-5.913)
