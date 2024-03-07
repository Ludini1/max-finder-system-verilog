module max_finder #(
    parameter WIDTH = 8,
    parameter NUM_INPUTS = 4
) (
    input  logic signed [WIDTH - 1 : 0] inputs [NUM_INPUTS],
    output logic signed [WIDTH - 1 : 0] max_value,
    output logic        [$clog2(NUM_INPUTS) - 1 : 0] max_index
);
    localparam NUM_MAX_VALUES   = (NUM_INPUTS >> 1) + (NUM_INPUTS % 2);
    localparam MAX_INDEX_WIDTH  = $clog2(NUM_INPUTS);

    genvar i;
    generate
        if (NUM_INPUTS == 1) begin
            assign max_value = inputs[0];
            assign max_index = 0;
        end else begin
            logic signed [WIDTH - 1 : 0]           max_values  [NUM_MAX_VALUES];
            logic        [MAX_INDEX_WIDTH - 1 : 0] max_indices [NUM_MAX_VALUES];

            for (i = 0; i < (NUM_INPUTS >> 1); i = i + 1) begin
                assign max_values[i] = (inputs[2 * i] >= inputs[2 * i + 1]) ? inputs[2 * i] : inputs[2 * i + 1];
                assign max_indices[i] = (inputs[2 * i] >= inputs[2 * i + 1]) ? MAX_INDEX_WIDTH'(i * 2) : MAX_INDEX_WIDTH'(i * 2 + 1);
            end

            if (NUM_INPUTS % 2 == 1) begin
                assign max_values[NUM_MAX_VALUES - 1] = inputs[NUM_INPUTS - 1];
                assign max_indices[NUM_MAX_VALUES - 1] = MAX_INDEX_WIDTH'(NUM_INPUTS - 1);
            end

            if (NUM_INPUTS == 2) begin
                assign max_value = max_values[0];
                assign max_index = max_indices[0];
            end else begin
                logic [$clog2(NUM_MAX_VALUES) - 1 : 0] max_index_recursed;

                max_finder #(
                    .WIDTH(WIDTH),
                    .NUM_INPUTS(NUM_MAX_VALUES)
                ) max_finder_i (
                    .inputs(max_values),
                    .max_value(max_value),
                    .max_index(max_index_recursed)
                );

                assign max_index = max_indices[max_index_recursed];

            end
        end
    endgenerate

endmodule
