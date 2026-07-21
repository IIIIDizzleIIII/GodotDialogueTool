extends Node
class_name DialogueEvent

@export_subgroup("EventDialogue")
@export
var speaker_name:String
@export_multiline()
var dialogue:String
@export
var character_sprite:Resource
@export
var bg_art:Resource

@export_subgroup("NextEvents")
@export
var next_node:DialogueEvent
@export
var dialogue_choices:Array[DialogueChoice]
@export
var next_scene:String
