--  Redistribution and use in source and binary forms, with or without modification,
--  are permitted provided that the following conditions are met:
--   o Redistributions of source code must retain the above copyright notice, this list
--   of conditions and the following disclaimer.
--   o Redistributions in binary form must reproduce the above copyright notice, this
--   list of conditions and the following disclaimer in the documentation and/or
--   other materials provided with the distribution.
--   o Neither the name of Freescale Semiconductor, Inc. nor the names of its
--   contributors may be used to endorse or promote products derived from this
--   software without specific prior written permission.
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
--   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
--   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--  This spec has been automatically generated from MKL28Z7.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

--  Enhanced direct memory access controller
package MKL28Z7.DMA0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Enable Debug
   type CR_EDBG_Field is
     (
      --  When in debug mode, the DMA continues to operate.
      CR_EDBG_Field_0,
      --  When in debug mode, the DMA stalls the start of a new channel.
      --  Executing channels are allowed to complete. Channel execution resumes
      --  when the system exits debug mode or the EDBG bit is cleared.
      CR_EDBG_Field_1)
     with Size => 1;
   for CR_EDBG_Field use
     (CR_EDBG_Field_0 => 0,
      CR_EDBG_Field_1 => 1);

   --  Enable Round Robin Channel Arbitration
   type CR_ERCA_Field is
     (
      --  Fixed priority arbitration is used for channel selection .
      CR_ERCA_Field_0,
      --  Round robin arbitration is used for channel selection .
      CR_ERCA_Field_1)
     with Size => 1;
   for CR_ERCA_Field use
     (CR_ERCA_Field_0 => 0,
      CR_ERCA_Field_1 => 1);

   --  Halt On Error
   type CR_HOE_Field is
     (
      --  Normal operation
      CR_HOE_Field_0,
      --  Any error causes the HALT bit to set. Subsequently, all service
      --  requests are ignored until the HALT bit is cleared.
      CR_HOE_Field_1)
     with Size => 1;
   for CR_HOE_Field use
     (CR_HOE_Field_0 => 0,
      CR_HOE_Field_1 => 1);

   --  Halt DMA Operations
   type CR_HALT_Field is
     (
      --  Normal operation
      CR_HALT_Field_0,
      --  Stall the start of any new channels. Executing channels are allowed
      --  to complete. Channel execution resumes when this bit is cleared.
      CR_HALT_Field_1)
     with Size => 1;
   for CR_HALT_Field use
     (CR_HALT_Field_0 => 0,
      CR_HALT_Field_1 => 1);

   --  Continuous Link Mode
   type CR_CLM_Field is
     (
      --  A minor loop channel link made to itself goes through channel
      --  arbitration before being activated again.
      CR_CLM_Field_0,
      --  A minor loop channel link made to itself does not go through channel
      --  arbitration before being activated again. Upon minor loop completion,
      --  the channel activates again if that channel has a minor loop channel
      --  link enabled and the link channel is itself. This effectively applies
      --  the minor loop offsets and restarts the next minor loop.
      CR_CLM_Field_1)
     with Size => 1;
   for CR_CLM_Field use
     (CR_CLM_Field_0 => 0,
      CR_CLM_Field_1 => 1);

   --  Enable Minor Loop Mapping
   type CR_EMLM_Field is
     (
      --  Disabled. TCDn.word2 is defined as a 32-bit NBYTES field.
      CR_EMLM_Field_0,
      --  Enabled. TCDn.word2 is redefined to include individual enable fields,
      --  an offset field, and the NBYTES field. The individual enable fields
      --  allow the minor loop offset to be applied to the source address, the
      --  destination address, or both. The NBYTES field is reduced when either
      --  offset is enabled.
      CR_EMLM_Field_1)
     with Size => 1;
   for CR_EMLM_Field use
     (CR_EMLM_Field_0 => 0,
      CR_EMLM_Field_1 => 1);

   --  Error Cancel Transfer
   type CR_ECX_Field is
     (
      --  Normal operation
      CR_ECX_Field_0,
      --  Cancel the remaining data transfer in the same fashion as the CX bit.
      --  Stop the executing channel and force the minor loop to finish. The
      --  cancel takes effect after the last write of the current read/write
      --  sequence. The ECX bit clears itself after the cancel is honored. In
      --  addition to cancelling the transfer, ECX treats the cancel as an
      --  error condition, thus updating the Error Status register (DMAx_ES)
      --  and generating an optional error interrupt.
      CR_ECX_Field_1)
     with Size => 1;
   for CR_ECX_Field use
     (CR_ECX_Field_0 => 0,
      CR_ECX_Field_1 => 1);

   --  Cancel Transfer
   type CR_CX_Field is
     (
      --  Normal operation
      CR_CX_Field_0,
      --  Cancel the remaining data transfer. Stop the executing channel and
      --  force the minor loop to finish. The cancel takes effect after the
      --  last write of the current read/write sequence. The CX bit clears
      --  itself after the cancel has been honored. This cancel retires the
      --  channel normally as if the minor loop was completed.
      CR_CX_Field_1)
     with Size => 1;
   for CR_CX_Field use
     (CR_CX_Field_0 => 0,
      CR_CX_Field_1 => 1);

   --  DMA Active Status
   type CR_ACTIVE_Field is
     (
      --  eDMA is idle.
      CR_ACTIVE_Field_0,
      --  eDMA is executing a channel.
      CR_ACTIVE_Field_1)
     with Size => 1;
   for CR_ACTIVE_Field use
     (CR_ACTIVE_Field_0 => 0,
      CR_ACTIVE_Field_1 => 1);

   --  Control Register
   type DMA0_CR_Register is record
      --  unspecified
      Reserved_0_0   : MKL28Z7.Bit := 16#0#;
      --  Enable Debug
      EDBG           : CR_EDBG_Field := MKL28Z7.DMA0.CR_EDBG_Field_0;
      --  Enable Round Robin Channel Arbitration
      ERCA           : CR_ERCA_Field := MKL28Z7.DMA0.CR_ERCA_Field_0;
      --  unspecified
      Reserved_3_3   : MKL28Z7.Bit := 16#0#;
      --  Halt On Error
      HOE            : CR_HOE_Field := MKL28Z7.DMA0.CR_HOE_Field_0;
      --  Halt DMA Operations
      HALT           : CR_HALT_Field := MKL28Z7.DMA0.CR_HALT_Field_0;
      --  Continuous Link Mode
      CLM            : CR_CLM_Field := MKL28Z7.DMA0.CR_CLM_Field_0;
      --  Enable Minor Loop Mapping
      EMLM           : CR_EMLM_Field := MKL28Z7.DMA0.CR_EMLM_Field_0;
      --  unspecified
      Reserved_8_15  : MKL28Z7.Byte := 16#0#;
      --  Error Cancel Transfer
      ECX            : CR_ECX_Field := MKL28Z7.DMA0.CR_ECX_Field_0;
      --  Cancel Transfer
      CX             : CR_CX_Field := MKL28Z7.DMA0.CR_CX_Field_0;
      --  unspecified
      Reserved_18_30 : MKL28Z7.UInt13 := 16#0#;
      --  Read-only. DMA Active Status
      ACTIVE         : CR_ACTIVE_Field := MKL28Z7.DMA0.CR_ACTIVE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA0_CR_Register use record
      Reserved_0_0   at 0 range 0 .. 0;
      EDBG           at 0 range 1 .. 1;
      ERCA           at 0 range 2 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      HOE            at 0 range 4 .. 4;
      HALT           at 0 range 5 .. 5;
      CLM            at 0 range 6 .. 6;
      EMLM           at 0 range 7 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      ECX            at 0 range 16 .. 16;
      CX             at 0 range 17 .. 17;
      Reserved_18_30 at 0 range 18 .. 30;
      ACTIVE         at 0 range 31 .. 31;
   end record;

   --  Destination Bus Error
   type ES_DBE_Field is
     (
      --  No destination bus error
      ES_DBE_Field_0,
      --  The last recorded error was a bus error on a destination write
      ES_DBE_Field_1)
     with Size => 1;
   for ES_DBE_Field use
     (ES_DBE_Field_0 => 0,
      ES_DBE_Field_1 => 1);

   --  Source Bus Error
   type ES_SBE_Field is
     (
      --  No source bus error
      ES_SBE_Field_0,
      --  The last recorded error was a bus error on a source read
      ES_SBE_Field_1)
     with Size => 1;
   for ES_SBE_Field use
     (ES_SBE_Field_0 => 0,
      ES_SBE_Field_1 => 1);

   --  Scatter/Gather Configuration Error
   type ES_SGE_Field is
     (
      --  No scatter/gather configuration error
      ES_SGE_Field_0,
      --  The last recorded error was a configuration error detected in the
      --  TCDn_DLASTSGA field. This field is checked at the beginning of a
      --  scatter/gather operation after major loop completion if TCDn_CSR[ESG]
      --  is enabled. TCDn_DLASTSGA is not on a 32 byte boundary.
      ES_SGE_Field_1)
     with Size => 1;
   for ES_SGE_Field use
     (ES_SGE_Field_0 => 0,
      ES_SGE_Field_1 => 1);

   --  NBYTES/CITER Configuration Error
   type ES_NCE_Field is
     (
      --  No NBYTES/CITER configuration error
      ES_NCE_Field_0,
      --  The last recorded error was a configuration error detected in the
      --  TCDn_NBYTES or TCDn_CITER fields. TCDn_NBYTES is not a multiple of
      --  TCDn_ATTR[SSIZE] and TCDn_ATTR[DSIZE], or TCDn_CITER[CITER] is equal
      --  to zero, or TCDn_CITER[ELINK] is not equal to TCDn_BITER[ELINK]
      ES_NCE_Field_1)
     with Size => 1;
   for ES_NCE_Field use
     (ES_NCE_Field_0 => 0,
      ES_NCE_Field_1 => 1);

   --  Destination Offset Error
   type ES_DOE_Field is
     (
      --  No destination offset configuration error
      ES_DOE_Field_0,
      --  The last recorded error was a configuration error detected in the
      --  TCDn_DOFF field. TCDn_DOFF is inconsistent with TCDn_ATTR[DSIZE].
      ES_DOE_Field_1)
     with Size => 1;
   for ES_DOE_Field use
     (ES_DOE_Field_0 => 0,
      ES_DOE_Field_1 => 1);

   --  Destination Address Error
   type ES_DAE_Field is
     (
      --  No destination address configuration error
      ES_DAE_Field_0,
      --  The last recorded error was a configuration error detected in the
      --  TCDn_DADDR field. TCDn_DADDR is inconsistent with TCDn_ATTR[DSIZE].
      ES_DAE_Field_1)
     with Size => 1;
   for ES_DAE_Field use
     (ES_DAE_Field_0 => 0,
      ES_DAE_Field_1 => 1);

   --  Source Offset Error
   type ES_SOE_Field is
     (
      --  No source offset configuration error
      ES_SOE_Field_0,
      --  The last recorded error was a configuration error detected in the
      --  TCDn_SOFF field. TCDn_SOFF is inconsistent with TCDn_ATTR[SSIZE].
      ES_SOE_Field_1)
     with Size => 1;
   for ES_SOE_Field use
     (ES_SOE_Field_0 => 0,
      ES_SOE_Field_1 => 1);

   --  Source Address Error
   type ES_SAE_Field is
     (
      --  No source address configuration error.
      ES_SAE_Field_0,
      --  The last recorded error was a configuration error detected in the
      --  TCDn_SADDR field. TCDn_SADDR is inconsistent with TCDn_ATTR[SSIZE].
      ES_SAE_Field_1)
     with Size => 1;
   for ES_SAE_Field use
     (ES_SAE_Field_0 => 0,
      ES_SAE_Field_1 => 1);

   subtype ES_ERRCHN_Field is MKL28Z7.UInt3;

   --  Channel Priority Error
   type ES_CPE_Field is
     (
      --  No channel priority error
      ES_CPE_Field_0,
      --  The last recorded error was a configuration error in the channel
      --  priorities . Channel priorities are not unique.
      ES_CPE_Field_1)
     with Size => 1;
   for ES_CPE_Field use
     (ES_CPE_Field_0 => 0,
      ES_CPE_Field_1 => 1);

   --  Transfer Canceled
   type ES_ECX_Field is
     (
      --  No canceled transfers
      ES_ECX_Field_0,
      --  The last recorded entry was a canceled transfer by the error cancel
      --  transfer input
      ES_ECX_Field_1)
     with Size => 1;
   for ES_ECX_Field use
     (ES_ECX_Field_0 => 0,
      ES_ECX_Field_1 => 1);

   --  Logical OR of all ERR status bits
   type ES_VLD_Field is
     (
      --  No ERR bits are set.
      ES_VLD_Field_0,
      --  At least one ERR bit is set indicating a valid error exists that has
      --  not been cleared.
      ES_VLD_Field_1)
     with Size => 1;
   for ES_VLD_Field use
     (ES_VLD_Field_0 => 0,
      ES_VLD_Field_1 => 1);

   --  Error Status Register
   type DMA0_ES_Register is record
      --  Read-only. Destination Bus Error
      DBE            : ES_DBE_Field;
      --  Read-only. Source Bus Error
      SBE            : ES_SBE_Field;
      --  Read-only. Scatter/Gather Configuration Error
      SGE            : ES_SGE_Field;
      --  Read-only. NBYTES/CITER Configuration Error
      NCE            : ES_NCE_Field;
      --  Read-only. Destination Offset Error
      DOE            : ES_DOE_Field;
      --  Read-only. Destination Address Error
      DAE            : ES_DAE_Field;
      --  Read-only. Source Offset Error
      SOE            : ES_SOE_Field;
      --  Read-only. Source Address Error
      SAE            : ES_SAE_Field;
      --  Read-only. Error Channel Number or Canceled Channel Number
      ERRCHN         : ES_ERRCHN_Field;
      --  unspecified
      Reserved_11_13 : MKL28Z7.UInt3;
      --  Read-only. Channel Priority Error
      CPE            : ES_CPE_Field;
      --  unspecified
      Reserved_15_15 : MKL28Z7.Bit;
      --  Read-only. Transfer Canceled
      ECX            : ES_ECX_Field;
      --  unspecified
      Reserved_17_30 : MKL28Z7.UInt14;
      --  Read-only. Logical OR of all ERR status bits
      VLD            : ES_VLD_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA0_ES_Register use record
      DBE            at 0 range 0 .. 0;
      SBE            at 0 range 1 .. 1;
      SGE            at 0 range 2 .. 2;
      NCE            at 0 range 3 .. 3;
      DOE            at 0 range 4 .. 4;
      DAE            at 0 range 5 .. 5;
      SOE            at 0 range 6 .. 6;
      SAE            at 0 range 7 .. 7;
      ERRCHN         at 0 range 8 .. 10;
      Reserved_11_13 at 0 range 11 .. 13;
      CPE            at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      ECX            at 0 range 16 .. 16;
      Reserved_17_30 at 0 range 17 .. 30;
      VLD            at 0 range 31 .. 31;
   end record;

   --  Enable DMA Request 0
   type ERQ_ERQ0_Field is
     (
      --  The DMA request signal for the corresponding channel is disabled
      ERQ_ERQ0_Field_0,
      --  The DMA request signal for the corresponding channel is enabled
      ERQ_ERQ0_Field_1)
     with Size => 1;
   for ERQ_ERQ0_Field use
     (ERQ_ERQ0_Field_0 => 0,
      ERQ_ERQ0_Field_1 => 1);

   -------------
   -- ERQ.ERQ --
   -------------

   --  ERQ array
   type ERQ_Field_Array is array (0 .. 7) of ERQ_ERQ0_Field
     with Component_Size => 1, Size => 8;

   --  Type definition for ERQ
   type ERQ_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  ERQ as a value
            Val : MKL28Z7.Byte;
         when True =>
            --  ERQ as an array
            Arr : ERQ_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8;

   for ERQ_Field use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Enable Request Register
   type DMA0_ERQ_Register is record
      --  Enable DMA Request 0
      ERQ           : ERQ_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA0_ERQ_Register use record
      ERQ           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Enable Error Interrupt 0
   type EEI_EEI0_Field is
     (
      --  The error signal for corresponding channel does not generate an error
      --  interrupt
      EEI_EEI0_Field_0,
      --  The assertion of the error signal for corresponding channel generates
      --  an error interrupt request
      EEI_EEI0_Field_1)
     with Size => 1;
   for EEI_EEI0_Field use
     (EEI_EEI0_Field_0 => 0,
      EEI_EEI0_Field_1 => 1);

   -------------
   -- EEI.EEI --
   -------------

   --  EEI array
   type EEI_Field_Array is array (0 .. 7) of EEI_EEI0_Field
     with Component_Size => 1, Size => 8;

   --  Type definition for EEI
   type EEI_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  EEI as a value
            Val : MKL28Z7.Byte;
         when True =>
            --  EEI as an array
            Arr : EEI_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8;

   for EEI_Field use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Enable Error Interrupt Register
   type DMA0_EEI_Register is record
      --  Enable Error Interrupt 0
      EEI           : EEI_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA0_EEI_Register use record
      EEI           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CEEI_CEEI_Field is MKL28Z7.UInt3;

   --  Clear All Enable Error Interrupts
   type CEEI_CAEE_Field is
     (
      --  Clear only the EEI bit specified in the CEEI field
      CEEI_CAEE_Field_0,
      --  Clear all bits in EEI
      CEEI_CAEE_Field_1)
     with Size => 1;
   for CEEI_CAEE_Field use
     (CEEI_CAEE_Field_0 => 0,
      CEEI_CAEE_Field_1 => 1);

   --  No Op enable
   type CEEI_NOP_Field is
     (
      --  Normal operation
      CEEI_NOP_Field_0,
      --  No operation, ignore the other bits in this register
      CEEI_NOP_Field_1)
     with Size => 1;
   for CEEI_NOP_Field use
     (CEEI_NOP_Field_0 => 0,
      CEEI_NOP_Field_1 => 1);

   --  Clear Enable Error Interrupt Register
   type DMA0_CEEI_Register is record
      --  Write-only. Clear Enable Error Interrupt
      CEEI         : CEEI_CEEI_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Write-only. Clear All Enable Error Interrupts
      CAEE         : CEEI_CAEE_Field := MKL28Z7.DMA0.CEEI_CAEE_Field_0;
      --  Write-only. No Op enable
      NOP          : CEEI_NOP_Field := MKL28Z7.DMA0.CEEI_NOP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_CEEI_Register use record
      CEEI         at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      CAEE         at 0 range 6 .. 6;
      NOP          at 0 range 7 .. 7;
   end record;

   subtype SEEI_SEEI_Field is MKL28Z7.UInt3;

   --  Sets All Enable Error Interrupts
   type SEEI_SAEE_Field is
     (
      --  Set only the EEI bit specified in the SEEI field.
      SEEI_SAEE_Field_0,
      --  Sets all bits in EEI
      SEEI_SAEE_Field_1)
     with Size => 1;
   for SEEI_SAEE_Field use
     (SEEI_SAEE_Field_0 => 0,
      SEEI_SAEE_Field_1 => 1);

   --  No Op enable
   type SEEI_NOP_Field is
     (
      --  Normal operation
      SEEI_NOP_Field_0,
      --  No operation, ignore the other bits in this register
      SEEI_NOP_Field_1)
     with Size => 1;
   for SEEI_NOP_Field use
     (SEEI_NOP_Field_0 => 0,
      SEEI_NOP_Field_1 => 1);

   --  Set Enable Error Interrupt Register
   type DMA0_SEEI_Register is record
      --  Write-only. Set Enable Error Interrupt
      SEEI         : SEEI_SEEI_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Write-only. Sets All Enable Error Interrupts
      SAEE         : SEEI_SAEE_Field := MKL28Z7.DMA0.SEEI_SAEE_Field_0;
      --  Write-only. No Op enable
      NOP          : SEEI_NOP_Field := MKL28Z7.DMA0.SEEI_NOP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_SEEI_Register use record
      SEEI         at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      SAEE         at 0 range 6 .. 6;
      NOP          at 0 range 7 .. 7;
   end record;

   subtype CERQ_CERQ_Field is MKL28Z7.UInt3;

   --  Clear All Enable Requests
   type CERQ_CAER_Field is
     (
      --  Clear only the ERQ bit specified in the CERQ field
      CERQ_CAER_Field_0,
      --  Clear all bits in ERQ
      CERQ_CAER_Field_1)
     with Size => 1;
   for CERQ_CAER_Field use
     (CERQ_CAER_Field_0 => 0,
      CERQ_CAER_Field_1 => 1);

   --  No Op enable
   type CERQ_NOP_Field is
     (
      --  Normal operation
      CERQ_NOP_Field_0,
      --  No operation, ignore the other bits in this register
      CERQ_NOP_Field_1)
     with Size => 1;
   for CERQ_NOP_Field use
     (CERQ_NOP_Field_0 => 0,
      CERQ_NOP_Field_1 => 1);

   --  Clear Enable Request Register
   type DMA0_CERQ_Register is record
      --  Write-only. Clear Enable Request
      CERQ         : CERQ_CERQ_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Write-only. Clear All Enable Requests
      CAER         : CERQ_CAER_Field := MKL28Z7.DMA0.CERQ_CAER_Field_0;
      --  Write-only. No Op enable
      NOP          : CERQ_NOP_Field := MKL28Z7.DMA0.CERQ_NOP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_CERQ_Register use record
      CERQ         at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      CAER         at 0 range 6 .. 6;
      NOP          at 0 range 7 .. 7;
   end record;

   subtype SERQ_SERQ_Field is MKL28Z7.UInt3;

   --  Set All Enable Requests
   type SERQ_SAER_Field is
     (
      --  Set only the ERQ bit specified in the SERQ field
      SERQ_SAER_Field_0,
      --  Set all bits in ERQ
      SERQ_SAER_Field_1)
     with Size => 1;
   for SERQ_SAER_Field use
     (SERQ_SAER_Field_0 => 0,
      SERQ_SAER_Field_1 => 1);

   --  No Op enable
   type SERQ_NOP_Field is
     (
      --  Normal operation
      SERQ_NOP_Field_0,
      --  No operation, ignore the other bits in this register
      SERQ_NOP_Field_1)
     with Size => 1;
   for SERQ_NOP_Field use
     (SERQ_NOP_Field_0 => 0,
      SERQ_NOP_Field_1 => 1);

   --  Set Enable Request Register
   type DMA0_SERQ_Register is record
      --  Write-only. Set Enable Request
      SERQ         : SERQ_SERQ_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Write-only. Set All Enable Requests
      SAER         : SERQ_SAER_Field := MKL28Z7.DMA0.SERQ_SAER_Field_0;
      --  Write-only. No Op enable
      NOP          : SERQ_NOP_Field := MKL28Z7.DMA0.SERQ_NOP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_SERQ_Register use record
      SERQ         at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      SAER         at 0 range 6 .. 6;
      NOP          at 0 range 7 .. 7;
   end record;

   subtype CDNE_CDNE_Field is MKL28Z7.UInt3;

   --  Clears All DONE Bits
   type CDNE_CADN_Field is
     (
      --  Clears only the TCDn_CSR[DONE] bit specified in the CDNE field
      CDNE_CADN_Field_0,
      --  Clears all bits in TCDn_CSR[DONE]
      CDNE_CADN_Field_1)
     with Size => 1;
   for CDNE_CADN_Field use
     (CDNE_CADN_Field_0 => 0,
      CDNE_CADN_Field_1 => 1);

   --  No Op enable
   type CDNE_NOP_Field is
     (
      --  Normal operation
      CDNE_NOP_Field_0,
      --  No operation, ignore the other bits in this register
      CDNE_NOP_Field_1)
     with Size => 1;
   for CDNE_NOP_Field use
     (CDNE_NOP_Field_0 => 0,
      CDNE_NOP_Field_1 => 1);

   --  Clear DONE Status Bit Register
   type DMA0_CDNE_Register is record
      --  Write-only. Clear DONE Bit
      CDNE         : CDNE_CDNE_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Write-only. Clears All DONE Bits
      CADN         : CDNE_CADN_Field := MKL28Z7.DMA0.CDNE_CADN_Field_0;
      --  Write-only. No Op enable
      NOP          : CDNE_NOP_Field := MKL28Z7.DMA0.CDNE_NOP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_CDNE_Register use record
      CDNE         at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      CADN         at 0 range 6 .. 6;
      NOP          at 0 range 7 .. 7;
   end record;

   subtype SSRT_SSRT_Field is MKL28Z7.UInt3;

   --  Set All START Bits (activates all channels)
   type SSRT_SAST_Field is
     (
      --  Set only the TCDn_CSR[START] bit specified in the SSRT field
      SSRT_SAST_Field_0,
      --  Set all bits in TCDn_CSR[START]
      SSRT_SAST_Field_1)
     with Size => 1;
   for SSRT_SAST_Field use
     (SSRT_SAST_Field_0 => 0,
      SSRT_SAST_Field_1 => 1);

   --  No Op enable
   type SSRT_NOP_Field is
     (
      --  Normal operation
      SSRT_NOP_Field_0,
      --  No operation, ignore the other bits in this register
      SSRT_NOP_Field_1)
     with Size => 1;
   for SSRT_NOP_Field use
     (SSRT_NOP_Field_0 => 0,
      SSRT_NOP_Field_1 => 1);

   --  Set START Bit Register
   type DMA0_SSRT_Register is record
      --  Write-only. Set START Bit
      SSRT         : SSRT_SSRT_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Write-only. Set All START Bits (activates all channels)
      SAST         : SSRT_SAST_Field := MKL28Z7.DMA0.SSRT_SAST_Field_0;
      --  Write-only. No Op enable
      NOP          : SSRT_NOP_Field := MKL28Z7.DMA0.SSRT_NOP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_SSRT_Register use record
      SSRT         at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      SAST         at 0 range 6 .. 6;
      NOP          at 0 range 7 .. 7;
   end record;

   subtype CERR_CERR_Field is MKL28Z7.UInt3;

   --  Clear All Error Indicators
   type CERR_CAEI_Field is
     (
      --  Clear only the ERR bit specified in the CERR field
      CERR_CAEI_Field_0,
      --  Clear all bits in ERR
      CERR_CAEI_Field_1)
     with Size => 1;
   for CERR_CAEI_Field use
     (CERR_CAEI_Field_0 => 0,
      CERR_CAEI_Field_1 => 1);

   --  No Op enable
   type CERR_NOP_Field is
     (
      --  Normal operation
      CERR_NOP_Field_0,
      --  No operation, ignore the other bits in this register
      CERR_NOP_Field_1)
     with Size => 1;
   for CERR_NOP_Field use
     (CERR_NOP_Field_0 => 0,
      CERR_NOP_Field_1 => 1);

   --  Clear Error Register
   type DMA0_CERR_Register is record
      --  Write-only. Clear Error Indicator
      CERR         : CERR_CERR_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Write-only. Clear All Error Indicators
      CAEI         : CERR_CAEI_Field := MKL28Z7.DMA0.CERR_CAEI_Field_0;
      --  Write-only. No Op enable
      NOP          : CERR_NOP_Field := MKL28Z7.DMA0.CERR_NOP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_CERR_Register use record
      CERR         at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      CAEI         at 0 range 6 .. 6;
      NOP          at 0 range 7 .. 7;
   end record;

   subtype CINT_CINT_Field is MKL28Z7.UInt3;

   --  Clear All Interrupt Requests
   type CINT_CAIR_Field is
     (
      --  Clear only the INT bit specified in the CINT field
      CINT_CAIR_Field_0,
      --  Clear all bits in INT
      CINT_CAIR_Field_1)
     with Size => 1;
   for CINT_CAIR_Field use
     (CINT_CAIR_Field_0 => 0,
      CINT_CAIR_Field_1 => 1);

   --  No Op enable
   type CINT_NOP_Field is
     (
      --  Normal operation
      CINT_NOP_Field_0,
      --  No operation, ignore the other bits in this register
      CINT_NOP_Field_1)
     with Size => 1;
   for CINT_NOP_Field use
     (CINT_NOP_Field_0 => 0,
      CINT_NOP_Field_1 => 1);

   --  Clear Interrupt Request Register
   type DMA0_CINT_Register is record
      --  Write-only. Clear Interrupt Request
      CINT         : CINT_CINT_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Write-only. Clear All Interrupt Requests
      CAIR         : CINT_CAIR_Field := MKL28Z7.DMA0.CINT_CAIR_Field_0;
      --  Write-only. No Op enable
      NOP          : CINT_NOP_Field := MKL28Z7.DMA0.CINT_NOP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_CINT_Register use record
      CINT         at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      CAIR         at 0 range 6 .. 6;
      NOP          at 0 range 7 .. 7;
   end record;

   --  Interrupt Request 0
   type INT_INT0_Field is
     (
      --  The interrupt request for corresponding channel is cleared
      INT_INT0_Field_0,
      --  The interrupt request for corresponding channel is active
      INT_INT0_Field_1)
     with Size => 1;
   for INT_INT0_Field use
     (INT_INT0_Field_0 => 0,
      INT_INT0_Field_1 => 1);

   -------------
   -- INT.INT --
   -------------

   --  INT array
   type INT_Field_Array is array (0 .. 7) of INT_INT0_Field
     with Component_Size => 1, Size => 8;

   --  Type definition for INT
   type INT_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  INT as a value
            Val : MKL28Z7.Byte;
         when True =>
            --  INT as an array
            Arr : INT_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8;

   for INT_Field use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Interrupt Request Register
   type DMA0_INT_Register is record
      --  Interrupt Request 0
      INT           : INT_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA0_INT_Register use record
      INT           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Error In Channel 0
   type ERR_ERR0_Field is
     (
      --  An error in this channel has not occurred
      ERR_ERR0_Field_0,
      --  An error in this channel has occurred
      ERR_ERR0_Field_1)
     with Size => 1;
   for ERR_ERR0_Field use
     (ERR_ERR0_Field_0 => 0,
      ERR_ERR0_Field_1 => 1);

   -------------
   -- ERR.ERR --
   -------------

   --  ERR array
   type ERR_Field_Array is array (0 .. 7) of ERR_ERR0_Field
     with Component_Size => 1, Size => 8;

   --  Type definition for ERR
   type ERR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  ERR as a value
            Val : MKL28Z7.Byte;
         when True =>
            --  ERR as an array
            Arr : ERR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8;

   for ERR_Field use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Error Register
   type DMA0_ERR_Register is record
      --  Error In Channel 0
      ERR           : ERR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA0_ERR_Register use record
      ERR           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Hardware Request Status Channel 0
   type HRS_HRS0_Field is
     (
      --  A hardware service request for channel 0 is not present
      HRS_HRS0_Field_0,
      --  A hardware service request for channel 0 is present
      HRS_HRS0_Field_1)
     with Size => 1;
   for HRS_HRS0_Field use
     (HRS_HRS0_Field_0 => 0,
      HRS_HRS0_Field_1 => 1);

   --  Hardware Request Status Channel 1
   type HRS_HRS1_Field is
     (
      --  A hardware service request for channel 1 is not present
      HRS_HRS1_Field_0,
      --  A hardware service request for channel 1 is present
      HRS_HRS1_Field_1)
     with Size => 1;
   for HRS_HRS1_Field use
     (HRS_HRS1_Field_0 => 0,
      HRS_HRS1_Field_1 => 1);

   --  Hardware Request Status Channel 2
   type HRS_HRS2_Field is
     (
      --  A hardware service request for channel 2 is not present
      HRS_HRS2_Field_0,
      --  A hardware service request for channel 2 is present
      HRS_HRS2_Field_1)
     with Size => 1;
   for HRS_HRS2_Field use
     (HRS_HRS2_Field_0 => 0,
      HRS_HRS2_Field_1 => 1);

   --  Hardware Request Status Channel 3
   type HRS_HRS3_Field is
     (
      --  A hardware service request for channel 3 is not present
      HRS_HRS3_Field_0,
      --  A hardware service request for channel 3 is present
      HRS_HRS3_Field_1)
     with Size => 1;
   for HRS_HRS3_Field use
     (HRS_HRS3_Field_0 => 0,
      HRS_HRS3_Field_1 => 1);

   --  Hardware Request Status Channel 4
   type HRS_HRS4_Field is
     (
      --  A hardware service request for channel 4 is not present
      HRS_HRS4_Field_0,
      --  A hardware service request for channel 4 is present
      HRS_HRS4_Field_1)
     with Size => 1;
   for HRS_HRS4_Field use
     (HRS_HRS4_Field_0 => 0,
      HRS_HRS4_Field_1 => 1);

   --  Hardware Request Status Channel 5
   type HRS_HRS5_Field is
     (
      --  A hardware service request for channel 5 is not present
      HRS_HRS5_Field_0,
      --  A hardware service request for channel 5 is present
      HRS_HRS5_Field_1)
     with Size => 1;
   for HRS_HRS5_Field use
     (HRS_HRS5_Field_0 => 0,
      HRS_HRS5_Field_1 => 1);

   --  Hardware Request Status Channel 6
   type HRS_HRS6_Field is
     (
      --  A hardware service request for channel 6 is not present
      HRS_HRS6_Field_0,
      --  A hardware service request for channel 6 is present
      HRS_HRS6_Field_1)
     with Size => 1;
   for HRS_HRS6_Field use
     (HRS_HRS6_Field_0 => 0,
      HRS_HRS6_Field_1 => 1);

   --  Hardware Request Status Channel 7
   type HRS_HRS7_Field is
     (
      --  A hardware service request for channel 7 is not present
      HRS_HRS7_Field_0,
      --  A hardware service request for channel 7 is present
      HRS_HRS7_Field_1)
     with Size => 1;
   for HRS_HRS7_Field use
     (HRS_HRS7_Field_0 => 0,
      HRS_HRS7_Field_1 => 1);

   --  Hardware Request Status Register
   type DMA0_HRS_Register is record
      --  Read-only. Hardware Request Status Channel 0
      HRS0          : HRS_HRS0_Field;
      --  Read-only. Hardware Request Status Channel 1
      HRS1          : HRS_HRS1_Field;
      --  Read-only. Hardware Request Status Channel 2
      HRS2          : HRS_HRS2_Field;
      --  Read-only. Hardware Request Status Channel 3
      HRS3          : HRS_HRS3_Field;
      --  Read-only. Hardware Request Status Channel 4
      HRS4          : HRS_HRS4_Field;
      --  Read-only. Hardware Request Status Channel 5
      HRS5          : HRS_HRS5_Field;
      --  Read-only. Hardware Request Status Channel 6
      HRS6          : HRS_HRS6_Field;
      --  Read-only. Hardware Request Status Channel 7
      HRS7          : HRS_HRS7_Field;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA0_HRS_Register use record
      HRS0          at 0 range 0 .. 0;
      HRS1          at 0 range 1 .. 1;
      HRS2          at 0 range 2 .. 2;
      HRS3          at 0 range 3 .. 3;
      HRS4          at 0 range 4 .. 4;
      HRS5          at 0 range 5 .. 5;
      HRS6          at 0 range 6 .. 6;
      HRS7          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Enable asynchronous DMA request in stop mode for channel 0.
   type EARS_EDREQ_0_Field is
     (
      --  Disable asynchronous DMA request for channel 0.
      EARS_EDREQ_0_Field_0,
      --  Enable asynchronous DMA request for channel 0.
      EARS_EDREQ_0_Field_1)
     with Size => 1;
   for EARS_EDREQ_0_Field use
     (EARS_EDREQ_0_Field_0 => 0,
      EARS_EDREQ_0_Field_1 => 1);

   --  Enable asynchronous DMA request in stop mode for channel 1.
   type EARS_EDREQ_1_Field is
     (
      --  Disable asynchronous DMA request for channel 1
      EARS_EDREQ_1_Field_0,
      --  Enable asynchronous DMA request for channel 1.
      EARS_EDREQ_1_Field_1)
     with Size => 1;
   for EARS_EDREQ_1_Field use
     (EARS_EDREQ_1_Field_0 => 0,
      EARS_EDREQ_1_Field_1 => 1);

   --  Enable asynchronous DMA request in stop mode for channel 2.
   type EARS_EDREQ_2_Field is
     (
      --  Disable asynchronous DMA request for channel 2.
      EARS_EDREQ_2_Field_0,
      --  Enable asynchronous DMA request for channel 2.
      EARS_EDREQ_2_Field_1)
     with Size => 1;
   for EARS_EDREQ_2_Field use
     (EARS_EDREQ_2_Field_0 => 0,
      EARS_EDREQ_2_Field_1 => 1);

   --  Enable asynchronous DMA request in stop mode for channel 3.
   type EARS_EDREQ_3_Field is
     (
      --  Disable asynchronous DMA request for channel 3.
      EARS_EDREQ_3_Field_0,
      --  Enable asynchronous DMA request for channel 3.
      EARS_EDREQ_3_Field_1)
     with Size => 1;
   for EARS_EDREQ_3_Field use
     (EARS_EDREQ_3_Field_0 => 0,
      EARS_EDREQ_3_Field_1 => 1);

   --  Enable asynchronous DMA request in stop mode for channel 4
   type EARS_EDREQ_4_Field is
     (
      --  Disable asynchronous DMA request for channel 4.
      EARS_EDREQ_4_Field_0,
      --  Enable asynchronous DMA request for channel 4.
      EARS_EDREQ_4_Field_1)
     with Size => 1;
   for EARS_EDREQ_4_Field use
     (EARS_EDREQ_4_Field_0 => 0,
      EARS_EDREQ_4_Field_1 => 1);

   --  Enable asynchronous DMA request in stop mode for channel 5
   type EARS_EDREQ_5_Field is
     (
      --  Disable asynchronous DMA request for channel 5.
      EARS_EDREQ_5_Field_0,
      --  Enable asynchronous DMA request for channel 5.
      EARS_EDREQ_5_Field_1)
     with Size => 1;
   for EARS_EDREQ_5_Field use
     (EARS_EDREQ_5_Field_0 => 0,
      EARS_EDREQ_5_Field_1 => 1);

   --  Enable asynchronous DMA request in stop mode for channel 6
   type EARS_EDREQ_6_Field is
     (
      --  Disable asynchronous DMA request for channel 6.
      EARS_EDREQ_6_Field_0,
      --  Enable asynchronous DMA request for channel 6.
      EARS_EDREQ_6_Field_1)
     with Size => 1;
   for EARS_EDREQ_6_Field use
     (EARS_EDREQ_6_Field_0 => 0,
      EARS_EDREQ_6_Field_1 => 1);

   --  Enable asynchronous DMA request in stop mode for channel 7
   type EARS_EDREQ_7_Field is
     (
      --  Disable asynchronous DMA request for channel 7.
      EARS_EDREQ_7_Field_0,
      --  Enable asynchronous DMA request for channel 7.
      EARS_EDREQ_7_Field_1)
     with Size => 1;
   for EARS_EDREQ_7_Field use
     (EARS_EDREQ_7_Field_0 => 0,
      EARS_EDREQ_7_Field_1 => 1);

   --  Enable Asynchronous Request in Stop Register
   type DMA0_EARS_Register is record
      --  Enable asynchronous DMA request in stop mode for channel 0.
      EDREQ_0       : EARS_EDREQ_0_Field := MKL28Z7.DMA0.EARS_EDREQ_0_Field_0;
      --  Enable asynchronous DMA request in stop mode for channel 1.
      EDREQ_1       : EARS_EDREQ_1_Field := MKL28Z7.DMA0.EARS_EDREQ_1_Field_0;
      --  Enable asynchronous DMA request in stop mode for channel 2.
      EDREQ_2       : EARS_EDREQ_2_Field := MKL28Z7.DMA0.EARS_EDREQ_2_Field_0;
      --  Enable asynchronous DMA request in stop mode for channel 3.
      EDREQ_3       : EARS_EDREQ_3_Field := MKL28Z7.DMA0.EARS_EDREQ_3_Field_0;
      --  Enable asynchronous DMA request in stop mode for channel 4
      EDREQ_4       : EARS_EDREQ_4_Field := MKL28Z7.DMA0.EARS_EDREQ_4_Field_0;
      --  Enable asynchronous DMA request in stop mode for channel 5
      EDREQ_5       : EARS_EDREQ_5_Field := MKL28Z7.DMA0.EARS_EDREQ_5_Field_0;
      --  Enable asynchronous DMA request in stop mode for channel 6
      EDREQ_6       : EARS_EDREQ_6_Field := MKL28Z7.DMA0.EARS_EDREQ_6_Field_0;
      --  Enable asynchronous DMA request in stop mode for channel 7
      EDREQ_7       : EARS_EDREQ_7_Field := MKL28Z7.DMA0.EARS_EDREQ_7_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA0_EARS_Register use record
      EDREQ_0       at 0 range 0 .. 0;
      EDREQ_1       at 0 range 1 .. 1;
      EDREQ_2       at 0 range 2 .. 2;
      EDREQ_3       at 0 range 3 .. 3;
      EDREQ_4       at 0 range 4 .. 4;
      EDREQ_5       at 0 range 5 .. 5;
      EDREQ_6       at 0 range 6 .. 6;
      EDREQ_7       at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype DCHPRI_CHPRI_Field is MKL28Z7.UInt3;

   --  Disable Preempt Ability.
   type DCHPRI_DPA_Field is
     (
      --  Channel n can suspend a lower priority channel.
      DCHPRI_DPA_Field_0,
      --  Channel n cannot suspend any channel, regardless of channel priority.
      DCHPRI_DPA_Field_1)
     with Size => 1;
   for DCHPRI_DPA_Field use
     (DCHPRI_DPA_Field_0 => 0,
      DCHPRI_DPA_Field_1 => 1);

   --  Enable Channel Preemption.
   type DCHPRI_ECP_Field is
     (
      --  Channel n cannot be suspended by a higher priority channel's service
      --  request.
      DCHPRI_ECP_Field_0,
      --  Channel n can be temporarily suspended by the service request of a
      --  higher priority channel.
      DCHPRI_ECP_Field_1)
     with Size => 1;
   for DCHPRI_ECP_Field use
     (DCHPRI_ECP_Field_0 => 0,
      DCHPRI_ECP_Field_1 => 1);

   --  Channel n Priority Register
   type DMA0_DCHPRI_Register is record
      --  Channel n Arbitration Priority
      CHPRI        : DCHPRI_CHPRI_Field := 16#0#;
      --  unspecified
      Reserved_3_5 : MKL28Z7.UInt3 := 16#0#;
      --  Disable Preempt Ability.
      DPA          : DCHPRI_DPA_Field := MKL28Z7.DMA0.DCHPRI_DPA_Field_0;
      --  Enable Channel Preemption.
      ECP          : DCHPRI_ECP_Field := MKL28Z7.DMA0.DCHPRI_ECP_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DMA0_DCHPRI_Register use record
      CHPRI        at 0 range 0 .. 2;
      Reserved_3_5 at 0 range 3 .. 5;
      DPA          at 0 range 6 .. 6;
      ECP          at 0 range 7 .. 7;
   end record;

   --  Channel n Priority Register
   type DMA0_DCHPRI_Registers is array (0 .. 7) of DMA0_DCHPRI_Register;

   subtype TCD_ATTR0_DSIZE_Field is MKL28Z7.UInt3;
   subtype TCD_ATTR0_DMOD_Field is MKL28Z7.UInt5;

   --  Source data transfer size
   type TCD_ATTR0_SSIZE_Field is
     (
      --  8-bit
      TCD_ATTR0_SSIZE_Field_000,
      --  16-bit
      TCD_ATTR0_SSIZE_Field_001,
      --  32-bit
      TCD_ATTR0_SSIZE_Field_010,
      --  16-byte
      TCD_ATTR0_SSIZE_Field_100,
      --  32-byte
      TCD_ATTR0_SSIZE_Field_101)
     with Size => 3;
   for TCD_ATTR0_SSIZE_Field use
     (TCD_ATTR0_SSIZE_Field_000 => 0,
      TCD_ATTR0_SSIZE_Field_001 => 1,
      TCD_ATTR0_SSIZE_Field_010 => 2,
      TCD_ATTR0_SSIZE_Field_100 => 4,
      TCD_ATTR0_SSIZE_Field_101 => 5);

   --  Source Address Modulo
   type TCD_ATTR0_SMOD_Field is
     (
      --  Source address modulo feature is disabled
      TCD_ATTR0_SMOD_Field_0)
     with Size => 5;
   for TCD_ATTR0_SMOD_Field use
     (TCD_ATTR0_SMOD_Field_0 => 0);

   --  TCD Transfer Attributes
   type TCD_ATTR_Register is record
      --  Destination data transfer size
      DSIZE : TCD_ATTR0_DSIZE_Field := 16#0#;
      --  Destination Address Modulo
      DMOD  : TCD_ATTR0_DMOD_Field := 16#0#;
      --  Source data transfer size
      SSIZE : TCD_ATTR0_SSIZE_Field := MKL28Z7.DMA0.TCD_ATTR0_SSIZE_Field_000;
      --  Source Address Modulo
      SMOD  : TCD_ATTR0_SMOD_Field := MKL28Z7.DMA0.TCD_ATTR0_SMOD_Field_0;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for TCD_ATTR_Register use record
      DSIZE at 0 range 0 .. 2;
      DMOD  at 0 range 3 .. 7;
      SSIZE at 0 range 8 .. 10;
      SMOD  at 0 range 11 .. 15;
   end record;

   subtype TCD_NBYTES_MLOFFNO0_NBYTES_Field is MKL28Z7.UInt30;

   --  Destination Minor Loop Offset enable
   type TCD_NBYTES_MLOFFNO0_DMLOE_Field is
     (
      --  The minor loop offset is not applied to the DADDR
      TCD_NBYTES_MLOFFNO0_DMLOE_Field_0,
      --  The minor loop offset is applied to the DADDR
      TCD_NBYTES_MLOFFNO0_DMLOE_Field_1)
     with Size => 1;
   for TCD_NBYTES_MLOFFNO0_DMLOE_Field use
     (TCD_NBYTES_MLOFFNO0_DMLOE_Field_0 => 0,
      TCD_NBYTES_MLOFFNO0_DMLOE_Field_1 => 1);

   --  Source Minor Loop Offset Enable
   type TCD_NBYTES_MLOFFNO0_SMLOE_Field is
     (
      --  The minor loop offset is not applied to the SADDR
      TCD_NBYTES_MLOFFNO0_SMLOE_Field_0,
      --  The minor loop offset is applied to the SADDR
      TCD_NBYTES_MLOFFNO0_SMLOE_Field_1)
     with Size => 1;
   for TCD_NBYTES_MLOFFNO0_SMLOE_Field use
     (TCD_NBYTES_MLOFFNO0_SMLOE_Field_0 => 0,
      TCD_NBYTES_MLOFFNO0_SMLOE_Field_1 => 1);

   --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and Offset
   --  Disabled)
   type TCD_NBYTES_MLOFFNO_Register is record
      --  Minor Byte Transfer Count
      NBYTES : TCD_NBYTES_MLOFFNO0_NBYTES_Field := 16#0#;
      --  Destination Minor Loop Offset enable
      DMLOE  : TCD_NBYTES_MLOFFNO0_DMLOE_Field :=
                MKL28Z7.DMA0.TCD_NBYTES_MLOFFNO0_DMLOE_Field_0;
      --  Source Minor Loop Offset Enable
      SMLOE  : TCD_NBYTES_MLOFFNO0_SMLOE_Field :=
                MKL28Z7.DMA0.TCD_NBYTES_MLOFFNO0_SMLOE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TCD_NBYTES_MLOFFNO_Register use record
      NBYTES at 0 range 0 .. 29;
      DMLOE  at 0 range 30 .. 30;
      SMLOE  at 0 range 31 .. 31;
   end record;

   subtype TCD_NBYTES_MLOFFYES0_NBYTES_Field is MKL28Z7.UInt10;
   subtype TCD_NBYTES_MLOFFYES0_MLOFF_Field is MKL28Z7.UInt20;

   --  Destination Minor Loop Offset enable
   type TCD_NBYTES_MLOFFYES0_DMLOE_Field is
     (
      --  The minor loop offset is not applied to the DADDR
      TCD_NBYTES_MLOFFYES0_DMLOE_Field_0,
      --  The minor loop offset is applied to the DADDR
      TCD_NBYTES_MLOFFYES0_DMLOE_Field_1)
     with Size => 1;
   for TCD_NBYTES_MLOFFYES0_DMLOE_Field use
     (TCD_NBYTES_MLOFFYES0_DMLOE_Field_0 => 0,
      TCD_NBYTES_MLOFFYES0_DMLOE_Field_1 => 1);

   --  Source Minor Loop Offset Enable
   type TCD_NBYTES_MLOFFYES0_SMLOE_Field is
     (
      --  The minor loop offset is not applied to the SADDR
      TCD_NBYTES_MLOFFYES0_SMLOE_Field_0,
      --  The minor loop offset is applied to the SADDR
      TCD_NBYTES_MLOFFYES0_SMLOE_Field_1)
     with Size => 1;
   for TCD_NBYTES_MLOFFYES0_SMLOE_Field use
     (TCD_NBYTES_MLOFFYES0_SMLOE_Field_0 => 0,
      TCD_NBYTES_MLOFFYES0_SMLOE_Field_1 => 1);

   --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset Enabled)
   type TCD_NBYTES_MLOFFYES_Register is record
      --  Minor Byte Transfer Count
      NBYTES : TCD_NBYTES_MLOFFYES0_NBYTES_Field := 16#0#;
      --  If SMLOE or DMLOE is set, this field represents a sign-extended
      --  offset applied to the source or destination address to form the
      --  next-state value after the minor loop completes.
      MLOFF  : TCD_NBYTES_MLOFFYES0_MLOFF_Field := 16#0#;
      --  Destination Minor Loop Offset enable
      DMLOE  : TCD_NBYTES_MLOFFYES0_DMLOE_Field :=
                MKL28Z7.DMA0.TCD_NBYTES_MLOFFYES0_DMLOE_Field_0;
      --  Source Minor Loop Offset Enable
      SMLOE  : TCD_NBYTES_MLOFFYES0_SMLOE_Field :=
                MKL28Z7.DMA0.TCD_NBYTES_MLOFFYES0_SMLOE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TCD_NBYTES_MLOFFYES_Register use record
      NBYTES at 0 range 0 .. 9;
      MLOFF  at 0 range 10 .. 29;
      DMLOE  at 0 range 30 .. 30;
      SMLOE  at 0 range 31 .. 31;
   end record;

   subtype TCD_CITER_ELINKNO0_CITER_Field is MKL28Z7.UInt15;

   --  Enable channel-to-channel linking on minor-loop complete
   type TCD_CITER_ELINKNO0_ELINK_Field is
     (
      --  The channel-to-channel linking is disabled
      TCD_CITER_ELINKNO0_ELINK_Field_0,
      --  The channel-to-channel linking is enabled
      TCD_CITER_ELINKNO0_ELINK_Field_1)
     with Size => 1;
   for TCD_CITER_ELINKNO0_ELINK_Field use
     (TCD_CITER_ELINKNO0_ELINK_Field_0 => 0,
      TCD_CITER_ELINKNO0_ELINK_Field_1 => 1);

   --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking Disabled)
   type TCD_CITER_ELINKNO_Register is record
      --  Current Major Iteration Count
      CITER : TCD_CITER_ELINKNO0_CITER_Field := 16#0#;
      --  Enable channel-to-channel linking on minor-loop complete
      ELINK : TCD_CITER_ELINKNO0_ELINK_Field :=
               MKL28Z7.DMA0.TCD_CITER_ELINKNO0_ELINK_Field_0;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for TCD_CITER_ELINKNO_Register use record
      CITER at 0 range 0 .. 14;
      ELINK at 0 range 15 .. 15;
   end record;

   subtype TCD_CITER_ELINKYES0_CITER_Field is MKL28Z7.UInt9;
   subtype TCD_CITER_ELINKYES0_LINKCH_Field is MKL28Z7.UInt3;

   --  Enable channel-to-channel linking on minor-loop complete
   type TCD_CITER_ELINKYES0_ELINK_Field is
     (
      --  The channel-to-channel linking is disabled
      TCD_CITER_ELINKYES0_ELINK_Field_0,
      --  The channel-to-channel linking is enabled
      TCD_CITER_ELINKYES0_ELINK_Field_1)
     with Size => 1;
   for TCD_CITER_ELINKYES0_ELINK_Field use
     (TCD_CITER_ELINKYES0_ELINK_Field_0 => 0,
      TCD_CITER_ELINKYES0_ELINK_Field_1 => 1);

   --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking Enabled)
   type TCD_CITER_ELINKYES_Register is record
      --  Current Major Iteration Count
      CITER          : TCD_CITER_ELINKYES0_CITER_Field := 16#0#;
      --  Minor Loop Link Channel Number
      LINKCH         : TCD_CITER_ELINKYES0_LINKCH_Field := 16#0#;
      --  unspecified
      Reserved_12_14 : MKL28Z7.UInt3 := 16#0#;
      --  Enable channel-to-channel linking on minor-loop complete
      ELINK          : TCD_CITER_ELINKYES0_ELINK_Field :=
                        MKL28Z7.DMA0.TCD_CITER_ELINKYES0_ELINK_Field_0;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for TCD_CITER_ELINKYES_Register use record
      CITER          at 0 range 0 .. 8;
      LINKCH         at 0 range 9 .. 11;
      Reserved_12_14 at 0 range 12 .. 14;
      ELINK          at 0 range 15 .. 15;
   end record;

   --  Channel Start
   type TCD_CSR0_START_Field is
     (
      --  The channel is not explicitly started.
      TCD_CSR0_START_Field_0,
      --  The channel is explicitly started via a software initiated service
      --  request.
      TCD_CSR0_START_Field_1)
     with Size => 1;
   for TCD_CSR0_START_Field use
     (TCD_CSR0_START_Field_0 => 0,
      TCD_CSR0_START_Field_1 => 1);

   --  Enable an interrupt when major iteration count completes.
   type TCD_CSR0_INTMAJOR_Field is
     (
      --  The end-of-major loop interrupt is disabled.
      TCD_CSR0_INTMAJOR_Field_0,
      --  The end-of-major loop interrupt is enabled.
      TCD_CSR0_INTMAJOR_Field_1)
     with Size => 1;
   for TCD_CSR0_INTMAJOR_Field use
     (TCD_CSR0_INTMAJOR_Field_0 => 0,
      TCD_CSR0_INTMAJOR_Field_1 => 1);

   --  Enable an interrupt when major counter is half complete.
   type TCD_CSR0_INTHALF_Field is
     (
      --  The half-point interrupt is disabled.
      TCD_CSR0_INTHALF_Field_0,
      --  The half-point interrupt is enabled.
      TCD_CSR0_INTHALF_Field_1)
     with Size => 1;
   for TCD_CSR0_INTHALF_Field use
     (TCD_CSR0_INTHALF_Field_0 => 0,
      TCD_CSR0_INTHALF_Field_1 => 1);

   --  Disable Request
   type TCD_CSR0_DREQ_Field is
     (
      --  The channel's ERQ bit is not affected.
      TCD_CSR0_DREQ_Field_0,
      --  The channel's ERQ bit is cleared when the major loop is complete.
      TCD_CSR0_DREQ_Field_1)
     with Size => 1;
   for TCD_CSR0_DREQ_Field use
     (TCD_CSR0_DREQ_Field_0 => 0,
      TCD_CSR0_DREQ_Field_1 => 1);

   --  Enable Scatter/Gather Processing
   type TCD_CSR0_ESG_Field is
     (
      --  The current channel's TCD is normal format.
      TCD_CSR0_ESG_Field_0,
      --  The current channel's TCD specifies a scatter gather format. The
      --  DLASTSGA field provides a memory pointer to the next TCD to be loaded
      --  into this channel after the major loop completes its execution.
      TCD_CSR0_ESG_Field_1)
     with Size => 1;
   for TCD_CSR0_ESG_Field use
     (TCD_CSR0_ESG_Field_0 => 0,
      TCD_CSR0_ESG_Field_1 => 1);

   --  Enable channel-to-channel linking on major loop complete
   type TCD_CSR0_MAJORELINK_Field is
     (
      --  The channel-to-channel linking is disabled.
      TCD_CSR0_MAJORELINK_Field_0,
      --  The channel-to-channel linking is enabled.
      TCD_CSR0_MAJORELINK_Field_1)
     with Size => 1;
   for TCD_CSR0_MAJORELINK_Field use
     (TCD_CSR0_MAJORELINK_Field_0 => 0,
      TCD_CSR0_MAJORELINK_Field_1 => 1);

   subtype TCD_CSR0_ACTIVE_Field is MKL28Z7.Bit;
   subtype TCD_CSR0_DONE_Field is MKL28Z7.Bit;
   subtype TCD_CSR0_MAJORLINKCH_Field is MKL28Z7.UInt3;

   --  Bandwidth Control
   type TCD_CSR0_BWC_Field is
     (
      --  No eDMA engine stalls.
      TCD_CSR0_BWC_Field_00,
      --  eDMA engine stalls for 4 cycles after each R/W.
      TCD_CSR0_BWC_Field_10,
      --  eDMA engine stalls for 8 cycles after each R/W.
      TCD_CSR0_BWC_Field_11)
     with Size => 2;
   for TCD_CSR0_BWC_Field use
     (TCD_CSR0_BWC_Field_00 => 0,
      TCD_CSR0_BWC_Field_10 => 2,
      TCD_CSR0_BWC_Field_11 => 3);

   --  TCD Control and Status
   type TCD_CSR_Register is record
      --  Channel Start
      START          : TCD_CSR0_START_Field :=
                        MKL28Z7.DMA0.TCD_CSR0_START_Field_0;
      --  Enable an interrupt when major iteration count completes.
      INTMAJOR       : TCD_CSR0_INTMAJOR_Field :=
                        MKL28Z7.DMA0.TCD_CSR0_INTMAJOR_Field_0;
      --  Enable an interrupt when major counter is half complete.
      INTHALF        : TCD_CSR0_INTHALF_Field :=
                        MKL28Z7.DMA0.TCD_CSR0_INTHALF_Field_0;
      --  Disable Request
      DREQ           : TCD_CSR0_DREQ_Field :=
                        MKL28Z7.DMA0.TCD_CSR0_DREQ_Field_0;
      --  Enable Scatter/Gather Processing
      ESG            : TCD_CSR0_ESG_Field :=
                        MKL28Z7.DMA0.TCD_CSR0_ESG_Field_0;
      --  Enable channel-to-channel linking on major loop complete
      MAJORELINK     : TCD_CSR0_MAJORELINK_Field :=
                        MKL28Z7.DMA0.TCD_CSR0_MAJORELINK_Field_0;
      --  Read-only. Channel Active
      ACTIVE         : TCD_CSR0_ACTIVE_Field := 16#0#;
      --  Channel Done
      DONE           : TCD_CSR0_DONE_Field := 16#0#;
      --  Major Loop Link Channel Number
      MAJORLINKCH    : TCD_CSR0_MAJORLINKCH_Field := 16#0#;
      --  unspecified
      Reserved_11_13 : MKL28Z7.UInt3 := 16#0#;
      --  Bandwidth Control
      BWC            : TCD_CSR0_BWC_Field :=
                        MKL28Z7.DMA0.TCD_CSR0_BWC_Field_00;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for TCD_CSR_Register use record
      START          at 0 range 0 .. 0;
      INTMAJOR       at 0 range 1 .. 1;
      INTHALF        at 0 range 2 .. 2;
      DREQ           at 0 range 3 .. 3;
      ESG            at 0 range 4 .. 4;
      MAJORELINK     at 0 range 5 .. 5;
      ACTIVE         at 0 range 6 .. 6;
      DONE           at 0 range 7 .. 7;
      MAJORLINKCH    at 0 range 8 .. 10;
      Reserved_11_13 at 0 range 11 .. 13;
      BWC            at 0 range 14 .. 15;
   end record;

   subtype TCD_BITER_ELINKNO0_BITER_Field is MKL28Z7.UInt15;

   --  Enables channel-to-channel linking on minor loop complete
   type TCD_BITER_ELINKNO0_ELINK_Field is
     (
      --  The channel-to-channel linking is disabled
      TCD_BITER_ELINKNO0_ELINK_Field_0,
      --  The channel-to-channel linking is enabled
      TCD_BITER_ELINKNO0_ELINK_Field_1)
     with Size => 1;
   for TCD_BITER_ELINKNO0_ELINK_Field use
     (TCD_BITER_ELINKNO0_ELINK_Field_0 => 0,
      TCD_BITER_ELINKNO0_ELINK_Field_1 => 1);

   --  TCD Beginning Minor Loop Link, Major Loop Count (Channel Linking
   --  Disabled)
   type TCD_BITER_ELINKNO_Register is record
      --  Starting Major Iteration Count
      BITER : TCD_BITER_ELINKNO0_BITER_Field := 16#0#;
      --  Enables channel-to-channel linking on minor loop complete
      ELINK : TCD_BITER_ELINKNO0_ELINK_Field :=
               MKL28Z7.DMA0.TCD_BITER_ELINKNO0_ELINK_Field_0;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for TCD_BITER_ELINKNO_Register use record
      BITER at 0 range 0 .. 14;
      ELINK at 0 range 15 .. 15;
   end record;

   subtype TCD_BITER_ELINKYES0_BITER_Field is MKL28Z7.UInt9;
   subtype TCD_BITER_ELINKYES0_LINKCH_Field is MKL28Z7.UInt3;

   --  Enables channel-to-channel linking on minor loop complete
   type TCD_BITER_ELINKYES0_ELINK_Field is
     (
      --  The channel-to-channel linking is disabled
      TCD_BITER_ELINKYES0_ELINK_Field_0,
      --  The channel-to-channel linking is enabled
      TCD_BITER_ELINKYES0_ELINK_Field_1)
     with Size => 1;
   for TCD_BITER_ELINKYES0_ELINK_Field use
     (TCD_BITER_ELINKYES0_ELINK_Field_0 => 0,
      TCD_BITER_ELINKYES0_ELINK_Field_1 => 1);

   --  TCD Beginning Minor Loop Link, Major Loop Count (Channel Linking
   --  Enabled)
   type TCD_BITER_ELINKYES_Register is record
      --  Starting major iteration count
      BITER          : TCD_BITER_ELINKYES0_BITER_Field := 16#0#;
      --  Link Channel Number
      LINKCH         : TCD_BITER_ELINKYES0_LINKCH_Field := 16#0#;
      --  unspecified
      Reserved_12_14 : MKL28Z7.UInt3 := 16#0#;
      --  Enables channel-to-channel linking on minor loop complete
      ELINK          : TCD_BITER_ELINKYES0_ELINK_Field :=
                        MKL28Z7.DMA0.TCD_BITER_ELINKYES0_ELINK_Field_0;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for TCD_BITER_ELINKYES_Register use record
      BITER          at 0 range 0 .. 8;
      LINKCH         at 0 range 9 .. 11;
      Reserved_12_14 at 0 range 12 .. 14;
      ELINK          at 0 range 15 .. 15;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type DMA0_Disc is
     (
      No0,
      Offno0,
      Offyes0,
      Yes0,
      No1,
      Offno1,
      Offyes1,
      Yes1,
      No2,
      Offno2,
      Offyes2,
      Yes2,
      No3,
      Offno3,
      Offyes3,
      Yes3,
      No4,
      Offno4,
      Offyes4,
      Yes4,
      No5,
      Offno5,
      Offyes5,
      Yes5,
      No6,
      Offno6,
      Offyes6,
      Yes6,
      No7,
      Offno7,
      Offyes7,
      Yes7);

   --  Enhanced direct memory access controller
   type DMA0_Peripheral
     (Discriminent : DMA0_Disc := No0)
   is record
      --  Control Register
      CR                   : DMA0_CR_Register;
      --  Error Status Register
      ES                   : DMA0_ES_Register;
      --  Enable Request Register
      ERQ                  : DMA0_ERQ_Register;
      --  Enable Error Interrupt Register
      EEI                  : DMA0_EEI_Register;
      --  Clear Enable Error Interrupt Register
      CEEI                 : DMA0_CEEI_Register;
      --  Set Enable Error Interrupt Register
      SEEI                 : DMA0_SEEI_Register;
      --  Clear Enable Request Register
      CERQ                 : DMA0_CERQ_Register;
      --  Set Enable Request Register
      SERQ                 : DMA0_SERQ_Register;
      --  Clear DONE Status Bit Register
      CDNE                 : DMA0_CDNE_Register;
      --  Set START Bit Register
      SSRT                 : DMA0_SSRT_Register;
      --  Clear Error Register
      CERR                 : DMA0_CERR_Register;
      --  Clear Interrupt Request Register
      CINT                 : DMA0_CINT_Register;
      --  Interrupt Request Register
      INT                  : DMA0_INT_Register;
      --  Error Register
      ERR                  : DMA0_ERR_Register;
      --  Hardware Request Status Register
      HRS                  : DMA0_HRS_Register;
      --  Enable Asynchronous Request in Stop Register
      EARS                 : DMA0_EARS_Register;
      --  Channel n Priority Register
      DCHPRI               : DMA0_DCHPRI_Registers;
      --  TCD Source Address
      TCD_SADDR0           : MKL28Z7.Word;
      --  TCD Signed Source Address Offset
      TCD_SOFF0            : MKL28Z7.Short;
      --  TCD Transfer Attributes
      TCD_ATTR0            : TCD_ATTR_Register;
      --  TCD Last Source Address Adjustment
      TCD_SLAST0           : MKL28Z7.Word;
      --  TCD Destination Address
      TCD_DADDR0           : MKL28Z7.Word;
      --  TCD Signed Destination Address Offset
      TCD_DOFF0            : MKL28Z7.Short;
      --  TCD Last Destination Address Adjustment/Scatter Gather Address
      TCD_DLASTSGA0        : MKL28Z7.Word;
      --  TCD Control and Status
      TCD_CSR0             : TCD_CSR_Register;
      --  TCD Source Address
      TCD_SADDR1           : MKL28Z7.Word;
      --  TCD Signed Source Address Offset
      TCD_SOFF1            : MKL28Z7.Short;
      --  TCD Transfer Attributes
      TCD_ATTR1            : TCD_ATTR_Register;
      --  TCD Last Source Address Adjustment
      TCD_SLAST1           : MKL28Z7.Word;
      --  TCD Destination Address
      TCD_DADDR1           : MKL28Z7.Word;
      --  TCD Signed Destination Address Offset
      TCD_DOFF1            : MKL28Z7.Short;
      --  TCD Last Destination Address Adjustment/Scatter Gather Address
      TCD_DLASTSGA1        : MKL28Z7.Word;
      --  TCD Control and Status
      TCD_CSR1             : TCD_CSR_Register;
      --  TCD Source Address
      TCD_SADDR2           : MKL28Z7.Word;
      --  TCD Signed Source Address Offset
      TCD_SOFF2            : MKL28Z7.Short;
      --  TCD Transfer Attributes
      TCD_ATTR2            : TCD_ATTR_Register;
      --  TCD Last Source Address Adjustment
      TCD_SLAST2           : MKL28Z7.Word;
      --  TCD Destination Address
      TCD_DADDR2           : MKL28Z7.Word;
      --  TCD Signed Destination Address Offset
      TCD_DOFF2            : MKL28Z7.Short;
      --  TCD Last Destination Address Adjustment/Scatter Gather Address
      TCD_DLASTSGA2        : MKL28Z7.Word;
      --  TCD Control and Status
      TCD_CSR2             : TCD_CSR_Register;
      --  TCD Source Address
      TCD_SADDR3           : MKL28Z7.Word;
      --  TCD Signed Source Address Offset
      TCD_SOFF3            : MKL28Z7.Short;
      --  TCD Transfer Attributes
      TCD_ATTR3            : TCD_ATTR_Register;
      --  TCD Last Source Address Adjustment
      TCD_SLAST3           : MKL28Z7.Word;
      --  TCD Destination Address
      TCD_DADDR3           : MKL28Z7.Word;
      --  TCD Signed Destination Address Offset
      TCD_DOFF3            : MKL28Z7.Short;
      --  TCD Last Destination Address Adjustment/Scatter Gather Address
      TCD_DLASTSGA3        : MKL28Z7.Word;
      --  TCD Control and Status
      TCD_CSR3             : TCD_CSR_Register;
      --  TCD Source Address
      TCD_SADDR4           : MKL28Z7.Word;
      --  TCD Signed Source Address Offset
      TCD_SOFF4            : MKL28Z7.Short;
      --  TCD Transfer Attributes
      TCD_ATTR4            : TCD_ATTR_Register;
      --  TCD Last Source Address Adjustment
      TCD_SLAST4           : MKL28Z7.Word;
      --  TCD Destination Address
      TCD_DADDR4           : MKL28Z7.Word;
      --  TCD Signed Destination Address Offset
      TCD_DOFF4            : MKL28Z7.Short;
      --  TCD Last Destination Address Adjustment/Scatter Gather Address
      TCD_DLASTSGA4        : MKL28Z7.Word;
      --  TCD Control and Status
      TCD_CSR4             : TCD_CSR_Register;
      --  TCD Source Address
      TCD_SADDR5           : MKL28Z7.Word;
      --  TCD Signed Source Address Offset
      TCD_SOFF5            : MKL28Z7.Short;
      --  TCD Transfer Attributes
      TCD_ATTR5            : TCD_ATTR_Register;
      --  TCD Last Source Address Adjustment
      TCD_SLAST5           : MKL28Z7.Word;
      --  TCD Destination Address
      TCD_DADDR5           : MKL28Z7.Word;
      --  TCD Signed Destination Address Offset
      TCD_DOFF5            : MKL28Z7.Short;
      --  TCD Last Destination Address Adjustment/Scatter Gather Address
      TCD_DLASTSGA5        : MKL28Z7.Word;
      --  TCD Control and Status
      TCD_CSR5             : TCD_CSR_Register;
      --  TCD Source Address
      TCD_SADDR6           : MKL28Z7.Word;
      --  TCD Signed Source Address Offset
      TCD_SOFF6            : MKL28Z7.Short;
      --  TCD Transfer Attributes
      TCD_ATTR6            : TCD_ATTR_Register;
      --  TCD Last Source Address Adjustment
      TCD_SLAST6           : MKL28Z7.Word;
      --  TCD Destination Address
      TCD_DADDR6           : MKL28Z7.Word;
      --  TCD Signed Destination Address Offset
      TCD_DOFF6            : MKL28Z7.Short;
      --  TCD Last Destination Address Adjustment/Scatter Gather Address
      TCD_DLASTSGA6        : MKL28Z7.Word;
      --  TCD Control and Status
      TCD_CSR6             : TCD_CSR_Register;
      --  TCD Source Address
      TCD_SADDR7           : MKL28Z7.Word;
      --  TCD Signed Source Address Offset
      TCD_SOFF7            : MKL28Z7.Short;
      --  TCD Transfer Attributes
      TCD_ATTR7            : TCD_ATTR_Register;
      --  TCD Last Source Address Adjustment
      TCD_SLAST7           : MKL28Z7.Word;
      --  TCD Destination Address
      TCD_DADDR7           : MKL28Z7.Word;
      --  TCD Signed Destination Address Offset
      TCD_DOFF7            : MKL28Z7.Short;
      --  TCD Last Destination Address Adjustment/Scatter Gather Address
      TCD_DLASTSGA7        : MKL28Z7.Word;
      --  TCD Control and Status
      TCD_CSR7             : TCD_CSR_Register;
      case Discriminent is
         when No0 =>
            --  TCD Minor Byte Count (Minor Loop Mapping Disabled)
            TCD_NBYTES_MLNO0 : MKL28Z7.Word;
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Disabled)
            TCD_CITER_ELINKNO0 : TCD_CITER_ELINKNO_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Disabled)
            TCD_BITER_ELINKNO0 : TCD_BITER_ELINKNO_Register;
         when Offno0 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and
            --  Offset Disabled)
            TCD_NBYTES_MLOFFNO0 : TCD_NBYTES_MLOFFNO_Register;
         when Offyes0 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset
            --  Enabled)
            TCD_NBYTES_MLOFFYES0 : TCD_NBYTES_MLOFFYES_Register;
         when Yes0 =>
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Enabled)
            TCD_CITER_ELINKYES0 : TCD_CITER_ELINKYES_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Enabled)
            TCD_BITER_ELINKYES0 : TCD_BITER_ELINKYES_Register;
         when No1 =>
            --  TCD Minor Byte Count (Minor Loop Mapping Disabled)
            TCD_NBYTES_MLNO1 : MKL28Z7.Word;
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Disabled)
            TCD_CITER_ELINKNO1 : TCD_CITER_ELINKNO_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Disabled)
            TCD_BITER_ELINKNO1 : TCD_BITER_ELINKNO_Register;
         when Offno1 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and
            --  Offset Disabled)
            TCD_NBYTES_MLOFFNO1 : TCD_NBYTES_MLOFFNO_Register;
         when Offyes1 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset
            --  Enabled)
            TCD_NBYTES_MLOFFYES1 : TCD_NBYTES_MLOFFYES_Register;
         when Yes1 =>
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Enabled)
            TCD_CITER_ELINKYES1 : TCD_CITER_ELINKYES_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Enabled)
            TCD_BITER_ELINKYES1 : TCD_BITER_ELINKYES_Register;
         when No2 =>
            --  TCD Minor Byte Count (Minor Loop Mapping Disabled)
            TCD_NBYTES_MLNO2 : MKL28Z7.Word;
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Disabled)
            TCD_CITER_ELINKNO2 : TCD_CITER_ELINKNO_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Disabled)
            TCD_BITER_ELINKNO2 : TCD_BITER_ELINKNO_Register;
         when Offno2 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and
            --  Offset Disabled)
            TCD_NBYTES_MLOFFNO2 : TCD_NBYTES_MLOFFNO_Register;
         when Offyes2 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset
            --  Enabled)
            TCD_NBYTES_MLOFFYES2 : TCD_NBYTES_MLOFFYES_Register;
         when Yes2 =>
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Enabled)
            TCD_CITER_ELINKYES2 : TCD_CITER_ELINKYES_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Enabled)
            TCD_BITER_ELINKYES2 : TCD_BITER_ELINKYES_Register;
         when No3 =>
            --  TCD Minor Byte Count (Minor Loop Mapping Disabled)
            TCD_NBYTES_MLNO3 : MKL28Z7.Word;
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Disabled)
            TCD_CITER_ELINKNO3 : TCD_CITER_ELINKNO_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Disabled)
            TCD_BITER_ELINKNO3 : TCD_BITER_ELINKNO_Register;
         when Offno3 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and
            --  Offset Disabled)
            TCD_NBYTES_MLOFFNO3 : TCD_NBYTES_MLOFFNO_Register;
         when Offyes3 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset
            --  Enabled)
            TCD_NBYTES_MLOFFYES3 : TCD_NBYTES_MLOFFYES_Register;
         when Yes3 =>
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Enabled)
            TCD_CITER_ELINKYES3 : TCD_CITER_ELINKYES_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Enabled)
            TCD_BITER_ELINKYES3 : TCD_BITER_ELINKYES_Register;
         when No4 =>
            --  TCD Minor Byte Count (Minor Loop Mapping Disabled)
            TCD_NBYTES_MLNO4 : MKL28Z7.Word;
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Disabled)
            TCD_CITER_ELINKNO4 : TCD_CITER_ELINKNO_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Disabled)
            TCD_BITER_ELINKNO4 : TCD_BITER_ELINKNO_Register;
         when Offno4 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and
            --  Offset Disabled)
            TCD_NBYTES_MLOFFNO4 : TCD_NBYTES_MLOFFNO_Register;
         when Offyes4 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset
            --  Enabled)
            TCD_NBYTES_MLOFFYES4 : TCD_NBYTES_MLOFFYES_Register;
         when Yes4 =>
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Enabled)
            TCD_CITER_ELINKYES4 : TCD_CITER_ELINKYES_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Enabled)
            TCD_BITER_ELINKYES4 : TCD_BITER_ELINKYES_Register;
         when No5 =>
            --  TCD Minor Byte Count (Minor Loop Mapping Disabled)
            TCD_NBYTES_MLNO5 : MKL28Z7.Word;
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Disabled)
            TCD_CITER_ELINKNO5 : TCD_CITER_ELINKNO_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Disabled)
            TCD_BITER_ELINKNO5 : TCD_BITER_ELINKNO_Register;
         when Offno5 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and
            --  Offset Disabled)
            TCD_NBYTES_MLOFFNO5 : TCD_NBYTES_MLOFFNO_Register;
         when Offyes5 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset
            --  Enabled)
            TCD_NBYTES_MLOFFYES5 : TCD_NBYTES_MLOFFYES_Register;
         when Yes5 =>
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Enabled)
            TCD_CITER_ELINKYES5 : TCD_CITER_ELINKYES_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Enabled)
            TCD_BITER_ELINKYES5 : TCD_BITER_ELINKYES_Register;
         when No6 =>
            --  TCD Minor Byte Count (Minor Loop Mapping Disabled)
            TCD_NBYTES_MLNO6 : MKL28Z7.Word;
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Disabled)
            TCD_CITER_ELINKNO6 : TCD_CITER_ELINKNO_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Disabled)
            TCD_BITER_ELINKNO6 : TCD_BITER_ELINKNO_Register;
         when Offno6 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and
            --  Offset Disabled)
            TCD_NBYTES_MLOFFNO6 : TCD_NBYTES_MLOFFNO_Register;
         when Offyes6 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset
            --  Enabled)
            TCD_NBYTES_MLOFFYES6 : TCD_NBYTES_MLOFFYES_Register;
         when Yes6 =>
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Enabled)
            TCD_CITER_ELINKYES6 : TCD_CITER_ELINKYES_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Enabled)
            TCD_BITER_ELINKYES6 : TCD_BITER_ELINKYES_Register;
         when No7 =>
            --  TCD Minor Byte Count (Minor Loop Mapping Disabled)
            TCD_NBYTES_MLNO7 : MKL28Z7.Word;
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Disabled)
            TCD_CITER_ELINKNO7 : TCD_CITER_ELINKNO_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Disabled)
            TCD_BITER_ELINKNO7 : TCD_BITER_ELINKNO_Register;
         when Offno7 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and
            --  Offset Disabled)
            TCD_NBYTES_MLOFFNO7 : TCD_NBYTES_MLOFFNO_Register;
         when Offyes7 =>
            --  TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset
            --  Enabled)
            TCD_NBYTES_MLOFFYES7 : TCD_NBYTES_MLOFFYES_Register;
         when Yes7 =>
            --  TCD Current Minor Loop Link, Major Loop Count (Channel Linking
            --  Enabled)
            TCD_CITER_ELINKYES7 : TCD_CITER_ELINKYES_Register;
            --  TCD Beginning Minor Loop Link, Major Loop Count (Channel
            --  Linking Enabled)
            TCD_BITER_ELINKYES7 : TCD_BITER_ELINKYES_Register;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for DMA0_Peripheral use record
      CR                   at 0 range 0 .. 31;
      ES                   at 4 range 0 .. 31;
      ERQ                  at 12 range 0 .. 31;
      EEI                  at 20 range 0 .. 31;
      CEEI                 at 24 range 0 .. 7;
      SEEI                 at 25 range 0 .. 7;
      CERQ                 at 26 range 0 .. 7;
      SERQ                 at 27 range 0 .. 7;
      CDNE                 at 28 range 0 .. 7;
      SSRT                 at 29 range 0 .. 7;
      CERR                 at 30 range 0 .. 7;
      CINT                 at 31 range 0 .. 7;
      INT                  at 36 range 0 .. 31;
      ERR                  at 44 range 0 .. 31;
      HRS                  at 52 range 0 .. 31;
      EARS                 at 68 range 0 .. 31;
      DCHPRI               at 256 range 0 .. 63;
      TCD_SADDR0           at 4096 range 0 .. 31;
      TCD_SOFF0            at 4100 range 0 .. 15;
      TCD_ATTR0            at 4102 range 0 .. 15;
      TCD_SLAST0           at 4108 range 0 .. 31;
      TCD_DADDR0           at 4112 range 0 .. 31;
      TCD_DOFF0            at 4116 range 0 .. 15;
      TCD_DLASTSGA0        at 4120 range 0 .. 31;
      TCD_CSR0             at 4124 range 0 .. 15;
      TCD_SADDR1           at 4128 range 0 .. 31;
      TCD_SOFF1            at 4132 range 0 .. 15;
      TCD_ATTR1            at 4134 range 0 .. 15;
      TCD_SLAST1           at 4140 range 0 .. 31;
      TCD_DADDR1           at 4144 range 0 .. 31;
      TCD_DOFF1            at 4148 range 0 .. 15;
      TCD_DLASTSGA1        at 4152 range 0 .. 31;
      TCD_CSR1             at 4156 range 0 .. 15;
      TCD_SADDR2           at 4160 range 0 .. 31;
      TCD_SOFF2            at 4164 range 0 .. 15;
      TCD_ATTR2            at 4166 range 0 .. 15;
      TCD_SLAST2           at 4172 range 0 .. 31;
      TCD_DADDR2           at 4176 range 0 .. 31;
      TCD_DOFF2            at 4180 range 0 .. 15;
      TCD_DLASTSGA2        at 4184 range 0 .. 31;
      TCD_CSR2             at 4188 range 0 .. 15;
      TCD_SADDR3           at 4192 range 0 .. 31;
      TCD_SOFF3            at 4196 range 0 .. 15;
      TCD_ATTR3            at 4198 range 0 .. 15;
      TCD_SLAST3           at 4204 range 0 .. 31;
      TCD_DADDR3           at 4208 range 0 .. 31;
      TCD_DOFF3            at 4212 range 0 .. 15;
      TCD_DLASTSGA3        at 4216 range 0 .. 31;
      TCD_CSR3             at 4220 range 0 .. 15;
      TCD_SADDR4           at 4224 range 0 .. 31;
      TCD_SOFF4            at 4228 range 0 .. 15;
      TCD_ATTR4            at 4230 range 0 .. 15;
      TCD_SLAST4           at 4236 range 0 .. 31;
      TCD_DADDR4           at 4240 range 0 .. 31;
      TCD_DOFF4            at 4244 range 0 .. 15;
      TCD_DLASTSGA4        at 4248 range 0 .. 31;
      TCD_CSR4             at 4252 range 0 .. 15;
      TCD_SADDR5           at 4256 range 0 .. 31;
      TCD_SOFF5            at 4260 range 0 .. 15;
      TCD_ATTR5            at 4262 range 0 .. 15;
      TCD_SLAST5           at 4268 range 0 .. 31;
      TCD_DADDR5           at 4272 range 0 .. 31;
      TCD_DOFF5            at 4276 range 0 .. 15;
      TCD_DLASTSGA5        at 4280 range 0 .. 31;
      TCD_CSR5             at 4284 range 0 .. 15;
      TCD_SADDR6           at 4288 range 0 .. 31;
      TCD_SOFF6            at 4292 range 0 .. 15;
      TCD_ATTR6            at 4294 range 0 .. 15;
      TCD_SLAST6           at 4300 range 0 .. 31;
      TCD_DADDR6           at 4304 range 0 .. 31;
      TCD_DOFF6            at 4308 range 0 .. 15;
      TCD_DLASTSGA6        at 4312 range 0 .. 31;
      TCD_CSR6             at 4316 range 0 .. 15;
      TCD_SADDR7           at 4320 range 0 .. 31;
      TCD_SOFF7            at 4324 range 0 .. 15;
      TCD_ATTR7            at 4326 range 0 .. 15;
      TCD_SLAST7           at 4332 range 0 .. 31;
      TCD_DADDR7           at 4336 range 0 .. 31;
      TCD_DOFF7            at 4340 range 0 .. 15;
      TCD_DLASTSGA7        at 4344 range 0 .. 31;
      TCD_CSR7             at 4348 range 0 .. 15;
      TCD_NBYTES_MLNO0     at 4104 range 0 .. 31;
      TCD_CITER_ELINKNO0   at 4118 range 0 .. 15;
      TCD_BITER_ELINKNO0   at 4126 range 0 .. 15;
      TCD_NBYTES_MLOFFNO0  at 4104 range 0 .. 31;
      TCD_NBYTES_MLOFFYES0 at 4104 range 0 .. 31;
      TCD_CITER_ELINKYES0  at 4118 range 0 .. 15;
      TCD_BITER_ELINKYES0  at 4126 range 0 .. 15;
      TCD_NBYTES_MLNO1     at 4136 range 0 .. 31;
      TCD_CITER_ELINKNO1   at 4150 range 0 .. 15;
      TCD_BITER_ELINKNO1   at 4158 range 0 .. 15;
      TCD_NBYTES_MLOFFNO1  at 4136 range 0 .. 31;
      TCD_NBYTES_MLOFFYES1 at 4136 range 0 .. 31;
      TCD_CITER_ELINKYES1  at 4150 range 0 .. 15;
      TCD_BITER_ELINKYES1  at 4158 range 0 .. 15;
      TCD_NBYTES_MLNO2     at 4168 range 0 .. 31;
      TCD_CITER_ELINKNO2   at 4182 range 0 .. 15;
      TCD_BITER_ELINKNO2   at 4190 range 0 .. 15;
      TCD_NBYTES_MLOFFNO2  at 4168 range 0 .. 31;
      TCD_NBYTES_MLOFFYES2 at 4168 range 0 .. 31;
      TCD_CITER_ELINKYES2  at 4182 range 0 .. 15;
      TCD_BITER_ELINKYES2  at 4190 range 0 .. 15;
      TCD_NBYTES_MLNO3     at 4200 range 0 .. 31;
      TCD_CITER_ELINKNO3   at 4214 range 0 .. 15;
      TCD_BITER_ELINKNO3   at 4222 range 0 .. 15;
      TCD_NBYTES_MLOFFNO3  at 4200 range 0 .. 31;
      TCD_NBYTES_MLOFFYES3 at 4200 range 0 .. 31;
      TCD_CITER_ELINKYES3  at 4214 range 0 .. 15;
      TCD_BITER_ELINKYES3  at 4222 range 0 .. 15;
      TCD_NBYTES_MLNO4     at 4232 range 0 .. 31;
      TCD_CITER_ELINKNO4   at 4246 range 0 .. 15;
      TCD_BITER_ELINKNO4   at 4254 range 0 .. 15;
      TCD_NBYTES_MLOFFNO4  at 4232 range 0 .. 31;
      TCD_NBYTES_MLOFFYES4 at 4232 range 0 .. 31;
      TCD_CITER_ELINKYES4  at 4246 range 0 .. 15;
      TCD_BITER_ELINKYES4  at 4254 range 0 .. 15;
      TCD_NBYTES_MLNO5     at 4264 range 0 .. 31;
      TCD_CITER_ELINKNO5   at 4278 range 0 .. 15;
      TCD_BITER_ELINKNO5   at 4286 range 0 .. 15;
      TCD_NBYTES_MLOFFNO5  at 4264 range 0 .. 31;
      TCD_NBYTES_MLOFFYES5 at 4264 range 0 .. 31;
      TCD_CITER_ELINKYES5  at 4278 range 0 .. 15;
      TCD_BITER_ELINKYES5  at 4286 range 0 .. 15;
      TCD_NBYTES_MLNO6     at 4296 range 0 .. 31;
      TCD_CITER_ELINKNO6   at 4310 range 0 .. 15;
      TCD_BITER_ELINKNO6   at 4318 range 0 .. 15;
      TCD_NBYTES_MLOFFNO6  at 4296 range 0 .. 31;
      TCD_NBYTES_MLOFFYES6 at 4296 range 0 .. 31;
      TCD_CITER_ELINKYES6  at 4310 range 0 .. 15;
      TCD_BITER_ELINKYES6  at 4318 range 0 .. 15;
      TCD_NBYTES_MLNO7     at 4328 range 0 .. 31;
      TCD_CITER_ELINKNO7   at 4342 range 0 .. 15;
      TCD_BITER_ELINKNO7   at 4350 range 0 .. 15;
      TCD_NBYTES_MLOFFNO7  at 4328 range 0 .. 31;
      TCD_NBYTES_MLOFFYES7 at 4328 range 0 .. 31;
      TCD_CITER_ELINKYES7  at 4342 range 0 .. 15;
      TCD_BITER_ELINKYES7  at 4350 range 0 .. 15;
   end record;

   --  Enhanced direct memory access controller
   DMA0_Periph : aliased DMA0_Peripheral
     with Import, Address => DMA0_Base;

end MKL28Z7.DMA0;
