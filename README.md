# [#] +++ Raspberry Pi - (3-5) - Bootfiles +++ [#] #



# Raspberry Pi 3 #

```md
Datei	Funktion
bootcode.bin	Initialer Bootloader (nur bei älteren RPi-Modellen relevant, Pi 3 hat oft eigene ROM-Firmware)
start.elf	GPU-Firmware und sekundärer Bootloader
fixup.dat	Passende Konfigurationsdaten zur start.elf
config.txt	Konfigurationsdatei für Firmware (z. B. Speicher, Auflösung, Kernelpfad)
kernel8.img	AArch64 (64-bit) Linux-Kernel oder U-Boot-Binary
cmdline.txt	Startparameter für den Kernel
*.dtb	Device Tree Blob (z. B. bcm2837-rpi-3-b.dtb)

Optional, wenn notwendig:

    overlays/*.dtbo – Device Tree Overlays

    kernel7.img – für 32-bit ARMv7 Kernel

    kernel.img – Fallback (älterer Name)

/boot/
├── bootcode.bin         # (oft nicht notwendig bei RPi 3)
├── start.elf
├── fixup.dat
├── config.txt
├── kernel8.img          # Hier liegt u-boot.bin oder Linux-Kernel
├── bcm2837-rpi-3-b.dtb  # Device Tree für RPi 3B
├── cmdline.txt



    ```

# Raspberry Pi 4b #
```md

✅ Notwendige Boot-Dateien für Raspberry Pi 4B (64-bit)
Datei	Funktion
start4.elf	GPU-Firmware und sekundärer Bootloader (für Pi 4)
fixup4.dat	Passende Konfigurationsdaten zur start4.elf
config.txt	Konfigurationsdatei (z. B. arm_64bit=1, Pfad zum Kernel, etc.)
kernel8.img	AArch64-Kernel (oder U-Boot Image)
bcm2711-rpi-4-b.dtb	Device Tree für Raspberry Pi 4B
cmdline.txt	Kernel-Boot-Parameter
overlays/*.dtbo	(Optional) Device Tree Overlays


/boot/
├── start4.elf
├── fixup4.dat
├── config.txt
├── kernel8.img                # U-Boot oder Kernel
├── bcm2711-rpi-4-b.dtb
├── cmdline.txt
└── overlays/
    └── *.dtbo

```



# Raspberry Pi 5 #
```md
Datei	Funktion
start4.elf	GPU-Firmware und sekundärer Bootloader
fixup4.dat	Passende Fixup-Daten zur start4.elf
config.txt	Konfiguration: 64-bit Modus, Kernelname, Device Tree usw.
kernel8.img	64-Bit Linux-Kernel oder U-Boot-Binary
bcm2712-rpi-5-b.dtb	Device Tree für Raspberry Pi 5
cmdline.txt	Kernel-Bootparameter (z. B. Root-Device)
overlays/*.dtbo	(Optional) Device Tree Overlays

❌ bootcode.bin ist nicht mehr erforderlich – der Bootloader liegt im SPI-EEPROM ab Werk.

/boot/
├── start4.elf
├── fixup4.dat
├── config.txt
├── kernel8.img                   # Linux-Kernel oder U-Boot-Binary
├── bcm2712-rpi-5-b.dtb
├── cmdline.txt
└── overlays/
    └── *.dtbo


    
```





```md

Der **Raspberry Pi 3** benötigt beim Booten von einer SD-Karte (im Standardmodus, also ohne U-Boot oder Bare-Metal) folgende **Boot-Dateien** im **/boot-Verzeichnis** der **ersten FAT32-Partition**:

---

## 📂 **Minimal notwendige Boot-Dateien für den Raspberry Pi 3**

| Datei          | Funktion                                                                                       |
| -------------- | ---------------------------------------------------------------------------------------------- |
| `bootcode.bin` | Initialer Bootloader (nur bei älteren RPi-Modellen relevant, Pi 3 hat oft eigene ROM-Firmware) |
| `start.elf`    | GPU-Firmware und sekundärer Bootloader                                                         |
| `fixup.dat`    | Passende Konfigurationsdaten zur `start.elf`                                                   |
| `config.txt`   | Konfigurationsdatei für Firmware (z. B. Speicher, Auflösung, Kernelpfad)                       |
| `kernel8.img`  | **AArch64 (64-bit) Linux-Kernel oder U-Boot-Binary**                                           |
| `cmdline.txt`  | Startparameter für den Kernel                                                                  |
| `*.dtb`        | Device Tree Blob (z. B. `bcm2837-rpi-3-b.dtb`)                                                 |

Optional, wenn notwendig:

* `overlays/*.dtbo` – Device Tree Overlays
* `kernel7.img` – für 32-bit ARMv7 Kernel
* `kernel.img` – Fallback (älterer Name)

---

## 🧠 **Beispielhafte minimalistische /boot-Partition für Raspberry Pi 3 (64-bit U-Boot)**

```
/boot/
├── bootcode.bin         # (oft nicht notwendig bei RPi 3)
├── start.elf
├── fixup.dat
├── config.txt
├── kernel8.img          # Hier liegt u-boot.bin oder Linux-Kernel
├── bcm2837-rpi-3-b.dtb  # Device Tree für RPi 3B
├── cmdline.txt
```

---

## 📝 Beispiel `config.txt` für U-Boot (64-bit)

```ini
arm_64bit=1
enable_uart=1
kernel=kernel8.img
device_tree=bcm2837-rpi-3-b.dtb
```

---

## 📝 Beispiel `cmdline.txt` für Linux (RootFS auf 2. Partition)

```txt
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 fsck.repair=yes rootwait
```

---

## 📌 Hinweis zu Boot-Reihenfolge auf dem RPi 3

1. Die Boot-ROM lädt **start.elf** (GPU-Firmware)
2. **start.elf** liest `config.txt` → lädt `kernel*.img`
3. Wird `kernel8.img` verwendet und `arm_64bit=1` gesetzt, wird ein **AArch64 Kernel oder U-Boot** geladen
4. Optional: lädt `*.dtb` und `cmdline.txt`

---

Möchtest du damit **direkt ein Linux-RootFS booten** oder zuerst **U-Boot starten** und dann Linux laden (per `boot.scr`, extlinux oder manuell)?


Der **Raspberry Pi 4B** hat eine leicht andere Bootarchitektur als der Pi 3 – er verwendet ein **richtiges EEPROM** mit eigenem Bootloader und braucht deshalb **nicht mehr unbedingt** `bootcode.bin`. Dennoch braucht er einige Firmwaredateien auf der **/boot-Partition (FAT32)**.

---

## ✅ **Notwendige Boot-Dateien für Raspberry Pi 4B (64-bit)**

| Datei                 | Funktion                                                         |
| --------------------- | ---------------------------------------------------------------- |
| `start4.elf`          | GPU-Firmware und sekundärer Bootloader (für Pi 4)                |
| `fixup4.dat`          | Passende Konfigurationsdaten zur `start4.elf`                    |
| `config.txt`          | Konfigurationsdatei (z. B. `arm_64bit=1`, Pfad zum Kernel, etc.) |
| `kernel8.img`         | AArch64-Kernel (oder U-Boot Image)                               |
| `bcm2711-rpi-4-b.dtb` | Device Tree für Raspberry Pi 4B                                  |
| `cmdline.txt`         | Kernel-Boot-Parameter                                            |
| `overlays/*.dtbo`     | (Optional) Device Tree Overlays                                  |

> ❌ `bootcode.bin` ist beim Pi 4 **nicht mehr nötig**, da er direkt vom EEPROM booten kann.

---

## 📁 **Beispiel-Inhalt der /boot-Partition für RPi 4B (64-bit, U-Boot oder Linux direkt)**

```
/boot/
├── start4.elf
├── fixup4.dat
├── config.txt
├── kernel8.img                # U-Boot oder Kernel
├── bcm2711-rpi-4-b.dtb
├── cmdline.txt
└── overlays/
    └── *.dtbo
```

---

## 📝 Beispiel `config.txt` (für 64-bit Linux oder U-Boot)

```ini
arm_64bit=1
enable_uart=1
kernel=kernel8.img
device_tree=bcm2711-rpi-4-b.dtb
```

---

## 📝 Beispiel `cmdline.txt` (für Linux mit RootFS auf 2. Partition)

```txt
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait
```

---

## ℹ️ Boot-Reihenfolge Raspberry Pi 4B

1. EEPROM lädt von SD/USB: `/boot/start4.elf`
2. `start4.elf` liest `config.txt`
3. Lädt `kernel8.img`, `*.dtb`, `cmdline.txt`
4. Startet Kernel (oder U-Boot, wenn `kernel8.img = u-boot.bin`)

---

## ❗ Wichtig bei U-Boot:

Wenn du **U-Boot** als Bootloader nutzen willst, speichere dein `u-boot.bin` einfach als:

```bash
/boot/kernel8.img
```

> U-Boot übernimmt dann das weitere Laden von Kernel + Initramfs (über extlinux, boot.scr oder Script).

---

Möchtest du den Raspberry Pi 4B mit U-Boot + einem minimalistischen Arch/Buildroot-RootFS starten? Dann zeige ich dir den vollständigen Flow.

Der **Raspberry Pi 4B** hat eine leicht andere Bootarchitektur als der Pi 3 – er verwendet ein **richtiges EEPROM** mit eigenem Bootloader und braucht deshalb **nicht mehr unbedingt** `bootcode.bin`. Dennoch braucht er einige Firmwaredateien auf der **/boot-Partition (FAT32)**.

---

## ✅ **Notwendige Boot-Dateien für Raspberry Pi 4B (64-bit)**

| Datei                 | Funktion                                                         |
| --------------------- | ---------------------------------------------------------------- |
| `start4.elf`          | GPU-Firmware und sekundärer Bootloader (für Pi 4)                |
| `fixup4.dat`          | Passende Konfigurationsdaten zur `start4.elf`                    |
| `config.txt`          | Konfigurationsdatei (z. B. `arm_64bit=1`, Pfad zum Kernel, etc.) |
| `kernel8.img`         | AArch64-Kernel (oder U-Boot Image)                               |
| `bcm2711-rpi-4-b.dtb` | Device Tree für Raspberry Pi 4B                                  |
| `cmdline.txt`         | Kernel-Boot-Parameter                                            |
| `overlays/*.dtbo`     | (Optional) Device Tree Overlays                                  |

> ❌ `bootcode.bin` ist beim Pi 4 **nicht mehr nötig**, da er direkt vom EEPROM booten kann.

---

## 📁 **Beispiel-Inhalt der /boot-Partition für RPi 4B (64-bit, U-Boot oder Linux direkt)**

```
/boot/
├── start4.elf
├── fixup4.dat
├── config.txt
├── kernel8.img                # U-Boot oder Kernel
├── bcm2711-rpi-4-b.dtb
├── cmdline.txt
└── overlays/
    └── *.dtbo
```

---

## 📝 Beispiel `config.txt` (für 64-bit Linux oder U-Boot)

```ini
arm_64bit=1
enable_uart=1
kernel=kernel8.img
device_tree=bcm2711-rpi-4-b.dtb
```

---

## 📝 Beispiel `cmdline.txt` (für Linux mit RootFS auf 2. Partition)

```txt
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait
```

---

## ℹ️ Boot-Reihenfolge Raspberry Pi 4B

1. EEPROM lädt von SD/USB: `/boot/start4.elf`
2. `start4.elf` liest `config.txt`
3. Lädt `kernel8.img`, `*.dtb`, `cmdline.txt`
4. Startet Kernel (oder U-Boot, wenn `kernel8.img = u-boot.bin`)

---

## ❗ Wichtig bei U-Boot:

Wenn du **U-Boot** als Bootloader nutzen willst, speichere dein `u-boot.bin` einfach als:

```bash
/boot/kernel8.img
```

> U-Boot übernimmt dann das weitere Laden von Kernel + Initramfs (über extlinux, boot.scr oder Script).

---

Möchtest du den Raspberry Pi 4B mit U-Boot + einem minimalistischen Arch/Buildroot-RootFS starten? Dann zeige ich dir den vollständigen Flow.


Gute Frage – die Kurzantwort: **Nein**, beim Raspberry Pi 4B sollte man **`kernel8.img`** verwenden, nicht `kernel7.img` – **wenn du 64-Bit booten willst**, was heute Standard ist.

---

## 📌 Unterschied: `kernel.img`, `kernel7.img`, `kernel8.img`

| Dateiname      | Architektur          | Beschreibung                                         |
| -------------- | -------------------- | ---------------------------------------------------- |
| `kernel.img`   | ARMv6 (32-bit)       | Für ältere Modelle (z. B. Raspberry Pi 1, Zero)      |
| `kernel7.img`  | ARMv7 (32-bit)       | Für RPi 2 & 3 im 32-Bit-Modus                        |
| `kernel7l.img` | ARMv7 (32-bit)       | Für RPi 3/4 mit „long physical address“              |
| `kernel8.img`  | **AArch64 (64-bit)** | **Empfohlen für Raspberry Pi 3 & 4 im 64-Bit-Modus** |

---

## ✅ Raspberry Pi 4B → `kernel8.img`

* Der **Raspberry Pi 4B** verwendet einen **64-Bit-fähigen SoC (Broadcom BCM2711)**.
* Wenn du ein **64-Bit-System booten willst** (z. B. ArchLinuxARM AArch64 oder U-Boot mit AArch64 Kernel), dann:

```ini
arm_64bit=1
kernel=kernel8.img
```

Falls du aber absichtlich ein **32-Bit-System bootest** (z. B. Raspbian 32-bit), dann würdest du `kernel7l.img` oder `kernel7.img` nutzen – aber das ist heute eher veraltet, außer du hast einen bestimmten Grund.

---

## 🧠 Wann du was nutzt

| Modell      | 32-Bit Boot    | 64-Bit Boot         |
| ----------- | -------------- | ------------------- |
| RPi 1, Zero | `kernel.img`   | ❌ nicht möglich     |
| RPi 2       | `kernel7.img`  | ❌ nicht möglich     |
| RPi 3       | `kernel7.img`  | `kernel8.img`       |
| **RPi 4**   | `kernel7l.img` | ✅ **`kernel8.img`** |

---

**Fazit:** Wenn du mit U-Boot oder einem 64-Bit-Kernel arbeitest (z. B. für Arch Linux ARM AArch64 oder Buildroot für den Pi 4), dann ist **`kernel8.img` korrekt und empfohlen**.
Nur bei einem 32-Bit-System brauchst du `kernel7.img`.

Möchtest du ein 32- oder 64-Bit-System bauen?


Der **Raspberry Pi 5** nutzt eine modernisierte Bootarchitektur – stark verbessert gegenüber früheren Modellen – und benötigt ebenfalls bestimmte Bootdateien auf der **ersten FAT32-Partition der SD-Karte oder SSD**. Diese Dateien werden vom offiziellen **bootloader im SPI-Flash (EEPROM)** verwendet.

---

## ✅ **Boot-Dateien für Raspberry Pi 5**

| Datei                 | Funktion                                                  |
| --------------------- | --------------------------------------------------------- |
| `start4.elf`          | GPU-Firmware und sekundärer Bootloader                    |
| `fixup4.dat`          | Passende Fixup-Daten zur `start4.elf`                     |
| `config.txt`          | Konfiguration: 64-bit Modus, Kernelname, Device Tree usw. |
| `kernel8.img`         | 64-Bit Linux-Kernel oder U-Boot-Binary                    |
| `bcm2712-rpi-5-b.dtb` | Device Tree für Raspberry Pi 5                            |
| `cmdline.txt`         | Kernel-Bootparameter (z. B. Root-Device)                  |
| `overlays/*.dtbo`     | (Optional) Device Tree Overlays                           |

> ❌ **`bootcode.bin` ist nicht mehr erforderlich** – der Bootloader liegt im SPI-EEPROM ab Werk.

---

## 📁 Beispielstruktur der Bootpartition (Raspberry Pi 5)

```
/boot/
├── start4.elf
├── fixup4.dat
├── config.txt
├── kernel8.img                   # Linux-Kernel oder U-Boot-Binary
├── bcm2712-rpi-5-b.dtb
├── cmdline.txt
└── overlays/
    └── *.dtbo
```

---

## 📝 Beispiel `config.txt` für 64-bit Boot (Linux oder U-Boot)

```ini
arm_64bit=1
enable_uart=1
kernel=kernel8.img
device_tree=bcm2712-rpi-5-b.dtb
```

---

## 📝 Beispiel `cmdline.txt` (für direktes Linux-Booten)

```txt
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait
```

---

## 🧠 Hinweise:

* Die **Dateien `start4.elf` und `fixup4.dat`** sind für alle neueren Modelle (RPi 4 und 5) gleich und kommen aus dem GitHub-Repo:
  👉 [`https://github.com/raspberrypi/firmware`](https://github.com/raspberrypi/firmware/tree/master/boot)

* Die **richtige DTB-Datei für den Pi 5** ist:

  ```
  bcm2712-rpi-5-b.dtb
  ```

* Wenn du **U-Boot** verwenden willst: Speichere `u-boot.bin` einfach als `kernel8.img`.

---

Möchtest du damit ein **eigenes System (z. B. mit Buildroot oder Arch RootFS)** booten oder **U-Boot als Bootloader** einsetzen?

```# build-bootloader
