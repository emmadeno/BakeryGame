extends Pickupable

var isOverCondiment = []
var has_content : bool = false
var content_name : String = ""

var quantity : float = 0.0

signal dropped(ingredient, quantity)

func _ready():
	if scale.x == 0.5:
		quantity = 1.0
	if int(scale.x * 100) == 43 :
		quantity = 0.5
	if int(scale.x * 100) == 40:
		quantity = 0.25

	
func _process(delta):
	super._process(delta)
	if Input.is_action_just_pressed("pick_up") and inShape and len(isOverCondiment) == 1 and not has_content:
		get_node(isOverCondiment[0]).show()
		content_name = isOverCondiment[0]
		has_content = true
	if Input.is_action_just_pressed("pick_up") and inShape and has_content and len(isOverCondiment) == 0:
		get_node(content_name).hide()
		has_content = false
		dropped.emit(content_name, quantity)
		content_name = ""
	
func add_to_coffee():
	if has_content:
		return content_name
	
