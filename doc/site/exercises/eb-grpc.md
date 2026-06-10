# EtherBone (Wishbone over Ethernet) cosimulation with gRPC

subdir {ghsrc}`eb-grpc`

```sh
# First, build DBHI/gRPC resources `server`, `libgrpc-go.so` and `libgrpc-go.h`:
cd dbhi-grpc
docker build -t dbhi/grpc - < Dockerfile
docker run --rm -v $(pwd):/wrk -w /wrk dbhi/grpc make all
cd ..

# Then, build the `manager` and `unit` clients in VHDL using foreign C, and test them along with the server:
docker run --rm -t -v $(pwd):/wrk -w /wrk ghcr.io/hdl/debian/bookworm/sim/osvb sh -c './run.py -v && ./cosim.py -v; ./test.sh'
```

*TBC*

## References

- [gh:dbhi/gRPC](https://github.com/dbhi/gRPC)

- [oshw:etherbone-core](https://ohwr.org/projects/etherbone-core/)
- [gl:ohwr/etherbone-core](https://gitlab.com/ohwr/project/etherbone-core)

- [ohwr:wr-nic](https://ohwr.org/projects/wr-nic/)

- [addi.ehu.es/handle/10810/79455: A low-latency, lightweight EtherBone core for data communication in synchronized sensor networks](https://addi.ehu.es/handle/10810/79455)
- [journals.aps.org/prab/abstract/10.1103/PhysRevSTAB.15.082801: Open borders for system-on-a-chip buses: A wire format for connecting large physics controls](https://journals.aps.org/prab/abstract/10.1103/PhysRevSTAB.15.082801)
- [inis.iaea.org/records/1eg3q-jg233: ETHERBONE - a network layer for the wishbone SoC bus](https://inis.iaea.org/records/1eg3q-jg233)
- [icalepcs2011/talks/webhmult03: EtherBone – A Network Layer for the Wishbone SoC Bus](https://proceedings.jacow.org/icalepcs2011/talks/webhmult03_talk.pdf)

- https://mithro-wishbone-utils.readthedocs.io/en/latest/libeb-c.html
- https://workshop.fomu.im/en/latest/renode-bridge.html
- https://renode.readthedocs.io/en/latest/tutorials/fomu-example.html
- https://renode.io/news/renode-with-etherbone-support/

- https://wiki.gsi.de/TOS/Timing/TimingSystemHowBuildingDeployment
- https://cateee.net/lkddb/web-lkddb/USB_SERIAL_WISHBONE.html
