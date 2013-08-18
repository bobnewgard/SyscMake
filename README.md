## Introduction

This project implements a set of makefiles for projects based on SystemC
and Verilator.

The makefiles are structured to support ease of deployment for new projects
with a project directory structure like

        project
        |-- Makefile
        `-- tb_X
            |-- Makefile
            |-- tb.cxx
            |-- tb.h
            `-- test_Y
                |-- Makefile
                |-- sc_main.cxx
                |-- test.cxx
                `-- test.h

where X is {tbname, tbname,...} and Y is {testname,testname,...} such
that there are one or more testbenches tb\_X and one or more tests
test\_Y under each testbench.

The makefiles are
* vars.mk
    * Defines simple and multi-line make variables for use in other makefiles
* targ.mk
    * Defines the core make targets debug, help, lib, bld, sim and clean
* proj.mk
    * Template for the top-level project Makefile
    * Integrates make targets from the lower-level Makefiles as top-level
      targets
* node.mk
    * Template for Makefiles in build directories for libraries or executables
    * Implements make targets for libraries and/or executables

### Core Targets

* debug
    * For build directories, show the accumulated make variables
* help
    * For top directory, show the prerequisites that make up the core help target
    * For build directories, show library and/or executable build variables and targets
* lib
    * For top directory, build all the prerequisites that make up the core lib target
    * For build directories, build all library build targets
* bld
    * For top directory, build all the prerequisites that make up the core bld target
    * For build directories, build all executable build targets
* sim
    * For top directory, run all the prerequisites that make up the core sim target
    * For build directories, run all executables
* clean
    * For top directory, clean all the prerequisites that make up the core clean target
    * For build directories, clean all executables, libraries and dependency files

### Use Cases

* Automated build for verilog RTL unit tests using Verilator and SystemC

### Unsupported Use Cases

* TBD

### SystemC

SyscMake supports the [Accellera](http://www.accellera.org/home/)
implementation of the SystemC classes.

The path to the SystemC installation is set in vars.make using the
variable SYSC\_DIR.

### Verilator

SyscMake supports Verilator for compiling verilog units under test (UUTs)
into SystemC classes.

The verilator environment is wrapped around the verilator executable
using the "env-veripool" wrapper script such that the command

    env-veripool verilator --version

returns the verilator version and

    env-veripool

returns the verilator environment.

The paths to the Verilator and SystemC installation directories are
set in the env-veripool script using the variables VERIPOOL\_DIR and
SYSTEMC\_DIR, respectively.

### Using The Templates

#### proj.mk

In the top directory of the project make a copy the proj.mk template, rename
it to Makefile and modify it.  Declaration of core targets, targets
for Makefiles in sub-directories, dependencies between targets in
sub-directories and any auxiliary targets are done in this file.

From top to bottom:

1. Set SYSCMAKE to point to where the SyscMake repo is installed
1. vars.mk must be included before anything else
1. Note that the ACCUM variables may be modified if required by auxiliary targets
1. Declare library targets by evaluating calls to root-lib-targets
1. Declare build dependencies for executables (declared next) by
   evaluating calls to root-exe-deps
1. Declare executable targets by evaluating calls to root-exe-targets
1. Declare top-level core targets by evaluating root-targets
1. Add auxiliary targets if required
    * Extend the core help target with auxiliary help targets

#### node.mk

In build directories for libraries or executables make a copy the proj.mk
template, rename it to Makefile and modify it.  Declaration of include
file search paths, library search paths, libraries to build and
executables to build are done in this file.

From top to bottom:

1. Set SYSCMAKE to point to where the SyscMake repo is installed
1. vars.mk must be included before anything else
1. Note that the ACCUM variables may be modified if required by auxiliary targets
1. Declare include file search paths by evaluating calls to hdr-spec
    * these specs add -I args to gcc
1. Declare library search paths by evaluating calls to lib-spec
    * these specs add -I, -L and -l args to gcc
1. Declare libraries to build by evaluating calls to build-\*-lib
    * build-sysc-lib for libraries based on SystemC
    * build-ver-lib for libraries based on Verilated verilog
1. Declare executables to build by evaluating calls to build-exe
1. targ.mk must be included after these declaration and before auxiliary targets
1. Add auxiliary targets if required

#### Accumulated <code>make</code> Variables

* ACCUM\_BLD\_LIBS
    * Used TBD
* ACCUM\_CPP\_INCLUDES
    * Add -I arguments as required by auxiliary targets
* ACCUM\_CPP\_OPTS
    * Unused
* ACCUM\_INTERMEDIATE
    * Add .o files for auxiliary targets if they are to be discarded
      after building a library
    * Used to build the special make target .INTERMEDIATE
* ACCUM\_LINKER\_LIBS
    * Add -l_library_ arguments here as required by auxiliary targets
* ACCUM\_LINKER\_LIB\_DIRS
    * Add -L _library_ arguments here as required by auxiliary targets
* ACCUM\_PHONY\_TARGS
    * Add phony targets used by auxiliary targets
    * Used to build the special make target .PHONY
* ACCUM\_PREREQ\_BLD
    * Add auxiliary executable targets as prerequisite for core bld target
* ACCUM\_PREREQ\_CLEAN
    * Add auxiliary clean-up targets as prerequisite for core clean target
* ACCUM\_PREREQ\_HELP
    * Add auxiliary help targets as prerequisite for core help target
* ACCUM\_PREREQ\_LIB
    * Add auxiliary library targets as prerequisite for core lib target
* ACCUM\_PREREQ\_SIM
    * Add auxiliary executable (sim) targets as prerequisite for core sim target
* ACCUM\_PYTHONPATH
    * Add path to directory containing Python modules as required by auxiliary targets
    * Used to modify PYTHONPATH
* ACCUM\_SIM\_LIB\_DIRS
    * Add path to libraries required by auxiliary executables
    * Used to modify LD\_LIBRARY\_PATH
* ACCUM\_VLTR\_OPTS
    * Add Verilator options
    * Options specified here are added to the verilator command line

## Validated Environments

| Linux                | libc  | gcc   | SystemC | Verilator | make | bash   |
|----------------------|-------|-------|---------|-----------|------|--------|
| Debian 3.2.0-4-amd64 | 2.13  | 4.7.2 | 2.3.0   | 3.847     | 3.81 | 4.2.37 |

## Installation

1. Make sure you have installed the components shown in the
   "Validated Environments" section
    * Install SystemC from source, since it is unlikely to be
      packaged
1. Modify the path to the SystemC installation, SYSC\_DIR,
   in SyscMake/vars.mk
1. Modify the paths to the SystemC and Veripool installations, SYSTEMC\_DIR
   and VERIPOOL\_DIR respectively, in env-veripool.

## Issues

* Bug tracker TBD

## Comms

* Mailing list TBD

## License

### License for Code

The code in this project is licensed under the GPLv3

### License for This Project Summary

This work is licensed under the Creative Commons Attribution-ShareAlike 3.0
Unported License. To view a copy of this license, visit
http://creativecommons.org/licenses/by-sa/3.0/. 
