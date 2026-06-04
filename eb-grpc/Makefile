.PHONY: all manager unit

DIST=dbhi-grpc/dist

all: manager unit
manager: $(DIST)/hdl-manager
unit: $(DIST)/hdl-unit

CLIBS=$(DIST)/libgrpc-go.so $(DIST)/libgrpc-go.h dbhi-grpc.h

$(DIST)/hdl-manager: manager.c $(CLIBS)
	gcc -o $@ $< -I$(DIST) -L$(DIST) -lgrpc-go

$(DIST)/hdl-unit: unit.c $(CLIBS)
	gcc -o $@ $< -I$(DIST) -L$(DIST) -lgrpc-go
