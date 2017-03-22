XSLTPROC = /usr/bin/xsltproc
WORKSPACE=~/workspace
PROJECT=Project
DOCBOOK=project
PUBLIC_HTML=~/public_html
HTMLHELP=$(PUBLIC_HTML)/htmlhelp/$(DOCBOOK)/chm

DSSSL=../../docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp html.XXXXXX)

XSLTPROC_OPT=--stringparam epub.stylesheet docbook.css --stringparam use.id.as.filename 1
DSSSL_EPUB=/usr/share/xml/docbook/stylesheet/docbook-xsl/epub/docbook.xsl

all: html epub htmlhelp

html:

	@mkdir -p ${PUBLIC_HTML}
	@find ${PUBLIC_HTML} -type f -iname "*.html" -exec rm -rf {} \;
	@rsync -au ../../common/docbook.css $(PUBLIC_HTML)/
	@$(XSLTPROC) -o $(PUBLIC_HTML)/${DOCBOOK}/ $(DSSSL) book.xml
	@$(shell test -d $(PUBLIC_HTML)/${DOCBOOK}/images && find $(PUBLIC_HTML)/${DOCBOOK}/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d images && rsync -au --exclude=.svn images $(PUBLIC_HTML)/${DOCBOOK}/)


epub:
	cd $(shell mktemp -d --suffix=.tmp -p /tmp ${PROJECT}.$@.XXXXXX) ; pwd ; \
	(test -d ${PUBLIC_HTML}/${DOCBOOK}/images && rsync -a --exclude=.svn ${PUBLIC_HTML}/${DOCBOOK}/images .) ; \
	${XSLTPROC} $(XSLTPROC_OPT) $(DSSSL_EPUB) $(WORKSPACE)/${PROJECT}/book.xml ; \
	cp ${PUBLIC_HTML}/${DOCBOOK}/docbook.css OEBPS ; \
	echo "application/epub+zip" > mimetype ; \
	zip -0Xq  ${PUBLIC_HTML}/download/epub/${PROJECT}.epub mimetype ; \
	zip -Xr9D ${PUBLIC_HTML}/download/epub/${PROJECT}.epub *
	#cp ${PROJECT}.epub ${PUBLIC_HTML}/${DOCBOOK}/ibook.epub

manpages:
	${XSLTPROC} -o $(PUBLIC_HTML)/$@/${DOCBOOK} /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl $(WORKSPACE)/${PROJECT}/book.xml

htmlhelp:
	@${XSLTPROC} -o $(HTMLHELP)/ --stringparam htmlhelp.chm ../$(PROJECT).chm ../docbook-xsl/htmlhelp/template.xsl $(WORKSPACE)/${PROJECT}/book.xml
	@../common/chm.sh $(HTMLHELP)
	@iconv -f UTF-8 -t GB18030 -o $(HTMLHELP)/htmlhelp.hhp < $(HTMLHELP)/htmlhelp.hhp
	@iconv -f UTF-8 -t GB18030 -o $(HTMLHELP)/toc.hhc < $(HTMLHELP)/toc.hhc
	@$(shell test -d $(HTMLHELP)/images && find $(HTMLHELP)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d images && rsync -au --exclude=.svn images $(HTMLHELP)/)

rpm:
	rpmbuild -ba --sign ../Miscellaneous/package/package.spec --define "book $(DOCBOOK)"
	rpm -qpi ~/rpmbuild/RPMS/x86_64/netkiller-$(DOCBOOK)-*.x86_64.rpm
	rpm -qpl ~/rpmbuild/RPMS/x86_64/netkiller-$(DOCBOOK)-*.x86_64.rpm

clean:
	rm -rf $(PUBLIC_HTML)/$(DOCBOOK)

test:
	@$(XSLTPROC) -o $(TMPDIR)/ $(DSSSL) book.xml
