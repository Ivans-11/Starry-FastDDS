### Install Musl Toolchain

1. Download files from https://github.com/arceos-org/setup-musl/releases/tag/prebuilt
2. Extract to some path, for example `/opt/riscv64-linux-musl-cross`
3. Add bin folder to `PATH`, for example:
   ```bash
   $ export PATH=/opt/riscv64-linux-musl-cross/bin:$PATH
   ```

### Build
```bash
git clone --recursive https://github.com/Ivans-11/Starry-FastDDS.git
cd Starry-FastDDS
make

make example hello_world
make load ./Fast-DDS/examples/cpp/hello_world/build/hello_world
```


