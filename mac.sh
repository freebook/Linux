git submodule update
#rm -rf ~/tmp/linux/
mkdir -p ~/tmp/linux/
cp -r images ~/tmp/linux/
cp common/docbook.css ~/tmp/linux/
xsltproc -o ~/tmp/linux/ docbook-xsl/docbook.mac.xsl book.xml
