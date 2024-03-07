module max_finder #(
    parameter WIDTH = 8,
    parameter NUM_INPUTS = 4
) (
    input   logic signed   [WIDTH - 1: 0]  inputs [NUM_INPUTS],
    output  logic signed   [WIDTH - 1: 0]  max_value
);
    localparam NUM_MAX_VALUES = (NUM_INPUTS >> 1) + (NUM_INPUTS % 2);
    genvar i;
    generate
        if (NUM_INPUTS == 1) begin
            assign max_value = inputs[0];
        end else begin
            logic signed [WIDTH - 1 : 0] max_values [NUM_MAX_VALUES];

            for (i = 0; i < (NUM_INPUTS >> 1); i = i + 1) begin
                assign max_values[i] = (inputs[2 * i] >= inputs[2 * i + 1]) ? inputs[2 * i] : inputs[2 * i + 1];
            end

            if (NUM_INPUTS % 2 == 1) begin
                assign max_values[NUM_MAX_VALUES - 1] = inputs[NUM_INPUTS - 1];
            end

            if (NUM_INPUTS == 2) begin
                assign max_value = max_values[0];
            end else begin
                max_finder #(
                    .WIDTH(WIDTH),
                    .NUM_INPUTS(NUM_MAX_VALUES)
                ) max_finder_i (
                    .inputs(max_values),
                    .max_value(max_value)
                );
            end
        end
    endgenerate

endmodule
