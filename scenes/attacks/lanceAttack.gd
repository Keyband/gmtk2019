extends Area2D

const twnDuration=0.3
func _ready():
	self.rotation=(get_global_mouse_position()-self.global_position).angle()
	$twnAttack.interpolate_property($collisionShape2D,"position:x",$collisionShape2D.position.x,1.5*$collisionShape2D.position.x,twnDuration,Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnAttack.start()
	set_physics_process(true)

func _physics_process(delta):
	self.rotation=(get_global_mouse_position()-self.global_position).angle()

func _on_twnAttack_tween_completed(object, key):
	self.queue_free()