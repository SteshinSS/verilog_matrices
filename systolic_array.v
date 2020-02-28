module systolic_array
# (
    parameter WIDTH = 8,
    parameter DIM = 3
)
(
    input wire clock,
    input wire reset,
    input wire [DIM*WIDTH - 1 : 0] inp_top,
    input wire [DIM*WIDTH - 1 : 0] inp_left,
    output wire [DIM*WIDTH - 1 : 0] out_bottom,
    output wire [DIM*WIDTH - 1 : 0] out_right,
    output wire [2*DIM*DIM*WIDTH - 1 : 0] result
);

    wire [DIM*(DIM-1)*WIDTH - 1 : 0] inner_wires_vertical;
    wire [DIM*(DIM-1)*WIDTH - 1 : 0] inner_wires_horizontal;

    // Левая верхняя клетка
    unit_cell #(WIDTH, DIM) UC_left_top
    (
        .clock(clock),
        .reset(reset),
        .inp_left(inp_left[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH]),
        .inp_top(inp_top[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH]),
        .out_bottom(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - 1 : DIM*(DIM-1)*WIDTH - WIDTH]),
        .out_right(inner_wires_vertical[DIM*(DIM-1)*WIDTH - 1 : DIM*(DIM-1)*WIDTH - WIDTH]),
        .out_mem(result[2*DIM*DIM*WIDTH - 1 : 2*DIM*DIM*WIDTH - 2*WIDTH])
    );


    // Первая строка из клеток кроме крайних
    generate
        genvar i;
            
        for (i = 0; i < DIM - 2; i = i + 1)
        begin : stage_i
            unit_cell #(WIDTH, DIM, DIM) UC_i
            (
                .clock(clock),
                .reset(reset),
                .inp_left(inner_wires_vertical[DIM*(DIM-1)*WIDTH - WIDTH*i - 1 : DIM*(DIM-1)*WIDTH - WIDTH*(i+1)]),
                .inp_top(inp_top[DIM*WIDTH - WIDTH*(i+1) - 1 : DIM*WIDTH - WIDTH*(i+2)]),
                .out_bottom(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - WIDTH*(i+1) - 1 : DIM*(DIM-1)*WIDTH - WIDTH*(i+2)]),
                .out_right(inner_wires_vertical[DIM*(DIM-1)*WIDTH - WIDTH*(i+1) - 1 : DIM*(DIM-1)*WIDTH - WIDTH*(i+2)]),
                .out_mem(result[2*DIM*DIM*WIDTH - 2*WIDTH*(i+1) - 1 : 2*DIM*DIM*WIDTH - 2*WIDTH*(i+2)])
            );
        end

    endgenerate


    // Правая верхняя клетка
    unit_cell #(WIDTH, DIM) UC_right_top
    (
        .clock(clock),
        .reset(reset),
        .inp_left(inner_wires_vertical[DIM*(DIM-1)*WIDTH - WIDTH*(DIM-2) - 1 : DIM*(DIM-1)*WIDTH - WIDTH*(DIM-1)]),
        .inp_top(inp_top[WIDTH - 1 : 0]),
        .out_bottom(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH]),
        .out_right(out_right[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH]),
        .out_mem(result[2*DIM*DIM*WIDTH - 2*(DIM-1)*WIDTH - 1 : 2*DIM*DIM*WIDTH - 2*DIM*WIDTH])
    );


    // Строки из клеток кроме первой и последней
    generate
        genvar j, k;
        
        for (j = 0; j < DIM - 2; j = j + 1)
        begin : stage_j

            // Первая клетка в строке
            unit_cell #(WIDTH, DIM) UC_left_j
            (
                .clock(clock),
                .reset(reset),
                .inp_left(inp_left[DIM*WIDTH - WIDTH*(j+1) - 1 : DIM*WIDTH - WIDTH*(j+2)]),
                .inp_top(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*j - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*j - WIDTH]),
                .out_bottom(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH]),
                .out_right(inner_wires_vertical[DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH]),
                .out_mem(result[2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(j+1) - 1 : 2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(j+1) - 2*WIDTH])
            );

            // Внутренние клетки в строке
            for (k = 0; k < DIM - 2; k = k + 1)
            begin :stage_k
                unit_cell #(WIDTH, DIM) UC_k
                (
                    .clock(clock),
                    .reset(reset),
                    .inp_left(inner_wires_vertical[DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH*k - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH*(k+1)]),
                    .inp_top(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*j - WIDTH*(k+1) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*j - WIDTH*(k+2)]),
                    .out_bottom(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH*(k+1) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH*(k+2)]),
                    .out_right(inner_wires_vertical[DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH*(k+1) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH*(k+2)]),
                    .out_mem(result[2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(j+1) - 2*WIDTH*(k+1) - 1 : 2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(j+1) - 2*WIDTH*(k+2)])
                );
            end

            // Последняя клетка в строке
            unit_cell #(WIDTH, DIM) UC_right_j
            (
                .clock(clock),
                .reset(reset),
                .inp_left(inner_wires_vertical[DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH*(DIM-2) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*WIDTH*(j+1) - WIDTH*(DIM-1)]),
                .inp_top(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH*j - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH*(j+1)]),
                .out_bottom(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH*(j+1) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH*(j+2)]),
                .out_right(out_right[DIM*WIDTH - WIDTH*(j+1) - 1 : DIM*WIDTH - WIDTH*(j+2)]),
                .out_mem(result[2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(j+1) - 2*WIDTH*(DIM-1) - 1 : 2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(j+2)])
            );
            
        end

    endgenerate


    // Левая нижняя клетка
    unit_cell #(WIDTH, DIM) UC_left_bottom
    (
        .clock(clock),
        .reset(reset),
        .inp_left(inp_left[WIDTH - 1 : 0]),
        .inp_top(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-2)*WIDTH - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-2)*WIDTH - WIDTH]),
        .out_bottom(out_bottom[DIM*WIDTH - 1 : DIM*WIDTH - WIDTH]),
        .out_right(inner_wires_vertical[DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH]),
        .out_mem(result[2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(DIM-1) - 1 : 2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(DIM-1) - 2*WIDTH])
    );


    // Последняя строка из клеток кроме крайних
    generate
        genvar l;
        
        for (l = 0; l < DIM - 2; l = l + 1)
        begin : stage_l
            unit_cell #(WIDTH, DIM) UC_l
            (
                .clock(clock),
                .reset(reset),
                .inp_left(inner_wires_vertical[DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH*l - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH*(l+1)]),
                .inp_top(inner_wires_horizontal[DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-2)*WIDTH - WIDTH*(l+1) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-2)*WIDTH - WIDTH*(l+2)]),
                .out_bottom(out_bottom[DIM*WIDTH - WIDTH*(l+1) - 1 : DIM*WIDTH - WIDTH*(l+2)]),
                .out_right(inner_wires_vertical[DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH*(l+1) - 1 : DIM*(DIM-1)*WIDTH - (DIM-1)*(DIM-1)*WIDTH - WIDTH*(l+2)]),
                .out_mem(result[2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(DIM-1) - 2*WIDTH*(l+1) - 1 : 2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(DIM-1) - 2*WIDTH*(l+2)])
            );
        end

    endgenerate


    // Правая нижняя клетка
    unit_cell #(WIDTH, DIM) UC_right_bottom
    (
        .clock(clock),
        .reset(reset),
        .inp_left(inner_wires_vertical[WIDTH - 1 : 0]),
        .inp_top(inner_wires_horizontal[WIDTH - 1 : 0]),
        .out_bottom(out_bottom[WIDTH - 1 : 0]),
        .out_right(out_right[WIDTH - 1 : 0]),
        .out_mem(result[2*DIM*DIM*WIDTH - 2*DIM*WIDTH*(DIM-1) - 2*WIDTH*(DIM-1) - 1 : 0])
    );


endmodule