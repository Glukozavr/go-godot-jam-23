# An extension of EnemyMovement with health points
extends EnemyMovement
class_name Enemy

@export var health = 40
var is_diying = false

func receive_damage(dmg):
	if is_dead or is_diying:
		return

	health = health - dmg
	
	if debug:
		print_debug("Enemy ", self, " is receiving damage", dmg, ", ", health)
	if health <= 0:
		health = 0
		_death_action()

func _death_action():
	is_diying = true
	if debug:
		print_debug("Enemy ", self, " is diying.")
	$AnimatedSprite3D.play(anim_die)

func _on_animated_sprite_3d_animation_finished():
	super._on_animated_sprite_3d_animation_finished()
	if is_dead:
		return
	if $AnimatedSprite3D.animation == anim_die:
		_die()
