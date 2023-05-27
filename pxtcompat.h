// PixTudio compatibility library v0.1
// Description: Compatibilizes PixTudio code with BennuGD 1 and 2
// Author: Pablo A. Navarro Reyes / RAWRLab © 2021
// License: zlib

#IFNDEF __PXTCOMPAT__
	#DEFINE __PXTCOMPAT__ 1
	
	// Quick fix for RAWRLAB (it's PixTudio with a few changes in the end!)
	#IFDEF __RAWRLAB__
		#DEFINE __PIXTUDIO__ 1
	#ENDIF

	//========================================= MODULES
	
	#IFNDEF MODULES_ALREADY_IMPORTED
		#DEFINE MODULES_ALREADY_IMPORTED 1
		#IFDEF __BENNUGD__
			#DEFINE USE_MOD_JOY 1
			#IFNDEF OS_ANDROID
				#DEFINE OS_ANDROID 1003
			#ENDIF
			import "mod_dir";
			import "mod_draw";
			import "mod_effects";
			import "mod_file";
			import "mod_grproc";
			import "mod_key";
			import "mod_map";
			import "mod_math";
			import "mod_mem";
			import "mod_mouse";
			import "mod_path";
			import "mod_proc";
			import "mod_rand";
			import "mod_regex";
			import "mod_say";
			import "mod_screen";
			import "mod_scroll";
			import "mod_sort";
			import "mod_sound";
			import "mod_string";
			import "mod_sys";
			#IFNDEF CUSTOM_MOD_TEXT
				import "mod_text";
				#DEFINE MOD_TEXT_COMPAT 1
			#ENDIF
			import "mod_time";
			import "mod_timers";
			import "mod_video";
			import "mod_wm";
		#ENDIF

		#IFDEF __PIXTUDIO__
			import "mod_dir";
			import "mod_draw";
			import "mod_file";
			import "mod_grproc";
			import "mod_key";
			import "mod_map";
			import "mod_math";
			import "mod_mouse";
			import "mod_path";
			import "mod_proc";
			import "mod_rand";
			import "mod_say";
			import "mod_screen";
			import "mod_scroll";
			import "mod_sort";
			import "mod_sound";
			import "mod_string";
			import "mod_sys";
			#IFNDEF CUSTOM_MOD_TEXT
				import "mod_text";
				#DEFINE MOD_TEXT_COMPAT 1
			#ENDIF
			import "mod_time";
			import "mod_timers";
			import "mod_video";
			import "mod_wm";
		#ENDIF

		#IFDEF __BENNUGD2__
			import "libmod_gfx"
			import "libmod_input"
			import "libmod_sound"
			import "libmod_misc";
			import "libmod_debug";
			#DEFINE MOD_TEXT_COMPAT 1
		#ENDIF

		#IFDEF __NINTENDO_SWITCH__
			import "mod_nswitch";
		#ENDIF
		
		#IFDEF STEAM
			import "mod_steam";
		#ENDIF
		
		#IFDEF TACTIL
			import "mod_multi";
		#ENDIF
		
		#IFDEF TOUCHSCREEN
			import "mod_multi";
		#ENDIF
	#ENDIF
	
	//================================ end of MODULES
	
	//================================ WRAPPERS
	
	#IFDEF __BENNUGD__
		#IFNDEF BGD1_WRAPPERS
			#DEFINE BGD1_WRAPPERS 1
			#DEFINE song_stop stop_song
			#DEFINE song_unload unload_song
			#DEFINE song_load load_song
			#DEFINE song_play play_song
			
			#DEFINE sound_stop stop_wav
			#DEFINE sound_unload unload_wav
			#DEFINE sound_load load_wav
			#DEFINE sound_play play_wav
		#ENDIF
	#ENDIF
	
	#IFDEF __BENNUGD2__
		#IFNDEF BGD2_WRAPPERS
			#DEFINE BGD2_WRAPPERS 1
			#DEFINE tlocal (double)
			#DEFINE local_type double
			
			#DEFINE div_scan_code keyboard.scan_code
			#DEFINE div_fps frame_info.fps
			#DEFINE div_frame_time frame_info.frame_time
			#DEFINE delta_time frame_info.frame_time
			#DEFINE full_screen screen.fullscreen
			#DEFINE exit_status 0
			#DEFINE set_title window_set_title
			#DEFINE png_load map_load
			#DEFINE file_exists fexists
			#DEFINE delete_text write_delete
			#DEFINE joy_get_button get_joy_button
			#DEFINE collision_box collision
			#DEFINE song_load music_load
			#DEFINE song_unload music_unload
			#DEFINE song_play music_play
			#DEFINE music_fade_out music_fade_off
			#DEFINE song_is_playing music_is_playing
			#DEFINE song_stop music_stop
			#DEFINE stop_wav sound_stop
			#DEFINE focus_status 1
			#DEFINE song_set_volume music_set_volume

			#DEFINE put_screen screen_put
			#DEFINE clear_screen screen_clear
			#DEFINE write_int(font_id,x,y,alignment,pointer_to_data) WRITE_VALUE(font_id,x,y,alignment,text_int,pointer_to_data)

			Function screen_put(file,graph);
			Begin
				background.file=file;
				background.graph=graph;
			End

			Function screen_clear();
			Begin
				background.file=0;
				background.graph=0;
			End
		#ENDIF
	#ENDIF
	
	//Attention: Not NOT FENIX!
	
	#IFNDEF __NOTFENIX__
		#IFNDEF FNX_WRAPPERS
			#DEFINE FNX_WRAPPERS 1
			#DEFINE all_process 0
			#DEFINE region_define(regionID,x,y,width,height) define_region(regionID,x,y,width,height)
			#DEFINE region_out(processID,regionID) out_region(processID,regionID)
			#DEFINE png_save(fileID,graphID,filename) save_png(fileID,graphID,filename)
			#DEFINE fpg_save(fileID,filename) save_fpg(fileID,filename)
			#DEFINE fnt_save(fileID,filename) save_fnt(fileID,filename)
			#DEFINE fnt_unload(fileID) unload_fnt(fileID)
			#DEFINE png_unload(fileID) unload_png(fileID)
			#DEFINE fpg_unload(fileID) unload_fpg(fileID)
			#DEFINE map_unload(fileID,graphID) unload_map(fileID,graphID)
			#DEFINE song_unload(fileID) unload_song(fileID)
			#DEFINE png_load(filename) load_png(filename)
			#DEFINE fpg_load(filename) load_fpg(filename)
			#DEFINE map_load(filename) load_map(filename)
			#DEFINE fnt_load(filename) load_fnt(filename)
			#DEFINE song_load(filename) load_song(filename)
			#DEFINE screen_put(fileID,graph) put_screen(fileID,graph)
			#DEFINE screen_clear() clear_screen()
			#DEFINE screen_get() get_screen()
			#DEFINE scroll_start(scrollnumber,fileID,graphID,backgroundgraphID,regionnumber,lockindicator) start_scroll(scrollnumber,fileID,graphID,backgroundgraphID,regionnumber,lockindicator)
			#DEFINE scroll_stop(scrollID) stop_scroll(scrollID)
			#DEFINE fade_in() fade_on()
			#DEFINE fade_out() fade_off()
			#DEFINE G_WIDTH g_wide
			#DEFINE joy_get_button(joy,button) get_joy_button(joy,button)
			#DEFINE map_new(width,height,bpp) new_map(width,height,bpp)
			#DEFINE fpg_new() new_fpg()
			#DEFINE set_center(fileID,graphID,x,y) center_set(fileID,graphID,x,y)
			#DEFINE joy_numbuttons(joy) joy_num_buttons(joy)
			#DEFINE number_joy() joy_number()
			#DEFINE song_play(songID,repeats) play_song(songID,repeats)
			#DEFINE song_stop() stop_song()
			#DEFINE song_pause() pause_song()
			#DEFINE song_resume() resume_song()
			#DEFINE sound_play(wavID,repeats) play_wav(wavID,repeats)
			#DEFINE sound_stop(channel) stop_wav(channel)
			#DEFINE music_fade_in(songID,num_loops,ms) fade_music_in(songID,num_loops,ms)
			#DEFINE music_fade_out(ms) fade_music_off(ms)
			#DEFINE sound_set_volume(waveID,volume) set_wav_volume(waveID,volume)
			#DEFINE channel_set_volume(channel,volume) set_channel_volume(channel,volume)
			#DEFINE channels_reserve(num_channels) reserve_channels(num_channels)
			#DEFINE channel_panning_set(channel,left,right) set_panning(channel,left,right)
			#DEFINE channel_position_set(channel,angle,distance) set_position(channel,angle,distance)
			#DEFINE channel_distance_set(channel,distance) set_distance(channel,distance)
			#DEFINE stereo_reverse(channel,flip) reverse_stereo(channel,flip)
			#DEFINE music_set_position(position) set_music_position(position)
			#DEFINE sound_is_playing(channel) is_playing_wav(channel)
			#DEFINE song_is_playing() is_playing_song()
			#DEFINE song_set_volume(volume) set_song_volume(volume)
			#DEFINE sound_load(filename) load_wav(filename)
			#DEFINE collision_box(collisionwith) collision(collisionwith)
			#DEFINE os_id -1
			#DEFINE sra_preserve -1

			Global
				int scale_resolution_aspectratio=0;
				int scale_resolution=0;
			End
		#ENDIF
	#ENDIF
	
	#IFNDEF __BENNUGD2__
		#IFNDEF NOT_BGD2_WRAPPERS
			#DEFINE NOT_BGD2_WRAPPERS 1
			#DEFINE tlocal (int)
			#DEFINE local_type int
			
			#DEFINE div_scan_code scan_code
			#DEFINE div_fps fps
			#DEFINE div_frame_time frame_time
			#DEFINE delta_time frame_time
		#ENDIF
	#ENDIF
	
	#IFNDEF __PIXTUDIO__
		#IFNDEF NOT_PXT_WRAPPERS
			#DEFINE NOT_PXT_WRAPPERS 1
			Global
				int scale_quality=0;
			End
			
			#IFDEF __BENNUGD2__
				
				// No funciona y no sé por qué
				/*#DEFINE modr color_r
				#DEFINE modg color_g
				#DEFINE modb color_b*/
				
				Local
					int modr,modg,modb;
				End
			#ELSE
				Local
					int modr,modg,modb;
				End
			#ENDIF
		#ENDIF
	#ENDIF	

	//==================================== end of WRAPPERS
#ENDIF