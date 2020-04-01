# Backup mechanism Postgres DB.

pobackup is shell tool for control/operating PostgreSQL backup.

Developed in bash code: 100%.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/pobackup.svg)](https://github.com/vroncevic/pobackup/issues)
 [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/pobackup.svg)](https://github.com/vroncevic/pobackup/graphs/contributors)

### INSTALLATION

Navigate to release [page](https://github.com/vroncevic/pobackup/releases) download and extract release archive.

To install modules type the following:

```
tar xvzf pobackup-x.y.z.tar.gz
cd pobackup-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/pobackup/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/pobackup/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/pobackup/ver.1.0/
```

Or You can use docker to create image/container.

:sparkles:

### USAGE

```
# Create symlink for shell tool
ln -s /root/scripts/pobackup/ver.1.0/bin/pobackup.sh /root/bin/pobackup

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating PostgreSQL backup
pobackup
```

### DEPENDENCIES

This tool requires these other modules and libraries:

* sh_util https://github.com/vroncevic/sh_util

### SHELL TOOL STRUCTURE

pobackup is based on MOP.

Shell tool structure:
```
.
├── bin/
│   └── pobackup.sh
├── conf/
│   ├── pobackup.cfg
│   └── pobackup_util.cfg
└── log/
    └── pobackup.log
```

### DOCS

[![Documentation Status](https://readthedocs.org/projects/pobackup/badge/?version=latest)](https://pobackup.readthedocs.io/projects/pobackup/en/latest/?badge=latest)

More documentation and info at:

* https://pobackup.readthedocs.io/en/latest/

:sparkles:

### COPYRIGHT AND LICENCE

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2018 by https://vroncevic.github.io/pobackup

This tool is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

:sparkles:

