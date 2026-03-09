extends CollisionShape
var startPos

func _ready():
	startPos = $"%Player".translation
func _on_Area_body_entered(body):
	if body.name == "Player":
		$"%fall".play()
		body.translation = startPos
