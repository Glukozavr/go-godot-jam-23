# An extension to weapon to add areal damage
extends Weapon

@export var damage:= 30

func _deliver_damager():
	var bodies = $Area3D.get_overlapping_bodies()
	for b in bodies:
		b.receive_damage(damage)
