unit estrellas;

interface

uses crt, sysutils;

procedure blink(x:integer; y:integer; symbol:char);

implementation

procedure blink(x:integer; y:integer; symbol:char);
begin
	

//-----------------------//

	textcolor(16);
	sleep(200);
		gotoxy(x, y);	
		write(symbol);
		gotoxy(x+80, y+1);
		write(symbol);												
	
	textcolor(8);
	sleep(200);
		gotoxy(x, y);
		write(symbol);
		gotoxy(x+80, y+1);
		write(symbol);						textcolor(16);
											gotoxy(x+17, y+20);
											write(symbol);
											gotoxy(x+110, y+10);
											write(symbol);

	textcolor(7);
	sleep(200);
		gotoxy(x, y);
		write(symbol);
		gotoxy(x+80, y+1);
		write(symbol); 						textcolor(8);		
											gotoxy(x+17, y+20);
											write(symbol);
											gotoxy(x+110, y+10);
											write(symbol);						textcolor(16);
																				gotoxy(x+75, y+20);
																				write(symbol);

	textcolor(15);
	sleep(500);
		gotoxy(x, y);
		write(symbol);
		gotoxy(x+80, y+1);
		write(symbol);						textcolor(7);
											gotoxy(x+17, y+20);
											write(symbol);
											gotoxy(x+110, y+10);
											write(symbol);						textcolor(8);
																				gotoxy(x+75, y+20);
																				write(symbol);

	textcolor(7);					
	sleep(100);
		gotoxy(x, y);
		write(symbol);
		gotoxy(x+80, y+1);
		write(symbol);						textcolor(15);
											gotoxy(x+17, y+20);
											write(symbol);
											gotoxy(x+110, y+10);
											write(symbol);						textcolor(7);
																				gotoxy(x+75, y+20);
																				write(symbol);



//------------------------//

	//la vuelta

end;

begin
end.