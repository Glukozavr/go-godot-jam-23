extends Enemy

@export var damage:= 30

func _death_action():	
	var bodies = $Area3D.get_overlapping_bodies()
	for b in bodies:
		b.receive_damage(damage)

	super._death_action()

func _attack_target():
	_death_action()
