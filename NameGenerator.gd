extends Node

var names = ["Bob's", "Jerry's", "Susan's", "Kevin's", "Keith's", "Nigel's", "Gertrude's", "Baldrick's", "Abaddon's", "Alastor's", "Archeus'", "Artemis'", "Dion's", "Persephone's", "Adastros'", "Atlas'", "Orion's", "Odysseus'", "Hector's", "Ajax's", "Sylvia's", "Ana's", "Niamh's", "Amon's", "Osiris'", "Re's", "Thoth's", "Makena's", "Maximus'", "Tristan's", "Arthur's", "Doris'", "Chryses'", "Nyx's", "Tyr's", "Zephyr's", "Zerachiel's", "Mr Sword's"]
var weapons = ["Bob", "Sword", "Blade", "Dagger", "Knife", "Spear", "Weapon", "Brand", "Mark", "Rapier", "Scimitar", "Cutlass", "Sign", "Symptom", "Possessor", "Finger", "Fork", "Sculpture", "Soul", "Rod", "Stick", "Proof", "Constructor", "Fabricator", "Producer", "Begetter", "Keeper", "Object", "Carrier", "Claymore", "Sabre", "Broadsword", "Longsword", "Stabber", "Thing", "Servant", "Katana", "Minion", "Bringer", "Taker", "Receiver", "Displacer", "Funder", "Lover", "Administrator", "Manager", "Obfuscator"]
var properties = ["Bob", "Destruction", "Chaos", "Equality", "Electricity", "Speed", "Mutation", "Aggression", "Worship", "Silence", "Illusion", "Purification", "Growth", "Breaking", "Secrets", "Anger", "Peace", "Doom", "Ending", "Controversy", "Pain", "Utility", "Unlocking", "Fear", "Strength", "Dexterity", "Wisdom", "Charisma", "Wonder", "Magic", "Love", "Empathy", "Coolness", "Friendship", "Swordsmanship", "Stabbing", "Sharpness", "Approval", "Damage", "Blood"]

var name_string

func make_name():
	name_string = _rand_from_array(names) + " "
	name_string += _rand_from_array(weapons) + " "
	name_string += "of "
	name_string += _rand_from_array(properties)
	
	return name_string

func get_name_string(colorIndex):
	var effect_string = "[center][wave]"
	if ("Bob" in name_string):
		effect_string += "[rainbow freq=0.2 val=2]"
	elif (colorIndex == 0 || colorIndex == 2 || colorIndex == 4):
		effect_string += "[color=#CBDBFC]"
	elif (colorIndex == 3 || colorIndex == 5):
		effect_string += "[color=#EEC39A]"
	else:
		effect_string += "[color=#FBF236]"
	
	return effect_string + name_string

func _rand_from_array(arr):
	return arr[randi() % arr.size()]
