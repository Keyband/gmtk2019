extends Area2D

var used=false
var minipause=preload("res://scenes/minipause/minipause.tscn")
const damage=1
const twnDuration=0.3
func _ready():
	self.rotation=(get_global_mouse_position()-self.global_position).angle()
	$twnAttack.interpolate_property($collisionShape2D,"position:x",$collisionShape2D.position.x,1.5*$collisionShape2D.position.x,twnDuration,Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnAttack.start()
	set_physics_process(true)

func _physics_process(delta):
	self.rotation=(get_global_mouse_position()-self.global_position).angle()

func _on_twnAttack_tween_completed(object, key):
	if used:
		get_parent().changeWeapon("Nothing")
	else:
		get_parent().changeWeapon("Lance")
	self.queue_free()

func _on_lanceAttack_body_entered(body):
	if body.is_in_group("Enemy"):
		self.used=true
		global.minorShake()
		body.takeDamage(self.damage)
		var i=minipause.instance()
		get_parent().add_child(i)