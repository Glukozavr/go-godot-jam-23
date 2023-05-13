# An extension of EnemyMovement with health points
extends EnemyMovement
class_name Enemy

@export var health = 40

func receive_damage(dmg):
	if is_dead:
		return
	
	health = health - dmg
	if health <= 0:
		health = 0

func _death_action():
	$AnimatedSprite3D.play(anim_die)

func _on_animated_sprite_3d_animation_finished():
	super._on_animated_sprite_3d_animation_finished()
	if is_dead:
		return
	if $AnimatedSprite3D.animation == anim_die:
		_die()
