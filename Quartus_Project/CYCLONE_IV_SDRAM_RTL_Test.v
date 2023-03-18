//=======================================================
//  	QMTECH SDRAM Test Program
//=======================================================

module CYCLONE_IV_SDRAM_RTL_Test(
	///////// Input CLOCK /////////
	input             CLOCK_50,

	///////// DRAM /////////
	output    [12:0]	DRAM_ADDR,
	output    [1:0] 	DRAM_BA,
	output            DRAM_CAS_N,
	output          	DRAM_CKE,
	output            DRAM_CLK,
	output        		DRAM_CS_N,
	inout     [15:0]	DRAM_DQ,
	output            DRAM_LDQM,
	output            DRAM_RAS_N,
	output            DRAM_UDQM,
	output            DRAM_WE_N,

	///////// KEYs /////////
	input [1:0]      	KEY,

	///////// LEDR /////////
	output      		LEDR,

	input       		CLK15_6P,	// Both were grounded on U8 on the proto PCBs. Oops.
	input       		CLK14_6N,

	// ISA Bus...
	input       		RES_DRV,		// Active-HIGH Reset input from the ISA bus / PC.
	input       		OSC,
	input       		CLK,

	inout [15:0]		SD,

	input [19:0]		SA,			// (SA[19:16] are input-only on the card).
	input [23:17]		LA,

	inout       		SD70_DIR,
	inout       		SD158_DIR,

	inout       		SA158_DIR,	// (SA[19:16] are input-only on the card).
	inout       		LA_DIR,

	input       		IOR_N,
	input       		IOW_N,
	input       		MEMR_N,
	input       		MEMW_N,
	input       		SMEMR_N,
	input       		SMEMW_N,

	input       		IOCS16_N,				
	input       		MEMCS16_N,

	input       		SBHE,
	input       		BALE,
	input       		AEN,

	input       		TC,
	input       		IOCHK,
	input       		IOCHRDY,
	input       		REFRESH_N,
	input       		ZERO_WAIT,
	input       		MASTER_N,

	output       		DRQ_HI_TRIG_N,
	output [2:0]		DRQ_HI_SEL,

	output       		DRQ_LO_TRIG_N,
	output [2:0]		DRQ_LO_SEL,

	input       		DACK0_N,
	input       		DACK1_N,
	input       		DACK2_N,
	input       		DACK3_N,
							// No DACK4_N.
	input       		DACK5_N,
	input       		DACK6_N,
	input       		DACK7_N,

	output       		IRQ_HI_TRIG_N,
	output [2:0]		IRQ_HI_SEL,

	output       		IRQ_LO_TRIG_N,
	output [2:0]		IRQ_LO_SEL,

	// Joystick ADC, and button inputs...
	output       		JOY_CLK,
	output       		JOY_CS_N,
	output       		JOY_DIN,
	input       		JOY_DOUT,
	input       		JOY_B1,
	input       		JOY_B2,
	input       		JOY_B3,
	input       		JOY_B4,

	input       		MIDI_RXD,
	output       		MIDI_TXD,

	output       		I2S_SCK,
	output       		I2S_BCK,
	output       		I2S_LRCK,
	
	output       		DAC_DIN,		// Output to the DAC.
	input       		ADC_DOUT,	// Input from the ADC.

	inout       		SPARE_F1,
	inout       		SPARE_F2,
	inout       		SPARE_A3
);


PLL01 u0(
	.areset(1'b0),
	.inclk0(CLOCK_50),
	.c0(clk_mpu),
	.locked()
);
wire clk_mpu;

//wire clk_sys = CLOCK_50;
wire clk_sys = CLK;


//assign LEDR = 1'b1;


reg [15:0] reset_cnt;
initial reset_cnt = 16'hffff;
always @(posedge CLOCK_50 or posedge RES_DRV)
if (RES_DRV) reset_cnt <= 16'hffff;
else if (reset_cnt>0) reset_cnt <= reset_cnt - 1'd1;

wire MRESET_N = reset_cnt==0;


reg ior_n_reg;
reg iow_n_reg;
reg bale_reg;
reg [15:0] sd_reg;
reg [19:0] sa_reg;
reg [6:0] la_reg;
reg [19:0] addr_lat;

reg dack1_n_reg;
reg dack5_n_reg;

(*keep*)wire bale_falling = !BALE & bale_reg;
(*keep*)wire ior_n_falling = !IOR_N & ior_n_reg;
(*keep*)wire ior_n_rising = IOR_N & !ior_n_reg;

(*keep*)wire iow_n_falling = !IOW_N & iow_n_reg;
(*keep*)wire iow_n_rising = IOW_N & !iow_n_reg;

always @(posedge clk_sys) begin
	ior_n_reg <= IOR_N;
	iow_n_reg <= IOW_N;
	bale_reg <= BALE;
	sd_reg <= SD;
	if (bale_falling) sa_reg <= SA;
	if (bale_falling) la_reg <= LA;
	
	dack1_n_reg <= DACK1_N;
	dack5_n_reg <= DACK5_N;
end


(*keep*)wire [15:0] io_addr = sa_reg[15:0];

(*keep*)wire joy_cs = (io_addr == 16'h0201) && !AEN;
(*keep*)wire sb_cs  = (io_addr >= 16'h0220 && io_addr <= 16'h022f) && !AEN;
(*keep*)wire fm_cs  = (io_addr >= 16'h0388 && io_addr <= 16'h038b) && !AEN;
(*keep*)wire mpu_cs = (io_addr >= 16'h0330 && io_addr <= 16'h0331) && !AEN;

(*keep*)wire fm_mode = 1'b1;	// OPL3.
(*keep*)wire cms_en = 1'b0;	// Disable for now.

(*keep*)wire irq_5, irq_7, irq_10;

(*keep*)wire [15:0] iobus_writedata = sd_reg;
(*keep*)wire iobus_write = !iow_n_reg;

(*keep*)wire [7:0] sound_readdata;
(*keep*)wire iobus_read = !ior_n_reg;


// All of these have Pull-ups.
// If they are  High-Z, the signal direction will be A->B, or ISA->FPGA.
// Pull LOW, to allow output to the ISA bus.
//
//assign SD70_DIR = 1'bz;	// ISA Data bits [7:0]  DIRection.
//assign SD158_DIR = 1'bz;	// ISA Data bits [15:8] DIRection.
assign SA158_DIR = 1'bz;	// ISA Addr bits [15:8] DIRection. (SA[19:16] are input-only on the card).
assign LA_DIR = 1'bz;		// ISA Addr bits [23:17] DIRection.


wire bus_read = ((joy_cs | sb_cs | fm_cs | mpu_cs) & !IOR_N);
assign SD = (bus_read) ? {sound_readdata, sound_readdata} : (mpu_cs) ? {mpu_readdata, mpu_readdata} : 16'hzzzz;
assign SD70_DIR = !bus_read;	// Bring SD70_DIR LOW during a READ.
assign SD158_DIR = !bus_read;	// Bring SD158_DIR LOW during a READ.


// SBHE Low denotes a byte has been put on the upper 8 bits of the ISA Data bus.
// SBHE will generally be asserted during single-byte writes to an Odd address (like 0x389 for OPL), as well as for 16-bit writes.
//
// (probably don't need this for the Sound Blaster and OPL IO writes, since DMA gets the full 16-bit ISA Data bus anyway.
//  The ISA bus on my Pentium does duplicate odd-byte writes onto the Upper and Lower 16-bits, but do all ISA mobos do that? ElectronAsh.)
//
wire [7:0] sound_writedata = (!SBHE && addr_lat[0]) ? iobus_writedata[15:8] : iobus_writedata[7:0];
//wire [7:0] sound_writedata = iobus_writedata[7:0];


// IRQ_xx_SEL 0 = IRQ5.  LPT2.
// IRQ_xx_SEL 1 = IRQ6.  Floppy Drive.
// IRQ_xx_SEL 2 = IRQ7.  LPT1.
// IRQ_xx_SEL 3 = IRQ10. Reserved / Available?
// IRQ_xx_SEL 4 = IRQ11. Reserved / Available?
// IRQ_xx_SEL 5 = IRQ12. Mouse.
// IRQ_xx_SEL 6 = IRQ14. ATA.
// IRQ_xx_SEL 7 = IRQ15. ATA.
//
// A Low on a IRQ_xx_TRIG_N pin will assert a HIGH on the IRQ pin
//
assign IRQ_LO_SEL = 3'd0;
assign IRQ_LO_TRIG_N = !irq_5;

assign IRQ_HI_SEL = 3'd3;
assign IRQ_HI_TRIG_N = !irq_mpu;


// DRQ_xx_SEL 0 = DMA 0.
// DRQ_xx_SEL 1 = DMA 1 (typically for 8-bit sound DMA).
// DRQ_xx_SEL 2 = DMA 2
// DRQ_xx_SEL 3 = DMA 3
// DRQ_xx_SEL 4 = (not used).
// DRQ_xx_SEL 5 = DMA 5 (typically for 16-bit sound DMA).
// DRQ_xx_SEL 6 = DMA 6
// DRQ_xx_SEL 7 = DMA 7
//
// A Low on a DRQ_xx_TRIG_N pin will assert a HIGH on the DRQ pin
//
assign DRQ_LO_SEL = 3'd1;
assign DRQ_LO_TRIG_N = !dma_req8;

assign DRQ_HI_SEL = 3'd5;
assign DRQ_HI_TRIG_N = !dma_req16;


reg read_n_1;
reg write_n_1;
wire read_n_falling = read_n_1  && !IOR_N;
wire write_n_rising = !write_n_1 && IOW_N;
always @(posedge clk_sys) begin
	read_n_1 <= IOR_N;
	write_n_1 <= IOW_N;
end

wire [15:0] dma_readdata = SD;
//wire [15:0] dma_readdata = sd_reg;
wire [15:0] dma_writedata;
wire dma_req8;
wire dma_req16;

wire dma_ack = (!DACK1_N | !DACK5_N) && !IOW_N && AEN;
//wire dma_ack = (!dack1_n_reg | !dack5_n_reg) && !write_n_1 && AEN;


(*keep*)wire [15:0] sb_out_l, sb_out_r;

sound sound_inst
(
	.clk(clk_sys) ,					// input  clk
	.clock_rate( 28'd8_000_000 ) ,// input [27:0] clock_rate. (the frequency of the clk input, in Hz)
	
	.clk_opl(CLOCK_50) ,				// input  clk_opl
	
	.rst_n(MRESET_N) ,				// input  rst_n
	
	.irq_5(irq_5) ,					// output  irq_5
	.irq_7(irq_7) ,					// output  irq_7
	.irq_10(irq_10) ,					// output  irq_10
	
	.address(io_addr[3:0]) ,		// input [3:0] address
	
	.readdata(sound_readdata) ,	// output [7:0] readdata
	.read(iobus_read && (sb_cs | fm_cs)) ,				// input  read
	
	.writedata(sound_writedata) ,	// input [7:0] writedata
	.write(iobus_write && (sb_cs | fm_cs)) ,			// input  write
	
	.sb_cs(sb_cs) ,					// input  sb_cs
	
	.fm_cs(fm_cs) ,					// input  fm_cs
	.fm_mode(fm_mode) ,				// input  fm_mode
	
	.cms_en(cms_en) ,					// input  cms_en
	
	.dma_req8(dma_req8) ,			// output  dma_req8
	.dma_req16(dma_req16) ,			// output  dma_req16
	.dma_ack(dma_ack) ,				// input  dma_ack
	.dma_readdata(dma_readdata) ,	// input [15:0] dma_readdata
	.dma_writedata(dma_writedata) ,	// output [15:0] dma_writedata
	
	.sample_l(sb_out_l) ,			// output [15:0] sample_l
	.sample_r(sb_out_r)				// output [15:0] sample_r	
);


reg [15:0] clk_div;
always @(posedge CLOCK_50) clk_div <= clk_div + 1; 

//wire i2s_ce = clk_div[3:0]==0;	// 3.125 MHz. 64fs, so 48,828 KHz I2S output rate.
//wire i2s_ce = clk_div[2:0]==0;	// 6.250 MHz. 64fs, so 97.656 KHz I2S output rate.
wire i2s_ce = clk_div[1:0]==0;	// 12.500 MHz. 64fs, so 195.312 KHz I2S output rate.

i2s i2s_inst
(
	.reset( !MRESET_N ) ,	// input  reset
	
	.clk(CLOCK_50) ,			// input  clk
	.ce(i2s_ce) ,				// input  ce
	
	.sclk(I2S_BCK) ,			// output  sclk
	.lrclk(I2S_LRCK) ,		// output  lrclk
	.sdata(DAC_DIN) ,			// output  sdata
	
	.left_chan( {sb_out_l, 16'h0000} ) ,	// input [AUDIO_DW-1:0] left_chan.  (up to) 32-bit now.
	.right_chan( {sb_out_r, 16'h0000} ) 	// input [AUDIO_DW-1:0] right_chan. (up to) 32-bit now.
);


(*keep*)wire [7:0] mpu_readdata;
(*keep*)wire irq_mpu;

wire mpu_read  = read_n_falling;
wire mpu_write = write_n_rising;

mpu mpu
(
	.clk               (clk_sys),
	.br_clk            (clk_mpu),
	.reset             (!MRESET_N),

	.address           (io_addr[0]),
	.writedata         (iobus_writedata[7:0]),
	.read              (mpu_read),
	.write             (mpu_write),
	.readdata          (mpu_readdata),
	.cs                (mpu_cs),

	.rx                (MIDI_RXD),
	.tx                (MIDI_TXD),

	.double_rate       (1),
	.irq               (irq_mpu)
);


endmodule
