-- *!***************************************************************************
-- *! Copyright 2014-2018 International Business Machines
-- *!
-- *! Licensed under the Apache License, Version 2.0 (the "License");
-- *! you may not use this file except in compliance with the License.
-- *! You may obtain a copy of the License at
-- *!
-- *!     http://www.apache.org/licenses/LICENSE-2.0
-- *!
-- *! Unless required by applicable law or agreed to in writing, software
-- *! distributed under the License is distributed on an "AS IS" BASIS,
-- *! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- *! See the License for the specific language governing permissions and
-- *! limitations under the License.
-- *!
-- *!***************************************************************************

library ieee;
use ieee.std_logic_1164.all;

-- CAPI board support
entity capi_bsp is
  port (
    spi_miso_secondary    : in  std_logic;
    spi_mosi_secondary    : out std_logic;
    spi_cen_secondary     : out std_logic;

    -- pci interface
    pci_pi_nperst0        : in  std_logic; -- Active low reset from the PCIe reset pin of the device
    pci_pi_refclk_n       : in  std_logic; -- 100MHz Refclk
    pci_pi_refclk_p       : in  std_logic; -- 100MHz Refclk

    -- Xilinx requires both pins of differential transceivers
    pcie_txp              : out std_logic_vector(15 downto 0);
    pcie_txn              : out std_logic_vector(15 downto 0);
    pcie_rxp              : in  std_logic_vector(15 downto 0);
    pcie_rxn              : in  std_logic_vector(15 downto 0);

    -- AFU interface (psl_accel)
    -- Command interface
    a0h_cvalid            : in  std_logic;                  -- Command valid
    a0h_ctag              : in  std_logic_vector(0 to 7);   -- Command tag
    a0h_ctagpar           : in  std_logic;                  -- Command tag parity
    a0h_com               : in  std_logic_vector(0 to 12);  -- Command code
    a0h_compar            : in  std_logic;                  -- Command code parity
    a0h_cabt              : in  std_logic_vector(0 to 2);   -- Command ABT
    a0h_cea               : in  std_logic_vector(0 to 63);  -- Command address
    a0h_ceapar            : in  std_logic;                  -- Command address parity
    a0h_cch               : in  std_logic_vector(0 to 15);  -- Command context handle
    a0h_csize             : in  std_logic_vector(0 to 11);  -- Command size
    a0h_cpagesize         : in  std_logic_vector(0 to 3);   -- ** New tie to 0000
    ha0_croom             : out std_logic_vector(0 to 7);   -- Command room

    -- Buffer interface
    ha0_brvalid           : out std_logic;                  -- Buffer Read valid
    ha0_brtag             : out std_logic_vector(0 to 7);   -- Buffer Read tag
    ha0_brtagpar          : out std_logic;                  -- Buffer Read tag parity
    ha0_brad              : out std_logic_vector(0 to 5);   -- Buffer Read address
    a0h_brlat             : in  std_logic_vector(0 to 3);   -- Buffer Read latency
    a0h_brdata            : in  std_logic_vector(0 to 1023);-- Buffer Read data
    a0h_brpar             : in  std_logic_vector(0 to 15);  -- Buffer Read data parity
    ha0_bwvalid           : out std_logic;                  -- Buffer Write valid
    ha0_bwtag             : out std_logic_vector(0 to 7);   -- Buffer Write tag
    ha0_bwtagpar          : out std_logic;                  -- Buffer Write tag parity
    ha0_bwad              : out std_logic_vector(0 to 5);   -- Buffer Write address
    ha0_bwdata            : out std_logic_vector(0 to 1023);-- Buffer Write data
    ha0_bwpar             : out std_logic_vector(0 to 15);  -- Buffer Write data parity

    -- Response interface
    ha0_rvalid            : out std_logic;                  -- Response valid
    ha0_rtag              : out std_logic_vector(0 to 7);   -- Response tag
    ha0_rtagpar           : out std_logic;                  -- Response tag parity
    ha0_rditag            : out std_logic_vector(0 to 8);   -- **New DMA Translation Tag for xlat_* requests
    ha0_rditagpar         : out std_logic;                  -- **New Parity bit for above
    ha0_response          : out std_logic_vector(0 to 7);   -- Response
    ha0_response_ext      : out std_logic_vector(0 to 7);   -- **New Response Ext
    ha0_rpagesize         : out std_logic_vector(0 to 3);   -- **New Command translated Page size.  Provided by PSL to allow
    ha0_rcachestate       : out std_logic_vector(0 to 1);   -- Response cache state
    ha0_rcachepos         : out std_logic_vector(0 to 12);  -- Response cache pos
    ha0_rcredits          : out std_logic_vector(0 to 8);   -- Response credits
    -- ha0_reoa           : out std_logic_vector(0 to 185); -- **New unknown width or use

    -- MMIO interface
    ha0_mmval             : out std_logic;                  -- A valid MMIO is present
    ha0_mmcfg             : out std_logic;                  -- afu descriptor space access
    ha0_mmrnw             : out std_logic;                  -- 1 = read, 0 = write
    ha0_mmdw              : out std_logic;                  -- 1 = doubleword, 0 = word
    ha0_mmad              : out std_logic_vector(0 to 23);  -- mmio address
    ha0_mmadpar           : out std_logic;                  -- mmio address parity
    ha0_mmdata            : out std_logic_vector(0 to 63);  -- Write data
    ha0_mmdatapar         : out std_logic;                  -- mmio data parity
    a0h_mmack             : in  std_logic;                  -- Write is complete or Read is valid
    a0h_mmdata            : in  std_logic_vector(0 to 63);  -- Read data
    a0h_mmdatapar         : in  std_logic;                  -- mmio data parity

    -- Control interface
    ha0_jval              : out std_logic;                  -- Job valid
    ha0_jcom              : out std_logic_vector(0 to 7);   -- Job command
    ha0_jcompar           : out std_logic;                  -- Job command parity
    ha0_jea               : out std_logic_vector(0 to 63);  -- Job address
    ha0_jeapar            : out std_logic;                  -- Job address parity
    -- ha0_lop            : out std_logic_vector(0 to 4);   -- LPC/Internal Cache Op code
    -- ha0_loppar         : out std_logic;                  -- Job address parity
    -- ha0_lsize          : out std_logic_vector(0 to 6);   -- Size/Secondary Op code
    -- ha0_ltag           : out std_logic_vector(0 to 11);  -- LPC Tag/Internal Cache Tag
    -- ha0_ltagpar        : out std_logic;                  -- LPC Tag/Internal Cache Tag parity
    a0h_jrunning          : in  std_logic;                  -- Job running
    a0h_jdone             : in  std_logic;                  -- Job done
    a0h_jcack             : in  std_logic;                  -- completion of llcmd
    a0h_jerror            : in  std_logic_vector(0 to 63);  -- Job error
    -- a0h_jyield         : inx std_logic;                  -- Job yield
    -- a0h_ldone          : in  std_logic;                  -- LPC/Internal Cache Op done
    -- a0h_ldtag          : in  std_logic_vector(0 to 11);  -- ltag is done
    -- a0h_ldtagpar       : in  std_logic;                  -- ldtag parity
    -- a0h_lroom          : in  std_logic_vector(0 to 7);   -- LPC/Internal Cache Op AFU can handle
    a0h_tbreq             : in  std_logic;                  -- Timebase command request
    a0h_paren             : in  std_logic;                  -- parity enable
    ha0_pclock            : out std_logic;

    -- New DMA Interface
    -- Port 0

    -- DMA port 0 Request interface
    d0h_dvalid            : in  std_logic;                  -- New PSL/AFU interface
    d0h_req_utag          : in  std_logic_vector(0 to 9);   -- New PSL/AFU interface
    d0h_req_itag          : in  std_logic_vector(0 to 8);   -- New PSL/AFU interface
    d0h_dtype             : in  std_logic_vector(0 to 2);   -- New PSL/AFU interface
    d0h_datomic_op        : in  std_logic_vector(0 to 5);   -- New PSL/AFU interface
    d0h_datomic_le        : in  std_logic;                  -- New PSL/AFU interface
    d0h_dsize             : in  std_logic_vector(0 to 9);   -- New PSL/AFU interface
    d0h_ddata             : in  std_logic_vector(0 to 1023);-- New PSL/AFU interface
    -- d0h_dpar           : in  std_logic_vector(0 to 15);  -- New PSL/AFU interface

    -- DMA port 0 Sent interface
    hd0_sent_utag_valid   : out std_logic;
    hd0_sent_utag         : out std_logic_vector(0 to 9);
    hd0_sent_utag_sts     : out std_logic_vector(0 to 2);

    -- DMA port 0 Completion interface
    hd0_cpl_valid         : out std_logic;
    hd0_cpl_utag          : out std_logic_vector(0 to 9);
    hd0_cpl_type          : out std_logic_vector(0 to 2);
    hd0_cpl_laddr         : out std_logic_vector(0 to 6);
    hd0_cpl_byte_count    : out std_logic_vector(0 to 9);
    hd0_cpl_size          : out std_logic_vector(0 to 9);
    hd0_cpl_data          : out std_logic_vector(0 to 1023);
    -- hd0_cpl_dpar       : out std_logic_vector(0 to 15);

    gold_factory          : in  std_logic;

    pci_user_reset        : out std_logic; -- PCI hip user_reset signal if required
    pci_clock_125MHz      : out std_logic  -- 125MHz clock if required
  );
end capi_bsp;

architecture capi_bsp of capi_bsp is

  -- OBUF: Output Buffer
  -- UltraScale
  -- Xilinx HDL Libraries Guide, version 2015.4
  component OBUF
    port (
      o : out std_logic;
      i : in std_logic
    );
  end component;

  -- component pcie4_uscale_plus_0
  component pcie4c_uscale_plus_0
    port (
      pci_exp_txn                                   : out std_logic_vector(15 downto 0);
      pci_exp_txp                                   : out std_logic_vector(15 downto 0);
      pci_exp_rxn                                   : in  std_logic_vector(15 downto 0);
      pci_exp_rxp                                   : in  std_logic_vector(15 downto 0);
      user_clk                                      : out std_logic;
      user_reset                                    : out std_logic;
      user_lnk_up                                   : out std_logic;
      s_axis_rq_tdata                               : in  std_logic_vector(511 downto 0);
      s_axis_rq_tkeep                               : in  std_logic_vector(15 downto 0);
      s_axis_rq_tlast                               : in  std_logic;
      s_axis_rq_tready                              : out std_logic_vector(3 downto 0);
      s_axis_rq_tuser                               : in  std_logic_vector(136 downto 0);
      s_axis_rq_tvalid                              : in  std_logic;
      m_axis_rc_tdata                               : out std_logic_vector(511 downto 0);
      m_axis_rc_tkeep                               : out std_logic_vector(15 downto 0);
      m_axis_rc_tlast                               : out std_logic;
      m_axis_rc_tready                              : in  std_logic_vector(0 downto 0);
      m_axis_rc_tuser                               : out std_logic_vector(160 downto 0);
      m_axis_rc_tvalid                              : out std_logic;
      m_axis_cq_tdata                               : out std_logic_vector(511 downto 0);
      m_axis_cq_tkeep                               : out std_logic_vector(15 downto 0);
      m_axis_cq_tlast                               : out std_logic;
      m_axis_cq_tready                              : in  std_logic_vector(0 downto 0);
      m_axis_cq_tuser                               : out std_logic_vector(182 downto 0);
      m_axis_cq_tvalid                              : out std_logic;
      s_axis_cc_tdata                               : in  std_logic_vector(511 downto 0);
      s_axis_cc_tkeep                               : in  std_logic_vector(15 downto 0);
      s_axis_cc_tlast                               : in  std_logic;
      s_axis_cc_tready                              : out std_logic_vector(3 downto 0);
      s_axis_cc_tuser                               : in  std_logic_vector(80 downto 0);
      s_axis_cc_tvalid                              : in  std_logic;
      pcie_rq_seq_num0                              : out std_logic_vector(5 downto 0);
      pcie_rq_seq_num_vld0                          : out std_logic;
      pcie_rq_seq_num1                              : out std_logic_vector(5 downto 0);
      pcie_rq_seq_num_vld1                          : out std_logic;
      pcie_rq_tag0                                  : out std_logic_vector(7 downto 0);
      pcie_rq_tag1                                  : out std_logic_vector(7 downto 0);
      pcie_rq_tag_av                                : out std_logic_vector(3 downto 0);
      pcie_rq_tag_vld0                              : out std_logic;
      pcie_rq_tag_vld1                              : out std_logic;
      pcie_tfc_nph_av                               : out std_logic_vector(3 downto 0);
      pcie_tfc_npd_av                               : out std_logic_vector(3 downto 0);
      pcie_cq_np_req                                : in  std_logic_vector(1 downto 0);
      pcie_cq_np_req_count                          : out std_logic_vector(5 downto 0);
      cfg_phy_link_down                             : out std_logic;
      cfg_phy_link_status                           : out std_logic_vector(1 downto 0);
      cfg_negotiated_width                          : out std_logic_vector(2 downto 0);
      cfg_current_speed                             : out std_logic_vector(1 downto 0);
      cfg_max_payload                               : out std_logic_vector(1 downto 0);
      cfg_max_read_req                              : out std_logic_vector(2 downto 0);
      cfg_function_status                           : out std_logic_vector(15 downto 0);
      cfg_function_power_state                      : out std_logic_vector(11 downto 0);
      cfg_vf_status                                 : out std_logic_vector(503 downto 0);
      cfg_vf_power_state                            : out std_logic_vector(755 downto 0);
      cfg_link_power_state                          : out std_logic_vector(1 downto 0);
      cfg_mgmt_addr                                 : in  std_logic_vector(9 downto 0);
      cfg_mgmt_function_number                      : in  std_logic_vector(7 downto 0);
      cfg_mgmt_write                                : in  std_logic;
      cfg_mgmt_write_data                           : in  std_logic_vector(31 downto 0);
      cfg_mgmt_byte_enable                          : in  std_logic_vector(3 downto 0);
      cfg_mgmt_read                                 : in  std_logic;
      cfg_mgmt_read_data                            : out std_logic_vector(31 downto 0);
      cfg_mgmt_read_write_done                      : out std_logic;
      cfg_mgmt_debug_access                         : in  std_logic;
      cfg_err_cor_out                               : out std_logic;
      cfg_err_nonfatal_out                          : out std_logic;
      cfg_err_fatal_out                             : out std_logic;
      cfg_local_error_valid                         : out std_logic;
      -- cfg_ltr_enable                             : out std_logic;
      cfg_local_error_out                           : out std_logic_vector(4 downto 0);
      cfg_ltssm_state                               : out std_logic_vector(5 downto 0);
      cfg_rx_pm_state                               : out std_logic_vector(1 downto 0);
      cfg_tx_pm_state                               : out std_logic_vector(1 downto 0);
      cfg_rcb_status                                : out std_logic_vector(3 downto 0);
      cfg_obff_enable                               : out std_logic_vector(1 downto 0);
      cfg_pl_status_change                          : out std_logic;
      cfg_tph_requester_enable                      : out std_logic_vector(3 downto 0);
      cfg_tph_st_mode                               : out std_logic_vector(11 downto 0);
      cfg_vf_tph_requester_enable                   : out std_logic_vector(251 downto 0);
      cfg_vf_tph_st_mode                            : out std_logic_vector(755 downto 0);
      cfg_msg_received                              : out std_logic;
      cfg_msg_received_data                         : out std_logic_vector(7 downto 0);
      cfg_msg_received_type                         : out std_logic_vector(4 downto 0);
      cfg_msg_transmit                              : in  std_logic;
      cfg_msg_transmit_type                         : in  std_logic_vector(2 downto 0);
      cfg_msg_transmit_data                         : in  std_logic_vector(31 downto 0);
      cfg_msg_transmit_done                         : out std_logic;
      cfg_fc_ph                                     : out std_logic_vector(7 downto 0);
      cfg_fc_pd                                     : out std_logic_vector(11 downto 0);
      cfg_fc_nph                                    : out std_logic_vector(7 downto 0);
      cfg_fc_npd                                    : out std_logic_vector(11 downto 0);
      cfg_fc_cplh                                   : out std_logic_vector(7 downto 0);
      cfg_fc_cpld                                   : out std_logic_vector(11 downto 0);
      cfg_fc_sel                                    : in  std_logic_vector(2 downto 0);
      cfg_dsn                                       : in  std_logic_vector(63 downto 0);
      cfg_bus_number                                : out std_logic_vector(7 downto 0);
      cfg_power_state_change_ack                    : in  std_logic;
      cfg_power_state_change_interrupt              : out std_logic;
      cfg_err_cor_in                                : in  std_logic;
      cfg_err_uncor_in                              : in  std_logic;
      cfg_flr_in_process                            : out std_logic_vector(3 downto 0);
      cfg_flr_done                                  : in  std_logic_vector(3 downto 0);
      cfg_vf_flr_in_process                         : out std_logic_vector(251 downto 0);
      cfg_vf_flr_func_num                           : in  std_logic_vector(7 downto 0);
      cfg_vf_flr_done                               : in  std_logic_vector(0 to 0);
      cfg_link_training_enable                      : in  std_logic;
      cfg_ext_read_received                         : out std_logic;
      cfg_ext_write_received                        : out std_logic;
      cfg_ext_register_number                       : out std_logic_vector(9 downto 0);
      cfg_ext_function_number                       : out std_logic_vector(7 downto 0);
      cfg_ext_write_data                            : out std_logic_vector(31 downto 0);
      cfg_ext_write_byte_enable                     : out std_logic_vector(3 downto 0);
      cfg_ext_read_data                             : in  std_logic_vector(31 downto 0);
      cfg_ext_read_data_valid                       : in  std_logic;
      cfg_interrupt_int                             : in  std_logic_vector(3 downto 0);
      cfg_interrupt_pending                         : in  std_logic_vector(3 downto 0);
      cfg_interrupt_sent                            : out std_logic;

      cfg_interrupt_msi_enable                      : out std_logic_vector(3 downto 0);
      cfg_interrupt_msi_mmenable                    : out std_logic_vector(11 downto 0);
      cfg_interrupt_msi_mask_update                 : out std_logic;
      cfg_interrupt_msi_data                        : out std_logic_vector(31 downto 0);
      cfg_interrupt_msi_select                      : in  std_logic_vector(1 downto 0);
      cfg_interrupt_msi_int                         : in  std_logic_vector(31 downto 0);
      cfg_interrupt_msi_pending_status              : in  std_logic_vector(31 downto 0);
      cfg_interrupt_msi_pending_status_data_enable  : in  std_logic;
      cfg_interrupt_msi_pending_status_function_num : in  std_logic_vector(1 downto 0);
      cfg_interrupt_msi_sent                        : out std_logic;
      cfg_interrupt_msi_fail                        : out std_logic;
      cfg_interrupt_msi_attr                        : in  std_logic_vector(2 downto 0);
      cfg_interrupt_msi_tph_present                 : in  std_logic;
      cfg_interrupt_msi_tph_type                    : in  std_logic_vector(1 downto 0);
      cfg_interrupt_msi_tph_st_tag                  : in  std_logic_vector(7 downto 0);
      cfg_interrupt_msi_function_number             : in  std_logic_vector(7 downto 0);
      cfg_pm_aspm_l1_entry_reject                   : in  std_logic;
      cfg_pm_aspm_tx_l0s_entry_disable              : in  std_logic;
      cfg_hot_reset_out                             : out std_logic;
      cfg_config_space_enable                       : in  std_logic;
      cfg_req_pm_transition_l23_ready               : in  std_logic;
      cfg_hot_reset_in                              : in  std_logic;
      cfg_ds_port_number                            : in  std_logic_vector(7 downto 0);
      cfg_ds_bus_number                             : in  std_logic_vector(7 downto 0);
      cfg_ds_device_number                          : in  std_logic_vector(4 downto 0);

      -- cfg_pm_aspm_l1_entry_reject                : in  std_logic;
      -- cfg_pm_aspm_tx_l0s_entry_disable           : in  std_logic;
      -- cfg_hot_reset_out                          : out std_logic;
      -- cfg_config_space_enable                    : in  std_logic;
      -- cfg_req_pm_transition_l23_ready            : in  std_logic;
      -- cfg_hot_reset_in                           : in  std_logic;
      -- cfg_ds_port_number                         : in  std_logic_vector(7 downto 0);
      -- cfg_ds_bus_number                          : in  std_logic_vector(7 downto 0);
      -- cfg_ds_device_number                       : in  std_logic_vector(4 downto 0);
      -- cfg_ds_function_number                     : in  std_logic_vector(2 downto 0);
      cfg_subsys_vend_id                            : in  std_logic_vector(15 downto 0);
      cfg_dev_id_pf0                                : in  std_logic_vector(15 downto 0);
      -- cfg_dev_id_pf1                             : in  std_logic_vector(15 downto 0);
      -- cfg_dev_id_pf2                             : in  std_logic_vector(15 downto 0);
      -- cfg_dev_id_pf3                             : in  std_logic_vector(15 downto 0);
      cfg_vend_id                                   : in  std_logic_vector(15 downto 0);
      cfg_rev_id_pf0                                : in  std_logic_vector(7 downto 0);
      -- cfg_rev_id_pf1                             : in  std_logic_vector(7 downto 0);
      -- cfg_rev_id_pf2                             : in  std_logic_vector(7 downto 0);
      -- cfg_rev_id_pf3                             : in  std_logic_vector(7 downto 0);
      cfg_subsys_id_pf0                             : in  std_logic_vector(15 downto 0);
      -- cfg_subsys_id_pf1                          : in  std_logic_vector(15 downto 0);
      -- cfg_subsys_id_pf2                          : in  std_logic_vector(15 downto 0);
      -- cfg_subsys_id_pf3                          : in  std_logic_vector(15 downto 0);

      sys_clk                                       : in  std_logic;
      sys_clk_gt                                    : in  std_logic;
      sys_reset                                     : in  std_logic;
      phy_rdy_out                                   : out std_logic

      -- New for 2016.4
      -- int_qpll0lock_out                          : out std_logic_vector(1 downto 0);
      -- int_qpll0outrefclk_out                     : out std_logic_vector(1 downto 0);
      -- int_qpll0outclk_out                        : out std_logic_vector(1 downto 0);
      -- int_qpll1lock_out                          : out std_logic_vector(1 downto 0);
      -- int_qpll1outrefclk_out                     : out std_logic_vector(1 downto 0);
      -- int_qpll1outclk_out                        : out std_logic_vector(1 downto 0)
    );
  end component;

  -- IBUFDS_GTE4: Gigabit Transceiver Buffer
  -- UltraScale
  -- Xilinx HDL Libraries Guide, version 2015.4

  component IBUFDS_GTE4
    -- generic (
    --   REFCLK_EN_TX_PATH    : in std_logic;
    --   REFCLK_HROW_CK_SEL   : in std_logic_vector(0 to 1);
    --   REFCLK_ICNTL_RX      : in std_logic_vector(0 to 1)
    -- );
    port (
      O           : out std_logic;
      ODIV2       : out std_logic;
      I           : in  std_logic;
      CEB         : in  std_logic;
      IB          : in  std_logic
    );
  end component;

  component IBUF
    port (
      O           : out std_logic;
      I           : in  std_logic
    );
  end component;

  component uscale_plus_clk_wiz
    port (
      clk_in1     : in  std_logic;
      clk_out1    : out std_logic;
      clk_out2    : out std_logic;
      clk_out3    : out std_logic;
      clk_out3_ce : in  std_logic;
      reset       : in  std_logic;
      locked      : out std_logic
    );
  end component;

  component capi_fpga_reset_gen
    port (
      pll_locked  : in  std_logic;
      clk         : in  std_logic;
      reset       : out std_logic
    );
  end component;

  component capi_stp_counter
    port (
      clk               : in  std_logic;
      reset             : in  std_logic;
      stp_counter_1sec  : out std_logic;
      stp_counter_msb   : out std_logic
    );
  end component;

  component psl9_wrap_0
    port (
      -- psl_clk          : in  std_logic;
      -- psl_rst          : in  std_logic;
      -- pcihip0_psl_clk  : in  std_logic;
      -- pcihip0_psl_rst  : in  std_logic;
      -- crc_error        : in  std_logic;
      a0h_cvalid          : in  std_logic;
      a0h_ctag            : in  std_logic_vector(0 to 7);
      a0h_com             : in  std_logic_vector(0 to 12);
      -- a0h_cpad         : in  std_logic_vector(0 to 2);
      a0h_cabt            : in  std_logic_vector(0 to 2);
      a0h_cea             : in  std_logic_vector(0 to 63);
      a0h_cch             : in  std_logic_vector(0 to 15);
      a0h_csize           : in  std_logic_vector(0 to 11);
      a0h_cpagesize       : in  std_logic_vector(0 to 3);
      ha0_croom           : out std_logic_vector(0 to 7);
      a0h_ctagpar         : in  std_logic;
      a0h_compar          : in  std_logic;
      a0h_ceapar          : in  std_logic;
      ha0_brvalid         : out std_logic;
      ha0_brtag           : out std_logic_vector(0 to 7);
      ha0_brad            : out std_logic_vector(0 to 5);
      a0h_brlat           : in  std_logic_vector(0 to 3);
      a0h_brdata          : in  std_logic_vector(0 to 1023);
      a0h_brpar           : in  std_logic_vector(0 to 15);
      ha0_bwvalid         : out std_logic;
      ha0_bwtag           : out std_logic_vector(0 to 7);
      ha0_bwad            : out std_logic_vector(0 to 5);
      ha0_bwdata          : out std_logic_vector(0 to 1023);
      ha0_bwpar           : out std_logic_vector(0 to 15);
      ha0_brtagpar        : out std_logic;
      ha0_bwtagpar        : out std_logic;
      ha0_rvalid          : out std_logic;
      ha0_rtag            : out std_logic_vector(0 to 7);
      ha0_rtagpar         : out std_logic;
      ha0_rditag          : out std_logic_vector(0 to 8);
      ha0_rditagpar       : out std_logic;
      ha0_response        : out std_logic_vector(0 to 7);
      ha0_response_ext    : out std_logic_vector(0 to 7);
      ha0_rpagesize       : out std_logic_vector(0 to 3);
      ha0_rcredits        : out std_logic_vector(0 to 8);
      ha0_rcachestate     : out std_logic_vector(0 to 1);
      ha0_rcachepos       : out std_logic_vector(0 to 12);
      ha0_reoa            : out std_logic_vector(0 to 185);

      ha0_mmval           : out std_logic;
      ha0_mmcfg           : out std_logic;
      ha0_mmrnw           : out std_logic;
      ha0_mmdw            : out std_logic;
      ha0_mmad            : out std_logic_vector(0 to 23);
      ha0_mmadpar         : out std_logic;
      ha0_mmdata          : out std_logic_vector(0 to 63);
      ha0_mmdatapar       : out std_logic;
      a0h_mmack           : in  std_logic;
      a0h_mmdata          : in  std_logic_vector(0 to 63);
      a0h_mmdatapar       : in  std_logic;

      ha0_jval            : out std_logic;
      ha0_jcom            : out std_logic_vector(0 to 7);
      ha0_jcompar         : out std_logic;
      ha0_jea             : out std_logic_vector(0 to 63);
      ha0_jeapar          : out std_logic;
      a0h_jrunning        : in  std_logic;
      a0h_jdone           : in  std_logic;
      a0h_jcack           : in  std_logic;
      a0h_jerror          : in  std_logic_vector(0 to 63);
      -- a0h_jyield       : in  std_logic;
      a0h_tbreq           : in  std_logic;
      a0h_paren           : in  std_logic;
      ha0_pclock          : out std_logic;

      d0h_dvalid          : in  std_logic;
      d0h_req_utag        : in  std_logic_vector(0 to 9);
      d0h_req_itag        : in  std_logic_vector(0 to 8);
      d0h_dtype           : in  std_logic_vector(0 to 2);
      -- dh_drelaxed      : in  std_logic;
      d0h_datomic_op      : in  std_logic_vector(0 to 5);
      d0h_datomic_le      : in  std_logic; -- New PSL/AFU interface
      d0h_dsize           : in  std_logic_vector(0 to 9);
      d0h_ddata           : in  std_logic_vector(0 to 1023);
      -- d0h_dpar         : in  std_logic_vector(0 to 15);

      -- PSL DMA Completion Interface
      hd0_cpl_valid       : out std_logic;
      hd0_cpl_utag        : out std_logic_vector(0 to 9);
      hd0_cpl_type        : out std_logic_vector(0 to 2);
      hd0_cpl_laddr       : out std_logic_vector(0 to 6);
      hd0_cpl_byte_count  : out std_logic_vector(0 to 9);
      hd0_cpl_size        : out std_logic_vector(0 to 9);
      hd0_cpl_data        : out std_logic_vector(0 to 1023);
      -- hd0_cpl_dpar     : out std_logic_vector(0 to 15);

      -- PSL DMA Sent Interface
      hd0_sent_utag_valid : out std_logic;
      hd0_sent_utag       : out std_logic_vector(0 to 9);
      hd0_sent_utag_sts   : out std_logic_vector(0 to 2);

      axis_cq_tvalid      : in  std_logic;
      axis_cq_tdata       : in  std_logic_vector(511 downto 0);
      axis_cq_tready      : out std_logic;
      axis_cq_tuser       : in  std_logic_vector(182 downto 0);
      axis_cq_np_req      : out std_logic_vector(1 downto 0);

      -- xlx ip rc interface
      axis_rc_tvalid      : in  std_logic;
      axis_rc_tdata       : in  std_logic_vector(511 downto 0);
      axis_rc_tready      : out std_logic;
      axis_rc_tuser       : in  std_logic_vector(160 downto 0);

      -- XLX IP RQ Interface
      axis_rq_tvalid      : out std_logic;
      axis_rq_tdata       : out std_logic_vector(511 downto 0);
      axis_rq_tready      : in  std_logic;
      axis_rq_tlast       : out std_logic;
      axis_rq_tuser       : out std_logic_vector(136 downto 0);
      axis_rq_tkeep       : out std_logic_vector(15 downto 0);

      -- XLX IP CC Interface
      axis_cc_tvalid      : out std_logic;
      axis_cc_tdata       : out std_logic_vector(511 downto 0);
      axis_cc_tready      : in  std_logic;
      axis_cc_tlast       : out std_logic;
      axis_cc_tuser       : out std_logic_vector(80 downto 0);
      axis_cc_tkeep       : out std_logic_vector(15 downto 0);

      -- Configuration Interface
      XIP_CFG_FC_SEL      : out std_logic_vector(2 downto 0);
      XIP_CFG_FC_PH       : in  std_logic_vector(7 downto 0);
      XIP_CFG_FC_PD       : in  std_logic_vector(11 downto 0);
      XIP_CFG_FC_NP       : in  std_logic_vector(7 downto 0);

      psl_kill_link       : out std_logic;
      psl_build_ver       : in  std_logic_vector(0 to 31);
      afu_clk             : in  std_logic;

      PSL_RST             : in  std_logic;
      PSL_CLK             : in  std_logic;
      PCIHIP_PSL_RST      : in  std_logic;
      PCIHIP_PSL_CLK      : in  std_logic
    );
  end component;

  -- CAPI board infrastructure
  component capi_board_infrastructure
    port (
      cfg_ext_read_received     : in  std_logic;
      cfg_ext_write_received    : in  std_logic;
      cfg_ext_register_number   : in  std_logic_vector(9 downto 0);
      cfg_ext_function_number   : in  std_logic_vector(7 downto 0);
      cfg_ext_write_data        : in  std_logic_vector(31 downto 0);
      cfg_ext_write_byte_enable : in  std_logic_vector(3 downto 0);
      cfg_ext_read_data         : out std_logic_vector(31 downto 0);
      cfg_ext_read_data_valid   : out std_logic;

      spi_miso_secondary        : in  std_logic;
      spi_mosi_secondary        : out std_logic;
      spi_cen_secondary         : out std_logic;

      pci_pi_nperst0            : in  std_logic;
      pcihip0_psl_clk           : in  std_logic;
      icap_clk                  : in  std_logic;
      cpld_usergolden           : in  std_logic;  -- bool
      crc_error                 : out std_logic
    );
  end component;

  component capi_rise_dff
    port (
      clk   : in  std_logic;
      dout  : out std_logic;
      din   : in  std_logic
    );
  end component;

  attribute mark_debug                  : string;
  signal ha0_reoa                       : std_logic_vector(0 to 185);

  signal hip_npor0                      : std_logic;
  signal i_cpld_sda                     : std_logic;
  signal crc_error                      : std_logic;
  signal i_therm_sda                    : std_logic;
  signal i_ucd_sda                      : std_logic;
  -- signal pcihip0_psl_app_int_ack     : std_logic;
  -- signal pcihip0_psl_app_msi_ack     : std_logic;
  -- signal pcihip0_psl_cfg_par_err     : std_logic;
  signal pcihip0_psl_coreclkout_hip     : std_logic;
  signal pcihip0_psl_cseb_addr          : std_logic_vector(0 to 32);
  signal pcihip0_psl_cseb_addr_parity   : std_logic_vector(0 to 4);
  signal pcihip0_psl_cseb_be            : std_logic_vector(0 to 3);
  signal pcihip0_psl_cseb_rden          : std_logic;
  signal pcihip0_psl_cseb_wrdata        : std_logic_vector(0 to 31);
  signal pcihip0_psl_cseb_wrdata_parity : std_logic_vector(0 to 3);
  signal pcihip0_psl_cseb_wren          : std_logic;
  signal pcihip0_psl_cseb_wrresp_req    : std_logic;
  -- signal pcihip0_psl_derr_cor_ext_rcv : std_logic;
  -- signal pcihip0_psl_derr_cor_ext_rpl : std_logic;
  -- signal pcihip0_psl_derr_rpl        : std_logic;
  -- signal pcihip0_psl_hip_reconfig_readdata : std_logic_vector(0 to 15);
  -- signal pcihip0_psl_ko_cpl_spc_data : std_logic_vector(0 to 11);
  -- signal pcihip0_psl_ko_cpl_spc_header : std_logic_vector(0 to 7);
  -- signal pcihip0_psl_lmi_ack         : std_logic;
  -- signal pcihip0_psl_lmi_dout        : std_logic_vector(0 to 31);
  signal pcihip0_psl_pld_clk_inuse      : std_logic;
  -- signal pcihip0_psl_pme_to_sr       : std_logic;
  signal pcihip0_psl_reset_status       : std_logic;
  -- signal pcihip0_psl_rx_par_err      : std_logic;
  signal pcihip0_psl_rx_st_bar          : std_logic_vector(0 to 7);
  signal pcihip0_psl_rx_st_data         : std_logic_vector(0 to 255);
  signal pcihip0_psl_rx_st_empty        : std_logic_vector(0 to 1);
  signal pcihip0_psl_rx_st_eop          : std_logic;
  signal pcihip0_psl_rx_st_err          : std_logic;
  signal pcihip0_psl_rx_st_parity       : std_logic_vector(0 to 31);
  signal pcihip0_psl_rx_st_sop          : std_logic;
  signal pcihip0_psl_rx_st_valid        : std_logic;
  -- signal pcihip0_psl_testin_zero     : std_logic; -- bool
  signal pcihip0_psl_tl_cfg_add         : std_logic_vector(0 to 3);
  signal pcihip0_psl_tl_cfg_ctl         : std_logic_vector(0 to 31);
  -- signal pcihip0_psl_tl_cfg_sts      : std_logic_vector(0 to 52);
  signal pcihip0_psl_tx_cred_datafccp   : std_logic_vector(0 to 11);
  signal pcihip0_psl_tx_cred_datafcnp   : std_logic_vector(0 to 11);
  signal pcihip0_psl_tx_cred_datafcp    : std_logic_vector(0 to 11);
  signal pcihip0_psl_tx_cred_fchipcons  : std_logic_vector(0 to 5);
  signal pcihip0_psl_tx_cred_fcinfinite : std_logic_vector(0 to 5);
  signal pcihip0_psl_tx_cred_hdrfccp    : std_logic_vector(0 to 7);
  signal pcihip0_psl_tx_cred_hdrfcnp    : std_logic_vector(0 to 7);
  signal pcihip0_psl_tx_cred_hdrfcp     : std_logic_vector(0 to 7);
  -- signal pcihip0_psl_tx_par_err      : std_logic_vector(0 to 1);
  signal pcihip0_psl_tx_st_ready        : std_logic;
  signal psl_clk                        : std_logic;
  signal psl_clk_div2                   : std_logic;

  signal sys_clk_p                      : std_logic;
  signal sys_clk_n                      : std_logic;
  signal sys_rst_n                      : std_logic;
  signal pci_exp_txn                    : std_logic_vector(15 downto 0);
  signal pci_exp_txp                    : std_logic_vector(15 downto 0);
  signal pci_exp_rxn                    : std_logic_vector(15 downto 0);
  signal pci_exp_rxp                    : std_logic_vector(15 downto 0);

  signal psl_reset_sig                  : std_logic;
  signal axis_cq_tvalid                 : std_logic;
  signal axis_cq_tdata                  : std_logic_vector(511 downto 0);
  signal axis_cq_tready                 : std_logic;
  signal axis_cq_tready_22              : std_logic_vector(0 downto 0);
  signal axis_cq_tuser                  : std_logic_vector(182 downto 0);
  signal axis_cq_np_req                 : std_logic_vector(1 downto 0);

  -- XLX IP RC Interface
  signal axis_rc_tvalid                 : std_logic;
  signal axis_rc_tdata                  : std_logic_vector(511 downto 0);
  signal axis_rc_tready                 : std_logic;
  -- signal axis_rc_tready_22           : std_logic_vector(0 downto 0);
  signal axis_rc_tready_22              : std_logic;
  signal axis_rc_tuser                  : std_logic_vector(160 downto 0);

  -- XLX IP RQ Interface
  signal axis_rq_tvalid                 : std_logic;
  signal axis_rq_tdata                  : std_logic_vector(511 downto 0);
  signal axis_rq_tready                 : std_logic_vector(3 downto 0);
  signal axis_rq_tlast                  : std_logic;
  signal axis_rq_tuser                  : std_logic_vector(136 downto 0);
  signal axis_rq_tkeep                  : std_logic_vector(15 downto 0);
  -- XLX IP CC Interface
  signal axis_cc_tvalid                 : std_logic;
  signal axis_cc_tdata                  : std_logic_vector(511 downto 0);
  signal axis_cc_tready                 : std_logic_vector(3 downto 0);
  signal axis_cc_tlast                  : std_logic;
  signal axis_cc_tuser                  : std_logic_vector(80 downto 0);
  signal axis_cc_tkeep                  : std_logic_vector(15 downto 0);

  signal pcihip0_psl_clk                : std_logic;
  signal pcihip0_psl_rst                : std_logic;
  signal user_lnk_up                    : std_logic;

  signal xip_cfg_fc_sel_sig             : std_logic_vector(2 downto 0);
  signal xip_cfg_fc_ph_sig              : std_logic_vector(7 downto 0);
  signal xip_cfg_fc_pd_sig              : std_logic_vector(11 downto 0);
  signal xip_cfg_fc_np_sig              : std_logic_vector(7 downto 0);
  signal cfg_dsn_sig                    : std_logic_vector(63 downto 0);

  signal sys_clk                        : std_logic;
  signal sys_clk_gt                     : std_logic;
  signal sys_rst_n_c                    : std_logic;

  signal stp_counter_msb_sig            : std_logic;
  signal stp_counter_1sec_sig           : std_logic;
  signal sys_clk_counter_1sec_sig       : std_logic;
  signal user_clock_sig                 : std_logic;

  signal clk_wiz_2_locked               : std_logic;

  signal psl_build_ver                  : std_logic_vector(0 to 31);

  signal icap_clk                       : std_logic; -- 125Mhz clock from PCIe refclk
  signal icap_clk_ce                    : std_logic; -- bool
  signal icap_clk_ce_d                  : std_logic;

  signal cfg_ext_read_received          : std_logic;
  signal cfg_ext_write_received         : std_logic;
  signal cfg_ext_register_number        : std_logic_vector(9 downto 0);
  signal cfg_ext_function_number        : std_logic_vector(7 downto 0);
  signal cfg_ext_write_data             : std_logic_vector(31 downto 0);
  signal cfg_ext_write_byte_enable      : std_logic_vector(3 downto 0);
  signal cfg_ext_read_data              : std_logic_vector(31 downto 0);
  signal cfg_ext_read_data_valid        : std_logic;

  signal led_red                        : std_logic_vector(3 downto 0);
  signal led_green                      : std_logic_vector(3 downto 0);
  signal led_blue                       : std_logic_vector(3 downto 0);

begin

  -- psl_build_ver  <= x"0000685a"; -- March 15, 2017 With Subsystem ID = x060f for capi_flash script
  psl_build_ver     <= x"00006900"; -- March 22, 2017 With fixes and With Subsystem ID = x060f for capi_flash script
  -- hd0_cpl_laddr  <= "000" & hd0_cpl_laddr_0_6;

  -- PSL logic
  p: psl9_wrap_0
    port map (
      -- crc_error        => crc_errorinternal,
      a0h_cvalid          => a0h_cvalid,
      a0h_ctag            => a0h_ctag,
      a0h_com             => a0h_com,
      -- a0h_cpad         => a0h_cpad,
      a0h_cabt            => a0h_cabt,
      a0h_cea             => a0h_cea,
      a0h_cch             => a0h_cch,
      a0h_csize           => a0h_csize,
      a0h_cpagesize       => a0h_cpagesize,
      ha0_croom           => ha0_croom,
      a0h_ctagpar         => a0h_ctagpar,
      a0h_compar          => a0h_compar,
      a0h_ceapar          => a0h_ceapar,
      ha0_brvalid         => ha0_brvalid,
      ha0_brtag           => ha0_brtag,
      ha0_brad            => ha0_brad,
      a0h_brlat           => a0h_brlat,
      a0h_brdata          => a0h_brdata,
      a0h_brpar           => a0h_brpar,
      ha0_bwvalid         => ha0_bwvalid,
      ha0_bwtag           => ha0_bwtag,
      ha0_bwad            => ha0_bwad,
      ha0_bwdata          => ha0_bwdata,
      ha0_bwpar           => ha0_bwpar,
      ha0_brtagpar        => ha0_brtagpar,
      ha0_bwtagpar        => ha0_bwtagpar,
      ha0_rcredits        => ha0_rcredits,

      ha0_response_ext    => ha0_response_ext,
      ha0_rditag          => ha0_rditag,
      ha0_rditagpar       => ha0_rditagpar,
      ha0_rpagesize       => ha0_rpagesize,

      ha0_rvalid          => ha0_rvalid,
      ha0_rtag            => ha0_rtag,
      ha0_response        => ha0_response,
      ha0_rcachestate     => ha0_rcachestate,
      ha0_rcachepos       => ha0_rcachepos,
      ha0_rtagpar         => ha0_rtagpar,
      ha0_reoa            => ha0_reoa,

      ha0_mmval           => ha0_mmval,
      ha0_mmrnw           => ha0_mmrnw,
      ha0_mmdw            => ha0_mmdw,
      ha0_mmad            => ha0_mmad,
      ha0_mmdata          => ha0_mmdata,
      ha0_mmcfg           => ha0_mmcfg,
      a0h_mmack           => a0h_mmack,
      a0h_mmdata          => a0h_mmdata,
      ha0_mmadpar         => ha0_mmadpar,
      ha0_mmdatapar       => ha0_mmdatapar,
      a0h_mmdatapar       => a0h_mmdatapar,

      ha0_jval            => ha0_jval,
      ha0_jcom            => ha0_jcom,
      ha0_jea             => ha0_jea,
      a0h_jrunning        => a0h_jrunning,
      a0h_jdone           => a0h_jdone,
      a0h_jcack           => a0h_jcack,
      a0h_jerror          => a0h_jerror,
      a0h_tbreq           => a0h_tbreq,
      -- a0h_jyield       => a0h_jyield,
      ha0_jeapar          => ha0_jeapar,
      ha0_jcompar         => ha0_jcompar,
      a0h_paren           => a0h_paren,
      ha0_pclock          => ha0_pclock,

      d0h_dvalid          => d0h_dvalid,
      d0h_req_utag        => d0h_req_utag,
      d0h_req_itag        => d0h_req_itag,
      d0h_dtype           => d0h_dtype,
      d0h_datomic_op      => d0h_datomic_op,
      d0h_datomic_le      => d0h_datomic_le,
      -- dh_drelaxed      => d0h_drelaxed,
      d0h_dsize           => d0h_dsize,
      d0h_ddata           => d0h_ddata,
      -- d0h_dpar         => d0h_dpar,

      hd0_cpl_valid       => hd0_cpl_valid,
      hd0_cpl_utag        => hd0_cpl_utag,
      hd0_cpl_type        => hd0_cpl_type,
      hd0_cpl_laddr       => hd0_cpl_laddr,
      hd0_cpl_byte_count  => hd0_cpl_byte_count,
      hd0_cpl_size        => hd0_cpl_size,
      hd0_cpl_data        => hd0_cpl_data,
      -- hd0_cpl_dpar     => hd0_cpl_dpar,
      hd0_sent_utag_valid => hd0_sent_utag_valid,
      hd0_sent_utag       => hd0_sent_utag,
      hd0_sent_utag_sts   => hd0_sent_utag_sts,

      axis_cq_tvalid      => axis_cq_tvalid,
      axis_cq_tdata       => axis_cq_tdata,
      axis_cq_tready      => axis_cq_tready,
      axis_cq_tuser       => axis_cq_tuser,
      axis_cq_np_req      => axis_cq_np_req,

      -- XLX IP RC Interface
      axis_rc_tvalid      => axis_rc_tvalid,
      axis_rc_tdata       => axis_rc_tdata,
      axis_rc_tready      => axis_rc_tready,
      axis_rc_tuser       => axis_rc_tuser,

      -- XLX IP RQ Interface
      axis_rq_tvalid      => axis_rq_tvalid,
      axis_rq_tdata       => axis_rq_tdata,
      axis_rq_tready      => axis_rq_tready(0),
      axis_rq_tlast       => axis_rq_tlast,
      axis_rq_tuser       => axis_rq_tuser,
      axis_rq_tkeep       => axis_rq_tkeep,

      -- XLX IP CC Interface
      axis_cc_tvalid      => axis_cc_tvalid,
      axis_cc_tdata       => axis_cc_tdata,
      axis_cc_tready      => axis_cc_tready(0),
      axis_cc_tlast       => axis_cc_tlast,
      axis_cc_tuser       => axis_cc_tuser,
      axis_cc_tkeep       => axis_cc_tkeep,

      -- Configuration Interface
      -- cfg_fc_sel[2:0] = 101b, cfg_fc_ph[7:0], cfg_fc_pd[11:0] cfg_fc_nph[7:0]
      xip_cfg_fc_sel      => xip_cfg_fc_sel_sig,
      xip_cfg_fc_ph       => xip_cfg_fc_ph_sig,
      xip_cfg_fc_pd       => xip_cfg_fc_pd_sig,
      xip_cfg_fc_np       => xip_cfg_fc_np_sig,

      psl_kill_link       => open,
      psl_build_ver       => psl_build_ver,
      afu_clk             => psl_clk,

      psl_rst             => pcihip0_psl_rst, -- was psl_reset_sig,
      psl_clk             => psl_clk,
      pcihip_psl_rst      => pcihip0_psl_rst,
      pcihip_psl_clk      => pcihip0_psl_clk
    );

  cfg_dsn_sig <= X"00000001" & X"01" & X"000A35";

  sys_clk_p   <= pci_pi_refclk_p0 ;
  sys_clk_n   <= pci_pi_refclk_n0;
  sys_rst_n   <= pci_pi_nperst0;

  pcie_txn(15 downto 0)    <= pci_exp_txn(15 downto 0);
  pcie_txp(15 downto 0)    <= pci_exp_txp(15 downto 0);
  pci_exp_rxn(15 downto 0) <= pcie_rxn(15 downto 0);
  pci_exp_rxp(15 downto 0) <= pcie_rxp(15 downto 0);

  pci_user_reset <= pcihip0_psl_rst;
  pci_clock_125MHz <= psl_clk_div2;


  pcihip0: pcie4c_uscale_plus_0
    port map (
      pci_exp_txn                                   => pci_exp_txn,
      pci_exp_txp                                   => pci_exp_txp,
      pci_exp_rxn                                   => pci_exp_rxn,
      pci_exp_rxp                                   => pci_exp_rxp,

      user_clk                                      => pcihip0_psl_clk,
      user_reset                                    => pcihip0_psl_rst,
      user_lnk_up                                   => user_lnk_up,

      s_axis_rq_tdata                               => axis_rq_tdata,
      s_axis_rq_tkeep                               => axis_rq_tkeep,
      s_axis_rq_tlast                               => axis_rq_tlast,
      s_axis_rq_tready                              => axis_rq_tready,
      s_axis_rq_tuser                               => axis_rq_tuser,
      s_axis_rq_tvalid                              => axis_rq_tvalid,
      m_axis_rc_tdata                               => axis_rc_tdata,
      m_axis_rc_tkeep                               => open,
      m_axis_rc_tlast                               => open,
      m_axis_rc_tready(0)                           => axis_rc_tready,
      m_axis_rc_tuser                               => axis_rc_tuser,
      m_axis_rc_tvalid                              => axis_rc_tvalid,
      m_axis_cq_tdata                               => axis_cq_tdata,
      m_axis_cq_tkeep                               => open,
      m_axis_cq_tlast                               => open,
      m_axis_cq_tready(0)                           => axis_cq_tready,
      m_axis_cq_tuser                               => axis_cq_tuser,
      m_axis_cq_tvalid                              => axis_cq_tvalid,
      s_axis_cc_tdata                               => axis_cc_tdata,
      s_axis_cc_tkeep                               => axis_cc_tkeep,
      s_axis_cc_tlast                               => axis_cc_tlast,
      s_axis_cc_tready                              => axis_cc_tready,
      s_axis_cc_tuser                               => axis_cc_tuser,
      s_axis_cc_tvalid                              => axis_cc_tvalid,

      pcie_rq_seq_num0                              => open,
      pcie_rq_seq_num_vld0                          => open,
      pcie_rq_seq_num1                              => open,
      pcie_rq_seq_num_vld1                          => open,
      pcie_rq_tag0                                  => open,
      pcie_rq_tag1                                  => open,
      pcie_rq_tag_av                                => open,
      pcie_rq_tag_vld0                              => open,
      pcie_rq_tag_vld1                              => open,
      pcie_tfc_nph_av                               => open,
      pcie_tfc_npd_av                               => open,
      pcie_cq_np_req                                => (others => '1'),
      pcie_cq_np_req_count                          => open,

      cfg_phy_link_down                             => open,
      cfg_phy_link_status                           => open,
      cfg_negotiated_width                          => open,
      cfg_current_speed                             => open,
      cfg_max_payload                               => open,
      cfg_max_read_req                              => open,
      cfg_function_status                           => open,
      cfg_function_power_state                      => open,
      cfg_vf_status                                 => open,
      cfg_vf_power_state                            => open,
      cfg_link_power_state                          => open,
      cfg_mgmt_addr                                 => (others => '0'),
      cfg_mgmt_function_number                      => (others => '0'),
      cfg_mgmt_write                                => '0',
      cfg_mgmt_write_data                           => (others => '0'),
      cfg_mgmt_byte_enable                          => (others => '0'),
      cfg_mgmt_read                                 => '0',
      cfg_mgmt_read_data                            => open,
      cfg_mgmt_read_write_done                      => open,
      cfg_mgmt_debug_access                         => '0',
      cfg_err_cor_out                               => open,
      cfg_err_nonfatal_out                          => open,
      cfg_err_fatal_out                             => open,
      cfg_local_error_valid                         => open,
  --     cfg_ltr_enable                             => open,
      cfg_local_error_out                           => open,
      cfg_ltssm_state                               => open,
      cfg_rx_pm_state                               => open,
      cfg_tx_pm_state                               => open,
      cfg_rcb_status                                => open,
      cfg_obff_enable                               => open,
      cfg_pl_status_change                          => open,
      cfg_tph_requester_enable                      => open,
      cfg_tph_st_mode                               => open,
      cfg_vf_tph_requester_enable                   => open,
      cfg_vf_tph_st_mode                            => open,
      cfg_msg_received                              => open,
      cfg_msg_received_data                         => open,
      cfg_msg_received_type                         => open,
      cfg_msg_transmit                              => '0',
      cfg_msg_transmit_type                         => (others => '0'),
      cfg_msg_transmit_data                         => (others => '0'),
      cfg_msg_transmit_done                         => open,
      cfg_fc_ph                                     => xip_cfg_fc_ph_sig,
      cfg_fc_pd                                     => xip_cfg_fc_pd_sig,
      cfg_fc_nph                                    => xip_cfg_fc_np_sig,
      cfg_fc_npd                                    => open,
      cfg_fc_cplh                                   => open,
      cfg_fc_cpld                                   => open,
      cfg_fc_sel                                    => xip_cfg_fc_sel_sig,
      -- cfg_dsn                                    => (others => '0'),
      cfg_dsn                                       => cfg_dsn_sig,
      cfg_bus_number                                => open,
      cfg_power_state_change_ack                    => '0',
      cfg_power_state_change_interrupt              => open,
      cfg_err_cor_in                                => '0',
      cfg_err_uncor_in                              => '0',
      cfg_flr_in_process                            => open,
      cfg_flr_done                                  => (others => '0'),
      cfg_vf_flr_in_process                         => open,
      cfg_vf_flr_func_num                           => (others => '0'),
      cfg_vf_flr_done                               => (others => '0'),
      -- cfg_link_training_enable                   => '0',
      cfg_link_training_enable                      => '1',
      cfg_ext_read_received                         => cfg_ext_read_received,
      cfg_ext_write_received                        => cfg_ext_write_received,
      cfg_ext_register_number                       => cfg_ext_register_number,
      cfg_ext_function_number                       => cfg_ext_function_number,
      cfg_ext_write_data                            => cfg_ext_write_data,
      cfg_ext_write_byte_enable                     => cfg_ext_write_byte_enable,
      cfg_ext_read_data                             => cfg_ext_read_data,
      cfg_ext_read_data_valid                       => cfg_ext_read_data_valid,
      cfg_interrupt_int                             => (others => '0'),
      cfg_interrupt_pending                         => (others => '0'),
      cfg_interrupt_sent                            => open,

      cfg_interrupt_msi_enable                      => open,
      cfg_interrupt_msi_mmenable                    => open,
      cfg_interrupt_msi_mask_update                 => open,
      cfg_interrupt_msi_data                        => open,
      cfg_interrupt_msi_select                      => (others => '0'),
      cfg_interrupt_msi_int                         => (others => '0'),
      cfg_interrupt_msi_pending_status              => (others => '0'),
      cfg_interrupt_msi_pending_status_data_enable  => '0',
      cfg_interrupt_msi_pending_status_function_num => (others => '0'),
      cfg_interrupt_msi_sent                        => open,
      cfg_interrupt_msi_fail                        => open,
      cfg_interrupt_msi_attr                        => (others => '0'),
      cfg_interrupt_msi_tph_present                 => '0',
      cfg_interrupt_msi_tph_type                    => (others => '0'),
      cfg_interrupt_msi_tph_st_tag                  => (others => '0'),
      cfg_interrupt_msi_function_number             => (others => '0'),
      cfg_pm_aspm_l1_entry_reject                   => '0',
      -- cfg_pm_aspm_tx_l0s_entry_disable           => '0',
      cfg_pm_aspm_tx_l0s_entry_disable              => '1',
      cfg_hot_reset_out                             => open,
      -- cfg_config_space_enable                    => '0',
      cfg_config_space_enable                       => '1',
      cfg_req_pm_transition_l23_ready               => '0',
      cfg_hot_reset_in                              => '0',
      cfg_ds_port_number                            => (others => '0'),
      cfg_ds_bus_number                             => (others => '0'),
      cfg_ds_device_number                          => (others => '0'),

      -- cfg_pm_aspm_l1_entry_reject                => '0',
      -- cfg_pm_aspm_tx_l0s_entry_disable           => '0',
      -- cfg_hot_reset_out                          => open,
      -- cfg_config_space_enable                    => '0',
      -- cfg_req_pm_transition_l23_ready            => '0',
      -- cfg_hot_reset_in                           => '0',
      -- cfg_ds_port_number                         => (others => '0'),
      -- cfg_ds_bus_number                          => (others => '0'),
      -- cfg_ds_device_number                       => (others => '0'),
      -- cfg_ds_function_number                     => (others => '0'),
      cfg_subsys_vend_id                            => (X"1014"),
      cfg_dev_id_pf0                                => (X"0477"),
      -- cfg_dev_id_pf1                             => (others => '0'),;
      -- cfg_dev_id_pf2                             => (others => '0'),;
      -- cfg_dev_id_pf3                             => (others => '0'),;
      cfg_vend_id                                   => (X"1014"),
      cfg_rev_id_pf0                                => (X"02"),
      -- cfg_rev_id_pf1                             => (others => '0'),
      -- cfg_rev_id_pf2                             => (others => '0'),
      -- cfg_rev_id_pf3                             => (others => '0'),
      cfg_subsys_id_pf0                             => (X"0666"),
      -- cfg_subsys_id_pf1                          => (others => '0'),
      -- cfg_subsys_id_pf2                          => (others => '0'),
      -- cfg_subsys_id_pf3                          => (others => '0'),

      -- sys_clk                                    => sys_clk_p,
      sys_clk                                       => sys_clk,
      sys_clk_gt                                    => sys_clk_gt,
      sys_reset                                     => sys_rst_n_c,

      phy_rdy_out                                   => open

      -- int_qpll0lock_out                          => open,
      -- int_qpll0outrefclk_out                     => open,
      -- int_qpll0outclk_out                        => open,
      -- int_qpll1lock_out                          => open,
      -- int_qpll1outrefclk_out                     => open,
      -- int_qpll1outclk_out                        => open
    );

  -- CAPI board infrastructure
  capi_bis : capi_board_infrastructure
    port map (
      cfg_ext_read_received       => cfg_ext_read_received,
      cfg_ext_write_received      => cfg_ext_write_received,
      cfg_ext_register_number     => cfg_ext_register_number,
      cfg_ext_function_number     => cfg_ext_function_number,
      cfg_ext_write_data          => cfg_ext_write_data,
      cfg_ext_write_byte_enable   => cfg_ext_write_byte_enable,
      cfg_ext_read_data           => cfg_ext_read_data,
      cfg_ext_read_data_valid     => cfg_ext_read_data_valid,

      spi_miso_secondary          => spi_miso_secondary,
      spi_mosi_secondary          => spi_mosi_secondary,
      spi_cen_secondary           => spi_cen_secondary,

      pci_pi_nperst0              => sys_rst_n_c,
      pcihip0_psl_clk             => pcihip0_psl_clk,
      icap_clk                    => icap_clk,
      cpld_usergolden             => gold_factory,
      crc_error                   => crc_error
    );

  -- Xilinx component which is required to generate correct clocks towards PCIHIP
  refclk_ibuf : IBUFDS_GTE4
    -- generic map (
    --   REFCLK_EN_TX_PATH  => '0',
    --   REFCLK_HROW_CK_SEL => "00",
    --   REFCLK_ICNTL_RX    => "00"
    -- )
    port map (
      O       => sys_clk_gt,
      ODIV2   => sys_clk,
      CEB     => '0',
      I       => sys_clk_p,
      IB      => sys_clk_n
    );

  IBUF_inst : IBUF
    port map (
      O => sys_rst_n_c,   -- 1-bit output: Buffer output
      I => sys_rst_n      -- 1-bit input: Buffer input
    );

  -- gate clock_lite until clocks are stable after link up
  -- avoid glitches to sem core to prevent false errors or worse
  -- also used to clock multiboot logic so keep enabled when link goes down
  -- clock_lite_ce <= clock_gen_locked and not(user_reset);
  dff_icap_clk_ce: capi_rise_dff
    port map (
      dout  => icap_clk_ce,
      din   => icap_clk_ce_d,
      clk   => pcihip0_psl_clk
    );

  icap_clk_ce_d <= icap_clk_ce or (clk_wiz_2_locked and not(pcihip0_psl_rst));

  -- MMCM to generate PSL clock (100...250MHz)
  pll0: uscale_plus_clk_wiz
    port map (
      clk_in1     => pcihip0_psl_clk, -- driven by pcihip
      clk_out1    => psl_clk,   -- goes to psl logic
      clk_out2    => psl_clk_div2, -- 125mhz out to psl_accel if required (went to psl logic)
      clk_out3    => icap_clk,     -- goes to sem, multiboot
      clk_out3_ce => icap_clk_ce,     -- gate off while unstable to prevent sem errors
      reset       => '0', -- was driven by pcihip, hardware fix for perst
      locked      => clk_wiz_2_locked
    );

  --component capi_fpga_reset
  capi_fpga_reset: capi_fpga_reset_gen
    port map (
      pll_locked  => clk_wiz_2_locked,
      clk         => psl_clk,
      reset       => psl_reset_sig
    );

  -- component capi_stp_counter
  csc: capi_stp_counter
    port map (
      clk               => psl_clk,
      reset             => psl_reset_sig,
      stp_counter_1sec  => stp_counter_1sec_sig,
      stp_counter_msb   => stp_counter_msb_sig
    );

  -- sys_clk_p_out: capi_stp_counter
  --   port map (
  --     clk               => sys_clk,
  --     reset             => pcihip0_psl_rst,
  --     stp_counter_1sec  => sys_clk_counter_1sec_sig,
  --     stp_counter_msb   => open
  --   );

  user_clock: capi_stp_counter
    port map (
      clk               => pcihip0_psl_clk,
      reset             => pcihip0_psl_rst,
      stp_counter_1sec  => user_clock_sig,
      stp_counter_msb   => open
    );

end capi_bsp;
