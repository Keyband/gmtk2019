extends KinematicBody2D

var life=3
var state="Alive"
var knockback=0
var vectorKnockback=Vector2()
const speed=85
var particle=preload("res://scenes/genericParticle/particle.tscn")
var rotationSpeed=0
func _ready():
	self.add_to_group("Enemy")
	set_physics_process(true)

func _physics_process(delta):
	$area2D.rotation+=delta*rotationSpeed
	if state=="Alive":
		rotationSpeed=lerp(rotationSpeed,1.5*PI,0.15)
		move_and_slide((global.player.global_position-self.global_position).normalized()*speed)
	elif state=="Dead":
		rotationSpeed=lerp(rotationSpeed,0,0.1)
		knockback=lerp(knockback,0,0.1)
		move_and_slide(knockback*vectorKnockback)

func takeDamage(amount):
	life-=amount
	if life<=0:
		self.state="Dead"
		self.remove_from_group("Enemy")
		self.set_collision_layer_bit(0,false)
		self.set_collision_layer_bit(1,true)
		self.set_collision_mask_bit(0,false)
		self.set_collision_mask_bit(1,true)
		knockback=rand_range(900,1300)
		vectorKnockback=-(global.player.global_position-self.global_position).rotated(rand_range(-1,1)*PI/8).normalized()
		$twnGray.interpolate_property(self,"modulate",self.modulate,Color("808080"),0.4,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$twnGray.start()
		$tmrDespawn.start()
		for j in range(randi()%20):
			var i=particle.instance()
			i.global_position=self.global_position+Vector2(rand_range(-5,5),rand_range(-5,5))
			i.linear_velocity=rand_range(1.8,2.4)*knockback*vectorKnockback.rotated(rand_range(-1,1)*PI/8).normalized()
			get_parent().add_child(i)
		#Add score increment here

func _on_tmrDespawn_timeout():
	$twnDespawn.interpolate_property(self,"modulate:a",self.modulate.a,0,2,Tween.TRANS_CUBIC,Tween.EASE_IN)
	$twnDespawn.start()

func _on_twnDespawn_tween_completed(object, key):
	self.queue_free()