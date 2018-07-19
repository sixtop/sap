module ROM #(parameter WordSize = 8, parameter AddressSize = 4)(
	//control signals
	input logic CE_bar

	//input address
    input logic [AddressSize-1:0] ROM_address,

    //output data
    output logic [WordSize-1:0] ROM_data,    
    );
    
    reg [WordSize-1:0] rom [0:(1<<AddressSize)-1];
    
    initial begin
        $readmemh("./src/rom.bin", rom);
    end

    assign ROM_data = CE_bar ? rom[ROM_address] : {WordSize{1'bz}};
    
endmodule

    