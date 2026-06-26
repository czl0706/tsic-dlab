module blockram #(
    parameter ADDR_WIDTH = 15,
    parameter DATA_WIDTH = 12,
    parameter DEPTH      = 160 * 120
)(
    input  wire                    clk,

    // Read port
    input  wire [ADDR_WIDTH-1:0]   raddr,
    output reg  [DATA_WIDTH-1:0]   rdata,

    // Write port
    input  wire                    we,
    input  wire [ADDR_WIDTH-1:0]   waddr,
    input  wire [DATA_WIDTH-1:0]   wdata
);

// TODO: declare the 2D memory array
// Which has DEPTH rows, each row has DATA_WIDTH bits
reg [... : 0] mem [0 : ...]; 

always @(posedge clk) begin
    // Write port
    if (we) begin
        mem[waddr] <= wdata;
    end

    // Read port
    rdata <= mem[raddr];
end

endmodule