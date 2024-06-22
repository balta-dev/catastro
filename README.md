# DOCUMENTACIÓN

&emsp;
 
## SATURN CATASTRO SIMULATOR

### ¿Qué es "Saturn Catastro Simulator"? 
Es un programa que utiliza archivos aleatorios para guardar, agregar o quitar información acerca de propietarios y terrenos. Utiliza algoritmos de cifrado de datos de sesión (MD5 Hash) para iniciar sesión como empleado del gestor del sistema de catastro y un submenú oculto de administrador para gestionar empleados. Utiliza dos árboles binarios (DNI y Apellido+Nombre) para almacenar información acerca de contribuyentes y asignarles terrenos recientemente creados o ya existentes.

### ¿Para qué sirve?
Este programa escrito en su totalidad en el lenguaje de programación Pascal, fue diseñado con el propósito de gestionar los terrenos de una ciudad dada, agregando, modificando, quitando, o consultando por su propietario (que si no es una persona física, es el Estado). Con el mismo, se pueden agregar propietarios que pueden (o no) tener terrenos. La utilidad real se la puedes dar tú, ya que es posible agregar múltiples palabras claves para ciertas respuestas sin ningún tipo de restricción.

&emsp;

### ¿Al ejecutarlo, con qué nos encontraremos?

Una pestaña de Inicio de Sesión para poder acceder al sistema. Cuando se compila y ejecuta por primera vez, el escribir cualquier información registra un usuario (es preferible que sea el dueño).
El usuario registrado pasa a ser automáticamente registrado como empleado. Luego, se accede a un menú de selección. 

> [!NOTE]
> Si escribis "adminmenu" en el menú, podes acceder al submenú de empleados. Esta información no debería conocerla alguien que no gestione usuarios.

&emsp;

El menú contiene lo siguiente:

* **1) ABMC De Contribuyetes:** Se puede dar de Alta, Baja (lógica), Modificar o Consultar Contribuyentes. Si son contribuyentes con uno o más terrenos, entonces son propietarios. Para dar de alta un contribuyente es necesaria la existencia de un terreno. Al dar de baja un contribuyente, se le remueven todos los terrenos a su nombre.
 
* **2) ABMC De Terrenos:** Se puede dar de Alta, Baja, Modificar o Consultar terrenos. Se puede cambiar la propiedad del terreno.
 
* **3) Impresión de Comprobante:** Genera automáticamente un comprobante con los datos del propietario y de un terreno particular al día de la fecha que sea requerido.
  
* **4) Estadísticas:** Se pueden mostrar estadísticas acerca de propietarios y terrenos. Aquellas opciones son:

* * **Cantidad de Inscripciones entre dos fechas:** Se muestra la cantidad de terrenos registrados entre dos fechas ingresadas por el usuario.

* * **Porcentaje de Propietarios con más de una Propiedad:** Si poseen más de una propiedad, son registrados en esta estadística.

* * **Porcentaje de Propietarios por tipo de edificación:** Entre los distintos tipos de edificación, se muestra un porcentaje que corresponde a la existencia de cada uno.

* * **Cantidad de Propietarios dados de baja:** Contribuyentes que fueron asignados en el sistema y no poseen terrenos (condición para estar dado de baja).

* **5) Listados :** Una lista en forma de páginas. Se pueden encontrar tres opciones de listado:
* * **Listado ordenado de propiedad por nombre:** Muestra el listado de terrenos asignados a un contribuyente y lo ordena por nombre de propietario.
* * **Listado ordenado por zonas:** Muestra el listado de terrenos asignados a un contribuyente y lo ordena por número de zonas.
* * **Listado ordenado por fecha de inscripción:** Muestra el listado de terrenos asignados a un contribuyente y lo ordena por fecha de inscripción.  

> [!NOTE]
> Cuando registra de Alta un contribuyente, queda registrado en el sistema como "Dado de baja" hasta que se le asigne una propiedad.

&emsp;

## ¿Cómo lo compilo?

### Si quieres modificar el código y/o compilarlo, debes cumplir ciertos prerrequisitos:

1. Si no tenes un compilador de Pascal, ingresá a la [página oficial de Free Pascal](https://www.freepascal.org/download.html) y descargá el binario adecuado a tu sistema operativo. También se puede instalar desde la consola al paquete `fpc`.

2. Cloná el repositorio (opcional, podes simplemente descargar el ZIP y descomprimirlo).
   ```sh
   git clone https://github.com/balta-dev/catastro.git
   ```
3. Ingresá a la carpeta base, abrí una terminal y compilá el archivo `main.pas` con:
   ```sh
   fpc main.pas
   ```
4. Ejecutá el archivo.
	```sh
   ./main
   ```

 &emsp;
## ¿Qué contiene el simulador de catastro?

Está diseñado con archivos aleatorios que contienen registros de información ofuscada para dificultar la recopilación y/o análisis de los datos de sesión hasheada por MD5 para ingresar al sistema. Se genera un archivo `db.dat` que contiene datos de todos los empleados y dos archivos (`terrenos.dat` y `propietarios.dat`) que guardan la información relevante. El archivo `propietarios.dat` está guardado y es recorrido con dos árboles binarios con clave maestra DNI y Apellido+Nombre. El archivo `terrenos.dat` está guardado ordenadamente por fecha y es recorrido secuencialmente.

&emsp;
## ALGORITMOS - ¿Qué hace internamente? 

* Tiene un manejador de archivos `hashing.pas` que se encarga de "encriptar" la información de inicio de sesión. Se guarda como registro de información ofuscada hasheada. En la ejecución de programa, los datos introducidos son hasheados y comparados con los elementos de `db.dat`, y si ambos datos coinciden entonces se brinda acceso.
* Tiene dos units (archivo y ABMC) tanto de propietarios como de terrenos, ambos gestionan lo más importante del programa.
* Tiene una unit `paginas.pas` que sirve de manejador de páginas que permite mostrar todos los terrenos. Comprueba que la pantalla sea suficiente para mostrar los mensajes completamente, un sistema para subir o bajar página (crea sublistas y restaura una página utilizando los procedimientos de las ventanas flotantes).
* Tiene un manejador de música `music.pas` que se encarga de crear el formato para elegir aleatoriamente una canción, colocarle nombre y reproducirla en medio de la ejecución del programa. Viene incluída una carpeta llamada "music" que almacena una canción de fondo .mp3. No está disponible su uso en Linux. Existen otros dos archivos de audio (easter eggs).
* Tiene una unit `dia.pas` que crea el formato para mostrar el día actual.
* Tiene una carpeta de visuales que contiene la generación de los gráficos del programa (cajas, comprobante, easter eggs, estrellas, círculos).
