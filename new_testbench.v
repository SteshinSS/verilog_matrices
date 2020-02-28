module testbench;
	parameter WIDTH = 8;
	parameter DIM = 10; // systolic array's dimensions
	
	reg clock, reset;
	reg [WIDTH - 1 : 0] inp_top [DIM];
        reg [WIDTH - 1 : 0] inp_left [DIM];
	wire [2*WIDTH - 1 : 0] result [DIM][DIM];

	systolic_array #(WIDTH, DIM) SA
	(
		.clock(clock),
		.reset(reset),
		.inp_top(inp_top),
		.inp_left(inp_left),
		.result(result)
	);

	always
	#10
	begin
		clock <= ~clock;
	end

	initial
	begin
		clock <= 0;
		reset <= 0;

		inp_left[0] <= 0;
		inp_left[1] <= 0;
		inp_left[2] <= 0;

		inp_top[0] <= 0;
		inp_top[1] <= 0;
		inp_top[2] <= 0;

		#10
		reset <= 1;

		#10

		inp_left[0] <= 9;
		inp_top[0] <= 9;

		#10

		inp_left[0] <= 3;
		inp_top[0] <= 0;

		inp_left[1] <= 5;
		inp_top[1] <= 1;

		#10

		inp_left[0] <= 2;
		inp_top[0] <= 2;

		inp_left[1] <= 1;
		inp_top[1] <= 2;

		inp_left[2] <= 0;
		inp_top[2] <= 8;

		#10

		inp_left[0] <= 0;
		inp_top[0] <= 0;
		
		inp_left[1] <= 1;
		inp_top[1] <= 6;

		inp_left[2] <= 1;
		inp_top[2] <= 2;

		#10

		inp_left[1] <= 0;
		inp_top[1] <= 0;

		inp_left[2] <= 5;
		inp_top[2] <= 1;

		#10

		inp_left[2] <= 0;
		inp_top[2] <= 0;

		#10
		#10

		$display(result[0][0], result[0][1], result[0][2]);
		$display(result[1][0], result[1][1], result[1][2]);
		$display(result[2][0], result[2][1], result[2][2]);

		$finish;


	end

	initial
	begin
		$dumpfile("out.vcd");
		$dumpvars(0, testbench);
	end

	endmodule

