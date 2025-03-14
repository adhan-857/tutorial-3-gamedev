extends CharacterBody2D

@export var gravity = 750.0
@export var walk_speed = 275
@export var jump_speed = -515
@export var crouch_speed = 150
@export var crouch_scale = Vector2(0.75, 0.75)
@export var normal_scale = Vector2(1, 1)
@export var crouch_offset = Vector2(10, 12)
@export var normal_offset = Vector2(0, 0)

@onready var animplayer : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var is_dashing = false
var dash_timer = 0.0
var last_press_time = {}
var double_press_threshold = 0.5
var jump_count = 0
var was_in_air = false

func _ready():
	last_press_time["ui_left"] = 0
	last_press_time["ui_right"] = 0
	anim_set("idle")
	print("Gunakan dash untuk mengusir Yeti!")

func _physics_process(delta):
	var move_dir = 0
	var is_crouching = false
	var current_time = Time.get_ticks_msec() / 1000.0

	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true  

	if is_on_floor() and was_in_air:
		was_in_air = false  
		if animplayer.animation == "jump":
			anim_set("idle")

	if is_on_floor():
		jump_count = 0

	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_speed
		jump_count = 1
		anim_set("jump")
	elif jump_count == 1 and !is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_speed
		jump_count = 2
		anim_set("jump")

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		move_and_slide()
		return

	if Input.is_action_just_pressed("ui_left"):
		if current_time - last_press_time.get("ui_left", 0) <= double_press_threshold:
			start_dash(-1)
		last_press_time["ui_left"] = current_time
		animplayer.flip_h = true
		move_dir = -1

	elif Input.is_action_just_pressed("ui_right"):
		if current_time - last_press_time.get("ui_right", 0) <= double_press_threshold:
			start_dash(1)
		last_press_time["ui_right"] = current_time
		animplayer.flip_h = false
		move_dir = 1

	elif Input.is_action_pressed("ui_left"):
		move_dir = -1
		if not is_dashing and is_on_floor():
			anim_set("jalan_kanan")
			animplayer.flip_h = true

	elif Input.is_action_pressed("ui_right"):
		move_dir = 1
		if not is_dashing and is_on_floor():
			anim_set("jalan_kanan")
			animplayer.flip_h = false

	if Input.is_action_pressed("ui_down") and is_on_floor():
		is_crouching = true
		animplayer.scale = crouch_scale
		var frame_height = animplayer.sprite_frames.get_frame_texture(animplayer.animation, animplayer.frame).get_height()
		animplayer.position.y = normal_offset.y + (frame_height * (1 - crouch_scale.y)) / 2
		anim_set("crouch")
	else:
		animplayer.scale = normal_scale
		animplayer.position = normal_offset
		if move_dir == 0 and is_on_floor() and not is_dashing:
			anim_set("idle")

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	elif is_crouching:
		velocity.x = move_dir * crouch_speed
	else:
		velocity.x = move_dir * walk_speed

	velocity.y += gravity * delta
	move_and_slide()

func start_dash(direction):
	is_dashing = true
	dash_timer = 0.3
	velocity.x = direction * walk_speed * 2
	anim_set("dash")

func anim_set(animation):
	if animplayer.animation != animation:
		animplayer.play(animation)
