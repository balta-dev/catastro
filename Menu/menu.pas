unit menu;
{$codepage UTF8}

interface

uses crt, 
MMSystem, 
arboles,
archivoTerrenos, 
archivoPropietarios, 
admin,
manipulacionCadenas,
abmc_propietarios,
abmc_terrenos,
box,
selector,
comprobante,
estadisticas,
listado;

procedure principalMenu();

implementation

procedure principalMenu();
var op:string;
musicON:boolean;

begin

musicON := false;
boxDO(13, 92, 4, 29, '*', true);
op := '0';

	repeat

		if (op<>'') then boxDO(13, 92, 4, 29, '*', true);
		gotoxy(18,7);
		writeln('Bienvenid@!');
		gotoxy(25, 10);
		textcolor(white);
		writeln('---- Simulador de Catastro ----');
		gotoxy(57, 10);
		writeln('Opcion: ');
		gotoxy(25, 12);
		writeln('1) ABMC (Alta, Baja, Modificacion y Consulta) de Contribuyentes ');
		gotoxy(25, 14);
		writeln('2) ABMC de Terrenos');
		gotoxy(25, 16);
		writeln('3) Impresión de Comprobante');
		gotoxy(25,18);
		writeln('4) Estadísticas');
		gotoxy(25, 20);
		writeln('5) Listado ordenado por nombre de propiedad');
		gotoxy(25, 22);
		writeln('6) Listado ordenado por zonas (terrenos)');
		gotoxy(25, 24);
		writeln('7) Listado ordenado por fecha de inscripción');
		gotoxy(25, 26);
		writeln('8) Salir');
		gotoxy(65, 10);
		readln(op);

		case op of
		'1': begin mostrarSeleccion(21, 12); clrscr; menuABMCPropietarios; end;
		'2': begin mostrarSeleccion(21, 14); clrscr; menuABMCTerrenos; end;
		'3': begin mostrarSeleccion(21, 16); clrscr; mostrarComprobante; end;
		'4': begin mostrarSeleccion(21, 18); clrscr; menuEstadisticas; end;
		'5': begin mostrarSeleccion(21, 20); clrscr; graficarListado('1'); end;
		'6': begin mostrarSeleccion(21, 22); clrscr; graficarListado('2'); end;
		'7': begin mostrarSeleccion(21, 24); clrscr; graficarListado('3'); end;
		end;

		if lowercase(op) = 'p' then 
		begin
			case musicON of
			true: begin musicON := false; mciSendString('pause "Musica/background.mp3"', nil, 0, 0); end;
			false: begin musicON := true; mciSendString('play "Musica/background.mp3"', nil, 0, 0); end;
			end;
		end;

		if lowercase(op) = 'adminmenu' then
		begin
			menuAdmin;
			clrscr;
		end;

	until op = '8';

	op:='0';

end;

begin
end.