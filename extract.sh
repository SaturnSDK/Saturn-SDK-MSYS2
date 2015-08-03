#!/bin/bash

echo "Extracting files..."

cd ${INSTALLDIR}

echo tar xvpf ${DOWNLOADDIR}/${MSYS2FILE} -C ${INSTALLDIR}
tar xvpf ${DOWNLOADDIR}/${MSYS2FILE} -C ${INSTALLDIR}

if [ $? -ne 0 ]; then
	rm -rf ${EXTRACTDIR}
	exit 1
fi

rm -rf ${INSTALLDIR}/msys2

mv ${EXTRACTDIR} ${INSTALLDIR}/msys2

echo "Done"
