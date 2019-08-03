extends KinematicBody2D

var minipause=preload("res://scenes/minipause/minipause.tscn")
const damage=1
var speed=450
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
	if body.is_in_group("Player"):
#		global.minorShake()
		body.takeDamage(self.damage)
#		var i=minipause.instance()
#		get_parent().add_child(i)
		self.queue_free()
	elif body is StaticBody2D:
		self.queue_free()
