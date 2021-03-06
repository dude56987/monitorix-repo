show:
	echo 'Run "make install" as root to install program!'
run:
	monitorix
install: build
	sudo gdebi --non-interactive monitorix-repo_UNSTABLE.deb
uninstall:
	sudo apt-get purge monitorix-repo
build: 
	sudo make build-deb;
build-deb:
	mkdir -p debian;
	mkdir -p debian/DEBIAN;
	mkdir -p debian/usr;
	mkdir -p debian/usr/share;
	mkdir -p debian/usr/share/applications;
	mkdir -p debian/etc;
	mkdir -p debian/etc/apt;
	mkdir -p debian/etc/apt/sources.list.d/;
	mkdir -p debian/etc/apt/trusted.gpg.d/;
	# copy over the repo stuff for apt
	cp -vf monitorix-izzysoft.asc ./debian/etc/apt/trusted.gpg.d/
	cp -vf monitorix-izzysoft.list ./debian/etc/apt/sources.list.d/
	# Create the md5sums file
	find ./debian/ -type f -print0 | xargs -0 md5sum > ./debian/DEBIAN/md5sums
	# cut filenames of extra junk
	sed -i.bak 's/\.\/debian\///g' ./debian/DEBIAN/md5sums
	sed -i.bak 's/\\n*DEBIAN*\\n//g' ./debian/DEBIAN/md5sums
	sed -i.bak 's/\\n*DEBIAN*//g' ./debian/DEBIAN/md5sums
	rm -v ./debian/DEBIAN/md5sums.bak
	# figure out the package size	
	du -sx --exclude DEBIAN ./debian/ > Installed-Size.txt
	# copy over package data
	cp -rv debdata/. debian/DEBIAN/
	# fix permissions in package
	chmod -Rv 775 debian/DEBIAN/
	chmod -Rv ugo+r debian/
	chmod -Rv go-w debian/
	chmod -Rv u+w debian/
	# build the package
	dpkg-deb --build debian
	cp -v debian.deb monitorix-repo_UNSTABLE.deb
	rm -v debian.deb
	rm -rv debian
