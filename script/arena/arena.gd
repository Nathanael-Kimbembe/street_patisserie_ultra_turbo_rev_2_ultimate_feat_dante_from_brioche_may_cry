extends Node2D
var camera;
var players;

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("Camera");
	players = get_node("players");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var moyPosition = players.moyPosition;
	if (moyPosition.x < -275):
		moyPosition.x = 275;
	if (moyPosition.x > 275):
		moyPosition.x = 275;
	$Camera.position = moyPosition;
