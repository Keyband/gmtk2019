extends KinematicBody2D

var speed=300
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