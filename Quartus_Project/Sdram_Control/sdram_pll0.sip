set_global_assignment -entity "sdram_pll0" -library "lib_sdram_pll0" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "sdram_pll0" -library "lib_sdram_pll0" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "sdram_pll0" -library "lib_sdram_pll0" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_sdram_pll0" -name SPD_FILE [file join $::quartus(sip_path) "sdram_pll0.spd"]

set_global_assignment -library "lib_sdram_pll0" -name MISC_FILE [file join $::quartus(sip_path) "sdram_pll0_sim/sdram_pll0.vo"]
