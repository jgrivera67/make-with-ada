--
--  Copyright (C) 2021, AdaCore
--

pragma Style_Checks (Off);

--  Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
--
--  SPDX-License-Identifier: BSD-3-Clause

--  This is the version for Cortex M0+ Kinetis KL25Z targets
with Kinetis_KL25Z;

package Ada.Interrupts.Names is

   --  All identifiers in this unit are implementation defined

   pragma Implementation_Defined;

   Sys_Tick_Interrupt               : constant Interrupt_ID := -1;
   DMA0_Interrupt                   : constant Interrupt_ID :=
     Kinetis_KL25Z.External_Interrupt_Type'Pos (Kinetis_KL25Z.DMA0_IRQ);

   UART0_Interrupt                   : constant Interrupt_ID :=
     Kinetis_KL25Z.External_Interrupt_Type'Pos (Kinetis_KL25Z.UART0_IRQ);

   UART1_Interrupt                   : constant Interrupt_ID :=
     Kinetis_KL25Z.External_Interrupt_Type'Pos (Kinetis_KL25Z.UART1_IRQ);

   UART2_Interrupt                   : constant Interrupt_ID :=
     Kinetis_KL25Z.External_Interrupt_Type'Pos (Kinetis_KL25Z.UART2_IRQ);

   ADC0_Interrupt                   : constant Interrupt_ID :=
     Kinetis_KL25Z.External_Interrupt_Type'Pos (Kinetis_KL25Z.ADC0_IRQ);

   PIT_Interrupt                   : constant Interrupt_ID :=
     Kinetis_KL25Z.External_Interrupt_Type'Pos (Kinetis_KL25Z.PIT_IRQ);

   --  ...

end Ada.Interrupts.Names;
