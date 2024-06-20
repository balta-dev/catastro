unit hashing;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses crt, sysutils, keyboard, box, {$IFDEF Windows} MMSystem, {$ENDIF}
	estrellas, generarcirculo, md5, dos;

type 

	tRegAUX = record
		DatoINT:integer;
		DatoString:string;
	end;

	tReg = record
		Hidden:tRegAUX;
		Usuario:string;
		Contrasena:string;
	end;

	database = file of tReg;

procedure logIn(var valid:boolean); //usado en main
//procedure loginHandling(var grantedAccess:boolean; var accessDeniedCount:integer; var abort:boolean); //usado solo acá
//procedure retryWait(accessDeniedCount:integer);

implementation

procedure retryWait(accessDeniedCount:integer);
var sec:integer;
begin

case accessDeniedCount of
1: sec := 3;
2: sec := 5;
3: sec := 10;
4: sec := 15;
5: sec := 20;
6: sec := 9999;
end;

InitKeyboard;
while (sec >= 0) and (sec <> 9999) and (sec < 9999) do
begin
	gotoxy(10, 25);
	writeln('Tiempo restante: ', sec, ' segundos.');

	if keypressed then 
	begin
		gotoxy(40, 25);
		writeln('Presta atención a las mayúsculas y/o minúsculas.');
		gotoxy(40, 26);
		writeln('Si no recuerdas tu contraseña, elimina el archivo "db.dat".');
	end;

	sleep(1000);
	dec(sec);
	clrscr;

end;

if accessDeniedCount >= 6 then writeln('Lamentablemente no podemos validar tu identidad. Vuelve más tarde.') else DoneKeyboard;

end;

procedure usernameEntering(var Username:string; var Abort:boolean);
var caracter : char;
begin

	caracter := #0;
	Username := '';
	Abort := false;

	 repeat

	 	caracter := readkey;

	 	if (caracter = #27) then //---------- Boton Escape -------------//
		begin
			caracter := #13;
			Abort := true;
		end;

		if (caracter <> #13) and (caracter <> #8) then write(caracter);	//----- Distinto de Enter y Backspace --------//

		if caracter <> #8 then Username := Username + caracter	//----- Distinto de Backspace -------//
		else  
		begin
			if whereX > 53 then gotoxy(whereX-1, 13);
			delete(Username, length(Username), 1);
			ClrEol;

		end;
	 	
	 until caracter=#13;
	 //delete(Username, length(Username), 1);
	
end;

procedure passwordEntering(var Password:string; var Abort:boolean);
var caracter : char;
begin

caracter := #0;
Password := '';

	repeat

		caracter := readkey;

		if (caracter = #27) then //---------- Boton Escape -------------//
		begin
			caracter := #13;
			Abort := true;
		end;

		if (caracter <> #13) and (caracter <> #8) then write('*');	//----- Distinto de Enter y Backspace --------//

		if caracter <> #8 then Password := Password + caracter	//----- Distinto de Backspace -------//
		else  
		begin
			if whereX > 56 then gotoxy(whereX-1, 15);
			delete(Password, length(Password), 1);
			ClrEol;

		end;

	until caracter=#13;
	//delete(Password, length(Password), 1);
	
end;

procedure loginHandling(var grantedAccess:boolean; var accessDeniedCount:integer; var abort:boolean);
var
  Password, Username, PasswordHash, UsernameHash: string;
  db:database;
  dbAUX:tReg;

  cont:integer;

begin

	cont := 0;

//////////////////// Login ///////////////////////////////
	
	abort := false;
	createCircle(10, 59, 15, 7/2, 1/2, '-');
	createCircle(10, 60, 15, 2, 1, '*');

	gotoxy(1,1);
	writeln('Presiona ESC para abortar inicio de sesión.');

	gotoxy(47, 8);
	textcolor(yellow);
	writeln('--- INICIO DE SESION ---');
	gotoxy(47, 20);
	writeln('Saturn Catastro Simulator');

	gotoxy(43, 13);
	textcolor(white);
	writeln('Usuario: ');
	gotoxy(43, 15);
	writeln('Contraseña: ');
	gotoxy(53, 13);
	UsernameEntering(Username, abort); 
	
if abort <> true then 
begin
	gotoxy(56, 15);
	passwordEntering(Password, abort);
end;

	UsernameHash := MD5Print(MD5String(Username)); Username := '';
	PasswordHash := MD5Print(MD5String(Password)); Password := '';

if abort <> true then
begin

////////////////////// Asignación de Archivo ////////////////////////

	assign(db, 'db.dat');

    {$i-}
    reset(db);
	 {$i+}

if IOResult <> 0 then	 ///////////////// Creacion de Usuario ///////////////////////////////
	begin

		rewrite(db);
		dbAUX.usuario := UsernameHash; UsernameHash := '';
		dbAUX.contrasena := PasswordHash; PasswordHash := '';

// ------------------------------------- //
		dbAUX.hidden.DatoINT := 0;
		dbAUX.hidden.DatoString := '';
// ------------------------------------- //

		write(db, dbAUX);
		dbAUX.usuario := '';
		dbAUX.contrasena := '';

		grantedAccess := true;

		gotoxy(1,1); ClrEol;
		
		gotoxy(36, 28);
		writeln('¡Cuenta de Administrador creada con éxito!');
		gotoxy(36, 29);
		writeln('Si olvida sus datos, elimine el archivo "db.dat".');
		readkey;
		clrscr;					

	end
else
	begin  ///////////////// Apertura de Archivo ///////////////////////////////

		while not EOF(db) do 
			begin
				read(db, dbAUX);
				cont += 1;
				if (UsernameHash = dbAUX.usuario) and (PasswordHash = dbAUX.contrasena) then grantedAccess:=true;
			end;

			if (PasswordHash <> 'dcb9be2f604e5df91deb9659bed4748d') then 
			begin //si no es vacia

			if grantedAccess then begin
			gotoxy(1,1); ClrEol; //mciSendString('play "ok.mp3"', nil, 0, 0);
				blink(5, 5, '*'); textcolor(10); gotoxy(36, 28); writeln('Exito!. Presione cualquier tecla para continuar.'); readkey; clrscr end
			else begin //mciSendString('play "bad.mp3"', nil, 0, 0);
				textcolor(12); gotoxy(36, 28); writeln('Usuario Inexistente y/o Contraseña Incorrecta. Intente nuevamente.'); inc(accessDeniedCount); end;

			end;

	end;

	close(db);
	SetFAttr(db, $02);
	textcolor(white);

end; //del abort

end;  

procedure logIn(var valid:boolean);
var grantedAccess:boolean;
accessDeniedCount:integer;
Abort:boolean;

begin

grantedAccess := false;
valid := false;
Abort := false;
accessDeniedCount := 0;
textcolor(white);

	repeat 

		//boxDO(40, 80, 8, 14);

		loginHandling(grantedAccess, accessDeniedCount, Abort);
		if (not grantedAccess) and (not Abort) then retryWait(accessDeniedCount);

	until grantedAccess or Abort;

	if grantedAccess then valid := true;

end;

begin
end.
