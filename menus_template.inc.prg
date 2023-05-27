Global
	struct menus;
		x_base_menu=250;
		y_base_menu=200;
		distancia_opciones=100;
		size=50;
		opcion_actual;
		estado;
		arrow_fpg;
		arrow_graph;
		arrow_x=200;
		torcido;
		fuente;
	end
End

Function menu(string options,int escapable);
Private
	id_texto[15];
	string textos[15];
	num_opciones;
	opcion_actual;
	y_objetivo;
	b_suelto;
	x_inc;
	gravedad;
Begin
	#IFDEF TACTIL
	no_vgamepad=0;
	gamepad_virtual();
	#ENDIF

	if(texts_to_scroll)
		ctype = c_scroll;
		cnumber = texts_to_scroll;
	end

	menus.opcion_actual=0;
	menus.estado=1;

	from i=0 to len(options);
		if(options[i]!="#")
			textos[j]+=""+options[i];
		else
			j++;
		end
	end
	num_opciones=j;
	
	y=menus.y_base_menu;
	
	from i=0 to num_opciones;
		if(textos[i]!="")
			id_texto[i]=texto_menu(y+=menus.distancia_opciones,textos[i]);
		end
	end
	
	z=-20;

	file=menus.arrow_fpg;
	graph=menus.arrow_graph;
	alpha=0;
	z=-100000;
	
	x=menus.arrow_x;
	
	j=0;
	//controlador(0);
	while(get_button(0,b_any)) frame; end
	while(get_button(0,b_accept)==0)
		if(alpha<255) alpha+=10; end
		if(escapable AND get_button(0,b_cancel)) 
			while(get_button(0,b_cancel)) frame; end 
			opcion_actual=-1; 
			// suena(s_change_selection); 
			break; 
		end
		y_objetivo=menus.y_base_menu+((opcion_actual+1)*menus.distancia_opciones);
		if(y!=y_objetivo)
			y+=(y_objetivo-y)/2;
			if(y_objetivo>y) y++; elseif(y_objetivo<y) y--; end
			angle=menus.torcido+fget_angle(x,y,x+30,y_objetivo);
		else
			angle=menus.torcido;
		end

		if(b_suelto)
			if(get_button(0,b_up)) 
				b_suelto=0; 
				opcion_actual--; 
				//suena(s_change_selection); 
			end
			if(get_button(0,b_down)) 
				b_suelto=0; 
				opcion_actual++; 
				//suena(s_change_selection); 
			end
		else
			if(get_button(0,b_up)==0 and get_button(0,b_down)==0)
				b_suelto=1;
			end
		end
		if(opcion_actual<0) opcion_actual=num_opciones; end
		if(opcion_actual>num_opciones) opcion_actual=0; end
		menus.opcion_actual=opcion_actual;
		frame;
	end
		
	menus.estado=0;
	
	if(opcion_actual!=-1)
		// suena(s_accept);
		soft_kill(id_texto[opcion_actual]);
	else
		action=-1;
		frame;
		return opcion_actual;
	end
	
	action=-1;
	x_inc=rand(10,15);
	/*gravedad=rand(-15,-5);
	
	while(y<1000)
		size++;
		x+=x_inc*1.5;
		y+=gravedad*2;
		gravedad++;
		angle-=3500;
		frame;
	end*/
	from alpha=255 to 0 step -10; gravedad+=2; x+=gravedad; angle-=gravedad*1000; frame; end
	return opcion_actual;
End

Process texto_menu(y,string mitexto);
Private
	id_texto;
Begin
	if(global_resolution!=0) resolution=global_resolution; end
	x=800;
	z=-512;
	angle=-50000;
	id_texto=write_size(menus.fuente,x,y,3,"%"+mitexto+"%",menus.size);
	loop
		if(!exists(father)) break; end
		if(father.action!=0) break; end
		x+=((menus.x_base_menu-x)/5);
		angle+=((menus.torcido-angle)/5);
		if(exists(id_texto))
			id_texto.x=x;
			id_texto.angle=angle;
		end
		frame;
	end
	if(action==0)
		fade_off_text(id_texto,10);
	else
		from i=1 to 3;
			if(exists(id_texto))
				id_texto.alpha=0; 
				frame(200); 
				id_texto.alpha=255; 
				frame(200);
			end
		end

		while(x<1300)
			x+=((1400-x)/10);
			if(exists(id_texto))
				id_texto.x=x;
			end
			frame;
		end
		delete_text(id_texto);
	end
End

/*
Process mostrar_opcion(y,i);
Private
	string mitexto;
	int id_texto;
Begin
	switch(i)
		case 1: //sonido
			if(ops.sonido) 
				mitexto="ON";
			else 
				mitexto="OFF";
			end
		end
		case 0: //música
			if(ops.musica) 
				mitexto="ON";
			else 
				mitexto="OFF";
			end
		end
		case 2: //dificultad
			switch(ops.dificultad)
				case 0:
					mitexto="facil";
				end
				case 1:
					mitexto="normal";
				end
				case 2:
					mitexto="dificil";
				end
			end
		end
		default: //go back
			return;
		end
	end

	z=-512;
	id_texto=write_cool(menus.fuente,1000,y,4,"%"+mitexto+"%",60,11);
	angle=-50000;
	
	while(exists(father) and action==0)
		angle+=((menus.torcido-angle)/5);
		if(exists(id_texto))
			id_texto.angle=angle;
		end
		frame;
	end
	
	if(action==-1)
		//explosion(1000,y,50);
	end
	soft_kill(id_texto);
End
*/

Function menu_opciones(string options,int escapable);
Private
	id_texto[15];
	id_opcion[15];
	string textos[15];
	num_opciones;
	opcion_actual;
	y_objetivo;
	b_suelto;
	id_fpg_gamepad_anterior;
Begin
	#IFDEF TACTIL
	no_vgamepad=0;
	gamepad_virtual();
	#ENDIF

	//id_fpg_gamepad_anterior=ops.gamepad_fnt;

	from i=0 to len(options);
		if(options[i]!="#")
			textos[j]+=""+options[i];
		else
			j++;
		end
	end
	num_opciones=j;

	x=menus.x_base_menu-190;
	y=menus.y_base_menu;
	
	from i=0 to num_opciones;
		if(textos[i]!="")
			y+=menus.distancia_opciones;
			id_texto[i]=texto_menu(y,textos[i]);
			// id_opcion[i]=mostrar_opcion(y,i);
		end
	end
	
	z=-20;
	
	x=menus.x_base_menu-40;

	file=menus.arrow_fpg;
	graph=menus.arrow_graph;
	alpha=0;
	z=-100000;
	
	j=0;
	loop
		if(alpha<255) alpha+=10; end
		if(escapable AND get_button(0,b_cancel)) while(get_button(0,b_cancel)) frame; end opcion_actual=-1; break; end
		y_objetivo=menus.y_base_menu+((opcion_actual+1)*menus.distancia_opciones);
		if(y!=y_objetivo)
			y+=(y_objetivo-y)/2;
			if(y_objetivo>y) y++; elseif(y_objetivo<y) y--; end
			angle=menus.torcido+fget_angle(x,y,x+30,y_objetivo);
		else
			angle=menus.torcido;
		end

		if(b_suelto)
			if(get_button(0,b_up)) 
				// suena(s_change_selection); 
				b_suelto=0; 
				opcion_actual--; 
			end
			if(get_button(0,b_down)) 
				// suena(s_change_selection); 
				b_suelto=0; 
				opcion_actual++; 
			end
		else
			if(get_button(0,b_up)==0 and get_button(0,b_down)==0)
				b_suelto=1;
			end
		end
		if(opcion_actual<0) opcion_actual=num_opciones; end
		if(opcion_actual>num_opciones) opcion_actual=0; end
		
		if(get_button(0,b_accept))
			while(get_button(0,b_accept)) frame; end
			soft_kill(id_opcion[opcion_actual]);
			// suena(s_accept);
			/* switch(opcion_actual)
				case 0: //música
					if(ops.musica) 
						ops.musica=0; 
						song_stop();
					else 
						ops.musica=1; 
						musica();
					end
				end
				case 1: //sonido
					if(ops.sonido) 
						ops.sonido=0; 
					else 
						ops.sonido=1; 
					end
				end
				case 2: //dificultad
					if(ops.dificultad==2) ops.dificultad=0; else ops.dificultad++; end
				end
			end
			*/
			// id_opcion[opcion_actual]=mostrar_opcion(y_objetivo,opcion_actual);
		end
		
		frame;
	end
	
	menus.estado=0;
	
	/* if(id_fpg_gamepad_anterior!=ops.gamepad_fnt)
		carga_fpg_gamepad();
	end
	*/
	
	action=-1;
	frame;
End

Function soft_kill(process_id);
Begin
	if(exists(process_id))
		process_id.action=-1;
	end
End