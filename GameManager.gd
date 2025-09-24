extends Node

const savefileLocation = "user://godotSaveFile.json"

var progress:int = 0
var playerscene = preload("res://scenes/player.tscn")

enum states{menu, ready, nostate}
#var currentstate = states.menu
var currentstate = states.nostate

var savedataDictionary = {
"playerProgress":progress, "savescenedata":"noscene", "playerposx": 0, "playerposey" : 0, 
"playerposez" : 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#remove this later and debug code later
	var instanceP = playerscene.instantiate()
	add_child(instanceP)
	#loadfile()
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("test"):
		progress += 1
		print(progress)
	
	if Input.is_action_just_pressed("save"):
		save()
	
	if Input.is_action_just_pressed("delete"):
		deletedata()
	
	if Input.is_action_just_pressed("load") and get_tree().current_scene.name == "menu" and FileAccess.file_exists(savefileLocation):
		currentstate = states.ready
	
	if Input.is_action_just_pressed("menu") and get_tree().current_scene.name != "menu":
		get_tree().paused = false
		var player = get_node("/root/GameManager/player")
		player.queue_free()
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pass
	
	#if Input.is_action_just_pressed("spawn") and currentstate == states.menu:
	#	currentstate = states.ready
	if Input.is_action_just_pressed("mouseunlock") and get_tree().paused == false and get_tree().current_scene.name != "menu":
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_node("/root/GameManager/player/ui/ColorRect").visible = true
	elif Input.is_action_just_pressed("mouseunlock") and get_tree().paused == true and get_tree().current_scene.name != "menu":
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_node("/root/GameManager/player/ui/ColorRect").visible = false

	if currentstate == states.ready:
		var instanceP = playerscene.instantiate()
		add_child(instanceP)
		loadfile()
		currentstate = states.nostate
		pass

func save():
	var player = get_node("/root/GameManager/player/player1")
	savedataDictionary["playerProgress"] = progress
	savedataDictionary["savescenedata"] = get_tree().current_scene.scene_file_path
	savedataDictionary["playerposx"] = player.position.x
	savedataDictionary["playerposey"] = player.position.y
	savedataDictionary["playerposez"] = player.position.z
	var saveFile = FileAccess.open(savefileLocation, FileAccess.WRITE)
	saveFile.store_string(JSON.stringify(savedataDictionary))
	saveFile.close()
	print("saved")

func loadfile():
	if FileAccess.file_exists(savefileLocation):
		var player = get_node("/root/GameManager/player/player1")
		var loadsavefile = FileAccess.open(savefileLocation, FileAccess.READ)
		savedataDictionary = JSON.parse_string(loadsavefile.get_as_text())
		player.position.x = savedataDictionary["playerposx"]
		player.position.y = savedataDictionary["playerposey"]
		player.position.z = savedataDictionary["playerposez"]
		progress = savedataDictionary["playerProgress"]
		get_tree().change_scene_to_file.call_deferred(savedataDictionary["savescenedata"])
		print(savedataDictionary)
		loadsavefile.close()
		#get_tree().change_scene_to_file(loadsavefile.get_var(savescene))
	else:
		print("no save data")

func deletedata():
	if FileAccess.file_exists(savefileLocation):
		DirAccess.remove_absolute(savefileLocation)
		print("deleted")
