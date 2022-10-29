
# FPGA-based ISA Sound Card


Warning: Please don't build this yet. It's not 100% done, and no PCBs have been ordered yet.


The idea here is to leverage the Sound Blaster 16 and OPL Verilog from the ao486 project to use on an ISA card.
In theory, it shouldn't take too much effort to adapt that logic to run on a "real" ISA bus, but I may be speaking too soon. lol


(ao486 and OPL3 cores by Aleksander Osman. Improvements by Sorgelig, Robert Piep, and many others.) 


This version is using the Cyclone IV module from QMtech...

https://www.aliexpress.com/item/32949281189.html

This is mainly due to the current chip shortage, and there aren't many of the QMtech boards left in stock either.

If/when the chip shortage improves, the FPGA can be put directly onto the ISA card.

There are some sellers on AliExpress who have the very same FPGA available, but their stock levels also might be quite low.

Using the QMtech board does save from having to do the BGA routing for the FPGA, and the routing for the SDRAM.
The modules also have switching regulators onboard, for the FPGA and 3V3 rails.

The SDRAM will be useful for trying my old Wavetable MIDI synth later.

Shoutout to the RMC crew on Discord. ;)


ElectronAsh
