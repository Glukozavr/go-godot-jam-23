extends Node
class_name PlayerVariables

signal update_perks

var revenge_modifier: float = 0
var motivation_modifier: float = 0
var mazohism_modifier: float = 1
var magazine_modifier: float = 0
var blood_modifier: float = 0

func reset():
	revenge_modifier = 0
	motivation_modifier = 0
	mazohism_modifier = 1
	magazine_modifier = 0
	var blood_modifier = 0

func set_revenge(modifier):
	revenge_modifier = modifier
	update_perks.emit()
	
func set_motivation(modifier):
	motivation_modifier = modifier
	update_perks.emit()
	
func set_mazohism(modifier):
	mazohism_modifier = modifier
	update_perks.emit()
	
func set_magazine(modifier):
	magazine_modifier = modifier
	update_perks.emit()
	
func get_motivation():
	return 1 + (motivation_modifier * mazohism_modifier * blood_modifier)
	
func get_revenge():
	return 1 + (revenge_modifier * mazohism_modifier * blood_modifier)
	
func get_mazohism():
	return mazohism_modifier
	
func get_magazine():
	return magazine_modifier + blood_modifier
	
func set_blood(blood):
	print("Blood is set to ", blood / 2)
	blood_modifier = blood / 2
