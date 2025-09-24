extends Area3D

@export_file() var scene
#var scene2 = "res://scenes/node_3d.tscn"

func _on_body_entered(_body):
		get_tree().change_scene_to_file.call_deferred(scene)
