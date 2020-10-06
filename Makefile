#CONFIGDIR=$(DESTDIR)/etc/myapp
#CRONDIR=$(DESTDIR)/etc/cron.d
#INITDIR=$(DESTDIR)/etc/init.d
#LOGROTATEDIR=$(DESTDIR)/etc/logrotate.d
#INSTALLDIR=$(DESTDIR)/my/install/path

# Basic package information
PKG_NAME=aci-tomcat-7
PKG_DESCRIPTION="aci-tomcat-7"
PKG_VERSION_URL="https://tomcat.apache.org/download-70.cgi"
PKG_VERSION=$(curl -s $PKG_ARCHIVE_URL | grep "7\.0\.[0-9]\+</a>" | sed -e 's|.*>\(.*\)<.*|\1|g' | tail -1)
PKG_URL="https://downloads.apache.org/tomcat/tomcat-7/v7.0.${PKG_VERSION}/bin/apache-tomcat-7.0.${PKG_VERSION}.tar.gz"
PKG_RELEASE=1
PKG_MAINTAINER="Lazy Guy \<tiziano.digennaro@a.com\>"
PKG_ARCH=all

# These vars probably need no change
PKG_DEB=${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_${PKG_ARCH}.deb
FPM_OPTS=-s dir -n $(PKG_NAME) -v $(PKG_VERSION) --iteration $(PKG_RELEASE) -C $(TMPINSTALLDIR) --maintainer ${PKG_MAINTAINER} --description $(PKG_DESCRIPTION) -a $(PKG_ARCH)
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
	wget -qO - $(PKG_URL) | tar xzvf -C $(TMPINSTALLDIR) \ 
		--exclude logs \
		--exclude work \
		--exclude webapps \
		--exclude temp \
		--exclude conf/server.xml \
		--exclude conf/catalina.properties \
		--exclude conf/tomcat-users.xml
	

# Set as needed: package dependencies (-d), after-install script, and paths to
# include in the package (last line):
#
	fpm -t deb -p $(PKG_DEB) $(FPM_OPTS) \ 
	    --prefix /opt/devel/java/
		#--after-install postinstall-deb \
		#etc usr var

publish:
#	Do whatever you need to publish your packages to your private repos, if you have any.
#   rm -f $(PKG_DEB)
