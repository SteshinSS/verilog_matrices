module systolic_array
# (
	parameter WIDTH = 8,
	parameter DIM = 10
)
(
	input wire clock,
	input wire reset,
	input wire [WIDTH - 1 : 0] inp_top[DIM],
	input wire [WIDTH - 1 : 0] inp_left[DIM],
	output wire [2*WIDTH - 1 : 0] result [DIM][DIM]
);

	wire [WIDTH - 1 : 0] inner_wires_vertical [DIM - 1 : 0][DIM : 0];
	wire [WIDTH - 1 : 0] inner_wires_horizontal [DIM : 0][DIM - 1 : 0];

	generate
		genvar i, j;

		for (i = 0; i < DIM; i = i + 1) begin 
			for (j = 0; j < DIM; j = j + 1) begin 
				wire [WIDTH - 1 : 0] cur_inp_left = (j == 0 ? 
					 	     		     inp_left[i] :
						     		     inner_wires_horizontal[i][j - 1]);
				wire [WIDTH - 1 : 0] cur_inp_top = (i == 0 ?
						    		    inp_top[j] :
						    		    inner_wires_vertical[i - 1][j]);

				// Last row's and column's elements have no
				// output
				if (i == DIM - 1) begin
					if (j == DIM - 1) begin
						unit_cell #(WIDTH) ucell
						(
							.clock(clock),
							.reset(reset),
							.inp_left(cur_inp_left),
							.inp_top(cur_inp_top),
							.out_bottom(),
							.out_right(),
							.out_mem(result[i][j])
						);
					end else begin
						unit_cell #(WIDTH) ucell
						(
							.clock(clock),
							.reset(reset),
							.inp_left(cur_inp_left),
							.inp_top(cur_inp_top),
							.out_bottom(),
							.out_right(inner_wires_horizontal[i][j]),
							.out_mem(result[i][j])
						);
					end
				end else begin
					if (j == DIM - 1) begin
						unit_cell #(WIDTH) ucell
						(
							.clock(clock),
							.reset(reset),
							.inp_left(cur_inp_left),
							.inp_top(cur_inp_top),
							.out_bottom(inner_wires_vertical[i][j]),
							.out_right(),
							.out_mem(result[i][j])
						);
					end else begin
						// usuall cell
						unit_cell #(WIDTH) ucell
						(
							.clock(clock),
							.reset(reset),
							.inp_left(cur_inp_left),
							.inp_top(cur_inp_top),
							.out_bottom(inner_wires_vertical[i][j]),
							.out_right(inner_wires_horizontal[i][j]),
							.out_mem(result[i][j])
						);
					end
				end
			end // for (j = ...
		end // for (i = ...

	endgenerate

	endmodule


