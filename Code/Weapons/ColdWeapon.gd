# An extension to weapon to add areal damage
extends Weapon

@export var damage:= 30

func _deliver_damager():
	var bodies = $Area3D.get_overlapping_bodies()
	for b in bodies:
		print("So, with revenge ", player_vars.get_revenge(), " and gamage ", damage, " we get ", damage * player_vars.get_revenge())
		b.receive_damage(damage * player_vars.get_revenge())
