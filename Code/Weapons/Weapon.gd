# A base weapon class with basic signals and interface
extends Node3D
class_name Weapon

signal on_ammo_update
signal on_hidden
signal on_shown

@export var anim_speed_multiplier:= 1

@export var type:= "generic"
@export var idle_anim:= "idle"
@export var show_anim:= "show"
@export var hide_anim:= "hide"
@export var attack_anim:= "attack"
@export var debug:= false

var is_busy:= false
var is_ready_to_shoot:= false

func play_idle():
	if debug:
		print_debug("Weapon ", type, " requested to Idle")
	_play_anim(idle_anim)
	
func play_show():
	if debug:
		print_debug("Weapon ", type, " requested to Show")
	_play_anim(show_anim)
	
func play_hide():
	if debug:
		print_debug("Weapon ", type, " requested to Hide")
	_play_anim(hide_anim)
	
func play_attack():
	if debug:
		print_debug("Weapon ", type, " requested to Attack")
	if not is_ready_to_shoot:
		return
	else:
		if _can_attack() and _play_anim(attack_anim):
			_deliver_damager()

func _can_attack():
	if debug:
		print_debug("Weapon ", type, " check for attack")
	return true

func _play_anim(anim_name):
	if is_busy:
		return false
	$AnimatedSprite3D.play(anim_name, anim_speed_multiplier)
	return true

func _deliver_damager():
	if debug:
		print_debug("Weapon ", type, " delivering damage")
	
func _update_ammo():
	if debug:
		print_debug("Weapon ", type, " updating on ammo")
	on_ammo_update.emit(-1)

func _on_animated_sprite_3d_animation_changed():
	var anim_name = $AnimatedSprite3D.animation
	if anim_name != idle_anim:
		is_busy = true
	if anim_name == hide_anim:
		is_ready_to_shoot = false


func _on_animated_sprite_3d_animation_finished():
	var anim_name = $AnimatedSprite3D.animation
	if anim_name != idle_anim:
		is_busy = false
	if anim_name == show_anim:
		on_shown.emit()
		is_ready_to_shoot = true
		_update_ammo()
	if anim_name == hide_anim:
		on_hidden.emit()

