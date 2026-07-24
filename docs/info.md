<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The AES 256 cryptography engine encrypts/decrypts strings of 128 bit data at a time using a 256 bit key.
It communicates over SPI at a speed of 60MHz acting as a slave receiver.

All 14 rounds of encryption/decryption are done by the ASIC, including generation of round keys.

Communication is done over SPI using certain 8 bit command words as follows :

## How to test

Explain how to use your project

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
