module testbench;
	parameter WIDTH = 8;
	parameter DIM = 10;

	reg clock, reset;
	reg [WIDTH - 1 : 0] A [DIM][DIM];
	reg [WIDTH - 1 : 0] B [DIM][DIM];

	reg [WIDTH - 1 : 0] inp_top[DIM];
	reg [WIDTH - 1 : 0] inp_left[DIM];
	wire [2*WIDTH - 1 : 0] result[DIM][DIM];

	integer n;
	integer m;
	integer k;

	integer total_steps;

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

		// Find A1 * B1
		// Where A1 is MxN matrix
		// Where B1 is NxK matrix
		
		// Initialize matrices
		for (int i = 0; i < DIM; i = i + 1) begin
			for (int j = 0; j < DIM; j = j + 1) begin
				A[i][j] <= 0;
				B[i][j] <= 0;
			end
		end

		#10;

		m <= 3;
                n <= 3;
                k <= 4;

		#10;
		total_steps <= (m > k ? m : k) + n;
		#10;

		// Filling A:
		// ( 0 A1 )
		// ( 0 0  )
		// where A1:
		// ( 2 3 9 )
		// ( 1 1 5 )
		// ( 5 1 0 )
		A[0][7] <= 2; A[0][8] <= 3; A[0][9] <= 9;
		A[1][7] <= 1; A[1][8] <= 1; A[1][9] <= 5;
		A[2][7] <= 5; A[2][8] <= 1; A[2][9] <= 0;

		// Filling B:
		// ( 0  0 )
		// ( B1 0 )
		// where B1:
		// ( 2 6 1 4 )
		// ( 0 2 2 5 )
		// ( 9 1 8 2 )
		B[7][0] <= 2; B[7][1] <= 6; B[7][2] <= 1; B[7][3] <= 4;
		B[8][0] <= 0; B[8][1] <= 2; B[8][2] <= 2; B[8][3] <= 5;
		B[9][0] <= 9; B[9][1] <= 1; B[9][2] <= 8; B[9][3] <= 2;

		reset <= 1;
		#10;


		for (int i = 0; i < total_steps; i = i + 1) begin
			for (int j = 0; j < m; j = j + 1) begin
				if (i < j || i >= j + n) begin
					inp_left[j] <= 0;
				end else begin
					inp_left[j] <= A[j][n - 1 - i + j];
				end
			end

			for (int j = 0; j < k; j = j + 1) begin
				if (i < j || i >= j + k) begin
					inp_top[j] <= 0;
				end else begin
					inp_top[j] <= B[n - 1 - i + j][j];
				end
			end
			#10;
		end

		$display(result[0][0], result[0][1], result[0][2], result[0][3]);
		$display(result[1][0], result[1][1], result[1][2], result[1][3]);
		$display(result[2][0], result[2][1], result[2][2], result[2][3]);

		$finish;
	end

	initial
	begin
		$dumpfile("out.vcd");
		$dumpvars(0, testbench);
	end
	endmodule










			
