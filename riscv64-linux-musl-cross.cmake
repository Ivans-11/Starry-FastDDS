# riscv64_toolchain.cmake
if (NOT DEFINED ARCH)
    set(ARCH riscv64)
endif()
if (NOT DEFINED CROSS_PATH)
    set(CROSS_PATH /opt/${ARCH}-linux-musl-cross)
endif()

message(STATUS "Using ARCH: ${ARCH}")
message(STATUS "Using CROSS_PATH: ${CROSS_PATH}")

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${ARCH})

# Compiler
set(CMAKE_C_COMPILER   ${CROSS_PATH}/bin/${ARCH}-linux-musl-gcc)
set(CMAKE_CXX_COMPILER ${CROSS_PATH}/bin/${ARCH}-linux-musl-g++)

# Tools
set(CMAKE_AR            ${CROSS_PATH}/bin/${ARCH}-linux-musl-ar)
set(CMAKE_NM            ${CROSS_PATH}/bin/${ARCH}-linux-musl-nm)
set(CMAKE_RANLIB        ${CROSS_PATH}/bin/${ARCH}-linux-musl-ranlib)
set(CMAKE_STRIP         ${CROSS_PATH}/bin/${ARCH}-linux-musl-strip)
set(CMAKE_OBJDUMP       ${CROSS_PATH}/bin/${ARCH}-linux-musl-objdump)
set(CMAKE_SIZE          ${CROSS_PATH}/bin/${ARCH}-linux-musl-size)

# sysroot
set(CMAKE_SYSROOT ${CROSS_PATH}/${ARCH}-linux-musl)

# Search paths
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Linker
set(CMAKE_LINKER ${CROSS_PATH}/bin/${ARCH}-linux-musl-ld)

