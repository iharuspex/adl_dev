#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. $SCRIPT_DIR/ask.sh

if ask "Do you want to flash board?" N; then
    pyocd load apps/app_microbit_v1/bin/app_microbit_v1.elf -t nrf51822
else
    echo "Exiting..."
fi