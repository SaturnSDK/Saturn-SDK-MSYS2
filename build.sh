#!/bin/bash 
if [ -z $NPROC ]; then
	export NCPU=`nproc`
fi

mkdir -p $INSTALLDIR

if [[ "$TARGETMACH" == "x86_64-w64-mingw32" ]]; then
	ARCH=x86_64
	EXTRACTDIR=${INSTALLDIR}/msys64
elif [[ "$TARGETMACH" == "i686-w64-mingw32" ]]; then
	ARCH=i686
	EXTRACTDIR=${INSTALLDIR}/msys32
else
	echo "Unknown target architecture"
	exit 1
fi

export ARCH
export EXTRACTDIR 
export MSYS2FILE=msys2-base-${ARCH}-20150512.tar.xz

./download.sh

if [ $? -ne 0 ]; then
	echo "Failed to retrieve MSYS2"
	exit 1
fi

./extract.sh

if [ $? -ne 0 ]; then
	echo "Failed to extract MSYS2"
	exit 1
fi

if [[ "${CREATEINSTALLER}" == "YES" ]]; then
	./createinstaller.sh
fi

