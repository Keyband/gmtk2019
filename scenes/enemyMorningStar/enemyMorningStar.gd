extends KinematicBody2D
const scoreValue=50
var life=2
var state="Entering"
var knockback=0
var vectorKnockback=Vector2()
const speed=20
var particle=preload("res://scenes/genericParticle/particle.tscn")
var anim="animActorIdle"
var vectorTargetPosition=Vector2()
var rotationSpeed=0
func _ready():
	self.add_to_group("Enemy")
	self.global_position=Vector2(vectorTargetPosition.x-50,vectorTargetPosition.y-100)
	var duration=1.5
	$twnEnter.interpolate_property(self,"global_position:x",self.global_position.x,vectorTargetPosition.x,0.9*duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$twnEnter.interpolate_property(self,"global_position:y",self.global_position.y,vectorTargetPosition.y-12,duration,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	$twnEnter.interpolate_property($spriteShadow,"position:x",$spriteShadow.position.x,0,0.9*duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$twnEnter.start()
	$area2D.visible=false
	set_physics_process(true)

func _physics_process(delta):
	$area2D.rotation+=delta*rotationSpeed
	if $twnEnter.is_active(): $spriteShadow.global_position.y=vectorTargetPosition.y
	else: $spriteShadow.position.y=12
	
	if state=="Alive":
		#Add some lerping to this movement maybe?
#		rotationSpeed=lerp(rotationSpeed,1.5*PI,0.15)
		if $animationPlayer.name!=anim:$animationPlayer.play(anim)
		knockback=lerp(knockback,0,0.1)
		var vectorMovement=move_and_slide((global.player.global_position-self.global_position).normalized()*speed+knockback*vectorKnockback)
		$sprite.flip_h=true if vectorMovement.x<0 else false if vectorMovement.x>0 else $sprite.flip_h
		anim="animActorIdle" if vectorMovement==Vector2() else "animActorWalk"
	elif state=="Dead":
		rotationSpeed=lerp(rotationSpeed,0,0.1)
		knockback=lerp(knockback,0,0.1)
		move_and_slide(knockback*vectorKnockback)

func takeDamage(amount):
	life-=amount
	if life<=0:
		global.score+=self.scoreValue
		self.state="Dead"
		self.remove_from_group("Enemy")
		self.set_collision_layer_bit(0,false)
		self.set_collision_layer_bit(1,true)
		self.set_collision_mask_bit(0,false)
		self.set_collision_mask_bit(1,true)
		$area2D/collisionShape2D.disabled=true
		anim="animActorDead"
		$animationPlayer.play(anim)
		knockback=rand_range(400,700)
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
	else:
		knockback=rand_range(200,300)
		vectorKnockback=-(global.player.global_position-self.global_position).rotated(rand_range(-1,1)*PI/8).normalized()

func _on_tmrDespawn_timeout():
	$twnDespawn.interpolate_property(self,"modulate:a",self.modulate.a,0,2,Tween.TRANS_CUBIC,Tween.EASE_IN)
	$twnDespawn.start()

func _on_twnDespawn_tween_completed(object, key):
	self.queue_free()

#func _on_twnEnter_tween_completed(object, key):
func _on_twnEnter_tween_all_completed():
	if self.state!="Dead":
		self.state="Alive"
		var duration=3
		for node in $area2D/collisionShape2D.get_children():
			var target=node.position.x
			$twnChain.interpolate_property(node,"position:x",-53,target,duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
		$twnChain.interpolate_property(self,"rotationSpeed",0,1.5*PI,0.75*duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
		$twnChain.start()
		$area2D.visible=true

func _on_area2D_body_entered(body):
	if body.is_in_group("Player") and self.life>0:
		body.takeDamage(1)
