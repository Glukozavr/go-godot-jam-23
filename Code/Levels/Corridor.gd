extends Node
class_name Corridor

@export var perks: Array[PackedScene]
@export var free_entrance:= true
@export var free_exit:= false

func _ready():
	if free_entrance:
		$Entrance.unlock()
	else:
		$Entrance.lock()
		
	if free_exit:
		$Exit.unlock()
	else:
		$Exit.lock()

func unlock():
	$Entrance.unlock()


func _generate_perk():
	if perks.size() <= 0:
		return
	
	var random_index = randi_range(0, perks.size() - 1)
	var perk_scene = perks[random_index]
	var perk = perk_scene.instantiate()
	
	$PerkMarker.add_child(perk)

func _on_entrance_entered():
	if free_exit:
		_generate_perk()
