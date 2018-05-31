#!/bin/sh 


# CPU Hotplug (CPU-0 Power UP)

echo 1 > /sys/devices/system/cpu/cpu1/online
sleep 1

# CPU Frequency scaling up
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# USB 3.0 Power Power Up

echo 0 > /sys/devices/platform/xhci-hcd/usb2/power/state
sleep 1

# USB 2.0 Power Power Up

echo 0 > /sys/devices/platform/dwc_otg.0/power/state
sleep 1
echo 0 > /sys/devices/platform/dwc_otg.0/usb3/power/state
sleep 1

# SPI Power Power Up

echo 0 > /sys/devices/platform/comcerto_spi.0/power/state
sleep 1

# Ethernet Power Power Up

ifconfig eth0 up
sleep 3
ifconfig eth1 up
sleep 3
ifconfig eth2 up
sleep 3

# Ethernet PHY Power Power Up
# Ethernet PHY Power Up sequence is given for reference for C2K EVM Boards.
# It needs to be changed according to the actual device and interface name present on the board.

echo 0 > /sys/bus/mdio_bus/devices/comcerto-0\:04/power/state
sleep 1
#echo 0 > /sys/bus/mdio_bus/devices/comcerto-0\:05/power/state
#sleep 1


# SLIC (Zarlink) Power Up
# SLIC Power Upsequence is given for reference for C2K EVM Boards.
# It needs to be changed according to the actual device and interface name present on the board.

echo 0 > /sys/devices/platform/comcerto_spi.0/spi_master/spi0/power/state
sleep 1

# Elliptic Eng Power Up

echo 0 >/sys/devices/platform/Elliptic-EPN1802.0/power/state
sleep 1


# DPI Epavis Content inspection engine core Power Up

echo 0 >/sys/devices/platform/lc_cie/power/state
sleep 1

# DPI Decompression engine Power Up

echo 0 >/sys/devices/platform/lc_decomp/power/state
sleep 1


# SATA Power Up

echo 0 >/sys/devices/platform/ahci/power/state
sleep 1


# I2C Power Up

echo 0 >/sys/devices/platform/comcerto_i2c/power/state
sleep 1


# WiFi Power Power Up
# WiFi Power Up sequence is given for reference for C2K EVM Boards.
# It needs to be changed according to the actual device and interface name present on the board.

#echo 0 > /sys/bus/pci/devices/0000\:00\:00.0/power/state
#ifconfig ath0 up
#sleep 5

# PCIe Power Power Up
# PCIe Power Up sequence is given for reference for C2K EVM Boards.
# It needs to be changed according to the correct VAP devicee present.

echo 0 >/sys/devices/platform/pcie.0/power/state
sleep 2
echo 0 >/sys/devices/platform/pcie.1/power/state
sleep 2
# ifconfig   <VAP devices>  up




