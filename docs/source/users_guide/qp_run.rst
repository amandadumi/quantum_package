.. _qp_run:

qp_run
======

.. TODO

.. program:: qp_run

Command used to run a calculation.

Usage
-----

.. code:: bash

   qp_run [-slave] [-help] <PROGRAM> <EZFIO_DIRECTORY>


.. option:: -help

   Displays the list of available |qp| programs. 


.. option:: -slave

   This option needs to be set when ``PROGRAM`` is a slave program, to accelerate
   another running instance of the |qp|.


Example
-------

.. code:: bash

   qp_run FCI h2o.ezfio


