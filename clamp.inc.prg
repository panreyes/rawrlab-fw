Function clamp(int value_current, int value_min, int value_max);
Begin
	if(value_current>value_max)
		return value_max;
	elseif(value_current<value_min)
		return value_min;
	else
		return value_current;
	end
End

Function float fclamp(float value_current, float value_min, float value_max);
Begin
	if(value_current>value_max)
		return value_max;
	elseif(value_current<value_min)
		return value_min;
	else
		return value_current;
	end
End