unit arboles;
interface

uses archivoPropietarios in '../Propietarios/archivoPropietarios.pas';

type

	tDatoArbol = record
		clave : string[100];
		pos : word;
	end;

	tPuntero = ^tNodo;

	tNodo = record
		informacion : tDatoArbol;
		SAI, SAD : tPuntero;
	end;

	procedure crearArbol(var raiz:tPuntero);

	//////////////////////////////////
	//procedure borrarArbol(var raiz:tPuntero); //NO TIENE NINGÚN TIPO DE USO EN NADA!!!!!
	/////////////////////////////////

	//procedure agregar(var raiz:tPuntero; x:tDatoArbol);
	function recorridoPreorden(var raiz:tPuntero; buscado:string):tPuntero;
	//procedure generarDatoArbol(var DatoArbolDNI:tDatoArbol; var DatoArbolAPYNOM:tDatoArbol; Dato:tDatoPropietarios; Posicion:word);
	procedure generarArbol(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios);


implementation

	procedure crearArbol(var raiz:tPuntero);
	begin
		raiz := nil;
	end;

	procedure borrarArbol(var raiz:tPuntero);
	begin
		
		if raiz <> nil then
		begin
			borrarArbol(raiz^.SAI);
			borrarArbol(raiz^.SAD);
			dispose(raiz);
		end;

	end;

	procedure agregar(var raiz:tPuntero; x:tDatoArbol);
	begin
		
		if raiz = nil then
		begin

			new(raiz);
			raiz^.informacion := x;
			raiz^.SAI := nil;
			raiz^.SAD := nil;

		end
		else
		begin
			
			if raiz^.informacion.clave > x.clave then
			begin
				agregar(raiz^.SAI, x);
			end
			else agregar(raiz^.SAD, x);

		end;

	end;


	function recorridoPreorden(var raiz:tPuntero; buscado:string):tPuntero;
	var i:byte;
	begin
		
		buscado := upcase(buscado);
		for i:=0 to length(buscado) do if copy(buscado, i, 1)=' ' then delete(buscado, i, 1);

		if raiz = nil then
		begin
			recorridoPreorden := nil;
		end
		else
		begin

			if raiz^.informacion.clave = buscado then begin recorridoPreorden := raiz end
			else 
			begin

				if raiz^.informacion.clave > buscado 
				then recorridoPreorden := recorridoPreorden(raiz^.SAI, buscado)
				else recorridoPreorden := recorridoPreorden(raiz^.SAD, buscado);
			end;

		end;

	end;

	procedure generarDatoArbol(var DatoArbolDNI:tDatoArbol; var DatoArbolAPYNOM:tDatoArbol; Dato:tDatoPropietarios; Posicion:word); 
	var i:word;
	begin 

		for i:=0 to length(Dato.apellido) do if copy(Dato.apellido, i, 1)=' ' then delete(Dato.apellido, i, 1);

		for i:=0 to length(Dato.nombre) do if copy(Dato.nombre, i, 1)=' ' then delete(Dato.nombre, i, 1);

		DatoArbolDNI.clave := Dato.DNI;
		DatoArbolAPYNOM.clave := Dato.apellido + Dato.nombre;
		DatoArbolDNI.pos := Posicion;
		DatoArbolAPYNOM.pos := Posicion; 

	end;
	
	procedure generarArbol(var raizDNI:tPuntero; var raizNOMBRE:tPuntero; var archivoPropietarios:tArchivoPropietarios); 
	var i:word;
	Dato:tDatoPropietarios;
	DatoArbolDNI, DatoArbolAPYNOM:tDatoArbol;
	begin 

	if filesize(archivoPropietarios) > 0 then 
	begin
		for i:=0 to filesize(archivoPropietarios)-1 do
		begin

			obtenerDatosPropietarios(archivoPropietarios, i, Dato);
			generarDatoArbol(DatoArbolDNI, DatoArbolAPYNOM, Dato, i); 
			agregar(raizDNI, DatoArbolDNI);
			agregar(raizNOMBRE, DatoArbolAPYNOM);

		end; 
	end;

	end;
 

begin
end.