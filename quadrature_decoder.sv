module Quad_Decode (
    input clk,
    input reset,
    input read,
    output unsigned [31:0] readdata,
    input write,
    input unsigned [31:0] writedata,
    input A,
    input B,
    input I
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

  quadrature_decoder #(0) quad_counter(
     .clk(clk),
     .a(A),
     .b(B),
     .direction(direction),
     .position(pos)
   );


endmodule //Stepper
