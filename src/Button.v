`define NUM_STAGES 2

`ifdef BK_TEST
`define DEBOUNCE_DELAY 4
`else
`define DEBOUNCE_DELAY 50000
`endif

`define DEBOUNCE_LEN 19

module Button(input button,
              output reg pressed,
              output reg pulse,

              input clk
              );

   reg [`NUM_STAGES-1:0] stages = 0;
   reg                   sync_button;

   reg [`DEBOUNCE_LEN-1:0] debounce_timer = 0;
   reg                     pulsed = 0;

   always @(posedge clk) begin
      stages <= {stages[`NUM_STAGES-2:0], button};
      sync_button <= stages[`NUM_STAGES - 1];

      pulse <= 0;
      pressed <= 0;

      if (sync_button) begin
         if (debounce_timer == `DEBOUNCE_DELAY) begin
            pressed <= 1;
            if (!pulsed) begin
               pulse <= 1;
               pulsed <= 1;
            end
         end else begin
            debounce_timer <= debounce_timer + 1;
         end
      end else begin
         debounce_timer <= 0;
         pulsed <= 0;
      end
   end
endmodule
