module testbench;

    parameter WIDTH = 8;
    parameter DIM = 3;

    reg clock, reset;
    reg [WIDTH - 1 : 0] inp_top [DIM];
    reg [WIDTH - 1 : 0] inp_left [DIM];

    wire [2*WIDTH - 1 : 0] result [DIM][DIM];

    systolic_array #(8, 3) SA
    (
        .clock(clock),
        .reset(reset),
        .inp_top(inp_top),
        .inp_left(inp_left),
//        .out_bottom(out_bottom),
//        .out_right(out_right),
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
        inp_left <= 0;
        inp_top <= 0;

        #10
        reset <= 1;

        inp_left[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH] <= 9;                //a11
        inp_top[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH] <= 9;                 //b11

        #10

        inp_left[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH] <= 3;                //a12
        inp_top[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH] <= 0;                 //b21

        inp_left[DIM*WIDTH - WIDTH - 1 : DIM*WIDTH - 2*WIDTH] <= 5;      //a21
        inp_top[DIM*WIDTH - WIDTH - 1 : DIM*WIDTH - 2*WIDTH] <= 1;       //b12

        #10

        inp_left[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH] <= 2;                //a13
        inp_top[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH] <= 2;                 //b31
        
        inp_left[DIM*WIDTH - WIDTH - 1 : DIM*WIDTH - 2*WIDTH] <= 1;      //a22
        inp_top[DIM*WIDTH - WIDTH - 1 : DIM*WIDTH - 2*WIDTH] <= 2;       //b22

        inp_left[DIM*WIDTH - 2*WIDTH - 1 : DIM*WIDTH - 3*WIDTH] <= 0;    //a31
        inp_top[DIM*WIDTH - 2*WIDTH - 1 : DIM*WIDTH - 3*WIDTH] <= 8;     //b13

        #10

        inp_left[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH] <= 0;
        inp_top[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH] <= 0;

        inp_left[DIM*WIDTH - WIDTH - 1 : DIM*WIDTH - 2*WIDTH] <= 1;      //a23
        inp_top[DIM*WIDTH - WIDTH - 1 : DIM*WIDTH - 2*WIDTH] <= 6;       //b32

        inp_left[DIM*WIDTH - 2*WIDTH - 1 : DIM*WIDTH - 3*WIDTH] <= 1;    //a32
        inp_top[DIM*WIDTH - 2*WIDTH - 1 : DIM*WIDTH - 3*WIDTH] <= 2;     //b23

        #10

        inp_left[DIM*WIDTH - WIDTH - 1 : DIM*WIDTH - 2*WIDTH] <= 0;
        inp_top[DIM*WIDTH - WIDTH - 1 : DIM*WIDTH - 2*WIDTH] <= 0;

        inp_left[DIM*WIDTH - 2*WIDTH - 1 : DIM*WIDTH - 3*WIDTH] <= 5;    //a33
        inp_top[DIM*WIDTH - 2*WIDTH - 1 : DIM*WIDTH - 3*WIDTH] <= 1;     //b33

        #10

        inp_left[DIM*WIDTH - 2*WIDTH - 1 : DIM*WIDTH - 3*WIDTH] <= 0;
        inp_top[DIM*WIDTH - 2*WIDTH - 1 : DIM*WIDTH - 3*WIDTH] <= 0;

        #30

        $display(
            result[2*DIM*DIM*WIDTH - 1 : 2*DIM*DIM*WIDTH - 2*WIDTH],
            result[2*DIM*DIM*WIDTH - 2*WIDTH - 1 : 2*DIM*DIM*WIDTH - 4*WIDTH],
            result[2*DIM*DIM*WIDTH - 4*WIDTH - 1 : 2*DIM*DIM*WIDTH - 6*WIDTH]
        );
        $display(
            result[2*DIM*(DIM-1)*WIDTH - 1 : 2*DIM*(DIM-1)*WIDTH - 2*WIDTH],
            result[2*DIM*(DIM-1)*WIDTH - 2*WIDTH - 1 : 2*DIM*(DIM-1)*WIDTH - 4*WIDTH],
            result[2*DIM*(DIM-1)*WIDTH - 4*WIDTH - 1 : 2*DIM*(DIM-1)*WIDTH - 6*WIDTH]
        );
        $display(
            result[2*DIM*(DIM-2)*WIDTH - 1 : 2*DIM*(DIM-2)*WIDTH - 2*WIDTH],
            result[2*DIM*(DIM-2)*WIDTH - 2*WIDTH - 1 : 2*DIM*(DIM-2)*WIDTH - 4*WIDTH],
            result[2*DIM*(DIM-2)*WIDTH - 4*WIDTH - 1 : 2*DIM*(DIM-2)*WIDTH - 6*WIDTH]
        );

        $finish;
    end

    initial
    begin
        $dumpfile("out.vcd");
        $dumpvars(0, testbench);
    end

    // initial
    // $monitor($stime,, clock);

endmodule
