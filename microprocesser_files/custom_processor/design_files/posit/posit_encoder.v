module posit_encoder #(
    parameter WIDTH = 8,
    parameter ES = 2
) (
    input signed [31:0] value_i,
    output reg [WIDTH-1:0] posit_o
);

    localparam MAX_REGIME_BITS = WIDTH - 1 - ES;

    integer i;
    integer sign_bit;
    integer abs_val;
    real x;
    real useed;
    real temp;
    integer k;
    integer regime_size;
    integer exp_val;
    integer frac_len;
    integer frac_val;
    real frac;
    reg [WIDTH-1:0] bits;
    integer idx;

    always @(*) begin
        if (value_i == 0) begin
            posit_o = {WIDTH{1'b0}};
        end else begin
            sign_bit = (value_i < 0) ? 1 : 0;
            abs_val = (value_i < 0) ? -value_i : value_i;
            x = abs_val;

            useed = 2.0 ** (2.0 ** ES);
            temp = x;
            k = 0;

            if (temp >= 1.0) begin
                while (temp >= useed) begin
                    temp = temp / useed;
                    k = k + 1;
                end
            end else begin
                while (temp < 1.0) begin
                    temp = temp * useed;
                    k = k - 1;
                end
            end

            exp_val = 0;
            while (temp >= 2.0) begin
                temp = temp / 2.0;
                exp_val = exp_val + 1;
            end
            frac = temp - 1.0;

            if (k >= 0) begin
                regime_size = k + 2;
                if (regime_size > MAX_REGIME_BITS) begin
                    regime_size = MAX_REGIME_BITS;
                end
            end else begin
                regime_size = -k + 1;
                if (regime_size > MAX_REGIME_BITS) begin
                    regime_size = MAX_REGIME_BITS;
                end
            end

            frac_len = WIDTH - 1 - regime_size - ES;
            if (frac_len < 0) begin
                frac_len = 0;
            end

            if (frac_len > 0) begin
                frac_val = $rtoi(frac * (2.0 ** frac_len) + 0.5);
                if (frac_val >= (1 << frac_len)) begin
                    frac_val = (1 << frac_len) - 1;
                end
            end else begin
                frac_val = 0;
            end

            bits = {WIDTH{1'b0}};
            bits[WIDTH-1] = sign_bit[0] ? 1'b1 : 1'b0;
            idx = WIDTH - 2;

            if (k >= 0) begin
                for (i = 0; i < regime_size; i = i + 1) begin
                    if (i < (k + 1)) begin
                        bits[idx] = 1'b1;
                    end else begin
                        bits[idx] = 1'b0;
                    end
                    idx = idx - 1;
                end
            end else begin
                for (i = 0; i < regime_size; i = i + 1) begin
                    if (i < (-k)) begin
                        bits[idx] = 1'b0;
                    end else begin
                        bits[idx] = 1'b1;
                    end
                    idx = idx - 1;
                end
            end

            for (i = 0; i < ES; i = i + 1) begin
                if (idx >= 0) begin
                    bits[idx] = (exp_val >> (ES - 1 - i)) & 1'b1;
                    idx = idx - 1;
                end
            end

            for (i = 0; i < frac_len; i = i + 1) begin
                if (idx >= 0) begin
                    bits[idx] = (frac_val >> (frac_len - 1 - i)) & 1'b1;
                    idx = idx - 1;
                end
            end

            posit_o = bits;
        end
    end
endmodule
