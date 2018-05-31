#!/bin/sh 


# CPU Hotplug (CPU-0 Power Off)

echo 0 > /sys/devices/system/cpu/cpu1/online
sleep 1

# CPU Frequency scaling down
echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# USB 3.0 Power Power Down

echo 2 > /sys/devices/platform/xhci-hcd/usb2/power/state
sleep 1

# USB 2.0 Power Power Down
echo 2 > /sys/devices/platform/dwc_otg.0/usb3/power/state
sleep 1
echo 2 > /sys/devices/platform/dwc_otg.0/power/state
sleep 1

# SPI Power Power Down

echo 2 > /sys/devices/platform/comcerto_spi.0/power/state
sleep 1

# Ethernet Power Power Down

ifconfig eth0 down
sleep 3
ifconfig eth1 down
sleep 3
ifconfig eth2 down
sleep 3

# Ethernet PHY Power Power Down
# Ethernet PHY Power Down sequence is given for reference for C2K EVM Boards.
# It needs to be changed according to the actual device and interface name present on the board.

echo 2 > /sys/bus/mdio_bus/devices/comcerto-0\:04/power/state
sleep 1
#echo 2 > /sys/bus/mdio_bus/devices/comcerto-0\:05/power/state
#sleep 1


# SLIC (Zarlink) Power Down
# SLIC Power Down sequence is given for reference for C2K EVM Boards.
# It needs to be changed according to the actual device and interface name present on the board.

echo 2 > /sys/devices/platform/comcerto_spi.0/spi_master/spi0/power/state
sleep 1

# Elliptic Eng Power Down

echo 2 >/sys/devices/platform/Elliptic-EPN1802.0/power/state
sleep 1


# DPI Epavis Content inspection engine core Power Down

echo 2 >/sys/devices/platform/lc_cie/power/state
sleep 1

# DPI Decompression engine Power Down

echo 2 >/sys/devices/platform/lc_decomp/power/state
sleep 1


# SATA Power Down

echo 2 >/sys/devices/platform/ahci/power/state
sleep 1


# I2C Power Down

echo 2 >/sys/devices/platform/comcerto_i2c/power/state
sleep 1


# WiFi Power Power Down
# WiFi Power Down sequence is given for reference for C2K EVM Boards.
# It needs to be changed according to the actual device and interface name present on the board.

#ifconfig ath0 down
#echo 2 > /sys/bus/pci/devices/0000\:00\:00.0/power/state
#sleep 5

# PCIe Power Power Down
# PCIe Power Down sequence is given for reference for C2K EVM Boards.
# It needs to be changed according to the correct VAP devicee present.

# ifconfig   <VAP devices>  down
echo 2 >/sys/devices/platform/pcie.0/power/state
sleep 2
echo 2 >/sys/devices/platform/pcie.1/power/state
sleep 2


