#!/bin/bash
# java-install.sh
#

# Author: Paul Combs
# Website: http://it.megocollector.com
# Summary: An automated script to install Sun Java JDK on CentOS / RHEL.

#----------------------------------------------------------------------------------
# Changelog
#----------------------------------------------------------------------------------

# 2013-0425 - FIX: Download failed. Added wget option --no-check-certificate
#             Successfully tested with Java JDK 6 Update 45

# 2012-0831 - FIX: Download failed. Added wget options --no-cookies --header
#             Successfully tested with Java JDK 6 Update 35

# 2012-0302 - Initial build. Successfully tested with Java JDK 6 Update 18

#----------------------------------------------------------------------------------
# USER VARIABLES
#----------------------------------------------------------------------------------

# Change the GET_JAVA variable to the link to the appropriate version of Java JDK.
GET_JAVA=http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64-rpm.bin

# DO NOT EDIT ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING.

#----------------------------------------------------------------------------------
# INSTALLATION / CONFIGURATION
#----------------------------------------------------------------------------------

JAVA_FNAME=${GET_JAVA##*/}
JAVA_BASE_NAME=${JAVA_FNAME%-rpm.bin}

# Determine if the environment variables have been applied.
#Source: http://www.linuxquestions.org/questions/linux-newbie-8/sed-append-text-to-end-of-line-if-line-contains-specific-text-how-can-this-be-done-684650/
grep -q "export JAVA_HOME=/usr/java/default" /etc/profile 2> /dev/null || echo "" >> /etc/profile
grep -q "export JAVA_HOME=/usr/java/default" /etc/profile 2> /dev/null || echo "export JAVA_HOME=/usr/java/default" >> /etc/profile
grep -q "export PATH=\$JAVA_HOME/bin:\$PATH" /etc/profile 2> /dev/null || echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile

# Determine if this file already exists.  There is no reason to download it again.
# Source: http://forum.codecall.net/bash-shell-scripting/17864-linux-bash-check-if-file-exists.html
if [ -f $JAVA_FNAME ]
then
    echo "" &> /dev/null
else
#   wget $GET_JAVA
	wget --no-check-certificate --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" $GET_JAVA
# 	Source: http://stackoverflow.com/questions/10268583/cant-install-java-jdk-on-linux-through-wget-is-there-a-workaround
fi

	echo $JAVA_FNAME?AuthParam=* > $JAVA_FNAME.txt

if [ -f $JAVA_FNAME.txt ]
then
	longname=`cat $JAVA_FNAME.txt`
	mv $longname $JAVA_FNAME
	rm $JAVA_FNAME.txt
else
    echo "" &> /dev/null	
fi

echo "$JAVA_FNAME download complete."
chmod 755 $JAVA_FNAME

# Accept the prompts, automatically.
# Source: http://www.unix.com/shell-programming-scripting/116174-how-install-jdk-bin-using-shell-script-auto-yes-no.html
echo "Patching $JAVA_FNAME."
sed -i 's/agreed=/agreed=1/g' $JAVA_FNAME
sed -i 's/more <<"EOF"/cat <<"EOF"/g' $JAVA_FNAME
echo q | ./$JAVA_FNAME
rpm -Uvh $JAVA_BASE_NAME.rpm 2> /dev/null

# Cleanup
echo "Removing installation files."
rm -f $JAVA_BASE_NAME.rpm $JAVA_FNAME sun-javadb-*.rpm
echo "Done."
java -version
