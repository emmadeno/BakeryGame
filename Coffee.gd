extends Area2D

var ingredients = {}
var spoon_is_over_area = false

func _on_area_entered(area):
	if area.is_in_group("Spoon"):
		spoon_is_over_area = true

func _on_area_exited(area):
	if area.is_in_group("Spoon"):
		spoon_is_over_area = false
