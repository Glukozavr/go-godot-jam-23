# A simple collectible item. Have s collision shape and some represetation with
# an area for player collision. Representation is coded to be AnimatedSprite3D
# with a default animation.
extends Node3D

@export var type: = "sword"
@export var description: = "A weapon"
@export var debug: = false
var consumed: = false

func _ready():
	if $AnimatedSprite3D:
		$AnimatedSprite3D.play("default")

func _on_area_3d_body_entered(body):
	if debug:
		print_debug("Item with type ", type, ": body entered ", body)
	body.item_found(self)


func _on_area_3d_body_exited(body):
	if debug:
		print_debug("Item with type ", type, ": body left ", body)
	body.item_lost(self)
	
	
func consume():
	if consumed:
		return
	consumed = true
	if $ActionSound:
		$ActionSound.play()
	if debug:
		print_debug("Item with type ", type, ": used")
	visible = false
	if $DeathTimer:
		$DeathTimer.start()


func _on_death_timer_timeout():
	queue_free()
