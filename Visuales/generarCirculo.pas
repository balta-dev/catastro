unit generarCirculo;

interface

uses crt, math, sysutils;

procedure createCircle(radius:real; xOffset:integer; yOffset:integer; cosAmplitude:real; sinAmplitude:real; symbol:char);

implementation

procedure createCircle(radius:real; xOffset:integer; yOffset:integer; cosAmplitude:real; sinAmplitude:real; symbol:char);
var xAux, yAux:integer;
coseno, seno:real;
x, y:integer;

begin

	x:=0; y:=0;
	textcolor(8);

	if (radius > 3) and (radius < 15) then
	begin
		repeat
		
			coseno := cosAmplitude*radius*cos(x*3.14/180); xAux := floor(coseno);// x = angulo(x)
			seno := sinAmplitude*radius*sin(y*3.14/180); yAux := floor(seno);// y = angulo(y)
			writeln;
		
			//gotoxy(auxiliar, 15+yAux);
			gotoxy(xOffset+xAux, yOffset+yAux);
			write(symbol);

			x := x+1; //aumenta un grado
			y := y+1; //aumenta un grado
			//sleep(10);
		
		until x = 360; //circulo completo

	end
	else
	begin
			write('Rango Inválido (4-14). Intente Nuevamente: ');
			readln(radius);
			createCircle(radius, xOffset, yOffset, cosAmplitude, sinAmplitude, symbol);
	end;

	textcolor(white);

end;

begin
end.