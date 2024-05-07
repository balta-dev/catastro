unit abmc_terrenos;
{$codepage UTF8}

interface

uses 
	archivoPropietarios in '../../Propietarios/archivoPropietarios.pas',
	archivoTerrenos in '../../Terrenos/archivoTerrenos.pas',
	arboles in '../../Arboles/arboles.pas',
	manipulacionCadenas in '../../Arboles/manipulacionCadenas.pas',
	sysutils,
	easter,
	crt,
	math,
	strutils,
	abmc_propietarios,
	selector,
	box;

//procedure asignarPorcentajes(X:tDatoTerrenos; var porcentajeZona:extended; var porcentajeTipoEdificacion:extended);
//function calculoAvaluo(X:tDatoTerrenos):extended;
//function colisionDomicilioParcelario(var archivoTerrenos:tArchivoTerrenos; domicilioParcelario:string; Posicion:word):boolean;
//function colisionPlanoMensura(var archivoTerrenos:tArchivoTerrenos; numeroPlanoMensura:string; Posicion:word):boolean;
//procedure tablaTipoEdificacion();
//procedure tablaZona();
//procedure leerDatosTerreno(var archivoTerrenos:tArchivoTerrenos; var X:tDatoTerrenos);
procedure encontrarPropietario(var archivoPropietarios:tArchivoPropietarios; numeroContribuyente:string; var Propietario:tDatoPropietarios); //usado en comprobante
//procedure consultaTerrenos(var archivoPropietarios:tArchivoPropietarios; X:tDatoTerrenos);
//procedure menuConsultaTerrenos(var archivoTerrenos:tArchivoTerrenos; var archivoPropietarios:tArchivoPropietarios);
//procedure cambiarOwner(var archivoPropietarios:tArchivoPropietarios; numeroContribuyente:string; var Terreno:tDatoTerrenos);
//procedure modificacionTerrenos(var archivoTerrenos:tArchivoTerrenos; var X:tDatoTerrenos; var archivoPropietarios:tArchivoPropietarios);
//procedure menuModificacionTerrenos(var archivoTerrenos:tArchivoTerrenos; var archivoPropietarios:tArchivoPropietarios);
//procedure bajaTerrenos(var archivoTerrenos:tArchivoTerrenos; var archivoPropietarios:tArchivoPropietarios);
//procedure altaTerrenosConPropietario(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
//procedure altaTerrenosSinPropietario(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
//procedure menuAltaTerrenos(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
procedure menuABMCTerrenos();



implementation

procedure asignarPorcentajes(X:tDatoTerrenos; var porcentajeZona:extended; var porcentajeTipoEdificacion:extended);
begin

	case X.zona of
	'1': porcentajeZona := 1.5;
	'2': porcentajeZona := 1.1;
	'3': porcentajeZona := 0.7;
	'4': porcentajeZona := 0.4;
	'5': porcentajeZona := 0.1;
	end;

	case X.tipoEdificacion of
	'1': porcentajeTipoEdificacion := 1.7;
	'2': porcentajeTipoEdificacion := 1.3;
	'3': porcentajeTipoEdificacion := 1.1;
	'4': porcentajeTipoEdificacion := 0.8;
	'5': porcentajeTipoEdificacion := 0.5;
	end;


end;

function calculoAvaluo(X:tDatoTerrenos):extended;
var calculoBasicoM2, porcentajeZona, porcentajeTipoEdificacion, basicoXSuperficie:extended;
begin

	calculoBasicoM2 := 12308.60;
	asignarPorcentajes(X, porcentajeZona, porcentajeTipoEdificacion);

	basicoXSuperficie := calculoBasicoM2 * StrToInt(X.superficieTerreno);	
	porcentajeZona := (basicoXSuperficie * porcentajeZona / 100);
	porcentajeTipoEdificacion := (basicoXSuperficie * porcentajeTipoEdificacion / 100);

	calculoAvaluo := basicoXSuperficie + porcentajeZona + porcentajeTipoEdificacion;

end;

function colisionDomicilioParcelario(var archivoTerrenos:tArchivoTerrenos; domicilioParcelario:string; Posicion:word):boolean;
var Terreno:tDatoTerrenos;
i:word;
begin

	colisionDomicilioParcelario := false;

	if filesize(archivoTerrenos)>0 then
	begin
		for i:=0 to filesize(archivoTerrenos)-1 do
		begin
	
			obtenerDatosTerrenos(archivoTerrenos, i, Terreno);

			if (Terreno.domicilioParcelario = domicilioParcelario) and (Posicion <> i) then

			begin
				colisionDomicilioParcelario := true;
			end;

	
		end;
	end;


end;

function colisionPlanoMensura(var archivoTerrenos:tArchivoTerrenos; numeroPlanoMensura:string; Posicion:word):boolean;
var Terreno:tDatoTerrenos;
i:word;
begin

	colisionPlanoMensura := false;
	rellenarCeros(numeroPlanoMensura);

	if filesize(archivoTerrenos)>0 then
	begin
		for i:=0 to filesize(archivoTerrenos)-1 do
		begin
	
			obtenerDatosTerrenos(archivoTerrenos, i, Terreno);

			if (Terreno.numeroPlanoMensura = numeroPlanoMensura) and (Posicion <> i) then

			begin
				colisionPlanoMensura := true;
			end;

	
		end;
	end;


end;

procedure tablaTipoEdificacion();
begin

	gotoxy(70, 23);
	writeln('Categoría 1: 1,7%');
	gotoxy(70, 24);
	writeln('Categoría 2: 1,3%');
	gotoxy(70, 25);
	writeln('Categoría 3: 1,1%');
	gotoxy(70, 26);
	writeln('Categoría 4: 0,7%');
	gotoxy(70, 27);
	writeln('Categoría 5: 0,5%');

end;

procedure tablaZona();
begin

	gotoxy(25, 23);
	writeln('Zona 1: 1,5%');
	gotoxy(25, 24);
	writeln('Zona 2: 1,1%');
	gotoxy(25, 25);
	writeln('Zona 3: 0,7%');
	gotoxy(25, 26);
	writeln('Zona 4: 0,4%');
	gotoxy(25, 27);
	writeln('Zona 5: 0,1%');

end;

procedure casoTipoEdificacion(var tipoEdificacion:string);
begin

	while (tipoEdificacion <> '1') and (tipoEdificacion <> '2') and (tipoEdificacion <> '3') and (tipoEdificacion <> '4') and (tipoEdificacion <> '5') do
	begin

		tablaTipoEdificacion;
		gotoxy(25, 17);
		write('El Tipo de Edificación se seleccionan entre 1 y 5. Intente nuevamente: ');
		readln(tipoEdificacion);

	end;

end;

procedure casoZona(var zona:string);
begin

	while (zona <> '1') and (zona <> '2') and (zona <> '3') and (zona <> '4') and (zona <> '5') do
	begin

		tablaZona;
		gotoxy(25, 16);
		write('Las Zonas se seleccionan entre 1 y 5. Intente nuevamente: ');
		readln(zona);

	end;

end;

procedure casoSuperficieTerreno(var superficieTerreno:string);
begin

	while (length(superficieTerreno)<1) or (not esNumero(superficieTerreno)) do
	begin

		gotoxy(25, 15);
		write('La superficie de terreno debe ser un número válido. Ingrese nuevamente: ');	
		readln(superficieTerreno);

	end;

end;

procedure casoDomicilioParcelario(var archivoTerrenos:tArchivoTerrenos; var domicilioParcelario:string);
begin

	while (length(domicilioParcelario)<1) or (colisionDomicilioParcelario(archivoTerrenos, domicilioParcelario, filesize(archivoTerrenos))) do
	begin

		gotoxy(25, 14);
		write('El Domicilio Parcelario ya está registrado. Ingrese nuevamente: ');	
		readln(domicilioParcelario);

	end;

end;

procedure casoNumeroMensura(var archivoTerrenos:tArchivoTerrenos; var numeroMensura:string);
begin

	while (not (esNumero(numeroMensura))) or (length(numeroMensura)<1) or (colisionPlanoMensura(archivoTerrenos, numeroMensura, filesize(archivoTerrenos))) or (numeroMensura='0') do
	begin

		gotoxy(25, 12);
		write('El Nro. de Mensura no es válido o está registrado. Intente nuevamente: ');
		readln(numeroMensura);

	end;

	rellenarCeros(numeroMensura);

end;

procedure leerDatosTerreno(var archivoTerrenos:tArchivoTerrenos; var X:tDatoTerrenos);
begin

	//clrscr;
	//gotoxy(25, 10);
	//writeln('---- Alta Terrenos ----');
	//boxDO(13, 119, 4, 29, '*', true);
	gotoxy(25, 12);
	write('Número de Mensura: ');
	readln(X.numeroPlanoMensura);
	casoNumeroMensura(archivoTerrenos, X.numeroPlanoMensura);

	gotoxy(25, 13);
	write('Fecha de Inscripción (DD/MM/AAAA): ');
	readln(X.fechaInscripcion);
	casoFecha(X.fechaInscripcion, 13);

	gotoxy(25, 14);
	write('Domicilio Parcelario: ');
	readln(X.domicilioParcelario);
	casoDomicilioParcelario(archivoTerrenos, X.domicilioParcelario);

	gotoxy(25, 15);
	write('Superficie de Terreno (M^2): ');
	readln(X.superficieTerreno);
	casoSuperficieTerreno(X.superficieTerreno);

	gotoxy(25, 16);
	write('Zona (1-5): ');
	readln(X.zona);
	casoZona(X.zona);

	gotoxy(25, 17);
	write('Tipo de Edificación (Categoría 1-5): ');
	readln(X.tipoEdificacion);
	casoTipoEdificacion(X.tipoEdificacion);

	gotoxy(25, 18);
	writeln('Avaluo: $', floatToStr(calculoAvaluo(X)));
	X.avaluo := floatToStr(calculoAvaluo(X));


end;

procedure encontrarPropietario(var archivoPropietarios:tArchivoPropietarios; numeroContribuyente:string; var Propietario:tDatoPropietarios);
var auxiliar:tDatoPropietarios;
i:word;
begin

	FillChar(Propietario, SizeOf(Propietario), 0);

	if filesize(archivoPropietarios)>0 then
	begin

		for i:=0 to filesize(archivoPropietarios)-1 do
		begin
		obtenerDatosPropietarios(archivoPropietarios, i, auxiliar);
		rellenarCeros(auxiliar.numeroContribuyente);

			if auxiliar.numeroContribuyente = numeroContribuyente then
			begin
				Propietario := auxiliar;
			end;

		end;

	end;

	if Propietario.apellido = '' then begin Propietario.apellido := 'Terreno'; Propietario.nombre := 'Municipal'; end;

end;

procedure consultaTerrenos(var archivoPropietarios:tArchivoPropietarios; X:tDatoTerrenos);
var Propietario:tDatoPropietarios;
begin

	encontrarPropietario(archivoPropietarios, X.numeroContribuyente, Propietario);

	clrscr;
	boxDO(13, 119, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Consulta Terrenos ----');
	gotoxy(25, 14);
	writeln('Número de Mensura: ', X.numeroPlanoMensura);
	gotoxy(25, 15);
	writeln('Fecha de Inscripción: ', X.fechaInscripcion); eb2c(X.fechaInscripcion);
	gotoxy(25, 16);
	writeln('Domicilio Parcelario: ', X.domicilioParcelario);
	ewm(X.domicilioParcelario);
	gotoxy(25, 17);
	writeln('Superficie de Terreno: ', X.superficieTerreno);
	gotoxy(25, 18);
	writeln('Zona: ', X.zona);
	gotoxy(25, 19);
	writeln('Tipo de Edificación: ', X.tipoEdificacion);
	gotoxy(25, 20);
	writeln('Avaluo: $', X.avaluo);
	gotoxy(25, 12);
	writeln('Dueño: ', Propietario.apellido + ' ' + Propietario.nombre);
	readkey;

end;

procedure menuConsultaTerrenos(var archivoTerrenos:tArchivoTerrenos; var archivoPropietarios:tArchivoPropietarios);
var numeroPlanoMensura, numeroContribuyente:string;
i:word;
Terreno, TerrenoParticular:tDatoTerrenos;
begin

	numeroContribuyente := '';
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Consulta Terrenos ----');
	gotoxy(25, 12);
	write('Ingrese Número de Mensura: ');
	readln(numeroPlanoMensura);

	if numeroPlanoMensura <> '' then rellenarCeros(numeroPlanoMensura);

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

	if filesize(archivoTerrenos)>0 then ordenarArchivoTerrenos(archivoTerrenos);

	end;

	if (numeroPlanoMensura <> '') then
	begin

		if (numeroContribuyente = '') then 
		begin
			gotoxy(25, 14);
			writeln('Número de Mensura NO ENCONTRADO.');
			readkey;
		end
		else consultaTerrenos(archivoPropietarios, TerrenoParticular);
		

	end;

	//contarCantidadTerrenos(archivoPropietarios, archivoTerrenos, numeroContribuyente, i);  //no interesa i
	clrscr;		

end;

procedure cambiarOwner(var archivoPropietarios:tArchivoPropietarios; numeroContribuyente:string; var Terreno:tDatoTerrenos);
var Propietario:tDatoPropietarios;
PropietarioParticular:tDatoPropietarios;
ok:char;
i:word;
begin

rellenarCeros(numeroContribuyente);

	if filesize(archivoPropietarios)>0 then
	begin

		for i:=0 to filesize(archivoPropietarios)-1 do
		begin
		obtenerDatosPropietarios(archivoPropietarios, i, Propietario);
		rellenarCeros(Propietario.numeroContribuyente);

			if Propietario.numeroContribuyente = numeroContribuyente then
			begin

				//Terreno.numeroContribuyente := numeroContribuyente;
				PropietarioParticular := Propietario;

			end;

		end;

	end;

	gotoxy(25, 14);
	writeln('Apellido y Nombre: ', PropietarioParticular.apellido + ' ' + PropietarioParticular.nombre);
	gotoxy(25, 15);
	writeln('DNI: ', PropietarioParticular.DNI);
	gotoxy(25, 20);
	write('Desea continuar? S/N: ');
	readln(ok);

	if (ok='s') or (ok='S') then Terreno.numeroContribuyente := numeroContribuyente;


end;

procedure modificacionTerrenos(var archivoTerrenos:tArchivoTerrenos; var X:tDatoTerrenos; var archivoPropietarios:tArchivoPropietarios);
var op, ingresado:string;
Propietario:tDatoPropietarios;
begin

	encontrarPropietario(archivoPropietarios, X.numeroContribuyente, Propietario);

	clrscr;
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Modificación Terrenos ----');
	gotoxy(25, 14);
	writeln('1) Número de Mensura (actual: ', X.numeroPlanoMensura ,')');
	gotoxy(25, 15);
	writeln('2) Fecha de Inscripción (actual: ', X.fechaInscripcion ,')');
	gotoxy(25, 16);
	writeln('3) Domicilio Parcelario (actual: ', X.domicilioParcelario ,')');
	gotoxy(25, 17);
	writeln('4) Superficie de Terreno (actual: ', X.superficieTerreno ,')');
	gotoxy(25, 18);
	writeln('5) Zona (actual: ', X.zona ,')');
	gotoxy(25, 19);
	writeln('6) Tipo de Edificación (actual: ', X.tipoEdificacion ,')');
	gotoxy(25, 20);
	writeln('7) Dueño (actual: ', Propietario.apellido + ' ' + Propietario.nombre, ')');
	gotoxy(25, 22);
	writeln('0) Modificación Masiva');

	gotoxy(25, 12);
	write('Seleccione dato a modificar: ');
	readln(op);

	if op='0' then 
	begin 
		clrscr;

		gotoxy(25, 10);
		writeln('---- Modificación Masiva Terrenos ----');

		boxDO(13, 119, 4, 29, '*', true);
		gotoxy(20,12); ClrEol;
		gotoxy(20,13); ClrEol;
		boxDO(92, 92, 5, 28, ' ', false);
		boxDO(119, 119, 4, 29, '*', true); //lo restaura

		leerDatosTerreno(archivoTerrenos, X); 

	end;

	if (op<>'') then
	begin

		clrscr;
		boxDO(13, 92, 4, 29, '*', true);
		gotoxy(25, 10);
		writeln('---- Modificación Terrenos ----');

		gotoxy(25,12);

		case op of
		'1': write('Número de Mensura nuevo: ');
		'2': write('Fecha de Inscripción nueva: ');
		'3': write('Domicilio Parcelario nuevo: ');
		'4': write('Superficie de Terreno nueva: ');
		'5': write('Zona nueva: ');
		'6': write('Tipo de Edificación nuevo: ');
		'7': write('Nuevo dueño (Número de Contribuyente): ');
		end;

		readln(ingresado);

		if ingresado<>'' then
		begin

			case op of
			'1': casoNumeroMensura(archivoTerrenos, ingresado);
			'2': casoFecha(ingresado, 12);
			'3': casoDomicilioParcelario(archivoTerrenos, ingresado);
			'4': casoSuperficieTerreno(ingresado);
			'5': casoZona(ingresado);
			'6': casoTipoEdificacion(ingresado);
			'7': cambiarOwner(archivoPropietarios, ingresado, X);
			end;

			case op of
			'1': X.numeroPlanoMensura := ingresado;
			'2': X.fechaInscripcion := ingresado;
			'3': X.domicilioParcelario := ingresado;
			'4': X.superficieTerreno := ingresado;
			'5': X.zona := ingresado;
			'6': X.tipoEdificacion := ingresado;
			end;

			if (op='4') or (op='5') or (op='6') then X.avaluo := floatToStr(calculoAvaluo(X)); //es necesario recalcular avaluo si se cambian datos

		end;

	end; 

end; 

procedure menuModificacionTerrenos(var archivoTerrenos:tArchivoTerrenos; var archivoPropietarios:tArchivoPropietarios);
var numeroPlanoMensura, numeroContribuyente:string;
i, Posicion:word;
Terreno, TerrenoParticular:tDatoTerrenos;
begin

	numeroContribuyente := '';
	Posicion := 0;
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Modificación Terrenos ----');
	gotoxy(25, 12);
	write('Ingrese Número de Mensura: ');
	readln(numeroPlanoMensura);

	if numeroPlanoMensura <> '' then rellenarCeros(numeroPlanoMensura);

	if filesize(archivoTerrenos)>0 then begin
	for i:=0 to filesize(archivoTerrenos)-1 do
	begin

		obtenerDatosTerrenos(archivoTerrenos, i, Terreno);
		rellenarCeros(Terreno.numeroPlanoMensura);

		if Terreno.numeroPlanoMensura = numeroPlanoMensura then
		begin

			rellenarCeros(Terreno.numeroContribuyente);
			numeroContribuyente := Terreno.numeroContribuyente;  //encuentro numero contribuyente con el nro plano mensura
			TerrenoParticular := Terreno;
			
			Posicion := i;

		end;

	end;

	if filesize(archivoTerrenos)>0 then ordenarArchivoTerrenos(archivoTerrenos);

	end;

	if (numeroPlanoMensura <> '') then
	begin

		if (numeroContribuyente = '') then 
		begin
			gotoxy(25, 14);
			writeln('Número de Mensura NO ENCONTRADO.');
			readkey;
		end
		else
		begin
			modificacionTerrenos(archivoTerrenos, TerrenoParticular, archivoPropietarios);
			ingresarTerrenos(archivoTerrenos, TerrenoParticular, Posicion);
		end;

	end;

	//contarCantidadTerrenos(archivoPropietarios, archivoTerrenos, numeroContribuyente, i);
	clrscr;		

end;

procedure bajaTerrenos(var archivoTerrenos:tArchivoTerrenos; var archivoPropietarios:tArchivoPropietarios);
var numeroPlanoMensura, numeroContribuyente:string;
i, Posicion:word;
Terreno:tDatoTerrenos;
Propietario:tDatoPropietarios;
PropietarioParticular:tDatoPropietarios;
ok:char;

begin

	numeroContribuyente := '';
	Posicion := 0;
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Baja Terrenos ----');
	gotoxy(25, 12);
	write('Ingrese Número de Mensura: ');
	readln(numeroPlanoMensura);

	if numeroPlanoMensura <> '' then rellenarCeros(numeroPlanoMensura);  //

	if filesize(archivoTerrenos)>0 then begin
	for i:=0 to filesize(archivoTerrenos)-1 do
	begin

		obtenerDatosTerrenos(archivoTerrenos, i, Terreno);
		rellenarCeros(Terreno.numeroPlanoMensura);
		if Terreno.numeroPlanoMensura = numeroPlanoMensura then
		begin

			Posicion := i;
			numeroContribuyente := Terreno.numeroContribuyente;
			rellenarCeros(numeroContribuyente);

		end;

	end;
	end;

	FillChar(PropietarioParticular, SizeOf(PropietarioParticular), 0);

	if filesize(archivoPropietarios)>0 then
	begin

		for i:=0 to filesize(archivoPropietarios)-1 do
		begin
		obtenerDatosPropietarios(archivoPropietarios, i, Propietario);
		rellenarCeros(Propietario.numeroContribuyente);

			if Propietario.numeroContribuyente = numeroContribuyente then
			begin

				PropietarioParticular := Propietario;

			end;

		end;

	end;

	if (numeroPlanoMensura <> '') then
	begin

		if (numeroContribuyente = '') then 
		begin
			gotoxy(25, 14);
			writeln('Número de Mensura NO ENCONTRADO.');
			readkey;
		end
		else
		begin
			
			if PropietarioParticular.apellido <> '' then
			begin
				gotoxy(25, 14);
				writeln('Apellido y Nombre: ', PropietarioParticular.apellido + ' ' + PropietarioParticular.nombre);
				gotoxy(25, 15);
				writeln('DNI: ', PropietarioParticular.DNI);
			end
			else
			begin
				gotoxy(25, 14);
				textcolor(red);
				writeln('Terreno registrado bajo Propiedad Estatal!');
				textcolor(white);

			end;

			gotoxy(25, 20);
			write('¿Seguro/a que desea eliminarlo? S/N: ');
			readln(ok);

			if (ok='s') or (ok='S') then  
				begin

					bajarTerreno(archivoTerrenos, Posicion);
					
					gotoxy(25, 14); ClrEol; boxDO(92, 92, 14, 14, '*', true);
					gotoxy(25, 20); ClrEol; boxDO(92, 92, 20, 20, '*', true);
					gotoxy(25, 14);
					
					writeln('Terreno dado de baja!');
					readkey;
					if filesize(archivoTerrenos)>1 then ordenarArchivoTerrenos(archivoTerrenos);
					
				end;

		end;

	end;

	clrscr;												

end;

procedure altaTerrenosConPropietario(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var Terreno:tDatoTerrenos;
Propietario:tDatoPropietarios;
ok: char;
Respuesta, aux:string;
Dato:tPuntero;
posBlank: integer;

begin // arranca el begin

	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Alta Terrenos ----');
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
			
			if Dato=Nil then begin writeln('Propietario NO EXISTENTE.'); readkey; end;

			if filesize(archivoPropietarios)>0 then
			begin

				obtenerDatosPropietarios(archivoPropietarios, Dato^.informacion.pos, Propietario);
				
				gotoxy(25, 10);
				writeln('---- Alta Terrenos ----');

				boxDO(13, 119, 4, 29, '*', true);
				gotoxy(20,12); ClrEol;
				gotoxy(20,13); ClrEol;
				boxDO(92, 92, 5, 28, ' ', false);
				boxDO(119, 119, 4, 29, '*', true); //lo restaura


				leerDatosTerreno(archivoTerrenos, Terreno);

				gotoxy(25, 20);
				write('Desea continuar? S/N: ');
				readln(ok);

				if (ok='s') or (ok='S') then  
				begin

					Terreno.numeroContribuyente := Propietario.numeroContribuyente;
					Propietario.estado := true;

					ingresarTerrenos(archivoTerrenos, Terreno, filesize(archivoTerrenos));
					
					seek(archivoPropietarios, Dato^.informacion.pos);
					write(archivoPropietarios, Propietario);

					if filesize(archivoTerrenos)>1 then 
					ordenarArchivoTerrenos(archivoTerrenos);

					gotoxy(25, 20);
					writeln('Terreno ingresado satisfactoriamente!');
					readkey;

				end;

			end
			else 
			begin

				writeln('No hay NINGÚN Propietario registrado en el sistema.');
				readkey;

			end;

	clrscr;

	end;




end;	// termina el begin

procedure altaTerrenosSinPropietario(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var Terreno:tDatoTerrenos;
ok: char;
begin

	boxDO(13, 119, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Alta Terrenos ----');
	leerDatosTerreno(archivoTerrenos, Terreno);

	Terreno.numeroContribuyente := '0000000000';

	gotoxy(25, 20);
	write('Desea continuar? S/N: ');
	readln(ok);

	if (ok='s') or (ok='S') then  
	begin

		ingresarTerrenos(archivoTerrenos, Terreno, filesize(archivoTerrenos));

		if filesize(archivoTerrenos)>1 then 
		ordenarArchivoTerrenos(archivoTerrenos);

		gotoxy(25, 20);
		writeln('Terreno ingresado satisfactoriamente!');
	    ee(Terreno.fechaInscripcion); ee(Terreno.domicilioParcelario);
		clrscr;

	end;


end;


procedure menuAltaTerrenos(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios; var archivoTerrenos:tArchivoTerrenos);
var op:string;
begin

repeat

	clrscr;
	boxDO(13, 92, 4, 29, '*', true);
	gotoxy(25, 10);
	writeln('---- Alta Terrenos ----');
	gotoxy(57, 10);
	writeln('Opcion: ');
	gotoxy(25, 12);
	writeln('1) Alta de Terreno asignando Propietario');
	gotoxy(25, 14);
	writeln('2) Alta de Terreno SIN asignar Propietario');
	gotoxy(65, 10);
	readln(op);
   	//clrscr;

   	case op of
   	'1': begin mostrarSeleccion(21, 12); clrscr; altaTerrenosConPropietario(raizDNI, raizNOMBRE, archivoPropietarios, archivoTerrenos); end;
   	'2': begin mostrarSeleccion(21, 14); clrscr; altaTerrenosSinPropietario(raizDNI, raizNOMBRE, archivoPropietarios, archivoTerrenos); end;
   	end;

until op='';

clrscr;

end;


procedure menuABMCTerrenos();
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
	writeln('---- ABMC Terrenos ----');
	gotoxy(57, 10);
	writeln('Opcion: ');
	gotoxy(25, 12);
	writeln('1) Alta de Terrenos');
	gotoxy(25, 14);
	writeln('2) Baja de Terrenos');
	gotoxy(25, 16);
	writeln('3) Modificación de Terrenos');
	gotoxy(25,18);
	writeln('4) Consulta de Terrenos');
	gotoxy(25, 20);
	writeln('5) Salir');
	gotoxy(65, 10);
	readln(op);

	case op of
	'1': begin mostrarSeleccion(21, 12); clrscr; menuAltaTerrenos(raizDNI, raizNOMBRE, archivoPropietarios, archivoTerrenos); end;
	'2': begin mostrarSeleccion(21, 14); clrscr; bajaTerrenos(archivoTerrenos, archivoPropietarios); end;
	'3': begin mostrarSeleccion(21, 16); clrscr; menuModificacionTerrenos(archivoTerrenos, archivoPropietarios); end; 
	'4': begin mostrarSeleccion(21, 18); clrscr; menuConsultaTerrenos(archivoTerrenos, archivoPropietarios); end;
	end; 

	cerrarArchivoTerrenos(archivoTerrenos);
	cerrarArchivoPropietarios(archivoPropietarios);

until op = '5';

clrscr;

end;

begin
end.