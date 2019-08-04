extends Node2D
var enemy=preload("res://scenes/enemy/enemy.tscn")
var enemyRanged=preload("res://scenes/enemyRanged/enemyRanged.tscn")
var enemyMorningStar=preload("res://scenes/enemyMorningStar/enemyMorningStar.tscn")
func _ready():randomize()
func _on_timer_timeout():
	var xx = rand_range(20,80) if randi()%2==0 else rand_range(240,300)
	var yy = rand_range(50,250)
	self.global_position=Vector2(xx,yy)
	var numberOfEnemies=0
	for node in get_parent().get_children():
		if node.is_in_group("Enemy"):
			numberOfEnemies+=1
	$timer.wait_time=(8/5)*numberOfEnemies+rand_range(1.0,2.0)
	var percentage=randf()
	if percentage<0.8:var i=enemy.instance()
	elif percentage<0.95:var i=enemyRanged.instance()
	else:var i=enemyMorningStar.instance()
	i.vectorTargetPosition=self.global_position
	get_parent().add_child(i)