############################################################################
############################################################################
##
## Copyright 2018 International Business Machines
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############################################################################
############################################################################

# from PSL9_WRAP.xdc
#set_false_path -from [get_pins {*/*/capi_fpga_reset/pll_locked_counter_l_reg[*]}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ c0/U0/pcihip0/inst*/user_reset_reg*/C}]

#set_false_path -from [get_pins {*/XSL9_WRAP/XSL9/RGS/XSL_PARAM_CG_PARREG_RGS_203/gr_data_ff_reg[*]*/C}]
#set_false_path -from [get_pins {*/XSL9_WRAP/XSL9/RGS/XSL_PARAM_CG_PARREG_RGS_10/gr_data_ff_reg[*]*/C}]
#set_false_path -from [get_pins {*/XSL9_WRAP/XSL9/RGS/XSL_PARAM_CG_PARREG_RGS_18/gr_data_ff_reg[*]*/C}]
