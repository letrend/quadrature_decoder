module Quadrature_Decoder_4Channels (
    input clk,
    input reset,
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

  assign readdata = dir?(pos-offset):(offset-pos);
	
	integer i;
	reg [3:0] channel_prev;
	
	genvar j;
	wire [3:0] rising_edge;
	wire [3:0] falling_edge;
	generate
		for(j=0;j<4;j=j+1)begin: rising_falling
			assign rising_edge[j] = channel[j] && !channel_prev[j];
			assign falling_edge[j] = !channel[j] && channel_prev[j];
		end
	
	endgenerate
	
	always @( posedge clk ) begin
		for(i=0;i<4;i=i+1)begin
			channel_prev[i] <= channel[i];
		end
//		if(channel[0] && falling_edge[1])begin
//				pos <= pos+1;
//		end
//		if(!channel[1] && falling_edge[0])begin
//				pos <= pos+1;
//		end
//		if(!channel[0] && rising_edge[1])begin
//				pos <= pos+1;
//		end
//		if(channel[1] && rising_edge[0])begin
//				pos <= pos+1;
//		end
//		
//		if(channel[1] && falling_edge[0])begin
//				pos <= pos-1;
//		end
//		if(!channel[0] && falling_edge[1])begin
//				pos <= pos-1;
//		end
//		if(!channel[1] && rising_edge[0])begin
//				pos <= pos-1;
//		end
//		if(channel[0] && rising_edge[1])begin
//				pos <= pos-1;
//		end
		
		if(rising_edge[0])begin
			pos <= pos+(channel[1]?1:-1);
		end
		if(rising_edge[1])begin
			pos <= pos+(channel[0]?-1:1);
		end
		if(falling_edge[0])begin
			pos <= pos+(channel[1]?-1:1);
		end
		if(falling_edge[1])begin
			pos <= pos+(channel[0]?1:-1);
		end
	end


endmodule //Stepper
