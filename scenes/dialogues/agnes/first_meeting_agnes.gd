extends Node2D

var SCRIPT_PATH = "res://resources/script.json"
var data
var making_tea = preload("res://scenes/main.tscn")

var chosen_option = "None"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Bakery.hide()
	var file = FileAccess.open(SCRIPT_PATH, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	$bg/Dialogue.load_text(data["first_meeting"], {"A" : "Agnes", "B" : "Player"})

func _on_dialogue_finished(option):
	print(option)
	if option == "B":
		$bg/Dialogue.load_text(data["first_meeting_B"], {"A" : "Agnes", "B" : "Player"})
		chosen_option = "B"
	else:
		if option == "A":
			chosen_option = "A"
		$Bakery.show()
		$bg/Dialogue.hide()
	

func _on_bakery_serve(recipe):
	var result = CompareRecipes.compare_recipes(Recipes.smoky_spicy_tea, recipe, data["feedback_tea"][0])
	if chosen_option == "B":
		$bg/Dialogue.load_text(data["first_meeting_B_" + result[0]], {"A" : "Agnes", "B" : "Player"}, [result[1]])
	else:
		$bg/Dialogue.load_text(data["first_meeting_A_2"], {"A" : "Agnes", "B" : "Player"})
	$Bakery.hide()
	$bg/Dialogue.show()
