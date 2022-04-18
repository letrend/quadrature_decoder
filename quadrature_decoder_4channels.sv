module Quadrature_Decoder_4Channels (
    input clk,
    input reset_n,
    input read,
    output unsigned [31:0] readdata,
    input write,
    input unsigned [31:0] writedata,
    input [3:0] channel
  );

  parameter CLOCK_FREQ_HZ = 50_000_000;

  wire direction;
  integer pos, offset;
  reg dir;

  always @ ( posedge clk ) begin
    if(write)begin
      offset <= pos;
      dir <= writedata[0];
    end
  end
  
  reg [7:0] counter [3:0];
  reg [3:0] channel_debounced;
  
  genvar j;
  generate for (j = 0; j < 4; j = j+1)
  begin:  debounce_counter_loop
    always @ (posedge clk) begin
		if(channel[j]!=channel_debounced[j])begin
			counter[j] <= counter[j]+1;
			if(counter[j]==0)begin
				channel_debounced[j] <= channel[j];
			end
		end else begin
			counter[j] <= 1;
		end
	 end
 end
  endgenerate

  assign readdata = dir?(pos-offset):(offset-pos);
	
	integer i;
	
	reg [3:0] channel_prev;
	wire [3:0] rising_edge;
	wire [3:0] falling_edge;
	generate
		for(j=0;j<4;j=j+1)begin: rising_falling
			assign rising_edge[j] = channel_debounced[j] && !channel_prev[j];
			assign falling_edge[j] = !channel_debounced[j] && channel_prev[j];
		end
	
	endgenerate
	
	always @( posedge clk ) begin
		for(i=0;i<4;i=i+1)begin
			channel_prev[i] <= channel_debounced[i];
		end
		
		if(rising_edge[0])begin
			pos <= pos+(channel_debounced[1]?1:-1);
		end
		if(rising_edge[1])begin
			pos <= pos+(channel_debounced[0]?-1:1);
		end
		if(falling_edge[0])begin
			pos <= pos+(channel_debounced[1]?-1:1);
		end
		if(falling_edge[1])begin
			pos <= pos+(channel_debounced[0]?1:-1);
		end
	end


endmodule //Stepper
