extends Area2D

var used=false
var minipause=preload("res://scenes/minipause/minipause.tscn")
var animBroke=preload("res://scenes/weapon/animBroke.tscn")
const damage=1
var way
var extraRotation=-PI/4
const twnDuration=0.25
func _ready():
	way=sign(1-randi()%2)
	if way==0: way=1
	self.extraRotation*=way
	self.rotation=extraRotation+(get_global_mouse_position()-self.global_position).angle()
	$twnAttack.interpolate_property(self,"extraRotation",self.extraRotation,way*PI/4,twnDuration,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$twnAttack.interpolate_property($sprite,"scale",Vector2(1,1),Vector2(2,2),twnDuration,Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnAttack.start()
	set_physics_process(true)

func _physics_process(delta):
	self.rotation=extraRotation+(get_global_mouse_position()-self.global_position).angle()

func _on_twnAttack_tween_completed(object, key):
	if used:
		get_parent().changeWeapon("Nothing")
		var i=animBroke.instance()
		i.global_position=$sprite.global_position
		get_parent().get_parent().add_child(i)
	else:
		get_parent().changeWeapon("Katana")
	self.queue_free()

func _on_katanaAttack_body_entered(body):
	if body.is_in_group("Enemy"):
		self.used=true
		global.minorShake()
		body.takeDamage(self.damage)
		var i=minipause.instance()
		get_parent().add_child(i)