extends Control

var mod_store = null

func _init():
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_STOP

func set_mod_store(store):
	mod_store = store
	_setup_ui()

func _setup_ui():
	# Add dark background
	var bg = ColorRect.new()
	bg.color = Color(0.1, 0.1, 0.1, 0.95)
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	add_child(bg)
	
	# Center container
	var center = CenterContainer.new()
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	add_child(center)
	
	# Main panel
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(700, 500)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	center.add_child(panel)
	
	# Main vertical layout for the panel
	var panel_vbox = VBoxContainer.new()
	panel_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(panel_vbox)
	
	# Title - OUTSIDE scroll container (fixed at top)
	var title = Label.new()
	title.text = "INSTALLED MODS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color(1, 0.9, 0.5))
	title.custom_minimum_size.y = 60
	panel_vbox.add_child(title)
	
	# Scroll container for mod entries
	var scroll = ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel_vbox.add_child(scroll)
	
	# Container for mod entries inside scroll
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 10)
	scroll.add_child(vbox)
	
	# Get and display mods
	var mods = _get_mods()
	_add_mod_entries(vbox, mods)
	
	# Bottom section (fixed at bottom, not scrollable)
	var bottom_section = VBoxContainer.new()
	bottom_section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_section.add_theme_constant_override("separation", 10)
	panel_vbox.add_child(bottom_section)
	
	# Close button
	var btn_container = HBoxContainer.new()
	btn_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_container.alignment = HBoxContainer.ALIGNMENT_CENTER
	bottom_section.add_child(btn_container)
	
	var close_btn = Button.new()
	close_btn.text = "CLOSE"
	close_btn.custom_minimum_size = Vector2(150, 40)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_btn.pressed.connect(_close)
	btn_container.add_child(close_btn)
	
	# Bottom padding
	var bottom_pad = Control.new()
	bottom_pad.custom_minimum_size.y = 15
	bottom_section.add_child(bottom_pad)
	
	# Focus
	close_btn.grab_focus()

func _get_mods():
	var mods = []
	
	if mod_store and "mod_data" in mod_store:
		print("ModStore has ", mod_store.mod_data.size(), " entries")
		for dir_name in mod_store.mod_data:
			var mod = mod_store.mod_data[dir_name]
			print("Processing: ", dir_name)
			
			var mod_info = {
				"id": dir_name,
				"name": dir_name,
				"description": ""
			}
			
			# Try to get better info from manifest
			if mod and "manifest" in mod:
				var manifest = mod.manifest
				if manifest:
					if "id" in manifest:
						mod_info.id = manifest.id
					if "name" in manifest:
						mod_info.name = manifest.name
					if "description" in manifest:
						mod_info.description = manifest.description
			
			mods.append(mod_info)
	else:
		print("mod_store is null or has no mod_data")
	
	print("Found " + str(mods.size()) + " mods")
	return mods

func _add_mod_entries(vbox, mods):
	if mods.size() == 0:
		var no_mods = Label.new()
		no_mods.text = "No mods found"
		no_mods.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		no_mods.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		no_mods.add_theme_font_size_override("font_size", 20)
		no_mods.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		no_mods.custom_minimum_size.y = 200
		vbox.add_child(no_mods)
		return
	
	for mod in mods:
		var panel_container = PanelContainer.new()
		panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Padding inside panel
		var margin = MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 15)
		margin.add_theme_constant_override("margin_right", 15)
		margin.add_theme_constant_override("margin_top", 10)
		margin.add_theme_constant_override("margin_bottom", 10)
		panel_container.add_child(margin)
		
		var mod_vbox = VBoxContainer.new()
		mod_vbox.add_theme_constant_override("separation", 4)
		margin.add_child(mod_vbox)
		
		# Name
		var name_label = Label.new()
		name_label.text = mod.name
		name_label.add_theme_font_size_override("font_size", 18)
		
		# ID
		var id_label = Label.new()
		id_label.text = mod.id
		id_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		id_label.add_theme_font_size_override("font_size", 11)
		
		# Description
		var desc_label = Label.new()
		desc_label.text = mod.description if mod.description else "No description"
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_label.add_theme_font_size_override("font_size", 12)
		
		mod_vbox.add_child(name_label)
		mod_vbox.add_child(id_label)
		mod_vbox.add_child(desc_label)
		
		vbox.add_child(panel_container)

func _close():
	queue_free()
