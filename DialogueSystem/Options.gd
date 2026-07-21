extends Panel

func Pause():
	Engine.time_scale = 0
	visible = true

func Quit():
	get_tree().quit()

func Title():
	Engine.time_scale = 1
	Autoloaded.LoadNewScene.emit("res://Title.tscn")

func Resume():
	Engine.time_scale = 1
	visible = false
