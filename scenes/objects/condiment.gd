extends Area2D
class_name Condiment

var condiment_name = ""

func _on_area_entered(area):
	if "isOverCondiment" in area :
		area.isOverCondiment.append(condiment_name)

func _on_area_exited(area):
	if "isOverCondiment" in area :
		area.isOverCondiment.erase(condiment_name)
