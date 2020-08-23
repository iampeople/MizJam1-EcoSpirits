extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.scale = Vector2(1,1)
	$Sprite.rotation = 0

func _physics_process(_delta):
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer, 'animation_finished')
	queue_free()

