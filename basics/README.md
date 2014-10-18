# Introduction #

In this README I try to collect some of the most basic informations.
I am working with the B revision of the Raspberry Pi.

# Raspberry Pi GPIOs #

| Function | PIN# | PIN# | Function |
| -------- | :----: | :----: | -------- |
| 3V3      |    1 |    2 | 5V       |
| GPIO2    |    3 |    4 | 5V       |
| GPIO3    |    5 |    6 | GND      |
| GPIO4    |    7 |    8 | GPIO14   |
| GND      |    9 |   10 | GPIO15   |
| GPIO17   |   11 |   12 | GPIO18   |
| GPIO27   |   13 |   14 | GND      |
| GPIO22   |   15 |   16 | GPIO23   |
| 3V3      |   17 |   18 | GPIO24   |
| GPIO10   |   19 |   20 | GND      |
| GPIO9    |   21 |   22 | GPIO25   |
| GPIO11   |   23 |   24 | GPIO8    |
| GND      |   25 |   26 | GPIO7    |

# Activate a GPIO #

As root, if you want to activate GPIO7 (which is PIN26), run this command:
```
echo 7 > /sys/class/gpio/export
```

This will create a directory /sys/class/gpio/gpio7 which contains some files
important to control the GPIO.
Activating a GPIO is also possible through the GPIOwizard.

# Configure a GPIO as Input or Output #

We use again GPIO07 as example. First, we check if GPIO7 is configured as a
input or output, we run this command:
```
cat /sys/class/gpio/gpio7/direction
```

This will output either "in" for "input" (which is default after activating) or
"out" for "output".

If we want to configure the GPIO07 as an output we use:
```
echo "out" > /sys/class/gpio/gpio7/direction
```

That was easy. We just write "out" or "in" to this file and the GPIO is
configured accordingly.
Configuring a GPIO as input or output is also possible through the GPIOwizard.

# Setting a GPIO output to high or low #

We use again GPIO07 as example. First, we check what value GPIO7 has currently,
if it is high or low:
```
cat /sys/class/gpio/gpio7/value
```

This will output either "0" for "low" (which is default) or "1" for "high".

If we want GPIO07 to be "high" we use:
```
echo "1" > /sys/class/gpio/gpio7/value
```

That was easy. We just write "0" or "1" to this file and the GPIO is
configured accordingly.

