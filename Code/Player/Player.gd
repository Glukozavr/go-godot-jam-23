extends MovementController

@export var hp_max := 100
@export var hp := 100

var item_buffer

func _ready():
	$GUI.set_health(hp, hp_max)
	$GUI.set_ammo(-1, 0)

func receive_damage(dmg):
	if dmg > 0:
		$GUI.damage()
		$DamageSound.play()
	hp = hp - dmg
	if hp < 0:
		hp = 0
		$DeathSound.play()
		player_vars.reset()
		get_tree().reload_current_scene()
	if hp > hp_max:
		hp = hp_max
	
	$GUI.set_health(hp, hp_max)
	var blood = int(round(float(hp_max) - float(hp)) / 10.0)
	if blood > 0:
		player_vars.set_blood(blood)
	else:
		player_vars.set_blood(0)

func item_found(item):
	item_buffer = item
	$GUI.show_pickup_tip(item.description)

func item_lost(item):
	item_buffer = null
	$GUI.hide_pickup_tip()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"use") and item_buffer:
		if item_buffer.type == "gun" or item_buffer.type == "sword":
			$Head.use_weapon(item_buffer.type)
		elif item_buffer.type == "heal":
			receive_damage(-20)
		elif item_buffer.type == "revenge":
			player_vars.set_revenge(player_vars.revenge_modifier + 0.1)
		elif item_buffer.type == "mazohism":
			player_vars.set_mazohism(player_vars.mazohism_modifier + 0.1)
		elif item_buffer.type == "motivation":
			player_vars.set_motivation(player_vars.motivation_modifier + 0.05)
		elif item_buffer.type == "magazine":
			player_vars.set_magazine(player_vars.magazine_modifier + 1)
		
		item_buffer.consume()

func _on_head_ammo_update(current_load, ammo):
	$GUI.set_ammo(current_load, ammo)
