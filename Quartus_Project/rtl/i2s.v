
module i2s
#(
	parameter AUDIO_DW = 32
)
(
	input      reset,
	input      clk,
	input      ce,

	output reg sclk,
	output reg lrclk,
	output reg sdata,

	input [AUDIO_DW-1:0]	left_chan,
	input [AUDIO_DW-1:0]	right_chan
);

always @(posedge clk) begin
	reg  [7:0] bit_cnt;
	reg msclk;
	
	reg [AUDIO_DW-1:0] left;
	reg [AUDIO_DW-1:0] right;
	
	if (reset) begin
		bit_cnt <= 1;
		lrclk   <= 1;
		sclk    <= 1;
		msclk   <= 1;
	end
	else begin
		sclk <= msclk;
		if (ce) begin					// Must use ce (Clock Enable), else the logic won't work correctly.
			msclk <= ~msclk;
			if (msclk) begin
				if (bit_cnt >= AUDIO_DW) begin	// Last bit has been shifted out...
					bit_cnt <= 1;						// Reset the bit count.
					lrclk <= ~lrclk;					// Toggle LRCLK.
					if (lrclk) begin					// If LRCLK was just High, latch the new incoming left/right samples...
						left  <= left_chan;
						right <= right_chan;
					end
				end
				else begin
					bit_cnt <= bit_cnt + 1'd1;
				end
				sdata <= lrclk ? right[AUDIO_DW - bit_cnt] : left[AUDIO_DW - bit_cnt];
			end
		end
	end
end

endmodule
