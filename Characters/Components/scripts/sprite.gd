extends AnimatedSprite2D

func flip() -> void:
	flip_h = !flip_h

func idle() -> void:
	play("idle")

func walk(direction: Vector2, delta: float) -> void:
	play("walk")

func sprint(direction: Vector2, delta: float) -> void:
	play("run")

func attack_1() -> void:
	play("attack_1")

func attack_2() -> void:
	play("attack_2")

func attack_3() -> void:
	play("attack_3")

func secondary() -> void:
	play("secondary")

func special() -> void:
	play("special")
