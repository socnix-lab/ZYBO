# build hardware project and export the hdf to required location

if {[info exists ::create_path]} {
	set dest_dir $::create_path
} else {
	set dest_dir [file normalize [file dirname [info script]]]
}
puts "INFO: project path - $dest_dir"
cd $dest_dir

set proj_name "hdmi_out"

set bd_design [get_files ${proj_name}.bd]
open_bd_design $bd_design
generate_target {synthesis simulation implementation} $bd_design
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
synth_design
opt_design
place_design
route_design
phys_opt_design

set sdk_path ${dest_dir}/${proj_name}.sdk
file mkdir ${sdk_path}
set bitstream ${sdk_path}/${proj_name}_wrapper.bit
set dest_hdf ${sdk_path}/${proj_name}_wrapper.hdf

# generate bitstream
write_bitstream -verbose -force ${bitstream}

# generate hwdef
write_hwdef -force -file ${sdk_path}/system.hdf

# generate the hdf with download.bit
write_sysdef -force -hwdef ${sdk_path}/system.hdf -bitfile ${bitstream} -file ${sdk_path}/final.hdf
file delete -force --  ${sdk_path}/system.hdf
file rename -force ${sdk_path}/final.hdf ${dest_hdf}

# copy hdf to hw_handoff
file copy -force -- ${dest_hdf} ${dest_dir}/../hw_handoff/${proj_name}_wrapper.hdf

# copy hdf to sdk/hdmi_out_wrapper_hw_platform_0
file copy -force -- ${dest_hdf} ${dest_dir}/../sdk/hdmi_out_wrapper_hw_platform_0/system.hdf
