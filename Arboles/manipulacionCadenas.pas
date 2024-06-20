unit manipulacionCadenas;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses crt, keyboard, strutils;

procedure fixEntry(var cadena:string);
function esDNI(var cadena:string):boolean;
function validarFecha(fecha:string):boolean;
function esNumero(cadena:string):boolean;
procedure rellenarCeros(var dato:string);
procedure reestructurarFecha(var fecha:string);
procedure reestructurarFechaAOriginal(var fecha:string);

implementation

procedure fixEntry(var cadena:string);
var position:integer;
begin
	
	while pos(' ', cadena) <> 0 do
	begin 
	position := pos(' ', cadena);
	delete(cadena, position, 1);

	end;

	cadena := lowercase(cadena);

end;

function esDNI(var cadena:string):boolean;
var codigo1, codigo2, codigo3, DNI:integer;
begin

	DNI:=0;
	DNI:=DNI; //para quitar advertencia compilador

	esDNI := false;

	if length(cadena) = 7 then insert('0', cadena, 1);

	if (length(cadena) = 8) then
	begin
		val(cadena, DNI, codigo1);
		if codigo1 = 0 then
			begin
				insert('.', cadena, 3);
				insert('.', cadena, 7);
			end;
	end;

	if length(cadena) = 9 then insert('0', cadena, 1);

	if (copy(cadena, 3, 1) = '.') and (copy(cadena, 7, 1) = '.') and (length(cadena) = 10) then
	
	begin
	val(copy(cadena, 1, 2), DNI, codigo1);//continuar / arreglar}
	val(copy(cadena, 4, 2), DNI, codigo2);
	val(copy(cadena, 8, 2), DNI, codigo3);
	end;

	if (codigo1 = 0) and (codigo2 = 0) and (codigo3 = 0) then esDNI := true else fixEntry(cadena);


end;

function validarFecha(fecha:string):boolean;
var codigoD, codigoM, codigoA, dd, mm, aaaa, maxDay:integer;
begin
	validarFecha := false;
	maxDay := 0;

	if (copy(fecha, 3, 1) = '/') and (copy(fecha, 6, 1) = '/') and (length(fecha)=10) then
	begin
		
		val(copy(fecha, 0, 2), dd, codigoD);
		val(copy(fecha, 4, 2), mm, codigoM);
		val(copy(fecha, 7, 10), aaaa, codigoA);

		if (codigoD=0) and (codigoM=0) and (codigoA=0) then
		begin
			
			case mm of
			01: maxDay := 31;
			02: if (aaaa mod 4 = 0) and ((aaaa mod 100 <> 0) or (aaaa mod 400 = 0)) then maxDay := 29 else maxDay := 28;
			03: maxDay := 31;
			04: maxDay := 30;
			05: maxDay := 31;
			06: maxDay := 30;
			07: maxDay := 31;
			08: maxDay := 31;
			09: maxDay := 30;
			10: maxDay := 31;
			11: maxDay := 30;
			12: maxDay := 31;
			end;

			if (maxDay > 0) and (maxDay >= dd) and (aaaa > 0) and (dd > 0) then		//que tenga dia máximo asignado, dd esté dentro de los valores, sea año mayor que 0 (porque no existe) y el dia no sea negativo
			begin
				validarFecha := true;

					if (aaaa = 1582) and (mm=10) and (dd > 4) and (dd < 15) then validarFecha := false;		//no existen dias entre el 4 y el 15 de octubre de 1582
			end;

		end;
	end;

end;

function esNumero(cadena:string):boolean;
var numero:byte;
aux:integer;
begin

	aux:=0;
	aux:=aux; //quita advertencia de compilador

	val(copy(cadena, 1, length(cadena)), aux, numero);
	if numero = 0 then esNumero := true;

	if aux<1 then esNumero := false; //para evitar números negativos. en este proyecto no se necesitan números negativos.

end;

procedure rellenarCeros(var dato:string);
begin

		while length(dato)<10 do dato:=addchar('0',dato, 10);

end;

procedure reestructurarFecha(var fecha:string);
var dia, mes, anio: string;
begin

	// 02/02/1992
	anio := copy(fecha, 7, 4); // año
	mes := copy(fecha, 4, 2); 
	dia := copy(fecha, 1, 2);

	fecha := anio + '/' + mes + '/' + dia;

end;

procedure reestructurarFechaAOriginal(var fecha:string);
var dia, mes, anio: string;
begin

	// 02/02/1992

	// 1992/02/02


	dia := copy(fecha, 9, 2); // año
	mes := copy(fecha, 6, 2); 
	anio := copy(fecha, 1, 4);

	fecha := dia + '/' + mes + '/' + anio;

end;

begin
end.