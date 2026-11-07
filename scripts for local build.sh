#!/bin/bash

read -p "KernelSU (backslashxx): [b] Delete & Reinstall  [u] Update  [s] Skip: " choice

if [[ "$choice" =~ ^[bB]$ ]]; then
    rm -rf KernelSU
    curl -LSs "https://raw.githubusercontent.com/backslashxx/KernelSU/master/kernel/setup.sh" | bash -s master
elif [[ "$choice" =~ ^[sS]$ ]]; then
    echo "Skip KernelSU."
elif [ -d KernelSU/.git ]; then
    git -C KernelSU fetch origin master && git -C KernelSU reset --hard origin/master
else
    echo "[!] KernelSU is not installed or the .git file is missing. Select 'b' to perform a fresh installation."
fi

export KERNEL_ROOT="$(pwd)"

SFX_SUCCESS="/usr/share/sounds/ocean/stereo/outcome-success.oga"
SFX_ERROR="/usr/share/sounds/ocean/stereo/outcome-failure.oga"

play_sfx() {
    paplay "$1" &
}

# Build options for the kernel
export BUILD_OPTIONS="
ARCH=arm64 \
LLVM=1 \
LLVM_IAS=1 \
KCFLAGS=-w \
PLATFORM_VERSION=14 \
ANDROID_MAJOR_VERSION=14 \
KBUILD_BUILD_USER=ken \
KBUILD_BUILD_HOST=pkenti
"

build_kernel(){
    # Make default configuration.
    make ${BUILD_OPTIONS} -j$(nproc --all) exynos850-a13nsxx_defconfig

    # make ${BUILD_OPTIONS} -j$(nproc --all) menuconfig

    # Build the kernel
    make ${BUILD_OPTIONS} -j$(nproc --all) Image dtbs 2>&1 | tee "${KERNEL_ROOT}/build.log"
if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    play_sfx "$SFX_ERROR"
    exit 1
fi

    echo "[+] Creating dtb.img..."
MKDTBOIMG="$(find . -name "mkdtboimg.py" | head -n 1)"
IN_DTB="${KERNEL_ROOT}/arch/arm64/boot/dts/exynos/exynos3830.dtb"
OUT_DTBIMAGE="${KERNEL_ROOT}/dtb.img"

if [ -f "$IN_DTB" ] && [ -f "$MKDTBOIMG" ]; then
    python3 "$MKDTBOIMG" create $OUT_DTBIMAGE --custom0=0x00000000 --custom1=0xff000000 --version=0 --page_size=2048 "$IN_DTB"
    echo "[+] The dtb.img file has been successfully created."
else
    echo "[!] Warning: No DTB file or mkdtboimg.py tool found!"
fi

    # Copy the built kernel to the build directory
if [ -e ${KERNEL_ROOT}/arch/arm64/boot/Image ]; then
    cp ${KERNEL_ROOT}/arch/arm64/boot/Image AnyKernel3

if [ -f $OUT_DTBIMAGE ]; then
    cp $OUT_DTBIMAGE AnyKernel3
fi

    echo "[+] Packaging kernel ..."
    cd AnyKernel3 && rm -f *.zip
    zip -r9 A135F-Surge.zip *
    echo "[-] Package done!"
    echo "Cleaning..." && cd "$KERNEL_ROOT" && make clean && make mrproper
    play_sfx "$SFX_SUCCESS"
else
    play_sfx "$SFX_ERROR"
    exit 1
fi
}
build_kernel
