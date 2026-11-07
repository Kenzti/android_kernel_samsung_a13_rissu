### AnyKernel3 Ramdisk Mod Script
### Modified by @RissuDesu & @hlprx49 & @pkenti
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Linux version 4.19.325-pkenti (ken@debian) (Debian clang version 19.1.7 (3+b1), Debian LLD 19.1.7)
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=1
device.name1=a13nsxx
device.name2=a13ub
device.name3=a12snsxx
device.name4=a04snsxx
device.name5=a04sub
device.name6=a12sub
device.name7=a21snsxx
device.name8=a13
device.name9=a12s
device.name10=a04s
device.name11=a21s
device.name12=a21sub
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
# dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk
split_boot;
# write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
flash_boot;
## end boot install

#! ~ Warning !!
#/- [ "a12snsxx" because of the A12s port for A13, but don't flash in the real A12s.
#/- "a04s**" because of the A04s vendor port for A13, but don't flash in the real A04s. >
#/- "a21s**" because of the A21s vendor port for A13, but don't flash in the real A21s. ]
