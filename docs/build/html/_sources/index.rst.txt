pobackup
---------

**pobackup** is shell tool for controlling/operating PostgreSQL backup.

Developed in `bash <https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_ code: **100%**.

|GitHub shell checker|

.. |GitHub shell checker| image:: https://github.com/vroncevic/pobackup/actions/workflows/pobackup_shell_checker.yml/badge.svg
   :target: https://github.com/vroncevic/pobackup/actions/workflows/pobackup_shell_checker.yml

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/pobackup.svg
   :target: https://github.com/vroncevic/pobackup/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/pobackup.svg
   :target: https://github.com/vroncevic/pobackup/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/pobackup/badge/?version=latest
   :target: https://pobackup.readthedocs.io/projects/pobackup/en/latest/?badge=latest

.. toctree::
    :hidden:

    self

Installation
-------------

|Debian Linux OS|

.. |Debian Linux OS| image:: https://raw.githubusercontent.com/vroncevic/pobackup/dev/docs/debtux.png
   :target: https://www.debian.org

Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/pobackup/releases

To install **pobackup** type the following

.. code-block:: bash

   tar xvzf pobackup-3.0.tar.gz
   cd pobackup-3.0
   cp -R ~/sh_tool/bin/   /root/scripts/pobackup/ver.3.0/
   cp -R ~/sh_tool/conf/  /root/scripts/pobackup/ver.3.0/
   cp -R ~/sh_tool/log/   /root/scripts/pobackup/ver.3.0/

Or You can use Docker to create image/container.

Dependencies
-------------

**pobackup** requires next modules and libraries

* sh_util `https://github.com/vroncevic/sh_util <https://github.com/vroncevic/sh_util>`_

Shell tool structure
---------------------

**pobackup** is based on MOP.

Shell tool structure

.. code-block:: bash

   sh_tool/
   ├── bin/
   │   └── pobackup.sh
   ├── conf/
   │   ├── pobackup.cfg
   │   ├── pobackup.logo
   │   └── pobackup_util.cfg
   └── log/
       └── pobackup.log

Copyright and licence
----------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2016 - 2026 by `vroncevic.github.io/pobackup <https://vroncevic.github.io/pobackup>`_

**pobackup** is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

|Free Software Foundation|

.. |Free Software Foundation| image:: https://raw.githubusercontent.com/vroncevic/pobackup/dev/docs/fsf-logo_1.png
   :target: https://my.fsf.org/

|Donate|

.. |Donate| image:: https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif
   :target: https://my.fsf.org/donate/

Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
