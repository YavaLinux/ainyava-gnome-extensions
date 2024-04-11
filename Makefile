PREFIX ?= /usr
EXTENSIONS ?= $(shell cat extensions.txt)
SHELL_VER ?= 46

list:
	for item in $(EXTENSIONS); do \
		name=`echo $$item | sed 's/:.*//g'`; \
		version=`echo $$item | sed 's/.*://g'`; \
		echo "Version: $$version, Extension: $$name"; \
	done;

download:
	for item in $(EXTENSIONS); do \
		name=`echo $$item | sed 's/:.*//g'`; \
		version=`echo $$item | sed 's/.*://g'`; \
		if [ ! -f $$name.zip ]; then curl -Ls "https://extensions.gnome.org/api/v1/extensions/$$name/versions/$$version?format=zip" -o "$$name.zip"; fi; \
	done;

make install: download
	mkdir -p $(DESTDIR)$(PREFIX)/share/gnome-shell/extensions
	for item in $(EXTENSIONS); do \
		name=`echo $$item | sed 's/:.*//g'`; \
		unzip $$name -d ./usr/share/gnome-shell/extensions/$$name; \
	done;
	cp -R ./usr/* $(DESTDIR)$(PREFIX)/

uninstall:
	for item in $(EXTENSIONS); do \
		name=`echo $$item | sed 's/:.*//g'`; \
		rm -rf $(DESTDIR)$(PREFIX)/share/gnome-shell/extensions/$$name;
	done;
