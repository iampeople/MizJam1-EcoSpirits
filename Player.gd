extends KinematicBody2D

signal dead

const move_speed = 40
var velo = Vector2()
var drag = 0.5
var facing_right = true
onready var anim_player = $AnimationPlayer
var dead = false
var welcome=false
var welcomeTimer=0
var welcomeMax = 5


#Bow and Arrow
var have_bow = false
var fire_rate = 1.0
var fire_time = 0.0
var arrow = preload("res://Arrow.tscn")

#Fire
var have_fire=false


func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().call_group("need_player_ref", "set_player", self)
	$RestartPanel.hide()
	$WinPanel.hide()
	$WelcomePanel.hide()
	$Sprite.scale = Vector2(1,1)
	$Sprite.rotation = 0
	$Sprite/Bow.hide()

func _physics_process(delta):
	#set ongoing counters
	var move_vec = Vector2()
	if have_bow == true:
		fire_time += delta
	
	#player actions
	if !dead and !have_fire:
		if have_bow == true and Input.is_action_pressed("click"):
				if fire_time > fire_rate:
					fire_time = 0
					fire()
		#else:
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
			if welcome == true: 
				closeWelcome(delta)
		if have_bow == true:
			$Sprite/Bow.show()
	
	if move_vec.x > 0.0 and !facing_right:
		flip()
	elif move_vec.x < 0.0 and facing_right:
		flip()

func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	if (dead or have_fire) and Input.is_action_pressed("restart"):
		get_tree().call_group("enemies","queue_free")
		var _ignore=get_tree().reload_current_scene()

func flip():
	$Sprite.flip_h = !$Sprite.flip_h
	$Sprite/Bow.flip_h = !$Sprite/Bow.flip_h
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
	#$Sprite/CanvasLayer/RestartPanel.rect_position.x=to_local(global_position).x
	#$Sprite/CanvasLayer/RestartPanel.rect_position.y=to_local(global_position).y
	#yield($AnimationPlayer, 'animation_finished')
	$RestartPanel.show()
	
func give(loot):
	if loot.name == "Bow":
		have_bow = true
		openWelcome()
	
	if loot.name == "Fire":
		have_fire = true
		win()
	
func openWelcome():
	$WelcomePanel.show()
	welcome=true
	
func closeWelcome(delta):
	if welcomeTimer > welcomeMax:
		$WelcomePanel.hide()
		welcome=false
	else:
		welcomeTimer+=delta
	
	
func win():
	$WinPanel.show()
	get_tree().call_group("need_player_ref", "release_player", self)
	
func fire():
	var arrow_inst = arrow.instance()
	get_tree().get_root().add_child(arrow_inst)
	arrow_inst.global_position = global_position
	var dir_to_fire = global_position.direction_to(get_global_mouse_position())
	arrow_inst.move_dir = dir_to_fire
	arrow_inst.rotation = dir_to_fire.angle()
	#$Sprite/CanvasLayer/debug.text = "player: ("
	#$Sprite/CanvasLayer/debug.text += str(global_position.x)
	#$Sprite/CanvasLayer/debug.text += ", " 
	#$Sprite/CanvasLayer/debug.text += str(global_position.y) 
	#$Sprite/CanvasLayer/debug.text += ")\n"+ "mouse: ("
	#$Sprite/CanvasLayer/debug.text += str(get_global_mouse_position().x)
	#$Sprite/CanvasLayer/debug.text += ", "
	#$Sprite/CanvasLayer/debug.text += str(get_global_mouse_position().y)
	#$Sprite/CanvasLayer/debug.text += ")\n"
	#$Sprite/CanvasLayer/debug.text += "arrow: ("
	#$Sprite/CanvasLayer/debug.text += str(dir_to_fire.x)
	#$Sprite/CanvasLayer/debug.text += ", "
	#$Sprite/CanvasLayer/debug.text += str(dir_to_fire.y)
	#$Sprite/CanvasLayer/debug.text += ")\n"
