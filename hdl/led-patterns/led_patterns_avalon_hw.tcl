# TCL File Generated by Component Editor 22.1
# Fri Oct 04 10:19:44 MDT 2024
# DO NOT MODIFY


# 
# led_patterns_avalon "led_patterns_avalon" v1.0
# Dirk Kaiser 2024.10.04.10:19:44
# Component to instantiate LED_patterns and create registers for HPS to interact with
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module led_patterns_avalon
# 
set_module_property DESCRIPTION "Component to instantiate LED_patterns and create registers for HPS to interact with"
set_module_property NAME led_patterns_avalon
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Dirk Kaiser"
set_module_property DISPLAY_NAME led_patterns_avalon
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL led_patterns_avalon
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file async_conditioner.vhd VHDL PATH ../async-conditioner/async_conditioner.vhd
add_fileset_file debouncer.vhd VHDL PATH ../async-conditioner/debouncer.vhd
add_fileset_file one_pulse.vhd VHDL PATH ../async-conditioner/one_pulse.vhd
add_fileset_file clock_gen.vhd VHDL PATH ./clock_gen.vhd
add_fileset_file down_counter.vhd VHDL PATH ./down_counter.vhd
add_fileset_file flash.vhd VHDL PATH ./flash.vhd
add_fileset_file led_patterns.vhd VHDL PATH ./led_patterns.vhd
add_fileset_file up_counter.vhd VHDL PATH ./up_counter.vhd
add_fileset_file walking_one.vhd VHDL PATH ./walking_one.vhd
add_fileset_file walking_two.vhd VHDL PATH ./walking_two.vhd
add_fileset_file synchronizer.vhd VHDL PATH ../synchronizer/synchronizer.vhd
add_fileset_file led_patterns_avalon.vhd VHDL PATH ./led_patterns_avalon.vhd TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave avs_address address Input 2
add_interface_port avalon_slave avs_read read Input 1
add_interface_port avalon_slave avs_readdata readdata Output 32
add_interface_port avalon_slave avs_write write Input 1
add_interface_port avalon_slave avs_writedata writedata Input 32
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point export
# 
add_interface export conduit end
set_interface_property export associatedClock clock
set_interface_property export associatedReset reset
set_interface_property export ENABLED true
set_interface_property export EXPORT_OF ""
set_interface_property export PORT_NAME_MAP ""
set_interface_property export CMSIS_SVD_VARIABLES ""
set_interface_property export SVD_ADDRESS_GROUP ""

add_interface_port export push_button push_button Input 1
add_interface_port export led led Output 8
add_interface_port export switches switches Input 4


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset rst reset Input 1

