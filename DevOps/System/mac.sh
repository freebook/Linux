HTML_DIR=~/tmp/devops/
rm -rf $HTML_DIR
mkdir -p $HTML_DIR
xsltproc -o $HTML_DIR docbook-xsl/docbook.mac.xsl book.xml
