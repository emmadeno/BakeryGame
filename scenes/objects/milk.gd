extends Pickupable

var cup_range
var isPouring = false
var value : float = 0.0

signal poured_milk(amount, ingredient)

func _ready():
	$TextureProgressBar.value = value
	$TextureProgressBar.hide()

func isWithinRange():
	if $pourBegin.global_position.y < cup_range[0].y:
		if $pourBegin.global_position.x > cup_range[0].x:
			if $pourBegin.global_position.x < cup_range[1].x:
				return true
	return false

func _process(delta):
	if not isPouring:
		super._process(delta)
	if isPouring:
		value += 27.0 * delta
		$TextureProgressBar.value = value
	if Input.is_action_just_pressed("pick_up") and isPickedUp and isWithinRange():
		isPouring = true
		$TextureProgressBar.show()
		var tween = create_tween()
		tween.tween_property($TextureProgressBar, "modulate:a", 1, 0.2)
		tween.tween_property(self, "rotation", deg_to_rad(50), 0.2)
	if Input.is_action_just_released("pick_up") and isPickedUp and isPouring:
		isPouring = false
		var tween = create_tween()
		poured_milk.emit($TextureProgressBar.value, "milk")
		tween.tween_property(self, "rotation", deg_to_rad(0), 0.2)
		tween.tween_property($TextureProgressBar, "modulate:a", 0, 0.2)
		$TextureProgressBar.value = 0
		value = 0.0

