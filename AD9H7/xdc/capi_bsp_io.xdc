############################################################################
############################################################################
##
## Copyright 2018 International Business Machines
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############################################################################
############################################################################

# Alpha Data 9H7 I/O constraints
# Reference: ADM-PCIE-9H7 User Manual - Document Revision 1.3

## PCIe #########################################################

## RST ###########################
# Page 7
set_property IOSTANDARD LVCMOS18 [get_ports pci_pi_nperst0]
# Page 12
set_property PACKAGE_PIN BF41 [get_ports pci_pi_nperst0]
# Not sure about this one
# set_property PULLUP true [get_ports *pci_pi_nperst0]

## CLK ###########################
# Page 33
set_property PACKAGE_PIN AR14 [get_ports pci_pi_refclk_n]
set_property PACKAGE_PIN AR15 [get_ports pci_pi_refclk_p]

## PCIE LANES ####################
# package_pin for pcie lanes are specified by the location of the IP

#Flash Interface
set_property PACKAGE_PIN AG30 [get_ports {spi_miso_secondary}]
set_property PACKAGE_PIN AF30 [get_ports {spi_mosi_secondary}]
set_property PACKAGE_PIN AV30 [get_ports {spi_cen_secondary}]
set_property IOSTANDARD LVCMOS18 [get_ports {spi_miso_secondary}]
set_property IOSTANDARD LVCMOS18 [get_ports {spi_mosi_secondary}]
set_property IOSTANDARD LVCMOS18 [get_ports {spi_cen_secondary}]

#set_property PACKAGE_PIN AJ28 [get_ports {refclk100M}]
#set_property PACKAGE_PIN AE8 [get_ports {fpga_flash_ce1_l}]
#set_property PACKAGE_PIN AV30 [get_ports {fpga_flash_ce2_l}]
#set_property PACKAGE_PIN AB8 [get_ports {fpga_flash_dq0}]
#set_property PACKAGE_PIN AD8 [get_ports {fpga_flash_dq1}]
#set_property PACKAGE_PIN Y8  [get_ports {fpga_flash_dq2}]
#set_property PACKAGE_PIN AC8 [get_ports {fpga_flash_dq3}]
#set_property PACKAGE_PIN AF30 [get_ports {fpga_flash_dq4}]
#set_property PACKAGE_PIN AG30 [get_ports {fpga_flash_dq5}]
#set_property PACKAGE_PIN AF28 [get_ports {fpga_flash_dq6}]
#set_property PACKAGE_PIN AG28 [get_ports {fpga_flash_dq7}]
