extends CharacterBody2D

var queue;
var faceRight = true;
var backwardsVelocity = Vector2(100, 0);
var forwardVelocity = Vector2(200, 0);


# Called when the node enters the scene tree for the first time.
func _ready():
	queue = get_node("./Input").queue;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var currInput = null;
	velocity = Vector2(0, 0);
	if (queue.size() > 0):
		currInput = queue.front()[0];
	if (!faceRight):
		currInput = reverse_input(currInput);
	if (currInput == 6):
		if (faceRight):
			velocity = forwardVelocity;
		else:
			velocity = -forwardVelocity;
	if (currInput == 4):
		if (faceRight):
			velocity = -backwardsVelocity;
		else:
			velocity = backwardsVelocity;
	#print(currInput);

func _physics_process(delta):
	move_and_slide();
	

func reverse_input(input):
	if (input == 6):
		return 4;
	elif (input == 4):
		return 6;
	elif (input == 9):
		return 7;
	elif (input == 7):
		return 9;
	elif (input == 1):
		return 3;
	elif (input == 3):
		return 1;
	else:
		return input;
