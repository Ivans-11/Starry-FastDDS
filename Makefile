ROOT_PATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
INSTALL_DIR := $(ROOT_PATH)/install
TOOLCHAIN := $(ROOT_PATH)/riscv64-linux-musl-cross.cmake
CMAKE_FLAGS := -DCMAKE_TOOLCHAIN_FILE=$(TOOLCHAIN)

# Third-party library directories
FOONATHAN_DIR := $(ROOT_PATH)/foonathan_memory_vendor
FASTCDR_DIR := $(ROOT_PATH)/Fast-CDR
TINYXML2_DIR := $(ROOT_PATH)/tinyxml2
FASTDDS_DIR := $(ROOT_PATH)/Fast-DDS
STARRYOS_DIR := $(ROOT_PATH)/StarryOS

EXAMPLES_DIR := $(FASTDDS_DIR)/examples/cpp

# Default target
.PHONY: all
all: foonathan fastcdr tinyxml2 fastdds img

# Build the third-party libraries
.PHONY: foonathan
foonathan:
	mkdir -p $(FOONATHAN_DIR)/build
	cd $(FOONATHAN_DIR)/build && \
	cmake $(FOONATHAN_DIR) -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) $(CMAKE_FLAGS)
	cmake --build $(FOONATHAN_DIR)/build --target install

.PHONY: fastcdr
fastcdr:
	mkdir -p $(FASTCDR_DIR)/build
	cd $(FASTCDR_DIR)/build && \
	cmake $(FASTCDR_DIR) -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) $(CMAKE_FLAGS)
	cmake --build $(FASTCDR_DIR)/build --target install

.PHONY: tinyxml2
tinyxml2:
	mkdir -p $(TINYXML2_DIR)/build
	cd $(TINYXML2_DIR)/build && \
	cmake $(TINYXML2_DIR) -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) $(CMAKE_FLAGS)
	cmake --build $(TINYXML2_DIR)/build --target install

.PHONY: fastdds
fastdds:
	mkdir -p $(FASTDDS_DIR)/build
	cd $(FASTDDS_DIR)/build && \
	cmake $(FASTDDS_DIR) -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) \
		-DTHIRDPARTY_Asio=FORCE \
		-DCMAKE_EXE_LINKER_FLAGS="-latomic" \
		-DCMAKE_SHARED_LINKER_FLAGS="-latomic" \
		$(CMAKE_FLAGS)
	cmake --build $(FASTDDS_DIR)/build --target install

# Create the StarryOS disk image and copy built libraries
.PHONY: img
img:
	@if [ ! -f "$(STARRYOS_DIR)/arceos/disk.img" ]; then \
		echo "disk.img not found, building StarryOS image..."; \
		cd $(STARRYOS_DIR) && make img; \
	else \
		echo "disk.img already exists"; \
	fi
	sudo mkdir -p /mnt/disk
	sudo mount -o loop $(STARRYOS_DIR)/arceos/disk.img /mnt/disk
	sudo cp -r $(INSTALL_DIR)/* /mnt/disk/usr/local/
	sudo cp -r /opt/riscv64-linux-musl-cross/riscv64-linux-musl/lib/* /mnt/disk/lib/
	sudo umount /mnt/disk

# Build an example application
.PHONY: example
example:
ifndef A
	$(error A is not set. Usage: make example A=<value>)
endif
	mkdir -p $(EXAMPLES_DIR)/$(A)/build
	cd $(EXAMPLES_DIR)/$(A)/build && \
	cmake $(EXAMPLES_DIR)/$(A) -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) $(CMAKE_FLAGS)
	cmake --build $(EXAMPLES_DIR)/$(A)/build

# Load a file into disk image
.PHONY: load
load:
ifndef A
	$(error A is not set. Usage: make load A=<path>)
endif
	sudo mkdir -p /mnt/disk
	sudo mount -o loop $(STARRYOS_DIR)/arceos/disk.img /mnt/disk
	sudo cp ${A} /mnt/disk/root/
	sudo umount /mnt/disk

# Clean up build artifacts and installation directory
.PHONY: clean
clean:
	rm -rf $(FOONATHAN_DIR)/build $(FASTCDR_DIR)/build $(TINYXML2_DIR)/build $(FASTDDS_DIR)/build
	rm -rf $(INSTALL_DIR)

.PHONY: run
run:
	cd $(STARRYOS_DIR) && make run