unit comprobante;
{$codepage UTF8}

interface 

uses crt, 
	sysutils, 
	arboles,
	archivoTerrenos,
	archivoPropietarios,
	manipulacionCadenas,
	abmc_terrenos,
	box,
	abmc_propietarios,
	dia;

procedure mostrarComprobante();

implementation

procedure generarBox();
begin

	clrscr;
	boxDO(13, 115, 4, 29, '#', true);
	boxDO(14, 114, 5, 7, '-', false);
	boxDO(14, 114, 7, 28, '-', false);
	boxDO(14, 60, 15, 28, '-', false);
	boxDO(14, 60, 15, 19, '-', false);
	boxDO(14, 60, 15, 24, '-', false);
	boxDO(14, 30, 24, 28, '-', false);

	boxDO(14, 114, 15, 15, '*', true);

	boxDO(30, 30, 25, 27, '|', false);
	boxDo(60, 60, 16, 28, '|', false);

	boxDO(61, 114, 23, 23, '#', false);

end;

procedure informacionEnPantalla(Propietario:tDatoPropietarios; Terreno:tDatoTerrenos; nombre:string);
begin

	gotoxy(17, 6);
	writeln('==== COMPROBANTE DE POSESIÓN ====');
	gotoxy(82, 6);
	writeln('Nro. Contribuyente: ', Propietario.numeroContribuyente);
	gotoxy(17,9);
	writeln('Esta constancia certifica a fecha del día ', diaActual, ',');
	gotoxy(17,11);
	writeln('a el/la Sr./a ', nombre ,' con DNI: ', Propietario.DNI , ' y domicilio ');
	gotoxy(17,13);
	writeln(Propietario.direccion, ', la propiedad del siguiente terreno: ');
	
	gotoxy(17,17);
	write('Nro. Mensura: ');
	textcolor(yellow);
	writeln(Terreno.numeroPlanoMensura);
	textcolor(white);

	gotoxy(17, 21);
	writeln('Domicilio Parcelario: ');
	textcolor(yellow);
	gotoxy(17, 22);
	writeln(Terreno.domicilioParcelario);
	textcolor(white);

	gotoxy(17, 26);
	write('Zona: ');
	textcolor(yellow);
	writeln(Terreno.zona);
	textcolor(white);

	gotoxy(35, 26);
	write('Tipo de Edificacion: ');
	textcolor(yellow);
	writeln(Terreno.tipoEdificacion);
	textcolor(white);

	gotoxy(63, 17);
	write('Fecha de Inscripción: ');
	textcolor(yellow);
	writeln(Terreno.fechaInscripcion);
	textcolor(white);

	gotoxy(63, 19);
	write('Superficie: ');
	textcolor(yellow);
	write(Terreno.superficieTerreno); write(' m^2');
	textcolor(white);

	gotoxy(63, 21);
	write('Avaluo (Pesos):');
	textcolor(yellow);
	write(' $',Terreno.avaluo);
	textcolor(white);

	gotoxy(90, 23);
	textcolor(yellow);
	writeln(' DATOS DE CONTACTO: ');
	textcolor(white);
	gotoxy(63, 25);
	write('E-mail: '); writeln(Propietario.mail);
	gotoxy(63, 26);
	write('Telefono: '); write(Propietario.telefono);
	readkey; 

end;

procedure datosComprobante(var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos; Terreno:tDatoTerrenos);
var nombre:string;
Dato:tPuntero;
Propietario:tDatoPropietarios;
aux:string;
begin

	encontrarPropietario(archivoPropietarios, Terreno.numeroContribuyente, Propietario); 
	nombre := Propietario.apellido + ' ' + Propietario.nombre; 
	fixEntry(nombre); 
	nombre := uppercase(nombre); //busco prop, arreglo formato y lo pongo en mayúsculas

	Dato := recorridoPreorden(raizNOMBRE, nombre);
	if Dato <> nil then
	begin
		cambiarEstado(archivoPropietarios, archivoTerrenos, Dato^.informacion.pos);
		obtenerDatosPropietarios(archivoPropietarios, Dato^.informacion.pos, Propietario);
		generarBox;
		informacionEnPantalla(Propietario, Terreno, nombre);
	end
	else 
	begin
		gotoxy(25, 14);
		writeln('Terreno registrado SIN PROPIETARIO.');
		readkey;
	end;

end;

procedure encontrarPropietarioParticular(var archivoTerrenos:tArchivoTerrenos; var Terreno:tDatoTerrenos; var TerrenoParticular:tDatoTerrenos; numeroPlanoMensura:string; var numeroContribuyente:string);
var i:word;
begin

	if filesize(archivoTerrenos)>0 then begin
		for i:=0 to filesize(archivoTerrenos)-1 do
		begin

			obtenerDatosTerrenos(archivoTerrenos, i, Terreno);
			rellenarCeros(Terreno.numeroPlanoMensura);

			if Terreno.numeroPlanoMensura = numeroPlanoMensura then
			begin

				rellenarCeros(Terreno.numeroContribuyente);
				numeroContribuyente := Terreno.numeroContribuyente;
				TerrenoParticular := Terreno;
			
			end;

		end;

		if filesize(archivoTerrenos)>1 then ordenarArchivoTerrenos(archivoTerrenos);

		
	end;

end;

procedure menuComprobante(var raizNOMBRE:tPuntero; var archivoTerrenos:tArchivoTerrenos; var archivoPropietarios:tArchivoPropietarios);
var numeroPlanoMensura, numeroContribuyente:string;
i:word;
Terreno, TerrenoParticular:tDatoTerrenos;
begin

	numeroContribuyente := '';
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Impresión Comprobante ----');
	gotoxy(25, 12);
	write('Ingrese Número de Mensura: ');
	readln(numeroPlanoMensura);

	if numeroPlanoMensura <> '' then rellenarCeros(numeroPlanoMensura);
	encontrarPropietarioParticular(archivoTerrenos, Terreno, TerrenoParticular, numeroPlanoMensura, numeroContribuyente);

	if (numeroPlanoMensura <> '') then
	begin

		if (numeroContribuyente = '') then 
		begin
			gotoxy(25, 14);
			writeln('Número de Mensura NO ENCONTRADO.');
			readkey;
		end
		else datosComprobante(raizNOMBRE, archivoPropietarios, archivoTerrenos, TerrenoParticular);
		

	end;

	clrscr;		

end;

procedure mostrarComprobante();
var raizDNI, raizNOMBRE:tPuntero;
archivoTerrenos:tArchivoTerrenos;
archivoPropietarios:tArchivoPropietarios;
begin

raizDNI := nil;
raizNOMBRE := nil;

	if raizDNI = nil then crearArbol(raizDNI);
	if raizNOMBRE = nil then crearArbol(raizNOMBRE);

    abrirArchivoTerrenos(archivoTerrenos, 'terrenos.dat');
	abrirArchivoPropietarios(archivoPropietarios);

	generarArbol(raizDNI, raizNOMBRE, archivoPropietarios);

	menuComprobante(raizNOMBRE, archivoTerrenos, archivoPropietarios);

	cerrarArchivoTerrenos(archivoTerrenos);
	cerrarArchivoPropietarios(archivoPropietarios);

end;

begin
end.