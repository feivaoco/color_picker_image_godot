tool
extends Node

export(Texture) var texture

export(bool) var startPick = false

export(int) var cantidad_colores

export(PoolColorArray) var palette

export(bool) var allSet = false

export(bool) var RESET_ALL = false;

export(bool) var savePalette = false


func _process(_delta):
	if Engine.editor_hint:
		creatte_palette()
		creatte_resource_palette()
func creatte_palette() -> void:
	if RESET_ALL: 
			palette.resize(0)
			allSet = false
			startPick = false
			RESET_ALL = false
	if startPick:
		if !allSet:
			var data = texture.get_data()
			data.lock()
			for row in data.get_height():
				for col in data.get_width():
					if palette.size() >= cantidad_colores:
						allSet = true
						print("listo")
						return
					var rgb_data = data.get_pixel(col,row)
					var rgb_avg = (rgb_data[0]+ rgb_data[1]+rgb_data[2]) / 3.0
					add_Color(rgb_data,rgb_avg)

func add_Color(_clr : Color, _avg : float) -> void:
	for color in palette:
		if _clr == color:
			return
	palette.append(_clr)

func creatte_resource_palette() -> void:
	if savePalette:
		
		var path = "res://rsrcs/ColorPalette/rsrcs_palettes/"
		var paletteRes = ColorPalette.new()
		paletteRes.palette = palette 
		var i = get_dir_files(path).size()
		
		
		var _s = ResourceSaver.save(str(path+"palette_"+str(i)+".tres"),paletteRes)
		
		savePalette = false

static func get_dir_files(path: String) -> PoolStringArray:
	var arr: PoolStringArray = []
	var dir := Directory.new()
	var _d = dir.open(path)

	if dir.file_exists(path):
		arr.append(path)

	else:
		var _d0 = dir.list_dir_begin(true,  true)
		while(true):
			var subpath := dir.get_next()
			if subpath.empty():
				break
			arr += get_dir_files(path.plus_file(subpath))

	return arr
