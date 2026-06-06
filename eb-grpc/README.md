# EtherBone co-simulation using VHPIDIRECT and gRPC

```sh
# First, build DBHI/gRPC resources `server`, `libgrpc-go.so` and `libgrpc-go.h`:
cd dbhi-grpc
docker build -t dbhi/grpc - < Dockerfile
docker run --rm -v $(pwd):/wrk -w /wrk dbhi/grpc make all
cd ..

# Then, build the `manager` and `unit` clients in VHDL using foreign C, and test them along with the server:
docker run --rm -t -v $(pwd):/wrk -w /wrk ghcr.io/hdl/debian/bookworm/sim/osvb sh -c './run.py -v && ./cosim.py -v; ./test.sh'
```

## References

- [gh:dbhi/gRPC](https://github.com/dbhi/gRPC)
