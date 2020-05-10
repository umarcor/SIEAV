# Examples from [ghdl.rtfd.io » Quick Start Guide](https://ghdl.readthedocs.io/en/latest/quick_start/README.html)

## *Hello world* program

As explained in [ghdl.rtfd.io » Quick Start Guide » *Hello world* program](https://ghdl.readthedocs.io/en/latest/quick_start/hello/README.html):

```sh
ghdl -a hello.vhd

ghdl -e hello_world

./hello_world.exe
```

Notes:

- Analyse accepts files.
- Elaborate requires an entity name.
- With mcode backend, no binary is generated.
- On GNU/Linux, the binary does not have an extension.

## *Heartbeat* module

As explained in [ghdl.rtfd.io » Quick Start Guide » *Heartbeat* module](https://ghdl.readthedocs.io/en/latest/quick_start/heartbeat/README.html):

```sh
ghdl -a heartbeat.vhdl

ghdl -e heartbeat

./heartbeat.exe

./heartbeat.exe --wave=wave.ghw

gtkwave wave.ghw
```

Notes:

- The simulation does not terminate.
- GtkWave is opened after the simulation is finished.

## *Full adder* module and testbench

As explained in [ghdl.rtfd.io » Quick Start Guide » *Full adder* module and testbench](https://ghdl.readthedocs.io/en/latest/quick_start/adder/README.html):

```sh
ghdl -a adder.vhd
ghdl -a tb_adder.vhd
ghdl -e tb_adder
./tb_adder

./tb_adder.exe --wave=wave.ghw
gtkwave wave.ghw
```

Notes:

- VHDL 2008 provides a programatic procedure in the standard library.

---

```sh
export VUNIT_SIMULATOR=ghdl
python run.py -l
python run.py -v
python run.py -v -g

export VUNIT_SIMULATOR=modelsim
python run.py -v
python run.py -v -g
```

Notes:

- Explore the content of `vunit_out`.
- Testbenches are not used if they don't have the expected generic.
- Integration with GtkWave is built-in.
- Switching between simulators is a matter of changing an environment variable.
