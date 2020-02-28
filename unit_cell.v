module unit_cell
# (
    parameter WIDTH = 8
)
(
    input wire clock,
    input wire reset,
    input wire [WIDTH - 1 : 0] inp_left,
    input wire [WIDTH - 1 : 0] inp_top,
    output reg [WIDTH - 1 : 0] out_bottom,
    output reg [WIDTH - 1 : 0] out_right,
    output reg [2*WIDTH - 1 : 0] out_mem
);

    always @(posedge reset)
    begin
        out_mem <= 0;
        out_bottom <= 0;
        out_right <= 0;
    end

    always @(clock)
    begin
        out_mem <= out_mem + inp_left*inp_top;
        out_right <= inp_left;
        out_bottom <= inp_top;
    end

endmodule
