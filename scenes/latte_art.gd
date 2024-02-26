extends Node2D

var arrow_scene: PackedScene = preload("res://scenes/game_areas/arrow.tscn")
var total_time:float = 0
var can_create_arrow : bool = true
var arrows_in_area : int = 0
var actions = ["up", "down", "left", "right"]

# Called when the node enters the scene tree for the first time.
func _ready():
	create_arrow()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if arrows_in_area == 0:
		check_inputs()
	total_time += delta * 20
	if int(total_time) % 20 == 0 and can_create_arrow:
		can_create_arrow = false
		$SpaceBetweenArrows.start()
		create_arrow()
	
func create_arrow():
	var arrow = arrow_scene.instantiate() as Area2D
	arrow.global_position = $arrow_start.position
	arrow.scale = Vector2(0.6, 0.6)
	$Arrows.add_child(arrow)

func _on_area_2d_area_entered(area):
	area.in_square = true
	arrows_in_area += 1

func _on_area_2d_area_exited(area):
	area.in_square = false
	if not area.hit:
		area.modulate = Color(1,0,0)
	arrows_in_area -= 1

func _on_space_between_arrows_timeout():
	can_create_arrow = true
		
func check_inputs():
	for action in actions:
		if Input.is_action_just_pressed(action):
			print("rip")
		
