//wrapper that selects architecture
//This module instantiates one 8x8 multiplier architecture
//To Switch Architecture:
//  Replace module name on line 11 with any of the architecture in rtl/multipliers

module image_multiplier(
    input  wire [7:0] pixel1,
    input  wire [7:0] pixel2,
    output wire [15:0] result
);
    jyothi4_wallace_tree_8x8 uut ( 
        .a(pixel1),
        .b(pixel2),
        .prod(result)
    );

endmodule