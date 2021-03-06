----------------------------
-- Hardware
----------------------------
To re-create a Vivado project:

You must have Vivado 2015.4 installed and the Digilent board files (as
instructed here: https://reference.digilentinc.com/vivado:boardfiles2015).
Then do the following:

0. Make sure the /proj does not already contain a project with the same name. 
   You may run cleanup.cmd to delete everything except the utility files.
1. Open either the Vivado Tcl shell or the Tcl Window in Vivado GUI 
2. cd to proj folder found in the same folder as this readme 
   For example: <board repo>/Projects/<project name>/proj
3. At the TCL console, run: source ./create_project.tcl
4. [Optional] To build the project: At the TCL console, run:
   source ./build_project.tcl

To make sure changes to the project are checked into git:
	Export hardware with bitstream to ./hw_handoff/.
	Export block design to ./src/bd/, if there is one.
	If there are changes to the Vivado project settings, go to File -> 
    Write Project TCL. Copy relevant TCL commands to proj/create_project.tcl. 
    This is the only project-relevant file checked into Git.
	Store all the project sources in src/. Design files go into src/hdl/, 
    constraints into src/constraints.
	Any IPs instantiated OUTSIDE BLOCK DESIGNS need to be created in /src/ip. 
    Use the IP Location button in the IP customization wizard to specify a 
    target directory. Only *.xci and *.prj files are checked in from here.
	If using MIG outside block designs, manually move the MIG IP to the 
    src/ip folder.

----------------------------
-- Software
----------------------------
[OPTIONAL]: If you wish to use your own HDF, please make sure the "system.hdf"
            in "./sdk/hdmi_out_wrapper_hw_platform_0" is updated with the
            latest hdf, hdmi_out_wrapper.hdf, generated in the Vivado
            hardware project. (not required if build_project.tcl is used)

Workspace folder: ./sdk
The workspace folder is versioned on Git without workspace information. This
means that when first cloning the repository and opening the ./sdk folder
as workspace, it will be empty in SDK. The workspace needs to be re-built
locally by manually importing projects, BSPs and hardware platforms. Once
this is done locally the first time, subsequent git pulls will not touch
the workspace. New imports will only be necessary when new projects appear.

To import the project:
  1. Use File -> Import -> Existing projects into Workspace
  2. Select ./sdk as root directory.
  3. Check the projects you want imported
  4. Make sure "Copy projects into workspace" is unchecked.

"Internal Error" during BSP import can be ignored. Just re-generate BSPs.

Projects:
  Videodemo: Runs a video input/output demo using the HDMI input and VGA
             output. Controlled over UART with a baud of 115200.
