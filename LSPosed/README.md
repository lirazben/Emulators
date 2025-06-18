How to root the avd by yourself? 

0. Download otatools:
https://ci.android.com/builds/submitted/13625421/aosp_cf_x86_64_only_phone-userdebug/latest/otatools.zip

1. Create an avd with android-13 img (choose the android open source emulator) 

2. Go to 
cd ~/Android/Sdk/system-images/android-33/default/x86_64

3. copy the ramdisk.img and kernel to the side (save the original)

4. use mkbootimg --kernel <path/kernel_name> --ramdisk <path/ramdisk_name> -o boot.img (this should be found inside otatools)

5. adb install Magisk-<version>.apk on the avd

6. adb push boot.img /sdcard/Download

7. patch the boot.img with magisk 

8. adb pull magisk_xxx.img to your pc

9. shutdown the emulator 

10. unpack the image:
a- unzip Magisk-v27.0.apk -d magisk_tmp
b- cd /magisk_apk/lib/x86_64
c- chmod +x libmagiskboot.so
d- ./libmagiskboot.so unpack magisk_xxx.img

11 - copy the ramdisk.img and kernel to the ~/Android/Sdk/system-images/android-33/default/x86_64 (instead of the original files)

12- power the emulator 

13- That is it you phone is rooted :), now you can install Lsposed package 

I added the Magisk.apk that we used + the lsposed we used .
