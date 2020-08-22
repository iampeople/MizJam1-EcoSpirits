extends KinematicBody2D

signal dead

const move_speed = 40
var velo = Vector2()
var drag = 0.5

var facing_right = true

onready var anim_player = $AnimationPlayer

var dead = false

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().call_group("need_player_ref", "set_player", self)
	$Sprite/CanvasLayer/RestartPanel.hide()
	$Sprite.scale = Vector2(1,1)

func _physics_process(_delta):
	var move_vec = Vector2()
	if !dead:
		if Input.is_action_pressed("move_left"):
			move_vec.x -= 1
		if Input.is_action_pressed("move_right"):
			move_vec.x += 1
		if Input.is_action_pressed("move_down"):
			move_vec.y += 1
		if Input.is_action_pressed("move_up"):
			move_vec.y -= 1
		
	velo += move_vec * move_speed - drag * velo
	var _ignore=move_and_slide(velo, Vector2.UP)
	
	if dead == false:
		if  move_vec == Vector2():
			_play_anim("idle")
		else:
			_play_anim("walk")
	
	if move_vec.x > 0.0 and !facing_right:
		flip()
	elif move_vec.x < 0.0 and facing_right:
		flip()

func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	if dead and Input.is_action_pressed("restart"):
		get_tree().call_group("enemies","queue_free")
		var _ignore=get_tree().reload_current_scene()

func flip():
	$Sprite.flip_h = !$Sprite.flip_h
	facing_right = !facing_right
	
func _play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)

func die():
	dead = true
	emit_signal("dead")
	get_tree().call_group("need_player_ref", "release_player", self)
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("dead")
	yield($AnimationPlayer, 'animation_finished')
	$Sprite/CanvasLayer/RestartPanel.show()
	
