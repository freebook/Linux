@echo off

set DSSSL=file:///D:/workspace/Document/Docbook/docbook-xsl-1.74.0/xhtml/chunk.xsl
cd tmp
rem copy ..\docbook.css .
rem xcopy ..\images images
C:\project\xsltproc-win32\xsltproc --timing --stringparam html.stylesheet docbook.css %DSSSL% ..\book.xml
rem --xinclude
explorer index.html 
cd ..