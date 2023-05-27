// Load full RAWRLab framework v1.0
// Description: TODO
// Author: Pablo A. Navarro Reyes / RAWRLab © 2021
// License: zlib

include "../../../libs/rawrlab-fw/pxtcompat.h";
include "../../../libs/rawrlab-fw/common_globals.h";
include "../../../libs/rawrlab-fw/common_locals.h";
include "../../../libs/rawrlab-fw/string_replace.pr-";
include "../../../libs/rawrlab-fw/inherit.pr-";
include "../../../libs/rawrlab-fw/clamp.inc.prg";
include "../../../libs/rawrlab-fw/net_play.pr-";
include "../../../libs/rawrlab-fw/mod_text2.pr-";
include "../../../libs/rawrlab-fw/gamepads.pr-";
include "../../../libs/rawrlab-fw/animate_me.pr-";

#ifndef DISABLE_FADE_OFF_PROCESS
include "../../../libs/rawrlab-fw/fade_off_process.pr-";
#endif
include "../../../libs/rawrlab-fw/bounce_deform.pr-";
#ifdef ENABLE_SCENE_SYSTEM
	include "../../../libs/rawrlab-fw/scene_fw.inc.prg";
	include "../../../libs/rawrlab-fw/attached_to.inc.prg";
#endif
#ifdef USE_ANDROID_FOPEN_PATCH
	include "../../../libs/rawrlab-fw/android_fopen.pr-";
#endif
include "../../../libs/rawrlab-fw/32bit_palettes.inc.prg";
#ifdef ENABLE_DO_DEBUG
	include "../../../libs/rawrlab-fw/do_debug.pr-";
#endif

//Thanks to Javier Arias for this nice tween library!
include "../../../libs/rawrlab-fw/motion_tween.inc";