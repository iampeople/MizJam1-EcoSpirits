extends KinematicBody2D

var move_dir = Vector2()
var move_speed = 200

var explosion = preload("res://Explosion.tscn")

func _physics_process(delta):
	var coll = move_and_collide(move_dir * move_speed * delta)
	if coll:
		if coll.collider.name == "Player":
			coll.collider.die()
			explode()
		queue_free()

func _ready():
	add_to_group("enemies")

func set_player(_p):
	return
	
func release_player(_p):
	queue_free()
	
func explode():
	var explosion_inst = explosion.instance()
	get_tree().get_root().add_child(explosion_inst)
	explosion_inst.global_position = global_position
