#!/bin/bash
# create multiresolution windows icon
ICON_DST=../../src/qt/res/icons/fsociety.ico

convert ../../src/qt/res/icons/fsociety-16.png ../../src/qt/res/icons/fsociety-32.png ../../src/qt/res/icons/fsociety-48.png ${ICON_DST}
