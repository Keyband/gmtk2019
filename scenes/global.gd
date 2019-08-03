extends Node
var player
var camera
var score=0

func _ready():OS.window_size*=2
func minorShake():camera.minorShake()