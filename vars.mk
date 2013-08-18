#
# Copyright 2013 Robert Newgard
#
# This file is part of SyscMake.
#
# SyscMake is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SyscMake is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SyscMake.  If not, see <http://www.gnu.org/licenses/>.
#

THIS := vars.mk

define syscmake-requirement
    This makefile is meant to be included from a top-level Makefile, and
    that top-level makefile must set SYSCMAKE to point to the directory
    this file resides in.  SYSCMAKE was not set or was set to the wrong path 
endef

ifeq '$(wildcard $(SYSCMAKE)/$(THIS))' ''
 $(error Error: $(strip $(syscmake-requirement)))
endif

.SUFFIXES:
MAKEFLAGS += --no-builtin-rules
unexport MAKEFLAGS

SHELL     := /bin/bash
COLS      := $(shell tput cols)
FMT       := fmt -w $(COLS)
SP        := $(NIL) $(NIL)
HERE      := .
UP_ONE    := ..
UP_TWO    := $(UP_ONE)/..
UP_THREE  := $(UP_TWO)/..
SYSC_DIR  := /opt/systemc/2.3.0
SYSC_ODIR := $(SYSC_DIR)/lib-linux64
SYSC_IDIR := $(SYSC_DIR)/include
VLTR_IDIR := /opt/Veripool/share/verilator/include
VPOOL_ENV := $(SYSCMAKE)/env-veripool
CXX_VER   := -x c++ -std=c++11
CFLAGS    := -Wall -m64 -g -pthread -fPIC
DFLAGS    := -DSC_INCLUDE_FX
LFLAGS    := -Wl,-rpath -Wl,$(SYSC_ODIR)

ACCUM_BLD_LIBS         +=
ACCUM_CPP_INCLUDES     += -isystem $(SYSC_IDIR)
ACCUM_CPP_OPTS         +=
ACCUM_INTERMEDIATE     +=
ACCUM_LINKER_LIBS      += -lsystemc -lm -pthread
ACCUM_LINKER_LIB_DIRS  += -L $(SYSC_ODIR)
ACCUM_PHONY_TARGS      +=
ACCUM_PREREQ_BLD       +=
ACCUM_PREREQ_CLEAN     +=
ACCUM_PREREQ_HELP      +=
ACCUM_PREREQ_LIB       +=
ACCUM_PREREQ_SIM       +=
ACCUM_PYTHONPATH       +=
ACCUM_SIM_LIB_DIRS     +=
ACCUM_VLTR_OPTS        += -Wall

define help-recipe
    @echo   "    accumulated variables"
    @echo   "        ACCUM_BLD_LIBS:"        
    @echo   "            $(strip $(ACCUM_BLD_LIBS))" | $(FMT)
    @echo   "        ACCUM_CPP_INCLUDES:"       
    @echo   "            $(strip $(ACCUM_CPP_INCLUDES))" | $(FMT)
    @echo   "        ACCUM_CPP_OPTS:"           
    @echo   "            $(strip $(ACCUM_CPP_OPTS))" | $(FMT)
    @echo   "        ACCUM_INTERMEDIATE:"       
    @echo   "            $(strip $(ACCUM_INTERMEDIATE))" | $(FMT)
    @echo   "        ACCUM_LINKER_LIBS:"        
    @echo   "            $(strip $(ACCUM_LINKER_LIBS))" | $(FMT)
    @echo   "        ACCUM_LINKER_LIB_DIRS:"    
    @echo   "            $(strip $(ACCUM_LINKER_LIB_DIRS))" | $(FMT)
    @echo   "        ACCUM_PHONY_TARGS:"        
    @echo   "            $(strip $(ACCUM_PHONY_TARGS))" | $(FMT)
    @echo   "        ACCUM_PREREQ_BLD:"       
    @echo   "            $(strip $(ACCUM_PREREQ_BLD))" | $(FMT)
    @echo   "        ACCUM_PREREQ_CLEAN:"       
    @echo   "            $(strip $(ACCUM_PREREQ_CLEAN))" | $(FMT)
    @echo   "        ACCUM_PREREQ_HELP:"        
    @echo   "            $(strip $(ACCUM_PREREQ_HELP))" | $(FMT)
    @echo   "        ACCUM_PREREQ_LIB:"         
    @echo   "            $(strip $(ACCUM_PREREQ_LIB))" | $(FMT)
    @echo   "        ACCUM_PREREQ_SIM:"       
    @echo   "            $(strip $(ACCUM_PREREQ_SIM))" | $(FMT)
    @echo   "        ACCUM_PYTHONPATH:"       
    @echo   "            $(strip $(ACCUM_PYTHONPATH))" | $(FMT)
    @echo   "        ACCUM_SIM_LIB_DIRS:"        
    @echo   "            $(strip $(ACCUM_SIM_LIB_DIRS))" | $(FMT)
    @echo   "        ACCUM_VLTR_OPTS:"        
    @echo   "            $(strip $(ACCUM_VLTR_OPTS))" | $(FMT)
    @echo   "    exported environment variables"
    @echo   "        $$(export -p | grep LD_LIBRARY_PATH)"
    @echo   "        $$(export -p | grep PYTHONPATH)"
endef

define compile-for-obj
	g++ $(CXX_VER) -c $(DFLAGS) $(ACCUM_CPP_INCLUDES) $(CFLAGS) -o $@ $<
endef

define ar-for-archive
        ar cr $@ $%
	ranlib $@
	rm $%
endef

define link-for-shared-obj
	@echo "[INF] linking shared library \"$(1)\" from archive \"$(2)\""
	g++ $(CFLAGS) -shared -Wl,--whole-archive $(2) -Wl,--no-whole-archive -o $(1)
endef

define link-for-executable
	g++ $(CFLAGS) -o $@ $(ACCUM_LINKER_LIB_DIRS) $(ACCUM_LINKER_LIBS) $(LFLAGS)
endef

define cpp-for-depends
	@echo "[INF] building \"$(1)\" from \"$(2)\""
	rm -f $(1)
        for file in $(2) ; do cpp $(CXX_VER) -MM -MG          $(ACCUM_CPP_INCLUDES) $$file ; done >> $(1)
        for file in $(2) ; do cpp $(CXX_VER) -MM -MG -MT $(1) $(ACCUM_CPP_INCLUDES) $$file ; done >> $(1)
endef

define ver-verilate
	@echo "[INF] building archive \"$(1)/obj_dir/V$(basename $(2))__ALL.a\""
	cd $(1) && $(VPOOL_ENV) verilator $(ACCUM_VLTR_OPTS) --sc --trace $(notdir $(2))
	cd $(1)/obj_dir && $(MAKE) -f V$(basename $(2)).mk V$(basename $(2))__ALL.a
	cd $(1)/obj_dir && $(MAKE) -f V$(basename $(2)).mk verilated.o verilated_vcd_c.o verilated_vcd_sc.o
endef

define ver-combine
	@echo "[INF] creating archive \"$(1)\" with \"$(2)\" and \"$(3)\""
	mkdir -p tmp
	cd tmp ; for AR in $(2) ; do ar x ../$$AR ; done
	cd tmp ; ar crv ../$(1) *.o
	rm -rf tmp
	ar rv $(1) $(3)
	ranlib $(1)
endef

define build-sysc-lib
    ifneq ($(findstring clean,$(MAKECMDGOALS)),clean)
	include $(1)-dep.mk
    endif

    SRC_$(1) := $(2)
    OBJ_$(1) := $$(foreach FN,$(2),$$(patsubst %.cxx,%.o,$$(FN)))
    ART_$(1) := lib$(1).a($$(OBJ_$(1)))
    ARF_$(1) := lib$(1).a
    LIB_$(1) := lib$(1).so

    define $(1)-help-recipe
    	@echo   "$(1)-help"
    	@echo   "    parameters"
    	@printf "        \x24(1) - library name:      \"$(1)\"\n"
    	@printf "        \x24(2) - list of cxx files:\n"
    	@echo   "            $(2)" | $(FMT)
    	@echo   "    includes"
    	@echo   "        \"$(1)-dep.mk\""
    	@echo   "    variables"
    	@echo   "        ART_$(1): $$(ART_$(1))"
    	@echo   "        ARF_$(1): $$(ARF_$(1))"
    	@echo   "        LIB_$(1): $$(LIB_$(1))"
    	@echo   "        OBJ_$(1):"
    	@echo   "            $$(OBJ_$(1))" | $(FMT)
    	@echo   "        SRC_$(1):"
    	@echo   "            $$(SRC_$(1))" | $(FMT)
    	@echo   "    targets"
    	@echo   "       $(1)-dep      build dependency file $(1)-dep.mk"
    	@echo   "       $(1)-dep-show show dependency file $(1)-dep.mk"
    	@echo   "       $(1)-lib      build libraries $(1).a and $(1).so"
    	@echo   "       $(1)-clean    remove libraries and dependency file"
    endef

    $(1)-dep.mk : $$(SRC_$(1))           ; $$(call cpp-for-depends,$(1)-dep.mk,$$(SRC_$(1)))
    $(1)-dep         : $(1)-dep.mk       ;
    $(1)-dep-show    : $(1)-dep               ; @cat $(1)-dep.mk
    $$(ARF_$(1))     : $$(ART_$(1))           ;
    $$(LIB_$(1))     : $$(ARF_$(1))           ; $$(call link-for-shared-obj,$$(LIB_$(1)),$$(ARF_$(1)))
    $(1)-lib         : $$(LIB_$(1))           ; 
    $(1)-clean       :                        ; rm -rf $$(LIB_$(1)) $$(ARF_$(1)) $(1)-dep.mk
    $(1)-help        :                        ; $$($(1)-help-recipe)

    ACCUM_CPP_INCLUDES     += -I .
    ACCUM_INTERMEDIATE     += $$(OBJ_$(1))
    ACCUM_LINKER_LIBS      += -l$(1)
    ACCUM_LINKER_LIB_DIRS  += -L .
    ACCUM_PHONY_TARGS      += $(1)-dep $(1)-dep-show $(1)-lib $(1)-clean $(1)-help
    ACCUM_PREREQ_CLEAN     += $(1)-clean
    ACCUM_PREREQ_HELP      += $(1)-help
    ACCUM_PREREQ_LIB       += $(1)-lib
endef

define build-ver-lib
    export SYSTEMC_INCLUDE=$(SYSC_IDIR)
    export SYSTEMC_LIBDIR=$(SYSC_ODIR)
    export SYSTEMC_CXX_FLAGS=-pthread -fPIC

    SRC_$(1) := $(2)
    BAS_$(1) := $$(foreach FN,$$(SRC_$(1)),$$(notdir $$(basename $$(FN))))
    DEL_$(1) := $$(foreach BN,$$(BAS_$(1)),obj_dir/V$$(BN)*)
    ARV_$(1) := $$(foreach BN,$$(BAS_$(1)),obj_dir/V$$(BN)__ALL.a)
    OBJ_$(1) := obj_dir/verilated.o obj_dir/verilated_vcd_c.o obj_dir/verilated_vcd_sc.o
    ARF_$(1) := obj_dir/lib$(1).a
    LIB_$(1) := obj_dir/lib$(1).so

    define $(1)-help-recipe
    	@echo   "$(1)-help"
    	@echo   "    parameters"
    	@printf "        \x24(1) - library name:      \"$(1)\"\n"
    	@printf "        \x24(2) - list of verilog files:\n"
    	@echo   "            $(2)" | $(FMT)
    	@echo   "    variables"
    	@echo   "        SRC_$(1):"
    	@echo   "            $$(SRC_$(1))" | $(FMT)
    	@echo   "        BAS_$(1):"
    	@echo   "            $$(BAS_$(1))" | $(FMT)
    	@echo   "        DEL_$(1):"
    	@echo   "            $$(DEL_$(1))" | $(FMT)
    	@echo   "        ARV_$(1):"
    	@echo   "            $$(ARV_$(1))" | $(FMT)
    	@echo   "        OBJ_$(1):"
    	@echo   "            $$(OBJ_$(1))" | $(FMT)
    	@echo   "        ARF_$(1): $$(ARF_$(1))"
    	@echo   "        LIB_$(1): $$(LIB_$(1))"
    	@echo   "    targets"
    	@echo   "       $(1)-verilate build verilated static libraries"
    	@echo   "       $(1)-archive  combine verilated static libraries"
    	@echo   "       $(1)-lib      build relocatable library"
    	@echo   "       $(1)-clean    remove objects and libraries"
    endef

    obj_dir/V%__ALL.a      : %.v                       ; $$(call ver-verilate,$$(<D),$$(<F))
    $$(ARF_$(1))           : $$(ARV_$(1))              ; $$(call ver-combine,$$@,$$^,$$(OBJ_$(1)))
    $$(LIB_$(1))           : $$(ARF_$(1))              ; $$(call link-for-shared-obj,$$@,$$<)
    $(1)-verilate          : $$(ARV_$(1))              ;
    $(1)-archive           : $$(ARF_$(1))              ;
    $(1)-lib               : $$(LIB_$(1))              ;
    $(1)-clean             :                           ; rm -rf $$(DEL_$(1)) $$(ARF_$(1)) $$(OBJ_$(1)) $$(LIB_$(1))
    $(1)-help              :                           ; $$($(1)-help-recipe)

    ACCUM_CPP_INCLUDES     += -I obj_dir -I $(VLTR_IDIR)
    ACCUM_LINKER_LIBS      += -l$(1)
    ACCUM_LINKER_LIB_DIRS  += -L obj_dir
    ACCUM_PHONY_TARGS      += $(1)-verilate $(1)-archive $(1)-lib $(1)-clean $(1)-help
    ACCUM_PREREQ_CLEAN     += $(1)-clean
    ACCUM_PREREQ_HELP      += $(1)-help
    ACCUM_PREREQ_LIB       += $(1)-lib
endef

define build-exe
    define $(1)-help-recipe
    	@echo   "$(1)-help"
    	@echo   "    parameters"
    	@printf "        \x24(1) - executable name: \"$(1)\"\n"
    	@echo   "    targets"
    	@echo   "       $(1)          build $(1)"
    	@echo   "       $(1)-run      simulate $(1)"
    	@echo   "       $(1)-runv     simulate $(1) under valgrind"
    	@echo   "       $(1)-clean    remove object directory"
    endef

    $(1)         : $(ACCUM_BLD_LIBS)        ; $$(link-for-executable)
    $(1)-run     : $(ACCUM_PREREQ_SIM) $(1) ; ./$(1)
    $(1)-runv    : $(ACCUM_PREREQ_SIM) $(1) ; valgrind ./$(1)
    $(1)-clean   :                          ; rm -rf $(1)
    $(1)-help    :                          ; $$($(1)-help-recipe)

    ACCUM_PHONY_TARGS  += $(1)-run $(1)-runv $(1)-clean $(1)-help
    ACCUM_PREREQ_BLD   += $(1)
    ACCUM_PREREQ_CLEAN += $(1)-clean
    ACCUM_PREREQ_HELP  += $(1)-help
    ACCUM_PREREQ_SIM   += $(1)-run
    ACCUM_SIM_LIB_DIRS += .
endef

define lib-spec
    ACCUM_CPP_INCLUDES    += -I $(1)
    ACCUM_LINKER_LIB_DIRS += -L $(1)
    ACCUM_SIM_LIB_DIRS    += $(1)
    ACCUM_LINKER_LIBS     += -l$(2)
endef

define hdr-spec
    ACCUM_CPP_INCLUDES += -I $(1)
endef

define root-lib-targets
    # arg 1: dir
    # arg 2: name (e.g. tb1, exe10 or test10)
    ACCUM_PREREQ_LIB   += $(2)-lib
    ACCUM_PREREQ_CLEAN += $(2)-clean
    ACCUM_PREREQ_HELP  += $(2)-help

    $(2)-lib   : ; cd $(1) ; make $(2)-lib
    $(2)-clean : ; cd $(1) ; make $(2)-clean
    $(2)-help  : ; cd $(1) ; make $(2)-help
endef

define root-exe-targets
    # arg 1: dir
    # arg 2: name (e.g. tb1, exe10 or test10)
    ACCUM_PREREQ_BLD   += $(2)
    ACCUM_PREREQ_SIM   += $(2)-run
    ACCUM_PREREQ_CLEAN += $(2)-clean
    ACCUM_PREREQ_HELP  += $(2)-help

    $(2)       : $($(2)-bld-prereq)   ; cd $(1) ; make $(2)
    $(2)-run   : $(2)                 ; cd $(1) ; make $(2)-run
    $(2)-clean :                      ; cd $(1) ; make $(2)-clean
    $(2)-help  :                      ; cd $(1) ; make $(2)-help
endef

define root-exe-deps
    $(1)-bld-prereq += $(2)-lib
endef

define root-help-core
    @echo   "    lib - build libraries"
    @echo   "        depends on: $(ACCUM_PREREQ_LIB)" | $(FMT)
    @echo   "    bld - build executables"
    @echo   "        depends on: $(ACCUM_PREREQ_BLD)" | $(FMT)
    @echo   "    run - run executables:"
    @echo   "        depends on: $(ACCUM_PREREQ_SIM)" | $(FMT)
    @echo   "    clean - remove build results"
    @echo   "        depends on: $(ACCUM_PREREQ_CLEAN)" | $(FMT)
endef

define root-help-aux
    @echo   "    $(1) - $(2)"
endef

define root-targets
    lib   : $(ACCUM_PREREQ_LIB)
    bld   : $(ACCUM_PREREQ_BLD)
    run   : $(ACCUM_PREREQ_SIM)
    clean : $(ACCUM_PREREQ_CLEAN)
endef
