# Specify root clocks

# Main 50 MHz osc on the FPGA board...
create_clock -period "50.0 MHz"  [get_ports CLOCK_50]

# CLK on ISA bus is usually 8.00 to 8.33MHz, but some boards can set it as high as 12 MHz.
create_clock -period "12.0 MHz"  [get_ports CLK]

# Not sure if most motherboards have this OSC?
# Usually 14.31818 MHz, which is four times the NTSC Color Carrier freq.
create_clock -period "14.31818"  [get_ports OSC]


derive_pll_clocks
derive_clock_uncertainty
