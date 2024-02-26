extends Area2D
class_name Pickupable

var isPickedUp : bool = false
var inShape : bool = false
var offset : Vector2 = Vector2(0, 0)

func _process(_delta):
	if Input.is_action_just_pressed("click") and inShape:
		isPickedUp = not isPickedUp
		offset = global_position - get_global_mouse_position()
	if isPickedUp:
		global_position = get_global_mouse_position() + offset

func _on_mouse_entered():
	inShape = true
	$outline.show()
		
func _on_mouse_exited():
	inShape = false
	$outline.hide()
