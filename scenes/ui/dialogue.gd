extends Control

const CHAR_READ_RATE = 0.03
@onready var label = $MarginContainer/Dialogue_box/MarginContainer/Normal_Dialogue
@onready var textbox_container = $MarginContainer/Dialogue_box
@onready var options = $MarginContainer/Dialogue_box/MarginContainer/Options
@onready var text_A = $MarginContainer/Dialogue_box/MarginContainer/Options/TextureButton/RichTextLabel
@onready var text_B = $MarginContainer/Dialogue_box/MarginContainer/Options/TextureButton2/RichTextLabel2
@onready var button_A = $MarginContainer/Dialogue_box/MarginContainer/Options/TextureButton
@onready var button_B = $MarginContainer/Dialogue_box/MarginContainer/Options/TextureButton2

var tween
var first_call : bool = true


signal finished(option)

enum State {
	READY,
	READING,
	FINISHED,
	WAITING,
	PAUSE
}

var current_state = State.READY
var queue = []
var character_assignment = {}
var current_options
var chosen_option = "None"
var custom_input = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox()

func load_text(script, characters, custom:=[]):
	queue = script
	character_assignment = characters
	custom_input = custom
	change_state(State.READY)

	
func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func signal_emit():
	finished.emit(chosen_option)
	chosen_option = "None"
	
func display_text():
	print(custom_input)
	var next_elem = queue.pop_front()
	print(next_elem)
	var character = next_elem["Character"]
	var type = next_elem["Type"]
	var next_text = next_elem["Dialogue"]
	display_character(character)
	if type == "N" or type == "I":
		label.show()
		options.hide()
		if type == "N":
			label.text = next_text[0]
		else :
			label.text = custom_input.pop_front()
		label.visible_ratio = 0.0
		change_state(State.READING)
		textbox_container.show()
		tween = create_tween()
		tween.tween_property(label, "visible_ratio",1.0, len(label.text) * CHAR_READ_RATE)
		tween.connect("finished", _on_Tween_tween_completed)
	elif type == "B":
		label.hide()
		options.show()
		text_A.text = next_text[0]
		text_B.text = next_text[1]
		textbox_container.show()
		current_options = next_text
		change_state(State.WAITING)
	first_call = false

func display_character(character):
	var tween1 = create_tween()
	tween1.set_parallel(true)
	var speed = 0.6
	if first_call:
		speed = 0.0
	if character == character_assignment["A"]:
		tween1.tween_property($MarginContainer/Dialogue_box/Character_A, "modulate:a", 1.0, speed)
		tween1.tween_property($MarginContainer/Dialogue_box/Character_B, "modulate:a", 0.4, speed)
	elif character == character_assignment["B"]:
		tween1.tween_property($MarginContainer/Dialogue_box/Character_B, "modulate:a", 1.0, speed)
		tween1.tween_property($MarginContainer/Dialogue_box/Character_A, "modulate:a", 0.4, speed)
			
			

func change_state(next_state):
	current_state = next_state

func _on_Tween_tween_completed():
	change_state(State.FINISHED)

func _process(delta):
	match current_state:
		State.READY:
			if len(queue) > 0:
				display_text()
			else:
				print("queue empty")
				signal_emit()
				change_state(State.PAUSE)
		State.READING:
			if Input.is_action_just_pressed("pick_up"):
				tween.stop()
				label.visible_ratio = 1.0
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("pick_up"):
				change_state(State.READY)
		State.WAITING:
			pass
		State.PAUSE:
			if len(queue) > 0:
				change_state(State.READY)


func _on_texture_button_pressed():
	if current_state == State.WAITING:
		chosen_option = "A"
		queue.push_back({"Character": "Player", "Type":"N", "Dialogue":[current_options[0]]})
		change_state(State.READY)


func _on_texture_button_2_pressed():
	if current_state == State.WAITING:
		chosen_option = "B"
		queue.push_back({"Character": "Player", "Type":"N", "Dialogue":[current_options[1]]})
		change_state(State.READY)
