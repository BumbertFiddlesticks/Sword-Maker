extends Node

# a lot of code has been cut out here, I only kept what was necessary for exporting

func _ready():
	if OS.get_name() == "HTML5" and OS.has_feature('JavaScript'):
		_define_js()


func _define_js()->void:
	#Define JS script
	JavaScript.eval("""
	var fileName;
	
	function download(fileName, byte) {
		var buffer = Uint8Array.from(byte);
		var blob = new Blob([buffer], { type: 'image/png'});
		var link = document.createElement('a');
		link.href = window.URL.createObjectURL(blob);
		link.download = fileName;
		link.click();
	};
	""", true)
	

func save_image(image:Image, fileName:String = "export")->void:
	if OS.get_name() != "HTML5" or !OS.has_feature('JavaScript'):
		return
	
	# clearing mipmaps doesnt export properly (i dont know why)
	#image.clear_mipmaps()
	if image.save_png("user://export_temp.png"):
		return
	var file:File = File.new()
	if file.open("user://export_temp.png", File.READ):
		return
	var pngData = Array(file.get_buffer(file.get_len()))	#read data as PoolByteArray and convert it to Array for JS
	file.close()
	var dir = Directory.new()
	dir.remove("user://export_temp.png")
	JavaScript.eval("download('%s', %s);" % [fileName, str(pngData)], true)
