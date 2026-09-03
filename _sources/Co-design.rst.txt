.. _Co-design:

Hardware-software co-design
###########################

.. figure:: _static/img/software-hardware.png
   :width: 100%
   :align: center

   Summary of software-hardware co-execution solutions.

.. HINT::
  Hooking functions/instructions in binary applications:

  * :gh:`dbhi/binhook`
  * :gh:`beehive-lab/mambo`
  * :gh:`dynamorio/dynamorio`

  Use cases:

  * Running binaries with custom instructions on devices without hardware support.
  * Replacing software routines with hardware accelerators, without modifying application sources.
  * Switching drivers/implementations without recompiling the software application.

    * For instance, evaluating accelerators on target boards before the RTL is ready for synthesis.

* `NEORV32 User Guide: Adding Custom Hardware Modules <https://stnolting.github.io/neorv32/ug/#_adding_custom_hardware_modules>`__

* `NEORV32 Datasheet <https://stnolting.github.io/neorv32/>`__

  * `Stream Link Interface <https://stnolting.github.io/neorv32/#_stream_link_interface>`__

  * `Custom Functions Subsystem (CFS) <https://stnolting.github.io/neorv32/#_custom_functions_subsystem_cfs>`__

* :gh:`google/CFU-Playground`

  * `youtube: CFU Playground: Model-specific Acceleration on FPGAs - Timothy Callahan & Alan V. Green, Google <https://www.youtube.com/watch?v=_1yrxrl61o4>`__

.. figure:: _static/img/vboard.png
   :width: 100%
   :align: center

   :gh:`dbhi/vboard`: virtual development board for HDL design.

Co-execution platform options:

* Workstation/laptop (amd64)

  * Native

  * QEMU user mode

  * QEMU system mode

* Single Board Computer (SBC)
* FPGA board (PS only)
* FPGA board (PS and PL)
