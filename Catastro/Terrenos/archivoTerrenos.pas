unit archivoTerrenos;

interface

uses sysutils, strutils, manipulacionCadenas;

type 
	tDatoTerrenos = record
		numeroContribuyente:string[10];
		numeroPlanoMensura:string[10];
		avaluo:string[40];
		fechaInscripcion:string[10];
		domicilioParcelario:string[40];
		superficieTerreno:string[10];
		zona:string[1];
		tipoEdificacion:string[1];
	end;

	tArchivoTerrenos = file of tDatoTerrenos;

	procedure abrirArchivoTerrenos(var archivoTerrenos:tArchivoTerrenos; Ubicacion:string);
	procedure cerrarArchivoTerrenos(var archivoTerrenos:tArchivoTerrenos);
	procedure obtenerDatosTerrenos(var archivoTerrenos:tArchivoTerrenos; Posicion:Word; var Dato:tDatoTerrenos);
	//procedure guardarDatosTerrenos(var archivoFuente:tArchivoTerrenos; var archivoSalida:tArchivoTerrenos; Posicion:word);
	procedure bajarTerreno(var archivoTerrenos:tArchivoTerrenos; Posicion:Word);
	procedure ingresarTerrenos(var archivoTerrenos:tArchivoTerrenos; Dato:tDatoTerrenos; Posicion:Word);
	procedure ordenarArchivoTerrenos(var archivoTerrenos:tArchivoTerrenos);

	////////////////////////////////////////////////////////////////////
	//procedure borrarArchivoTerrenos(var archivoTerrenos:tArchivoTerrenos);   NO TIENE UTILIDAD EN EL CÓDIGO!
	///////////////////////////////////////////////////////////////////

implementation

	procedure abrirArchivoTerrenos(var archivoTerrenos:tArchivoTerrenos; Ubicacion:string);
	begin
		
		assign(archivoTerrenos, Ubicacion);
		{$I-} 
		reset(archivoTerrenos);
		{$I+}  
		if IOResult <> 0 then
		begin
			rewrite(archivoTerrenos);
		end;

	end;

	procedure borrarArchivoTerrenos(var archivoTerrenos:tArchivoTerrenos);
	begin
		close(archivoTerrenos);
		erase(archivoTerrenos);
	end;

	procedure cerrarArchivoTerrenos(var archivoTerrenos:tArchivoTerrenos);
	begin
		close(archivoTerrenos);
	end;

	procedure obtenerDatosTerrenos(var archivoTerrenos:tArchivoTerrenos; Posicion:Word; var Dato:tDatoTerrenos); 
	begin 

		seek(archivoTerrenos, Posicion);
		read(archivoTerrenos, Dato);

	end;

	procedure guardarDatosTerrenos(var archivoFuente:tArchivoTerrenos; var archivoSalida:tArchivoTerrenos; Posicion:word); 
	var Terreno:tDatoTerrenos;
	begin 
		seek(archivoFuente, Posicion);					//posiciono sobre la data a capturar
		read(archivoFuente, Terreno);					//leo y guardo en "Terreno"
		seek(archivoSalida, filesize(archivoSalida));	//posiciono al final del salida
		write(archivoSalida, Terreno);					//escribo ahí

	end;
	
	procedure bajarTerreno(var archivoTerrenos:tArchivoTerrenos; Posicion:Word); 
	var archivoAuxiliar:tArchivoTerrenos;
	i:word;
	begin

		if (filesize(archivoTerrenos) > 1) and (filesize(archivoTerrenos) > Posicion) then
		begin
		
			abrirArchivoTerrenos(archivoAuxiliar, 'terrenos_auxiliar.dat');

			
{		    Acá se guardan todo lo que está en archivoTerrenos en archivoAuxiliar, menos el a bajar	        }
			if filesize(archivoTerrenos) > 0 then
				for i:=0 to filesize(archivoTerrenos)-1 do
					if i<>Posicion then begin guardarDatosTerrenos(archivoTerrenos, archivoAuxiliar, i); end; //espacio en blanco no se guarda	
																	//fuente        //salida


			borrarArchivoTerrenos(archivoTerrenos); //porque tiene espacio blanco. auxiliar tiene los datos bien
			abrirArchivoTerrenos(archivoTerrenos, 'terrenos.dat');

{			Acá se devuelven los datos originales a "archivoTerrenos"							}
			if filesize(archivoAuxiliar) > 0 then
				for i:=0 to filesize(archivoAuxiliar)-1 do
					guardarDatosTerrenos(archivoAuxiliar, archivoTerrenos, i);
											//fuente          //salida

			borrarArchivoTerrenos(archivoAuxiliar); //borro porque ya no lo necesito

		end //si no cumple (filesize(archivoTerrenos) > 1) y (filesize(archivoTerrenos) > Posicion)
		else 
			if filesize(archivoTerrenos)=1 then
			begin
				borrarArchivoTerrenos(archivoTerrenos);
				abrirArchivoTerrenos(archivoTerrenos, 'terrenos.dat');
			end;

	end;

	procedure ingresarTerrenos(var archivoTerrenos:tArchivoTerrenos; Dato:tDatoTerrenos; Posicion:Word);
	begin 

		seek(archivoTerrenos, Posicion);
		write(archivoTerrenos, Dato);

	end;


	procedure ordenarArchivoTerrenos(var archivoTerrenos:tArchivoTerrenos); 
	var i,j:word;
	Terreno, TerrenoSiguiente: tDatoTerrenos;

	begin 

		if filesize(archivoTerrenos)>1 then
		begin

			for i:=0 to filesize(archivoTerrenos)-1 do
				for j:=0 to filesize(archivoTerrenos)-2 do

				begin
					obtenerDatosTerrenos(archivoTerrenos, j, Terreno);
					obtenerDatosTerrenos(archivoTerrenos, j+1, TerrenoSiguiente);

					if validarFecha(Terreno.fechaInscripcion) and validarFecha(TerrenoSiguiente.fechaInscripcion) and esNumero(Terreno.numeroContribuyente) and esNumero(TerrenoSiguiente.numeroContribuyente) then

					begin

						//writeln('Fecha valida, numero de contribuyente son numeros')

						if StrtoInt(Terreno.numeroContribuyente)>StrtoInt(TerrenoSiguiente.numeroContribuyente) then
						begin

							ingresarTerrenos(archivoTerrenos, Terreno, j+1);
							ingresarTerrenos(archivoTerrenos, TerrenoSiguiente, j);

						end
						else if StrtoInt(Terreno.numeroContribuyente)=StrtoInt(TerrenoSiguiente.numeroContribuyente) then
							
								if StrToInt(Terreno.numeroContribuyente)=StrtoInt(TerrenoSiguiente.numeroContribuyente) then
								begin

									ingresarTerrenos(archivoTerrenos, Terreno, j+1);
									ingresarTerrenos(archivoTerrenos, TerrenoSiguiente, j);

								end;
						end;
					end;
			end;
	end;


begin
end.