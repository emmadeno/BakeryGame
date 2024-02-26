extends Area2D

var available_arrows = ["left", "up", "right", "down"] 
var direction : String
var speed: int = 400
var hit : bool = false
var wrong : bool = false
var in_square : bool = false

func _process(delta):
	position += Vector2.DOWN * speed * delta
	if in_square and not wrong:
		for arrow in available_arrows:
			if Input.is_action_just_pressed(arrow):
				if direction == arrow:
					hit = true
					get_node(direction).modulate = Color(0,1,0)
				else :
					get_node(direction).modulate = Color(1,0,0)
					wrong = true

func _ready():
	direction = available_arrows[randi() % 4]
	get_node(direction).show()

func _on_self_destruct_timeout():
	queue_free()

	
