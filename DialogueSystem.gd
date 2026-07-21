extends Control

#region Child Nodes
@onready
var bg_image:TextureRect = get_node("BackgroundArt")
@onready
var character_image:TextureRect = get_node("CharacterSprite")
@onready
var speaker_name:Label = get_node("CharacterNameBox/Label")
@onready
var dialogue_box:Label = get_node("MainBox/DialogueBox/ScrollContainer/DialogueLabel")
@onready
var choices_menu:Panel = get_node("DialogueChoices")
@onready
var choices_container:VBoxContainer = get_node("DialogueChoices/Scroll/VBox")
#endregion

@export_subgroup("Settings")
@export
var typewriter_short_delay:float = 0.7
@export
var typewriter_long_delay:float = 1.5

@export_subgroup("")
@export
var start_dialogue:DialogueEvent
var current_dialogue:DialogueEvent

var typewriter:Node
var awaiting_dialogue:bool = false

signal typewriter_ended
signal dialogue_ended

var continue_pressed:bool = false



func DialogueLoop():
	while true:
		LoadDialogueEvent(current_dialogue)
		StartTypewriter()
		await typewriter_ended
		
		awaiting_dialogue = true
		await dialogue_ended
		awaiting_dialogue = false
		
		if current_dialogue.dialogue_choices:
			pass
		else:
			current_dialogue = current_dialogue.next_node

func StartTypewriter():
	typewriter = Typewriter.new()
	dialogue_box.add_child(typewriter)
	typewriter.dialogue = current_dialogue.dialogue
	typewriter.short_delay = 0.07
	typewriter.long_delay = .15
	typewriter.completed.connect(EndTypewriter)
	
	dialogue_box.text = ""
	typewriter.Typewrite()

func EndTypewriter():
	typewriter.free()
	dialogue_box.text = current_dialogue.dialogue
	typewriter_ended.emit()

func LoadDialogueEvent(Event:DialogueEvent):
	if Event.bg_art:
		bg_image.texture = Event.bg_art
	if Event.character_sprite:
		character_image.texture = Event.character_sprite
	if Event.speaker_name:
		speaker_name.text = Event.speaker_name



func _ready() -> void:
	current_dialogue = start_dialogue
	DialogueLoop()
	pass

func ContinuePressed():
	continue_pressed = true

func _process(_delta) -> void:
	if Input.is_action_just_pressed("Continue") or continue_pressed == true:
		if typewriter:
			EndTypewriter()
		elif awaiting_dialogue == true:
			dialogue_ended.emit()
	continue_pressed = false
