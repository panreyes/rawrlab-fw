// Project: Motion Tween library
// Description: Motion Tween library for BennuGD by Javier Arias.
// Author: Javier Arias (Javis)
// License: ?

// Usage:
// - Include it :)
// - Have a look at the desired motion effect in the list below
// - Call this process in your code: 
//	   tween_to(int* property, int  toValue,  int  effectType, int  duration)
//         property   : Pointer of an INT variable.
//         toValue    : Objective of the INT variable.
//         effectType : Type of effect to apply from the list below (check struct motion_effect).
//         duration   : Duration of the effect in number of frames.
// Example:
//     tween_to(&x, 1920, motion_effect.regularEaseOut, 30);

#ifndef __MOTION_TWEEN_LIB
#define __MOTION_TWEEN_LIB


/*
// This library requires all those. Please import them before using this library!
import "mod_say";
import "mod_map"
import "mod_key"
import "mod_grproc"
import "mod_proc"
import "mod_video"
import "mod_math"
*/

Const
	ALPHA_GRADE = 1.70158;
	BETA_GRADE = 1.525;
End


Global
	struct motion_effect
		// No motion effect
		int none = 0;
	
		// Regular
		int regularEaseIn = 1;
		int regularEaseOut = 2;
		int regularEaseInOut = 3;
		// Bounce
		int bounceEaseIn = 4;
		int bounceEaseOut = 5;
		int bounceEaseInOut = 6;
		// Back
		int backEaseIn = 7;
		int backEaseOut = 8;
		int backEaseInOut = 9;
		// Strong
		int strongEaseIn = 10;
		int strongEaseOut = 11;
		int strongEaseInOut = 12;
		// Elastic
		int elasticEaseIn = 13;
		int elasticEaseOut = 14;
		int elasticEaseInOut = 15;    	
	end
End

Local
	int tweening;
End

Type _tween
	int* property;
	int  effectType;
	int  fromValue;
	int  toValue;
	int  duration;
	int  start;
End

//Back
Function int backEaseIn(float _step, int _initial_value, int _nro_steps, int _duration);
Private
	float s;
Begin
 	s = ALPHA_GRADE;
	return _nro_steps*(_step/=_duration)*_step*((s+1)*_step - s) + _initial_value;
End
Function int backEaseOut(float _step, int _initial_value, int _nro_steps, int _duration);
Private
	float s;
Begin
	s = ALPHA_GRADE;
	return _nro_steps*((_step/=_duration-1)*_step*((s+1)*_step + s) + 1) + _initial_value;
End
Function int backEaseInOut(float _step, int _initial_value, int _nro_steps, int _duration);
Private
	float s;
	float resultado;
Begin
	s = ALPHA_GRADE;
	if ((_step/=_duration/2) < 1) 
		resultado = _nro_steps/2*(_step*_step*(((s*=(BETA_GRADE))+1)*_step - s)) + _initial_value;
	else
		resultado = _nro_steps/2*((_step-=2)*_step*(((s*=(BETA_GRADE))+1)*_step + s) + 2) + _initial_value;
	end
	return resultado;
End

//Strong
Function int strongEaseIn(float _step, int _initial_value, int _nro_steps, int _duration);
Begin
	return _nro_steps*(_step/=_duration)* _step*_step*_step*_step + _initial_value;
End
Function int strongEaseOut(float _step, int _initial_value, int _nro_steps, int _duration);
Begin
	return _nro_steps*((_step/=_duration-1)*_step*_step*_step*_step + 1) + _initial_value;
End
Function int strongEaseInOut(float _step, int _initial_value, int _nro_steps, int _duration);
Begin
	if ((_step/=_duration/2) < 1) 
		return _nro_steps/2*_step*_step*_step*_step*_step + _initial_value;
	end
	return _nro_steps/2*((_step-=2)*_step*_step*_step*_step + 2) + _initial_value;
End

//Bounce
Function int bounceEaseOut(float _step, int _initial_value, int _nro_steps, int _duration);
Begin
	if ((_step/=_duration) < (1/2.75)) 
		return _nro_steps*(7.5625*_step*_step) + _initial_value;
	elseif (_step < (2/2.75)) 
		return _nro_steps*(7.5625*(_step-=(1.5/2.75))*_step + 0.75) + _initial_value;
	elseif (_step < (2.5/2.75)) 
		return _nro_steps*(7.5625*(_step-=(2.25/2.75))*_step + 0.9375) + _initial_value;
	else 
		return _nro_steps*(7.5625*(_step-=(2.625/2.75))*_step + 0.984375) + _initial_value;
	end
End
Function int bounceEaseIn(float _step, int _initial_value, int _nro_steps, int _duration);
begin
	return _nro_steps - bounceEaseOut (_duration-_step, 0, _nro_steps, _duration) + _initial_value;
end
Function int bounceEaseInOut(float _step, int _initial_value, int _nro_steps, int _duration);
Begin
	if (_step < _duration/2) 
		return bounceEaseIn (_step*2, 0, _nro_steps, _duration) * 0.5 + _initial_value;
	else 
		return bounceEaseOut (_step*2-_duration, 0, _nro_steps, _duration) * 0.5 + _nro_steps*0.5 + _initial_value;
	end
End

// Regular
Function float regularEaseIn(float _step, int _initial_value, int _nro_steps, int _duration);
Begin
	return _nro_steps*(_step/=_duration)*_step + _initial_value;	
End

Function float regularEaseOut(float _step, int _initial_value, int _nro_steps, int _duration);
private
	float result;
Begin
	result = (-_nro_steps*(_step/=_duration)*(_step-2) + _initial_value);
	return result;
End

Function float regularEaseInOut(float _step, int _initial_value, int _nro_steps, int _duration);
Begin
	if ((_step/=_duration/2) < 1) 
		return _nro_steps/2*_step*_step + _initial_value;
	end
	return -_nro_steps/2 * ((--_step)*(_step-2) - 1) + _initial_value;
end

//Elastic
Function int elasticEaseIn(float _step, int _initial_value, int _nro_steps, int _duration);
private
	float a;
	float p;
	float s;
Begin
		if (_step==0) 
			return _initial_value;
		end
		if ((_step/=_duration)==1) 
			return _initial_value+_nro_steps;
		end
		p=_duration*0.3;
		if (a < abs(_nro_steps)) 
			a=_nro_steps; 
			s=p/4;
		else 
			s = p/(2*PI) * asin (_nro_steps/a);
		end
		
		return -(a*pow(2,10*(_step-=1)) *sin( (_step*_duration-s)*(2*PI)/p )) + _initial_value;
End
Function int elasticEaseOut(float _step, int _initial_value, int _nro_steps, int _duration);
private
	float a;
	float p;
	float s;
Begin
	if (_step==0) 
		return _initial_value;
	end
	if ((_step/=_duration)==1)
		return _initial_value+_nro_steps;
	end
	p=_duration*0.3;
	if (a < abs(_nro_steps))
		a=_nro_steps;
		s=p/4;
	else
		s = p/(2*PI) * asin (_nro_steps/a);
	end
	return (a*pow(2,-10*_step) * sin( (_step*_duration-s)*(2*PI)/p ) + _nro_steps + _initial_value);
End
Function int elasticEaseInOut(float _step, int _initial_value, int _nro_steps, int _duration);
private
	float a;
	float p;
	float s;
Begin
	if (_step==0)
		return _initial_value;
	end
	if ((_step/=_duration/2)==2)
		return _initial_value+_nro_steps;
	end
	p=_duration*(0.3*1.5);
	if (a < abs(_nro_steps))
		a=_nro_steps;
		s=p/4;
	else
		s = p/(2*PI) * asin (_nro_steps/a);
	end
	if (_step < 1)
		return -0.5*(a*pow(2,10*(_step-=1)) * sin( (_step*_duration-s)*(2*PI)/p )) + _initial_value;
	end
	return a*pow(2,-10*(_step-=1)) * sin( (_step*_duration-s)*(2*PI)/p )*0.5 + _nro_steps + _initial_value;
End


Function float _callEffectFunction(float _step, int _initial_value, int _nro_steps, int _duration, int effect);
Begin
	switch(effect)
		// No motion effect
		case motion_effect.none:
			return _initial_value + (_nro_steps / _duration * _step);
		end
	
		// Regular
		case motion_effect.regularEaseIn:
			return regularEaseIn(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.regularEaseOut:
			return regularEaseOut(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.regularEaseInOut:
			return regularEaseInOut(_step, _initial_value, _nro_steps, _duration);
		end
		// Bounce
		case motion_effect.bounceEaseIn:
			return bounceEaseIn(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.bounceEaseOut:
			return bounceEaseOut(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.bounceEaseInOut:
			return bounceEaseInOut(_step, _initial_value, _nro_steps, _duration);
		end
		// Back
		case motion_effect.backEaseIn:
			return backEaseIn(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.backEaseOut:
			return backEaseOut(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.backEaseInOut:
			return backEaseInOut(_step, _initial_value, _nro_steps, _duration);
		end
		// Strong
		case motion_effect.strongEaseIn:
			return strongEaseIn(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.strongEaseOut:
			return strongEaseOut(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.strongEaseInOut:
			return strongEaseInOut(_step, _initial_value, _nro_steps, _duration);
		end
		//Elastic
		case motion_effect.elasticEaseIn:
			return elasticEaseIn(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.elasticEaseOut:
			return elasticEaseOut(_step, _initial_value, _nro_steps, _duration);
		end
		case motion_effect.elasticEaseInOut:
			return elasticEaseInOut(_step, _initial_value, _nro_steps, _duration);
		end
	end
End

/**
 * This function aply an effect to the argument property (not sincronized efect - all at the same time) 
 *
 * @param propiedad: It is modified by the fuction with the selected effect
 * @param effecto:	define the effect to apply
 * @param valorFinal: define the final value that the property will have when the effect finish.
 * @param duracion: define the time duration of the effect (in frames).
 */
Process tween(_tween _effect)
public
_tween effect;
Private
	int _nro_steps;
	float _step;
	float _value;
Begin
	_nro_steps = _effect.toValue - _effect.fromValue;
	_step = 0;
	effect = _effect;
	Repeat
		_value = _callEffectFunction(_step, _effect.fromValue, _nro_steps, _effect.duration, _effect.effectType);
		//say(_value);
		*_effect.property = _value;//_callEffectFunction(_step, _effect.fromValue, _nro_steps, _effect.duration, _effect.effectType);
		_step++;
		frame;
	Until(_step==(_effect.duration+1))
	frame;
End

/**
 * This function forces the animation to end
 */
function tween_finish(tween tween)
private
begin
	*tween.effect.property = tween.effect.toValue;
	signal(tween,s_kill_tree);
end

function tween_finish_all()
private 
	int this_anim;
begin
	while (this_anim = get_id(type tween))
		tween_finish(this_anim);
	end
end

process tween_to(int* property, int  toValue,  int  effectType, int  duration)
public
	tween tweenning;
end
private
	_tween this_anim;	
end
begin
	this_anim.property = property;
	this_anim.effectType = effectType;
	this_anim.fromValue = *property;
	this_anim.toValue = toValue;
	this_anim.duration = duration;

	tweenning = tween(this_anim);
	if(exists(father))
		father.tweening++;
	end
	while (exists(tweenning))
		frame;
	end
	if(exists(father))
		father.tweening--;
	end
	onexit:
	signal(id,s_kill_tree);
end 

// returns true if an animation is being done
function tweening()
begin
	return get_id(type tween) != 0; 
end

#endif