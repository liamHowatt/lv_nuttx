#!/bin/bash

DIR=$(dirname $0)

git -C $DIR submodule update --init

cd $DIR/apps
ln --symbolic --force ../my_lvgl_apps
cd ..

if [ -e $DIR/nuttx/.config ]; then
    echo "NuttX already has a config loaded."
    echo "Run 'make -C nuttx distclean' and try again."
    exit 1
fi

cd $DIR/nuttx
./tools/configure.sh -l esp32s3-lcd-ev:lvgl
kconfig-tweak --enable CONFIG_MY_LVGL_APPS_MY_LVGL_APP
kconfig-tweak --set-val CONFIG_ESP32S3_I2C0_SCLPIN 48
kconfig-tweak --set-val CONFIG_ESP32S3_I2C0_SDAPIN 47
kconfig-tweak --set-val CONFIG_ESP32S3_LCD_DATA6_PIN 8
kconfig-tweak --set-val CONFIG_ESP32S3_LCD_DATA7_PIN 18
yes '' | make oldconfig
cd ..

echo
echo "Ready. Run 'cd nuttx/' and 'make -j$(nproc)'"
