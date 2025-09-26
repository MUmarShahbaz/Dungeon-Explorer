extends AnimatedSprite2D

@export var atk_sfx: AudioStreamPlayer

func flip() -> void:
	flip_h = !flip_h

func idle() -> void:
	play("idle")

func walk() -> void:
	play("walk")

func sprint() -> void:
	play("run")

func attack_1() -> void:
	play("attack_1")
	atk_sfx.play()

func attack_2() -> void:
	play("attack_2")
	atk_sfx.play()

func attack_3() -> void:
	play("attack_3")
	atk_sfx.play()

func secondary() -> void:
	play("secondary")

func special() -> void:
	play("special")

func hurt() -> void:
	play("hurt")

func die() -> void:
	play("die")
