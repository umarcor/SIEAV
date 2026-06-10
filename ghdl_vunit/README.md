# Examples from [ghdl.github.io/ghdl » Quick Start Guide » Simulation](https://ghdl.github.io/ghdl/quick_start/simulation)

## *Hello world* program

As explained in [*Hello world* program](https://ghdl.github.io/ghdl/quick_start/simulation/hello):

```sh
ghdl -a hello.vhd

ghdl -e hello_world

./hello_world
```

Remarks:

- Analyse accepts files.
- Elaborate requires an entity name.
- With mcode backend, no binary is generated.
- On GNU/Linux, the binary does not have an extension.

## *Heartbeat* module

As explained in [*Heartbeat* module](https://ghdl.github.io/ghdl/quick_start/simulation/heartbeat):

```sh
ghdl -a heartbeat.vhdl

ghdl -e heartbeat

./heartbeat

./heartbeat --wave=wave.ghw

gtkwave wave.ghw
```

Remarks:

- The simulation does not terminate.
- GTKWave is opened after the simulation is finished (we do that explicitly).

ATTENTION: If the simulation is executed through `ghdl -r ...`, when using LLVM/GCC backends, Ctrl+C might terminate GHDL
but not the underlying (and running) executable. Therefore, the waveform will grow non-stop. We might need to find the
`heartbeat` task (`tasklist | grep heartbeat`) and kill it. Note that this is precisely done for didactic purposes. The next example explains how to do
it properly.

## *Full adder* module and testbench

As explained in [*Full adder* module and testbench](https://ghdl.github.io/ghdl/quick_start/simulation/adder):

```sh
ghdl -a adder.vhd
ghdl -a tb_adder.vhd
ghdl -e tb_adder
./tb_adder

./tb_adder --wave=wave.ghw
gtkwave wave.ghw
```

Remarks:

- VHDL 2008 provides a programatic procedure in the standard library for finalising the execution and producing an specific exit code.
- GHDL allows specifying the maximum simulation time through the CLI; see [--stop-time](https://ghdl.github.io/ghdl/using/Simulation.html#cmdoption-ghdl-stop-time).
- VUnit provides an optional watchdog timer: [The VUnit Watchdog](http://vunit.github.io/run/user_guide.html?#the-vunit-watchdog).

### Executing the full adder example through VUnit

```sh
python vunit_run.py -l

export VUNIT_SIMULATOR=ghdl
python vunit_run.py -v
python vunit_run.py -v -g

export VUNIT_SIMULATOR=modelsim
python vunit_run.py -v
python vunit_run.py -v -g
```

Remarks:

- Explore the content of `vunit_out`.
- Testbenches are not used if they don't have the expected generic or naming.
- Integration with GTKWave is built-in.
- Switching between simulators is a matter of changing an environment variable.

NOTE: although `vunit_run.py` and `tb_adder_vunit.vhd` are provided here, readers are encouraged to trying writing them on their own, by reading the [VUnit User Guide](http://vunit.github.io/user_guide.html).
