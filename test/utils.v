`ifndef __utils_v
 `define assert_eq(a,b) assert(a==b) else begin $display("%5d FAIL: %h != %h", `__LINE__, a, b); $fatal ; end
`endif
