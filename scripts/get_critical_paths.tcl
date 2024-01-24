proc compute_critical_path {module data_width} {
    set_property generic DATAWIDTH=$data_width [current_fileset] -quiet
    set_property top $module [current_fileset] -quiet
    reset_run synth_1 -quiet
    launch_runs synth_1 -jobs 6 -quiet
    wait_on_runs synth_1 -quiet
    open_run synth_1 -name synth_1 -quiet
    set design_analysis [report_design_analysis -timing -setup -max_paths 1 -return_string -quiet]
    regexp {Path Delay\s*\|\s*(\S+)} $design_analysis matched critical_path
    return $critical_path
}

set modules {"REG" "ADD" "SUB" "MULT" "COMP" "MUX2x1" "SHR" "SHL" "DIV" "MOD" "INC" "DEC"}
set data_widths {2 8 16 32 64}
set critical_paths ""
foreach module $modules {
    append critical_paths [format "%-6s :" $module]
    foreach data_width $data_widths {
        set critical_path [compute_critical_path $module $data_width]
        append critical_paths [format " %7.3f" $critical_path]
    }
    append critical_paths "\n"
}
puts $critical_paths
