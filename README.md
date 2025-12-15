# Backup mechanism Postgres DB

<img align="right" src="https://raw.githubusercontent.com/vroncevic/pobackup/dev/docs/pobackup_logo.png" width="25%">

**pobackup** is shell tool for control/operating PostgreSQL backup.

Developed in **[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))** code: **100%**.

[![pobackup_shell_checker](https://github.com/vroncevic/pobackup/actions/workflows/pobackup_shell_checker.yml/badge.svg)](https://github.com/vroncevic/pobackup/actions/workflows/pobackup_shell_checker.yml)

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/pobackup.svg)](https://github.com/vroncevic/pobackup/issues) [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/pobackup.svg)](https://github.com/vroncevic/pobackup/graphs/contributors)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Shell tool structure](#shell-tool-structure)
- [Docs](#docs)
- [Copyright and licence](#copyright-and-licence)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

![Debian Linux OS](https://raw.githubusercontent.com/vroncevic/pobackup/dev/docs/debtux.png)

Navigate to release **[page](https://github.com/vroncevic/pobackup/releases)** download and extract release archive.

To install **pobackup** type the following

```bash
tar xvzf pobackup-3.0.tar.gz
cd pobackup-3.0
cp -R ~/sh_tool/bin/   /root/scripts/pobackup/ver.3.0/
cp -R ~/sh_tool/conf/  /root/scripts/pobackup/ver.3.0/
cp -R ~/sh_tool/log/   /root/scripts/pobackup/ver.3.0/
```

Self generated setup script and execution

```bash
./pobackup_setup.sh

[setup] installing App/Tool/Script pobackup
	Mon Dec 15 05:33:38 PM CET 2025
[setup] clean up App/Tool/Script structure
[setup] copy App/Tool/Script structure
[setup] remove github editor configuration files
[setup] set App/Tool/Script permission
[setup] create symbolic link of App/Tool/Script
[setup] done

/root/scripts/pobackup/ver.3.0/
├── bin/
│   └── pobackup.sh
├── conf/
│   ├── pobackup.cfg
│   ├── pobackup.logo
│   └── pobackup_util.cfg
└── log/
    └── pobackup.log

4 directories, 5 files
lrwxrwxrwx 1 root root 46 Dec 15 05:33 /root/bin/pobackup -> /root/scripts/pobackup/ver.3.0/bin/pobackup.sh
```

Or You can use docker to create image/container.

### Usage

```bash
# Create symlink for shell tool
ln -s /root/scripts/pobackup/ver.3.0/bin/pobackup.sh /root/bin/pobackup

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating PostgreSQL backup
pobackup help

pobackup ver.3.0
Mon Dec 15 05:33:58 PM CET 2025

[check_root] Check permission for current session? [ok]
[check_root] Done

                                                                      
                    ██                        ██                      
                   ░██                       ░██                      
   ██████   ██████ ░██       ██████    █████ ░██  ██ ██   ██ ██████   
  ░██░░░██ ██░░░░██░██████  ░░░░░░██  ██░░░██░██ ██ ░██  ░██░██░░░██  
  ░██  ░██░██   ░██░██░░░██  ███████ ░██  ░░ ░████  ░██  ░██░██  ░██  
  ░██████ ░██   ░██░██  ░██ ██░░░░██ ░██   ██░██░██ ░██  ░██░██████   
  ░██░░░  ░░██████ ░██████ ░░████████░░█████ ░██░░██░░██████░██░░░    
  ░██      ░░░░░░  ░░░░░    ░░░░░░░░  ░░░░░  ░░  ░░  ░░░░░░ ░██       
  ░░                                                        ░░        
                                                                      
	                                               
		Info   github.io/pobackup ver.3.0 
		Issue  github.io/issue
		Author vroncevic.github.io

  [Usage] pobackup [OPTIONS]
  [OPTIONS]
  [OPTION] help (optional)
  # Postgres backup mechanism
  pobackup help
  [help | h] print this option
```

### Dependencies

**pobackup** requires next modules and libraries
* pobackup [https://github.com/vroncevic/pobackup](https://github.com/vroncevic/pobackup)

### Shell tool structure

**pobackup** is based on MOP.

Shell tool structure

```bash
sh_tool/
├── bin/
│   └── pobackup.sh
├── conf/
│   ├── pobackup.cfg
│   ├── pobackup.logo
│   └── pobackup_util.cfg
└── log/
    └── pobackup.log
```

### Docs

[![Documentation Status](https://readthedocs.org/projects/pobackup/badge/?version=latest)](https://pobackup.readthedocs.io/projects/pobackup/en/latest/?badge=latest)

More documentation and info at
* [https://pobackup.readthedocs.io/en/latest/](https://pobackup.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

### Copyright and licence

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2016 - 2026 by [vroncevic.github.io/pobackup](https://vroncevic.github.io/pobackup)

**pobackup** is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

[![Free Software Foundation](https://raw.githubusercontent.com/vroncevic/pobackup/dev/docs/fsf-logo_1.png)](https://my.fsf.org/)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://my.fsf.org/donate/)
