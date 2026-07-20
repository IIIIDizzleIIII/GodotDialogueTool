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
@export
var start_dialogue:DialogueEvent



func DialogueLoop(FirstEvent:DialogueEvent):
	while true:
		pass
		await get_tree().create_timer(1).timeout

func TypewriterEffect():
	pass

func LoadDialogueEvent(Event:DialogueEvent):
	if Event.bg_art:
		bg_image.texture = Event.bg_art
	if Event.character_sprite:
		character_image.texture = Event.character_sprite
	if Event.speaker_name:
		speaker_name.text = Event.speaker_name

func _ready() -> void:
	LoadDialogueEvent(start_dialogue)
	pass
