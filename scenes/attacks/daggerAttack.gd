extends KinematicBody2D

var minipause=preload("res://scenes/minipause/minipause.tscn")
var animBroke=preload("res://scenes/weapon/animBroke.tscn")
const damage=1
var speed=750
var vectorDirection=Vector2()

const twnDuration=0.25
func _ready():
	self.rotation=vectorDirection.angle()
	set_physics_process(true)

func _physics_process(delta):
	if self.global_position.x<0 or\
		self.global_position.x>OS.window_size.x or\
		self.global_position.y<0 or\
		self.global_position.y>OS.window_size.y:
			self.queue_free()
	move_and_slide(vectorDirection*speed)

func _on_twnAttack_tween_completed(object, key):
	self.queue_free()

func _on_area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		global.minorShake()
		body.takeDamage(self.damage)
		var i=minipause.instance()
		get_parent().add_child(i)
		var j=animBroke.instance()
		j.global_position=$sprite.global_position
		get_parent().add_child(j)
		$sfxBroke.pitch_scale=rand_range(1.8,2.2)
		$sfxBroke.play()
		delete()
	elif body is StaticBody2D:
		var i=animBroke.instance()
		i.global_position=$sprite.global_position
		get_parent().add_child(i)
		$sfxBroke.pitch_scale=rand_range(1.8,2.2)
		$sfxBroke.play()
		delete()

func delete():
	self.visible=false
	$area2D/collisionShape2D.disabled=true
	yield(get_tree().create_timer(3.0),"timeout")
	self.queue_free()