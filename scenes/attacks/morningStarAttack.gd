extends Area2D

var used=false
var minipause=preload("res://scenes/minipause/minipause.tscn")
var animBroke=preload("res://scenes/weapon/animBroke.tscn")
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
	$twnAttack.interpolate_property($sprite,"scale",Vector2(1,1),Vector2(2,2),twnDuration,Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnAttack.start()
	
	var duration=0.25
	for node in $sprite.get_children():
		var target=node.position.x
		$twnChain.interpolate_property(node,"position:x",-53,target,duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnChain.interpolate_property(self,"rotationSpeed",0,1.5*PI,0.75*duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnChain.start()
	
	set_physics_process(true)

func _physics_process(delta):
	self.rotation=extraRotation#+(get_global_mouse_position()-self.global_position).angle()

func _on_twnAttack_tween_completed(object, key):
	if used:
		get_parent().changeWeapon("Nothing")
		var i=animBroke.instance()
		i.global_position=$sprite.global_position
		get_parent().get_parent().add_child(i)
	else:
		get_parent().changeWeapon("MorningStar")
	delete()

func _on_morningStarAttack_body_entered(body):
	if body.is_in_group("Enemy"):
		self.used=true
		global.minorShake()
		body.takeDamage(self.damage)
		var i=minipause.instance()
		get_parent().add_child(i)
		$sfxBroke.pitch_scale=rand_range(1.8,2.2)
		$sfxBroke.play()

func delete():
	self.visible=false
	$collisionShape2D.disabled=true
	yield(get_tree().create_timer(3.0),"timeout")
	self.queue_free()