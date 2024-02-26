extends Node2D

var created_recipe = {}
signal serve(recipe)

func _ready():
	for spoon in get_tree().get_nodes_in_group("Spoon"):
		spoon.connect("dropped", _on_spoon_dropped)
		$Ingredients/Milk.cup_range = [$Ingredients/Coffee/PourRange/min.global_position, $Ingredients/Coffee/PourRange/max.global_position]

func _on_spoon_dropped(ingredient, quantity):
	if $Ingredients/Coffee.spoon_is_over_area :
		add_to_recipe(quantity, ingredient)
		print("added " + str(quantity) + " tsps of " + ingredient)

func _on_milk_poured_milk(amount, ingredient):
	add_to_recipe(amount, ingredient)
	print("added " + str(amount) + " cls of " + ingredient)

func add_to_recipe(amount, ingredient):
	if ingredient in created_recipe:
		created_recipe[ingredient] += amount
	else:
		created_recipe[ingredient] = amount

func _on_texture_button_pressed():
	serve.emit(created_recipe)
