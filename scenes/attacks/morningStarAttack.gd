extends Area2D

var used=false
var minipause=preload("res://scenes/minipause/minipause.tscn")
const damage=1
var way
var extraRotation=-PI/4
const twnDuration=0.75
func _ready():
	way=sign(1-randi()%2)
	if way==0: way=1
	self.extraRotation=(way*self.extraRotation)+(get_global_mouse_position()-self.global_position).angle()
	self.rotation=extraRotation
	$twnAttack.interpolate_property(self,"extraRotation",self.extraRotation,way*(self.extraRotation+3*PI),twnDuration,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
	set_physics_process(true)

func _physics_process(delta):
	self.rotation=extraRotation#+(get_global_mouse_position()-self.global_position).angle()

func _on_twnAttack_tween_completed(object, key):
	if used:
		get_parent().changeWeapon("Nothing")
	else:
		get_parent().changeWeapon("MorningStar")
	self.queue_free()

func _on_morningStarAttack_body_entered(body):
	if body.is_in_group("Enemy"):
		self.used=true
		global.minorShake()
		body.takeDamage(self.damage)
		var i=minipause.instance()
		get_parent().add_child(i)
