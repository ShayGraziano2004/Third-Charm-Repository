extends CharacterBody2D

@export var speed := 10

@onready var animation = $AnimationPlayer
@onready var timer = $Timer
@onready var wall_down = $down
@onready var wall_up = $up
@onready var wall_left = $left
@onready var wall_right = $right
@onready var agro_clock = $agro_clock
@onready var agro_count_clock = $agro_count_clock


enum enemy_state {MOVERIGHT, MOVELEFT, MOVEUP, MOVEDOWN}

var current_state := enemy_state.MOVELEFT
var direction
var agro_clk := false
var agro_cont_clk := false
var clock_deg := 0
var count_clock_deg := 0


func _ready():
	random_gen()
	animation.play("move_left")


func _physics_process(delta):
	
	if clock_deg > 360:
		clock_deg = 0
	if count_clock_deg < -360:
		count_clock_deg = 0
	
	if !agro_clk and !agro_cont_clk:
		wander()
		
	
	if agro_clk and !agro_cont_clk:
		var agro_x : float = cos(deg_to_rad(clock_deg))
		var agro_y : float = sin(deg_to_rad(clock_deg))
		velocity = Vector2(agro_x * speed, agro_y * speed)
		if clock_deg < 270 and clock_deg > 90:
			animation.play("move_left")
		elif clock_deg > 270 or clock_deg < 90:
			animation.play("move_right")
			
		
		
	
	if !agro_clk and agro_cont_clk:
		var agro_x : float = cos(deg_to_rad(count_clock_deg))
		var agro_y : float = sin(deg_to_rad(count_clock_deg))
		velocity = Vector2(agro_x * speed, agro_y * speed)
		if count_clock_deg > -90 or count_clock_deg < -270:
			animation.play("move_right")
		elif count_clock_deg > -270 and count_clock_deg < -90:
			animation.play("move_left")
		
	
	if agro_clk and agro_cont_clk:
		if clock_deg < 270 and clock_deg > 90:
			animation.play("move_left")
		elif clock_deg > 270 or clock_deg < 90:
			animation.play("move_right")
		
	
	
	
	if agro_clock.is_colliding():
		agro_clk = true
	
	if agro_count_clock.is_colliding():
		agro_cont_clk = true
	
	if !agro_clock.is_colliding():
		agro_clk = false
	
	if !agro_count_clock.is_colliding():
		agro_cont_clk = false
	
	if !agro_clk:
		clock_deg += 9
		agro_clock.rotation = deg_to_rad(clock_deg)
	
	if !agro_cont_clk:
		count_clock_deg -= 9
		agro_count_clock.rotation = deg_to_rad(count_clock_deg)
		
	
	
	
	move_and_slide()
	
	


func random_gen():
	direction = randi() % 4
	direction_set()
	

func direction_set():
	match direction:
		0:
			current_state = enemy_state.MOVERIGHT
			
		1:
			current_state = enemy_state.MOVELEFT
			
		2:
			current_state = enemy_state.MOVEUP
			
		3:
			current_state = enemy_state.MOVEDOWN
			
		
		
	
	


func move_right():
	velocity = Vector2.RIGHT * speed
	animation.play("move_right")


func move_left():
	velocity = Vector2.LEFT * speed
	animation.play("move_left")


func move_up():
	velocity = Vector2.UP * speed
	


func move_down():
	velocity = Vector2.DOWN * speed
	


func wander():
	match current_state:
		enemy_state.MOVERIGHT:
			move_right()
			
		
		enemy_state.MOVELEFT:
			move_left()
			
		
		enemy_state.MOVEUP:
			move_up()
			
		
		enemy_state.MOVEDOWN:
			move_down()
			
		
	
	if wall_left.is_colliding():
		current_state = enemy_state.MOVERIGHT
		
		
	if wall_right.is_colliding():
		current_state = enemy_state.MOVELEFT
		
		
	if wall_down.is_colliding():
		current_state = enemy_state.MOVEUP
		
		
	if wall_up.is_colliding():
		current_state = enemy_state.MOVEDOWN
		
	
	



func take_damage():
	queue_free()









func _on_timer_timeout():
	random_gen()
	if !agro_clk or !agro_cont_clk:
		timer.start()
	






func _on_area_2d_body_entered(body):
	body.player_hit()









