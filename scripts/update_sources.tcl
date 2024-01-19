proc update_fileset {src_dir fileset} {
    set src_files {}
    set src_files [file normalize [glob  -nocomplain "${src_dir}/*"]]
    set prj_files [file normalize [get_files -of_objects [get_filesets $fileset] -quiet]]
    if {[llength $src_files]} {
        foreach src_file $src_files {
            set match 0
            if {[llength $prj_files]} {
                foreach prf_file $prj_files {
                    if {[string equal $prj_file $src_file]} {
                        set match 1
                    }
                }
            }
            if {$match == 0} {
                add_files -fileset $fileset $src_file
            }
        }
    }
    if {[llength $prj_files]} {
        foreach prj_file $prj_files {
            set match 0
            if {[llength $src_files]} {
                foreach src_file $src_files {
                    if {[string equal $prj_file $src_file]} {
                        set match 1
                    }
                }
            }
            if {$match == 0} {
                remove_files -fileset $fileset $prj_file
            }
        }
    }
    update_compile_order -fileset $fileset
}

update_fileset ./src sources_1