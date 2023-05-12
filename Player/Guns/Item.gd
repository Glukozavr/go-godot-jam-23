extends Node3D

@export var type = 'sword'

func _ready():
	$AnimatedSprite3D.play("default")

func _on_area_3d_body_entered(body):
	print("Body entered ", body)
	body.item_found(self)


func _on_area_3d_body_exited(body):
	print("Body left ", body)
	body.item_lost(self)
	
	
func consume():
	print("Item used")
	queue_free()
