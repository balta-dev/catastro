unit estadisticas;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses manipulacionCadenas in '../Arboles/manipulacionCadenas.pas',
	selector in '../Menu/selector.pas',
	crt,
	box in '../Visuales/box.pas',
	arboles in '../Arboles/arboles.pas',
	abmc_propietarios in '../Propietarios/ABMC/ABMC_Propietarios.pas',
	abmc_terrenos in '../Terrenos/ABMC/ABMC_Terrenos.pas',
	archivoTerrenos in '../Terrenos/archivoTerrenos.pas',
	archivoPropietarios in '../Propietarios/archivoPropietarios.pas';

type tArrayMaxPropietarios = array[1..500] of string;

//procedure estadisticasPropietarios(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; var cantidad:word; var propietariosMasUnoTerrenos:word; var dadosDeBaja:word; var arrayPropietarios:tArrayMaxPropietarios);
//procedure contarTotalTerrenos(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; var totalTerrenosArchivo:word; arrayPropietarios:tArrayMaxPropietarios);
procedure devolverArrayPropietarios(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; var arrayPropietarios:tArrayMaxPropietarios);
procedure menuEstadisticas();

implementation


procedure quitarRepetidos(var arr:tArrayMaxPropietarios);
var i,j, cont, posRepetido:word;
begin

	i:=1;
	
	repeat
		cont:=0;
		j:=1;
		posRepetido:=0;

		repeat

			if (arr[i] = arr[j]) then begin cont+=1;
			if (cont>1) then posRepetido:=j; end;
			
			j+=1;
		
		until j=length(arr);

		if posRepetido<>0 then begin 
		arr[i] := arr[posRepetido]; 
		arr[posRepetido] := ''; 
		end;

		i+=1;

		//if i=length(arr) then j:=length(arr);
	
	until i=length(arr);
	
	//DEBE SER INDEPENDIENTE DEL PROCESO
	//size := 0;
	//for i:=1 to length(arr) do if arr[i]<>'' then size+=1;
	

end;

{procedure contarTotalTerrenos(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; var totalTerrenosArchivo:word; arrayPropietarios:tArrayMaxPropietarios);
var cantidadTerrenos, i:word;
Propietario:tDatoPropietarios;
begin

totalTerrenosArchivo:=0;

	for i:=1 to length(arrayPropietarios) do
	begin

		if arrayPropietarios[i]<>'' then
		begin
		encontrarPropietario(archivoPropietarios, arrayPropietarios[i], Propietario);
		contarCantidadTerrenos(archivoPropietarios, archivoTerrenos, arrayPropietarios[i], cantidadTerrenos);
		totalTerrenosArchivo := totalTerrenosArchivo + cantidadTerrenos;
		end;

	end;

end; }

procedure devolverArrayPropietarios(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; var arrayPropietarios:tArrayMaxPropietarios);
var i, cantidad:word;
Propietario:tDatoPropietarios;
begin

	clrscr;
	cantidad := 0;
	if filesize(archivoPropietarios)>0 then
	begin

		for i:=0 to filesize(archivoPropietarios)-1 do
		begin
		
			obtenerDatosPropietarios(archivoPropietarios, i, Propietario);
			cantidad += 1;
			if (length(Propietario.numeroContribuyente)=10) and (Propietario.numeroContribuyente <> '0000000000') then 
			begin 
				cambiarEstado(archivoPropietarios, archivoTerrenos, i); 
				arrayPropietarios[cantidad] := Propietario.numeroContribuyente;
			end;

		end;
	end;

	for i:=0 to cantidad do
	quitarRepetidos(arrayPropietarios);

end;

procedure contarPropietarios(arrayPropietarios:tArrayMaxPropietarios; var totalPropietarios:word);
var i:word;
begin

    totalPropietarios := 0;
    for i:=1 to length(arrayPropietarios) do
    begin
     if (arrayPropietarios[i]<>'') and (length(arrayPropietarios[i])=10) then begin totalPropietarios+=1; end;
    end;

end;
//sirve para devolver algún dato particular. previamente habian 2 variables que siempre eran devueltas. si bien es mas complicado leerlo, da más facilidades de mantenimiento.
procedure retornoDatoPropietarios(opcion:byte; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; arrayPropietarios:tArrayMaxPropietarios; var ret:word);
var i, cantidadContada, cantidadTerrenos:word;
begin

	contarPropietarios(arrayPropietarios, cantidadContada);

	for i:=1 to cantidadContada do
	begin

		if arrayPropietarios[i]<>'' then
		begin

			contarCantidadTerrenos(archivoPropietarios, archivoTerrenos, arrayPropietarios[i], cantidadTerrenos);			

			case opcion of
			1: if cantidadTerrenos>1 then ret += 1; //propietarios que tienen mas de 1 terreno
			2: if cantidadTerrenos=0 then ret += 1; //propietarios dados de baja
			else ret := 0;
			end;

		end;
	
	end;

end;

//debe reducirse el alcance del procedimiento
{procedure estadisticasPropietarios(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; var cantidad:word; var propietariosMasUnoTerrenos:word; var dadosDeBaja:word; var arrayPropietarios:tArrayMaxPropietarios);
var i, cantidadTerrenos, cantidadContada:word;
Propietario:tDatoPropietarios;
begin

	devolverArrayPropietarios(archivoPropietarios, archivoTerrenos, arrayPropietarios);

	cantidadContada := 0;
	for i:=1 to length(arrayPropietarios) do if arrayPropietarios[i]<>'' then cantidadContada+=1;

	propietariosMasUnoTerrenos := 0; cantidad := 0; dadosDeBaja := 0;

	for i:=1 to cantidadContada do
	begin

		if arrayPropietarios[i]<>'' then
		begin
			//writeln(arrayPropietarios[i]);
			cantidad += 1;
			contarCantidadTerrenos(archivoPropietarios, archivoTerrenos, arrayPropietarios[i], cantidadTerrenos);
			if cantidadTerrenos>1 then propietariosMasUnoTerrenos += 1;
			if cantidadTerrenos=0 then dadosDeBaja += 1;

		end;
	
	end;

end; }

procedure porcentajePropietariosTipoEdificacion(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var i, j:word;
Terreno:tDatoTerrenos;
arrayPropietarios:tArrayMaxPropietarios;
tipo1, tipo2, tipo3, tipo4, tipo5, total:word;

begin

	tipo1 := 0; tipo2 := 0; tipo3 := 0; tipo4 := 0; tipo5 := 0;
	//estadisticasPropietarios(archivoPropietarios, archivoTerrenos, totalPropietarios, propietariosMasUnoTerrenos, dadosDeBaja, arrayPropietarios);
	devolverArrayPropietarios(archivoPropietarios, archivoTerrenos, arrayPropietarios);

	//tercera variante, debe tener de salida totalTerrenosArchivo y arrayPropietarios
	//contarTotalTerrenos(archivoPropietarios, archivoTerrenos, totalTerrenosArchivo, arrayPropietarios);
	//no debería retornar arrayPropietarios

	
	for i:=0 to length(arrayPropietarios) do
	begin

	if filesize(archivoTerrenos)>0 then
	begin
			for j:=0 to filesize(archivoTerrenos)-1 do
			begin
	
				obtenerDatosTerrenos(archivoTerrenos, j, Terreno);
				//writeln(Terreno.numeroContribuyente);

				if (Terreno.numeroContribuyente = arrayPropietarios[i]) and (Terreno.numeroContribuyente<>'0000000000') then

				begin
						case Terreno.tipoEdificacion of
						'1': tipo1 += 1;
						'2': tipo2 += 1;
						'3': tipo3 += 1;
						'4': tipo4 += 1;
						'5': tipo5 += 1;
						end;
				end;

	
			end;
	end;
	end;

	total:= tipo1 + tipo2 + tipo3 + tipo4 + tipo5;

	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Porcentaje de Propietarios por tipo de edificación ----');
	gotoxy(25, 12);
	textcolor(yellow); write('* Total de Terrenos (con propietarios): ', total); textcolor(white);
	
	if total <> 0 then
	begin
		gotoxy(25, 14);
		write('* Tipo de Edificacion 1:  '); textcolor(yellow); write(tipo1/total*100:3:2, '%'); textcolor(white); write('    (', tipo1, ')'); 
		gotoxy(25, 15);
		write('* Tipo de Edificacion 2:  '); textcolor(yellow); write(tipo2/total*100:3:2, '%'); textcolor(white); write('    (', tipo2, ')'); 
		gotoxy(25, 16);
		write('* Tipo de Edificacion 3:  '); textcolor(yellow); write(tipo3/total*100:3:2, '%'); textcolor(white); write('    (', tipo3, ')'); 
		gotoxy(25, 17);
		write('* Tipo de Edificacion 4:  '); textcolor(yellow); write(tipo4/total*100:3:2, '%'); textcolor(white); write('    (', tipo4, ')'); 
		gotoxy(25, 18); 
		write('* Tipo de Edificacion 5:  '); textcolor(yellow); write(tipo5/total*100:3:2, '%'); textcolor(white); write('    (', tipo5, ')'); 
	end;

	readkey;


end;


procedure porcentajePropietariosPropiedades(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var totalPropietarios, ret:word;
arrayPropietarios:tArrayMaxPropietarios;
begin

	//estadisticasPropietarios(archivoPropietarios, archivoTerrenos, totalPropietarios, propietariosMasUnoTerrenos, dadosDeBaja, arrayPropietarios);
	//primer variante, debe tener salida solamente de totalPropietarios y propietariosMasUnoTerrenos

	devolverArrayPropietarios(archivoPropietarios, archivoTerrenos, arrayPropietarios);
	ret := 0;
	retornoDatoPropietarios(1, archivoPropietarios, archivoTerrenos, arrayPropietarios, ret); //opcion 1 = ret := propietariosMasUnoTerrenos
	contarPropietarios(arrayPropietarios, totalPropietarios);

	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Porcentaje de Propietarios con más de una Propiedad ----');
	gotoxy(25, 12);
	write('* Total de Propietarios: ');
	writeln(totalPropietarios);
	gotoxy(25, 14);
	write('* Propietarios con más de una propiedad: ');
	writeln(ret);
	
	if totalPropietarios <> 0 then
	begin
		textcolor(yellow);
		gotoxy(25, 16);
		writeln('* Porcentaje: ', ret/totalPropietarios*100:3:2, '%');
		textcolor(white);
	end;

	readkey;

end;

procedure terrenosEntreFechas(fechaBusquedaInscripcionInicial:string; fechaBusquedaInscripcionFinal:string; Terreno:tDatoTerrenos; var cantidadTerrenos:word);
begin

	if (fechaBusquedaInscripcionInicial <= Terreno.fechaInscripcion) and (fechaBusquedaInscripcionFinal >= Terreno.fechaInscripcion) and (Terreno.numeroContribuyente <> '0000000000') then		//La fecha que le meto a la funcion deberia ser mayor o igual a LA DEL ARCHIVO TERRENOS
	cantidadTerrenos += 1;

end;

procedure cambiarFechaAAAAMMDD(var archivoTerrenos:tArchivoTerrenos; fechaBusquedaInscripcionInicial:string; fechaBusquedaInscripcionFinal:string; var Terreno:tDatoTerrenos; var cantidadTerrenos:word);
var i:word;
begin

	if filesize(archivoTerrenos)>0 then 
	begin

		for i:=0 to filesize(archivoTerrenos)-1 do
		begin

		obtenerDatosTerrenos(archivoTerrenos, i, Terreno);
		reestructurarFecha(Terreno.fechaInscripcion);
		rellenarCeros(Terreno.numeroContribuyente);
		terrenosEntreFechas(fechaBusquedaInscripcionInicial, fechaBusquedaInscripcionFinal, Terreno, cantidadTerrenos);

		end;

	end;

end;

procedure cambiarFechaDDMMAAAA(var archivoTerrenos:tArchivoTerrenos; var Terreno:tDatoTerrenos);
var i:word;
begin

	if filesize(archivoTerrenos)>0 then 
	begin

		for i:=0 to filesize(archivoTerrenos)-1 do
		begin

			obtenerDatosTerrenos(archivoTerrenos, i, Terreno);
			reestructurarFechaAOriginal(Terreno.fechaInscripcion);

		end;

		if filesize(archivoTerrenos)>1 then ordenarArchivoTerrenos(archivoTerrenos);


	end;

end;

procedure cantidadInscripciones(var archivoTerrenos:tArchivoTerrenos; var archivoPropietarios:tArchivoPropietarios);
var fechaBusquedaInscripcionInicial, fechaBusquedaInscripcionFinal:string;
Terreno:tDatoTerrenos;
cantidadTerrenos:word;
begin

	clrscr;
	boxDO(13, 119, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Cantidad de Inscripciones entre dos fechas ----');
	gotoxy(25, 12);
	write('Ingrese fecha inicial (DD/MM/AAAA): ');
	readln(fechaBusquedaInscripcionInicial);
	casoFecha(fechaBusquedaInscripcionInicial, 12);
	reestructurarFecha(fechaBusquedaInscripcionInicial);

	writeln; writeln;

	gotoxy(25, 13);
	write('Ingrese fecha final (DD/MM/AAAA): ');
	readln(fechaBusquedaInscripcionFinal);
	casoFecha(fechaBusquedaInscripcionFinal, 13);
	reestructurarFecha(fechaBusquedaInscripcionFinal);

	cantidadTerrenos := 0;

/////////////////		ACOMODAR A (AAAA/MM/DD)		//////////////////////////

	cambiarFechaAAAAMMDD(archivoTerrenos, fechaBusquedaInscripcionInicial, fechaBusquedaInscripcionFinal, Terreno, cantidadTerrenos); //cambio la estructura de las fechas del archivo.

//////////////////////////		ACOMODAR A (DD/MM/AAAA)			///////////////////////////////

	cambiarFechaDDMMAAAA(archivoTerrenos, Terreno); //retorno al original. probablemente ordenar archivo no vaya acá, sino que arriba (porque acá ya no es AAAAMMDD)
	
/////////////////////////////////////////////////////////////////////////////////////////////////

	clrscr;	
	reestructurarFechaAOriginal(fechaBusquedaInscripcionInicial);
	reestructurarFechaAOriginal(fechaBusquedaInscripcionFinal);

	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Cantidad de Inscripciones entre dos fechas ----');
	gotoxy(25, 11);
	textcolor(yellow);
	writeln('     (      ',fechaBusquedaInscripcionInicial, ' y ', fechaBusquedaInscripcionFinal, '     )');
	textcolor(white);
	gotoxy(25, 14);
	writeln('* Cantidad de terrenos: ' , cantidadTerrenos);
	readkey;


end;

procedure cantidadPropietariosBaja(var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var totalPropietarios, ret:word;
arrayPropietarios:tArrayMaxPropietarios;

begin

	clrscr;
	devolverArrayPropietarios(archivoPropietarios, archivoTerrenos, arrayPropietarios);
	ret := 0;
	retornoDatoPropietarios(2, archivoPropietarios, archivoTerrenos, arrayPropietarios, ret); //opcion 2 = ret := dadosDeBaja
	contarPropietarios(arrayPropietarios, totalPropietarios);

	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('----  Cantidad de Propietarios dados de baja ----');
	gotoxy(25, 12);
	write('* Total de Propietarios: ');
	writeln(totalPropietarios);
	gotoxy(25, 14);
	write('* Propietarios dados de baja: ');
	writeln(ret);
	readkey;

end;

procedure menuEstadisticas();
var op:string;
archivoTerrenos:tArchivoTerrenos;
archivoPropietarios:tArchivoPropietarios;
begin

op := '0';

	repeat

   	 	abrirArchivoTerrenos(archivoTerrenos, 'terrenos.dat');
		abrirArchivoPropietarios(archivoPropietarios);

		if (op<>'') then boxDO(13, 92, 4, 29, '*', true);

		gotoxy(25, 10);
		writeln('---- Estadisticas ----');
		gotoxy(57, 10);
		writeln('Opcion: ');
		gotoxy(25, 12);
		writeln('1) Cantidad de Inscripciones entre dos fechas');
		gotoxy(25, 14);
		writeln('2) Porcentaje de Propietarios con más de una Propiedad');
		gotoxy(25, 16);
		writeln('3) Porcentaje de Propietarios por tipo de edificación');
		gotoxy(25,18);
		writeln('4) Cantidad de Propietarios dados de baja');
		gotoxy(25, 20);
		writeln('5) Salir');
		gotoxy(65, 10);
		readln(op);

		case op of
		'1': begin mostrarSeleccion(21, 12); cantidadInscripciones(archivoTerrenos, archivoPropietarios); clrscr; end;
		'2': begin mostrarSeleccion(21, 14); porcentajePropietariosPropiedades(archivoPropietarios, archivoTerrenos); clrscr; end;
		'3': begin mostrarSeleccion(21, 16); porcentajePropietariosTipoEdificacion(archivoPropietarios, archivoTerrenos); clrscr; end;
		'4': begin mostrarSeleccion(21, 18); cantidadPropietariosBaja(archivoPropietarios, archivoTerrenos); clrscr; end;
		end;

		cerrarArchivoTerrenos(archivoTerrenos);
		cerrarArchivoPropietarios(archivoPropietarios);	


	until op='5';

op:='0';
clrscr;
	
end;

begin
end.