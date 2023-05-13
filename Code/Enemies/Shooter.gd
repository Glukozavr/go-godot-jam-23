extends Enemy

@export var bullet_scene: PackedScene

func _attack_target():
	if not $AnimatedSprite3D.is_playing() or $AnimatedSprite3D.animation != anim_attack:
		shoot()

func shoot():
	velocity.x = 0
	velocity.z = 0
	$AnimatedSprite3D.play(anim_attack)
	var bullet = bullet_scene.instantiate()
	bullet.fly_from_to(to_global($LaunchMarker.position), target.position)
	get_tree().current_scene.add_child(bullet)

func _on_animated_sprite_3d_animation_finished():
	super._on_animated_sprite_3d_animation_finished()
	if is_dead:
		return

func _on_animated_sprite_3d_animation_looped():
	pass # Replace with function body.
