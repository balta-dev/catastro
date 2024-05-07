unit dia;
{$codepage UTF8}

interface
uses sysutils, dos;
function diaActual():string;

implementation

procedure asignarDia(dia:string; var dsemana:string);
var a,b,c,d:word;
begin

	getDate(a, b, c, d);

	case d of
	0: dsemana := 'Domingo';
	1: dsemana := 'Lunes';
	2: dsemana := 'Martes';
	3: dsemana := 'Miércoles';
	4: dsemana := 'Jueves';
	5: dsemana := 'Viernes';
	6: dsemana := 'Sábado';
	end;

end;

procedure asignarMes(var mes:string);
begin

	case mes of
	'01': mes := 'Enero';
	'02': mes := 'Febrero';
	'03': mes := 'Marzo';
	'04': mes := 'Abril';
	'05': mes := 'Mayo';
	'06': mes := 'Junio';
	'07': mes := 'Julio';
	'08': mes := 'Agosto';
	'09': mes := 'Septiembre';
	'10': mes := 'Octubre';
	'11': mes := 'Noviembre';
	'12': mes := 'Diciembre';
	end;

end;

function diaActual():string;
var Dia, DSemana:string;
Mes:string;
YY:string;
FechaAuxiliar:string;
begin

	diaActual := DateTimeToStr(Now);
	delete(diaActual, 11, 15); 
	FechaAuxiliar := diaActual;

	delete(diaActual, 3, 15); 
	Dia:= diaActual; 
	asignarDia(Dia, Dsemana);
	diaActual := FechaAuxiliar;

	delete(diaActual, 1, 3); delete(diaActual, 3, 15); 
	Mes:= diaActual; 
	asignarMes(Mes);
	diaActual := FechaAuxiliar;

	delete(diaActual, 1, 6); 
	YY:= diaActual; 
	diaActual := FechaAuxiliar;

	diaActual := DSemana + ' ' + Dia + ' de ' + Mes + ' del año ' + YY;

end;
begin
end.