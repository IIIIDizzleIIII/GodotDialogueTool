extends Node
class_name Typewriter

var dialogue:String
var short_delay:float = .07
var long_delay:float = .15

var kill:bool = false

signal completed

func Typewrite():
	var parent = get_parent()
	for i in dialogue:
		if kill == true:
			break
		parent.text = parent.text + i
		if i in [".","?","!"]:
			await get_tree().create_timer(long_delay).timeout
		else:
			await get_tree().create_timer(short_delay).timeout
	completed.emit()
