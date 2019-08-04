extends Node2D
var enemy=preload("res://scenes/enemy/enemy.tscn")
var enemyRanged=preload("res://scenes/enemyRanged/enemyRanged.tscn")
var enemyMorningStar=preload("res://scenes/enemyMorningStar/enemyMorningStar.tscn")
func _ready():randomize()
func _on_timer_timeout():
	$timer.wait_time=rand_range(1.0,2.0)
	var i=enemyMorningStar.instance()
	i.vectorTargetPosition=self.global_position
	get_parent().add_child(i)