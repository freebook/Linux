@echo off
cls
rem  --stringparam html.stylesheet docbook.css
%XML%\bin\xsltproc %XML%\docbook-xsl\xhtml\docbook.xsl usenet.xml >usenet.html