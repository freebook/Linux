@echo off
call ..\setenv.cmd
%HOME%\bin\xsltproc %DSSSL% book.xml>index.html
explorer index.html
