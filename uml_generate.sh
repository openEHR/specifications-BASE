#!/bin/bash

if [ -z "$MAGICDRAW_HOME" ]; then
    echo "MAGICDRAW_HOME environment variable not set, please set it to the MagicDraw installation folder"
    exit 1
fi

# Figure out the MD home 'URL' leader, which is needed for the -Dmd.class.path param below
# We look for $OS which should be set to Windows_NT on cygwin, and either something else or nothing on other unix/OSX
# Then mangle it to make it the proper URL form of a file system location - replace spaces, remove ':', precede with /
# We also set the Classpath delimiter properly, since it's different on different platforms.

if [ "$OS" = Windows_NT ]; then
	md_home_url_leader=$(echo "$MAGICDRAW_HOME" | sed -e 's/^/\//' -e 's/ /%20/g')
	md_home_url_base=$(echo "$MAGICDRAW_HOME" | sed -e 's/:/%3A/g' -e 's/ /%20/g' -e 's/\//%2F/g')
	cp_delim=";"
else
	md_home_url_leader=${MAGICDRAW_HOME}
	md_home_url_base=${MAGICDRAW_HOME}
	cp_delim=":"
fi
md_cp_url=file:$md_home_url_leader/bin/magicdraw.properties?base=$md_home_url_base#CLASSPATH
echo md_cp_url = $md_cp_url

CP="$MAGICDRAW_HOME/lib/com.nomagic.osgi.launcher-17.0.5-SNAPSHOT.jar$cp_delim$MAGICDRAW_HOME/lib/bundles/org.eclipse.osgi_3.10.1.v20140909-1633.jar$cp_delim$MAGICDRAW_HOME/lib/bundles/com.nomagic.magicdraw.osgi.fragment_1.0.0.201512211944.jar$cp_delim$MAGICDRAW_HOME/lib/md_api.jar$cp_delim$MAGICDRAW_HOME/lib/md_common_api.jar$cp_delim$MAGICDRAW_HOME/lib/md.jar$cp_delim$MAGICDRAW_HOME/lib/md_common.jar$cp_delim$MAGICDRAW_HOME/lib/jna.jar"

java -Xmx1200M -Xss1024K \
       -Dmd.class.path=$md_cp_url \
       -Dcom.nomagic.osgi.config.dir="$MAGICDRAW_HOME/configuration" \
       -Desi.system.config="$MAGICDRAW_HOME/data/application.conf" \
       -Dlogback.configurationFile="$MAGICDRAW_HOME/data/logback.xml" \
       -Dcom.nomagic.magicdraw.launcher=org.openehr.docs.magicdraw.AsciidocCommandLine  \
       -cp "$CP" \
       -Dmd.additional.class.path="$MAGICDRAW_HOME/plugins/org.openehr.docs.magicdraw/OpenEhrModelExporter.jar"  \
       com.nomagic.osgi.launcher.ProductionFrameworkLauncher $@
