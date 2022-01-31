#IFNDEF RAWRLAB_COMMON_GLOBALS
#DEFINE RAWRLAB_COMMON_GLOBALS 1

Global
	int possible_players;
	int players;

	struct p[100];
		int control;
	end
	
	struct ops;
		string lang="en";
	end
	
	int ancho_pantalla;
	int alto_pantalla;
	int global_resolution=1;
End

#ENDIF