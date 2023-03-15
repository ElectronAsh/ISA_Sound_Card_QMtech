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

	input [19:0]		SA,
	input [23:17]		LA,

	inout       		SD70_DIR,
	inout       		SD158_DIR,

	inout       		SA158_DIR,
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
	output       		DRQ_HI_SEL_A0,
	output       		DRQ_HI_SEL_A1,
	output       		DRQ_HI_SEL_A2,

	output       		DRQ_LO_TRIG_N,
	output       		DRQ_LO_SEL_A0,
	output       		DRQ_LO_SEL_A1,
	output       		DRQ_LO_SEL_A2,

	input       		DACK0_N,
	input       		DACK1_N,
	input       		DACK2_N,
	input       		DACK3_N,
							// No DACK4_N.
	input       		DACK5_N,
	input       		DACK6_N,
	input       		DACK7_N,

	output       		IRQ_HI_TRIG_N,
	output       		IRQ_HI_SEL_A0,
	output       		IRQ_HI_SEL_A1,
	output       		IRQ_HI_SEL_A2,

	output       		IRQ_LO_TRIG_N,
	output       		IRQ_LO_SEL_A0,
	output       		IRQ_LO_SEL_A2,
	output       		IRQ_LO_SEL_A1,

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

/*
//=======================================================
//  REG/WIRE declarations
//=======================================================
wire  [15:0]  writedata;
wire  [15:0]  readdata;
wire          write;
wire          read;
wire          clk_test;

//	SDRAM frame buffer
Sdram_Control	u1	(	//	HOST Side
						   .REF_CLK(CLOCK_50),
					      .RESET_N(KEY[1]),
							//	FIFO Write Side 
						   .WR_DATA(writedata),
							.WR(write),
							.WR_ADDR(0),
							.WR_MAX_ADDR(24'h1ffffff),
							.WR_LENGTH(9'h80),
							.WR_LOAD(!KEY[1] ),
							.WR_CLK(clk_test),
							//	FIFO Read Side 
						   .RD_DATA(readdata),
				        	.RD(read),
				        	.RD_ADDR(0),			//	Read odd field and bypess blanking
							.RD_MAX_ADDR(24'h1ffffff),
							.RD_LENGTH(9'h80),
				        	.RD_LOAD(!KEY[1] ),
							.RD_CLK(clk_test),
                     //	SDRAM Side
						   .SA(DRAM_ADDR),
						   .BA(DRAM_BA),
						   .CS_N(DRAM_CS_N),
						   .CKE(DRAM_CKE),
						   .RAS_N(DRAM_RAS_N),
				         .CAS_N(DRAM_CAS_N),
				         .WE_N(DRAM_WE_N),
						   .DQ(DRAM_DQ),
				         .DQM({DRAM_UDQM,DRAM_LDQM}),
							.SDR_CLK(DRAM_CLK)	);

wire  test_start_n;

wire  sdram_test_pass;
wire  sdram_test_fail;
wire  sdram_test_complete;
*/

/*
PLL01 u0(
	.areset(1'b0),
	.inclk0(CLOCK_50),
	.c0(clk_sys),
	.locked()
);
wire clk_sys;
*/

//wire clk_sys = CLOCK_50;
wire clk_sys = CLK;


/*
RW_Test u2(
      .iCLK(clk_test),
		.iRST_n(KEY[1]),
		.iBUTTON(test_start_n),
      .write(write),
		.writedata(writedata),
	   .read(read),
		.readdata(readdata),
      .drv_status_pass(sdram_test_pass),
		.drv_status_fail(sdram_test_fail),
		.drv_status_test_complete(sdram_test_complete)
);

assign test_start_n = KEY[0];

assign LEDR = !(sdram_test_complete & sdram_test_pass);
*/


// All of these have Pull-ups.
// If they are  High-Z, the signal direction will be A->B, or ISA->FPGA.
// Pull LOW, to allow output to the ISA bus.
//
//assign SD70_DIR = 1'bz;	// ISA Data bits [7:0]  DIRection.
assign SD158_DIR = 1'bz;	// ISA Data bits [15:8] DIRection.

assign SA158_DIR = 1'bz;	// ISA Addr bits [15:8] DIRection.
assign LA_DIR = 1'bz;


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
	sa_reg <= SA;
	la_reg <= LA;
	
	if (bale_falling) addr_lat <= sa_reg;
end


(*keep*)wire [15:0] io_addr = addr_lat[15:0];

(*keep*)wire joy_cs = (io_addr == 16'h0201);
(*keep*)wire sb_cs  = (io_addr >= 16'h0220 && io_addr <= 16'h022f);
(*keep*)wire fm_cs  = (io_addr >= 16'h0388 && io_addr <= 16'h038b);
(*keep*)wire mpu_cs = (io_addr == 16'h0330);

(*keep*)wire cms_en = 1'b0;	// Disable for now.

(*keep*)wire fm_mode = 1'b1;	// OPL3.

(*keep*)wire irq_5, irq_7, irq_10;

(*keep*)wire [15:0] iobus_writedata = sd_reg;
(*keep*)wire iobus_write = !iow_n_reg /*& !AEN*/;
//(*keep*)wire iobus_write = !IOW_N;

(*keep*)wire [7:0] sound_readdata;
(*keep*)wire iobus_read = !ior_n_reg /*& !AEN*/;
//(*keep*)wire iobus_read = !IOR_N;

//wire bus_read = ((sb_cs | fm_cs) & !ior_n_reg);
wire bus_read = ((sb_cs | fm_cs) & !IOR_N);
assign SD = (bus_read) ? {sound_readdata, sound_readdata} : 16'hzzzz;
assign SD70_DIR = !bus_read;	// Bring SD70_DIR LOW during a READ.
assign SD158_DIR = !bus_read;	// Bring SD158_DIR LOW during a READ.


// SBHE Low denotes a byte has been put on the upper 8 bits of the ISA Data bus.
// This often happens during writes to an Odd address as well. (like 0x389 for OPL).
//
//wire [7:0] sound_writedata = (!SBHE) ? iobus_writedata[15:8] : iobus_writedata[7:0];
wire [7:0] sound_writedata = iobus_writedata[7:0];


(*keep*)wire [7:0] mpu_readdata;

(*keep*)wire [15:0] sb_out_l, sb_out_r;

// IRQ_xx_SEL 0 = IRQ5.  LPT2.
// IRQ_xx_SEL 1 = IRQ6.  Floppy Drive.
// IRQ_xx_SEL 2 = IRQ7.  LPT1.
// IRQ_xx_SEL 3 = IRQ10. Reserved / Available?
// IRQ_xx_SEL 4 = IRQ11. Reserved / Available?
// IRQ_xx_SEL 5 = IRQ12. Mouse.
// IRQ_xx_SEL 6 = IRQ14. ATA.
// IRQ_xx_SEL 7 = IRQ15. ATA.
//
assign {IRQ_LO_SEL_A2, IRQ_LO_SEL_A1, IRQ_LO_SEL_A0} = 3'd0;
assign IRQ_LO_TRIG_N = !irq_5;

assign {IRQ_HI_SEL_A2, IRQ_HI_SEL_A1, IRQ_HI_SEL_A0} = 3'd3;
assign IRQ_HI_TRIG_N = !irq_10;


assign {DRQ_LO_SEL_A2, DRQ_LO_SEL_A1, DRQ_LO_SEL_A0} = 3'd1;
assign DRQ_LO_TRIG_N = !dma_req8;

assign {DRQ_HI_SEL_A2, DRQ_HI_SEL_A1, DRQ_HI_SEL_A0} = 3'd5;
assign DRQ_HI_TRIG_N = !dma_req16;


reg dack1_n_reg;
reg dack5_n_reg;
always @(posedge clk_sys) begin
	dack1_n_reg <= DACK1_N;
	dack5_n_reg <= DACK5_N;
end

wire dma_req8;
wire dma_req16;

//wire dma_ack = ((!DACK1_N & dack1_n_reg) | (!DACK5_N & dack5_n_reg)) && !IOW_N;
wire dma_ack = (!DACK1_N | !DACK5_N) && !IOW_N;


wire [15:0] dma_readdata = SD;
wire [15:0] dma_writedata;

sound sound_inst
(
	.clk(clk_sys) ,					// input  clk
	.clock_rate( 28'd8_333_000 ) ,// input [27:0] clock_rate. (the frequency of the clk input, in Hz)
	
	.clk_opl(CLOCK_50) ,				// input  clk_opl
	
	.rst_n(MRESET_N) ,				// input  rst_n
	
	.irq_5(irq_5) ,					// output  irq_5
	.irq_7(irq_7) ,					// output  irq_7
	.irq_10(irq_10) ,					// output  irq_10
	
	.address(io_addr[3:0]) ,		// input [3:0] address
	
	.readdata(sound_readdata) ,	// output [7:0] readdata
	.read(iobus_read) ,				// input  read
	
	.writedata(sound_writedata) ,	// input [7:0] writedata
	.write(iobus_write) ,			// input  write
	
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
wire i2s_ce = clk_div[2:0]==0;	// 6.250 MHz. 64fs, so 97.656 KHz I2S output rate.

//wire [15:0] test_tone = {clk_div[15], 15'h7fff};

i2s i2s_inst
(
	.reset( !MRESET_N ) ,	// input  reset
	
	.clk(CLOCK_50) ,			// input  clk
	.ce(i2s_ce) ,				// input  ce
	
	.sclk(i2s_bck_out) ,		// output  sclk
	.lrclk(i2s_lrck_out) ,	// output  lrclk
	.sdata(i2s_data_out) ,	// output  sdata
	
	.left_chan( {sb_out_l, 16'h0000} ) ,	// input [AUDIO_DW-1:0] left_chan
	.right_chan( {sb_out_r, 16'h0000} ) 	// input [AUDIO_DW-1:0] right_chan
);

(*keep*)wire i2s_bck_out;
(*keep*)wire i2s_lrck_out;
(*keep*)wire i2s_data_out;

assign I2S_BCK  = i2s_bck_out;
assign I2S_LRCK = i2s_lrck_out;
assign DAC_DIN  = i2s_data_out;

/*
mpu mpu
(
	.clk               (clk_sys),
	.br_clk            (clk_mpu),
	.reset             (!MRESET_N),

	.address           (io_addr[0]),
	.writedata         (iobus_writedata[7:0]),
	.read              (iobus_read),
	.write             (iobus_write),
	.readdata          (mpu_readdata),
	.cs                (mpu_cs),

	.rx                (mpu_rx),
	.tx                (mpu_tx),

	.double_rate       (1),
	.irq               (irq_9)
);
*/

endmodule
