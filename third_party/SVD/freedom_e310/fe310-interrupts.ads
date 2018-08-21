--  This spec has been automatically generated from FE310.svd

--  Definition of the device's interrupts
package FE310.Interrupts is
   pragma No_Elaboration_Code_All;

   ----------------
   -- Interrupts --
   ----------------

   Watchdog                 : constant := 1;
   RTC                      : constant := 2;
   UART0                    : constant := 3;
   UART1                    : constant := 4;
   QSPI0                    : constant := 5;
   QSPI1                    : constant := 6;
   QSPI2                    : constant := 7;
   GPIO_0                   : constant := 8;
   GPIO_1                   : constant := 9;
   GPIO_2                   : constant := 10;
   GPIO_3                   : constant := 11;
   GPIO_4                   : constant := 12;
   GPIO_5                   : constant := 13;
   GPIO_6                   : constant := 14;
   GPIO_7                   : constant := 15;
   GPIO_8                   : constant := 16;
   GPIO_9                   : constant := 17;
   GPIO_10                  : constant := 18;
   GPIO_11                  : constant := 19;
   GPIO_12                  : constant := 20;
   GPIO_14                  : constant := 22;
   GPIO_16                  : constant := 24;
   GPIO_17                  : constant := 25;
   GPIO_18                  : constant := 26;
   GPIO_19                  : constant := 27;
   GPIO_20                  : constant := 28;
   GPIO_21                  : constant := 29;
   GPIO_22                  : constant := 30;
   GPIO_23                  : constant := 31;
   GPIO_24                  : constant := 32;
   GPIO_25                  : constant := 33;
   GPIO_26                  : constant := 34;
   GPIO_27                  : constant := 35;
   GPIO_28                  : constant := 36;
   GPIO_30                  : constant := 38;
   GPIO_31                  : constant := 39;
   PWMO_CMP0                : constant := 40;
   PWMO_CMP1                : constant := 41;
   PWMO_CMP2                : constant := 42;
   PWMO_CMP3                : constant := 43;
   PWM1_CMP0                : constant := 44;
   PWM1_CMP1                : constant := 45;
   PWM1_CMP2                : constant := 46;
   PWM1_CMP3                : constant := 47;
   PWM2_CMP0                : constant := 48;
   PWM2_CMP1                : constant := 49;
   PWM2_CMP2                : constant := 50;
   PWM2_CMP3                : constant := 51;

end FE310.Interrupts;
