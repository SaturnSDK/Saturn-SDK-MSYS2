#!/bin/bash

cd ${INSTALLDIR}/msys2
patch -Np0 -i ${ROOTDIR}/patches/profile.patch
patch -Np0 -i ${ROOTDIR}/patches/msys2_shell.bat.patch

exit 0
