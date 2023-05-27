// Compatibity layers from PixTudio with BennuGD1/2
include "../../../libs/rawrlab-fw/pxtcompat.h";

Const
	SCENE_MAX_STATUS = 100;
	SCENE_MAX_RESOURCES = 100;
	SCENE_MAX_MUSICS = 100;
	SCENE_MAX_SOUNDS = 100;
End

type t_scene_status
	string name;
	
	int x = 0;
	int y = 0;
	int z = 0;
	int file = 0;
	int graph = 0;
	int size = 100;
	int size_x = 100;
	int size_y = 100;
	int flags = 0;
	int angle = 0;
	int animation = 0;
	int animation_set = 0;
	int alpha = 255;
	
	int x_set = 0;
	int y_set = 0;
	int z_set = 0;
	int graph_set = 0;
	int size_set = 0;
	int size_x_set = 0;
	int size_y_set = 0;
	int flags_set = 0;
	int file_set = 0;
	int angle_set = 0;
	int animation_setted = 0; // Confusing...
	int animation_set_setted = 0;
	int alpha_set = 0;
end

Global
	int scene_fully_loaded;
	int scene_system_started;
	string scene_current;
	string scene_ini;
	string scene_statuses_ini;
	t_scene_status scene_statuses[SCENE_MAX_STATUS];
	int scene_editor_enabled;
	
	int scene_musics[SCENE_MAX_RESOURCES];
	int scene_sounds[SCENE_MAX_RESOURCES];
	int scene_fpgs[SCENE_MAX_RESOURCES];
	int scene_fonts[SCENE_MAX_RESOURCES];
	int scene_maps[SCENE_MAX_RESOURCES];
	int scene_animations[SCENE_MAX_RESOURCES];
	
	string scene_musics_names[SCENE_MAX_RESOURCES];
	string scene_sounds_names[SCENE_MAX_RESOURCES];
	string scene_fpgs_names[SCENE_MAX_RESOURCES];
	string scene_fonts_names[SCENE_MAX_RESOURCES];
	string scene_maps_names[SCENE_MAX_RESOURCES];
	string scene_animations_names[SCENE_MAX_RESOURCES];
	
	string scene_musics_filenames[SCENE_MAX_RESOURCES];
	string scene_sounds_filenames[SCENE_MAX_RESOURCES];
	string scene_fpgs_filenames[SCENE_MAX_RESOURCES];
	string scene_fonts_filenames[SCENE_MAX_RESOURCES];
	string scene_maps_filenames[SCENE_MAX_RESOURCES];
	string scene_animations_filenames[SCENE_MAX_RESOURCES];
	
	int scene_fpgs_previous_ids[SCENE_MAX_RESOURCES];
	string scene_fpgs_previous_names[SCENE_MAX_RESOURCES];
	
	int scene_musics_repeat[SCENE_MAX_RESOURCES] = -1; //Default
	int scene_sounds_repeat[SCENE_MAX_RESOURCES];
	
	int scene_statuses_loaded;
	int scene_musics_loaded;
	int scene_sounds_loaded;
	int scene_fpgs_loaded;
	int scene_fonts_loaded;
	int scene_maps_loaded;
	int scene_animations_loaded;
	
	int scene_all_in_scroll;
	int scene_scroll_bg1;
	
	int scene_scale_resolution_x;
	int scene_scale_resolution_y;
	int scene_game_resolution_x;
	int scene_game_resolution_y;
	int scene_game_bpp;
	int scene_game_fps;
	int scene_game_fps_max_skip;
	string window_title;
	
	struct scene_system_config;
		int music_volume = 100;
		int sound_volume = 100;
		int music_enabled = 1;
		int sound_enabled = 1;
	end
	
	struct scene_globals;
		int actor_default_size = 100;
		float actor_size_multiplier = 0;
		int last_music_id = 0;
	end
End

Local
	int is_actor;
	string process_name;
	int _size;
	int _size_x;
	int _size_y;
End

#define Begin_Actor Begin; scene_actor_init(id);
#ifndef DISABLE_ACTION_AUTOBREAK
	#define Frame_Actor 					\
		if(attached_to>0) 					\
			update_attachment_pre(id); 		\
		end									\
		if(animation_set>0 and animation>0) \
			animate_that(id); 				\
		end									\
		if(action == -1) 					\
			action = 0; 					\
			break; 							\
		end 								\
		frame; 								\
		if(attached_to>0) 					\
			update_attachment_post(id); 	\
		end;								
#else
	#define Frame_Actor if(attached_to>0) update_attachment_pre(id); end; if(animation_set>0 and animation>0) animate_that(id); end; frame; if(attached_to>0) update_attachment_post(id); end;
#endif

Function scene_system_init();
Begin
	scene_system_started = 1;
	set_mode(1280,720);
	fpg_new(); // Let's ignore FPG 0
	fpg_unload(0);
	gamepads_init();
End

Function scene_assets_unload_fpgs();
Begin
	from i=1 to scene_fpgs_loaded;
		if(scene_fpgs[i] > 0)
			fpg_unload(scene_fpgs[i]);
			scene_fpgs[i] = 0;
			scene_fpgs_filenames[i] = "";
			scene_fpgs_names[i] = "";
		end
	end
	scene_fpgs_loaded = 0;
End

Function scene_assets_load_fpgs(string from_scene);
Private
	int num_file;
	string filename;
	string rel_path;
	int already_loaded;
Begin
	// Load all FPGs
	say("+ Loading FPGs");
	num_file=0;
	if(fexists("scene/"+from_scene+"/fpg/filelist.ini"))
		load_ini("scene/"+from_scene+"/fpg/filelist.ini");
		repeat
			num_file++;
			filename=read_ini("filelist","file"+num_file);
			if(filename != "")
				rel_path = "scene/"+from_scene+"/fpg/"+filename;
				
				already_loaded=0;
				from i=1 to SCENE_MAX_RESOURCES;
					if(scene_fpgs_filenames[i] == rel_path)
						already_loaded=1;
					end
				end
				
				if(!already_loaded)
					scene_fpgs_loaded++;
					scene_fpgs[scene_fpgs_loaded]=fpg_load(rel_path);
					if(scene_fpgs[scene_fpgs_loaded]<0)
						scene_fpgs_loaded--;
						#ifdef RAWR_DEBUG
							say("Could not load FPG "+rel_path);
						#endif
					else
						scene_fpgs_filenames[scene_fpgs_loaded]=rel_path;
						scene_fpgs_names[scene_fpgs_loaded]=substr(filename,0,len(filename)-4);
						#ifdef RAWR_DEBUG_VERBOSE
						say("++ FPG loaded: "+scene_fpgs_names[scene_fpgs_loaded]);
						#endif
					end
				end
			end
		until(filename == "")
	end
End

Function scene_fpg_add(file, string name);
Begin
	scene_fpgs_loaded++;
	scene_fpgs[scene_fpgs_loaded] = file;
	scene_fpgs_filenames[scene_fpgs_loaded] = ".";
	scene_fpgs_names[scene_fpgs_loaded] = name;

	#ifdef RAWR_DEBUG_VERBOSE
	say("++ FPG added: "+scene_fpgs_names[scene_fpgs_loaded]);
	#endif
End

Function scene_assets_load();
Private
	string filename;
	string rel_path;
	int already_loaded;
	int num_file;
	string ini_backup_string;
Begin
	load_ini_string(scene_ini);

	// Unload all assets?
	if(read_ini_int("assets","unloadall",0)==1)
		//scene_assets_unload_all();
	end
	
	// Load all assets?
	if(read_ini_int("assets","loadall",1)!=1)
		return;
	end

	scene_assets_load_fpgs(scene_current);
	
	// Load all MAPs (png, webp, jpg)
	say("+ Loading maps");
	
	num_file=0;
	if(fexists("scene/"+scene_current+"/map/filelist.ini"))
		load_ini("scene/"+scene_current+"/map/filelist.ini");
		repeat
			num_file++;
			filename=read_ini("filelist","file"+num_file);
			if(filename != "")
				rel_path = "scene/"+scene_current+"/map/"+filename;
				
				already_loaded=0;
				from i=1 to SCENE_MAX_RESOURCES;
					if(scene_maps_filenames[i] == rel_path)
						already_loaded=1;
					end
				end
				
				if(!already_loaded)		
					scene_maps_loaded++;
					scene_maps[scene_maps_loaded]=image_load(rel_path);
					if(scene_maps[scene_maps_loaded]<0)
						scene_maps_loaded--;
						#ifdef RAWR_DEBUG
						say("Could not load MAP (bitmap) "+rel_path);
						#endif
					else
						scene_maps_filenames[scene_maps_loaded]=rel_path;
						scene_maps_names[scene_maps_loaded]=substr(filename,0,len(filename)-4);
					end
				end
			end
		until(filename == "")
	end
	
	// Load all fonts (FNT & TTF)
	say("+ Loading fonts");
	
	num_file=0;
	if(fexists("scene/"+scene_current+"/font/filelist.ini"))
		load_ini("scene/"+scene_current+"/font/filelist.ini");
		repeat
			num_file++;
			filename=read_ini("filelist","file"+num_file);
			if(filename != "")
				rel_path = "scene/"+scene_current+"/font/"+filename;
				
				already_loaded=0;
				from i=1 to SCENE_MAX_RESOURCES;
					if(scene_fonts_filenames[i] == rel_path)
						already_loaded=1;
					end
				end
				
				if(!already_loaded)
					scene_fonts_loaded++;
					if(substr(filename,len(filename)-3,3)=="ttf")
						scene_fonts[scene_fonts_loaded]=ttf_load(rel_path);
					else
						scene_fonts[scene_fonts_loaded]=fnt_load(rel_path);
					end
					if(scene_fonts[scene_fonts_loaded]<0)
						scene_fonts_loaded--;
						#ifdef RAWR_DEBUG
						say("Could not load font "+rel_path);
						#endif
					else
						scene_fonts_filenames[scene_fonts_loaded]=rel_path;
						scene_fonts_names[scene_fonts_loaded]=substr(filename,0,len(filename)-4);
					end
				end
			end
		until(filename == "")
	end
	
	// Load all sounds
	say("+ Loading sounds");
	
	num_file=0;
	if(fexists("scene/"+scene_current+"/sound/filelist.ini"))
		load_ini("scene/"+scene_current+"/sound/filelist.ini");
		repeat
			num_file++;
			filename=read_ini("filelist","file"+num_file);
			if(filename != "")
				rel_path = "scene/"+scene_current+"/sound/"+filename;
				
				already_loaded=0;
				from i=1 to SCENE_MAX_RESOURCES;
					if(scene_sounds_filenames[i] == rel_path)
						already_loaded=1;
					end
				end
				
				if(!already_loaded)
					scene_sounds_loaded++;
					scene_sounds[scene_sounds_loaded]=sound_load(rel_path);
					if(scene_sounds[scene_sounds_loaded]<0)
						scene_sounds_loaded--;
						#ifdef RAWR_DEBUG
						say("Could not load sound "+rel_path);
						#endif
					else
						scene_sounds_filenames[scene_sounds_loaded]=rel_path;
						scene_sounds_names[scene_sounds_loaded]=substr(filename,0,len(filename)-4);
					end
				end
			end
		until(filename == "")
	end
	
	// Load all music
	say("+ Loading music");
	
	num_file=0;
	if(fexists("scene/"+scene_current+"/music/filelist.ini"))
		load_ini("scene/"+scene_current+"/music/filelist.ini");
		repeat
			num_file++;
			filename=read_ini("filelist","file"+num_file);
			if(filename != "")
				rel_path = "scene/"+scene_current+"/music/"+filename;
				
				already_loaded=0;
				from i=1 to SCENE_MAX_RESOURCES;
					if(scene_musics_filenames[i] == rel_path)
						already_loaded=1;
					end
				end
				
				if(!already_loaded)
					scene_musics_loaded++;
					scene_musics[scene_musics_loaded]=song_load(rel_path);
					if(scene_musics[scene_musics_loaded]<0)
						scene_musics_loaded--;
						#ifdef RAWR_DEBUG
						say("Could not load music "+rel_path);
						#endif
					else
						scene_musics_filenames[scene_musics_loaded]=rel_path;
						scene_musics_repeat[scene_musics_loaded]=-1; //By default
						scene_musics_names[scene_musics_loaded]=substr(filename,0,len(filename)-4);
					end
				end
			end
		until(filename == "")
	end
	
	// Load all animations
	say("+ Loading animations");
	
	num_file=0;
	if(fexists("scene/"+scene_current+"/anims/filelist.ini"))
		load_ini("scene/"+scene_current+"/anims/filelist.ini");
		ini_backup_string = loaded_ini_data;
		repeat
			num_file++;
			
			loaded_ini_data = ini_backup_string;
			filename=read_ini("filelist","file"+num_file);			
			
			if(filename != "")
				rel_path = "scene/"+scene_current+"/anims/"+filename;
				
				already_loaded=0;
				from i=1 to SCENE_MAX_RESOURCES;
					if(scene_animations_filenames[i] == rel_path)
						already_loaded=1;
					end
				end
				
				if(!already_loaded)
					scene_animations_loaded++;
					scene_animations[scene_animations_loaded]=animation_load_set(rel_path);
					if(scene_animations[scene_animations_loaded]<0)
						scene_animations_loaded--;
						#ifdef RAWR_DEBUG
						say("Could not load animation "+rel_path);
						#endif
					else
						scene_animations_filenames[scene_animations_loaded]=rel_path;
						scene_animations_names[scene_animations_loaded]=substr(filename,0,len(filename)-4);
						#ifdef RAWR_DEBUG_VERBOSE
						say("++ Loaded animation "+scene_animations_names[scene_animations_loaded]);
						#endif
					end
				end
			end
		until(filename == "")
	end
End

Process scene_music_play(string music_to_play);
Private
	music_id=-10;
Begin
	#ifdef RAWR_DEBUG_VERBOSE
	say("scene_music_play, requested "+music_to_play);
	#endif

	if(scene_editor_enabled or !scene_system_config.music_enabled)
		return;
	end
	
	if(music_to_play == "")
		return;
	end

	if(music_to_play == "stop")
		song_stop();
		scene_globals.last_music_id = 0;
		return;
	end

	if(music_to_play == "fadeout")
		music_fade_out(300);
		scene_globals.last_music_id = 0;
		return;
	end	
	
	// If it is a number, it's the index:
	if(atoi(music_to_play)>0 and atoi(music_to_play)<SCENE_MAX_RESOURCES)
		music_id=atoi(music_to_play);
	else // If not, find out the index
		from i=1 to scene_musics_loaded;
			say(scene_musics_names[i]);
			if(scene_musics_names[i] == music_to_play)
				music_id = i;
				break;
			end
		end
	end
	
	if(music_id>0 and scene_globals.last_music_id != music_id)
		timer[8] = 0; // FIXME: Ugly! but works... Updated SDL2_mixer does support getting song's current position, but we don't use it.
		scene_globals.last_music_id = music_id;
		song_play(scene_musics[music_id],scene_musics_repeat[music_id]);
	else
		if(scene_globals.last_music_id != music_id)
			#ifdef RAWR_DEBUG
			say("Could not play scene music: "+music_to_play);
			#endif
		end
	end
End

Process scene_sound_play(string sound_to_play);
Private
	sound_id=-10;
Begin
	// If it is a number, it's the index:
	if(atoi(sound_to_play)>0)
		sound_id=atoi(sound_to_play);
	else // If not, find out the index
		from i=1 to scene_sounds_loaded;
			if(scene_sounds_names[i] == sound_to_play)
				sound_id = i;
				break;
			end
		end
	end
	if(sound_id>0)
		i=sound_play(scene_sounds[sound_id],scene_sounds_repeat[sound_id]);
		
		// Stereo surround effect
		x=father.x;
		if(x!=0)
			j=(x*255)/scene_game_resolution_x;
			j=clamp(j,0,255);
			channel_set_panning(i,255-j,j);
		end
		
		return i;
	else
		#ifdef RAWR_DEBUG
		say("Could not play scene sound: "+sound_to_play);
		#endif
	end
End

Function scene_fpg_by_name(string fpg_name);
Begin
	from i=1 to scene_fpgs_loaded;
		if(scene_fpgs_names[i] == fpg_name)
			return scene_fpgs[i];
		end
	end

	return 0;
End

Function scene_wait_until_loaded();
Begin
	while(!scene_fully_loaded)
		frame;
	end
End

Function scene_font_by_name(string font_name);
Begin
	from i=1 to scene_fonts_loaded;
		if(scene_fonts_names[i] == font_name)
			return scene_fonts[i];
		end
	end

	return 0;
End

Function scene_map_by_name(string map_name);
Begin
	from i=1 to scene_maps_loaded;
		if(scene_maps_names[i] == map_name)
			return scene_maps[i];
		end
	end

	return 0;
End

Function scene_actor_frame_before(that_id);
Begin
	// Animate if enabled
	if(that_id.animation_set>0 and that_id.animation>0)
		animate_that(that_id);
	end
	
	// Chipmunking physics!
End

Function scene_actor_frame_after(that_id);
Begin
	// ..
End

Function scene_change(string new_scene, int clean_the_house);
Private
	change_screen_resolution;
Begin
	if(!scene_system_started)
		scene_system_init();
	end

	if(new_scene==scene_current)
		return;
	end
	
	scene_fully_loaded=0;
	
	say("Loading scene: "+new_scene);
	
	// We clean the house (if asked)
	if(clean_the_house)
		net_let_me_alone();
		net_screen_clear();
		delete_text(all_text);
		from x=0 to 9; scroll_stop(x); end
	end
	
	// Set the new scene
	scene_current = new_scene;
	
	// Load scene config file
	scene_ini=file("scene/"+scene_current+"/scene.ini");
	load_ini_string(scene_ini);
	
	// Set screen mode
	say("Setting screen mode...");
#ifdef SPYBROS
	if(ops.full_screen == -1)
		full_screen = read_ini_int("config","full_screen",full_screen);
	else
		full_screen = ops.full_screen;
	end
#else
	full_screen = read_ini_int("config","full_screen",full_screen);
#endif
	
	scene_game_resolution_x=read_ini_int("config","game_resolution_x",scene_game_resolution_x);
	scene_game_resolution_y=read_ini_int("config","game_resolution_y",scene_game_resolution_y);
	if(scene_game_resolution_x>0 and scene_game_resolution_x!=ancho_pantalla)
		ancho_pantalla=scene_game_resolution_x;
		change_screen_resolution=1;
	end
	if(scene_game_resolution_y>0 and scene_game_resolution_y!=alto_pantalla)
		alto_pantalla=scene_game_resolution_y;
		change_screen_resolution=1;
	end
	
	scene_all_in_scroll = read_ini_int("config","all_in_scroll",0);
	if(scene_all_in_scroll > 0)
		scene_all_in_scroll++; // Para que corresponda con C_1, C_2, etc...
		texts_to_scroll = scene_all_in_scroll;
		
		if(!scene_scroll_bg1) scene_scroll_bg1 = map_new(scene_game_resolution_x,scene_game_resolution_y,32); end
	end

	scene_scale_resolution_x=read_ini_int("config","scale_resolution_x",0);
	scene_scale_resolution_y=read_ini_int("config","scale_resolution_y",0);
	if(scene_scale_resolution_x>0 and scene_scale_resolution_y>0)
		// #ifndef __NINTENDO_SWITCH__
		scale_resolution = scene_scale_resolution_x*10000 + scene_scale_resolution_y;
		change_screen_resolution=1;
		// #endif
	end
	
	scene_game_bpp=read_ini_int("config","game_resolution_bpp",scene_game_bpp);
	
	if(scene_editor_enabled)
		full_screen = false;
		// scale_resolution = -1;
	end
	
	if(change_screen_resolution)
		#ifndef __PIXTUDIO__
			set_mode(scene_game_resolution_x,scene_game_resolution_y,scene_game_bpp);
		#else
			set_mode(scene_game_resolution_x,scene_game_resolution_y);
		#endif
	end
	
	window_title=read_ini("config","title");
	if(!scene_editor_enabled)
		set_title(window_title);
	end
	
	scene_game_fps=read_ini_int("config","fps",scene_game_fps);
	scene_game_fps_max_skip=read_ini_int("config","fps_max_skip",scene_game_fps);
	set_fps(scene_game_fps,scene_game_fps_max_skip);

	say("Loading assets...");
	// Load this scene's FPGs, maps, musics and sounds
	scene_assets_load();
	
	say("Loading statuses...");
	// Load the process statuses
	scene_statuses_load("scene/"+scene_current+"/statuses.ini");
	
	if(scene_all_in_scroll > 0) //FIXME FUERTE. HACK PARA PIPIBIBIS
		scroll_start(scene_all_in_scroll-1,0,scene_scroll_bg1,0,1,0);
		region_define(1,53,0,320,240);
	end
	
	say("Executing scene autostart...");
	// Load and execute this scene "autostart" config file
	scene_autostart();
	
	// Instantiate scene's associated main process
	scene_run_on_scene_change();
	
	scene_fully_loaded=1;
	
	say("Scene loaded correctly!");
End

Function scene_read_actor_status(string process_name, string status_name, int scene_status_id);
Private
	string ini_section;
	string temp_s;
	int temp_i;
Begin
	load_ini_string(scene_statuses_ini);
	ini_section = process_name+":status:"+status_name;
	
	if(ini_section_exists(ini_section))
		scene_statuses[scene_status_id].name=ini_section;
		if(read_ini(ini_section,"x") != "")
			scene_statuses[scene_status_id].x=read_ini_int(ini_section,"x",0);
			scene_statuses[scene_status_id].x_set=1;
		end
		if(read_ini(ini_section,"y") != "")
			scene_statuses[scene_status_id].y=read_ini_int(ini_section,"y",scene_statuses[0].y);
			scene_statuses[scene_status_id].y_set=1;
		end
		if(read_ini(ini_section,"z") != "")
			scene_statuses[scene_status_id].z=read_ini_int(ini_section,"z",scene_statuses[0].z);
			scene_statuses[scene_status_id].z_set=1;
		end
		if(read_ini(ini_section,"graph") != "")
			scene_statuses[scene_status_id].graph=read_ini_int(ini_section,"graph",scene_statuses[0].graph);
			scene_statuses[scene_status_id].graph_set=1;
		end
		if(read_ini(ini_section,"size") != "")
			scene_statuses[scene_status_id].size=read_ini_int(ini_section,"size",scene_statuses[0].size);
			scene_statuses[scene_status_id].size_set=1;
		end
		if(read_ini(ini_section,"size_x") != "")
			scene_statuses[scene_status_id].size_x=read_ini_int(ini_section,"size_x",scene_statuses[0].size_x);
			scene_statuses[scene_status_id].size_x_set=1;
		end
		if(read_ini(ini_section,"size_y") != "")
			scene_statuses[scene_status_id].size_y=read_ini_int(ini_section,"size_y",scene_statuses[0].size_y);
			scene_statuses[scene_status_id].size_y_set=1;
		end
		if(read_ini(ini_section,"flags") != "")
			scene_statuses[scene_status_id].flags=read_ini_int(ini_section,"flags",scene_statuses[0].flags);
			scene_statuses[scene_status_id].flags_set=1;
		end
		if(read_ini(ini_section,"angle") != "")
			scene_statuses[scene_status_id].angle=read_ini_int(ini_section,"angle",scene_statuses[0].angle);
			scene_statuses[scene_status_id].angle_set=1;
		end
		if(read_ini(ini_section,"file") != "")
			scene_statuses[scene_status_id].file=scene_fpg_by_name(read_ini(ini_section,"file"));
			scene_statuses[scene_status_id].file_set=1;
		end
		if(read_ini(ini_section,"animation_set") != "")
			scene_statuses[scene_status_id].animation_set=animation_set_get_id(read_ini(ini_section,"animation_set"));
			scene_statuses[scene_status_id].animation_set_setted=1;
			if(read_ini(ini_section,"animation") != "")
				scene_statuses[scene_status_id].animation=animation_anim_id(scene_statuses[scene_status_id].animation_set,read_ini(ini_section,"animation"));
				scene_statuses[scene_status_id].animation_setted=1;				
			end
		end
		if(read_ini(ini_section,"alpha") != "")
			scene_statuses[scene_status_id].alpha=read_ini(ini_section,"alpha");
			scene_statuses[scene_status_id].alpha_set=1;
		end
		
		return 1;
	else
		#ifdef RAWR_DEBUG
		say("Scene actor status not available: "+ini_section);
		#endif
		return 0;
	end
End

Function scene_statuses_unload();
Private
	t_scene_status empty_status;
Begin
	from i=0 to scene_statuses_loaded;
		scene_statuses[i] = empty_status;
	end
	scene_statuses_loaded = 0;
End

Function scene_statuses_load(string filepath);
Private
	string section_name;
	string actor_name;
	string status_name;
	int start_pos;
	int end_pos;
Begin
	scene_statuses_ini=file(filepath);
	load_ini_string(scene_statuses_ini);
	
	// For each "%:status:%" section, we should read it to the scene_statuses global structure
	from i=0 to len(scene_statuses_ini);
		if(scene_statuses_ini[i]=="[")
			start_pos=i+1;
		end
		if(start_pos>0)
			if(scene_statuses_ini[i]=="]")
				end_pos=i;
				section_name=substr(scene_statuses_ini,start_pos,end_pos-start_pos);
				if(find(section_name,":status:"))
					// Find out actor name
					end_pos=find(section_name,":");
					actor_name=substr(section_name,0,end_pos);
					
					// Find out status_name
					start_pos=find(section_name,":",end_pos+1)+1;
					status_name=substr(section_name,start_pos);
					
					if(status_name!="" and actor_name!="")
						scene_statuses_loaded++;
						scene_read_actor_status(actor_name,status_name,scene_statuses_loaded);
					end
				end
				start_pos=0;
				end_pos=0;
			end
		end
	end
End

Function scene_autostart();
Begin
	load_ini_string(scene_ini);
	
	// Put this scene's background. If it is in a FPG file
	if(read_ini("autostart","bgfile") != "" AND read_ini_int("autostart","bggraph",-1) > -1)
		net_screen_put(scene_fpg_by_name(read_ini("autostart","bgfile")),read_ini_int("autostart","bggraph",-1));
	else // If it is in a MAP file
		if(read_ini("autostart","bgmap")!="")
			net_screen_put(0,scene_map_by_name(read_ini("autostart","bgmap")));
		end
	end
	
	// If in autoplay, start the music
	if(read_ini("autostart","music")!="")
		scene_music_play(read_ini("autostart","music"));
	end
End

Function string scene_get_process_name(actor_id);
Begin
	switch(actor_id.reserved.process_type)
		include "generated_process_list.inc.prg";
	end
	return actor_id.process_name;
End

Function int scene_run_on_scene_change();
Begin
	switch(scene_current)
		include "generated_run_on_scene_change.inc.prg";
	end
	
	if(!scene_editor_enabled)
		#ifndef SCENE_DONT_INSTANCE_STATICS
			scene_start_static_nodes();
		#endif
	end
	
	return "";
End

Process scene_start_static_nodes();
Private
	string static_nodes_names[100];
	string static_nodes;
	int start_pos;
	int end_pos;
	int num_parms=-1;
Begin
	// Read static nodes (nodes without processes) from scene.ini
	load_ini_string(scene_ini);
	static_nodes = read_ini("autostart","static_nodes");
	
	// Separate static_nodes names
	from x=0 to len(static_nodes);
		if(static_nodes[x]=="|")
			end_pos=x;
			num_parms++;
			if(end_pos!=start_pos)
				static_nodes_names[num_parms] = substr(static_nodes,start_pos,end_pos-start_pos);
			else // empty parameter
				num_parms--;
			end
			start_pos=end_pos+1;
		end
	end
	
	from x=0 to num_parms;
		if(static_nodes_names[x]!="")
			scene_node_process(static_nodes_names[x]);
		end
	end
	
	// Put static nodes on screen
	
End

Process scene_node_process(process_name);
Begin_Actor
	While(action!=-1)
		Frame_Actor;
	End
End

Function scene_status_apply(int actor_id, string process_name, string status_name);
Private
	int status_id;
Begin
	if(process_name == "")
		return false;
	end
	status_id = scene_status_find_id(process_name, status_name);
	if(status_id<0)
		#ifdef RAWR_DEBUG_VERBOSE
		say("Could not apply start status to "+process_name);
		#endif
		return false;
	end
	
	if(scene_statuses[status_id].x_set and actor_id.x == 0)
		actor_id.x = scene_statuses[status_id].x;
	end
	if(scene_statuses[status_id].y_set and actor_id.y == 0)
		actor_id.y = scene_statuses[status_id].y;
	end
	if(scene_statuses[status_id].z_set and actor_id.z == 0)
		actor_id.z = scene_statuses[status_id].z;
	end
	if(scene_statuses[status_id].graph_set)
		actor_id.graph = scene_statuses[status_id].graph;
	end
	if(scene_statuses[status_id].size_set)
		actor_id.size = scene_statuses[status_id].size;
	end
	if(scene_statuses[status_id].size_x_set)
		actor_id.size_x = scene_statuses[status_id].size_x;
	end
	if(scene_statuses[status_id].size_y_set)
		actor_id.size_y = scene_statuses[status_id].size_y;
	end
	if(scene_statuses[status_id].flags_set)
		actor_id.flags = scene_statuses[status_id].flags;
	end
	if(scene_statuses[status_id].angle_set)
		actor_id.angle = scene_statuses[status_id].angle;
	end
	if(scene_statuses[status_id].file_set)
		actor_id.file = scene_statuses[status_id].file;
	end
	if(scene_statuses[status_id].alpha_set)
		actor_id.alpha = scene_statuses[status_id].alpha;
	end
	if(scene_statuses[status_id].animation_setted)
		actor_id.animation_set = scene_statuses[status_id].animation_set;
		actor_id.animation = scene_statuses[status_id].animation;
	else // Animation set will be automatically assigned if the process' name matches an animation set's name
		if(animation_set_get_id(process_name)>0)
			actor_id.animation_set = animation_set_get_id(process_name);
			actor_id.animation = animation_sets[actor_id.animation_set].default_anim;
		end
	end
	
	#ifdef SCENE_ENABLE_AUTO_COLLISION_GRAPH
	if(actor_id.file)
		if(map_exists(actor_id.file, 999))
			actor_id.collision_graph = 999;
		end
	end
	#endif
	
	return true;
End

Function scene_status_find_id(string process_name, string status_name);
Private
	string name_to_find;
Begin
	name_to_find=process_name+":status:"+status_name;

	// Search for the status
	from i=0 to SCENE_MAX_STATUS;
		if(scene_statuses[i].name == name_to_find)
			return i;
		end
	end
	return -1;
End


Function scene_actor_init(actor_id);
Begin
	// Set it as an actor
	actor_id.is_actor = 1;

	// Get the process into the local string
	actor_id.process_name = scene_get_process_name(actor_id);
	
	// Find out if there's a start status in the scene file
	scene_status_apply(actor_id, actor_id.process_name, "start");
	
	if(actor_id.animation_set>0 and actor_id.animation>0)
		animate_that(actor_id);
	end
	
	if(scene_all_in_scroll)
		actor_id.ctype=c_scroll;
		actor_id.cnumber=c_1;
	end
	
	if(scene_globals.actor_size_multiplier != 0)
		actor_id.size = 100 * scene_globals.actor_size_multiplier;
	end
End