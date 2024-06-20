unit dia;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses sysutils, dos;
type tVector = array [1..6] of string;

function diaActual:string;
procedure decodificarTiempo(var tiempo:tVector);

implementation

procedure decodificarTiempo(var tiempo:tVector);
var year, month, day, hr, min, sec, ms:Word;
i:1..6;
begin

	DecodeDate(Date,year,month,day);
	DecodeTime(Time, hr, min, sec, ms);

	tiempo[1] := IntToStr(year);
	tiempo[2] := IntToStr(month);
	tiempo[3] := IntToStr(day);
	tiempo[4] := IntToStr(hr);
	tiempo[5] := IntToStr(min);
	tiempo[6] := IntToStr(sec);

	for i:=1 to 6 do 
	begin
	if length(tiempo[i]) = 1 then insert('0', tiempo[i], 1);
	end;

end;

procedure asignarDia(var dsemana:string);
var a,b,c,d:word;
begin

	getDate(a, b, c, d);

	case d of
	0: dsemana := 'domingo';
	1: dsemana := 'lunes';
	2: dsemana := 'martes';
	3: dsemana := 'miércoles';
	4: dsemana := 'jueves';
	5: dsemana := 'viernes';
	6: dsemana := 'sábado';
	end;

end;

procedure asignarMes(var mes:string);
begin

	case mes of
	'01': mes := 'enero';
	'02': mes := 'febrero';
	'03': mes := 'marzo';
	'04': mes := 'abril';
	'05': mes := 'mayo';
	'06': mes := 'junio';
	'07': mes := 'julio';
	'08': mes := 'agosto';
	'09': mes := 'septiembre';
	'10': mes := 'octubre';
	'11': mes := 'noviembre';
	'12': mes := 'diciembre';
	end;

end;

function diaActual():string;
var DSemana:string[20];
tiempo:tVector;
begin

	decodificarTiempo(tiempo);

	asignarDia(Dsemana);
	asignarMes(tiempo[2]);
	
	diaActual := DSemana + ' ' + tiempo[3] + ' de ' + tiempo[2] + ' del año ' + tiempo[1];

end;
begin
end.