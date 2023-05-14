extends Node3D
class_name SpawnZone

signal finished

@export var spawn_node: Node3D

var active:= false
var started:= false
var player
var spawns = []

func activate():
	print("Zone activated!", self)
	active = true
	if player:
		_start()

func stop():
	if not active:
		return
	active = false
	$WaveTimer.stop()
	finished.emit(self)

func _findByGroup(node: Node, groupName : String, result : Array) -> void:
	if node.is_in_group(groupName):
		result.push_back(node)
	for child in node.get_children():
		_findByGroup(child, groupName, result)

func _ready():
	_findByGroup(self, "Spawns", spawns)

func _start():
	if started:
		return
	print("Zone started!", self)
	started = true
	_spawn()
	$WaveTimer.start()
	$DurationTimer.start()

func _spawn():
	print("Zone spawning!")
	for s in spawns:
		print(s, " is spawning!")
		s.spawn(player, self)

func _on_area_3d_body_entered(body: Node3D):
	if not body.is_in_group("Player"):
		return
	
	print("Player in the zone!", spawn_node)
	player = body
	if active:
		_start()
	
func _on_wave_timer_timeout():
	if player:
		_spawn()


func _on_duration_timer_timeout():
	stop()
