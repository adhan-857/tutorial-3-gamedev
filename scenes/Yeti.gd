extends CharacterBody2D

@export var gravity = 750.0
@export var speed = 200

@onready var animplayer : AnimatedSprite2D = $AnimatedSprite2D
@onready var area : Area2D = $Area2D
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_player2 : AudioStreamPlayer2D = $AudioStreamPlayer2D2

var is_pushed = false

func _ready():
	area.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_pushed:
		velocity.x = speed

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if body.is_dashing:
			if animplayer.animation != "kabur":
				animplayer.play("kabur")
				is_pushed = true
				if not audio_player2.playing:
					audio_player2.play()
		else:
			if animplayer.animation != "marah":
				animplayer.play("marah")
				if not audio_player.playing:
					audio_player.play()
				await get_tree().create_timer(0.75).timeout
				get_tree().change_scene_to_file("res://scenes/gameover.tscn")
