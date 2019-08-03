extends Node2D
var enemy=preload("res://scenes/enemy/enemy.tscn")

func _ready():randomize()
func _on_timer_timeout():
	$timer.wait_time=rand_range(1.0,2.0)
	var i=enemy.instance()
	i.global_position=self.global_position
	get_parent().add_child(i)