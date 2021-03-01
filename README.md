# bashCmd

## Run ". ~/setup/index.sh" in .bashrc to setup the command. All commands are cross bash sessions

cdup {Number}: go up {Number} level of directories

setjump {Name(optional): string}: create a alias jmp{name} to cd to the current directory and save the command into a file for future terminal session

rmjmp {Name(optional): string}: remove jmp{name} alias

lsjmp: list all existing jmp commands

cleanjmp: iterate through all existing jmp alias and remove ones which destination doesnt exist anymore

cpmulti {files: 1+ strings} {destination directory: string}: copy all {files} into destination

setssh {Name: string} {ssh accout/url: string}: create ssh{Name}, sftp{Name} alias of {ssh/sftp command}

rmssh {Name: string}: remove ssh{Name}, sftp{Name} alias

lsssh: list all existing ssh/sftp alias

setAlias {Name: string} {command: string}: create alias that runs {command}

rmalias {Name: string}: remove alias {Name}

lsalias: list all existing alias

lscmd: list all commands
