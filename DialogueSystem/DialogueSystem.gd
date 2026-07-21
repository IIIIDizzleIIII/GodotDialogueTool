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
var continue_gem:TextureRect = get_node("MainBox/DialogueBox/ContinueGem")
@onready
var choices_menu:Panel = get_node("DialogueChoices")
@onready
var choices_container:VBoxContainer = get_node("DialogueChoices/Scroll/VBox")
@onready
var history_menu:Panel = get_node("HistoryLog")
@onready
var history_container:VBoxContainer = get_node("HistoryLog/Scroll/VBox")
#endregion

var choice_button_scene = preload("res://DialogueSystem/ChoiceButton.tscn")
var history_entry_scene = preload("res://DialogueSystem/HistoryEntry.tscn")


@export
var start_dialogue:DialogueEvent

@export_subgroup("Settings")
@export
var typewriter_short_delay:float = 0.7
@export
var typewriter_long_delay:float = 1.5
@export_subgroup("")

var current_dialogue:DialogueEvent

var typewriter:Node
var awaiting_dialogue:bool = false

signal typewriter_ended
signal dialogue_ended
signal choice_ended

var history_menu_open:bool = false
var continue_pressed:bool = false
var ui_hidden:bool = false



func DialogueLoop():
	while true:
		LoadDialogueEvent(current_dialogue)
		continue_gem.visible = false
		StartTypewriter()
		await typewriter_ended
		continue_gem.visible = true
		AddHistoryEntry(current_dialogue)
		
		awaiting_dialogue = true
		await dialogue_ended
		awaiting_dialogue = false
		
		if current_dialogue.dialogue_choices:
			StartDialogueChoice(current_dialogue)
			current_dialogue = await choice_ended
		elif current_dialogue.next_scene:
			LoadNewScene(current_dialogue.next_scene)
			break
		elif current_dialogue.next_node:
			current_dialogue = current_dialogue.next_node
		else:
			get_tree().quit()
			break

func StartDialogueChoice(dialogue_event:DialogueEvent):
	choices_menu.visible = true
	for i in dialogue_event.dialogue_choices:
		var new_button:Button = choice_button_scene.instantiate()
		new_button.text = i.ChoiceDialogue
		
		if i.NextScene:
			new_button.pressed.connect(func():Autoloaded.LoadNewScene.emit(i.NextScene))
		else:
			new_button.pressed.connect(func():EndDialogueChoice(i.NextEvent))
		
		choices_container.add_child(new_button)

func EndDialogueChoice(next_event:DialogueEvent):
	choices_menu.visible = false
	choice_ended.emit(next_event)
	for i in choices_container.get_children():
		i.queue_free()

func OpenLog():
	history_menu_open = true
	history_menu.visible = true

func CloseLog():
	history_menu_open = false
	history_menu.visible = false

func HideUi():
	ui_hidden = true
	get_node("CharacterNameBox").visible = false
	get_node("MainBox").visible = false
func ShowUi():
	ui_hidden = false
	get_node("CharacterNameBox").visible = true
	get_node("MainBox").visible = true

func AddHistoryEntry(dialogue_event:DialogueEvent):
	var new_entry = history_entry_scene.instantiate()
	new_entry.get_node("Name").text = dialogue_event.speaker_name
	new_entry.get_node("Dialogue").text = dialogue_event.dialogue
	new_entry.custom_minimum_size.y += (
		new_entry.get_node("Dialogue").get_line_count()
		+new_entry.get_node("Dialogue").text.count("\n")
		)*53
	
	history_container.add_child(new_entry)

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
	typewriter.kill = true
	typewriter.queue_free()
	dialogue_box.text = current_dialogue.dialogue
	typewriter_ended.emit()

func LoadDialogueEvent(Event:DialogueEvent):
	if Event.bg_art:
		bg_image.texture = Event.bg_art
	if Event.character_sprite:
		character_image.texture = Event.character_sprite
	if Event.speaker_name:
		speaker_name.text = Event.speaker_name

func LoadNewScene(NewScene):
	Autoloaded.LoadNewScene.emit(NewScene)



func _ready() -> void:
	current_dialogue = start_dialogue
	DialogueLoop()
	pass

func ContinuePressed():
	continue_pressed = true

func _process(_delta) -> void:
	if Input.is_action_just_pressed("Continue") or continue_pressed == true:
		if ui_hidden == true:
			ShowUi()
		if typewriter:
			EndTypewriter()
		elif awaiting_dialogue == true:
			dialogue_ended.emit()
	if Input.is_action_just_pressed("History"):
		if history_menu_open == false:
			OpenLog()
		else:
			CloseLog()
	if Input.is_action_just_pressed("HideUi"):
		if ui_hidden == false:
			HideUi()
		else:
			ShowUi()
	continue_pressed = false
