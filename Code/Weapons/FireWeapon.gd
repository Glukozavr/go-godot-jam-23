# An extension of a Weapon with bullets and reload
extends Weapon

@export var bullet_scene: PackedScene

@export var reload_anim:= "reload"
@export var bullets_total:= 5
var bullets:= 5

func play_show():
	bullets = bullets_total
	super.play_show()

func play_reload():
	if debug:
		print_debug("Weapon ", type, " reloads")
	_play_anim(reload_anim)

func _update_ammo():
	if debug:
		print_debug("Weapon ", type, " updates ammo", bullets, bullets_total)
	on_ammo_update.emit(bullets, bullets_total)

func _can_attack():
	super._can_attack()
	var is_empty = bullets <= 0
	if is_empty:
		play_reload()
		return false
	else:
		return true

func _deliver_damager():
	super._deliver_damager()
	bullets = bullets - 1
	_update_ammo()
	_send_bullet()
	
func _send_bullet():
	if debug:
		print_debug("Weapon ", type, " sending a bullet")
	var bullet = bullet_scene.instantiate()
	bullet.fly_from_to(to_global($LaunchMarker.position), to_global($DirectionMarker.position))
	get_tree().current_scene.add_child(bullet)

func _on_animated_sprite_3d_animation_finished():
	super._on_animated_sprite_3d_animation_finished()
	var anim_name = $AnimatedSprite3D.animation
	if anim_name == reload_anim:
		bullets = bullets_total
		_update_ammo()
