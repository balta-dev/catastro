program main;

uses 

	generarCirculo in 'Visuales/generarCirculo.pas',
	estrellas in 'Visuales/estrellas.pas',
	box in 'Visuales/box.pas',
	selector in 'Menu/selector.pas',
	dia in 'Visuales/dia.pas',
	comprobante in 'Visuales/comprobante.pas',
	hashing in 'MD5/hashing.pas', 
	crt,
	manipulacionCadenas in 'Arboles/manipulacionCadenas.pas',
	menu in 'Menu/menu.pas', 
	sysutils,  
	arboles in 'Arboles/arboles.pas',
	easter in 'Visuales/easter.pas',
	archivoTerrenos in 'Terrenos/archivoTerrenos.pas',
	archivoPropietarios in 'Propietarios/archivoPropietarios.pas',
	admin in 'MD5/admin.pas',
	abmc_propietarios in 'Propietarios/ABMC/ABMC_Propietarios.pas',
	abmc_terrenos in 'Terrenos/ABMC/ABMC_Terrenos.pas',
	estadisticas in 'Estadisticas/estadisticas.pas',
	listado in 'Listado/listado.pas';

var valid:boolean;

begin

clrscr;
valid := false;
logIn(valid);
if valid then principalMenu;

end. 