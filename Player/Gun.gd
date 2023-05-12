extends Node3D

signal on_ammo_update

@export var bullet_scene: PackedScene
@export var ammo:= 100
@export var load:= 5
@export var current_load:= 5
@export var speed:= 2
@export var idle_anim:= "idle"
@export var show_anim:= "show"
@export var hide_anim:= "hide"
@export var reload_anim:= "reload"
@export var shoot_anim:= "shoot"

var is_busy:= false
var is_ready_to_shoot:= false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_idle():
	play_anim(idle_anim)
	
func play_show():
	play_anim(show_anim)
	
func play_hide():
	play_anim(hide_anim)
	
func play_reload():
	play_anim(reload_anim)
	
func play_shoot():
	if not is_ready_to_shoot:
		return
	if current_load <= 0 and ammo > 0:
		play_reload()
	else:
		if current_load > 0 and play_anim(shoot_anim):
			current_load = current_load - 1
			on_ammo_update.emit(ammo, current_load, load)
			shoot_bullet()

func play_anim(anim_name):
	if is_busy:
		return false
	$AnimationPlayer.play(anim_name, -1, speed)
	return true

func shoot_bullet():
	print_debug("Let's print some bullet")
	var bullet = bullet_scene.instantiate()
	bullet.fly_from_to(to_global($LaunchMarker.position), to_global($DirectionMarker.position))
	get_tree().current_scene.add_child(bullet)

func _on_animation_player_animation_started(anim_name):
	if anim_name != idle_anim:
		is_busy = true
	if anim_name == hide_anim:
		is_ready_to_shoot = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name != idle_anim:
		is_busy = false
	if anim_name == show_anim or anim_name == reload_anim:
		is_ready_to_shoot = true
	if anim_name == reload_anim:
		var new_load = load
		if ammo - new_load < 0:
			new_load = ammo
		ammo = ammo - new_load
			
		current_load = new_load
		on_ammo_update.emit(ammo, current_load, load)
		
