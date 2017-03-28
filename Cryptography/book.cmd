@echo off

cls
rem %XML%\bin\xsltproc %DSSSL% %0.xml>%0.html
cd xhtml
copy ..\docbook.css .
%XML%\bin\xsltproc --stringparam html.stylesheet docbook.css %XML%\docbook-xsl\xhtml\chunk.xsl ..\book.xml
cd ..

tar cvf security.tar xhtml
gzip security.tar
md5sum security.tar.gz > xhtml\security.tar.gz.md5
move security.tar.gz xhtml



rem explorer %0.html
