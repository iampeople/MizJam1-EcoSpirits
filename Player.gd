extends KinematicBody2D

const move_speed = 40
var velo = Vector2()
var drag = 0.5

var facing_right = true

onready var anim_player = $AnimationPlayer

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
		
	velo += move_vec * move_speed - drag * velo
	move_and_slide(velo, Vector2.UP)
	
	if move_vec == Vector2():
		play_anim("idle")
	else:
		play_anim("walk")
	
	if move_vec.x > 0.0 and !facing_right:
		flip()
	elif move_vec.x < 0.0 and facing_right:
		flip()
	
func flip():
	$Sprite.flip_h = !$Sprite.flip_h
	facing_right = !facing_right
	
func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)
