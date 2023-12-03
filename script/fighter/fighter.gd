extends CharacterBody2D

enum {IDLE, WALK, CROUCH, CROUCH_BLOCK, HIT, BACK_WALK, JUMP, BLOCK, DASH, AIRDASH = 0};

var queue;
var input;
var animation;
var faceRight = true;
var backwardsVelocity = Vector2(200, 0);
var forwardVelocity = Vector2(300, 0);
var dash = Vector2(1000, 0);
var backDash = Vector2(500, 0);
var jump = Vector2(0, -1250);
var forwardJump = Vector2(300, -1250);
var backwardJump = Vector2(-200, -1250);
var gravity = Vector2(0, 7000);
var airborn = false;
var dashing = false;
var hasDashed = false;
var groundDash = false;
var jumpTime = 0;
var dashTime = 0;
var curState = IDLE;
var attacking = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	input = get_node("./Input");
	queue = input.queue;
	animation = get_node("./AnimationPlayer");
	animation.play("Idle");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var currInput = null;
	if (queue.size() > 0):
		currInput = queue.front()[0];
	if (!faceRight):
		currInput = reverse_input(currInput);

	if (airborn == false && attacking == false):
		do_crouch(currInput);
		do_jump(currInput);
		if (curState != DASH):
			do_walk(currInput);
		do_dash(currInput);
		do_idle(currInput);
	
	if (airborn):
		apply_gravity(delta);
	
	var speedVect = velocity * delta;
	var collisioner = move_and_collide(speedVect, true);
	if (collisioner && airborn):
		var wasGround = false;
		var groups = collisioner.get_collider().get_groups();
		for group in groups:
			if (group == "ground"):
				wasGround = true
				airborn = false;
				curState = IDLE;
		if (wasGround):
			velocity.x = 0;
	#animation_manager(currInput);
	move_and_slide()

func do_idle(currInput):
	if (currInput == 5):
		animation.play("Idle");
		curState = IDLE;
		velocity = Vector2(0,0);

func do_walk(curInput):
	if (curInput == 6):
		animation.play("Walk");
		if (faceRight):
			velocity = forwardVelocity;
		else:
			velocity = -forwardVelocity;
		curState = WALK;
	elif (curInput == 4):
		animation.play("WalkBack");
		if (faceRight):
			velocity = -backwardsVelocity;
		else:
			velocity = backwardsVelocity;
		curState = BACK_WALK;

func do_dash(currInput):
	if ((currInput == 6 && curState == DASH) || (faceRight && input.motion_input(queue, [6, 5, 6])) || (!faceRight &&  input.motion_input(queue, [4, 5, 4]))):
		animation.play("Dash");
		curState = DASH;
		if (faceRight):
			velocity = 2 * forwardVelocity;
		else:
			velocity = -2 * forwardVelocity;
	
func do_crouch(currInput):
	if (currInput == 2 || currInput == 3):
		animation.play("Crouch");
		curState = CROUCH;
		velocity = Vector2(0, 0);
	elif (currInput == 1):
		animation.play("CrouchBlock");
		curState = CROUCH_BLOCK;
		velocity = Vector2(0, 0);

func do_jump(currInput):
	if (currInput == 8 || currInput == 7 || currInput == 9):
		animation.play("Jump");
		airborn = true;
		velocity = jump;
		if (currInput == 9):
			if (faceRight):
				velocity += forwardVelocity;
			else:
				velocity -= forwardVelocity;
		if (currInput == 7):
			if (faceRight):
				velocity -= backwardsVelocity;
			else:
				velocity += backwardsVelocity;
		curState = JUMP;
		jumpTime = 0;

func apply_gravity(delta):
	jumpTime += delta;
	if (!dashing && jumpTime > 0.2):
		velocity += gravity * delta;

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
	if (currInput == 9):
		if (faceRight):
			velocity = forwardJump;
		else:
			velocity = Vector2(-forwardJump.x, forwardJump.y);
	if (currInput == 7):
		if (faceRight):
			velocity = backwardJump;
		else:
			velocity = Vector2(-backwardJump.x, backwardJump.y);
	if (currInput == 1 || currInput == 2 || currInput == 3):
		velocity = Vector2(0, 0);
	if (currInput && currInput > 6):
		hasDashed = false;
		airborn = true;
		jumpTime = 0;

func animation_manager(currInput):
	if (currInput == 6 && groundDash):
		animation.play("Dash");
	if (airborn):
		animation.play("Airborne");
	if (airborn && dashing):
		animation.play("Dash");

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
