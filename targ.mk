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

ACCUM_BLD_LIBS         +=
ACCUM_CPP_INCLUDES     +=
ACCUM_CPP_OPTS         +=
ACCUM_INTERMEDIATE     +=
ACCUM_LINKER_LIBS      +=
ACCUM_LINKER_LIB_DIRS  +=
ACCUM_PHONY_TARGS      += debug help lib bld sim clean
ACCUM_PREREQ_BLD       +=
ACCUM_PREREQ_CLEAN     +=
ACCUM_PREREQ_HELP      +=
ACCUM_PREREQ_LIB       +=
ACCUM_PREREQ_SIM       +=
ACCUM_PYTHONPATH       +=
ACCUM_SIM_LIB_DIRS     +=
ACCUM_VLTR_OPTS        +=

export      PYTHONPATH=$(subst $(SP),:,$(strip $(ACCUM_PYTHONPATH)))
export LD_LIBRARY_PATH=$(subst $(SP),:,$(strip $(ACCUM_SIM_LIB_DIRS)))

define help-all-recipe
    @echo   "top-level targets"
    @echo   "    debug lib bld sim clean"
endef

(%)              : %                        ; $(ar-for-archive)
%.o              : ./%.cxx                  ; $(compile-for-obj)
debug            :                          ; $(help-recipe)
help             : $(ACCUM_PREREQ_HELP)     ; $(help-all-recipe)
lib              : $(ACCUM_PREREQ_LIB)      ;
bld              : $(ACCUM_PREREQ_BLD)      ;
sim              : $(ACCUM_PREREQ_SIM)      ;
clean            : $(ACCUM_PREREQ_CLEAN)    ;
.PHONY           : $(ACCUM_PHONY_TARGS)     ;
.INTERMEDIATE    : $(ACCUM_INTERMEDIATE)    ;

.DEFAULT_GOAL := help
