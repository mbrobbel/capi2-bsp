# CAPI2-BSP (CAPI version 2.0 board support)
Create CAPI 2.0 board infrastructure including PSL as IP container for various FPGA-cards.

Depends on PSL sources that can be obtained as zip archive from `<TBD>`

Currently, support for the followig cards is implemented:
* [AD9V3](./AD9V3) (AlphaData 9V3)
* [N250SP](./N250SP) (Nallatech 250S+)

## Creating container via make process
Before creating the CAPI board support IP container, the P9 PSL (PSL9) sources have to be made available for the build process.
This can be done by copying the PSL9 encrypted source file archive to the subdirectory [psl](./psl) (see section [PSL9 IP](#psl9-ip)
for more information on PSL IP generation).
The CAPI board  support IP container for the card with name `<CARD NAME>` can then simply be generated by calling
```
make <CARD NAME>
```
This will automatically create the required PSL9 IP for the card's FPGA chip which will be included in the resulting CAPI
board support IP container
```
<CARD NAME>/build/ip/capi_bsp_wrap.xcix
```

## Adding new cards
In order to add a new card `<NEW CARD>` a new subdirectory has to be created that contains
* a `Makefile` for setting up the card specific environment variables
  (see [AD9V3/Makefile](./AD9V3/Makefile) for an example)
* a subdirectory `src` keeping the capi board support sources
* a subdirectory `tcl` containing at least the following files
  - `add_ip.tcl` to add card specific IP to the `card_board_support` project
  - `add_src.tcl` to add card specific files not contained in `<NEW CARD>/src`
  - `create_ip.tcl` to create the required card specific IP
  - optionally a script `patch_ip.tcl` to apply additional patches
* a subdirectory `xdc` containing card specific constraint files

For examples, please refer to [AD9V3](./AD9V3) or [N250SP](./N250SP).

After creation of the directories and files as described above,
the new card can be enabled by just adding the card to the variable `CARDS`
in the top level [Makefile](./Makefile).

## PSL9 IP
The required PSL9 IP will be generated automatically when creating a CAPI board
support IP container. It is not even necessary to take care of it
in the card specific `create_ip.tcl`. The build scripts for PSL IP generation are
contained in the subdirectory [psl](./psl). The required (encrypted) source files
can be obtained from `<TBD>`.

The build process expects to find the required PSL source files in an archive
* `psl/psl9_encrypted_$(PSL_VERSION).zip`

where `$PSL_VERSION` is an environment variable used by the build process to identify the PSL version.
If that variable is not defined, the default value `2.00` will be assumed, currently.

While it is not necessary to explicitly build the PSL IP for a card, calling
```
make -C <CARD_NAME> psl
```
will build the PSL IP for the FPGA part that belongs to the card with name `<CARD_NAME>`.
