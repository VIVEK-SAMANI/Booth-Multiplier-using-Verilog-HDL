`timescale 1ns / 1ps

module Booth_Multiplier(
    input Rst, Clk,
    input [3:0] Multiplicand, Multiplier,
    output reg Valid,
    output reg [7:0] Mul
    );

parameter case1 = 2'b00, case2 = 2'b01, case3 = 2'b10, case4 = 2'b11;

reg Qm1 = 0;        
reg [2:0] Count = 4;
reg [3:0] Acc = 4'b0, M = 4'b0, Q = 4'b0;

always@(negedge Clk or posedge Rst)
begin
    if(Rst)
    begin
        M <= Multiplicand;
        Q <= Multiplier;
        Mul <= 8'b0;
        Acc = 4'b0;
        Count <= 4;
        Valid = 0;
        Qm1 = 0;
    end
    
    else if(Count != 0)
    begin
        case({Q[0],Qm1})
        case1:
        begin
            {Acc,Q,Qm1} = {Acc[3],Acc[3:1],Acc[0],Q[3:1],Q[0]};
            Count = Count - 1;
            Valid = 0;
            Mul = 8'b0;
            $display("Acc:%b,\tQ:%b,\tQ-1:%b,\tCount:%d", Acc,Q,Qm1,Count);
        end
                        
        case2:  
        begin
            Acc = Acc + M;
            {Acc,Q,Qm1} = {Acc[3],Acc[3:1],Acc[0],Q[3:1],Q[0]};
            Count = Count - 1;
            Valid = 0;
            Mul = 8'b0;
            $display("Acc:%b,\tQ:%b,\tQ-1:%b,\tCount:%d", Acc,Q,Qm1,Count);
        end
                
        case3:  
        begin
            Acc = Acc + ((~M) + 1);
            {Acc,Q,Qm1} = {Acc[3],Acc[3:1],Acc[0],Q[3:1],Q[0]};
            Count = Count - 1;
            Valid = 0;
            Mul = 4'b0;
            $display("Acc:%b,\tQ:%b,\tQ-1:%b,\tCount:%d", Acc,Q,Qm1,Count);
        end

        case4:  
        begin
            {Acc,Q,Qm1} = {Acc[3],Acc[3:1],Acc[0],Q[3:1],Q[0]};
            Count = Count - 1;
            Valid = 0;
            Mul = 8'b0;
            $display("Acc:%b,\tQ:%b,\tQ-1:%b,\tCount:%d", Acc,Q,Qm1,Count);           
        end
                
        default: Mul = 8'b0;
            
        endcase
    end
    
    else
        Valid = 1;
        assign Mul = {Acc,Q};
end
    
endmodule
