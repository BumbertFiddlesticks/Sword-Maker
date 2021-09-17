extends Control

onready var name_generator = preload("res://NameGenerator.gd").new()

# renderer materials (we ping-pong between 2 renderers)
onready var mat1 = $Viewport/Renderer.material
onready var mat2 = $Viewport2/Renderer.material

# sword parameters
var color1
var color2
var bladeType
var bladeWidth
var bladeHeight
var handleWidth
var handleHeight
var shapeSeed
var patternSeed
var frame = 0;

# array of previous states
var array = []
var arrayIndex = 0

var rng = RandomNumberGenerator.new()

# bug: using reset can make first sword buggy if you change its bladeWidth (idk why)
func _ready():
	#if (OS.get_name() == "HTML5"):
	#	$mat2.set_shader_param("HTML", 1)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	randomize()

	set_rand_values()
	#yield(get_tree(), "idle_frame")
	push_sword_back()
	_on_BladeWidthBox_value_changed(bladeWidth)
	#reset()

# reset values and re-run the sword shader
func reset():
	$Sword/Name.bbcode_text = name_generator.get_name_string(color1)
	set_box_values()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	reset_dimensions()
	for i in range(0,22):
		yield(get_tree(), "idle_frame")
		mat1.set_shader_param("frame", i);
		mat2.set_shader_param("frame", i);
		$Viewport.set_update_mode(Viewport.UPDATE_ONCE)
		$Viewport2.set_update_mode(Viewport.UPDATE_ONCE)


func reset_dimensions():
	mat2.set_shader_param("dimGem", Vector2(bladeWidth, bladeHeight))
	mat2.set_shader_param("dimHandle", Vector2(handleWidth, handleHeight))
	var dim = Vector2(max(bladeWidth, handleWidth), bladeHeight + handleHeight)
	$Viewport.size = dim
	$Viewport2.size = dim
	$Sword/FinalDisplay.rect_min_size = dim
	$Sword/FinalDisplay.rect_size = dim


func set_box_values():
	$Settings/Color1Box.value = color1
	$Settings/Color2Box.value = color2
	$Settings/BladeTypeBox.value = bladeType
	$Settings/BladeWidthBox.value = bladeWidth
	$Settings/BladeHeightBox.value = bladeHeight
	$Settings/HandleWidthBox.value = handleWidth
	$Settings/HandleHeightBox.value = handleHeight
	$Settings/ShapeSeedBox.value = shapeSeed
	$Settings/PatternSeedBox.value = patternSeed


func set_rand_values():
	$Sword/Name.bbcode_text = name_generator.make_name()
	randomize()
	rng.randomize()
	color1 = randi() % 6
	color2 = randi() % 9
	bladeType = randi() % 6
	bladeWidth = 8 + 2 * (floor(max(0, rng.randfn(4, 1))))#6 + 2 * (randi() % 7)
	bladeHeight = max(clamp(rng.randfn(52, 12), 0, 76), 2 * bladeWidth - 6)
	handleWidth = 10 + 2 * (randi() % 26)
	handleHeight = max(24, min(100 - ceil(bladeHeight), 24 + randi() % 20))
	#handleHeight = max(24, min(100 - bladeHeight, 24 + randi() % 70))
	shapeSeed = randi() % 1000
	patternSeed = randi() % 1000 


func push_sword_back():
	array.push_back([name_generator.name_string, color1, color2, bladeType, bladeWidth, bladeHeight, handleWidth, handleHeight, shapeSeed, patternSeed])


func push_sword_front():
	array.push_front([name_generator.name_string, color1, color2, bladeType, bladeWidth, bladeHeight, handleWidth, handleHeight, shapeSeed, patternSeed])


func _on_Color1Box_value_changed(value):
	color1 = value
	array[arrayIndex][1] = color1
	mat2.set_shader_param("index1", color1)
	$Sword/Border.material.set_shader_param("index", color1)
	reset()


func _on_Color2Box_value_changed(value):
	color2 = value
	array[arrayIndex][2] = color2
	mat2.set_shader_param("index2", color2)
	reset()


func _on_BladeTypeBox_value_changed(value):
	bladeType = value
	mat2.set_shader_param("index3", bladeType)
	array[arrayIndex][3] = bladeType
	
	var minHeight = 0
	var maxWidth = 100
	if (bladeType == 1 || bladeType == 2):
		minHeight = 2 * bladeWidth - 6
		maxWidth = 2 * floor(bladeHeight / 4) + 2
	elif (bladeType != 0):
		minHeight = bladeWidth
		maxWidth = bladeHeight
		
	if (100 - handleHeight >= minHeight && bladeHeight < minHeight):
		bladeHeight = minHeight
	elif (bladeWidth > maxWidth):
		bladeWidth = maxWidth

	reset()


func _on_BladeWidthBox_value_changed(value):
	bladeWidth = value
	
	if (bladeType == 1 || bladeType == 2):
		bladeWidth = min(bladeWidth, 2 * floor(bladeHeight / 4) + 2)
	elif (bladeType != 0):
		bladeWidth = min(bladeWidth, 2 * floor(bladeHeight / 2))
	else:
		bladeWidth = min(bladeWidth, 2 * floor(bladeHeight / 2) + 2)
	
	array[arrayIndex][4] = bladeWidth
	reset()


func _on_BladeHeightBox_value_changed(value):
	bladeHeight = min(100 - handleHeight, value)
	
	if (bladeType == 1 || bladeType == 2):
		bladeHeight = max(bladeHeight, 2 * bladeWidth - 6)
	elif (bladeType != 0):
		bladeHeight = max(bladeHeight, bladeWidth)
	else:
		bladeWidth = min(bladeWidth, 2 * floor(bladeHeight / 2) + 2)
		
	array[arrayIndex][5] = bladeHeight
	reset()


func _on_HandleWidthBox_value_changed(value):
	handleWidth = value
	array[arrayIndex][6] = handleWidth
	reset()


func _on_HandleHeightBox_value_changed(value):
	handleHeight = min(100.0 - bladeHeight, value)
	array[arrayIndex][7] = handleHeight
	reset()


func _on_SeedBox_value_changed(value):
	shapeSeed = value
	array[arrayIndex][8] = shapeSeed
	mat2.set_shader_param("seed", value)
	reset()


func _on_SeedBox2_value_changed(value):
	patternSeed = value
	array[arrayIndex][9] = patternSeed
	mat2.set_shader_param("seed2", value)
	reset()


# make new sword at end of array
func _on_RandomButton_pressed():
	$Sounds/Right.play(0.04)
	arrayIndex = array.size()
	set_rand_values()
	push_sword_back()
	reset()


func _on_ExportButton_pressed():
	$Sounds/Export.play(0.04)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	export_image()


func export_image():
	var tex = $Viewport2.get_texture().get_data()
	tex.flip_y()
	tex.convert(Image.FORMAT_RGBA8)
	save_image(tex)


#
func save_image(img):
	var fileName = str(color1) + "_" + str(color2) + "_" + str(bladeType) + "_" + str(bladeWidth) + "_" + str(bladeHeight) + "_" + str(handleWidth) + "_" + str(handleHeight) + "_" + str(shapeSeed) + "_" + str(patternSeed)
	if OS.get_name() == "HTML5" and OS.has_feature('JavaScript'):
		#var filesaver = get_tree().root.get_node("/root/HTML5File")
		$FileSaver.save_image(img, fileName)
	else:
		if OS.get_name() == "OSX":
			img.save_png("user://" + fileName + ".png")
		else:
			img.save_png("res://Swords/" + fileName + ".png")
		


# make new sword at end of array (or revisit sword)
func _on_Right_pressed():
	$Sounds/Right.play(0.04)
	if (arrayIndex < array.size() - 1):
		arrayIndex += 1
		reload_values()
	else:
		set_rand_values()
		push_sword_back()
		arrayIndex += 1
		reset()


# make new sword at start of array (or revisit a sword)
func _on_Left_pressed():
	$Sounds/Left.play(0.05)
	if (arrayIndex > 0):
		arrayIndex -= 1
		reload_values()
	else: 
		set_rand_values()
		push_sword_front()
		reset()


# load sword from array
func reload_values():
	var values = array[arrayIndex]
	name_generator.name_string = values[0]
	color1 = values[1]
	color2 = values[2]
	bladeType = values[3]
	bladeWidth = values[4]
	bladeHeight = values[5]
	handleWidth = values[6]
	handleHeight = values[7]
	shapeSeed = values[8]
	patternSeed = values[9]
	reset()
