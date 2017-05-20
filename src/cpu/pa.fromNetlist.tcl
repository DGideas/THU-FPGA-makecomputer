
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name cpu -dir "/home/dgideas/VHDL/THU-FPGA-makecomputer/src/cpu/planAhead_run_4" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/dgideas/VHDL/THU-FPGA-makecomputer/src/cpu/cpu_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/dgideas/VHDL/THU-FPGA-makecomputer/src/cpu} }
set_property target_constrs_file "cpu_top.ucf" [current_fileset -constrset]
add_files [list {cpu_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
