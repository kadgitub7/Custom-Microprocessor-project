module posit_decoder #(
    parameter WIDTH = 8,
    parameter ES = 2
) (
    input [WIDTH-1:0] posit_i,
    output reg signed [31:0] value_o
);

    localparam MAX_REGIME_BITS = WIDTH - 1 - ES;

    integer i;
    integer idx;
    integer sign_bit;
    integer ones_cnt;
    integer zeros_cnt;
    integer regime_consumed;
    integer k;
    integer exp_val;
    integer frac_len;
    integer frac_val;
    real useed;
    real magnitude;
    real frac_scale;

    always @(*) begin
        if (posit_i == {WIDTH{1'b0}}) begin
            value_o = 0;
        end else begin
            sign_bit = posit_i[WIDTH-1] ? -1 : 1;
            idx = WIDTH - 2;
            ones_cnt = 0;
            zeros_cnt = 0;
            regime_consumed = 0;

            if (idx >= 0 && posit_i[idx] == 1'b1) begin
                while (idx >= 0 && posit_i[idx] == 1'b1 && ones_cnt < MAX_REGIME_BITS) begin
                    ones_cnt = ones_cnt + 1;
                    idx = idx - 1;
                end
                if (idx >= 0 && posit_i[idx] == 1'b0) begin
                    regime_consumed = ones_cnt + 1;
                    idx = idx - 1;
                end else begin
                    regime_consumed = ones_cnt;
                end
                k = ones_cnt - 1;
            end else begin
                while (idx >= 0 && posit_i[idx] == 1'b0 && zeros_cnt < MAX_REGIME_BITS) begin
                    zeros_cnt = zeros_cnt + 1;
                    idx = idx - 1;
                end
                if (idx >= 0 && posit_i[idx] == 1'b1) begin
                    regime_consumed = zeros_cnt + 1;
                    idx = idx - 1;
                end else begin
                    regime_consumed = zeros_cnt;
                end
                k = -zeros_cnt;
            end

            exp_val = 0;
            for (i = 0; i < ES; i = i + 1) begin
                if (idx >= 0) begin
                    exp_val = (exp_val << 1) | posit_i[idx];
                    idx = idx - 1;
                end
            end

            frac_len = WIDTH - 1 - regime_consumed - ES;
            if (frac_len < 0) begin
                frac_len = 0;
            end

            frac_val = 0;
            for (i = 0; i < frac_len; i = i + 1) begin
                if (idx >= 0) begin
                    frac_val = (frac_val << 1) | posit_i[idx];
                    idx = idx - 1;
                end
            end

            useed = 2.0 ** (2.0 ** ES);
            magnitude = 2.0 ** exp_val;
            if (frac_len > 0) begin
                frac_scale = 2.0 ** frac_len;
                magnitude = magnitude * (1.0 + (frac_val / frac_scale));
            end

            if (k >= 0) begin
                magnitude = magnitude * (useed ** k);
            end else begin
                magnitude = magnitude / (useed ** (-k));
            end
            
            if (sign_bit < 0) begin
                value_o = -$rtoi(magnitude + 0.5);
            end else begin
                value_o = $rtoi(magnitude + 0.5);
            end
        end
    end
endmodule
