extends CharacterBody3D

@export var playerspeed:int
@export var gravity:float
@export var jumpforce:float

@export var camsense = 0
var caminput = Vector2.ZERO
@export var campivot:Node3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		campivot.rotation_degrees.x -= event.relative.y * camsense/2
		campivot.rotation_degrees.y -= event.relative.x * camsense/2


func _physics_process(delta):
	
	if is_on_floor() == false or velocity.y < 0:
		velocity.y -= 2.3 * gravity * delta 
		velocity.y = clamp(velocity.y, -1000, 1000)
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = 0
			velocity.y += jumpforce
	
	var movedirection = Vector3.ZERO
	movedirection.x = Input.get_action_strength("moveleft") - Input.get_action_strength("moveright")
	movedirection.z = Input.get_action_strength("movefoward") - Input.get_action_strength("movebackward")
	
	campivot.rotation_degrees.x = clamp(campivot.rotation_degrees.x, -90,90)
	
	movedirection = movedirection.rotated(Vector3.UP,campivot.rotation.y).normalized()
	
	
	velocity.x = -movedirection.x * playerspeed * delta
	velocity.z = -movedirection.z * playerspeed * delta
	move_and_slide()


