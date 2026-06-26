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

parameter SCREEN_W = 640;
parameter TILES_X  = 40;

// pixel_index = y * 640 + x
assign pixel_index = ...;

// RGB565 uses 2 bytes per pixel.
assign byte_addr = ...;

// tile_x = x / 16
assign tile_x = ...;

// tile_y = y / 16
assign tile_y = ...;

// tile_index = tile_y * 40 + tile_x
assign tile_index = ...;

// local_x = x % 16
assign local_x = ...;

// local_y = y % 16
assign local_y = ...;

// sprite_addr = local_y * 16 + local_x
assign sprite_addr = ...;

endmodule
