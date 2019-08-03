extends Area2D

var way
var extraRotation=-PI/4
const twnDuration=0.45
func _ready():
	way=sign(1-randi()%2)
	if way==0: way=1
	self.extraRotation=(way*self.extraRotation)+(get_global_mouse_position()-self.global_position).angle()
	self.rotation=extraRotation
	$twnAttack.interpolate_property(self,"extraRotation",self.extraRotation,way*(self.extraRotation+2*PI),twnDuration,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
	set_physics_process(true)

func _physics_process(delta):
	self.rotation=extraRotation#+(get_global_mouse_position()-self.global_position).angle()

func _on_twnAttack_tween_completed(object, key):
	self.queue_free()