extends RigidBody2D
class_name Projectile

@export var SPD: int
@export var DMG: int
var target: Vector2

func _ready() -> void:
	var ang = atan2(target.y, target.x)
	rotate(ang)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(target*SPD*(delta*100))
	if collision:
		var collider = collision.get_collider()
		if collider is CharacterBody2D:
			var body_velocity: Velocity = collider.find_child("Velocity")
			var body_damager: Damager = collider.find_child("Damager")
			var body_secondary: Secondary_Handler = collider.find_child("Secondary")
			if body_secondary:
				if not (body_velocity.direction * target.x < 0 and body_secondary.sheilding):
					body_damager.take(DMG)
			else:
				body_damager.take(DMG)
		queue_free()
