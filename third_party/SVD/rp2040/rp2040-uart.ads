pragma Style_Checks (Off);

--  Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
--
--  SPDX-License-Identifier: BSD-3-Clause

--  This spec has been automatically generated from rp2040.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package RP2040.UART is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype UARTDR_DATA_Field is RP2040.Byte;
   subtype UARTDR_FE_Field is RP2040.Bit;
   subtype UARTDR_PE_Field is RP2040.Bit;
   subtype UARTDR_BE_Field is RP2040.Bit;
   subtype UARTDR_OE_Field is RP2040.Bit;

   --  Data Register, UARTDR
   type UARTDR_Register is record
      --  Receive (read) data character. Transmit (write) data character.
      DATA           : UARTDR_DATA_Field := 16#0#;
      --  Read-only. Framing error. When set to 1, it indicates that the
      --  received character did not have a valid stop bit (a valid stop bit is
      --  1). In FIFO mode, this error is associated with the character at the
      --  top of the FIFO.
      FE             : UARTDR_FE_Field := 16#0#;
      --  Read-only. Parity error. When set to 1, it indicates that the parity
      --  of the received data character does not match the parity that the EPS
      --  and SPS bits in the Line Control Register, UARTLCR_H. In FIFO mode,
      --  this error is associated with the character at the top of the FIFO.
      PE             : UARTDR_PE_Field := 16#0#;
      --  Read-only. Break error. This bit is set to 1 if a break condition was
      --  detected, indicating that the received data input was held LOW for
      --  longer than a full-word transmission time (defined as start, data,
      --  parity and stop bits). In FIFO mode, this error is associated with
      --  the character at the top of the FIFO. When a break occurs, only one 0
      --  character is loaded into the FIFO. The next character is only enabled
      --  after the receive data input goes to a 1 (marking state), and the
      --  next valid start bit is received.
      BE             : UARTDR_BE_Field := 16#0#;
      --  Read-only. Overrun error. This bit is set to 1 if data is received
      --  and the receive FIFO is already full. This is cleared to 0 once there
      --  is an empty space in the FIFO and a new character can be written to
      --  it.
      OE             : UARTDR_OE_Field := 16#0#;
      --  unspecified
      Reserved_12_31 : RP2040.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTDR_Register use record
      DATA           at 0 range 0 .. 7;
      FE             at 0 range 8 .. 8;
      PE             at 0 range 9 .. 9;
      BE             at 0 range 10 .. 10;
      OE             at 0 range 11 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   subtype UARTRSR_FE_Field is RP2040.Bit;
   subtype UARTRSR_PE_Field is RP2040.Bit;
   subtype UARTRSR_BE_Field is RP2040.Bit;
   subtype UARTRSR_OE_Field is RP2040.Bit;

   --  Receive Status Register/Error Clear Register, UARTRSR/UARTECR
   type UARTRSR_Register is record
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Framing error. When set to 1, it indicates that the
      --  received character did not have a valid stop bit (a valid stop bit is
      --  1). This bit is cleared to 0 by a write to UARTECR. In FIFO mode,
      --  this error is associated with the character at the top of the FIFO.
      FE            : UARTRSR_FE_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Parity error. When set to 1, it indicates that the
      --  parity of the received data character does not match the parity that
      --  the EPS and SPS bits in the Line Control Register, UARTLCR_H. This
      --  bit is cleared to 0 by a write to UARTECR. In FIFO mode, this error
      --  is associated with the character at the top of the FIFO.
      PE            : UARTRSR_PE_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Break error. This bit is set to 1 if a break condition
      --  was detected, indicating that the received data input was held LOW
      --  for longer than a full-word transmission time (defined as start,
      --  data, parity, and stop bits). This bit is cleared to 0 after a write
      --  to UARTECR. In FIFO mode, this error is associated with the character
      --  at the top of the FIFO. When a break occurs, only one 0 character is
      --  loaded into the FIFO. The next character is only enabled after the
      --  receive data input goes to a 1 (marking state) and the next valid
      --  start bit is received.
      BE            : UARTRSR_BE_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Overrun error. This bit is set to 1 if data is received
      --  and the FIFO is already full. This bit is cleared to 0 by a write to
      --  UARTECR. The FIFO contents remain valid because no more data is
      --  written when the FIFO is full, only the contents of the shift
      --  register are overwritten. The CPU must now read the data, to empty
      --  the FIFO.
      OE            : UARTRSR_OE_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : RP2040.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTRSR_Register use record
      FE            at 0 range 0 .. 0;
      PE            at 0 range 1 .. 1;
      BE            at 0 range 2 .. 2;
      OE            at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype UARTFR_CTS_Field is RP2040.Bit;
   subtype UARTFR_DSR_Field is RP2040.Bit;
   subtype UARTFR_DCD_Field is RP2040.Bit;
   subtype UARTFR_BUSY_Field is RP2040.Bit;
   subtype UARTFR_RXFE_Field is RP2040.Bit;
   subtype UARTFR_TXFF_Field is RP2040.Bit;
   subtype UARTFR_RXFF_Field is RP2040.Bit;
   subtype UARTFR_TXFE_Field is RP2040.Bit;
   subtype UARTFR_RI_Field is RP2040.Bit;

   --  Flag Register, UARTFR
   type UARTFR_Register is record
      --  Read-only. Clear to send. This bit is the complement of the UART
      --  clear to send, nUARTCTS, modem status input. That is, the bit is 1
      --  when nUARTCTS is LOW.
      CTS           : UARTFR_CTS_Field;
      --  Read-only. Data set ready. This bit is the complement of the UART
      --  data set ready, nUARTDSR, modem status input. That is, the bit is 1
      --  when nUARTDSR is LOW.
      DSR           : UARTFR_DSR_Field;
      --  Read-only. Data carrier detect. This bit is the complement of the
      --  UART data carrier detect, nUARTDCD, modem status input. That is, the
      --  bit is 1 when nUARTDCD is LOW.
      DCD           : UARTFR_DCD_Field;
      --  Read-only. UART busy. If this bit is set to 1, the UART is busy
      --  transmitting data. This bit remains set until the complete byte,
      --  including all the stop bits, has been sent from the shift register.
      --  This bit is set as soon as the transmit FIFO becomes non-empty,
      --  regardless of whether the UART is enabled or not.
      BUSY          : UARTFR_BUSY_Field;
      --  Read-only. Receive FIFO empty. The meaning of this bit depends on the
      --  state of the FEN bit in the UARTLCR_H Register. If the FIFO is
      --  disabled, this bit is set when the receive holding register is empty.
      --  If the FIFO is enabled, the RXFE bit is set when the receive FIFO is
      --  empty.
      RXFE          : UARTFR_RXFE_Field;
      --  Read-only. Transmit FIFO full. The meaning of this bit depends on the
      --  state of the FEN bit in the UARTLCR_H Register. If the FIFO is
      --  disabled, this bit is set when the transmit holding register is full.
      --  If the FIFO is enabled, the TXFF bit is set when the transmit FIFO is
      --  full.
      TXFF          : UARTFR_TXFF_Field;
      --  Read-only. Receive FIFO full. The meaning of this bit depends on the
      --  state of the FEN bit in the UARTLCR_H Register. If the FIFO is
      --  disabled, this bit is set when the receive holding register is full.
      --  If the FIFO is enabled, the RXFF bit is set when the receive FIFO is
      --  full.
      RXFF          : UARTFR_RXFF_Field;
      --  Read-only. Transmit FIFO empty. The meaning of this bit depends on
      --  the state of the FEN bit in the Line Control Register, UARTLCR_H. If
      --  the FIFO is disabled, this bit is set when the transmit holding
      --  register is empty. If the FIFO is enabled, the TXFE bit is set when
      --  the transmit FIFO is empty. This bit does not indicate if there is
      --  data in the transmit shift register.
      TXFE          : UARTFR_TXFE_Field;
      --  Read-only. Ring indicator. This bit is the complement of the UART
      --  ring indicator, nUARTRI, modem status input. That is, the bit is 1
      --  when nUARTRI is LOW.
      RI            : UARTFR_RI_Field;
      --  unspecified
      Reserved_9_31 : RP2040.UInt23;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTFR_Register use record
      CTS           at 0 range 0 .. 0;
      DSR           at 0 range 1 .. 1;
      DCD           at 0 range 2 .. 2;
      BUSY          at 0 range 3 .. 3;
      RXFE          at 0 range 4 .. 4;
      TXFF          at 0 range 5 .. 5;
      RXFF          at 0 range 6 .. 6;
      TXFE          at 0 range 7 .. 7;
      RI            at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype UARTILPR_ILPDVSR_Field is RP2040.Byte;

   --  IrDA Low-Power Counter Register, UARTILPR
   type UARTILPR_Register is record
      --  8-bit low-power divisor value. These bits are cleared to 0 at reset.
      ILPDVSR       : UARTILPR_ILPDVSR_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTILPR_Register use record
      ILPDVSR       at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTIBRD_BAUD_DIVINT_Field is RP2040.UInt16;

   --  Integer Baud Rate Register, UARTIBRD
   type UARTIBRD_Register is record
      --  The integer baud rate divisor. These bits are cleared to 0 on reset.
      BAUD_DIVINT    : UARTIBRD_BAUD_DIVINT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : RP2040.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTIBRD_Register use record
      BAUD_DIVINT    at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype UARTFBRD_BAUD_DIVFRAC_Field is RP2040.UInt6;

   --  Fractional Baud Rate Register, UARTFBRD
   type UARTFBRD_Register is record
      --  The fractional baud rate divisor. These bits are cleared to 0 on
      --  reset.
      BAUD_DIVFRAC  : UARTFBRD_BAUD_DIVFRAC_Field := 16#0#;
      --  unspecified
      Reserved_6_31 : RP2040.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTFBRD_Register use record
      BAUD_DIVFRAC  at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype UARTLCR_H_BRK_Field is RP2040.Bit;
   subtype UARTLCR_H_PEN_Field is RP2040.Bit;
   subtype UARTLCR_H_EPS_Field is RP2040.Bit;
   subtype UARTLCR_H_STP2_Field is RP2040.Bit;
   subtype UARTLCR_H_FEN_Field is RP2040.Bit;
   subtype UARTLCR_H_WLEN_Field is RP2040.UInt2;
   subtype UARTLCR_H_SPS_Field is RP2040.Bit;

   --  Line Control Register, UARTLCR_H
   type UARTLCR_H_Register is record
      --  Send break. If this bit is set to 1, a low-level is continually
      --  output on the UARTTXD output, after completing transmission of the
      --  current character. For the proper execution of the break command, the
      --  software must set this bit for at least two complete frames. For
      --  normal use, this bit must be cleared to 0.
      BRK           : UARTLCR_H_BRK_Field := 16#0#;
      --  Parity enable: 0 = parity is disabled and no parity bit added to the
      --  data frame 1 = parity checking and generation is enabled.
      PEN           : UARTLCR_H_PEN_Field := 16#0#;
      --  Even parity select. Controls the type of parity the UART uses during
      --  transmission and reception: 0 = odd parity. The UART generates or
      --  checks for an odd number of 1s in the data and parity bits. 1 = even
      --  parity. The UART generates or checks for an even number of 1s in the
      --  data and parity bits. This bit has no effect when the PEN bit
      --  disables parity checking and generation.
      EPS           : UARTLCR_H_EPS_Field := 16#0#;
      --  Two stop bits select. If this bit is set to 1, two stop bits are
      --  transmitted at the end of the frame. The receive logic does not check
      --  for two stop bits being received.
      STP2          : UARTLCR_H_STP2_Field := 16#0#;
      --  Enable FIFOs: 0 = FIFOs are disabled (character mode) that is, the
      --  FIFOs become 1-byte-deep holding registers 1 = transmit and receive
      --  FIFO buffers are enabled (FIFO mode).
      FEN           : UARTLCR_H_FEN_Field := 16#0#;
      --  Word length. These bits indicate the number of data bits transmitted
      --  or received in a frame as follows: b11 = 8 bits b10 = 7 bits b01 = 6
      --  bits b00 = 5 bits.
      WLEN          : UARTLCR_H_WLEN_Field := 16#0#;
      --  Stick parity select. 0 = stick parity is disabled 1 = either: * if
      --  the EPS bit is 0 then the parity bit is transmitted and checked as a
      --  1 * if the EPS bit is 1 then the parity bit is transmitted and
      --  checked as a 0. This bit has no effect when the PEN bit disables
      --  parity checking and generation.
      SPS           : UARTLCR_H_SPS_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTLCR_H_Register use record
      BRK           at 0 range 0 .. 0;
      PEN           at 0 range 1 .. 1;
      EPS           at 0 range 2 .. 2;
      STP2          at 0 range 3 .. 3;
      FEN           at 0 range 4 .. 4;
      WLEN          at 0 range 5 .. 6;
      SPS           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTCR_UARTEN_Field is RP2040.Bit;
   subtype UARTCR_SIREN_Field is RP2040.Bit;
   subtype UARTCR_SIRLP_Field is RP2040.Bit;
   subtype UARTCR_LBE_Field is RP2040.Bit;
   subtype UARTCR_TXE_Field is RP2040.Bit;
   subtype UARTCR_RXE_Field is RP2040.Bit;
   subtype UARTCR_DTR_Field is RP2040.Bit;
   subtype UARTCR_RTS_Field is RP2040.Bit;
   --  UARTCR_OUT array element
   subtype UARTCR_OUT_Element is RP2040.Bit;

   --  UARTCR_OUT array
   type UARTCR_OUT_Field_Array is array (1 .. 2) of UARTCR_OUT_Element
     with Component_Size => 1, Size => 2;

   --  Type definition for UARTCR_OUT
   type UARTCR_OUT_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  OUT as a value
            Val : RP2040.UInt2;
         when True =>
            --  OUT as an array
            Arr : UARTCR_OUT_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for UARTCR_OUT_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   subtype UARTCR_RTSEN_Field is RP2040.Bit;
   subtype UARTCR_CTSEN_Field is RP2040.Bit;

   --  Control Register, UARTCR
   type UARTCR_Register is record
      --  UART enable: 0 = UART is disabled. If the UART is disabled in the
      --  middle of transmission or reception, it completes the current
      --  character before stopping. 1 = the UART is enabled. Data transmission
      --  and reception occurs for either UART signals or SIR signals depending
      --  on the setting of the SIREN bit.
      UARTEN         : UARTCR_UARTEN_Field := 16#0#;
      --  SIR enable: 0 = IrDA SIR ENDEC is disabled. nSIROUT remains LOW (no
      --  light pulse generated), and signal transitions on SIRIN have no
      --  effect. 1 = IrDA SIR ENDEC is enabled. Data is transmitted and
      --  received on nSIROUT and SIRIN. UARTTXD remains HIGH, in the marking
      --  state. Signal transitions on UARTRXD or modem status inputs have no
      --  effect. This bit has no effect if the UARTEN bit disables the UART.
      SIREN          : UARTCR_SIREN_Field := 16#0#;
      --  SIR low-power IrDA mode. This bit selects the IrDA encoding mode. If
      --  this bit is cleared to 0, low-level bits are transmitted as an active
      --  high pulse with a width of 3 / 16th of the bit period. If this bit is
      --  set to 1, low-level bits are transmitted with a pulse width that is 3
      --  times the period of the IrLPBaud16 input signal, regardless of the
      --  selected bit rate. Setting this bit uses less power, but might reduce
      --  transmission distances.
      SIRLP          : UARTCR_SIRLP_Field := 16#0#;
      --  unspecified
      Reserved_3_6   : RP2040.UInt4 := 16#0#;
      --  Loopback enable. If this bit is set to 1 and the SIREN bit is set to
      --  1 and the SIRTEST bit in the Test Control Register, UARTTCR is set to
      --  1, then the nSIROUT path is inverted, and fed through to the SIRIN
      --  path. The SIRTEST bit in the test register must be set to 1 to
      --  override the normal half-duplex SIR operation. This must be the
      --  requirement for accessing the test registers during normal operation,
      --  and SIRTEST must be cleared to 0 when loopback testing is finished.
      --  This feature reduces the amount of external coupling required during
      --  system test. If this bit is set to 1, and the SIRTEST bit is set to
      --  0, the UARTTXD path is fed through to the UARTRXD path. In either SIR
      --  mode or UART mode, when this bit is set, the modem outputs are also
      --  fed through to the modem inputs. This bit is cleared to 0 on reset,
      --  to disable loopback.
      LBE            : UARTCR_LBE_Field := 16#0#;
      --  Transmit enable. If this bit is set to 1, the transmit section of the
      --  UART is enabled. Data transmission occurs for either UART signals, or
      --  SIR signals depending on the setting of the SIREN bit. When the UART
      --  is disabled in the middle of transmission, it completes the current
      --  character before stopping.
      TXE            : UARTCR_TXE_Field := 16#1#;
      --  Receive enable. If this bit is set to 1, the receive section of the
      --  UART is enabled. Data reception occurs for either UART signals or SIR
      --  signals depending on the setting of the SIREN bit. When the UART is
      --  disabled in the middle of reception, it completes the current
      --  character before stopping.
      RXE            : UARTCR_RXE_Field := 16#1#;
      --  Data transmit ready. This bit is the complement of the UART data
      --  transmit ready, nUARTDTR, modem status output. That is, when the bit
      --  is programmed to a 1 then nUARTDTR is LOW.
      DTR            : UARTCR_DTR_Field := 16#0#;
      --  Request to send. This bit is the complement of the UART request to
      --  send, nUARTRTS, modem status output. That is, when the bit is
      --  programmed to a 1 then nUARTRTS is LOW.
      RTS            : UARTCR_RTS_Field := 16#0#;
      --  This bit is the complement of the UART Out1 (nUARTOut1) modem status
      --  output. That is, when the bit is programmed to a 1 the output is 0.
      --  For DTE this can be used as Data Carrier Detect (DCD).
      OUT_k          : UARTCR_OUT_Field := (As_Array => False, Val => 16#0#);
      --  RTS hardware flow control enable. If this bit is set to 1, RTS
      --  hardware flow control is enabled. Data is only requested when there
      --  is space in the receive FIFO for it to be received.
      RTSEN          : UARTCR_RTSEN_Field := 16#0#;
      --  CTS hardware flow control enable. If this bit is set to 1, CTS
      --  hardware flow control is enabled. Data is only transmitted when the
      --  nUARTCTS signal is asserted.
      CTSEN          : UARTCR_CTSEN_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : RP2040.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTCR_Register use record
      UARTEN         at 0 range 0 .. 0;
      SIREN          at 0 range 1 .. 1;
      SIRLP          at 0 range 2 .. 2;
      Reserved_3_6   at 0 range 3 .. 6;
      LBE            at 0 range 7 .. 7;
      TXE            at 0 range 8 .. 8;
      RXE            at 0 range 9 .. 9;
      DTR            at 0 range 10 .. 10;
      RTS            at 0 range 11 .. 11;
      OUT_k          at 0 range 12 .. 13;
      RTSEN          at 0 range 14 .. 14;
      CTSEN          at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype UARTIFLS_TXIFLSEL_Field is RP2040.UInt3;
   subtype UARTIFLS_RXIFLSEL_Field is RP2040.UInt3;

   --  Interrupt FIFO Level Select Register, UARTIFLS
   type UARTIFLS_Register is record
      --  Transmit interrupt FIFO level select. The trigger points for the
      --  transmit interrupt are as follows: b000 = Transmit FIFO becomes <= 1
      --  / 8 full b001 = Transmit FIFO becomes <= 1 / 4 full b010 = Transmit
      --  FIFO becomes <= 1 / 2 full b011 = Transmit FIFO becomes <= 3 / 4 full
      --  b100 = Transmit FIFO becomes <= 7 / 8 full b101-b111 = reserved.
      TXIFLSEL      : UARTIFLS_TXIFLSEL_Field := 16#2#;
      --  Receive interrupt FIFO level select. The trigger points for the
      --  receive interrupt are as follows: b000 = Receive FIFO becomes >= 1 /
      --  8 full b001 = Receive FIFO becomes >= 1 / 4 full b010 = Receive FIFO
      --  becomes >= 1 / 2 full b011 = Receive FIFO becomes >= 3 / 4 full b100
      --  = Receive FIFO becomes >= 7 / 8 full b101-b111 = reserved.
      RXIFLSEL      : UARTIFLS_RXIFLSEL_Field := 16#2#;
      --  unspecified
      Reserved_6_31 : RP2040.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTIFLS_Register use record
      TXIFLSEL      at 0 range 0 .. 2;
      RXIFLSEL      at 0 range 3 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype UARTIMSC_RIMIM_Field is RP2040.Bit;
   subtype UARTIMSC_CTSMIM_Field is RP2040.Bit;
   subtype UARTIMSC_DCDMIM_Field is RP2040.Bit;
   subtype UARTIMSC_DSRMIM_Field is RP2040.Bit;
   subtype UARTIMSC_RXIM_Field is RP2040.Bit;
   subtype UARTIMSC_TXIM_Field is RP2040.Bit;
   subtype UARTIMSC_RTIM_Field is RP2040.Bit;
   subtype UARTIMSC_FEIM_Field is RP2040.Bit;
   subtype UARTIMSC_PEIM_Field is RP2040.Bit;
   subtype UARTIMSC_BEIM_Field is RP2040.Bit;
   subtype UARTIMSC_OEIM_Field is RP2040.Bit;

   --  Interrupt Mask Set/Clear Register, UARTIMSC
   type UARTIMSC_Register is record
      --  nUARTRI modem interrupt mask. A read returns the current mask for the
      --  UARTRIINTR interrupt. On a write of 1, the mask of the UARTRIINTR
      --  interrupt is set. A write of 0 clears the mask.
      RIMIM          : UARTIMSC_RIMIM_Field := 16#0#;
      --  nUARTCTS modem interrupt mask. A read returns the current mask for
      --  the UARTCTSINTR interrupt. On a write of 1, the mask of the
      --  UARTCTSINTR interrupt is set. A write of 0 clears the mask.
      CTSMIM         : UARTIMSC_CTSMIM_Field := 16#0#;
      --  nUARTDCD modem interrupt mask. A read returns the current mask for
      --  the UARTDCDINTR interrupt. On a write of 1, the mask of the
      --  UARTDCDINTR interrupt is set. A write of 0 clears the mask.
      DCDMIM         : UARTIMSC_DCDMIM_Field := 16#0#;
      --  nUARTDSR modem interrupt mask. A read returns the current mask for
      --  the UARTDSRINTR interrupt. On a write of 1, the mask of the
      --  UARTDSRINTR interrupt is set. A write of 0 clears the mask.
      DSRMIM         : UARTIMSC_DSRMIM_Field := 16#0#;
      --  Receive interrupt mask. A read returns the current mask for the
      --  UARTRXINTR interrupt. On a write of 1, the mask of the UARTRXINTR
      --  interrupt is set. A write of 0 clears the mask.
      RXIM           : UARTIMSC_RXIM_Field := 16#0#;
      --  Transmit interrupt mask. A read returns the current mask for the
      --  UARTTXINTR interrupt. On a write of 1, the mask of the UARTTXINTR
      --  interrupt is set. A write of 0 clears the mask.
      TXIM           : UARTIMSC_TXIM_Field := 16#0#;
      --  Receive timeout interrupt mask. A read returns the current mask for
      --  the UARTRTINTR interrupt. On a write of 1, the mask of the UARTRTINTR
      --  interrupt is set. A write of 0 clears the mask.
      RTIM           : UARTIMSC_RTIM_Field := 16#0#;
      --  Framing error interrupt mask. A read returns the current mask for the
      --  UARTFEINTR interrupt. On a write of 1, the mask of the UARTFEINTR
      --  interrupt is set. A write of 0 clears the mask.
      FEIM           : UARTIMSC_FEIM_Field := 16#0#;
      --  Parity error interrupt mask. A read returns the current mask for the
      --  UARTPEINTR interrupt. On a write of 1, the mask of the UARTPEINTR
      --  interrupt is set. A write of 0 clears the mask.
      PEIM           : UARTIMSC_PEIM_Field := 16#0#;
      --  Break error interrupt mask. A read returns the current mask for the
      --  UARTBEINTR interrupt. On a write of 1, the mask of the UARTBEINTR
      --  interrupt is set. A write of 0 clears the mask.
      BEIM           : UARTIMSC_BEIM_Field := 16#0#;
      --  Overrun error interrupt mask. A read returns the current mask for the
      --  UARTOEINTR interrupt. On a write of 1, the mask of the UARTOEINTR
      --  interrupt is set. A write of 0 clears the mask.
      OEIM           : UARTIMSC_OEIM_Field := 16#0#;
      --  unspecified
      Reserved_11_31 : RP2040.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTIMSC_Register use record
      RIMIM          at 0 range 0 .. 0;
      CTSMIM         at 0 range 1 .. 1;
      DCDMIM         at 0 range 2 .. 2;
      DSRMIM         at 0 range 3 .. 3;
      RXIM           at 0 range 4 .. 4;
      TXIM           at 0 range 5 .. 5;
      RTIM           at 0 range 6 .. 6;
      FEIM           at 0 range 7 .. 7;
      PEIM           at 0 range 8 .. 8;
      BEIM           at 0 range 9 .. 9;
      OEIM           at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   subtype UARTRIS_RIRMIS_Field is RP2040.Bit;
   subtype UARTRIS_CTSRMIS_Field is RP2040.Bit;
   subtype UARTRIS_DCDRMIS_Field is RP2040.Bit;
   subtype UARTRIS_DSRRMIS_Field is RP2040.Bit;
   subtype UARTRIS_RXRIS_Field is RP2040.Bit;
   subtype UARTRIS_TXRIS_Field is RP2040.Bit;
   subtype UARTRIS_RTRIS_Field is RP2040.Bit;
   subtype UARTRIS_FERIS_Field is RP2040.Bit;
   subtype UARTRIS_PERIS_Field is RP2040.Bit;
   subtype UARTRIS_BERIS_Field is RP2040.Bit;
   subtype UARTRIS_OERIS_Field is RP2040.Bit;

   --  Raw Interrupt Status Register, UARTRIS
   type UARTRIS_Register is record
      --  Read-only. nUARTRI modem interrupt status. Returns the raw interrupt
      --  state of the UARTRIINTR interrupt.
      RIRMIS         : UARTRIS_RIRMIS_Field;
      --  Read-only. nUARTCTS modem interrupt status. Returns the raw interrupt
      --  state of the UARTCTSINTR interrupt.
      CTSRMIS        : UARTRIS_CTSRMIS_Field;
      --  Read-only. nUARTDCD modem interrupt status. Returns the raw interrupt
      --  state of the UARTDCDINTR interrupt.
      DCDRMIS        : UARTRIS_DCDRMIS_Field;
      --  Read-only. nUARTDSR modem interrupt status. Returns the raw interrupt
      --  state of the UARTDSRINTR interrupt.
      DSRRMIS        : UARTRIS_DSRRMIS_Field;
      --  Read-only. Receive interrupt status. Returns the raw interrupt state
      --  of the UARTRXINTR interrupt.
      RXRIS          : UARTRIS_RXRIS_Field;
      --  Read-only. Transmit interrupt status. Returns the raw interrupt state
      --  of the UARTTXINTR interrupt.
      TXRIS          : UARTRIS_TXRIS_Field;
      --  Read-only. Receive timeout interrupt status. Returns the raw
      --  interrupt state of the UARTRTINTR interrupt. a
      RTRIS          : UARTRIS_RTRIS_Field;
      --  Read-only. Framing error interrupt status. Returns the raw interrupt
      --  state of the UARTFEINTR interrupt.
      FERIS          : UARTRIS_FERIS_Field;
      --  Read-only. Parity error interrupt status. Returns the raw interrupt
      --  state of the UARTPEINTR interrupt.
      PERIS          : UARTRIS_PERIS_Field;
      --  Read-only. Break error interrupt status. Returns the raw interrupt
      --  state of the UARTBEINTR interrupt.
      BERIS          : UARTRIS_BERIS_Field;
      --  Read-only. Overrun error interrupt status. Returns the raw interrupt
      --  state of the UARTOEINTR interrupt.
      OERIS          : UARTRIS_OERIS_Field;
      --  unspecified
      Reserved_11_31 : RP2040.UInt21;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTRIS_Register use record
      RIRMIS         at 0 range 0 .. 0;
      CTSRMIS        at 0 range 1 .. 1;
      DCDRMIS        at 0 range 2 .. 2;
      DSRRMIS        at 0 range 3 .. 3;
      RXRIS          at 0 range 4 .. 4;
      TXRIS          at 0 range 5 .. 5;
      RTRIS          at 0 range 6 .. 6;
      FERIS          at 0 range 7 .. 7;
      PERIS          at 0 range 8 .. 8;
      BERIS          at 0 range 9 .. 9;
      OERIS          at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   subtype UARTMIS_RIMMIS_Field is RP2040.Bit;
   subtype UARTMIS_CTSMMIS_Field is RP2040.Bit;
   subtype UARTMIS_DCDMMIS_Field is RP2040.Bit;
   subtype UARTMIS_DSRMMIS_Field is RP2040.Bit;
   subtype UARTMIS_RXMIS_Field is RP2040.Bit;
   subtype UARTMIS_TXMIS_Field is RP2040.Bit;
   subtype UARTMIS_RTMIS_Field is RP2040.Bit;
   subtype UARTMIS_FEMIS_Field is RP2040.Bit;
   subtype UARTMIS_PEMIS_Field is RP2040.Bit;
   subtype UARTMIS_BEMIS_Field is RP2040.Bit;
   subtype UARTMIS_OEMIS_Field is RP2040.Bit;

   --  Masked Interrupt Status Register, UARTMIS
   type UARTMIS_Register is record
      --  Read-only. nUARTRI modem masked interrupt status. Returns the masked
      --  interrupt state of the UARTRIINTR interrupt.
      RIMMIS         : UARTMIS_RIMMIS_Field;
      --  Read-only. nUARTCTS modem masked interrupt status. Returns the masked
      --  interrupt state of the UARTCTSINTR interrupt.
      CTSMMIS        : UARTMIS_CTSMMIS_Field;
      --  Read-only. nUARTDCD modem masked interrupt status. Returns the masked
      --  interrupt state of the UARTDCDINTR interrupt.
      DCDMMIS        : UARTMIS_DCDMMIS_Field;
      --  Read-only. nUARTDSR modem masked interrupt status. Returns the masked
      --  interrupt state of the UARTDSRINTR interrupt.
      DSRMMIS        : UARTMIS_DSRMMIS_Field;
      --  Read-only. Receive masked interrupt status. Returns the masked
      --  interrupt state of the UARTRXINTR interrupt.
      RXMIS          : UARTMIS_RXMIS_Field;
      --  Read-only. Transmit masked interrupt status. Returns the masked
      --  interrupt state of the UARTTXINTR interrupt.
      TXMIS          : UARTMIS_TXMIS_Field;
      --  Read-only. Receive timeout masked interrupt status. Returns the
      --  masked interrupt state of the UARTRTINTR interrupt.
      RTMIS          : UARTMIS_RTMIS_Field;
      --  Read-only. Framing error masked interrupt status. Returns the masked
      --  interrupt state of the UARTFEINTR interrupt.
      FEMIS          : UARTMIS_FEMIS_Field;
      --  Read-only. Parity error masked interrupt status. Returns the masked
      --  interrupt state of the UARTPEINTR interrupt.
      PEMIS          : UARTMIS_PEMIS_Field;
      --  Read-only. Break error masked interrupt status. Returns the masked
      --  interrupt state of the UARTBEINTR interrupt.
      BEMIS          : UARTMIS_BEMIS_Field;
      --  Read-only. Overrun error masked interrupt status. Returns the masked
      --  interrupt state of the UARTOEINTR interrupt.
      OEMIS          : UARTMIS_OEMIS_Field;
      --  unspecified
      Reserved_11_31 : RP2040.UInt21;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTMIS_Register use record
      RIMMIS         at 0 range 0 .. 0;
      CTSMMIS        at 0 range 1 .. 1;
      DCDMMIS        at 0 range 2 .. 2;
      DSRMMIS        at 0 range 3 .. 3;
      RXMIS          at 0 range 4 .. 4;
      TXMIS          at 0 range 5 .. 5;
      RTMIS          at 0 range 6 .. 6;
      FEMIS          at 0 range 7 .. 7;
      PEMIS          at 0 range 8 .. 8;
      BEMIS          at 0 range 9 .. 9;
      OEMIS          at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   subtype UARTICR_RIMIC_Field is RP2040.Bit;
   subtype UARTICR_CTSMIC_Field is RP2040.Bit;
   subtype UARTICR_DCDMIC_Field is RP2040.Bit;
   subtype UARTICR_DSRMIC_Field is RP2040.Bit;
   subtype UARTICR_RXIC_Field is RP2040.Bit;
   subtype UARTICR_TXIC_Field is RP2040.Bit;
   subtype UARTICR_RTIC_Field is RP2040.Bit;
   subtype UARTICR_FEIC_Field is RP2040.Bit;
   subtype UARTICR_PEIC_Field is RP2040.Bit;
   subtype UARTICR_BEIC_Field is RP2040.Bit;
   subtype UARTICR_OEIC_Field is RP2040.Bit;

   --  Interrupt Clear Register, UARTICR
   type UARTICR_Register is record
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. nUARTRI modem interrupt clear. Clears the UARTRIINTR
      --  interrupt.
      RIMIC          : UARTICR_RIMIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. nUARTCTS modem interrupt clear. Clears the UARTCTSINTR
      --  interrupt.
      CTSMIC         : UARTICR_CTSMIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. nUARTDCD modem interrupt clear. Clears the UARTDCDINTR
      --  interrupt.
      DCDMIC         : UARTICR_DCDMIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. nUARTDSR modem interrupt clear. Clears the UARTDSRINTR
      --  interrupt.
      DSRMIC         : UARTICR_DSRMIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Receive interrupt clear. Clears the UARTRXINTR
      --  interrupt.
      RXIC           : UARTICR_RXIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Transmit interrupt clear. Clears the UARTTXINTR
      --  interrupt.
      TXIC           : UARTICR_TXIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Receive timeout interrupt clear. Clears the UARTRTINTR
      --  interrupt.
      RTIC           : UARTICR_RTIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Framing error interrupt clear. Clears the UARTFEINTR
      --  interrupt.
      FEIC           : UARTICR_FEIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Parity error interrupt clear. Clears the UARTPEINTR
      --  interrupt.
      PEIC           : UARTICR_PEIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Break error interrupt clear. Clears the UARTBEINTR
      --  interrupt.
      BEIC           : UARTICR_BEIC_Field := 16#0#;
      --  Write data bit of one shall clear (set to zero) the corresponding bit
      --  in the field. Overrun error interrupt clear. Clears the UARTOEINTR
      --  interrupt.
      OEIC           : UARTICR_OEIC_Field := 16#0#;
      --  unspecified
      Reserved_11_31 : RP2040.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTICR_Register use record
      RIMIC          at 0 range 0 .. 0;
      CTSMIC         at 0 range 1 .. 1;
      DCDMIC         at 0 range 2 .. 2;
      DSRMIC         at 0 range 3 .. 3;
      RXIC           at 0 range 4 .. 4;
      TXIC           at 0 range 5 .. 5;
      RTIC           at 0 range 6 .. 6;
      FEIC           at 0 range 7 .. 7;
      PEIC           at 0 range 8 .. 8;
      BEIC           at 0 range 9 .. 9;
      OEIC           at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   subtype UARTDMACR_RXDMAE_Field is RP2040.Bit;
   subtype UARTDMACR_TXDMAE_Field is RP2040.Bit;
   subtype UARTDMACR_DMAONERR_Field is RP2040.Bit;

   --  DMA Control Register, UARTDMACR
   type UARTDMACR_Register is record
      --  Receive DMA enable. If this bit is set to 1, DMA for the receive FIFO
      --  is enabled.
      RXDMAE        : UARTDMACR_RXDMAE_Field := 16#0#;
      --  Transmit DMA enable. If this bit is set to 1, DMA for the transmit
      --  FIFO is enabled.
      TXDMAE        : UARTDMACR_TXDMAE_Field := 16#0#;
      --  DMA on error. If this bit is set to 1, the DMA receive request
      --  outputs, UARTRXDMASREQ or UARTRXDMABREQ, are disabled when the UART
      --  error interrupt is asserted.
      DMAONERR      : UARTDMACR_DMAONERR_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : RP2040.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTDMACR_Register use record
      RXDMAE        at 0 range 0 .. 0;
      TXDMAE        at 0 range 1 .. 1;
      DMAONERR      at 0 range 2 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype UARTPERIPHID0_PARTNUMBER0_Field is RP2040.Byte;

   --  UARTPeriphID0 Register
   type UARTPERIPHID0_Register is record
      --  Read-only. These bits read back as 0x11
      PARTNUMBER0   : UARTPERIPHID0_PARTNUMBER0_Field;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTPERIPHID0_Register use record
      PARTNUMBER0   at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTPERIPHID1_PARTNUMBER1_Field is RP2040.UInt4;
   subtype UARTPERIPHID1_DESIGNER0_Field is RP2040.UInt4;

   --  UARTPeriphID1 Register
   type UARTPERIPHID1_Register is record
      --  Read-only. These bits read back as 0x0
      PARTNUMBER1   : UARTPERIPHID1_PARTNUMBER1_Field;
      --  Read-only. These bits read back as 0x1
      DESIGNER0     : UARTPERIPHID1_DESIGNER0_Field;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTPERIPHID1_Register use record
      PARTNUMBER1   at 0 range 0 .. 3;
      DESIGNER0     at 0 range 4 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTPERIPHID2_DESIGNER1_Field is RP2040.UInt4;
   subtype UARTPERIPHID2_REVISION_Field is RP2040.UInt4;

   --  UARTPeriphID2 Register
   type UARTPERIPHID2_Register is record
      --  Read-only. These bits read back as 0x4
      DESIGNER1     : UARTPERIPHID2_DESIGNER1_Field;
      --  Read-only. This field depends on the revision of the UART: r1p0 0x0
      --  r1p1 0x1 r1p3 0x2 r1p4 0x2 r1p5 0x3
      REVISION      : UARTPERIPHID2_REVISION_Field;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTPERIPHID2_Register use record
      DESIGNER1     at 0 range 0 .. 3;
      REVISION      at 0 range 4 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTPERIPHID3_CONFIGURATION_Field is RP2040.Byte;

   --  UARTPeriphID3 Register
   type UARTPERIPHID3_Register is record
      --  Read-only. These bits read back as 0x00
      CONFIGURATION : UARTPERIPHID3_CONFIGURATION_Field;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTPERIPHID3_Register use record
      CONFIGURATION at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTPCELLID0_UARTPCELLID0_Field is RP2040.Byte;

   --  UARTPCellID0 Register
   type UARTPCELLID0_Register is record
      --  Read-only. These bits read back as 0x0D
      UARTPCELLID0  : UARTPCELLID0_UARTPCELLID0_Field;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTPCELLID0_Register use record
      UARTPCELLID0  at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTPCELLID1_UARTPCELLID1_Field is RP2040.Byte;

   --  UARTPCellID1 Register
   type UARTPCELLID1_Register is record
      --  Read-only. These bits read back as 0xF0
      UARTPCELLID1  : UARTPCELLID1_UARTPCELLID1_Field;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTPCELLID1_Register use record
      UARTPCELLID1  at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTPCELLID2_UARTPCELLID2_Field is RP2040.Byte;

   --  UARTPCellID2 Register
   type UARTPCELLID2_Register is record
      --  Read-only. These bits read back as 0x05
      UARTPCELLID2  : UARTPCELLID2_UARTPCELLID2_Field;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTPCELLID2_Register use record
      UARTPCELLID2  at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype UARTPCELLID3_UARTPCELLID3_Field is RP2040.Byte;

   --  UARTPCellID3 Register
   type UARTPCELLID3_Register is record
      --  Read-only. These bits read back as 0xB1
      UARTPCELLID3  : UARTPCELLID3_UARTPCELLID3_Field;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UARTPCELLID3_Register use record
      UARTPCELLID3  at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type UART_Peripheral is record
      --  Data Register, UARTDR
      UARTDR        : aliased UARTDR_Register;
      --  Receive Status Register/Error Clear Register, UARTRSR/UARTECR
      UARTRSR       : aliased UARTRSR_Register;
      --  Flag Register, UARTFR
      UARTFR        : aliased UARTFR_Register;
      --  IrDA Low-Power Counter Register, UARTILPR
      UARTILPR      : aliased UARTILPR_Register;
      --  Integer Baud Rate Register, UARTIBRD
      UARTIBRD      : aliased UARTIBRD_Register;
      --  Fractional Baud Rate Register, UARTFBRD
      UARTFBRD      : aliased UARTFBRD_Register;
      --  Line Control Register, UARTLCR_H
      UARTLCR_H     : aliased UARTLCR_H_Register;
      --  Control Register, UARTCR
      UARTCR        : aliased UARTCR_Register;
      --  Interrupt FIFO Level Select Register, UARTIFLS
      UARTIFLS      : aliased UARTIFLS_Register;
      --  Interrupt Mask Set/Clear Register, UARTIMSC
      UARTIMSC      : aliased UARTIMSC_Register;
      --  Raw Interrupt Status Register, UARTRIS
      UARTRIS       : aliased UARTRIS_Register;
      --  Masked Interrupt Status Register, UARTMIS
      UARTMIS       : aliased UARTMIS_Register;
      --  Interrupt Clear Register, UARTICR
      UARTICR       : aliased UARTICR_Register;
      --  DMA Control Register, UARTDMACR
      UARTDMACR     : aliased UARTDMACR_Register;
      --  UARTPeriphID0 Register
      UARTPERIPHID0 : aliased UARTPERIPHID0_Register;
      --  UARTPeriphID1 Register
      UARTPERIPHID1 : aliased UARTPERIPHID1_Register;
      --  UARTPeriphID2 Register
      UARTPERIPHID2 : aliased UARTPERIPHID2_Register;
      --  UARTPeriphID3 Register
      UARTPERIPHID3 : aliased UARTPERIPHID3_Register;
      --  UARTPCellID0 Register
      UARTPCELLID0  : aliased UARTPCELLID0_Register;
      --  UARTPCellID1 Register
      UARTPCELLID1  : aliased UARTPCELLID1_Register;
      --  UARTPCellID2 Register
      UARTPCELLID2  : aliased UARTPCELLID2_Register;
      --  UARTPCellID3 Register
      UARTPCELLID3  : aliased UARTPCELLID3_Register;
   end record
     with Volatile;

   for UART_Peripheral use record
      UARTDR        at 16#0# range 0 .. 31;
      UARTRSR       at 16#4# range 0 .. 31;
      UARTFR        at 16#18# range 0 .. 31;
      UARTILPR      at 16#20# range 0 .. 31;
      UARTIBRD      at 16#24# range 0 .. 31;
      UARTFBRD      at 16#28# range 0 .. 31;
      UARTLCR_H     at 16#2C# range 0 .. 31;
      UARTCR        at 16#30# range 0 .. 31;
      UARTIFLS      at 16#34# range 0 .. 31;
      UARTIMSC      at 16#38# range 0 .. 31;
      UARTRIS       at 16#3C# range 0 .. 31;
      UARTMIS       at 16#40# range 0 .. 31;
      UARTICR       at 16#44# range 0 .. 31;
      UARTDMACR     at 16#48# range 0 .. 31;
      UARTPERIPHID0 at 16#FE0# range 0 .. 31;
      UARTPERIPHID1 at 16#FE4# range 0 .. 31;
      UARTPERIPHID2 at 16#FE8# range 0 .. 31;
      UARTPERIPHID3 at 16#FEC# range 0 .. 31;
      UARTPCELLID0  at 16#FF0# range 0 .. 31;
      UARTPCELLID1  at 16#FF4# range 0 .. 31;
      UARTPCELLID2  at 16#FF8# range 0 .. 31;
      UARTPCELLID3  at 16#FFC# range 0 .. 31;
   end record;

   UART0_Periph : aliased UART_Peripheral
     with Import, Address => UART0_Base;

   UART1_Periph : aliased UART_Peripheral
     with Import, Address => UART1_Base;

end RP2040.UART;
