`timescale 1ns / 1ps
//`include "user_module_341360223723717202.v"

module user_module_341360223723717202_tb;

reg [7:0] io_in;
wire [7:0] io_out;

user_module_341360223723717202 m (.io_in(io_in), .io_out(io_out));

initial begin
  $dumpfile("user_module_341360223723717202_tb.vcd");
  $dumpvars(0, user_module_341360223723717202_tb);
end

initial begin
   #8000;
   $display("Caught by trap");
   $finish;
 end

parameter CLK_HALF_PERIOD = 5;
always begin
  io_in[0] = 1'b1;
  #(CLK_HALF_PERIOD);
  io_in[0] = 1'b0;
  #(CLK_HALF_PERIOD);
end

initial 
begin
  // reset
  #20
  $display("RESET");
  io_in[1] = 1;
  #(CLK_HALF_PERIOD);
  io_in[1] = 0;
end

always begin
  // external memory
  case(io_out[5:0])
    0: io_in[7:2] <= 1; // a = a + b
    1: io_in[7:2] <= 2; // swap a,b
    2: io_in[7:2] <= 16;// output a
    3: io_in[7:2] <= 6; // jmp if a == 0
    4: io_in[7:2] <= 0; // ... to address
    5: io_in[7:2] <= 7; // read immediate into a
    6: io_in[7:2] <= 63;// ...
    7: io_in[7:2] <= 4; // c = a
    8: io_in[7:2] <= 1; // a = a + b
    9: io_in[7:2] <= 3; // a = c
    10:io_in[7:2] <= 9; // a = ~a
    11:io_in[7:2] <= 8; // a++
    12:io_in[7:2] <= 5; // jmp
    13:io_in[7:2] <= 7; // ... to address
    default: io_in[7:4] <= 15;
  endcase

  #1;
end

always @(posedge io_out[7]) $display("OUT: ", io_out[5:0]);

initial begin
  $monitor(
    "a",m.reg_a,"  ",
    "b",m.reg_b,"  ",
    "c",m.reg_c,"  ",
    "pc",m.pc,"  ",
    "micro",m.micro_pc,"  ",
    "instr",m.instr,"  ",
    ""
  );
end

endmodule
