extends CharacterBody2D

@export var gravity = 750.0
@export var walk_speed = 275
@export var jump_speed = -350
@export var jump_count = 0
@export var dash_speed = 500
@export var dash_duration = 2.0
@export var crouch_speed = 150

var is_dashing = false
var dash_timer = 0.0

var last_press_time = {}
var double_press_threshold = 0.5
var can_dash = false

var sprite : Sprite2D
var normal_texture : Texture
var jump_texture : Texture
var crouch_texture : Texture
var collision_shape : CollisionShape2D

func _ready():
	last_press_time["ui_left"] = 0.0
	last_press_time["ui_right"] = 0.0

	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	normal_texture = preload("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_stand.png")
	jump_texture = preload("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_jump.png")
	crouch_texture = preload("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_duck.png")

	sprite.texture = normal_texture
	
	print("Halo, Petualang!")
	print()

func _physics_process(delta):
	velocity.y += delta * gravity
	var current_time = Time.get_ticks_msec() / 1000.0

	if is_on_floor():
		jump_count = 0

	if is_on_floor() and Input.is_action_just_pressed('ui_up') and jump_count == 0:
		velocity.y = jump_speed
		jump_count = 1

	if jump_count == 1 and !is_on_floor() and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		jump_count = 2
		sprite.texture = jump_texture
		print("[Double Jump] Awas ketinggian :D")

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0 or (!Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right")):
			is_dashing = false

	var move_dir = 0
	if Input.is_action_just_pressed("ui_left"):
		if current_time - last_press_time["ui_left"] <= double_press_threshold:
			start_dash(-1)
			print("[Dash] Awas nabrak :D")
			can_dash = true
		else:
			move_dir = -1
			can_dash = false
		last_press_time["ui_left"] = current_time
		sprite.flip_h = true

	elif Input.is_action_just_pressed("ui_right"):
		if current_time - last_press_time["ui_right"] <= double_press_threshold:
			start_dash(1)
			print("[Dash] Awas nabrak :D")
			can_dash = true
		else:
			move_dir = 1
			can_dash = false
		last_press_time["ui_right"] = current_time
		sprite.flip_h = false

	elif Input.is_action_pressed("ui_left") and not can_dash:
		move_dir = -1
		sprite.flip_h = true

	elif Input.is_action_pressed("ui_right") and not can_dash:
		move_dir = 1
		sprite.flip_h = false

	# Penanganan crouch
	var is_crouching = false
	if Input.is_action_pressed("ui_down"):
		sprite.texture = crouch_texture
		sprite.scale = Vector2(0.8, 0.8)
		collision_shape.scale = Vector2(0, 0)
		print("[Crouch] Awas encok :D")
		is_crouching = true
	elif is_on_floor():
		sprite.scale = Vector2(1, 1)
		collision_shape.scale = Vector2(1, 1)
		sprite.texture = normal_texture 

	if not is_dashing:
		if is_crouching:
			velocity.x = move_dir * crouch_speed
		else:
			velocity.x = move_dir * walk_speed

	move_and_slide()

func start_dash(direction):
	is_dashing = true
	dash_timer = dash_duration
	velocity.x = dash_speed * direction
