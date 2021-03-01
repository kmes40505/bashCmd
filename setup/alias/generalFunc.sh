#!/bin/bash

function cdup {
    local count=1;
    local execmd="./";
    while [[ $count -le ${1} ]]; do
        execmd="${execmd}../";
		((count+=1));
    done
    cd $execmd;
}

function permanentAlias {
	if [ -z "${1}" -o -z "${2}" -o -z "${3}" ];
	then
		echo "3 input required for permanentAlias 1:name 2:content 3:file location";
		return;
	fi

    local aliasCmd="alias ${1}='${2}'";
    local location="${3}";

    if [ ! -e "$location" ];
    then
        echo '#!/bin/bash' >> "$location";
    fi

    alias ${1}="${2}";

    local setStr="/^alias ${1}=.*/d";
    sed -i "$setStr" "$location";
    echo ${aliasCmd} >> "$location";
}

function rmPerAlias {
	if [ -z "${1}" -o -z "${2}" ];
	then
		echo "2 input required for permanentAlias 1:name 2:file location";
		return;
	fi

    local target="${2}";
    if [ ! -e "$target" ];
    then
        return;
    fi

    local name="alias ${1}=";
    if [ -z  "`grep \"${name}\" \"${target}\"`" ];
    then
        echo "alias ${1} not found";
        return;
    fi

    local setStr="/^${name}.*/d";
    sed -i "$setStr" "$target";

    unalias "${1}";

    if [ -z "`grep alias \"$target\"`" ];
    then
        rm "$target";
    fi
}

function lsPerAlias {
    if [ ! -e "${1}" ];
    then
        echo "no ${2} custom alias exists yet";
    else
        cat "${1}";
    fi
}

function setjump {
    local jumpRec="$BashSetupPath/alias/jumpRec";


    local name="";
    if [ -z "${1}" ];
    then
        name="jmp";

    else
        name="jmp${1}";

    fi

    local pwdPath=`printf "%q" "$(pwd)"`;
	permanentAlias $name "cd $pwdPath" "$jumpRec";
}

function rmjmp {
    local target="$BashSetupPath/alias/jumpRec"

    local name="";
    if [ -z "${1}" ];
    then
        echo "input required. i.e. remove jmptest requires input 'test'";
        return;
    else
    	rmPerAlias "jmp"${1} "$target";
    fi
}

function lsjmp {
    lsPerAlias "$BashSetupPath/alias/jumpRec" "jmp"
}

function cpmulti {
	local count=1;
	while [[ $count -lt $# ]]; do
		echo ${!count};
		cp -r "${!count}" "${!#}";
		((count+=1));
	done
}

function setssh {
    local sshRec="$BashSetupPath/alias/sshRec";

    local sshname="";
    local sftpname="";
    if [ -z "${1}" ] || [ -z "${2}" ];
    then
        echo "requires a name and login info: i.e.: setssh School chenhsi8@remote.ecf.utoronto.ca";
        return;
    else
        sshname="ssh${1}";
        sftpname="sftp${1}";
    fi

    permanentAlias $sshname "ssh -t ${2} exec bash --init-file setup/index" "$sshRec";
    permanentAlias $sftpname "sftp ${2}" "$sshRec";
}

function rmssh {
    local target="$BashSetupPath/alias/sshRec"

    local sshname="";
    local sftpname="";

    if [ -z "${1}" ];
    then
        echo "input required. i.e. remove sshtest requires input 'test'";
        return;
    else
        sshname="ssh${1}";
        sftpname="sftp${1}";
    fi

    rmPerAlias $sshname "$target";
    rmPerAlias $sftpname "$target";
}

function lsssh {
    lsPerAlias "$BashSetupPath/alias/sshRec" "ssh"
}

function setalias {
    local aliasRec="$BashSetupPath/alias/aliasRec";

    local name="";
    local instruction="";
    if [ -z "${1}" ] || [ -z "${2}" ] || [ -n "${3}" ];
    then
        echo "requires a name and instruction: i.e.: setalias test \"echo test\"";
        return;
    else
        name="${1}";
        instruction="${2}";
    fi

    permanentAlias $name "$instruction" "$aliasRec";
}

function rmalias {
    local aliasRec="$BashSetupPath/alias/aliasRec";

    local name="";
    if [ -z "${1}" ];
    then
        echo "alias name required";
        return;
    else
        rmPerAlias ${1} "$aliasRec";
    fi
}

function lsalias {
    lsPerAlias "$BashSetupPath/alias/aliasRec" "random name"
}

function cleanjmp {
    local jumpRec="$BashSetupPath/alias/jumpRec";

    if [ ! -e "$jumpRec" ];
    then
        return;
    fi

    local deleArray;
    local idx=0;
    while read line; do
        local cmdName=`echo $line | sed -n "s/.*alias jmp\(.*\)=.*/\1/p"`;
        local dirPath=`echo $line | sed -n "s/.*alias jmp[^/]*\([^']*\).*/\1/p"`;
        if [ ! -z $cmdName ] && [ ! -e "$dirPath" ];
        then
        echo $cmdName;
            deleArray[idx]=$cmdName;
            ((idx+=1));
            continue;
        fi
    done < "$jumpRec";

    for cmd in "${deleArray[@]}"
    do
       rmjmp $cmd;
    done

    unset deleArray;
}

function lscmd {
    local funcFile="$BashSetupPath/alias/generalFunc";
    sed -n "s/\(^ *function \(.*\) {.*\)/\2/p" "$funcFile";
}