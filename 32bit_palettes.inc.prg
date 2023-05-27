Const
	num_paletas_max = 32;
End

Global
	num_paletas;
	paletas_num_colores[num_paletas_max];
	paletas_colores[num_paletas_max][32][2];
End

Function palette_load(string filename);
Private
	temp;
	color;
Begin
	if(num_paletas == 10)
		return -1;
	end

	temp = png_load(filename);
	if(temp < 1)
		return -1;
	end
	
	num_paletas++;
	
	paletas_num_colores[num_paletas] = map_info(0,temp,G_WIDTH)-1;
	
	from i=0 to paletas_num_colores[num_paletas];
		paletas_colores[num_paletas][i][1]=map_get_pixel(0,temp,i,0);
		paletas_colores[num_paletas][i][2]=map_get_pixel(0,temp,i,1);
	end
	
	map_unload(0,temp);
	
	return num_paletas;
End

Function fpg_color_replace(file, palette, fpg_option);
Private
	clone_fpg;
Begin
	if(file < 1 or palette < 1)
		return -1;
	end
	
	if(fpg_option == 1) //Clone FPG
		clone_fpg = fpg_new();
	end
	
	if(fpg_option == 2) //Export to PNGs
		mkdir("fpg-temp-output");
	end
	
	from i=1 to 999;
		if(map_exists(file,i))
			if(clone_fpg)
				fpg_add(clone_fpg,i,file,i);
				map_color_replace(clone_fpg,i,palette);
			else
				map_color_replace(file,i,palette);
			end
			
			if(fpg_option == 2)
				mkdir("fpg-temp-output");
				png_save(file,i,"fpg-temp-output\"+i+".png");
			end
		end
	end
	
	if(clone_fpg)
		return clone_fpg;
	else
		return file;
	end
End

Function map_color_replace(file,map,palette);
Begin
	if(palette < 1 or palette > 10)
		return -1;
	end

	i = map_info(file,map,G_WIDTH);
	j = map_info(file,map,G_HEIGHT);
	from x=0 to i;
		from y=0 to j;
			from z=0 to paletas_num_colores[palette];
				if(map_get_pixel(file,map,x,y) == paletas_colores[palette][z][1])
					map_put_pixel(file,map,x,y,paletas_colores[palette][z][2]);
				end
			end
		end
	end
End