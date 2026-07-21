extends Control

var LoadedScene:Node

func LoadNewScene(ScenePath:String):
	var Scene = load(ScenePath)
	if LoadedScene:
		LoadedScene.queue_free()
	LoadedScene = Scene.instantiate()
	add_child(LoadedScene)

func _ready() -> void:
	Autoloaded.LoadNewScene.connect(LoadNewScene)
	Autoloaded.LoadNewScene.emit("res://Scene0001.tscn")
