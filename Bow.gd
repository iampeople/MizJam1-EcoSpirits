extends KinematicBody2D

var move_dir = Vector2()

func _physics_process(_delta):
	var coll = move_and_collide(move_dir)
	if coll:
		if coll.collider.name == "Player":
			coll.collider.give(self)
			queue_free()

func _ready():
	add_to_group("loot")

func set_player(_p):
	return
	
func release_player(_p):
	queue_free()
