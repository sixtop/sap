module ROM #(parameter WordSize = 8, parameter AddressSize = 4)(
    input logic [AddressSize-1:0] address,
    output logic [WordSize-1:0] data,
    input logic CE_bar
    );
    
    reg [WordSize-1:0] rom [0:(1<<AddressSize)-1];
    
    initial begin
        $readmemh("./src/rom.bin", rom);
    end
    
    
    assign data = CE_bar ? rom[address] : {WordSize{1'bz}};
    
endmodule

    