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

--  This spec has been automatically generated from MK64F12.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

--  Flash Memory Interface
package MK64F12.FTFE is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   subtype FSTAT_MGSTAT0_Field is MK64F12.Bit;

   --  Flash Protection Violation Flag
   type FSTAT_FPVIOL_Field is
     (
      --  No protection violation detected
      FSTAT_FPVIOL_Field_0,
      --  Protection violation detected
      FSTAT_FPVIOL_Field_1)
     with Size => 1;
   for FSTAT_FPVIOL_Field use
     (FSTAT_FPVIOL_Field_0 => 0,
      FSTAT_FPVIOL_Field_1 => 1);

   --  Flash Access Error Flag
   type FSTAT_ACCERR_Field is
     (
      --  No access error detected
      FSTAT_ACCERR_Field_0,
      --  Access error detected
      FSTAT_ACCERR_Field_1)
     with Size => 1;
   for FSTAT_ACCERR_Field use
     (FSTAT_ACCERR_Field_0 => 0,
      FSTAT_ACCERR_Field_1 => 1);

   --  FTFE Read Collision Error Flag
   type FSTAT_RDCOLERR_Field is
     (
      --  No collision error detected
      FSTAT_RDCOLERR_Field_0,
      --  Collision error detected
      FSTAT_RDCOLERR_Field_1)
     with Size => 1;
   for FSTAT_RDCOLERR_Field use
     (FSTAT_RDCOLERR_Field_0 => 0,
      FSTAT_RDCOLERR_Field_1 => 1);

   --  Command Complete Interrupt Flag
   type FSTAT_CCIF_Field is
     (
      --  FTFE command or EEPROM file system operation in progress
      FSTAT_CCIF_Field_0,
      --  FTFE command or EEPROM file system operation has completed
      FSTAT_CCIF_Field_1)
     with Size => 1;
   for FSTAT_CCIF_Field use
     (FSTAT_CCIF_Field_0 => 0,
      FSTAT_CCIF_Field_1 => 1);

   --  Flash Status Register
   type FTFE_FSTAT_Register is record
      --  Read-only. Memory Controller Command Completion Status Flag
      MGSTAT0      : FSTAT_MGSTAT0_Field := 16#0#;
      --  unspecified
      Reserved_1_3 : MK64F12.UInt3 := 16#0#;
      --  Flash Protection Violation Flag
      FPVIOL       : FSTAT_FPVIOL_Field := MK64F12.FTFE.FSTAT_FPVIOL_Field_0;
      --  Flash Access Error Flag
      ACCERR       : FSTAT_ACCERR_Field := MK64F12.FTFE.FSTAT_ACCERR_Field_0;
      --  FTFE Read Collision Error Flag
      RDCOLERR     : FSTAT_RDCOLERR_Field :=
                      MK64F12.FTFE.FSTAT_RDCOLERR_Field_0;
      --  Command Complete Interrupt Flag
      CCIF         : FSTAT_CCIF_Field := MK64F12.FTFE.FSTAT_CCIF_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for FTFE_FSTAT_Register use record
      MGSTAT0      at 0 range 0 .. 0;
      Reserved_1_3 at 0 range 1 .. 3;
      FPVIOL       at 0 range 4 .. 4;
      ACCERR       at 0 range 5 .. 5;
      RDCOLERR     at 0 range 6 .. 6;
      CCIF         at 0 range 7 .. 7;
   end record;

   --  For devices with FlexNVM: This flag indicates if the EEPROM backup data
   --  has been copied to the FlexRAM and is therefore available for read
   --  access
   type FCNFG_EEERDY_Field is
     (
      --  For devices with FlexNVM: FlexRAM is not available for EEPROM
      --  operation.
      FCNFG_EEERDY_Field_0,
      --  For devices with FlexNVM: FlexRAM is available for EEPROM operations
      --  where: reads from the FlexRAM return data previously written to the
      --  FlexRAM in EEPROM mode and writes launch an EEPROM operation to store
      --  the written data in the FlexRAM and EEPROM backup.
      FCNFG_EEERDY_Field_1)
     with Size => 1;
   for FCNFG_EEERDY_Field use
     (FCNFG_EEERDY_Field_0 => 0,
      FCNFG_EEERDY_Field_1 => 1);

   --  RAM Ready
   type FCNFG_RAMRDY_Field is
     (
      --  For devices with FlexNVM: FlexRAM is not available for traditional
      --  RAM access. For devices without FlexNVM: Programming acceleration RAM
      --  is not available.
      FCNFG_RAMRDY_Field_0,
      --  For devices with FlexNVM: FlexRAM is available as traditional RAM
      --  only; writes to the FlexRAM do not trigger EEPROM operations. For
      --  devices without FlexNVM: Programming acceleration RAM is available.
      FCNFG_RAMRDY_Field_1)
     with Size => 1;
   for FCNFG_RAMRDY_Field use
     (FCNFG_RAMRDY_Field_0 => 0,
      FCNFG_RAMRDY_Field_1 => 1);

   --  FTFE configuration
   type FCNFG_PFLSH_Field is
     (
      --  For devices with FlexNVM: FTFE configuration supports two program
      --  flash blocks and two FlexNVM blocks For devices with program flash
      --  only: Reserved
      FCNFG_PFLSH_Field_0,
      --  For devices with FlexNVM: Reserved For devices with program flash
      --  only: FTFE configuration supports four program flash blocks
      FCNFG_PFLSH_Field_1)
     with Size => 1;
   for FCNFG_PFLSH_Field use
     (FCNFG_PFLSH_Field_0 => 0,
      FCNFG_PFLSH_Field_1 => 1);

   --  Swap
   type FCNFG_SWAP_Field is
     (
      --  For devices with FlexNVM: Program flash 0 block is located at
      --  relative address 0x0000 For devices with program flash only: Program
      --  flash 0 block is located at relative address 0x0000
      FCNFG_SWAP_Field_0,
      --  For devices with FlexNVM: Reserved For devices with program flash
      --  only: Program flash 1 block is located at relative address 0x0000
      FCNFG_SWAP_Field_1)
     with Size => 1;
   for FCNFG_SWAP_Field use
     (FCNFG_SWAP_Field_0 => 0,
      FCNFG_SWAP_Field_1 => 1);

   --  Erase Suspend
   type FCNFG_ERSSUSP_Field is
     (
      --  No suspend requested
      FCNFG_ERSSUSP_Field_0,
      --  Suspend the current Erase Flash Sector command execution.
      FCNFG_ERSSUSP_Field_1)
     with Size => 1;
   for FCNFG_ERSSUSP_Field use
     (FCNFG_ERSSUSP_Field_0 => 0,
      FCNFG_ERSSUSP_Field_1 => 1);

   --  Erase All Request
   type FCNFG_ERSAREQ_Field is
     (
      --  No request or request complete
      FCNFG_ERSAREQ_Field_0,
      --  Request to: run the Erase All Blocks command, verify the erased
      --  state, program the security byte in the Flash Configuration Field to
      --  the unsecure state, and release MCU security by setting the FSEC[SEC]
      --  field to the unsecure state.
      FCNFG_ERSAREQ_Field_1)
     with Size => 1;
   for FCNFG_ERSAREQ_Field use
     (FCNFG_ERSAREQ_Field_0 => 0,
      FCNFG_ERSAREQ_Field_1 => 1);

   --  Read Collision Error Interrupt Enable
   type FCNFG_RDCOLLIE_Field is
     (
      --  Read collision error interrupt disabled
      FCNFG_RDCOLLIE_Field_0,
      --  Read collision error interrupt enabled. An interrupt request is
      --  generated whenever an FTFE read collision error is detected (see the
      --  description of FSTAT[RDCOLERR]).
      FCNFG_RDCOLLIE_Field_1)
     with Size => 1;
   for FCNFG_RDCOLLIE_Field use
     (FCNFG_RDCOLLIE_Field_0 => 0,
      FCNFG_RDCOLLIE_Field_1 => 1);

   --  Command Complete Interrupt Enable
   type FCNFG_CCIE_Field is
     (
      --  Command complete interrupt disabled
      FCNFG_CCIE_Field_0,
      --  Command complete interrupt enabled. An interrupt request is generated
      --  whenever the FSTAT[CCIF] flag is set.
      FCNFG_CCIE_Field_1)
     with Size => 1;
   for FCNFG_CCIE_Field use
     (FCNFG_CCIE_Field_0 => 0,
      FCNFG_CCIE_Field_1 => 1);

   --  Flash Configuration Register
   type FTFE_FCNFG_Register is record
      --  Read-only. For devices with FlexNVM: This flag indicates if the
      --  EEPROM backup data has been copied to the FlexRAM and is therefore
      --  available for read access
      EEERDY   : FCNFG_EEERDY_Field := MK64F12.FTFE.FCNFG_EEERDY_Field_0;
      --  Read-only. RAM Ready
      RAMRDY   : FCNFG_RAMRDY_Field := MK64F12.FTFE.FCNFG_RAMRDY_Field_0;
      --  Read-only. FTFE configuration
      PFLSH    : FCNFG_PFLSH_Field := MK64F12.FTFE.FCNFG_PFLSH_Field_0;
      --  Read-only. Swap
      SWAP     : FCNFG_SWAP_Field := MK64F12.FTFE.FCNFG_SWAP_Field_0;
      --  Erase Suspend
      ERSSUSP  : FCNFG_ERSSUSP_Field := MK64F12.FTFE.FCNFG_ERSSUSP_Field_0;
      --  Read-only. Erase All Request
      ERSAREQ  : FCNFG_ERSAREQ_Field := MK64F12.FTFE.FCNFG_ERSAREQ_Field_0;
      --  Read Collision Error Interrupt Enable
      RDCOLLIE : FCNFG_RDCOLLIE_Field := MK64F12.FTFE.FCNFG_RDCOLLIE_Field_0;
      --  Command Complete Interrupt Enable
      CCIE     : FCNFG_CCIE_Field := MK64F12.FTFE.FCNFG_CCIE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for FTFE_FCNFG_Register use record
      EEERDY   at 0 range 0 .. 0;
      RAMRDY   at 0 range 1 .. 1;
      PFLSH    at 0 range 2 .. 2;
      SWAP     at 0 range 3 .. 3;
      ERSSUSP  at 0 range 4 .. 4;
      ERSAREQ  at 0 range 5 .. 5;
      RDCOLLIE at 0 range 6 .. 6;
      CCIE     at 0 range 7 .. 7;
   end record;

   --  Flash Security
   type FSEC_SEC_Field is
     (
      --  MCU security status is secure
      FSEC_SEC_Field_00,
      --  MCU security status is secure
      FSEC_SEC_Field_01,
      --  MCU security status is unsecure (The standard shipping condition of
      --  the FTFE is unsecure.)
      FSEC_SEC_Field_10,
      --  MCU security status is secure
      FSEC_SEC_Field_11)
     with Size => 2;
   for FSEC_SEC_Field use
     (FSEC_SEC_Field_00 => 0,
      FSEC_SEC_Field_01 => 1,
      FSEC_SEC_Field_10 => 2,
      FSEC_SEC_Field_11 => 3);

   --  Freescale Failure Analysis Access Code
   type FSEC_FSLACC_Field is
     (
      --  Freescale factory access granted
      FSEC_FSLACC_Field_00,
      --  Freescale factory access denied
      FSEC_FSLACC_Field_01,
      --  Freescale factory access denied
      FSEC_FSLACC_Field_10,
      --  Freescale factory access granted
      FSEC_FSLACC_Field_11)
     with Size => 2;
   for FSEC_FSLACC_Field use
     (FSEC_FSLACC_Field_00 => 0,
      FSEC_FSLACC_Field_01 => 1,
      FSEC_FSLACC_Field_10 => 2,
      FSEC_FSLACC_Field_11 => 3);

   --  Mass Erase Enable Bits
   type FSEC_MEEN_Field is
     (
      --  Mass erase is enabled
      FSEC_MEEN_Field_00,
      --  Mass erase is enabled
      FSEC_MEEN_Field_01,
      --  Mass erase is disabled
      FSEC_MEEN_Field_10,
      --  Mass erase is enabled
      FSEC_MEEN_Field_11)
     with Size => 2;
   for FSEC_MEEN_Field use
     (FSEC_MEEN_Field_00 => 0,
      FSEC_MEEN_Field_01 => 1,
      FSEC_MEEN_Field_10 => 2,
      FSEC_MEEN_Field_11 => 3);

   --  Backdoor Key Security Enable
   type FSEC_KEYEN_Field is
     (
      --  Backdoor key access disabled
      FSEC_KEYEN_Field_00,
      --  Backdoor key access disabled (preferred KEYEN state to disable
      --  backdoor key access)
      FSEC_KEYEN_Field_01,
      --  Backdoor key access enabled
      FSEC_KEYEN_Field_10,
      --  Backdoor key access disabled
      FSEC_KEYEN_Field_11)
     with Size => 2;
   for FSEC_KEYEN_Field use
     (FSEC_KEYEN_Field_00 => 0,
      FSEC_KEYEN_Field_01 => 1,
      FSEC_KEYEN_Field_10 => 2,
      FSEC_KEYEN_Field_11 => 3);

   --  Flash Security Register
   type FTFE_FSEC_Register is record
      --  Read-only. Flash Security
      SEC    : FSEC_SEC_Field;
      --  Read-only. Freescale Failure Analysis Access Code
      FSLACC : FSEC_FSLACC_Field;
      --  Read-only. Mass Erase Enable Bits
      MEEN   : FSEC_MEEN_Field;
      --  Read-only. Backdoor Key Security Enable
      KEYEN  : FSEC_KEYEN_Field;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for FTFE_FSEC_Register use record
      SEC    at 0 range 0 .. 1;
      FSLACC at 0 range 2 .. 3;
      MEEN   at 0 range 4 .. 5;
      KEYEN  at 0 range 6 .. 7;
   end record;

   --  Flash Common Command Object Registers
   type FTFE_FCCOB_Registers is record
      FCCOB3 : MK64F12.Byte;
      FCCOB2 : MK64F12.Byte;
      FCCOB1 : MK64F12.Byte;
      FCCOB0 : MK64F12.Byte;
      FCCOB7 : MK64F12.Byte;
      FCCOB6 : MK64F12.Byte;
      FCCOB5 : MK64F12.Byte;
      FCCOB4 : MK64F12.Byte;
      FCCOBB : MK64F12.Byte;
      FCCOBA : MK64F12.Byte;
      FCCOB9 : MK64F12.Byte;
      FCCOB8 : MK64F12.Byte;
   end record;

   for FTFE_FCCOB_Registers use record
      FCCOB3 at 0 range 0 .. 7;
      FCCOB2 at 1 range 0 .. 7;
      FCCOB1 at 2 range 0 .. 7;
      FCCOB0 at 3 range 0 .. 7;
      FCCOB7 at 4 range 0 .. 7;
      FCCOB6 at 5 range 0 .. 7;
      FCCOB5 at 6 range 0 .. 7;
      FCCOB4 at 7 range 0 .. 7;
      FCCOBB at 8 range 0 .. 7;
      FCCOBA at 9 range 0 .. 7;
      FCCOB9 at 10 range 0 .. 7;
      FCCOB8 at 11 range 0 .. 7;
   end record;

   --  Program Flash Protection Registers
   type FTFE_FPROT_Registers is record
      FPROT3 : MK64F12.Byte;
      FPROT2 : MK64F12.Byte;
      FPROT1 : MK64F12.Byte;
      FPROT0 : MK64F12.Byte;
   end record;

   for FTFE_FPROT_Registers use record
      FPROT3 at 0 range 0 .. 7;
      FPROT2 at 1 range 0 .. 7;
      FPROT1 at 2 range 0 .. 7;
      FPROT0 at 3 range 0 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Flash Memory Interface
   type FTFE_Peripheral is record
      --  Flash Status Register
      FSTAT  : FTFE_FSTAT_Register;
      --  Flash Configuration Register
      FCNFG  : FTFE_FCNFG_Register;
      --  Flash Security Register
      FSEC   : FTFE_FSEC_Register;
      --  Flash Option Register
      FOPT   : MK64F12.Byte;
      --  Flash Common Command Object Registers
      FCCOB  : FTFE_FCCOB_Registers;
      --  Program Flash Protection Registers
      FPROT  : FTFE_FPROT_Registers;
      --  EEPROM Protection Register
      FEPROT : MK64F12.Byte;
      --  Data Flash Protection Register
      FDPROT : MK64F12.Byte;
   end record
     with Volatile;

   for FTFE_Peripheral use record
      FSTAT  at 0 range 0 .. 7;
      FCNFG  at 1 range 0 .. 7;
      FSEC   at 2 range 0 .. 7;
      FOPT   at 3 range 0 .. 7;
      FCCOB  at 4 range 0 .. 95;
      FPROT  at 16 range 0 .. 31;
      FEPROT at 22 range 0 .. 7;
      FDPROT at 23 range 0 .. 7;
   end record;

   --  Flash Memory Interface
   FTFE_Periph : aliased FTFE_Peripheral
     with Import, Address => FTFE_Base;

end MK64F12.FTFE;
