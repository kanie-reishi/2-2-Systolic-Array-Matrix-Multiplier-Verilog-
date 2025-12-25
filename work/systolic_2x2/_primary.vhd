library verilog;
use verilog.vl_types.all;
entity systolic_2x2 is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        load_en         : in     vl_logic;
        data_in         : in     vl_logic_vector(15 downto 0);
        weight_in       : in     vl_logic_vector(15 downto 0);
        result_row0     : out    vl_logic_vector(31 downto 0);
        result_row1     : out    vl_logic_vector(31 downto 0)
    );
end systolic_2x2;
