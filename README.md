# ppeb-cr
PPEBcr - Surface Mount version of the PPEB by JasonACT

This is my reversed engineered surface mount version of the Pi Pico PEB.
This project is by JasonACT on Atari Age Forums.

## Project Overview <a name="project-overview"></a>

---

[**PPEB**] is a fully integrated, all-in-one expansion solution for the TI-99/4A home computer.  
Built around the Raspberry Pi Pico W, it recreates multiple expansion cards and peripherals inside one modern sideport device:

- Speech Synthesizer (PWM Emulated)
- 32K RAM Expansion
- SAMS Memory (2MB/8MB PSRAM)
- Myarc RAM (512K)
- Cartridge GROM/GRAM loader
- Disk Controller with .DSK sector image support
- IDE Hard Disk Emulation via USB stick
- RS232 Serial Support (3.3V or TCP/IP socket)
- TIPI Extensions Compatibility
- USB Keyboard, Mouse, Joystick, Bluetooth HID support
- Math Co-Processor for accelerated floating-point math
- Digi-Port 8-bit audio output support
- RS232 Support is provided via the Pico W's second UART at 3.3V logic levels. Not compatible with 8MB memory for Sams.
  
<br>

## Safety Warnings <a name="safety-warnings"></a>

> **IMPORTANT — READ BEFORE USING OR BUILDING:**

- ⚠️ **Never power the PPEB through USB while it is connected to your TI-99/4A.**  
  The device draws power directly from the TI sideport. USB power while inserted can cause hardware damage.
  
- ⚠️ **Always power down the TI-99/4A before inserting or removing the PPEB.**  
  Repeated insertion/removal while powered on can damage TI-99 side port buffer chips.

- ⚠️ **The QI (Quality Improved) model of the TI-99/4A is not supported without hardware modifications.**  
  This is a TI motherboard limitation: QI units block GROM access on the side port, which is required for cartridge emulation.



- 🛠 **Power Supply Stability:**  
  TI-99/4A power supply health is critical to PPEB stability.  
  Many random lockups have been traced to marginal regulators or aged power bricks.  
  If experiencing intermittent behavior, verify or recap your TI power supply.



---

If you get one of my unbuilt boards, or had them made from the original release, remove capacitor c4. This fixes compatibility with a lot of microsd cards.

IF YOU HAVE A HARDWARE ISSUES WITH THE SMD BOARD OPEN A ISSUE HERE!
DO NOT BUG JASONACT about my board design.


The main usage support for this board for a software standpoint is from the Atariage forum. I'm a hardware guy, and I like building things, the software, not so much.

Links.

[Main AtariAge forum thread.](https://forums.atariage.com/topic/358129-pi-picow-peripheral-expansion-box-side-port-device/)

[Online PPEB guide, including how to build and general usage.](https://github.com/hexbus/ppebcr-docs)



This device must not be sold as a commercial product, it must not be "passed on" with the speech synthesizer enabled (which is GPL code, only owner-builders should enable this).



I know nothing about the software side of this project, I just wanted to make it easier to build.


[Firmware I've been using currently, it isn't the latest, but works to start](https://forums.atariage.com/topic/358129-pi-picow-peripheral-expansion-box-side-port-device/page/28/#findComment-5639111)


[Sample pack of Rom Images with a config file for the PPEB that support the reset button firmware listed above.](https://forums.atariage.com/topic/358129-pi-picow-peripheral-expansion-box-side-port-device/page/28/#findComment-5616188)





Kicad Files are in the KiCad Directory, and gerbers/bom/position are in the Production directory under Kicad.

STLs that I used for a case for the Prototype board are in the STL directory, and haven't been tested with the production board.

