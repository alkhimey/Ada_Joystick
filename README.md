# Ada Joystick

Thick bindings for [linux joystick driver](https://www.kernel.org/doc/Documentation/input/joystick-api.txt).

## Using

Instansiate `Linux_Joystick` package with two generic type parameters. 
The first type, `Axis_Type` should represent the available axes of the specific joystick and the second type, `Button_Type` should represent buttons.

It is possible to use any scalar, as long as it is limited by 8 bits. For example

```Ada
   type Common_Axis_Type is range 0..20;
   type Common_Button_Type is range 0..20;
   package JS is new Linux_Joystick(Button_Type => Common_Button_Type,
                                     Axis_Type  => Common_Axis_Type);
```

## Example

A main.adb file is provided with an example of how to use the bindings with _Logitech Extreme 3D Pro_ joystick.

### Build the example

```bash
gprbuild -Pada_joystick.gpr --create-missing-dirs
```

### Run the example

```bash
./bin/main
```

![Screenshot of example](example.png)

