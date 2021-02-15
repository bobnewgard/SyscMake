#
# Copyright 2013-2021 Robert Newgard
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

SYSCMAKE  := ../SyscMake

include $(SYSCMAKE)/vars.mk

# accumulated variables
ACCUM_BLD_LIBS         +=
ACCUM_CPP_INCLUDES     +=
ACCUM_CPP_OPTS         +=
ACCUM_INTERMEDIATE     +=
ACCUM_LINKER_LIBS      +=
ACCUM_LINKER_LIB_DIRS  +=
ACCUM_PHONY_TARGS      +=
ACCUM_PREREQ_BLD       +=
ACCUM_PREREQ_CLEAN     += dox-clean
ACCUM_PREREQ_HELP      +=
ACCUM_PREREQ_LIB       +=
ACCUM_PREREQ_SIM       +=
ACCUM_PYTHONPATH       +=
ACCUM_SIM_LIB_DIRS     +=
ACCUM_VLTR_OPTS        +=

HELP := dox-help

# accumulate library targets here
#------------|------- build-process ----|------- lib-dir ------------|------- lib-name -------|
$(eval $(call $(strip root-lib-targets ),$(strip ver                ),$(strip uut1         )))
$(eval $(call $(strip root-lib-targets ),$(strip ver                ),$(strip uut8         )))
$(eval $(call $(strip root-lib-targets ),$(strip ver                ),$(strip uut16        )))
$(eval $(call $(strip root-lib-targets ),$(strip ver                ),$(strip uut32        )))
$(eval $(call $(strip root-lib-targets ),$(strip ver                ),$(strip uut512       )))
$(eval $(call $(strip root-lib-targets ),$(strip tb_1               ),$(strip tb1          )))
$(eval $(call $(strip root-lib-targets ),$(strip tb_1/test_0        ),$(strip test10       )))

# accumulate build dependencies here
#------------|------- build-process -|------- exe-name -----------|------- lib-name -------|
$(eval $(call $(strip root-exe-deps ),$(strip exe10              ),$(strip uut1         )))
$(eval $(call $(strip root-exe-deps ),$(strip exe10              ),$(strip tb1          )))
$(eval $(call $(strip root-exe-deps ),$(strip exe10              ),$(strip test10       )))

# accumulate executable targets here
#------------|------- build-process ----|------- exe-dir ------------|------- exe-name -------|
$(eval $(call $(strip root-exe-targets ),$(strip tb_1/test_0        ),$(strip exe10        )))

# instantiate core targets
$(eval $(root-targets))

# add auxiliary targets here, if needed
help      : $(HELP)  ; $(root-help-core)
dox-help  :          ; $(call root-help-aux,dox,build doxygen)
dox       :          ; doxygen doxygen.conf
dox-clean :          ; rm -rf doxygen

# set default goal
.DEFAULT_GOAL := help
