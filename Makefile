XSLTPROC = /usr/bin/xsltproc
DSSSL = /home/neo/workspace/Document/Docbook/docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp ebook.$html.XXXXXX)
DOCBOOK=''
PUBLIC_HTML=/home/neo/workspace/public_html

define reset
	@mkdir -p ${PUBLIC_HTML}/$(1)
	@find ${PUBLIC_HTML}/$(1) -type f -iname "*.html" -exec rm -rf {} \;
endef

define book
	@rsync -au common/docbook.css $(PUBLIC_HTML)/$(2)/
	@$(XSLTPROC) -o $(PUBLIC_HTML)/$(2)/ $(DSSSL) $(1)/book.xml
	@$(shell test -d $(PUBLIC_HTML)/$(2)/images && find $(PUBLIC_HTML)/$(2)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d $(1)/images && rsync -au --exclude=.svn $(1)/images $(PUBLIC_HTML)/$(2)/)
endef

define test
        @$(XSLTPROC) -o $(TMPDIR)/ $(DSSSL) $(1)/book.xml
endef


all: linux debian monitoring storage www shell security

show:
	@echo $(DOCBOOK)
	@echo ${PUBLIC_HTML}
	@echo $(TMPDIR)
	@cat Makefile | egrep -o "(.+):" | sed 's/://'
	
clean:
	@rm -rf $(PUBLIC_HTML)/$@

linux: clean
	$(call reset,linux)
	@$(XSLTPROC) -o $(PUBLIC_HTML)/$@/ $(DSSSL) book.xml
debian:
	$(call reset,debian)
	$(call book,System,debian)
mail:
	$(call reset,mail)
	$(call book,Mail,mail)
monitoring:
	$(call reset,monitoring)
	$(call book,Monitoring,monitoring)	
storage:
	$(call reset,storage)
	$(call book,Storage,storage)
www:
	$(call reset,www)
	$(call book,Web,www)
shell:
	$(call reset,shell)
	$(call book,Shell,shell)
security:
	$(call reset,security)
	$(call book,Security,security)

#%.html: %.xml $(DSSSL)
#	$(XSLTPROC) -o $@ \
#	$(DSSSL) \
#	$< 

test: test.html

