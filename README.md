# ARM Bare Metal Development Environment

This repo contains a Dockerfile that will provide a basic development environment suitable to assemble/link simple ARM assembly language source files written for the GNU tool chain.

It also includes the lastest version of Go because the Golang toolchain can use GCC to compile in and link ARM assembly language files and will produce an ARM executable image.

The goal is to be able to write small ARM assembly language routines and unit test them using Go as a high-level language. An example is included from an assignment I was given for the ECE 371 class at Portland State University

## Building

Just run:

```
# docker build .
``` 

in the repo directory

## Building the Example

The example assembly language source files are located in `project1.s`, `lib/avg_temps.s` and `lib/min_max.s`. The assembly source to the actual file I turned in is located in the `./assignment` directory. 

To build the Go unit test which will pull in the assembly sources from `project1.s`, just run:

`CC=arm-linux-gnueabi-gcc CGO_ENABLED=1 GOARM=7 GOARCH=arm go build -ldflags '-extldflags "-static"' -o project1_test`

This will produce a build artifact called `project_test` that is an ARM executable image:

```
# file project1_test
project1_test: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=da756cd1216fcbc43d9f2acdf245787be9091d59, not stripped
```

## Running ARM images

The container also includes [qemu](https://www.qemu.org/) which transparantly performs translation on the ARM executable and runs it. To run the unit tests, just execute the image, as you would any other:

```
# ./project1_test
Test all zeros pass
Test all 125s pass
Test 1-16 ascending pass
Test all zeros + 1 pass
Test all zeros + 125 pass
Test all zeros + 1 and 125 pass
Test first value 125 pass
All tests pass
```

## Assembling / Linking just the assembly

To build an executable image from just the assembly language sources use the GNU assembler and linker:

```
# arm-linux-gnueabi-as -o part_one.o part_one.s
```

then

```
# arm-linux-gnueabi-ld -o part_one  part_one.o
```

This will produce an ARM executable, but it will probably segfault when it runs because it's running on bare metal, and doesn't have an OS to return to. 


## Debugging with GDB and qemu

GDB can debug ARM executables in linux with qemu, but it is a two-step process that requires a client and server. First, start the executable with qemu:

```
# qemu-arm -singlestep -g 1234 part_one
```

Then, start another window inside the docker container with `docker exec -it <container_id> /bin/bash`

At the prompt, change to the assignment directory, start the debugger and connect to the qemu-process we started above:

```
# gdb-multiarch part_one
Reading symbols from part_one...done.
(gdb) target remote localhost:1234
Remote debugging using localhost:1234
_start () at part_one.s:22
22	_start:           LDR   R0,   =Fahrenheit_Temps   @  Entrypoint
(gdb) list
17	                                                  @
18	.global _start                                    @  Define our _start global
19	.equ    TEMP_COUNT, 0x10                          @  Constant that holds the number of timeslices we're dealing with
20	                                                  @    - 16 in this case.
21	                                                  @
22	_start:           LDR   R0,   =Fahrenheit_Temps   @  Entrypoint
23	                  LDR   R1,   =Temp_Avg           @  Load R1 with addr of our temp timeslices
24	                  LDR   R6,   =TEMP_COUNT         @  Load R6 counter with length of timeslice array
25	                  MOV   R7,   #0                  @  Initialize R7 as accumulator
26	                                                  @
```

From here, you can use gdb as normal to step though the program or whatever.