# Teoría

- Introducción a librerías (frameworks) para simulación/verificación de diseños VHDL (>= 2008): VUnit y OSVVM.
- Transición de m/C/Python a VHDL mediante desarrollo guiado por pruebas (test-driven development, TDD): gestión de tests e integración continua con VUnit y GHDL (o ModelSim/QuestaSim).
  - Modelado de sistemas en VHDL mediante tipos real y los paquetes de coma fija y coma flotante de VHDL.
  - Co-simulación de VHDL y C/C++/Python mediante la interfaz VHPIDIRECT de GHDL.

# Prácticas

- Instalación y setup de VUnit y GHDL. Ejecución y análisis de ejemplos existentes.
- Co-simulación y test SW/HW de un SoC con un núcleo IP con interfaces AXI, utilizando la Verification Component Library de VUnit.

# Materiales de uso obligatorio

- Instalación de MSYS2: [msys2.org: Installation](https://www.msys2.org/#installation)
- GHDL:
  - [Quick Start Guide » Simulation](https://ghdl.github.io/ghdl/quick_start/simulation/index.html)
- VUnit:
  - [User Guide](http://vunit.github.io/user_guide.html#user-guide)
  - [Command Line Interface](http://vunit.github.io/cli.html)
  - [Verification Component Library](http://vunit.github.io/verification_components/user_guide.html)
  - Example [Array and AXI4 Stream Verification Components](https://github.com/VUnit/vunit/tree/master/examples/vhdl/array_axis_vcs/)
- Co-simulation with GHDL: [ghdl.github.io/ghdl-cosim](https://ghdl.github.io/ghdl-cosim/)
  - VHPIDIRECT examples 'Constrained multidimensional arrays of doubles/reals' and 'Array and AXI4 Stream Verification Components': [ghdl.github.io/ghdl-cosim/vhpidirect/examples](https://ghdl.github.io/ghdl-cosim/vhpidirect/examples)

# Bibliografía

- Documentación de MSYS2: [msys2.org](https://www.msys2.org/)
- Documentación de VUnit: [vunit.github.io](http://vunit.github.io)
- Documentación de GHDL: [ghdl.github.io/ghdl](https://ghdl.github.io/ghdl)
- Documentación de Bash: [gnu.org/software/bash/manual](https://www.gnu.org/software/bash/manual/)
- Página de OSVVM: [osvvm.org/about-os-vvm](https://osvvm.org/about-os-vvm)
