#!/bin/bash
if [ ! -d $DOWNLOADDIR ]; then
	mkdir -p $DOWNLOADDIR
fi

cd $DOWNLOADDIR

if test "`curl -V`"; then
	FETCH="curl -f -L -O -C -"
elif test "`wget -V`"; then
	FETCH="wget -c"
else
	echo "Could not find either curl or wget, please install either one to continue"
	exit 1
fi

if test "`parallel -V`"; then
	PARALLEL="TRUE"
else
	PARALLEL="FALSE"
fi

MSYS2DOWNLOAD=http://sourceforge.net/projects/msys2/files/Base/${ARCH}/${MSYS2FILE}/download

if [[ "$PARALLEL" == "FALSE" ]]; then
	$FETCH $MSYS2DOWNLOAD
else
	echo $MSYS2DOWNLOAD > downloadlist.txt

	cat downloadlist.txt | parallel -j 10 --progress --gnu $FETCH
fi

mv download ${MSYS2FILE}

