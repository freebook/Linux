XSLTPROC = /usr/bin/xsltproc
DSSSL = ../../docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp multimedia.html.XXXXXX)
DOCBOOK='.'
PUBLIC_HTML=~/public_html/multimedia

all:
	@mkdir -p ${PUBLIC_HTML}
	@find ${PUBLIC_HTML}/$(1) -type f -iname "*.html" -exec rm -rf {} \;
	@rsync -au ../common/docbook.css $(PUBLIC_HTML)/
	@$(XSLTPROC) -o $(PUBLIC_HTML)/ $(DSSSL) $(DOCBOOK)/book.xml
	@$(shell test -d $(PUBLIC_HTML)/images && find $(PUBLIC_HTML)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d $(1)/images && rsync -au --exclude=.svn $(DOCBOOK)/images $(PUBLIC_HTML)/)

clean:
	@rm -rf $(PUBLIC_HTML)/$@

test:
	@$(XSLTPROC) -o $(TMPDIR)/ $(DSSSL) $(DOCBOOK)/book.xml
