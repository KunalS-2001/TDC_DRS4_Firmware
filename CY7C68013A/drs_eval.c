/********************************************************************\

  Name:         drs_eval.c
  Created by:   Stefan Ritt

  Contents:     Cy7c68013A firmware for DRS4 evaluation board

  $Id: drs_eval.c 18733 2011-12-14 07:57:23Z ritt $

\********************************************************************/

#define ALLOCATE_EXTERN

#include "fx2.h"
#include "fx2regs.h"
#include "intrins.h"

/* Syncronization delay:
   CPU running at 12 MHz
   FIFO running at 30 MHz
   -> 3 CPU cycles
*/
#define SYNCDELAY _nop_( ); _nop_( ); _nop_( )

void config_ep4_ep8()
{
   /* default values for Reset to work */
   SYNCDELAY;
   EP4FIFOCFG = 0x03;

   SYNCDELAY;
   EP8FIFOCFG = 0x03;

   /* Endpoint 4 Configuration
      BULK OUT 512 Bytes
   */
   SYNCDELAY;
   EP4CFG = 0xA0; // equals default

   /* Endpoint 8 Configuration
      BULK IN 512 Bytes
   */
   SYNCDELAY;
   EP8CFG = 0xE0; // equals default

   /* FIFO Reset */
   SYNCDELAY;
   FIFORESET = 0x80; // NAKALL
   SYNCDELAY;
   FIFORESET = 0x84; // Reset EP4
   SYNCDELAY;
   FIFORESET = 0x88; // Reset EP8
   SYNCDELAY;
   FIFORESET = 0x00; // Normal operation

   /* Flags definition:
      FLAGA is progammed level flag
      FLAGB is full flag
      FLAGC is empty flag
   */
   PINFLAGSAB = 0x00;
   PINFLAGSCD = 0x00;

   /* set all FIFO interface pins as active low */
   SYNCDELAY;
   FIFOPINPOLAR = 0x00;

   /* EZ-USB automatically commits data in 512-byte chunks */
   SYNCDELAY;
   EP8AUTOINLENH = 0x02; // equals default
   SYNCDELAY;
   EP8AUTOINLENL = 0x00; // equals default

   /* arm EP4 OUT buffer with SKIP=1 */
   SYNCDELAY;
   OUTPKTEND = 0x84; // first buffer
   SYNCDELAY;
   OUTPKTEND = 0x84; // second buffer

   /* Endpoint 4 FIFO configuration
                  0    dummy
      INFM1     = 0    "IN Full Minus One" off
      OEP1      = 0    "OUT Empty Plus One" off
      AUTOOUT   = 1    Automatically commit OUT packets
      AUTOIN    = 0    Automatically commit IN packets off
      ZEROLENIN = 0    Disable zero length packets
                  0    dummy
      WORDWIDE  = 1    Use word wide FIFO
   */
   SYNCDELAY;
   EP4FIFOCFG = 0x11;

   /* Endpoint 8 FIFO configuration
                  0    dummy
      INFM1     = 0    "IN Full Minus One" off
      OEP1      = 0    "OUT Empty Plus One" off
      AUTOOUT   = 0    Automatically commit OUT packets off
      AUTOIN    = 1    Automatically commit IN packets
      ZEROLENIN = 1    Disable zero length packets
                  0    dummy
      WORDWIDE  = 1    Use word wide FIFO
   */
   SYNCDELAY;
   EP8FIFOCFG = 0x0D;
}

main()
{
   /* Configure interface:
      IFCLKSDRC = 1    use internal FIFO clock
      3048MHZ   = 0    select internal 30 MHz clock
      IFCLKOE   = 1    enable IFCLK pin output
      IFCLKPOL  = 0    do not invert clock
      ASYNC     = 0    use synchronous mode
      GSTATE    = 0    do not output GSTATE bits
      IFCFG1:0  = 11   select slave FIFO interface
   */
   IFCONFIG = 0xA3;
   
   /* Chip revision control
      DYN_OUT   = 1    endpoints are not auto-armed on AUTOOUT transitions
      ENH_PKT   = 1    enable CPU enhanced packet handling
   */
   SYNCDELAY;
   REVCTL = 0x03;

   config_ep4_ep8();

   // set LED port to output
   OEA = 0x01;
   // turn on LED
   PA0 = 1;

   // set the CPU clock to 48MHz
   // CPUCS = ((CPUCS & ~bmCLKSPD) | bmCLKSPD1) ;
   
   // set RENUM = 0 to let EZ-USB handle all traffic
   USBCS &=!bmRENUM;

   while (1) {
      SYNCDELAY;
      EP1OUTBC = 1; // arm EP1 to receive data
      while (EP1OUTCS & bmBIT1); // wait until data available
      PA0 = EP1OUTBUF[0];

      /* echo back data */
      /*
      EP1INBUF[0] = EP1OUTBUF[0] + 1;

      SYNCDELAY;
      EP1INBC = 1; // arm EP1 to send data
      while (EP1INCS & bmBIT1);  // wait until host has read data
      */
          
      config_ep4_ep8();
   }

   while (1);
}

