#!/bin/bash
export BashSetupPath=$(dirname "$BASH_SOURCE");
export SHELL=`which bash`;

for files in "$BashSetupPath/alias"/*
do
	. "$files";
done

if [[ `uname -o` == "Cygwin" ]];
then
	mount -f C: /c;
	mount -f D: /d;
	alias start='cygstart';
	alias open='cygstart';
else
	export PS1='\n$(whoami) $(pwd)\n\$ ';
fi

winpath=$(echo $MSYS2_WINPATH | tr ";" "\n" | sed -e 's/\\/\\\\/g' | xargs -I {} cygpath -u {})
unixpath=''

# Set delimiter to new line
IFS=$'\n'

for pth in $winpath; do unixpath+=$(echo $pth)":"; done

export PATH=$(echo $PATH:$unixpath | sed -e 's/:$//g')
unset IFS
unset unixpath
unset winpath
