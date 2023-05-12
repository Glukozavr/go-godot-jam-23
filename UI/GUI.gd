extends Control

func set_health(hp_points):
	$HealthText.text = str(hp_points)

func set_ammo(current, total):
	$AmmoText.text = "" + str(current) + " / " + str(total)
	
func show_pickup_tip():
	$PickUp.visible = true
	
func hide_pickup_tip():
	$PickUp.visible = false
