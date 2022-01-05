#!/bin/bash
make clean
make uninstall
rm -rf $(pwd)/android
./build_config.sh armv7-a
./build_config.sh armv8-a
./build_config.sh x86
./build_config.sh x86_64