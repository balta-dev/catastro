unit selector;

interface

uses sysutils, crt, keyboard;

procedure mostrarSeleccion(x:integer; y:integer);

implementation

procedure mostrarSeleccion(x:integer; y:integer);
var i:1..2;
begin

	InitKeyboard;

	for i:=1 to 2 do
	begin

	//textbackground(yellow);
	textcolor(yellow);
	gotoxy(x, y);
	writeln('->');
	sleep(250);

	//textbackground(black);
	gotoxy(x, y);
	writeln('  ');
	sleep(100);

	end;

	//clrscr;
	textcolor(white);
	DoneKeyboard;

end;

begin



end.