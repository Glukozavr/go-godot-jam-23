extends MovementController

@export var hp_max := 100
@export var hp := 100

var item_buffer

func _ready():
	$GUI.set_health(hp, hp_max)
	$GUI.set_ammo(-1, 0)

func receive_damage(dmg):
	$GUI.damage()
	hp = hp - dmg
	if hp < 0:
		hp = 0
		get_tree().reload_current_scene()
	
	$GUI.set_health(hp, hp_max)

func item_found(item):
	item_buffer = item
	$GUI.show_pickup_tip()

func item_lost(item):
	item_buffer = null
	$GUI.hide_pickup_tip()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"use") and item_buffer:
		$Head.use_weapon(item_buffer.type)
		item_buffer.consume()

func _on_head_ammo_update(current_load, ammo):
	$GUI.set_ammo(current_load, ammo)
