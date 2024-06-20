unit admin;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses 
	hashing, 
	crt,
	sysutils, 
	box, 
	estrellas, 
	generarCirculo, 
	arboles,
	archivoTerrenos,
	archivoPropietarios,
	md5,
	dos;	

//procedure handleAccount(op:string);
procedure menuAdmin();

implementation	

procedure handleAccount(op:string);
var Password, Username, PasswordHash, UsernameHash: string;
  db:database;
  dbAUX:tReg;
  cont:integer;
  coincideCuenta:boolean;
  confirm:string;
  existeUsuario:boolean;

begin

	if (op<>'') then boxDO(13, 92, 4, 29, '#', false);
	coincideCuenta:=false;
	existeUsuario:=false;
	assign(db, 'db.dat');
	{$i-}
    reset(db);
	{$i+}

	if IOResult <> 0 then	 ///////////////// Creacion de Usuario ///////////////////////////////
	begin
		rewrite(db);
		rewrite(db);
	end
	else 

		begin

		cont := 0;
		confirm := 'n';

		textcolor(yellow);
		gotoxy(25, 10);
		writeln('ADMINISTRADOR');
		gotoxy(25, 10);
		textcolor(white);
		//writeln('---- Alta de Empleados ----');

		case op of
		'alta': writeln('---- Alta de Empleados ----');
		'baja': writeln('---- Baja de Empleados ----');
		'modif': writeln('---- Modificación de Contraseñas ----');
		'cons': writeln('---- Consulta de Cantidad de Empleados ----');
		end;

	if op <> 'cons' then
	begin
		gotoxy(25, 12);
		textcolor(white);
		write('Usuario: '); readln(Username);
		gotoxy(25, 14);
		
		if (op <> 'baja') and (op <> 'modif') then begin write('Contraseña: '); readln(Password);
		gotoxy(25, 18);
		textcolor(yellow);
		end;

		write('¿Estas seguro? S/N: ');
		readln(confirm);
		textcolor(white);
	end;

		if (confirm='S') or (confirm='s') then  
		begin

		Username := Username+#13;
		Password := Password+#13;

		UsernameHash := MD5Print(MD5String(Username));
		PasswordHash := MD5Print(MD5String(Password));

		while not EOF(db) do 
		begin
			read(db, dbAUX);
			cont += 1;
			if (UsernameHash = dbAUX.usuario) and (PasswordHash = dbAUX.contrasena) then begin coincideCuenta:=true; end;
			if UsernameHash = dbAUX.usuario then begin existeUsuario:=true; end;
		end;

		dbAUX.usuario := UsernameHash; UsernameHash := '';
		dbAUX.contrasena := PasswordHash; PasswordHash := '';

// ------------------------------------- //
		dbAUX.hidden.DatoINT := 0;
		dbAUX.hidden.DatoString := '';
// ------------------------------------- //

		clrscr; 
		textcolor(yellow); 
		gotoxy(25, 10); 
		writeln('ADMINISTRADOR'); 
		gotoxy(25, 12); 

		case op of
		'alta': 
			begin 

				if (coincideCuenta=false) and (existeUsuario=false) then 
				begin textcolor(green); writeln('¡Cuenta Creada con Éxito!'); textcolor(white); write(db, dbAUX); end
				else if existeUsuario=true then begin clrscr; textcolor(yellow); gotoxy(25, 10); writeln('ADMINISTRADOR'); gotoxy(25, 10); textcolor(red); writeln('CUENTA EXISTENTE'); textcolor(white); end;

			end;

		'baja': 
			begin 

				if existeUsuario=true then 
				begin seek(db, cont-1);
				truncate(db);
				textcolor(red);
				writeln('Cuenta dada de baja');
				textcolor(white);
				end
				else begin clrscr; textcolor(yellow); gotoxy(25, 10); writeln('ADMINISTRADOR'); gotoxy(25, 12); textcolor(red); writeln('NO EXISTE EL EMPLEADO'); textcolor(white); end;

			end;

		'modif': 
			begin 

				if existeUsuario=true then begin
				textcolor(white);
				write('Ingrese nueva contraseña: ');
				readln(Password);
				Password := Password+#13;
				PasswordHash := MD5Print(MD5String(Password));
				dbAUX.contrasena := PasswordHash; PasswordHash := '';
				seek(db, cont-1);
				write(db, dbAUX);
				end
				else begin clrscr; textcolor(yellow); gotoxy(25, 10); writeln('ADMINISTRADOR'); gotoxy(25, 12); textcolor(red); writeln('NO EXISTE EL EMPLEADO'); textcolor(white); end;

			end;

		end;

		dbAUX.usuario := '';
		dbAUX.contrasena := '';

		gotoxy(1,1); ClrEol;
		readkey;
		clrscr;

	end;

if op = 'cons' then
	begin

		cont := 0;

		while not EOF(db) do 
		begin
			read(db, dbAUX);
			cont += 1;
		end;

		gotoxy(25, 12);
		write('* Cantidad: ', cont);
		readkey;
	end;

close(db);
SetFAttr(db, $02);

end;

clrscr;

end;

procedure menuAdmin();
var op:string;
begin

clrscr;
boxDO(13, 92, 4, 29, '#', false);

	repeat

		op := '0';
		//clrscr;
		if (op<>'') then boxDO(13, 92, 4, 29, '#', false);
		gotoxy(18,7);
		writeln('Bienvenid@, ADMINISTRADOR!');
		gotoxy(25, 10);
		textcolor(white);
		writeln('---- Simulador de Catastro ----');
		gotoxy(57, 10);
		writeln('Opcion: ');
		gotoxy(25, 12);
		writeln('1) Alta de Empleados');
		gotoxy(25, 14);
		writeln('2) Baja de Empleados');
		gotoxy(25, 16);
		writeln('3) Modificación de Contraseñas');
		gotoxy(25,18);
		writeln('4) Consulta de Cantidad de Empleados');
		gotoxy(25, 20);
		writeln('5) Salir');
		gotoxy(65, 10);
		readln(op);
		//clrscr;

		case op of
		'1': begin clrscr; handleAccount('alta'); end;
		'2': begin clrscr; handleAccount('baja'); end;
		'3': begin clrscr; handleAccount('modif'); end;
		'4': begin clrscr; handleAccount('cons'); end;
		end;

	until op = '5';

end;

begin
end.