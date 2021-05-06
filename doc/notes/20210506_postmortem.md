# Resumen de la sesión de hoy

- Instalar MSYS2, y después instalar todas las dependencias (GHDL, Python, Gtkwave, etc.).
- Ejecutar los tres primeros ejercicios/ejemplos de la sección de simulación de la User Guide de GHDL.
- Adaptar el último de los ejemplos de la User Guide de GHDL para añadir un `run.py` y ejecutarlo a través de VUnit.
- Ver la estructura de los ficheros que componen el ejemplo `array_axis_vcs` de VUnit.

# Referencias

Lectura indispensable para entender lo anterior:

- Transparencia 4:
  - https://hdl.github.io/MINGW-packages/#_usage
- Transparencia 7:
  - https://ghdl.github.io/ghdl/quick_start/simulation
- Transparencias 10-13:
  - http://vunit.github.io/about.html
  - http://vunit.github.io/user_guide.html#user-guide
  - http://vunit.github.io/cli.html#example-session
- Transparencia 14:
  - http://vunit.github.io/com/user_guide.html
  - https://github.com/paebbels/json-for-vhdl
- Transparencia 15:
  - http://vunit.github.io/verification_components/user_guide.html
  - http://vunit.github.io/examples.html#id11

Lectura muy recomendable para entender las posibilidades que ofrecen las librerías VHDL de VUnit, que son complementarias
y no dependendientes del uso de Python como "runner":

- http://vunit.github.io/run/user_guide.html#run-library
  - http://vunit.github.io/examples.html#id4
- http://vunit.github.io/check/user_guide.html#check-library
  - http://vunit.github.io/examples.html#id12
- http://vunit.github.io/logging/user_guide.html#logging-library
  - http://vunit.github.io/examples.html#id5
- JSON-for-VHDL
  - http://vunit.github.io/examples.html#id2

NOTA: todos los ejemplos de VUnit se ejecutan de igual manera, mediante `python run.py` en la carpeta correspondiente.
Podéis usar `-l`, `-v` o `-g`, como hemos visto en clase. La lista completa de opciones CLI está documentada en [Command Line Interface](http://vunit.github.io/cli.html). Recomiendo ejecutar cada uno de los ejemplos referenciados, al menos con `-l` (primero) y `-v` (después).

Asimismo, no vamos a entrar en muchos detalles, pero es recomendable saber que la API Python (hooks, configuraciones, filtros, etc.) está documentada en [Python Interface](http://vunit.github.io/py/ui.html).

# Tareas a realizar para la próxima sesión

- Clonar https://github.com/umarcor/MSEA limpio.
- Situarnos en el subdirectorio `ghdl_ug` y abrir el `README.md`.
- Leer detenidamente cada ejemplo en la User Guide de GHDL, y a continuación ejecutar los comandos indicados en el README. Ver las notas en el mismo al respecto.
- Escribir un script de Python y adaptar el testbench del adder para usar VUnit. Como veis en el README, la solución está dada (`vunit_run.py` y `tb_adder_vunit.vhd`), por lo que podéis consultarlo si os atascáis.
  - Una vez ejecutado satisfactoriamente, quienes dispongáis de ModelSim/QuestaSim podéis probar a definir la variable de entorno, tal como se indica en el README, y volver a ejecutar la simulación. El mismo comando de Python debería esta vez utilizar ModelSim/QuestaSim para la simulación y visualización, en vez de GHDL y GTKWave.
- Leer muy atentamente el ejemplo `array_axis_vcs` (son exactamente 4 ficheros VHDL y el `run.py`, además de un CSV de entrada). El primer diagrama de [ghdl-cosim: Array and AXI4 Stream Verification Components](https://ghdl.github.io/ghdl-cosim/vhpidirect/examples/arrays.html#array-and-axi4-stream-verification-components) puede ser útil para entender la estructura del testbench y los flujos de datos. Ejecutadlo, ved la waveform, tratad de hacer modificaciones (e.g. el tamaño del CSV), etc.

El tiempo necesario para instalar desde cero y hacer todas las ejecuciones es de 10 minutos. Teniendo en cuenta que debéis leer las referencias indispensables, estimo 1 hora. A ello habría que sumarle otra hora para entender el ejemplo array_axis_vcs y leer algunas de las referencias recomendables.

Uno de los objetivos de la siguiente sesión será entender cómo reemplazar el uso de los CSV por un fichero en C que pase los datos a GHDL mediante un puntero (segundo diagrama del enlace anterior). Trabajaremos sobre el testbench, asumiendo que conocemos lo que está sucediendo dentro de `vc_axis` (donde se encuentran la UUT y los VCs).
Asimismo, nos centraremos en VHDL y C, asumiendo que nos es indiferente ejecutar los comandos de GHDL directamente, usar un script de VUnit o cualquier otro "runner" similar.

Si quisierais ojear qué vamos a hacer en la próxima sesión, en las transparencias 3-6 de 2021_05_cosim se indica el orden en que vamos a analizar el contenido de [ghdl.github.io/ghdl-cosim](https://ghdl.github.io/ghdl-cosim/).

# Errores cometidos

La documentación referenciada no es particularmente amena, pero prácticamente cada oración está incluida porque contiene información relevante. Es muy importante leerla atentamente. En casa, tranquilamente.

- Hay que ejecutar `pacman -Syu` (una o varias veces) después de instalar MSYS2 y antes de ejecutar el script.
- Hay que ejecutar el script (y los ejemplos) en una terminal MINGW64, NO MSYS2, NO MINGW32, ni ninguna otra. Los errores de "python no encontrado" se han debido a esto.
- Hay que leer el contenido de la terminal hasta encontrar el primer error, no el último. El primero puede condicionar los posteriores. Este ha sido el caso al ejecutar el script varias veces, ya que intentaba clonar VUnit pero el directorio ya existía.
- En caso de ejecutar el ejemplo heartbeat mediate `ghdl -r ...`, la terminación con Ctrl+C no finaliza el binario. He añadido una aclaración en el README al respecto.
- Al duplicar un fichero y modificar el contenido sin renombrar la entidad, produce un conflicto. Analiza dos veces "la misma" entidad y el segundo análisis sobreescribe la primera. Este es un error que yo había cometido también en ghdl_ug. Lo he subsanado.
  - Una solución es renombrar la entidad (no sólo el fichero).
  - Otra solución es modificar `lib.add_source_files("*.vhd")` en el script de Python, para especificar una lista concreta de ficheros. Por ejemplo `lib.add_source_files(["adder.vhd", "tb_adder.vhd"])`.

El ejercicio final (adaptar tb_adder a VUnit), a algunas os ha funcionado y habéis visto el resultado en GTKWave. A otras aparentemente se os simulaba correctamente, pero no se abría GTKWave, a pesar de usar `-g` o `-v -g`. En otros casos, no os detectaba ningún testbench válido. Quienes tengáis algunos de estos problemas, por favor abrid un hilo en el foro facilitando los ficheros concretos que estáis utilizando.

A una persona creo que le daba un "Segmentation fault" al intentar abrir un fichero GHW con GTKWave. Si sigue sucediendo, por favor abre un hilo facilitando ese fichero concreto.

---

Un compañero me ha preguntado cómo se pueden restablecer/revertir los cambios realizados en los ficheros de un repositorio de git. Por ejemplo, el contenido de ghdl_ug, después de clonar el repo umarcor/MSEA y de haber cambiado algunos ficheros.

Una opción es `git checkout path/al/directorio/o/fichero`. Así se revertirán esos ficheros en concreto.

Otra opción es `git reset --hard origin/main`. Eso deshará todos los cambios (incluidos commits) y, como el nombre indica, hará un reset para estar exactamente tal como indique la rama `main` del repositorio.

En general, ante la duda, os recomiendo volver a clonar el repositorio. Aunque no es lo recomendable desde el punto de vista del uso de git, en este caso git no es un objetivo del curso. Clonar es simplemente una alternativa a descargar el zip/tarball y descomprimirlo.

De hecho, en general, recomiendo empezar con un clone nuevo cuando vayáis a hacer las tareas para el próximo día, ya que he subido unas correcciones.
