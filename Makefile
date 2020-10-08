# Basic package information
PKG_NAME=aci-tomcat
PKG_DESCRIPTION="tomcat"
TMC_VERSION=7
PKG_ARCHIVE_URL="https://tomcat.apache.org/download-${TMC_VERSION}0.cgi"
PKG_VERSION=$(curl -s ${PKG_ARCHIVE_URL} | grep "${TMC_VERSION}\.0\.[0-9]\+</a>" | sed -e 's|.*>\(.*\)<.*|\1|g' | tail -1)
PKG_URL="https://downloads.apache.org/tomcat/tomcat-${TMC_VERSION}/v${PKG_VERSION}/bin/apache-tomcat-${PKG_VERSION}.tar.gz"
PKG_MAINTAINER="TDG \<tiziano.digennaro@aciworldwide.com\>"
PKG_ARCH=all
JMX_URL="https://downloads.apache.org/tomcat/tomcat-${TMC_VERSION}/v${PKG_VERSION}/bin/extras/catalina-jmx-remote.jar"

# These vars probably need no change
PKG_DEB="${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_${PKG_ARCH}.deb"
FPM_OPTS=--deb-no-default-config-files -s dir -n $(PKG_NAME) -v $(PKG_VERSION) --iteration $(PKG_RELEASE) -C $(TMPINSTALLDIR) --maintainer ${PKG_MAINTAINER} --description $(PKG_DESCRIPTION) -a $(PKG_ARCH)
TMPINSTALLDIR=/tmp/$(PKG_NAME)-fpm-install

# Do whatever you need to install the software. Remember to use $(DESTDIR) as
# prefix to all destination paths.
#
# About SYMLINKS: Making a symlink *pointing* to a path with $(DESTDIR) won't work. You can:
# - Use the pointed-to-path without $(DESTDIR) OR
# - Use relative paths OR
# - Create symlinks in the after install script.
#
#install:
	# mkdir -p $(INSTALLDIR)
	# cp myprog $(INSTALLDIR)
	# ln -s /usr/local/myapp/myprog  $(DESTDIR)/usr/local/bin/myprog
	# ln -s ../myapp/myprog  $(DESTDIR)/usr/local/bin/myprog

# Generate a deb package using fpm
.PHONY: package publish
package:
	rm -rf $(TMPINSTALLDIR)
	rm -f $(PKG_DEB)
	mkdir -vp $(TMPINSTALLDIR)
	wget -qO - $(PKG_URL) | tar xzf - -C $(TMPINSTALLDIR) \
		--exclude logs \
		--exclude work \
		--exclude webapps \
		--exclude temp \
		--exclude conf/server.xml \
		--exclude conf/catalina.properties \
		--exclude conf/logging.properties \
		--exclude conf/web.xml \
		--exclude conf/tomcat-users.xml
	cd ${TMPINSTALLDIR} && ln -s apache-tomcat-$(PKG_VERSION) apache-tomcat-${TMC_VERSION}
    
ifeq ($(TMC_VERSION),7)
	wget -q $(JMX_URL) -P $(TMPINSTALLDIR)/apache-tomcat-$(PKG_VERSION)/lib
	fpm -t deb -p $(PKG_DEB) $(FPM_OPTS) \
    	--prefix /opt/devel/java/
endif

ifeq ($(TMC_VERSION),9)
	fpm -t deb -p $(PKG_DEB) $(FPM_OPTS) \
    	--prefix /opt/devel/java/
endif

publish:
#	Do whatever you need to publish your packages to your private repos, if you have any.
    #cp -av $(PKG_DEB) /data/$(PKG_DEB)
