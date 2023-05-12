extends Node3D

signal on_ammo_update
signal on_hidden

@export var speed:= 1
@export var damage:= 30
var ammo:= "Inifinity"
var load:= "Inifinity"
var current_load:= "Inifinity"
@export var idle_anim:= "idle"
@export var show_anim:= "show"
@export var hide_anim:= "hide"
@export var shoot_anim:= "attack"

var is_busy:= false
var is_ready_to_shoot:= false
var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_idle():
	play_anim(idle_anim)
	
func play_show():
	play_anim(show_anim)
	
func play_hide():
	play_anim(hide_anim)
	
func play_shoot():
	if not is_ready_to_shoot:
		return
	else:
		if play_anim(shoot_anim):
			shoot_bullet()

func play_anim(anim_name):
	if is_busy:
		return false
	$AnimatedSprite3D.play(anim_name, speed)
	return true

func shoot_bullet():
	print_debug("Let's cut some monsters")
	var bodies = $Area3D.get_overlapping_bodies()
	for b in bodies:
		print(b, " gonna be slaaayed")
		b.receive_damage(damage)


func _on_animated_sprite_3d_animation_changed():
	var anim_name = $AnimatedSprite3D.animation
	print("Kind of animation started ", anim_name)
	if anim_name != idle_anim:
		is_busy = true
	if anim_name == hide_anim:
		is_ready_to_shoot = false


func _on_animated_sprite_3d_animation_finished():
	var anim_name = $AnimatedSprite3D.animation
	print("Kind of animation finished ", anim_name)
	if anim_name != idle_anim:
		is_busy = false
	if anim_name == show_anim:
		on_ammo_update.emit(ammo, current_load, load)
		is_ready_to_shoot = true
	if anim_name == hide_anim:
		on_hidden.emit()


func _on_animated_sprite_3d_animation_looped():
	pass # Replace with function body.
