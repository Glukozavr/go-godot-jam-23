extends Node3D
class_name Door3D

signal entered

@export var locked:= false
@export var collision_layer_disabled:= 10
@export var debug:= false

var collision_later_enabled

func _ready():
	collision_later_enabled = $StaticBody3D.collision_layer

func lock():
	if debug:
		print("Door is locked")
	locked = true

func unlock():
	if debug:
		print("Door is unlocked")
	locked = false

func open():
	if not locked:
		if debug:
			print("Door is opened")
		hide()
		$ActionSound.play()
		$StaticBody3D.collision_layer = collision_layer_disabled

func close():
	if debug:
		print("Door is closed")
	# close the door
	show()
	$ActionSound.play()
	$StaticBody3D.collision_layer = collision_later_enabled

func _on_entrance_body_entered(body):
	if debug:
		print("Door entrance trigggered")
	open()

func _on_entrance_body_exited(body):
	if debug:
		print("Door entrance untrigggered")
	close()	


func _on_exit_body_entered(body):
	if debug:
		print("Door exit trigggered")
	close()
	lock()
	entered.emit()

func _on_exit_body_exited(body):
	if debug:
		print("Door exit untrigggered")
	pass # Replace with function body.
