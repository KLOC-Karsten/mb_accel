# mb_accel
Utility to detect the accelerometer of a micro:bit board.


## Background

The BBC micro:bit board contains - depending on the hardware revision - one of
three different motion sensors: either the Freescale MMA8653FC (rev 1.3),
the ST LSM303AGR (rev 1.5),
or the NXP FXOS8700 (rev 1.5).
See also [this page](https://tech.microbit.org/hardware/).

Currently, the [Ada Drivers Library](https://github.com/AdaCore/Ada_Drivers_Library)
contains only the code for the MMA8653 motion sensor.
Even worse, your application will crash if your micro:bit contains the
LSM303 sensor and you use the MicroBit.Accelerometer package, because it
automatically tries to configure an MMA8653!
This library contains a simple routine to detect the motion sensor
of your micro:bit.



## Usage

Use the library together with the Ada Drivers Library micro:bit BSP-
Example: 

        if MB_Accel.Detect_Accelerometer(MicroBit.I2C.Controller) = MB_Accel.LSM303 then
          ...
        end if;
