library verilog;
use verilog.vl_types.all;
entity processing_element is
    generic(
        DATA_WIDTH      : integer := 16
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        load_en         : in     vl_logic;
        data_in         : in     vl_logic_vector;
        sum_in          : in     vl_logic_vector;
        weight_in       : in     vl_logic_vector;
        weight_out      : out    vl_logic_vector;
        sum_out         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
end processing_element;
