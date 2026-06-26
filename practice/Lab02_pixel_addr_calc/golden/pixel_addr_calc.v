module pixel_addr_calc (
    input  [9:0] x,
    input  [8:0] y,

    output [18:0] pixel_index,
    output [19:0] byte_addr,

    output [5:0] tile_x,
    output [4:0] tile_y,
    output [10:0] tile_index,

    output [3:0] local_x,
    output [3:0] local_y,
    output [7:0] sprite_addr
);

localparam SCREEN_W = 640;
localparam TILES_X  = 40;

assign pixel_index = y * SCREEN_W + x;
assign byte_addr = pixel_index << 1;

assign tile_x = x >> 4;
assign tile_y = y >> 4;
assign tile_index = tile_y * TILES_X + tile_x;

assign local_x = x[3:0];
assign local_y = y[3:0];

assign sprite_addr = (local_y << 4) + local_x;

endmodule
