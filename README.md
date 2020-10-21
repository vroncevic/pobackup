# Backup mechanism Postgres DB

**pobackup** is shell tool for control/operating PostgreSQL backup.

Developed in **[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))** code: **100%**.

[![pobackup shell checker](https://github.com/vroncevic/pobackup/workflows/pobackup%20shell%20checker/badge.svg)](https://github.com/vroncevic/pobackup/actions?query=workflow%3A%22pobackup+shell+checker%22)

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

Navigate to release **[page](https://github.com/vroncevic/pobackup/releases)** download and extract release archive.

To install **pobackup** type the following:

```
tar xvzf pobackup-x.y.z.tar.gz
cd pobackup-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/pobackup/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/pobackup/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/pobackup/ver.1.0/
```

![alt tag](https://raw.githubusercontent.com/vroncevic/pobackup/dev/docs/setup_tree.png)

Or You can use docker to create image/container.

[![pobackup docker checker](https://github.com/vroncevic/pobackup/workflows/pobackup%20docker%20checker/badge.svg)](https://github.com/vroncevic/pobackup/actions?query=workflow%3A%22pobackup+docker+checker%22)

### Usage

```
# Create symlink for shell tool
ln -s /root/scripts/pobackup/ver.1.0/bin/pobackup.sh /root/bin/pobackup

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating PostgreSQL backup
pobackup
```

### Dependencies

**pobackup** requires next modules and libraries:
* sh_util [https://github.com/vroncevic/sh_util](https://github.com/vroncevic/sh_util)

### Shell tool structure

**pobackup** is based on MOP.

Code structure:
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

### Docs

[![Documentation Status](https://readthedocs.org/projects/pobackup/badge/?version=latest)](https://pobackup.readthedocs.io/projects/pobackup/en/latest/?badge=latest)

More documentation and info at:
* [https://pobackup.readthedocs.io/en/latest/](https://pobackup.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

### Copyright and licence

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2016 by [vroncevic.github.io/pobackup](https://vroncevic.github.io/pobackup)

**pobackup** is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

[![Free Software Foundation](https://raw.githubusercontent.com/vroncevic/pobackup/dev/docs/fsf-logo_1.png)](https://my.fsf.org/)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://my.fsf.org/donate/)
