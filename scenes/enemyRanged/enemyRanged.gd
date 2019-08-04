extends KinematicBody2D
const scoreValue=20
var life=1
var state="Entering"
var knockback=0
var vectorKnockback=Vector2()
const speed=50
var particle=preload("res://scenes/genericParticle/particle.tscn")
var dagger=preload("res://scenes/enemyRanged/enemyDaggerAttack.tscn")
var canAttack=true
var vectorTargetPosition=Vector2()
var anim="animActorIdle"
func _ready():
	self.add_to_group("Enemy")
	self.global_position=Vector2(vectorTargetPosition.x-50,vectorTargetPosition.y-100)
	var duration=1.5
	$twnEnter.interpolate_property(self,"global_position:x",self.global_position.x,vectorTargetPosition.x,0.9*duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$twnEnter.interpolate_property(self,"global_position:y",self.global_position.y,vectorTargetPosition.y,duration,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	$twnEnter.interpolate_property($spriteShadow,"position:x",$spriteShadow.position.x,0,0.9*duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$twnEnter.start()
	set_physics_process(true)

func _physics_process(delta):
	if $twnEnter.is_active(): $spriteShadow.global_position.y=vectorTargetPosition.y
	else: $spriteShadow.position.y=12
	if state=="Alive":
		var vectorDistanceToPlayer=global.player.global_position-self.global_position
		if vectorDistanceToPlayer.length()>50:
			if $animationPlayer.name!=anim:$animationPlayer.play(anim)
			var vectorMovement=move_and_slide((global.player.global_position-self.global_position).normalized()*speed)
			$sprite.flip_h=true if vectorMovement.x<0 else false if vectorMovement.x>0 else $sprite.flip_h
			anim="animActorIdle" if vectorMovement==Vector2() else "animActorWalk"
#			if $animationPlayer.name!=anim:$animationPlayer.play(anim)
#			move_and_slide(vectorDistanceToPlayer.normalized()*speed)
#			anim="animActorIdle" if vectorMovement==Vector2() else "animActorWalk"
		elif vectorDistanceToPlayer.length()<75:
			if $animationPlayer.name!=anim:$animationPlayer.play(anim)
			var vectorMovement=move_and_slide(-(global.player.global_position-self.global_position).normalized()*speed)
			$sprite.flip_h=true if vectorMovement.x<0 else false if vectorMovement.x>0 else $sprite.flip_h
			anim="animActorIdle" if vectorMovement==Vector2() else "animActorWalk"
		else:
			attack()
			
	elif state=="Dead":
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
		anim="animActorDead"
		$animationPlayer.play(anim)
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

func attack():
	var vectorDistanceToPlayer=global.player.global_position-self.global_position
	if canAttack:
		if vectorDistanceToPlayer.length()<75 and vectorDistanceToPlayer.length()>50:
			var i=dagger.instance()
			i.global_position=self.global_position
			i.vectorDirection=vectorDistanceToPlayer.normalized()
			get_parent().add_child(i)
			self.canAttack=false
			$tmrAttack.start()
		

func _on_tmrAttack_timeout():
	canAttack=true


func _on_twnEnter_tween_completed(object, key):
	if self.state!="Dead":self.state="Alive"