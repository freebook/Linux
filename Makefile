XSLTPROC = /usr/bin/xsltproc
DSSSL = ../docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp linux.$html.XXXXXX)
WORKSPACE=~/workspace
PROJECT=Linux
DOCBOOK=linux
PUBLIC_HTML=~/public_html
HTMLHELP=~/htmlhelp/${DOCBOOK}/chm

define reset
	@mkdir -p ${PUBLIC_HTML}/$(1)
	@find ${PUBLIC_HTML}/$(1) -type f -iname "*.html" -exec rm -rf {} \;
endef

define book
	@git pull
	@git submodule init
	@git submodule update
	@rsync -au ../common/docbook.css $(PUBLIC_HTML)/$(2)/
	@$(XSLTPROC) -o $(PUBLIC_HTML)/$(2)/ $(DSSSL) $(1)/book.xml
	@$(shell test -d $(PUBLIC_HTML)/$(2)/images && find $(PUBLIC_HTML)/$(2)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d $(1)/images && rsync -au --exclude=.svn $(1)/images $(PUBLIC_HTML)/$(2)/)
endef

define test
        @$(XSLTPROC) -o $(TMPDIR)/ $(DSSSL) $(1)/book.xml
endef


all: linux debian monitoring storage www shell security htmlhelp

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
	@$(shell test -d images && rsync -au --exclude=.svn images $(PUBLIC_HTML)/linux/)
	@$(find */images -type d -d 0 -exec rsync -au {}/* $(PUBLIC_HTML)/linux/images \;)
debian:
	$(call reset,debian)
	$(call book,System,debian)
mail:
	$(call reset,mail)
	$(call book,Mail,mail)
monitor:
	$(call reset,monitor)
	$(call book,Monitoring,monitor)	
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

virtualization:
	$(call reset,virtualization)
	$(call book,Virtualization,virtualization)

htmlhelp:
	@rm -rf $(HTMLHELP) && mkdir -p $(HTMLHELP)
	@test -d images && rsync -a images $(HTMLHELP) 
	@${XSLTPROC} -o $(HTMLHELP)/ --stringparam htmlhelp.chm ../$(PROJECT).chm ../docbook-xsl/htmlhelp/template.xsl $(WORKSPACE)/${PROJECT}/book.xml
	@test -f $(HTMLHELP)/htmlhelp.hhp && ../common/chm.sh $(HTMLHELP)
	@iconv -f UTF-8 -t GB18030 -o $(HTMLHELP)/htmlhelp.hhp < $(HTMLHELP)/htmlhelp.hhp
	@iconv -f UTF-8 -t GB18030 -o $(HTMLHELP)/toc.hhc < $(HTMLHELP)/toc.hhc	

rpm:
	rpmbuild -ba --sign ../Miscellaneous/package/package.spec --define "book $(DOCBOOK)"
	rpm -qpi ~/rpmbuild/RPMS/x86_64/netkiller-$(DOCBOOK)-*.x86_64.rpm
	rpm -qpl ~/rpmbuild/RPMS/x86_64/netkiller-$(DOCBOOK)-*.x86_64.rpm
