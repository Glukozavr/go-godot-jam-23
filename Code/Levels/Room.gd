extends Node

@export var exit_corridor: Corridor
var spawnZones: Array[SpawnZone] = []
var spawnZonesFinished = 0
var started:= false
var finished:= false

func _findByGroup(node: Node, groupName : String, result : Array) -> void:
	if node.is_in_group(groupName):
		result.push_back(node)
	for child in node.get_children():
		_findByGroup(child, groupName, result)

func _ready():
	_findByGroup(self, "SpawnZones", spawnZones)
	for zone in spawnZones:
		zone.finished.connect(_on_spawn_zone_finished)


func _on_area_3d_body_entered(body: Node3D):
	if started or not body.is_in_group("Player"):
		return
	started = true
	print("Activated!")
	for zone in spawnZones:
		print(zone, " active!")
		zone.activate()

func _on_spawn_zone_finished(spawn_zone):
	print("One done! ", spawn_zone)
	spawnZonesFinished = spawnZonesFinished + 1
	if spawnZonesFinished == spawnZones.size():
		print("That's it!")
		finished = true
		for zone in spawnZones:
			zone.stop()
		exit_corridor.unlock()
	
