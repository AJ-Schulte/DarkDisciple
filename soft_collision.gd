extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0
# Called when the node enters the scene tree for the first time.
func get_push_vector():
	var areas = get_overlapping_areas()
	var pushvector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		pushvector = area.global_position.direction_to(global_position)
		pushvector = pushvector.normalized()
	return pushvector
