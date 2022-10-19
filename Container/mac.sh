BASEDIR=~/tmp/virtualization/
#rm -rf ${BASEDIR}
mkdir -p ${BASEDIR}
cp -r images ${BASEDIR}
cp ../common/docbook.css ${BASEDIR}
xsltproc -o ${BASEDIR} ../docbook-xsl/docbook.mac.xsl book.xml
