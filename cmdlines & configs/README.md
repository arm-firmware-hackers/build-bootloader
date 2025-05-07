# Bootmethoden

Für dein minimales **BusyBox-basiertes RootFS** auf dem **Raspberry Pi 5 (ARM64)** stehen dir mehrere Bootmethoden zur Verfügung. Die Wahl hängt von deinen Anforderungen an Flexibilität, Sicherheit und Ressourcenverbrauch ab. Hier sind die gängigsten Ansätze:

---

## 🧰 1. **Booten mit initramfs (komplett im RAM)**

Diese Methode eignet sich hervorragend für minimalistische Systeme, die vollständig im RAM laufen sollen.

### 🔧 Vorbereitung:

* **Kernel**: Kompiliere einen Kernel mit Unterstützung für initramfs.
* **initramfs**: Erstelle ein CPIO-Archiv deines RootFS, das BusyBox und ein `/init`-Skript enthält.
* **Boot-Konfiguration**:

  * **`config.txt`**:

    ```ini
    kernel=kernel8.img
    initramfs initramfs.cpio.gz followkernel
    ```
  * **`cmdline.txt`**:

    ```bash
    console=serial0,115200 root=/dev/ram0 init=/init
    ```

Diese Methode ermöglicht ein schnelles Booten und eignet sich für Systeme ohne persistente Speicherung. Weitere Details findest du in diesem [Leitfaden](https://itachilab.github.io/initramfs-pi/initramfs-pi.html).([itachilab.github.io][1])

---

## 💾 2. **Booten von einer SD-Karte oder USB mit RootFS auf ext4**

Hierbei befindet sich das Root-Dateisystem auf einer ext4-Partition eines Speichermediums.

### 🔧 Vorbereitung:

* **Partitionierung**:

  * **/boot**: FAT32-Partition mit `kernel8.img`, `config.txt` und `cmdline.txt`.
  * **/**: ext4-Partition mit deinem RootFS.
* **`cmdline.txt`**:

```bash
  console=serial0,115200 root=PARTUUID=dein-partuuid rootfstype=ext4 rootwait
```



Stelle sicher, dass die `PARTUUID` korrekt ist. Du kannst sie mit `blkid` ermitteln. Diese Methode ist klassisch und stabil für Systeme mit persistenter Speicherung.([Raspberry Pi Forum][2])

---

## 🔐 3. **Booten mit Secure Boot und `boot.img`**

Der Raspberry Pi 5 unterstützt Secure Boot, bei dem ein signiertes `boot.img` geladen wird.([Raspberry Pi Forum][3])

### 🔧 Vorbereitung:

* **`boot.img`**: Enthält `kernel8.img`, `config.txt`, `cmdline.txt`, `initramfs` und Device Tree.
* **Signierung**: Signiere das `boot.img` mit einem privaten Schlüssel.
* **EEPROM-Konfiguration**:

  * Aktiviere Secure Boot durch Setzen von `SIGNED_BOOT=1`.
* **`config.txt`**:

```ini
  boot_ramdisk=1
```

([Raspberry Pi Forum][3])

Diese Methode erhöht die Sicherheit, indem sie nur signierte Boot-Images zulässt. Ein Beispiel und weitere Informationen findest du in diesem [Forumseintrag](https://forums.raspberrypi.com/viewtopic.php?t=370062).([Raspberry Pi Forum][3])

---

## 🌐 4. **Netzwerkboot mit PXE und initramfs**

Für Systeme ohne lokale Speichermedien kannst du den Raspberry Pi 5 über das Netzwerk booten.

### 🔧 Vorbereitung:

* **TFTP-Server**: Stelle `kernel8.img` und `initramfs.cpio.gz` bereit.
* **DHCP-Server**: Konfiguriere PXE-Boot-Optionen.
* **`cmdline.txt`**:

```bash
  console=serial0,115200 root=/dev/ram0 init=/init
```



Diese Methode eignet sich für zentral verwaltete Systeme oder disklose Clients. Weitere Details findest du in diesem [Diskussionsbeitrag](https://forums.raspberrypi.com/viewtopic.php?t=332044).([Raspberry Pi Forum][4])

---

## 🧪 5. **Booten mit Buildroot**

Buildroot ermöglicht das Erstellen eines maßgeschneiderten Linux-Systems, einschließlich Kernel, RootFS und Bootloader.

### 🔧 Vorbereitung:

* **Konfiguration**:

  * Setze `MACHINE = "raspberrypi5"` in der Buildroot-Konfiguration.
* **Build**:

```bash
  make
```

* **Ergebnis**:

  * Ein bootfähiges Image, das du auf eine SD-Karte schreiben kannst.([rootcommit.com][5])

Buildroot bietet eine umfassende Lösung für Embedded-Systeme. Ein Beispiel findest du in diesem [Artikel](https://rootcommit.com/2025/raspberrypi5-mainline-linux-kernel/).([rootcommit.com][5])

---

## 🧾 Zusammenfassung der Bootmethoden

| Methode                    | Beschreibung                                         | Vorteile                             | Geeignet für                         |                                                    |
| -------------------------- | ---------------------------------------------------- | ------------------------------------ | ------------------------------------ | -------------------------------------------------- |
| initramfs (RAM-only)       | Bootet vollständig im RAM                            | Schnell, keine Speicherzugriffe      | Minimalistische Systeme              |                                                    |
| SD/USB mit ext4 RootFS     | Klassisches Booten von Speichermedien                | Stabil, weit verbreitet              | Systeme mit persistenter Speicherung |                                                    |
| Secure Boot mit `boot.img` | Signiertes Boot-Image für erhöhte Sicherheit         | Schutz vor Manipulation              | Sicherheitskritische Anwendungen     |                                                    |
| Netzwerkboot (PXE)         | Bootet über das Netzwerk ohne lokale Medien          | Zentral verwaltbar, disklose Clients | Große Systemlandschaften             |                                                    |
| Buildroot                  | Maßgeschneidertes System mit integriertem Bootloader | Flexibel, anpassbar                  | Embedded-Systeme                     | ([Raspberry Pi Forum][6], [Raspberry Pi Forum][3]) |

---

Wenn du weitere Informationen oder Unterstützung bei der Einrichtung einer dieser Bootmethoden benötigst, stehe ich dir gerne zur Verfügung!

[1]: https://itachilab.github.io/initramfs-pi/initramfs-pi.html?utm_source=chatgpt.com "Raspberry Pi running from initramfs — ITachi Lab Docs"
[2]: https://forums.raspberrypi.com/viewtopic.php?t=365680&utm_source=chatgpt.com "New Raspberry Pi 5 not booting up [solved]"
[3]: https://forums.raspberrypi.com/viewtopic.php?t=370062&utm_source=chatgpt.com "Raspberry PI 5 Secure Boot"
[4]: https://forums.raspberrypi.com/viewtopic.php?t=332044&utm_source=chatgpt.com "Booting and running from RAM using a custom initramfs"
[5]: https://rootcommit.com/2025/raspberrypi5-mainline-linux-kernel/?utm_source=chatgpt.com "Booting the Raspberry Pi 5 with the Mainline Linux Kernel"
[6]: https://forums.raspberrypi.com/viewtopic.php?t=383962&utm_source=chatgpt.com "Raspberry Pi 5 Boot Control"
