extends Control

var hearts: Array[Node]
@export var hearts_imgs: Array[Texture2D]
var bullets: Array[Node]
@export var bullets_imgs: Array[Texture2D]
@export var debug = false

@export var anim_damage = "damage"
@export var anim_damage_speed = 2

func _ready():
	hearts = [ $"Health/Heart-1", $"Health/Heart-2", $"Health/Heart-3", $"Health/Heart-4", $"Health/Heart-5" ]
	bullets = [ $"Ammo/Bullet-1", $"Ammo/Bullet-2", $"Ammo/Bullet-3", $"Ammo/Bullet-4", $"Ammo/Bullet-5" ]

func set_health(current, total):
	_do_math(hearts, hearts_imgs, current, total)
		

func set_ammo(current, total):
	if current < 0:
		$Ammo.visible = false
	else:
		_do_math(bullets, bullets_imgs, current, total)
		$Ammo.visible = true

func _do_math(items, items_imgs, points, total_points):
	var actual_parts = (items_imgs.size() - 1)
	var fraction: float = float(points) / float(total_points) * (float(items.size()) * float(actual_parts))
	var actual_points = int(round(fraction))
	if debug:
		print_debug("So, ", points, " from ", total_points, " is ", actual_points)
	for index in items.size():
		var item = items[index]
		var item_index
		if actual_points > index * actual_parts and actual_points <= (index * actual_parts + actual_parts):
			item_index = (actual_points - index * actual_parts) % items.size()
		elif actual_points > (index * actual_parts + actual_parts):
			item_index = actual_parts
		else:
			item_index = 0
		if debug:
			print_debug("So, for ", index, " we have ", item_index)
		item.texture = items_imgs[item_index]

func show_pickup_tip():
	$PickUp.visible = true
	
func hide_pickup_tip():
	$PickUp.visible = false
	
func damage():
	$AnimationPlayer.play(anim_damage, -1, anim_damage_speed)
