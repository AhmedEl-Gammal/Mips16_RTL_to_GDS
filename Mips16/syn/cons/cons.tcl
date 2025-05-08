##################################################
		# ----- Clock Definations -----  # 
##################################################

# --- Budget Clock (Timing Definations)
create_clock -name clk -period 6 -waveform {0 3} [get_ports clk]

# --- Clock uncertainty Berfore CTS  uncertainty = Jitter + Source Latency  + Network Latency 
set_clock_uncertainty -setup 0.3 [get_clocks clk]  ;  # Consider Skew + Jitter 
set_clock_uncertainty -hold  0.2  [get_clocks clk] ;  # only Consider Skew   

# --- Modeling outside for Timing 
# -- Type of Path IN to Reg >> pesudo as [input_delay =  Tcq + Tpd ] 
set_input_delay  -clock clk -max 0.3  [remove_from_collection [all_inputs] [get_ports clk]]
 
# -- Type of Path Reg to Output >> pesudo as [output_delay = Tpd + Tsetup ] 
set_output_delay -max 0.3 -clock clk [all_outputs] 

# --- Prevent Tool do any thing on network 
set_dont_touch_network [get_clocks clk]
##################################################
		# ----- Optimization ---------  # 
##################################################
set_max_area 0.0 
set_max_capacitance 3.0 [current_design]
set_max_delay 6 -from pc_current_reg[1] -through pc_current_reg[13] 
set_max_delay 6 -from pc_current_reg[1] -through pc_current_reg[12] 
##################################################
		# ----- Interaface  ---------  # 
##################################################
set_driving_cell -lib_cell NBUFFX2 -pin Z [remove_from_collection [all_inputs] [get_ports clk] ];
set_load 1.5 [all_outputs]

##################################################
		# ----- Operating Conditions ---------  # 
##################################################

# # Clear existing scenarios
# remove_scenario -all 
# # Create operational scenarios
# create_scenario func_wc ;   # Worst-case functional
# # Worst-case (slow corner)
# set_operating_conditions -max "WORST" -max_library saed90nm_max
