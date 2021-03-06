#!/bin/bash
set -e

export TAG_NAME=`git describe --tags | sed -e 's/_[0-9].*//'`
export VERSION_NUM=`git describe --match "${TAG_NAME}_[0-9]*" HEAD | sed -e 's/-g.*//' -e "s/${TAG_NAME}_//"`
export MAJOR_BUILD_NUM=`echo $VERSION_NUM | sed 's/-[^.]*$//' | sed -r 's/.[^.]*$//' | sed -r 's/.[^.]*$//'`
export MINOR_BUILD_NUM=`echo $VERSION_NUM | sed 's/-[^.]*$//' | sed -r 's/.[^.]*$//' | sed -r 's/.[.]*//'`
export REVISION_BUILD_NUM=`echo $VERSION_NUM | sed 's/-[^.]*$//' | sed -r 's/.*(.[0-9].)//'`
export BUILD_NUM=`echo $VERSION_NUM | sed -e 's/[0-9].[0-9].[0-9]//' -e 's/-//'`

if [ -z $TAG_NAME ]; then
	TAG_NAME=unknown
fi

if [ -z $MAJOR_BUILD_NUM ]; then
	MAJOR_BUILD_NUM=0
fi

if [ -z $MINOR_BUILD_NUM ]; then
	MINOR_BUILD_NUM=0
fi

if [ -z $REVISION_BUILD_NUM ]; then
	REVISION_BUILD_NUM=0
fi

if [ -z $BUILD_NUM ]; then
	BUILD_NUM=0
fi

mkdir -p $ROOTDIR/installerpackage/{org.opengamedevelopers.sega.saturn.sdk.msys2/{data,meta},config}

cat > $ROOTDIR/installerpackage/org.opengamedevelopers.sega.saturn.sdk.msys2/meta/package.xml << __EOF__
<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<DisplayName>MSYS2</DisplayName>
	<Description>MSYS2</Description>
	<Version>${MAJOR_BUILD_NUM}.${MINOR_BUILD_NUM}.${REVISION_BUILD_NUM}.${BUILD_NUM}</Version>
	<Name>org.opengamedevelopers.sega.saturn.sdk.msys2</Name>
	<ReleaseDate>`git log --pretty=format:"%ci" -1 | sed -e 's/ [^ ]*$//g'`</ReleaseDate>
	<Script>installscript.qs</Script>
	<Licenses>
		<License name="GNU Public License Ver. 3" file="gplv3.txt" />
	</Licenses>
</Package>
__EOF__

cat > $ROOTDIR/installerpackage/org.opengamedevelopers.sega.saturn.sdk.msys2/meta/installscript.qs << __EOF__
function Component( )
{
	installer.finishButtonClicked.connect( this, Component.prototype.installationFinished );
}

Component.prototype.createOperations = function( )
{
	component.createOperations( );

	component.addOperation( "CreateShortcut", "@TargetDir@/msys2/msys2_shell.bat",
		"@StartMenuDir@/MSYS2 Shell.lnk", "iconPath=@TargetDir@/msys2/msys2.ico" );
}

Component.prototype.installationFinished = function( )
{
	if( installer.fileExists( installer.value( "TargetDir" ) + "/msys2/etc/hosts" ) == false )
	{
		QDesktopServices.openUrl( "file:///" + installer.value( "TargetDir" ) + "/msys2/msys2_shell.bat" );
	}
}
__EOF__

wget -c -O $ROOTDIR/installerpackage/org.opengamedevelopers.sega.saturn.sdk.msys2/meta/gplv3.txt https://www.gnu.org/licenses/gpl-3.0.txt

printf "Packaging $INSTALLDIR/msys2 ... "
$QTIFWDIR/bin/archivegen $ROOTDIR/installerpackage/org.opengamedevelopers.sega.saturn.sdk.msys2/data/directory.7z $INSTALLDIR/msys2
if [ $? -ne "0" ]; then
	printf "FAILED\n"
	exit 1
fi

printf "OK\n"

rm -rf $ROOTDIR/installerpackage/msys2

$QTIFWDIR/bin/repogen -p $ROOTDIR/installerpackage -i org.opengamedevelopers.sega.saturn.sdk.msys2 $ROOTDIR/installerpackage/msys2

