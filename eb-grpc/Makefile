.PHONY: all manager unit

DIST=dbhi-grpc/dist

all: manager unit
manager: $(DIST)/ghdl-manager
unit: $(DIST)/ghdl-unit

CLIBS=$(DIST)/libgrpc-go.so $(DIST)/libgrpc-go.h test/cosim/dbhi-grpc.h

define tb_build
mkdir -p build && \
cd build && \
ghdl -a --std=08 ../$< && \
ghdl -e --std=08 -o ghdl-$(TNAME) -Wl,../test/cosim/$(TNAME).c -Wl,-I../$(DIST) -Wl,-L../$(DIST) -Wl,-lgrpc-go tb_$(TNAME) && \
mv ghdl-$(TNAME) ../$(DIST) && \
cd ..  && \
rm -rf build
endef
# TODO: Ask Tristan (create issue in ghdl/ghdl) to support OPTION in `-Wl,<OPTION>` containing commas:
# -Wl,../test/cosim/$(TNAME).c,-I../$(DIST),-L../$(DIST),-lgrpc-go

$(DIST)/ghdl-manager: test/cosim/tb_manager.vhd test/cosim/manager.c $(CLIBS)
	$(eval TNAME = manager)
	$(tb_build)

$(DIST)/ghdl-unit: test/cosim/tb_unit.vhd test/cosim/unit.c $(CLIBS)
	$(eval TNAME = unit)
	$(tb_build)
