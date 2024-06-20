unit listado;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses manipulacionCadenas in '../Arboles/manipulacionCadenas.pas',
	selector in '../Menu/selector.pas',
	crt,
	math,
	keyboard,
	box in '../Visuales/box.pas',
	arboles in '../Arboles/arboles.pas',
	abmc_propietarios in '../Propietarios/ABMC/ABMC_Propietarios.pas',
	abmc_terrenos in '../Terrenos/ABMC/ABMC_Terrenos.pas',
	estadisticas in '../Estadisticas/estadisticas.pas',
	archivoTerrenos in '../Terrenos/archivoTerrenos.pas',
	archivoPropietarios in '../Propietarios/archivoPropietarios.pas';

type tRegistroListado = record
	Propietario:tDatoPropietarios;
	Terreno:tDatoTerrenos;
	end;

	tArrayListado = array[1..1000] of tRegistroListado;


procedure graficarListado(op:string); //usado en menu


implementation


procedure OrdenarPorFecha(var Lista: tArrayListado);
var
  i, j: Integer;
  temp: tRegistroListado;
begin
  for i := 1 to 999 do
  begin
    for j := i + 1 to 1000 do
    begin
      if (Lista[i].Terreno.fechaInscripcion = '') then
      begin
        temp := Lista[i];
        Lista[i] := Lista[j];
        Lista[j] := temp;
      end
      else if (Lista[i].Terreno.fechaInscripcion <> '') and (Lista[j].Terreno.fechaInscripcion <> '') then
      begin
        if Lista[i].Terreno.fechaInscripcion > Lista[j].Terreno.fechaInscripcion then
        begin
          temp := Lista[i];
          Lista[i] := Lista[j];
          Lista[j] := temp;
        end;
      end;
    end;
  end;
end;

procedure OrdenarPorZona(var Lista: tArrayListado);
var
  i, j: Integer;
  temp: tRegistroListado;
begin
  for i := 1 to 999 do
  begin
    for j := i + 1 to 1000 do
    begin
      if (Lista[i].Terreno.zona = '') then
      begin
        temp := Lista[i];
        Lista[i] := Lista[j];
        Lista[j] := temp;
      end
      else if (Lista[i].Terreno.zona <> '') and (Lista[j].Terreno.zona <> '') then
      begin
        if Lista[i].Terreno.zona > Lista[j].Terreno.zona then
        begin
          temp := Lista[i];
          Lista[i] := Lista[j];
          Lista[j] := temp;
        end;
      end;
    end;
  end;
end;

procedure OrdenarPorNombre(var Lista: tArrayListado);
var
  i, j: Integer;
  temp: tRegistroListado;
begin
  for i := 1 to 999 do
  begin
    for j := i + 1 to 1000 do
    begin
      if (Lista[i].Propietario.apellido + Lista[i].Propietario.nombre = '') and (Lista[j].Propietario.apellido + Lista[j].Propietario.nombre <> '') then
      begin
        temp := Lista[i];
        Lista[i] := Lista[j];
        Lista[j] := temp;
      end
      else if (Lista[i].Propietario.apellido + Lista[i].Propietario.nombre <> '') and (Lista[j].Propietario.nombre + Lista[j].Propietario.nombre <> '') then
      begin
        if Lista[i].Propietario.apellido + Lista[i].Propietario.nombre  > Lista[j].Propietario.apellido + Lista[j].Propietario.nombre then
        begin
          temp := Lista[i];
          Lista[i] := Lista[j];
          Lista[j] := temp;
        end;
      end;
    end;
  end;
end;


procedure quitarRepetidosListado(var arr:tArrayListado; var size:word);
var i,j, cont, posRepetido:word;
begin

	i:=1;
	
	repeat
		cont:=0;
		j:=1;
		posRepetido:=0;

		repeat

			if (arr[i].Terreno.numeroPlanoMensura = arr[j].Terreno.numeroPlanoMensura) then begin cont+=1;
			if (cont>1) then posRepetido:=j; end;
			
			j+=1;
		
		until j=length(arr);

		if posRepetido<>0 then begin 
		arr[i].Propietario := arr[posRepetido].Propietario;
		arr[i].Terreno := arr[posRepetido].Terreno; 
		FillChar(arr[posRepetido], SizeOf(arr[posRepetido]), 0);


		end;

		i+=1;
	
	until i=length(arr);

	size := 0;
	for i:=1 to length(arr) do if arr[i].Terreno.numeroPlanoMensura<>'' then size+=1;

end;

procedure borrarLineasInscripciones();
var y, i:integer;
begin
	
	y := 9;

	for i:=1 to 10 do
	begin

		gotoxy(1, y); ClrEol;
		boxDO(13, 13, y, y, '#', true);  boxDO(115, 115, y, y, '#', true);
		boxDO(26, 26, y, y, '|', false);
		boxDO(42, 42, y, y, '|', false);
		boxDO(55, 55, y, y, '|', false);
		boxDO(64, 64, y, y, '|', false);
		boxDO(96, 96, y, y, '|', false);
		boxDO(104, 104, y, y, '|', false);
		y += 2;

	end;

end;

procedure borrarLineasZonas();
var y, i:integer;
begin
	
	y := 9;

	for i:=1 to 10 do
	begin

		gotoxy(1, y); ClrEol;
		boxDO(13, 13, y, y, '#', true);  boxDO(115, 115, y, y, '#', true);
		boxDO(21, 21, y, y, '|', false);
		boxDO(37, 37, y, y, '|', false);
		boxDO(51, 51, y, y, '|', false);
		boxDO(62, 62, y, y, '|', false);
		boxDO(93, 93, y, y, '|', false);
		boxDO(103, 103, y, y, '|', false);
		y += 2;

	end;


end;

procedure borrarLineasPropietarios();
var y, i:integer;
begin
	
	y := 9;

	for i:=1 to 10 do
	begin

		gotoxy(1, y); ClrEol;
		boxDO(13, 13, y, y, '#', true);  boxDO(115, 115, y, y, '#', true);
		boxDO(26, 26, y, y, '|', false);
		boxDO(38, 38, y, y, '|', false);
		boxDO(50, 50, y, y, '|', false);
		boxDO(61, 61, y, y, '|', false);
		boxDO(80, 80, y, y, '|', false);
		boxDO(87, 87, y, y, '|', false);
		boxDO(95, 95, y, y, '|', false);
		boxDO(102, 102, y, y, '|', false);
		y += 2;

	end;


end;

procedure escribirDatosFecha(dato:word; registroListado:tArrayListado; fechaInscripcion:string);
var i, y, cont:word;
begin

	y := 9;
	cont := 0;

	for i:=dato to dato+10 do
	begin

		if copy(registroListado[i].Terreno.fechaInscripcion, 7, 4) = fechaInscripcion then cont += 1;

	end;


	for i:=dato to dato+10 do
	begin

	if copy(registroListado[i].Terreno.fechaInscripcion, 7, 4) = fechaInscripcion then
	begin

		gotoxy(15, y);
		writeln(registroListado[i].Terreno.fechaInscripcion);
		gotoxy(29, y);
		writeln(registroListado[i].Terreno.numeroContribuyente);
		gotoxy(44, y);
		writeln(registroListado[i].Terreno.numeroPlanoMensura);
		gotoxy(59, y);
		writeln(registroListado[i].Terreno.zona);
		gotoxy(66, y);
		writeln(registroListado[i].Terreno.domicilioParcelario);
		gotoxy(99, y);
		writeln(registroListado[i].Terreno.superficieTerreno);
		gotoxy(110, y);
		writeln(registroListado[i].Terreno.tipoEdificacion);
		y := y+2;

	end
	else if cont=0 then begin 


	gotoxy(40, 15);
	writeln('NO SE ENCONTRARON RESULTADOS PARA ESTA');
	gotoxy(55, 16);
	writeln('BÚSQUEDA');

	end;

	end;

end;

procedure escribirDatosZona(dato:word; registroListado:tArrayListado);
var i, y:word;
begin

	y := 9;

	for i:=dato to dato+10 do
	begin

		gotoxy(17, y);
		writeln(registroListado[i].Terreno.zona);
		gotoxy(24, y);
		writeln(registroListado[i].Terreno.numeroContribuyente);
		gotoxy(40, y);
		writeln(registroListado[i].Terreno.numeroPlanoMensura);
		gotoxy(52, y);
		writeln(registroListado[i].Terreno.fechaInscripcion);
		gotoxy(64, y);
		writeln(registroListado[i].Terreno.domicilioParcelario);
		gotoxy(96, y);
		writeln(registroListado[i].Terreno.superficieTerreno);
		gotoxy(108, y);
		writeln(registroListado[i].Terreno.tipoEdificacion);
		y := y+2;
	
	end;

end;


procedure escribirDatosPropietarios(dato:word; registroListado:tArrayListado);
var i, y:word;
begin

	y := 9;

	for i:=dato to dato+8 do
	begin

		gotoxy(15, y);
		if registroListado[i].Propietario.apellido <> '' then write(copy(registroListado[i].Propietario.apellido, 1, 5) + '. ' + copy(registroListado[i].Propietario.nombre, 1, 3) + '.');
		gotoxy(27, y);
		writeln(registroListado[i].Terreno.numeroContribuyente);
		gotoxy(39, y);
		writeln(registroListado[i].Terreno.numeroPlanoMensura);
		gotoxy(51, y);
		writeln(registroListado[i].Terreno.fechaInscripcion);
		gotoxy(63, y);
		if registroListado[i].Terreno.domicilioParcelario <> '' then write(copy(registroListado[i].Terreno.domicilioParcelario, 1, 15) + '. ');
		gotoxy(82, y);
		writeln(registroListado[i].Terreno.superficieTerreno);
		gotoxy(91, y);
		writeln(registroListado[i].Terreno.zona);
		gotoxy(98, y);
		writeln(registroListado[i].Terreno.tipoEdificacion);
		gotoxy(103, y);
		writeln(registroListado[i].Terreno.avaluo);
		y := y+2;
	
	end;

end;

procedure sistemaPaginas(var registroListado:tArrayListado; var actual:word; fechaInscripcion:string; var cantidadPaginas:word; op:string);
var dato:word;
K: TKeyEvent;
begin

	dato := 1;

	actual := 1;

	gotoxy(1,1);
	writeln('Presiona ESC para salir!');

	case op of
	'1': escribirDatosPropietarios(dato, registroListado);
	'2': escribirDatosZona(dato, registroListado);
	'3': escribirDatosFecha(dato, registroListado, fechaInscripcion);
	end;

	gotoxy(1, 29);
	writeln('Utiliza la flecha "<-" para bajar de página o "->" para subir de página.');
	gotoxy(1, 28);
	textcolor(yellow);
	writeln('Pag ',actual,'/',cantidadPaginas);
	textcolor(white);

	InitKeyboard;

	Repeat
    K:= GetKeyEvent;
    K:= TranslateKeyEvent(K);
     
    case TKeyRecord(K).KeyCode of
    65315: 
    	begin 

    		ClrEol;
    		if actual = 1 then writeln('No se puede mover mas a la izquierda!') else 
    		begin
    			actual -= 1;
    			dato := dato-8;
    			//borrarLineas;

    			case op of
				'1': begin borrarLineasPropietarios; escribirDatosPropietarios(dato, registroListado); end;
				'2': begin borrarLineasZonas; escribirDatosZona(dato, registroListado); end;
				'3': begin borrarLineasInscripciones; escribirDatosFecha(dato, registroListado, fechaInscripcion); end;
				end;
			
			end;

    	end;
    65317: 
    	begin 

    		ClrEol;
    		if actual = cantidadPaginas then writeln('No se puede mover mas a la derecha!') else 
    		begin
    			actual +=1;
    			dato := dato+8;
		
    			case op of
				'1': begin borrarLineasPropietarios; escribirDatosPropietarios(dato, registroListado); end;
				'2': begin borrarLineasZonas; escribirDatosZona(dato, registroListado); end;
				'3': begin borrarLineasInscripciones; escribirDatosFecha(dato, registroListado, fechaInscripcion); end;
				end;
			end;

    	end;

    
    end;
   
  gotoxy(1, 28);
	textcolor(yellow);
	writeln('Pag ',actual,'/',cantidadPaginas);
	textcolor(white);

   Until TKeyRecord(K).KeyCode = 283;
   DoneKeyboard;
   clrscr;

end;

procedure ponerDDMMAAAA(var registroListado:tArrayListado);
var i:word;
begin

	for i:=1 to length(registroListado) do 
	begin 
	if registroListado[i].Terreno.fechaInscripcion <> '' then begin reestructurarFechaAOriginal(registroListado[i].Terreno.fechaInscripcion); end;
	end;


end;

procedure ponerAAAAMMDD(var registroListado:tArrayListado);
var i:word;
begin

	for i:=1 to length(registroListado) do 
	begin 
	if registroListado[i].Terreno.fechaInscripcion <> '' then begin reestructurarFecha(registroListado[i].Terreno.fechaInscripcion); end;
	end;


end;


procedure datosListado(var registroListado:tArrayListado; var datosTotales:word; var actual:word; var cantidadPaginas:word; op:string);
var i:word;

contarNoVacios:word;
begin

	contarNoVacios := 0; actual := 1;

	quitarRepetidosListado(registroListado, datosTotales);
	
	case op of
	'1':OrdenarPorNombre(registroListado);
	'2':OrdenarPorZona(registroListado);
	'3':begin ponerAAAAMMDD(registroListado); OrdenarPorFecha(registroListado); ponerDDMMAAAA(registroListado); end;
	end;
	
	for i:=1 to datosTotales do begin if registroListado[i].Propietario.apellido <> '' then contarNoVacios += 1; end;
	datosTotales := contarNoVacios;

	if datosTotales>0 then cantidadPaginas := ceil(datosTotales / 9) else cantidadPaginas := 1;


end;


procedure capturarDatos(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; var registroListado:tArrayListado);
var cantidadPropietarios, cantidadTerrenos, i, J:word;
arrayPropietarios:tArrayMaxPropietarios;
Propietario:tDatoPropietarios;
Terreno:tDatoTerrenos;
datosTotales:word;

begin

	devolverArrayPropietarios(archivoPropietarios, archivoTerrenos, arrayPropietarios);
	datosTotales := 0;

	FillChar(registroListado, SizeOf(registroListado), 0);

	for i:=1 to length(arrayPropietarios) do
	begin

		encontrarPropietario(archivoPropietarios, arrayPropietarios[i], Propietario);
		contarCantidadTerrenos(archivoPropietarios, archivoTerrenos, arrayPropietarios[i], cantidadTerrenos);

		///////////////// BÚSQUEDA DE TODOS LOS TERRENOS////////////////////////////


		if filesize(archivoTerrenos)>0 then
		for j:=0 to filesize(archivoTerrenos)-1 do
		begin

			obtenerDatosTerrenos(archivoTerrenos, j, Terreno);
			rellenarCeros(Terreno.numeroContribuyente);

			if (Propietario.numeroContribuyente = Terreno.numeroContribuyente) then
			begin

				datosTotales += 1;
				registroListado[datosTotales].Propietario := Propietario;
				registroListado[datosTotales].Terreno := Terreno;

			end;

		end;

	end;

	for i:=1 to datosTotales do quitarRepetidosListado(registroListado, cantidadPropietarios); //cantidadPropietarios solamente en otro procedimiento (acá no) para los datos a mostrar

end;

procedure crearBoxInscripciones();
begin

	boxDO(13, 115, 4, 28, '#', true);
	boxDO(14, 114, 5, 5, '-', false);
	boxDO(14, 114, 7, 7, '-', false);

	boxDO(26, 26, 6, 27, '|', false);
	boxDO(42, 42, 6, 27, '|', false);
	boxDO(55, 55, 6, 27, '|', false);
	boxDO(64, 64, 6, 27, '|', false);
	boxDO(96, 96, 6, 27, '|', false);
	boxDO(104, 104, 6, 27, '|', false);

//"LISTADO ORDENADO POR INSCRIPCIONES EN UN DETERMINADO AÑO"	

	gotoxy(17, 6);
	writeln('Fecha');
	gotoxy(29, 6);
	writeln('Nro. Contr.');
	gotoxy(45, 6);
	writeln('Mensura');
	gotoxy(58, 6);
	writeln('Zona');
	gotoxy(72, 6);
	writeln('Dom. Parcelario');
	gotoxy(99, 6);
	writeln('M^2');
	gotoxy(106, 6);
	writeln('T. Edif');

end;

procedure crearBoxZonas();
begin

	boxDO(13, 115, 4, 28, '#', true);
	boxDO(14, 114, 5, 5, '-', false);
	boxDO(14, 114, 7, 7, '-', false);

	boxDO(21, 21, 6, 27, '|', false);
	boxDO(37, 37, 6, 27, '|', false);
	boxDO(51, 51, 6, 27, '|', false);
	boxDO(62, 62, 6, 27, '|', false);
	boxDO(93, 93, 6, 27, '|', false);
	boxDO(103, 103, 6, 27, '|', false);
	

//"LISTADO ORDENADO POR ZONAS DE TODOS LOS TERRENOS"	

	gotoxy(16, 6);
	writeln('Zona');
	gotoxy(24, 6);
	writeln('Nro. Contr.');
	gotoxy(41, 6);
	writeln('Mensura');
	gotoxy(54, 6);
	writeln('Fecha');
	gotoxy(70, 6);
	writeln('Dom. Parcelario');
	gotoxy(97, 6);
	writeln('M^2');
	gotoxy(106, 6);
	writeln('T. Edif');

end;

procedure crearBoxPropiedades();
begin

	boxDO(13, 115, 4, 28, '#', true);
	boxDO(14, 114, 5, 5, '-', false);
	//boxDO(14, 114, 28, 28, '-', false);
	boxDO(14, 114, 7, 7, '-', false);
	
	boxDO(26, 26, 6, 27, '|', false);
	boxDO(38, 38, 6, 27, '|', false);
	boxDO(50, 50, 6, 27, '|', false);
	boxDO(61, 61, 6, 27, '|', false);
	boxDO(80, 80, 6, 27, '|', false);
	boxDO(87, 87, 6, 27, '|', false);
	boxDO(95, 95, 6, 27, '|', false);
	boxDO(102, 102, 6, 27, '|', false);

//"LISTADO ORDENADO POR NOMBRE DE PROPIEDADES VALORIZADAS"

	gotoxy(18, 6);
	writeln('Dueño');
	gotoxy(29, 6);
	writeln('Nro. C.');
	gotoxy(41, 6);
	writeln('Mensura');
	gotoxy(53, 6);
	writeln('Fecha');
	gotoxy(63, 6);
	writeln('Dom. Parcelario');
	gotoxy(82, 6);
	writeln('M^2');
	gotoxy(89, 6);
	writeln('Zona');
	gotoxy(97, 6);
	writeln('T.Ed');
	gotoxy(104, 6);
	writeln('Avaluo ($)');

end;


procedure submenuInscripciones(registroListado:tArrayListado);
var fechaInscripcion:string;
actual, cantidadPaginas, datosTotales:word;
begin

	boxDO(13, 115, 4, 28, '#', true);

	gotoxy(25, 10);
	writeln('---- Listado ordenado por inscripciones en un determinado año ----');
	gotoxy(25, 12);
	write('Ingrese año de inscripción (Ejemplo: 2001): ');
	readln(fechaInscripcion);
	clrscr;
	if fechaInscripcion <> '' then
	begin
	crearBoxInscripciones; 
	datosListado(registroListado, datosTotales, actual, cantidadPaginas, '3'); 
	sistemaPaginas(registroListado, actual, fechaInscripcion, cantidadPaginas, '3');
	end;

end;

procedure graficarListado(op:string);
var archivoTerrenos:tArchivoTerrenos;
archivoPropietarios:tArchivoPropietarios;
datosTotales, cantidadPaginas, actual:word;
registroListado:tArrayListado;
fechaInscripcion:string;
begin

	fechaInscripcion := '';
	abrirArchivoTerrenos(archivoTerrenos, 'terrenos.dat');
	abrirArchivoPropietarios(archivoPropietarios);

	capturarDatos(archivoPropietarios, archivoTerrenos, registroListado);

	case op of
	'1': begin crearBoxPropiedades; datosListado(registroListado, datosTotales, actual, cantidadPaginas, '1'); sistemaPaginas(registroListado, actual, fechaInscripcion, cantidadPaginas, '1'); end;
	'2': begin crearBoxZonas; datosListado(registroListado, datosTotales, actual, cantidadPaginas, '2'); sistemaPaginas(registroListado, actual, fechaInscripcion, cantidadPaginas, '2'); end;
	'3': submenuInscripciones(registroListado);
	end; 

	cerrarArchivoTerrenos(archivoTerrenos);
	cerrarArchivoPropietarios(archivoPropietarios);	


end;

begin
end.