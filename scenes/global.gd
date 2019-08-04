extends Node
var player
var camera
var music=preload("res://scenes/musicHydra.tscn")
var gameOver
var score=0

func _ready():
	add_child(music.instance())
	OS.window_size*=2
func minorShake():camera.minorShake()
func lost():
	gameOver.lost()