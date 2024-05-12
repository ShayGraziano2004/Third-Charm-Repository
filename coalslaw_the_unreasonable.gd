extends CharacterBody2D


@export var speed := 100
@export var enemy_count := 10
###################################################  change enemy count in scene to be killed

@onready var animation = $AnimationPlayer
@onready var attack_box_right_col = $attack_box_right/attack_box_right_col
@onready var attack_box_left_col = $attack_box_left/attack_box_left_col
@onready var heart_1 = $Camera2D/heart_1
@onready var heart_2 = $Camera2D/heart_2
@onready var heart_3 = $Camera2D/heart_3
@onready var invinc_timer = $invincibility_Timer
@onready var flash_timer = $flash_Timer
@onready var coalslaw_sprite = $coalslaw_sprite
@onready var kills = $Camera2D/RichTextLabel




const HEART_EMPTY = preload("res://sprites/heart_empty.png")
const HEART_FULL = preload("res://sprites/heart_full.png")
const ATTACK_HITBOX = preload("res://hitboxes/attack_hitbox.tres")




var left := false
var attack := false
var health := 3
var invincible := false
var invinc_flash := false
var kill_counter := 0


func _physics_process(delta):
	var x := 0
	var y := 0
	
	if !attack:
		if Input.is_action_pressed("up"):
			y = -1
			if left:
				animation.play("move_left")
			elif !left:
				animation.play("move_right")
			
		
		
		if Input.is_action_pressed("down"):
			y = 1
			if left:
				animation.play("move_left")
			elif !left:
				animation.play("move_right")
			
		
		
		if Input.is_action_pressed("left"):
			x = -1
			animation.play("move_left")
			left = true
			
		
		
		if Input.is_action_pressed("right"):
			x = 1
			animation.play("move_right")
			left = false
		
	
	
	if Input.is_action_just_pressed("attack"):
		attack = true
		
		if left:
			animation.play("attack_left")
			attack_box_left_col.shape = ATTACK_HITBOX
		elif !left:
			animation.play("attack_right")
			attack_box_right_col.shape = ATTACK_HITBOX
		
		
		
	
	
	
	var direction = Vector2(x,y)
	if direction:
		velocity = direction * speed
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		
		if left and !attack:
			animation.play("idle_left")
			
		elif !left and !attack:
			animation.play("idle_right")
			
		
	
	if health == 3:
		heart_1.texture = HEART_FULL
		heart_2.texture = HEART_FULL
		heart_3.texture = HEART_FULL
		
	elif health == 2:
		heart_1.texture = HEART_FULL
		heart_2.texture = HEART_FULL
		heart_3.texture = HEART_EMPTY
		
	elif health == 1:
		heart_1.texture = HEART_FULL
		heart_2.texture = HEART_EMPTY
		heart_3.texture = HEART_EMPTY
		
	elif health == 0:
		heart_1.texture = HEART_EMPTY
		heart_2.texture = HEART_EMPTY
		heart_3.texture = HEART_EMPTY
		####################################################################################################################### game over here
		
	
	
	
	
	
	
	
	if kill_counter == enemy_count:
		pass
		##################################################################################################################   win screen here
	
	
	move_and_slide()






func player_hit():
	
	if !invincible:
		invincible = true
		invinc_flash = true
		health -= 1
		invinc_timer.start()
		flash_timer.start()
		
	
	






func _on_animation_player_animation_finished(anim_name):
	
	match anim_name:
		"attack_left":
			attack = false
			attack_box_left_col.shape = null
		"attack_right":
			attack = false
			attack_box_right_col.shape = null
		
	
	
	
	
	






func _on_attack_box_right_body_entered(body):
	body.take_damage()
	kill_counter += 1
	kills.text = "KILLS: " + str(kill_counter)
	


func _on_attack_box_left_body_entered(body):
	body.take_damage()
	kill_counter += 1
	kills.text = "KILLS: " + str(kill_counter)





func _on_invincibility_timer_timeout():
	invincible = false
	



func _on_flash_timer_timeout():
	if invinc_flash and invincible:
		invinc_flash = false
		flash_timer.start()
		coalslaw_sprite.modulate = "ff0026"
		
		
	elif !invinc_flash:
		invinc_flash = true
		flash_timer.start()
		coalslaw_sprite.modulate = "ffffff"
		
		
	
	







