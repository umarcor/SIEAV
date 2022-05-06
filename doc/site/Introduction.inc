.. _Intro:

About
=====

This repository and documentation contain resources used in some sessions of the "*Cosimulation for verification of
systems on FPGAs*" (in spanish, "*Cosimulación para la verificación de sistemas sobre FPGAs*") course unit taught in the
`Master on Advanced Electronic Systems (in spanish, Máster en Sistemas Electrónicos Avanzados) <https://www.ehu.eus/es/web/master/master-sistemas-electronicos-avanzados>`__
at the `University of the Basque Country (UPV/EHU) <https://www.ehu.eus>`__.
Find the syllabus:
`2019/2020 <https://www.ehu.eus/es/web/master/master-sistemas-electronicos-avanzados/materia?p_anyo_ofd=20190&p_anyo_pop=20170&p_cod_centro=345&p_cod_materia=9117&p_cod_asignatura=504738&p_tipo_asignatura=1>`__,
`2020/2021 <https://www.ehu.eus/es/web/master/master-sistemas-electronicos-avanzados/materia?p_anyo_ofd=20200&p_anyo_pop=20170&p_cod_centro=345&p_cod_materia=9117&p_cod_asignatura=504738&p_tipo_asignatura=1>`__,
`2021/2022 <https://www.ehu.eus/es/web/master/master-sistemas-electronicos-avanzados/materia?p_anyo_ofd=20210&p_anyo_pop=20170&p_cod_centro=345&p_cod_materia=9117&p_cod_asignatura=504738&p_tipo_asignatura=1>`__.

.. |Logo:EHU| image:: _static/ehu.png
   :alt: UPV/EHU
   :height: 100 px
   :target: https://www.ehu.eus

.. |Logo:GDED| image:: _static/gded.png
   :alt: Grupo de Investigación de Diseño en Electrónica Digital (GDED)
   :height: 100 px
   :target: https://www.ehu.eus/gded

.. |nbsp| unicode:: 0xA0

.. centered:: |Logo:EHU| |nbsp| |nbsp| |nbsp| |nbsp| |Logo:GDED|

.. raw:: html

    <br>

.. IMPORTANT::
  These sessions are a follow-up of the course unit "*Design of digital controllers with FPGAs*" (in spanish, "*Diseño
  de controladores digitales con FPGAs*") taught in the same master degree (`2021/2022 <https://www.ehu.eus/es/web/master/master-sistemas-electronicos-avanzados/materia?p_anyo_ofd=20210&p_anyo_pop=20170&p_cod_centro=345&p_cod_materia=9120&p_cod_asignatura=504740&p_tipo_asignatura=1>`__).
  Hence, attendants are expected to have prior knowledge about the fundamentals of control theory (discretization of
  state-space representation and transfer-functions, sampling and PID algorithms/implementations).
  Nonetheless, these sessions are focused on VHDL language features, not on control.

.. NOTE::
  The course is taught in spanish and/or basque (for now); so, some references might not be available in english (yet).
  Still, most of the documentation and code examples should be readable to any english speaker.
  Should you find any issue in this regard, please :gh:`let us know <umarcor/SIEAV/issues/new>`!

Introduction
============

This part of the course is focused on using Free/Libre and Open Source Software (`FLOSS <https://www.gnu.org/philosophy/floss-and-foss.en.html>`__)
tools for hardware-software co-design with
:doc:`VHDL <vasg:index>`,
C/C++,
and
`Python <https://www.python.org/>`__,
`Matlab <https://www.mathworks.com/products/matlab.html>`__,
and/or
`Octave <https://www.gnu.org/software/octave/index>`__.
A methodology based on co-simulation interfaces, mixed-language Verification Components (VCs) and digital twins is
introduced (see
:wikipedia:`wikipedia: Functional verification <Functional_verification>`,
:wikipedia:`wikipedia: Digital twin <Digital_twin>`
and :wikipedia:`Co-simulation`,
respectively).

For now, synthesis and automatic documentation generation are not included in this course.
However, references to FLOSS projects (such as
:doc:`OSVB <osvb:index>`,
:doc:`EDA² <edaa:index>`,
`F4PGA <https://f4pga.org/>`__ (formerly known as `SymbiFlow <https://github.com/SymbiFlow>`__),
`Renode <https://renode.io/>`__,
etc.
) are provided throughout the documentation.
