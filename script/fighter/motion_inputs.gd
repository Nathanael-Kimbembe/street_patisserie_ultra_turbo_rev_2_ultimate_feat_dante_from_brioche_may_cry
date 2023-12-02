extends Node

var queue = [];
var frame = 0;
var currInput = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame += 1;
	var direction = Input.get_vector("left", "right", "up", "down");
<<<<<<< Updated upstream
	var directionString = convert_vector_to_direction(direction);
=======
	var directionNumber = convert_vector_to_direction(direction);
>>>>>>> Stashed changes
	if (queue):
		var queueFront = queue.front();
		queueFront[1] = frame;
		if (frame > 30):
			while (queue.size() > 1):
				queue.pop_back();
		if (queue.size() > 30):
			queue.pop_back()
<<<<<<< Updated upstream
	if (currInput != directionString):
		currInput = directionString;
=======
	if (currInput != directionNumber):
		currInput = directionNumber;
>>>>>>> Stashed changes
		var input = [currInput, frame];
		frame = 0;
		queue.push_front(input);
	if (motion_input(queue, [2, 3, 6]) && Input.is_key_pressed(KEY_F)):
		print("HADOUKEN");
<<<<<<< Updated upstream

func motion_input(inputList, moveInputs):
	var motion = true;
=======
		queue.clear();

func motion_input(inputList, moveInputs):
>>>>>>> Stashed changes
	var i = 0;
	if (inputList.size() < moveInputs.size()):
		return false;
	for n in range(moveInputs.size() - 1,-1,-1):
		if (moveInputs[i] != inputList[n][0]):
			return false;
		i += 1;
	return true	
	
func convert_vector_to_direction(direction):
	if (direction.x < 0.25 && direction.x > -0.25 && direction.y < 0):
		return 8
	if (direction.x < 0.25 && direction.x > -0.25 && direction.y > 0):
		return 2
	if (direction.y < 0.25 && direction.y > -0.25 && direction.x < 0):
		return 4
	if (direction.y < 0.25 && direction.y > -0.25 && direction.x > 0):
		return 6
	if (direction.y < 0.75 && direction.y > 0.25 && direction.x > 0):
		return 3
	if (direction.y < 0.75 && direction.y > 0.25 && direction.x < 0):
		return 1
	if (direction.y < -0.25 && direction.y > -0.75 && direction.x > 0):
		return 9
	if (direction.y < -0.25 && direction.y > -0.75 && direction.x < 0):
		return 7
	else:
		return 5
