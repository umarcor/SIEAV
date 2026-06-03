.PHONY: all manager unit

DIST=dbhi-grpc/dist

all: manager unit
manager: $(DIST)/ghdl-manager
unit: $(DIST)/ghdl-unit

CLIBS=$(DIST)/libgrpc-go.so $(DIST)/libgrpc-go.h test/dbhi-grpc.h

define tb_build
mkdir -p build && \
cd build && \
ghdl -a --std=08 ../$< && \
ghdl --bind --std=08 tb_$(TNAME) && \
gcc -o ghdl-$(TNAME) ../test/$(TNAME).c -I../$(DIST) -L../$(DIST) -lgrpc-go -Wl,`ghdl --list-link tb_$(TNAME)` && \
mv ghdl-$(TNAME) ../$(DIST) && \
cd ..  && \
rm -rf build
endef
# TODO: Find equivalent syntax to use `ghdl -e` instead of `--bind` and `--list-link`.
# ghdl -e -o ghdl-$(TNAME) -Wl,../$(TNAME).c ???? tb_$(TNAME)

$(DIST)/ghdl-manager: test/tb_manager.vhd test/manager.c $(CLIBS)
	$(eval TNAME = manager)
	$(tb_build)

$(DIST)/ghdl-unit: test/tb_unit.vhd test/unit.c $(CLIBS)
	$(eval TNAME = unit)
	$(tb_build)
