extends Node2D
var moyPosition = Vector2(0, 0);
var playersCharacter = [];
var player1;
var player2;
var player1Input;
var player2Input;

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = get_node("./Fighter1");
	player2 = get_node("./Fighter2");
	player1Input = get_node("./Fighter1/Input");
	player2Input = get_node("./Fighter2/Input");
	player1Input.controllerId = 0;
	player2Input.controllerId = 1;
	player1.faceRight = true;
	player2.faceRight = false;
	player1.scale.x *= -1;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (player1.position.x > player2.position.x && player1.faceRight):
		player1.faceRight = false;
		player2.faceRight = true;
		player1.scale.x *= -1;
		player2.scale.x *= -1;
	elif (player1.position.x < player2.position.x && !player1.faceRight):
		player1.faceRight = true;
		player2.faceRight = false;
		player1.scale.x *= -1;
		player2.scale.x *= -1;

	moyPosition.x = (player1.position.x + player2.position.x) / 2

