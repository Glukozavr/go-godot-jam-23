extends Control

@export var motivation_perk: Control
@export var motivation_label: Label
@export var revenge_perk: Control
@export var revenge_label: Label
@export var magazine_perk: Control
@export var magazine_label: Label
@export var mazohist_perk: Control
@export var mazohist_label: Label

var hearts: Array[Node]
@export var hearts_imgs: Array[Texture2D]
var bullets: Array[Node]
@export var bullets_imgs: Array[Texture2D]
@export var debug = false

@export var anim_damage = "damage"
@export var anim_damage_speed = 2
var player_vars: PlayerVariables

		
func _ready():
	player_vars = get_node("/root/GameMehanics")
	player_vars.update_perks.connect(_update_perks)
	_update_perks()
	hearts = [ $"Health/Heart-1", $"Health/Heart-2", $"Health/Heart-3", $"Health/Heart-4", $"Health/Heart-5" ]
	bullets = [ $"Ammo/Bullet-1", $"Ammo/Bullet-2", $"Ammo/Bullet-3", $"Ammo/Bullet-4", $"Ammo/Bullet-5",
	$"Ammo/Bullet-6", $"Ammo/Bullet-7", $"Ammo/Bullet-8", $"Ammo/Bullet-9", $"Ammo/Bullet-10",
	$"Ammo/Bullet-11", $"Ammo/Bullet-12", $"Ammo/Bullet-13", $"Ammo/Bullet-14" ]

func set_health(current, total):
	_do_math(hearts, hearts_imgs, current, total)

func _update_perks():
	if player_vars.motivation_modifier > 0:
		motivation_perk.visible = true
		motivation_label.text = str(player_vars.get_motivation())
	else:
		motivation_perk.visible = false
		
	if player_vars.revenge_modifier > 0:
		revenge_perk.visible = true
		revenge_label.text = str(player_vars.get_revenge())
	else:
		revenge_perk.visible = false
		
	if player_vars.magazine_modifier > 0:
		magazine_perk.visible = true
		magazine_label.text = str(player_vars.get_magazine())
	else:
		magazine_perk.visible = false
		
	if player_vars.mazohism_modifier > 1:
		mazohist_perk.visible = true
		mazohist_label.text = str(player_vars.get_mazohism())
	else:
		mazohist_perk.visible = false

func set_ammo(current, total):
	if current < 0:
		$Ammo.visible = false
	else:
		_calculate_images(bullets, bullets_imgs, current, total)
		$Ammo.visible = true

func _do_math(items, items_imgs, points, total_points):
	var actual_parts = (items_imgs.size() - 1)
	var fraction: float = float(points) / float(total_points) * (float(items.size()) * float(actual_parts))
	var actual_points = int(round(fraction))
	_calculate_images(items, items_imgs, actual_points, items.size())
		
		
func _calculate_images(items, items_imgs, points, total_points):
	var actual_parts = (items_imgs.size() - 1)
	for index in items.size():
		var item = items[index]
		if index >= total_points:
			item.visible = false
			continue
		else:
			item.visible = true
		var item_index
		if points > index * actual_parts and points <= (index * actual_parts + actual_parts):
			item_index = (points - index * actual_parts) % items.size()
		elif points > (index * actual_parts + actual_parts):
			item_index = actual_parts
		else:
			item_index = 0
		if debug:
			print_debug("So, for ", index, " we have ", item_index)
		item.texture = items_imgs[item_index]

func show_pickup_tip(description):
	$PickUp.visible = true
	$PickUp/Label3.text = description
	
func hide_pickup_tip():
	$PickUp.visible = false
	
func damage():
	$AnimationPlayer.play(anim_damage, -1, anim_damage_speed)
