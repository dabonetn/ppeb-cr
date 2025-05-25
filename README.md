# ppeb-cr
PPEBcr - Surface Mount version of the PPEB by JasonACT


This is my reversed engineered surface mount version of the Pi Pico PEB.
This project is by JasonACT on Atari Age Forums.


This device must not be sold as a commercial product, it must not be "passed on" with the speech synthesizer enabled (which is GPL code, only owner-builders should enable this).



I know nothing about the software side of this project, I just wanted to make it easier to build.

The RS232 port was not routed on this version of the board, and shares one pin with the reset button and also
a pin with the second PSram, so only the 2mb version supports serial.

If you would like RS232 3.3V Level out, attach to the Pi Pico W pins GP8 for Serial Transmit, and GP9 for Serial Receive.


Here's the link to the forum thread. It contains the actual firmware for the card, and how to use it.

https://forums.atariage.com/topic/358129-pi-picow-peripheral-expansion-box-side-port-device/

I'll work on some docs as I have some time.


Here's the link to the firmware that I've tested with that supports the reset button on this version.

https://forums.atariage.com/topic/358129-pi-picow-peripheral-expansion-box-side-port-device/page/28/#findComment-5639111


I'm using the zip pack of roms from this page of the thread.

https://forums.atariage.com/topic/358129-pi-picow-peripheral-expansion-box-side-port-device/page/28/#findComment-5616188



Kicad Files are in the KiCad Directory, and gerbers/bom/position are in the Production directory under Kicad.

STLs that I used for a case for the Prototype board are in the STL directory, and haven't been tested with the production board.

Here are some of the Features from the PPEB2.INO file.


IMPLEMENTED: (Mostly in the order done)

.Board in the size and shape of a real TI Speech Synthesizer
.Speech Synthesizer implementation using PWM
.32KB Expanded Memory (using Pico memory if desired, but also PSRAM that can implement SAMS, see below...)
.DSR RAM/ROM Memory - 4KB ROM area + 5 * paged 4KB (20KB) RAM areas in >5000=>5FFF
.GRAM/GROM Cartridge + Multi-bank RAM/ROM, E.G. 40KB GROM & 16KB+ ROM (+MiniMem-RAM) +++ PSRAM expands this considerably
.Load   Interrupt Capable (Used to enable the USB subsystem [keyboard & joystick])
.ExtInt Interrupt Capable (Used to enable RS232 non-blocking reads)
.USB Keyboard Interface "<ALT>=" is the normal TI-99 reset, but <CTRL><ALT>DEL can perform a full reset if <ALT>'=' has been locked out,
.USB Keyboard Interface  <CTRL><ALT>F11 is a keyboard to joystick toggle (enables TAB and Arrow keys as a joystick), <CTRL><ALT>F12 is a keyboard-state reset, should keys get stuck
.USB Joystick Interface (4 way Hat switch & 4 buttons + includes 1 analog stick converted to digital)
.USB Mouse interface - TIPI style which can also do Mechatronics style using the available TIPI drivers
.DSK/x - Via the SD Card, including listing directories w/o the 127 file limit
.RAW File read and write support (these work with sectors, but are not direct sector I/O)
.PIO - List to SD Card text-file (/spool.txt)
.Using TCP/IP & standard time-server to set the Pico clock for proper file system timestamps
.SAMS Memory Expansion, using a PSRAM chip, size configurable at build-time
.RS232 - Via Pico's free Serial2 port.  Uses a fixed BAUD rate, see below in the defines, .cfg file can override
.PI.CLOCK - WiFi on the Pico W - Special read-only file (set via a NTP time-server mentioned above) also defined as just 'CLOCK'
.Sockets - WiFi on the Pico W - RS232/2 - port:2322 (Server socket - with single client auto-connect)
.Sockets - WiFi on the Pico W - PI.TCP=... (a single Client-Only socket)
.Sockets - WiFi on the Pico W - Extension-TCP (a single Client-Only socket)
.DSK1 automap when E.G. CALL TIPI("/x/y/DSK1ea/TIEA") loads a module (TI E/A here) from a path with a "last" path component starting with "DSK1" - which gets automapped
.Math Co-Processor implements faster Add (and Sub) Multiply and Divide for Radix-100 floating point numbers (requires USB subsystem)
.PCode Card, with "PCode.ROM", "PCode.GRM" in the SD Card's root, must be 12KB & 62KB (or 64KB) merged G/ROM dumps
.mydisk.DSK sector-dump disk images mapped via CALL MAP1...MAP9 accessed via a special build of the TI Disk Controller Card's DSR ROM (needed for PCode usage, but generally useful)
.(Note 1: The TI Disk Controller Card's DSR requires sector image file names to end with ".DSK" to be properly detected otherwise SD Card directories are assumed)
.(Note 2: Mapping a track-dump .DSK file may [or may not] work but it will be converted to a RAM DISK [read only] but can be converted to a sector dump file by the ",RR" postfix)
.Action-Reply (VDPREGS - because recording them was important to the implementation) <CTRL><ALT>Print-Screen to save, <CTRL><ALT>Win-Menu to restore (Doesn't support SAMS or PCODE)
.Myarc 512KB RAM [switchable] (turns off SAMS to reuse its memory and CRU base - I.E. A Foundation card @ CRU >1E00)
.A USB Memory Stick will mount as a DSK device (DSK3 by default) for a single directory device
.Digi-Port emulation for sound, if the speech synth is enabled
.ForTI sound card emulation using a connected BT speaker
.Bluetooth Gamepads (joystick 1 and 2 specified by the 6 byte BT device address)
.Bluetooth Keyboard & Mouse (ditto^^)

DSR Devices Available...

TI DSR Devices available:
TIPI    - SD card root access
DSK     - SD card root access (allows access to disks via their name, if a directory in SD Root is that name, or a .DSK is mounted)
DSK1    - /DSK1/ SD card access + AUTOMAP (all current maps survive a reset)
...
DSK9    - /DSK9/ SD card access
PIO     - /spool.txt SD card access
PIO/1   - /spool.txt SD card access (same as above)
RS232   - Pico serial port access
RS232/1 - Pico serial port access (same as above)
RS232/2 - Pico tcpip port:2322 access
PI      - Currently, only PI.CLOCK as a read-only file & PI.TCP as a single client socket are implemented
CLOCK   - Same as PI.CLOCK
SOCI    - RS232/2's socket for output, but socket input is directed into the special keyboard CRU input interface (because, why not.)

NB: The single client socket may be used via the TIPI extensions protocol instead (also how the TIPI mouse interface operates).

TI Basic Commands available:
TIPI    - CALL TIPI                 ; Builds a /cat.txt file the first time after power-on (or SD re-mount) and presents a menu to select Cart ROMs that can be loaded, press SPACE for config
TIPI    - CALL TIPI("/cartprefix")  ; Loads GROM/ROM with a cartridge SD card image (C/D/8/-8/_8/_9/G), MAME .ZIP/.RPK (don't type .ext), or EA5 loader (TIFILES & no .ext)
EXPON   - CALL EXPON                ; Turns 32KB expansion memory on
EXPOFF  - CALL EXPOFF               ; Turns 32KB expansion memory off
CARTON  - CALL CARTON               ; Turns Cartridge memory on
CARTOFF - CALL CARTOFF              ; Turns Cartridge memory off
CARTMMO - CALL CARTMMO              ; Turns 8/4KB of cartridge memory into RAM
CARTMMF - CALL CARTMMF              ; Turns off the Mini-Memory RAM mode
JOY0    - CALL JOY0                 ; Joystick keypads are NOT locked out                        [default] : "ALPINER" mode (all directions available)
JOY1    - CALL JOY1                 ; Joystick keypads are locked into 4 directions, newest takes priority : "MUNCHMAN" mode
JOY2    - CALL JOY2                 ; Joystick keypads are locked into 4 directions, oldest takes priority : "PARSEC" mode
JOYOFF  - CALL JOYOFF               ; Stops the CRU interface part of joysticks, allowing the TIPI extension to have full joystick control (more buttons)
MATHON  - CALL MATHON               ; Turns on the math co-processor
MATHOFF - CALL MATHOFF              ; Turns off the math co-processor [default]
PCODEON - CALL PCODEON              ; Turns on the PCode Card - and reboots the TI into PCode mode
PCODEOF - CALL PCODEOF              ; Turns off the PCode Card [default] (to use this, PCode 'H'alt must be used, clearing low-mem would otherwise restart the PCode Card on a reset)
MYARCON - CALL MYARCON              ; Turns SAMS memory into Myarc mode
MYARCOF - CALL MYARCOF              ; Turns off Myarc mode, back to SAMS
UNMOUNT - CALL UNMOUNT              ; Unmounts the SD card so it can be ejected (the next SD Card access re-mounts automatically) - Also saves the bluetooth config
MAP1    - CALL MAP1("/dir")         ; Like DSK1 automap, this allows the user to select the directory mapped to DSK1.  If a path to a .DSK file is entered,
...                                 ; then the custom TI Disk DSR is used for the sector dump file specified.  With 8MB PSRAM, these can all be RAM-read-cached with "xxx.DSK,RC"
MAP9    -                           ; or with "xxx.DSK,RO" can be pre-formatted with the file's data and then used as a true RAM DISK (I.E. fast writes to RAM, but not persistent).
FLUSH   - CALL FLUSH(1)             ; With "xxx.DSK,RO" RAM DISKs, you can write back changed data at a later point in time using CALL FLUSH(drive-number) [but not with BLNK.DSK, see below]
MAPCS1  - CALL MAPCS1("/dir/file")  ; This allows the user to select a TIFILES file mapped for CS1 \_ For the CALL TIPI config menu, use a file extension of ".CS" for easier configuration
MAPCS2  - CALL MAPCS2("/dir/file")  ; This allows the user to select a TIFILES file mapped for CS2 /
PASTE   - CALL PASTE("/dir/file")   ; Pastes from a file, via the keyboard CRU interface, end filename with ":" for USB keyboard <CTRL><ALT>F10 start-signal
FILES   - CALL FILES(3)             ; Only available when the CRU address is defined as >1100

NB: The MAME .ZIP / .RPK archive loader requires about 84KB of free RAM to function properly, making a 2MB/8MB PSRAM chip necessary to free up space (archived files must end with C/D/G/8/9)
NB: The supplied BLNK.DSK is a small 2 sector disk image that can be used with the "BLNK.DSK,RO" command to format a temporary empty 400KB RAM DISK (only ever use ",RO" with this file)
NB: For ",RO" RAM DISKs, MAP1..MAP9 can specify a new DSK file with "xxx.DSK,RR" which will take the existing RAM contents and write ('R'estore) it to the new file (overwrites old files)


The SD Card root file: /autoload.cfg can be used to set start up defaults:
cru_base    "CRU="   (the card offsets starts at >1000, this parameter is a single digit 0-9, A-D [E & F are reserved] - Note: the default CRU base is specified by DSR1_CRU below for >1100)
baudrate    "BAUD="  (override the default single BAUD rate we allow for the RS232 / DEBUG Pico serial port)
wificntrycd "WFCC="  (See below for 2 char codes, do not change this frequently, it will wear out the flash memory page, also requires a power-cycle when first setting up or changing)
wifissid    "WIFI="  (to connect to a WiFi network, this is the network name)
password    "PASS="  (your password)
timeserver  "SNTP="  (where to get the current time from)
timehour    "TZHR="  (timezone hours offset)
timemins    "TZMN="  (timezone minutes offset)
timeformat  "TMFT="  (0=US %m/%d/%y, 1=AUS %d/%m/%y)
map-cs1     "C1MAP="
map-cs2     "C2MAP="
map-dsk1    "D1MAP=" ...
map-dsk9    "D9MAP="
filename    "CART=", "CART2=", "CART3=", etc. to autoload command modules (..2 onwards needs the module library feature enabled)
MM RAM ENAB "MMEM="  (0=off, 1=on, default is off)
MM 8/4K RAM "MMMD="  (0=8KB, 1=4KB, default is 8KB)
pcode-on    "PCODE=" (0=off, 1=on, default is off)
Myarc mode  "MYARC=" (0=off, 1=on, default is off)
Pico Speed  "MHZ="   (The pico starts at a fixed speed [as set in Arduino] but can be dynamically adjusted using this setting - limited to even values between '250' and '280' MHz)
Pico NOPs   "NOPS="  (The number of NOP instructions to use for the delay between a memory access [*MEMEN] and starting to read the address lines - valid value ranges from 1 to 9)
Pico NOPs2  "NOPSW=" (After a write instruction, when the *WE signal goes back to high, this allows different delay time before restarting the loop.. default 5, valid values 1..9)
USB Drive   "USBD="  (If a USB memory stick is inserted, this DSKx number will be temporarily overridden - a value from 1 to 9)
PIO Sound   "PSNDO=" (=1 means turn on this feature)
BT Joystick "BTJ1="  (Specified in the hex format HH:HH:HH:HH:HH:HH  ---> Specifying BTJ1 in the config file prevents a USB GamePad from being Joystick 1)
BT Joystick "BTJ2="  (Specified in the hex format HH:HH:HH:HH:HH:HH)
BT Keyboard "BTKM1=" (Specified in the hex format HH:HH:HH:HH:HH:HH)
BT Mouse    "BTKM2=" (Specified in the hex format HH:HH:HH:HH:HH:HH)
BT5 KeyBd   "BT5KB=" (Specified in the hex format HH:HH:HH:HH:HH:HH)
BT Speaker  "BTSPK=" (Specified in the hex format HH:HH:HH:HH:HH:HH)
ForTI Sound "FORTI=" (Sound gets sent to a BT Speaker - with the following options...
                      =0 off,
                      =1 means one chip emulated    - BT Speaker plays left & right channel in mono the same as the TI,
                      =2 means all 4 chips emulated - BT Speaker plays in stereo,
                      =3 means all 4 chips emulated - BT Speaker plays in mono)
SAMS RAMBO  "RAMBO=" (=1 turns on SAMS RAM at >4000 when no DSR ROM is enabled)
PlayThing   "PLAYT=" (=1 turns on ROM/RAM at CRU >1D00)
