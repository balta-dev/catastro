unit archivoPropietarios;

interface

uses strutils;

type 
	tDatoPropietarios = record
		numeroContribuyente:string[10];
		nombre:string[30];
		apellido:string[30];
		direccion:string[40];
		ciudad:string[40];
		DNI:string[10];
		fechaNacimiento:string[10];
		telefono:string[15];
		mail:string[50];
		estado:boolean;
	end;

	tArchivoPropietarios = file of tDatoPropietarios;

	procedure abrirArchivoPropietarios(var archivoPropietarios:tArchivoPropietarios);
	procedure cerrarArchivoPropietarios(var archivoPropietarios:tArchivoPropietarios);
	procedure obtenerDatosPropietarios(var archivoPropietarios:tArchivoPropietarios; Posicion:Word; var Dato:tDatoPropietarios);
	procedure guardarDatosPropietarios(var archivoPropietarios:tArchivoPropietarios; Dato:tDatoPropietarios);
	procedure bajaLogicaPropietarios(var archivoPropietarios:tArchivoPropietarios; Posicion:Word);
	//procedure altaLogicaPropietarios(var archivoPropietarios:tArchivoPropietarios; Posicion:Word); CREO QUE ESTE NI DEBERÍA EXISTIR!!!

implementation

	procedure obtenerDatosPropietarios(var archivoPropietarios:tArchivoPropietarios; Posicion:Word; var Dato:tDatoPropietarios); 
	begin 

	seek(archivoPropietarios, Posicion);
	read(archivoPropietarios, Dato);

	end;

	procedure guardarDatosPropietarios(var archivoPropietarios:tArchivoPropietarios; Dato:tDatoPropietarios); 
	begin 

		if filesize(archivoPropietarios)=0 then
		begin 
			seek(archivoPropietarios, 0); 
			write(archivoPropietarios, Dato); 
		end
		else
		begin
			seek(archivoPropietarios, filesize(archivoPropietarios));
			write(archivoPropietarios, Dato);
		end;

	end;

	procedure bajaLogicaPropietarios(var archivoPropietarios:tArchivoPropietarios; Posicion:Word); 
	var Propietario:tDatoPropietarios;
	begin 

		if (filesize(archivoPropietarios)>0) and (Posicion<=filesize(archivoPropietarios)) then
		begin
			seek(archivoPropietarios, Posicion);
			read(archivoPropietarios, Propietario);
			Propietario.estado:=false;
			seek(archivoPropietarios, Posicion);
			write(archivoPropietarios, Propietario);
		end;

	end;

	procedure altaLogicaPropietarios(var archivoPropietarios:tArchivoPropietarios; Posicion:Word); 
	var Propietario:tDatoPropietarios;
	begin 

		if (filesize(archivoPropietarios)>0) and (Posicion<=filesize(archivoPropietarios)) then
		begin
			seek(archivoPropietarios, Posicion);
			read(archivoPropietarios, Propietario);
			Propietario.estado:=true;
			seek(archivoPropietarios, Posicion);
			write(archivoPropietarios, Propietario);
		end;

	end;

	procedure abrirArchivoPropietarios(var archivoPropietarios:tArchivoPropietarios);
	begin
		
		assign(archivoPropietarios, 'propietarios.dat');
		{$I-} 
		reset(archivoPropietarios);
		{$I+}  
		if IOResult <> 0 then
		begin
			rewrite(archivoPropietarios);
		end;

	end;

	procedure cerrarArchivoPropietarios(var archivoPropietarios:tArchivoPropietarios);
	begin
		close(archivoPropietarios);
	end;


begin
end.