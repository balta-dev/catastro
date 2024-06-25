unit abmc_propietarios;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses

	crt, 
	sysutils, 
	arboles,
	archivoTerrenos,
	archivoPropietarios,
	manipulacionCadenas,
	box,
	selector;

procedure contarCantidadTerrenos(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; numeroContribuyente:string; var cantidadTerrenos:word); //usado en estadisticas
//procedure leerDatosPropietario(var X:tDatoPropietarios; Dato:string; var archivoPropietarios:tArchivoPropietarios);
//procedure consultaContribuyente(var Dato:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
//procedure modificacionPropietarios(var Dato:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
//procedure bajaPropietarios(var Dato:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
//procedure altaPropietarios(var Dato:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; Respuesta:string);
procedure cambiarEstado(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; Posicion:word);
procedure casoFecha(var ingresado:string; y:integer);
procedure menuABMCPropietarios();


implementation

function colisionNumeroContribuyente(var archivoPropietarios:tArchivoPropietarios; numeroContribuyente:string; Posicion:word):boolean;
var Propietario:tDatoPropietarios;
i:word;
begin

	colisionNumeroContribuyente := false;
	rellenarCeros(numeroContribuyente);

	if filesize(archivoPropietarios)>0 then
	begin
		for i:=0 to filesize(archivoPropietarios)-1 do
		begin
	
			obtenerDatosPropietarios(archivoPropietarios, i, Propietario);

			if (Propietario.numeroContribuyente = numeroContribuyente) and (Posicion <> i) then

			begin
				colisionNumeroContribuyente := true;
			end;

	
		end;
	end;

end;

function colisionDNI(var archivoPropietarios:tArchivoPropietarios; DNI:string; Posicion:word):boolean;
var Propietario:tDatoPropietarios;
i:word;
begin

	colisionDNI := false;

	if filesize(archivoPropietarios)>0 then
	begin
		for i:=0 to filesize(archivoPropietarios)-1 do
		begin
	
			obtenerDatosPropietarios(archivoPropietarios, i, Propietario);

			EsDNI(DNI);

			if (Propietario.DNI = DNI) and (Posicion <> i) then

			begin
				colisionDNI := true;
			end;

	
		end;
	end;

end;

procedure contarCantidadTerrenos(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; numeroContribuyente:string; var cantidadTerrenos:word);
var i, j:word;
Propietario, PropietarioParticular:tDatoPropietarios;
Terreno:tDatoTerrenos;
begin

	cantidadTerrenos := 0;
	rellenarCeros(numeroContribuyente);

	if filesize(archivoPropietarios)>0 then begin
		for i:=0 to filesize(archivoPropietarios)-1 do
		begin

			obtenerDatosPropietarios(archivoPropietarios, i, Propietario);
			rellenarCeros(Propietario.numeroContribuyente);

			if (numeroContribuyente <> '0') and (Propietario.numeroContribuyente = numeroContribuyente) then
			begin

				PropietarioParticular := Propietario;
			
			end;

		end;
	end;

	if filesize(archivoTerrenos)>0 then
		for j:=0 to filesize(archivoTerrenos)-1 do
		begin

			obtenerDatosTerrenos(archivoTerrenos, j, Terreno);
			rellenarCeros(Terreno.numeroContribuyente);

			if PropietarioParticular.numeroContribuyente = Terreno.numeroContribuyente then
			begin

				cantidadTerrenos += 1;

			end;
	end;

end;


procedure mostrarContribuyente(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; Posicion:word);
var Dato:tDatoPropietarios;
cantidadTerrenos:word;
begin

	obtenerDatosPropietarios(archivoPropietarios, Posicion, Dato);
	contarCantidadTerrenos(archivoPropietarios, archivoTerrenos, Dato.numeroContribuyente, cantidadTerrenos);
	
		clrscr;
		boxDO(13, 92, 4, 29, '*', true);
		gotoxy(25, 10);
		writeln('---- ABMC Propietarios ----');
		gotoxy(25, 12);
		writeln('Número de Contribuyente: ', Dato.numeroContribuyente);
		gotoxy(25, 13);
		write('Apellido/s: ', Dato.apellido);
		gotoxy(25, 14);
		write('Nombre/s: ', Dato.nombre);
		gotoxy(25, 15);
		write('Dirección: ', Dato.direccion);
		gotoxy(25, 16);
		write('Ciudad: ', Dato.ciudad);
		gotoxy(25, 17);
		write('DNI: ', Dato.DNI);
		gotoxy(25, 18);
		write('Fecha de Nacimiento (DD/MM/AAAA): ', Dato.fechaNacimiento);
		gotoxy(25, 19);
		write('Teléfono: ', Dato.telefono);
		gotoxy(25, 20);
		write('Mail: ', Dato.mail);

		if (not Dato.estado) then
		begin 	
				textcolor(yellow);
				gotoxy(25, 21);
				write('Estado Lógico: Dado de baja');
				textcolor(white);
		end
		else if (cantidadTerrenos<>0) and (Dato.estado) then
		begin
				gotoxy(25, 21);
				writeln('Cantidad de Terrenos: ', cantidadTerrenos);
		end
		else writeln('Error: Se detectó un error en el conteo de terrenos');

end;

procedure casoMail(var ingresado:string; y:integer);
begin

	while pos('@', ingresado) = 0 do
	begin
		gotoxy(25, y);
		write('No corresponde a un email. Ingrese nuevamente: ');
		readln(ingresado);
	end;  //del while 9

end;

procedure casoFecha(var ingresado:string; y:integer);
begin

	while not validarFecha(ingresado) do
	begin
		gotoxy(25, y);
		write('No es una fecha válida (DD/MM/AAAA). Ingrese nuevamente: ');
		readln(ingresado);

	end; 

end;

procedure casoDNI(var archivoPropietarios:tArchivoPropietarios; var ingresado:string);
begin

	if not esDNI(ingresado) then
	begin
		
		write('DNI: ');
		readln(ingresado);

			while colisionDNI(archivoPropietarios, ingresado, filesize(archivoPropietarios)) do
			begin

				gotoxy(25, 17);
				write('El DNI ya está registrado. Ingrese nuevamente: ');
				readln(ingresado)

			end;


			while not esDNI(ingresado) do
			begin

				gotoxy(25, 17);
				write('No es un DNI válido. Ingrese nuevamente: ');
				readln(ingresado);

				while colisionDNI(archivoPropietarios, ingresado, filesize(archivoPropietarios)) do
				begin

					gotoxy(25, 17);
					write('El DNI ya está registrado. Ingrese nuevamente: ');
					readln(ingresado)

				end;

				esDNI(ingresado);

			end;


	end;

end;

procedure casoContribuyente(var archivoPropietarios:tArchivoPropietarios; var ingresado:string; var X:tDatoPropietarios; Posicion:word);
var aux, okContribuyente:word;
begin

aux:=0; okContribuyente := 0;
aux:=aux; okContribuyente:=okContribuyente;
rellenarCeros(ingresado);

	val(copy(ingresado, 1, length(ingresado)), aux, okContribuyente);
	while (okContribuyente <> 0) or (ingresado = '0000000000') do
		begin

			gotoxy(25, 12);
			write('El Nro. de contribuyente no es un número. Intente nuevamente: ');
			readln(ingresado);
			rellenarCeros(ingresado);
			val(copy(ingresado, 1, length(ingresado)), aux, okContribuyente);

		end;

		while colisionNumeroContribuyente(archivoPropietarios, ingresado, Posicion) do
		begin

			gotoxy(25, 12);
			write('El Nro. de contribuyente YA EXISTE. Intente nuevamente: ');
			readln(ingresado);
			rellenarCeros(ingresado);

			val(copy(ingresado, 1, length(ingresado)), aux, okContribuyente);

			while okContribuyente <> 0 do
			begin

				gotoxy(25, 12);
				write('El Nro. de contribuyente no es un número. Intente nuevamente: ');
				readln(ingresado);
				rellenarCeros(ingresado);
				val(copy(ingresado, 1, length(ingresado)), aux, okContribuyente);

			end;

		end;

		//rellenarCeros(ingresado);

end;

procedure leerDatosPropietario(var X:tDatoPropietarios; Dato:string; var archivoPropietarios:tArchivoPropietarios);
var y:integer;
begin

	//clrscr;
	//boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 12);
	write('Número de Contribuyente: ');
	readln(X.numeroContribuyente);
	casoContribuyente(archivoPropietarios, X.numeroContribuyente, X, filesize(archivoPropietarios));

	gotoxy(25, 13);
	write('Apellido/s: ');
	readln(X.apellido);
	X.apellido := upcase(X.apellido);

	gotoxy(25, 14);
	write('Nombre/s: ');
	readln(X.nombre);
	X.nombre := upcase(X.nombre);

	gotoxy(25, 15);
	write('Dirección: ');
	readln(X.direccion);

	gotoxy(25, 16);
	write('Ciudad: ');
	readln(X.ciudad);

	gotoxy(25, 17);
	if esDNI(Dato) then X.DNI := Dato else casoDNI(archivoPropietarios, Dato);
	X.DNI := Dato;

	y := whereY;

	gotoxy(25, y);
	write('Fecha de Nacimiento (DD/MM/AAAA): ');
	readln(X.fechaNacimiento);
	casoFecha(X.fechaNacimiento, y);

	gotoxy(25, y+1);
	write('Teléfono: ');
	readln(X.telefono); 

	gotoxy(25, y+2);
	write('Mail: ');
	readln(X.mail);
	casoMail(X.mail, y+2);

	X.estado := false;

end;


procedure consultaContribuyente(var Dato:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var Propietario:tDatoPropietarios;
begin

	clrscr;
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Consulta Propietarios ----');

	if Dato=nil then
	begin
		gotoxy(25, 12);
		writeln('Propietario NO EXISTENTE.');

	end else
	begin

		obtenerDatosPropietarios(archivoPropietarios, Dato^.informacion.pos, Propietario);
		mostrarContribuyente(archivoPropietarios, archivoTerrenos, Dato^.informacion.pos);

	end;

	readkey;
	clrscr;

end;

procedure modificarNumeroContribuyente(var archivoTerrenos:tArchivoTerrenos; var X:tDatoPropietarios; ingresado:string); 
var i:integer;
DatoTerreno:tDatoTerrenos;
begin

	if (X.numeroContribuyente<>ingresado) and (filesize(archivoTerrenos)>0) then
	begin

		i:=0;
		repeat
			obtenerDatosTerrenos(archivoTerrenos, i, DatoTerreno);
			i:=i+1;
		until (X.numeroContribuyente = DatoTerreno.numeroContribuyente) or (i=filesize(archivoTerrenos));

		while i<filesize(archivoTerrenos) do
		begin

			obtenerDatosTerrenos(archivoTerrenos, i, DatoTerreno);
			if DatoTerreno.numeroContribuyente = X.numeroContribuyente then
			begin

				DatoTerreno.numeroContribuyente := ingresado;
				if i<filesize(archivoTerrenos) then
				begin

					ingresarTerrenos(archivoTerrenos, DatoTerreno, i);
					ordenarArchivoTerrenos(archivoTerrenos);

				end;

			end;

			i:=i+1;

		end;


	end;

end;


procedure modificacionDatoParticularPropietarios(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; var X:tDatoPropietarios; Posicion:word; op:string);
var ingresado:string;
begin

if op='0' then
begin

	boxDO(13, 119, 4, 29, '*', true);
	gotoxy(20,12); ClrEol;
	gotoxy(20,13); ClrEol;
	boxDO(92, 92, 5, 28, ' ', false);
	boxDO(119, 119, 4, 29, '*', true); //lo restaura
	gotoxy(25, 10);
	writeln('---- Modificación Propietarios ----');
	leerDatosPropietario(X, X.DNI, archivoPropietarios); 			//modificacion masiva
	seek(archivoPropietarios, Posicion); 
	write(archivoPropietarios, X); 

end;

if (op<>'') and (op<>'0') then
begin

	clrscr;
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Modificación Propietarios ----');

	gotoxy(25,12);

	case op of
	'1': write('Número de Contribuyente nuevo: ');
	'2': write('Apellido/s nuevo/s: ');
	'3': write('Nombre/s nuevo/s: ');
	'4': write('Direccion nueva: ');
	'5': write('Ciudad nueva: ');
	'6': write('DNI nuevo: ');
	'7': write('Fecha de Nacimiento nueva (DD/MM/AAAA): ');
	'8': write('Telefono nuevo: ');
	'9': write('Mail nuevo: ');
	end;

	readln(ingresado);

	while ingresado<>'' do
	begin

		case op of 
		'1': begin casoContribuyente(archivoPropietarios, ingresado, X, Posicion); modificarNumeroContribuyente(archivoTerrenos, X, ingresado); end;
		'2','3': ingresado:=upcase(ingresado); 
		'6': casoDNI(archivoPropietarios, ingresado);
		'7': casoFecha(ingresado, 12);
		'9': casoMail(ingresado, 12);
		end;

		case op of
		'1':X.numeroContribuyente:=ingresado;
   		'2':X.apellido:=ingresado;
    	'3':X.nombre:=ingresado;
    	'4':X.direccion:=ingresado;
    	'5':X.ciudad:=ingresado;
    	'6':X.DNI:=ingresado;
    	'7':X.fechaNacimiento:=ingresado;
    	'8':X.telefono:=ingresado;
    	'9':X.mail:=ingresado;
    	end;

    	seek(archivoPropietarios, Posicion);
    	write(archivoPropietarios, X);

    	ingresado := '';
   
    end;

end;

end;

procedure menuDatosModificacionPropietarios(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; Posicion:word; var X:tDatoPropietarios);
var op:string;

begin

op := ''; //para que quite las advertencias de compilador

repeat

	clrscr;
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Modificación Propietarios ----');
	
	gotoxy(25, 14);
	writeln('1) Número de Contribuyente (actual: ', X.numeroContribuyente ,')');
	gotoxy(25, 15);
	writeln('2) Apellido/s (actual: ', X.apellido ,')');
	gotoxy(25, 16);
	writeln('3) Nombre/s (actual: ', X.nombre ,')');
	gotoxy(25, 17);
	writeln('4) Dirección (actual: ', X.direccion ,')');
	gotoxy(25, 18);
	writeln('5) Ciudad (actual: ', X.ciudad ,')');
	gotoxy(25, 19);
	writeln('6) DNI (actual: ', X.DNI ,')');
	gotoxy(25, 20);
	writeln('7) Fecha de Nacimiento (DD/MM/AAAA) (actual: ', X.fechaNacimiento ,')');
	gotoxy(25, 21);
	writeln('8) Telefono (actual: ', X.telefono ,')');
	gotoxy(25, 22);
	writeln('9) Mail (actual: ', X.mail ,')');
	gotoxy(25, 24);
	writeln('0) Modificación Masiva');

	gotoxy(25, 12);
	write('Seleccione dato a modificar: ');
	readln(op);

	modificacionDatoParticularPropietarios(archivoPropietarios, archivoTerrenos, X, Posicion, op);


until (op = '');

end; 

procedure modificacionPropietarios(var Dato:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var Propietario:tDatoPropietarios;

begin

		if Dato=Nil then
		begin

			clrscr;
			boxDO(13, 92, 4, 29, '*', true);
			gotoxy(25, 10);
			writeln('---- Modificación Propietarios ----');
			gotoxy(25, 12);
			writeln('Propietario NO EXISTENTE.');
			readkey;

		end
		else
		if (filesize(archivoPropietarios) > 0) and (Dato<>nil) then
		begin

			obtenerDatosPropietarios(archivoPropietarios, Dato^.informacion.pos, Propietario);
			menuDatosModificacionPropietarios(archivoPropietarios, archivoTerrenos, Dato^.informacion.pos, Propietario); 		//cargo modificacion de datos

		end;

end;

procedure bajaPropietarios(var Dato:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var i: word;
Terreno:tDatoTerrenos;
Propietario:tDatoPropietarios;
begin
		if Dato<>nil then
		begin 

			if filesize(archivoPropietarios) > 0 then
			begin
		
				bajaLogicaPropietarios(archivoPropietarios, Dato^.informacion.pos);
				obtenerDatosPropietarios(archivoPropietarios, Dato^.informacion.pos, Propietario);
		
				if filesize(archivoTerrenos) > 0 then
				begin
					i:=0;
					while i<filesize(archivoTerrenos) do
					begin
						obtenerDatosTerrenos(archivoTerrenos, i, Terreno);
						
						if Terreno.numeroContribuyente = Propietario.numeroContribuyente then
						begin
							bajarTerreno(archivoTerrenos, i);
							i:=0;
						end
						else i:=i+1;
		
					end;
		
				end;
		
			clrscr;
			boxDO(13, 92, 4, 29, '*', true);
			gotoxy(25, 10);
			writeln('---- Baja Propietarios ----');
			gotoxy(25, 12);
			writeln('¡El propietario ha sido dado de baja satisfactoriamente!');
			readkey;
		
			end;

		end
		else if Dato=Nil then 
		begin
			clrscr;
			gotoxy(25, 10);
			writeln('---- Baja Propietarios ----');
			gotoxy(25, 12);
			writeln('¡El propietario no ha sido encontrado!');
			readkey;

		end;
	//end;

	//clrscr;

end;

procedure confirmacionSubAltaPropietarios(var archivoPropietarios:tArchivoPropietarios; var Propietario:tDatoPropietarios);
var op:char;
begin

	readln(op);
	if (op = 's') or (op = 'S') then
		begin

			guardarDatosPropietarios(archivoPropietarios, Propietario);
			gotoxy(25, 24);
			write('¡Propietario agregado con éxito!');
			readkey;

		end;

end;

procedure subAltaPropietarios(var archivoPropietarios:tArchivoPropietarios; var Propietario:tDatoPropietarios; Respuesta:string);
var op:char;
begin

	readln(op);
	if (op = 's') or (op = 'S') then 
		begin

			gotoxy(25, 10);
			writeln('---- Alta Propietarios ----');

			boxDO(13, 119, 4, 29, '*', true);
			gotoxy(20,12); ClrEol;
			gotoxy(20,13); ClrEol;
			boxDO(92, 92, 5, 28, ' ', false);
			boxDO(119, 119, 4, 29, '*', true); //lo restaura

			leerDatosPropietario(Propietario, Respuesta, archivoPropietarios);
			gotoxy(25, whereY);
			write('¿Los datos son correctos? S/N: ');

			confirmacionSubAltaPropietarios(archivoPropietarios, Propietario);
	end;


end;

procedure altaPropietarios(var Dato:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; Respuesta:string);
var Propietario:tDatoPropietarios;
op:string;
begin
 
	    clrscr;
	    boxDO(13, 92, 4, 29, '*', true);
	    gotoxy(25, 10);
	    writeln('---- Alta Propietarios ----');

		if Dato=nil then 
		begin 	//No existe propietario

			gotoxy(25, 13);
			writeln('(Deberá reescribir nuevamente nombre y apellido)');
			gotoxy(25, 12);
			write('Propietario inexistente. ¿Desea crearlo? S/N: ');
			subAltaPropietarios(archivoPropietarios, Propietario, Respuesta);
			op := '0';

		end
		else
		begin	//Si existe propietario

			obtenerDatosPropietarios(archivoPropietarios, Dato^.informacion.pos, Propietario);
			if Propietario.estado = true then
			begin

				gotoxy(25, 12);
				write('El propietario ya está dado de alta. ¿Desea mostrarlo en pantalla? S/N: ');
				readln(op);
				if (op = 's') or (op = 'S') then mostrarContribuyente(archivoPropietarios, archivoTerrenos, Dato^.informacion.pos);

			end
			else
			begin

				gotoxy(25, 12);
				write('Propietario NO ACTIVO o Dado de Baja.');
				gotoxy(25, 13);
				writeln('(Un propietario necesita un terreno para estar dado de alta)');
				readkey;

			end;

		end; //termina el if recorridoPreorden = nil

end; //termina el programa

procedure cambiarEstado(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; Posicion:word);
var
cantidadTerrenos:word;
Propietario:tDatoPropietarios;
begin

	obtenerDatosPropietarios(archivoPropietarios, Posicion, Propietario);
	contarCantidadTerrenos(archivoPropietarios, archivoTerrenos, Propietario.numeroContribuyente, cantidadTerrenos);
	if cantidadTerrenos<>0 then Propietario.estado := true else Propietario.estado := false;
	seek(archivoPropietarios, Posicion);
	write(archivoPropietarios, Propietario);

end;

procedure busquedaPreordenPropietarios(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; op:string);
var posBlank: integer;
Respuesta, aux:string;
Dato:tPuntero;
begin

	boxDO(13, 92, 4, 29, '*', true);

	gotoxy(25, 10);
	case op of
	'1': writeln('---- Alta Propietarios ----'); 
	'2': writeln('---- Baja Propietarios ----'); 
	'3': writeln('---- Modificación Propietarios ----'); 
	'4': writeln('---- Consulta Propietarios ----');
	end; 

	gotoxy(25, 12);
	writeln('Ingrese DNI o Nombre de Contribuyente: ');
	gotoxy(25, 13);
	writeln('(Con Formato: Apellido Nombre)');
	gotoxy(64, 12);
    readln(Respuesta);

    posBlank := pos(' ', Respuesta); // para evitar entradas vacias

    aux := Respuesta;

    if esDNI(Respuesta)=true then Dato := recorridoPreorden(raizDNI, Respuesta)
    else Dato := recorridoPreorden(raizNOMBRE, aux);

	if (esDNI(Respuesta)=true) or ((posBlank>1) and (posBlank<>length(aux)+1)) then 
	begin

		if Dato<>nil then cambiarEstado(archivoPropietarios, archivoTerrenos, Dato^.informacion.pos);

		case op of
		'1': altaPropietarios(Dato, archivoPropietarios, archivoTerrenos, aux);
		'2': bajaPropietarios(Dato, archivoPropietarios, archivoTerrenos);
		'3': modificacionPropietarios(Dato, archivoPropietarios, archivoTerrenos);
		'4': consultaContribuyente(Dato, archivoPropietarios, archivoTerrenos);
		end;

	end;

	clrscr;

end;

procedure menuABMCPropietarios();
var op:string;
raizDNI, raizNOMBRE:tPuntero;
archivoTerrenos:tArchivoTerrenos;
archivoPropietarios:tArchivoPropietarios;
begin

raizDNI := nil;
raizNOMBRE := nil;

boxDO(13, 92, 4, 29, '*', true);
op := '0';

repeat

	if raizDNI = nil then crearArbol(raizDNI);
	if raizNOMBRE = nil then crearArbol(raizNOMBRE);

    abrirArchivoTerrenos(archivoTerrenos, 'terrenos.dat');
	abrirArchivoPropietarios(archivoPropietarios);

	generarArbol(raizDNI, raizNOMBRE, archivoPropietarios);

	if (op<>'') then boxDO(13, 92, 4, 29, '*', true);

	gotoxy(25, 10);
	textcolor(white);
	writeln('---- ABMC Propietarios ----');
	gotoxy(57, 10);
	writeln('Opcion: ');
	gotoxy(25, 12);
	writeln('1) Alta de Contribuyentes');
	gotoxy(25, 14);
	writeln('2) Baja de Contribuyentes');
	gotoxy(25, 16);
	writeln('3) Modificación de Contribuyentes');
	gotoxy(25,18);
	writeln('4) Consulta de Contribuyentes');
	gotoxy(25, 20);
	writeln('5) Salir');
	gotoxy(65, 10);
	readln(op);

	case op of
	'1': mostrarSeleccion(21, 12);
	'2': mostrarSeleccion(21, 14);
	'3': mostrarSeleccion(21, 16);
	'4': mostrarSeleccion(21, 18);
	end;

	if (op<>'') then clrscr;

	if ((op<>'') and (op<>'5')) and ((op = '1') or (op = '2') or (op = '3') or (op = '4')) then busquedaPreordenPropietarios(raizDNI, raizNOMBRE, archivoPropietarios, archivoTerrenos, op);

	cerrarArchivoTerrenos(archivoTerrenos);
	cerrarArchivoPropietarios(archivoPropietarios);

until op = '5';

op := '0';

end;

begin
end.