extends Area3D

@export var currentresource:npcdat
@export var resource:npcdat
@export var resource2:npcdat
var gameManager = GameManager.progress
var isclose = false
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if gameManager == 2:
		currentresource = resource2
		position = resource2.pos
		#index = mini(0 ,currentresource.dialogue.size() -1)
	print(currentresource.name)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	
	if isclose == true and Input.is_action_just_pressed("interact"):
		var player = get_node("/root/GameManager/player/ui/RichTextLabel")
		#print(player.text)
		#player.set_text(currentresource.dialogue[index])
		#currentresource.dialogue[index] += 1
		if index <= currentresource.dialogue.size() -1:
			player.set_text(currentresource.dialogue[index])
			if index == 0:
				print("start")
			index += 1
		else:
			print("end")
			index = 0


func _on_body_entered(_body):
	#print("hello")
	isclose = true


func _on_body_exited(_body):
	#print("bye")
	isclose = false
