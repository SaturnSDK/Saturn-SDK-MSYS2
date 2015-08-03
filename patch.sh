#!/bin/bash

cd ${INSTALLDIR}/msys2
patch -Np0 -i ${ROOTDIR}/patches/profile.patch

exit 0
