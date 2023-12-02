extends CharacterBody2D

var queue;
var input;
var faceRight = true;
var backwardsVelocity = Vector2(100, 0);
var forwardVelocity = Vector2(200, 0);
var dash = Vector2(1000, 0);
var backDash = Vector2(500, 0);
var jump = Vector2(0, -1000);
var forwardJump = Vector2(200, -1000);
var BackwardJump = Vector2(-100, -1000);
var gravity = Vector2(0, 7000);
var airborn = false;
var dashing = false;
var hasDashed = false;
var groundDash = false;
var jumpTime = 0;
var dashTime = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	input = get_node("./Input");
	queue = input.queue;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var currInput = null;
	if (queue.size() > 0):
		currInput = queue.front()[0];
	if (!faceRight):
		currInput = reverse_input(currInput);
	if (airborn):
		universal_air(currInput, delta);
	else:
		universal_ground(currInput);
	var collisioner = move_and_collide(velocity * delta);
	if (collisioner && airborn):
		var groups = collisioner.get_collider().get_groups();
		for group in groups:
			if (group == "ground"):
				airborn = false;

func universal_air(currInput, delta):
	jumpTime += delta;
	if (!dashing && jumpTime > 0.2):
		velocity += gravity * delta;
	if (!hasDashed && input.motion_input(queue, [6, 5, 6])):
		dashing = true;
		hasDashed = true;
		dashTime = 0;
		if (faceRight):
			velocity = dash;
		else:
			velocity = backDash;
	if (!hasDashed && input.motion_input(queue, [4, 5, 4])):
		dashing = true;
		hasDashed = true;
		dashTime = 0;
		if (faceRight):
			velocity = -backDash;
		else:
			velocity = -dash;
	if (dashing):
		dashTime += delta;
	if (dashing && dashTime > 0.2):
		velocity = velocity / 2;
		dashing = false

func universal_ground(currInput):
	if (currInput == 5):
		velocity = Vector2(0, 0);
	if (currInput == 6):
		if (faceRight):
			if (input.motion_input(queue, [6, 5, 6]) || groundDash):
				groundDash = true;
				velocity = 2 * forwardVelocity;
			else:
				velocity = forwardVelocity;
		else:
			if (input.motion_input(queue, [4, 5, 4]) || groundDash):
				groundDash = true;
				velocity = 2 * -forwardVelocity;
			else:
				velocity = -forwardVelocity;
	elif (groundDash):
		groundDash = false;
	if (currInput == 4):
		if (faceRight):
			velocity = -backwardsVelocity;
		else:
			velocity = backwardsVelocity;
	if (currInput == 8):
		velocity = jump;
	if ((currInput == 9 && faceRight) || (currInput == 7 && !faceRight)):
		velocity = forwardJump;
	if ((currInput == 7 && faceRight) || (currInput == 9 && !faceRight)):
		velocity = BackwardJump;
	if (currInput && currInput > 6):
		hasDashed = false;
		airborn = true;
		jumpTime = 0;

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
