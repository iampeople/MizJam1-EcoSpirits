extends Sprite

var player = null

var rot_speed = .5
var fire_rate = 1.0
var fire_time = 0.0
var rang = 400

var bullet = preload("res://Bullet.tscn")

func _physics_process(delta):
	if player == null or global_position.distance_to(player.global_position) > rang:
		return
	
	var dir_to_player = player.global_position - global_position
	
	#$TextLabel.text = "Lerp: " + str(lerp_angle(global_position.angle(),dir_to_player.angle(),rot_speed))+"\n rot_spead: "+str(rot_speed)+"\n dir_to_player: "+ str(dir_to_player.angle())+"\n global_position:"+str(global_position.angle())+"\n delta:"+str(delta)
	#rotation = lerp_angle(global_position.angle(),dir_to_player.angle(),rot_speed*delta)
	rotation = dir_to_player.angle()
	
	
	fire_time += delta
	if fire_time > fire_rate:
		fire_time = 0
		fire()

func fire():
	if global_position.distance_to(player.global_position) > rang:
		return
	var bullet_inst = bullet.instance()
	get_tree().get_root().add_child(bullet_inst)
	bullet_inst.global_position = global_position
	var dir_to_player = (player.global_position - global_position).normalized()
	bullet_inst.move_dir = dir_to_player

func set_player(p):
	player = p

func release_player(p):
	if player == p:
		player = null
	
func _ready():
	add_to_group("enemies")

