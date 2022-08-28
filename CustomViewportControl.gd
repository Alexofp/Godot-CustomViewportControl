extends TextureRect

export(NodePath) var viewportPath
var viewport:Viewport

func _ready():
	viewport = get_node(viewportPath)
	call_deferred("init_texture")

func init_texture():
	if(viewport == null):
		return
	
	viewport.size = getPixelSize()

func getPixelSize():
	var globalRect = get_global_rect()
	var newSize
	
	if(is_nan(globalRect.position.x) || is_nan(globalRect.position.y) || is_nan(globalRect.size.x) || is_nan(globalRect.size.y)):
		if(viewport == null):
			return Vector2(32, 32)
		return viewport.size
	
	if(get_viewport().is_size_override_enabled()):
		newSize = globalRect.size / get_viewport().get_size_override() * get_viewport().size
	else:
		newSize = globalRect.size
	
	return Vector2(round(newSize.x), round(newSize.y))

func _notification(what):
	if(viewport == null):
		return
	
	if what == NOTIFICATION_RESIZED:
		viewport.size = getPixelSize()

func _input(event):
	if(viewport != null):
		var globalTrans = get_global_transform().affine_inverse()

		var scale_xf:Transform2D = Transform2D.IDENTITY
		scale_xf = globalTrans.scaled(Vector2(1.0,1.0) / get_viewport().get_size_override() * get_viewport().size)

		var newevent = event.xformed_by(scale_xf)
		
		viewport.input(newevent)
