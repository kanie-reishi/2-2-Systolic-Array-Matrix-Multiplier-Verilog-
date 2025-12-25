`timescale 1ns/1ps

module tb_systolic_2x2;

    // 1. Khai báo tín hiệu
    reg clk;
    reg rst_n;
    reg load_en;
    reg signed [15:0] data_in;
    reg signed [15:0] weight_in;

    wire signed [31:0] result_row0;
    wire signed [31:0] result_row1;

    // 2. Instantiate DUT (Device Under Test)
    systolic_2x2 uut (
        .clk(clk),
        .rst_n(rst_n),
        .load_en(load_en),
        .data_in(data_in),
        .weight_in(weight_in),
        .result_row0(result_row0),
        .result_row1(result_row1)
    );

    // 3. Tạo Clock (Chu kỳ 10ns -> 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 4. Chương trình kiểm tra chính
    initial begin
        // --- SETUP ---
        $display("===========================================");
        $display("   TESTBENCH FOR SYSTOLIC ARRAY 2x2");
        $display("===========================================");
        
        // Reset hệ thống
        rst_n = 0;
        load_en = 0;
        data_in = 0;
        weight_in = 0;
        #20;
        rst_n = 1;
        #10;

        // --- GIAI ĐOẠN 1: NẠP WEIGHT (LOADING PHASE) ---
        // Ma trận mong muốn:
        // | 2   3 |  (Row 0)
        // | 4   5 |  (Row 1)
        //
        // Thứ tự nạp vào chuỗi: PE00 -> PE01 -> PE10 -> PE11
        // Để PE11 nhận số 5, ta phải nạp số 5 ĐẦU TIÊN.
        // Để PE00 nhận số 2, ta phải nạp số 2 CUỐI CÙNG.
        // Thứ tự nạp: 5 -> 4 -> 3 -> 2
        
        $display("[T=0] Start Loading Weights...");
        load_en = 1;

        input_weight(16'd5); // Vào PE00, trôi dần xuống PE11
        input_weight(16'd4); // Vào PE00, trôi dần xuống PE10
        input_weight(16'd3); // Vào PE00, trôi dần xuống PE01
        input_weight(16'd2); // Nằm lại ở PE00

        load_en = 0; // Kết thúc nạp, chốt Weight lại
        weight_in = 0;
        $display("[T=Now] Loading Done. Weights locked.");
        #10;

        // --- GIAI ĐOẠN 2: TÍNH TOÁN (COMPUTE PHASE) ---
        // Vector Input: x = 10, y = 20.
        // Expectation:
        // Row 0: 2*10 + 3*20 = 20 + 60 = 80
        // Row 1: 4*10 + 5*20 = 40 + 100 = 140
        
        $display("[T=Now] Start Streaming Data...");
        
        // Nhịp 1: Bắn x = 10
        input_data(16'd10); 
        // Tại thời điểm này:
        // PE00 tính 2*10 = 20.
        // PE10 tính 4*10 = 40.
        
        // Nhịp 2: Bắn y = 20
        input_data(16'd20);
        // Tại thời điểm này:
        // PE01 lấy output của PE00 (là 20) + 3*20 = 80.
        // PE11 lấy output của PE10 (là 40) + 5*20 = 140.
        
        // Ngắt input
        data_in = 0;
        
        #1; // Delay nhỏ để tránh race condition khi đọc

        // --- CHECK KẾT QUẢ ---
        $display("-------------------------------------------");
        $display("CHECKING RESULTS:");
        
        // Check Row 0
        if (result_row0 === 32'd80) 
            $display("ROW 0: PASSED (Expected 80, Got %d)", result_row0);
        else 
            $display("ROW 0: FAILED (Expected 80, Got %d)", result_row0);

        // Check Row 1
        if (result_row1 === 32'd140) 
            $display("ROW 1: PASSED (Expected 140, Got %d)", result_row1);
        else 
            $display("ROW 1: FAILED (Expected 140, Got %d)", result_row1);
            
        $display("-------------------------------------------");
        $finish;
    end

    // --- Task hỗ trợ nạp Weight ---
    task input_weight(input [15:0] val);
        begin
            weight_in = val;
            @(posedge clk); // Đợi 1 nhịp để đẩy vào
        end
    endtask

    // --- Task hỗ trợ bắn Data ---
    task input_data(input [15:0] val);
        begin
            data_in = val;
            @(posedge clk); // Đợi 1 nhịp để tính
        end
    endtask

    // --- Monitor Waveform (Optional) ---
    initial begin
        $dumpfile("systolic_test.vcd");
        $dumpvars(0, tb_systolic_2x2);
    end

endmodule