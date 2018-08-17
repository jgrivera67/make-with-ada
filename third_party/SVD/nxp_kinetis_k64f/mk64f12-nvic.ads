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

--  Nested Vectored Interrupt Controller
package MK64F12.NVIC is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   subtype NVICSTIR_INTID_Field is MK64F12.UInt9;

   --  Software Trigger Interrupt Register
   type NVICSTIR_Register is record
      --  Interrupt ID of the interrupt to trigger, in the range 0-239. For
      --  example, a value of 0x03 specifies interrupt IRQ3.
      INTID         : NVICSTIR_INTID_Field := 16#0#;
      --  unspecified
      Reserved_9_31 : MK64F12.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVICSTIR_Register use record
      INTID         at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Nested Vectored Interrupt Controller
   type NVIC_Peripheral is record
      --  Interrupt Set Enable Register n
      NVICISER0 : MK64F12.Word;
      --  Interrupt Set Enable Register n
      NVICISER1 : MK64F12.Word;
      --  Interrupt Set Enable Register n
      NVICISER2 : MK64F12.Word;
      --  Interrupt Set Enable Register n
      NVICISER3 : MK64F12.Word;
      --  Interrupt Clear Enable Register n
      NVICICER0 : MK64F12.Word;
      --  Interrupt Clear Enable Register n
      NVICICER1 : MK64F12.Word;
      --  Interrupt Clear Enable Register n
      NVICICER2 : MK64F12.Word;
      --  Interrupt Clear Enable Register n
      NVICICER3 : MK64F12.Word;
      --  Interrupt Set Pending Register n
      NVICISPR0 : MK64F12.Word;
      --  Interrupt Set Pending Register n
      NVICISPR1 : MK64F12.Word;
      --  Interrupt Set Pending Register n
      NVICISPR2 : MK64F12.Word;
      --  Interrupt Set Pending Register n
      NVICISPR3 : MK64F12.Word;
      --  Interrupt Clear Pending Register n
      NVICICPR0 : MK64F12.Word;
      --  Interrupt Clear Pending Register n
      NVICICPR1 : MK64F12.Word;
      --  Interrupt Clear Pending Register n
      NVICICPR2 : MK64F12.Word;
      --  Interrupt Clear Pending Register n
      NVICICPR3 : MK64F12.Word;
      --  Interrupt Active bit Register n
      NVICIABR0 : MK64F12.Word;
      --  Interrupt Active bit Register n
      NVICIABR1 : MK64F12.Word;
      --  Interrupt Active bit Register n
      NVICIABR2 : MK64F12.Word;
      --  Interrupt Active bit Register n
      NVICIABR3 : MK64F12.Word;
      --  Interrupt Priority Register n
      NVICIP0   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP1   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP2   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP3   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP4   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP5   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP6   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP7   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP8   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP9   : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP10  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP11  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP12  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP13  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP14  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP15  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP16  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP17  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP18  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP19  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP20  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP21  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP22  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP23  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP24  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP25  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP26  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP27  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP28  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP29  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP30  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP31  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP32  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP33  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP34  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP35  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP36  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP37  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP38  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP39  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP40  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP41  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP42  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP43  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP44  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP45  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP46  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP47  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP48  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP49  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP50  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP51  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP52  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP53  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP54  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP55  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP56  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP57  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP58  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP59  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP60  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP61  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP62  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP63  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP64  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP65  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP66  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP67  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP68  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP69  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP70  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP71  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP72  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP73  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP74  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP75  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP76  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP77  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP78  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP79  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP80  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP81  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP82  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP83  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP84  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP85  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP86  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP87  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP88  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP89  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP90  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP91  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP92  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP93  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP94  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP95  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP96  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP97  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP98  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP99  : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP100 : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP101 : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP102 : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP103 : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP104 : MK64F12.Byte;
      --  Interrupt Priority Register n
      NVICIP105 : MK64F12.Byte;
      --  Software Trigger Interrupt Register
      NVICSTIR  : NVICSTIR_Register;
   end record
     with Volatile;

   for NVIC_Peripheral use record
      NVICISER0 at 0 range 0 .. 31;
      NVICISER1 at 4 range 0 .. 31;
      NVICISER2 at 8 range 0 .. 31;
      NVICISER3 at 12 range 0 .. 31;
      NVICICER0 at 128 range 0 .. 31;
      NVICICER1 at 132 range 0 .. 31;
      NVICICER2 at 136 range 0 .. 31;
      NVICICER3 at 140 range 0 .. 31;
      NVICISPR0 at 256 range 0 .. 31;
      NVICISPR1 at 260 range 0 .. 31;
      NVICISPR2 at 264 range 0 .. 31;
      NVICISPR3 at 268 range 0 .. 31;
      NVICICPR0 at 384 range 0 .. 31;
      NVICICPR1 at 388 range 0 .. 31;
      NVICICPR2 at 392 range 0 .. 31;
      NVICICPR3 at 396 range 0 .. 31;
      NVICIABR0 at 512 range 0 .. 31;
      NVICIABR1 at 516 range 0 .. 31;
      NVICIABR2 at 520 range 0 .. 31;
      NVICIABR3 at 524 range 0 .. 31;
      NVICIP0   at 768 range 0 .. 7;
      NVICIP1   at 769 range 0 .. 7;
      NVICIP2   at 770 range 0 .. 7;
      NVICIP3   at 771 range 0 .. 7;
      NVICIP4   at 772 range 0 .. 7;
      NVICIP5   at 773 range 0 .. 7;
      NVICIP6   at 774 range 0 .. 7;
      NVICIP7   at 775 range 0 .. 7;
      NVICIP8   at 776 range 0 .. 7;
      NVICIP9   at 777 range 0 .. 7;
      NVICIP10  at 778 range 0 .. 7;
      NVICIP11  at 779 range 0 .. 7;
      NVICIP12  at 780 range 0 .. 7;
      NVICIP13  at 781 range 0 .. 7;
      NVICIP14  at 782 range 0 .. 7;
      NVICIP15  at 783 range 0 .. 7;
      NVICIP16  at 784 range 0 .. 7;
      NVICIP17  at 785 range 0 .. 7;
      NVICIP18  at 786 range 0 .. 7;
      NVICIP19  at 787 range 0 .. 7;
      NVICIP20  at 788 range 0 .. 7;
      NVICIP21  at 789 range 0 .. 7;
      NVICIP22  at 790 range 0 .. 7;
      NVICIP23  at 791 range 0 .. 7;
      NVICIP24  at 792 range 0 .. 7;
      NVICIP25  at 793 range 0 .. 7;
      NVICIP26  at 794 range 0 .. 7;
      NVICIP27  at 795 range 0 .. 7;
      NVICIP28  at 796 range 0 .. 7;
      NVICIP29  at 797 range 0 .. 7;
      NVICIP30  at 798 range 0 .. 7;
      NVICIP31  at 799 range 0 .. 7;
      NVICIP32  at 800 range 0 .. 7;
      NVICIP33  at 801 range 0 .. 7;
      NVICIP34  at 802 range 0 .. 7;
      NVICIP35  at 803 range 0 .. 7;
      NVICIP36  at 804 range 0 .. 7;
      NVICIP37  at 805 range 0 .. 7;
      NVICIP38  at 806 range 0 .. 7;
      NVICIP39  at 807 range 0 .. 7;
      NVICIP40  at 808 range 0 .. 7;
      NVICIP41  at 809 range 0 .. 7;
      NVICIP42  at 810 range 0 .. 7;
      NVICIP43  at 811 range 0 .. 7;
      NVICIP44  at 812 range 0 .. 7;
      NVICIP45  at 813 range 0 .. 7;
      NVICIP46  at 814 range 0 .. 7;
      NVICIP47  at 815 range 0 .. 7;
      NVICIP48  at 816 range 0 .. 7;
      NVICIP49  at 817 range 0 .. 7;
      NVICIP50  at 818 range 0 .. 7;
      NVICIP51  at 819 range 0 .. 7;
      NVICIP52  at 820 range 0 .. 7;
      NVICIP53  at 821 range 0 .. 7;
      NVICIP54  at 822 range 0 .. 7;
      NVICIP55  at 823 range 0 .. 7;
      NVICIP56  at 824 range 0 .. 7;
      NVICIP57  at 825 range 0 .. 7;
      NVICIP58  at 826 range 0 .. 7;
      NVICIP59  at 827 range 0 .. 7;
      NVICIP60  at 828 range 0 .. 7;
      NVICIP61  at 829 range 0 .. 7;
      NVICIP62  at 830 range 0 .. 7;
      NVICIP63  at 831 range 0 .. 7;
      NVICIP64  at 832 range 0 .. 7;
      NVICIP65  at 833 range 0 .. 7;
      NVICIP66  at 834 range 0 .. 7;
      NVICIP67  at 835 range 0 .. 7;
      NVICIP68  at 836 range 0 .. 7;
      NVICIP69  at 837 range 0 .. 7;
      NVICIP70  at 838 range 0 .. 7;
      NVICIP71  at 839 range 0 .. 7;
      NVICIP72  at 840 range 0 .. 7;
      NVICIP73  at 841 range 0 .. 7;
      NVICIP74  at 842 range 0 .. 7;
      NVICIP75  at 843 range 0 .. 7;
      NVICIP76  at 844 range 0 .. 7;
      NVICIP77  at 845 range 0 .. 7;
      NVICIP78  at 846 range 0 .. 7;
      NVICIP79  at 847 range 0 .. 7;
      NVICIP80  at 848 range 0 .. 7;
      NVICIP81  at 849 range 0 .. 7;
      NVICIP82  at 850 range 0 .. 7;
      NVICIP83  at 851 range 0 .. 7;
      NVICIP84  at 852 range 0 .. 7;
      NVICIP85  at 853 range 0 .. 7;
      NVICIP86  at 854 range 0 .. 7;
      NVICIP87  at 855 range 0 .. 7;
      NVICIP88  at 856 range 0 .. 7;
      NVICIP89  at 857 range 0 .. 7;
      NVICIP90  at 858 range 0 .. 7;
      NVICIP91  at 859 range 0 .. 7;
      NVICIP92  at 860 range 0 .. 7;
      NVICIP93  at 861 range 0 .. 7;
      NVICIP94  at 862 range 0 .. 7;
      NVICIP95  at 863 range 0 .. 7;
      NVICIP96  at 864 range 0 .. 7;
      NVICIP97  at 865 range 0 .. 7;
      NVICIP98  at 866 range 0 .. 7;
      NVICIP99  at 867 range 0 .. 7;
      NVICIP100 at 868 range 0 .. 7;
      NVICIP101 at 869 range 0 .. 7;
      NVICIP102 at 870 range 0 .. 7;
      NVICIP103 at 871 range 0 .. 7;
      NVICIP104 at 872 range 0 .. 7;
      NVICIP105 at 873 range 0 .. 7;
      NVICSTIR  at 3584 range 0 .. 31;
   end record;

   --  Nested Vectored Interrupt Controller
   NVIC_Periph : aliased NVIC_Peripheral
     with Import, Address => NVIC_Base;

end MK64F12.NVIC;
