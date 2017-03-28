XSLTPROC = /usr/bin/xsltproc
DSSSL = ../../docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp cryptography.html.XXXXXX)
WORKSPACE=~/workspace
PROJECT=Cryptography
DOCBOOK=cryptography
PUBLIC_HTML=~/public_html
HTML=$(PUBLIC_HTML)/$(DOCBOOK)
HTMLHELP=$(PUBLIC_HTML)/htmlhelp/${DOCBOOK}/chm

all: html htmlhelp

html:
	@mkdir -p ${PUBLIC_HTML}
	@find ${PUBLIC_HTML} -type f -iname "*.html" -exec rm -rf {} \;
	@rsync -au ../../common/docbook.css $(HTML)/
	@$(XSLTPROC) -o $(HTML)/ $(DSSSL) book.xml
	@$(shell test -d $(HTML)/images && find $(HTML)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d images && rsync -au --exclude=.svn images $(HTML)/)

htmlhelp:
	${XSLTPROC} -o $(HTMLHELP)/ --stringparam htmlhelp.chm ../$(PROJECT).chm ../docbook-xsl/htmlhelp/template.xsl $(WORKSPACE)/${PROJECT}/book.xml
	@../../common/chm.sh $(HTMLHELP)
	@iconv -f UTF-8 -t GB18030 -o $(HTMLHELP)/htmlhelp.hhp < $(HTMLHELP)/htmlhelp.hhp
	@iconv -f UTF-8 -t GB18030 -o $(HTMLHELP)/toc.hhc < $(HTMLHELP)/toc.hhc
	@$(shell test -d $(HTMLHELP)/images && find $(HTMLHELP)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d images && rsync -au --exclude=.svn images $(HTMLHELP)/)
	@rsync $(PUBLIC_HTML)/images/by-nc-sa.png $(HTMLHELP)/images

rpm:
	rpmbuild -ba --sign ../Miscellaneous/package/package.spec --define "book $(DOCBOOK)"
	rpm -qpi ~/rpmbuild/RPMS/x86_64/netkiller-$(DOCBOOK)-*.x86_64.rpm
	rpm -qpl ~/rpmbuild/RPMS/x86_64/netkiller-$(DOCBOOK)-*.x86_64.rpm

clean:
	rm -rf $(PUBLIC_HTML)/$@

test:
	@$(XSLTPROC) -o $(TMPDIR)/ $(DSSSL) $(DOCBOOK)/book.xml
