unit box;

interface
uses crt, sysutils;

procedure boxDO(originX:integer; x:integer; originY:integer; y:integer; simbolo:char; fondo:boolean);

implementation

procedure boxDO(originX:integer; x:integer; originY:integer; y:integer; simbolo:char; fondo:boolean);
var i, j:integer;
begin

	if fondo then TextBackground(yellow);
	TextColor(yellow);

	if ((x<=119) and (x>=originX)) and ((y<=29) and (y>=originY)) then
	begin

	for i:=originX to x do
		for j:=originY to y do
		begin
			if ((i=originX) or (j=originY)) then begin
			gotoxy(i, j);
			writeln(simbolo);
			end;
		end;

	for i:=originX to x do
		for j:=originY to y do
		begin

			if ((i=x)) or ((j=y)) then begin
			gotoxy(i, j);
			writeln(simbolo);
			end;

		end;	
	end
	else writeln('Dimensiones X;Y fuera de limite (X MAX: 119; Y MAX: 29).');

	TextBackground(black);
	TextColor(white);

end;

begin
end.