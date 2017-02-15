# Magisk Compatible phh's SuperUser

### Additional Features
- Bind su binary to /system/xbin on demand by `BINDSYSTEMXBIN` flag in `.magisk`. Disabled by default.
- bind_mount /magisk/phh/su.d to /system/etc/init.d if the latter doesn't exist.

**Official thread to phh's SuperUser: [phh's SuperUser/ OpenSource SELinux-capable SuperUser](http://forum.xda-developers.com/showthread.php?t=3216394)**

### Requirements
- **Magisk is required to be installed on your device!**
- **[Magisk - The Universal Systemless Interface](http://forum.xda-developers.com/android/software/mod-magisk-v1-universal-systemless-t3432382)**

### Features
- phh's 100% open source root
- Packed with my own sepolicy-injection tools, which support live patching to work on small boot image devices
- Magisk compatible, no boot image modifications are required
- **su.d support (place scripts in /magisk/phh/su.d)**

### Instructions
- You can install/update phh's SuperUser in Magisk Manager's Download section
- If you have no root in the first place, please flash the zip in the attachment through custom recovery
- A root solution is part of a proper Magisk installation.
- After phh's SuperUser is installed, please install the SuperUser manager Application through the Play Store
- [phh's SuperUser Manager](https://play.google.com/store/apps/details?id=me.phh.superuser)

### Source
- <https://github.com/topjohnwu/sepolicy-inject> (sepolicy-tools)
- <https://github.com/Magisk-Modules-Repo/phh-superuser> (Magisk repo source)
