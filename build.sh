#!/bin/bash

echo "Bootloader - Builder started !..."


# Ziel-Verzeichnis
BASE_DIR="rpi_firmware"
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

# GitHub-RAW-Basis für Dateien (main branch)
BASE_URL="https://raw.githubusercontent.com/raspberrypi/firmware/master/boot"

# Funktion zum Herunterladen von Dateien mit wget
download_file() {
    local url=$1
    local dest=$2
    echo "-> Downloading $url"
    wget -q --show-progress "$url" -O "$dest"
}

# Funktion zum Herunterladen von Ordnern wie overlays/
download_overlay_dir() {
    local dest_dir=$1
    mkdir -p "$dest_dir"
    echo "-> Downloading overlay .dtb files..."
    # Liste an gängigen .dtb Overlays, die meist vorhanden sind
    overlays=( "vc4-kms-v3d.dtbo" "disable-bt.dtbo" "disable-wifi.dtbo" "i2c-rtc.dtbo" )
    for overlay in "${overlays[@]}"; do
        download_file "$BASE_URL/overlays/$overlay" "$dest_dir/$overlay"
    done
}

# Raspberry Pi 3
mkdir -p rpi3
cd rpi3
files3=( bootcode.bin fixup.dat start.elf config.txt kernel8.img cmdline.txt )
for f in "${files3[@]}"; do
    download_file "$BASE_URL/$f" "$f"
done
download_overlay_dir "overlays"
# Beispiel für .dtb-Dateien für Pi 3
download_file "$BASE_URL/bcm2710-rpi-3-b.dtb" "bcm2710-rpi-3-b.dtb"
cd ..

# Raspberry Pi 4
mkdir -p rpi4
cd rpi4
files4=( fixup4.dat start4.elf config.txt kernel8.img cmdline.txt )
for f in "${files4[@]}"; do
    download_file "$BASE_URL/$f" "$f"
done
download_overlay_dir "overlays"
download_file "$BASE_URL/bcm2711-rpi-4-b.dtb" "bcm2711-rpi-4-b.dtb"
cd ..

# Raspberry Pi 5
mkdir -p rpi5
cd rpi5
files5=( fixup.dat start.elf config.txt kernel8.img cmdline.txt )
for f in "${files5[@]}"; do
    download_file "$BASE_URL/$f" "$f"
done
download_overlay_dir "overlays"
download_file "$BASE_URL/bcm2712-rpi-5-b.dtb" "bcm2712-rpi-5-b.dtb"
cd ..

echo "✅ Alle Dateien wurden erfolgreich heruntergeladen."
