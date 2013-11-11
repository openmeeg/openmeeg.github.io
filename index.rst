=============
OpenMEEG Home
=============

What is OpenMEEG?
-----------------

    * The OpenMEEG software is developed within the `Athena project-team <http://www-sop.inria.fr/athena>`_ at INRIA Sophia-Antipolis.
    * It was initiated in 2006 by the Odyssee Project Team (INRIA/ENPC/ENS Ulm).
    * OpenMEEG solves forward problems related to Magneto- and Electro-encephalography (MEG and EEG).
    * The forward problem uses the symmetric Boundary Element Method (symmetric BEM), providing excellent accuracy (see :ref:`publications`).

Using OpenMEEG
--------------

    * From Matlab using `Brainstorm <http://neuroimage.usc.edu/brainstorm/Tutorials/TutBem>`_ or `Fieldtrip <http://fieldtrip.fcdonders.nl>`_

    * For general lead fields computation (EEG, MEG, EIT, Internal potential):

        * From `Python <https://raw.github.com/openmeeg/openmeeg/master/examples/compute_leadfields.py>`_
        * From a `Bash <https://raw.github.com/openmeeg/openmeeg/master/examples/compute_leadfields.sh>`_ script on Unix systems (Linux/Mac).
        * From a `BAT <https://github.com/openmeeg/openmeeg/raw/master/examples/compute_leadfields.bat>`_ file on Windows.

`A PDF tutorial <ftp://ftp-sop.inria.fr/odyssee/Publications/2010/OpenMEEGHandsOnTutorial2010.pdf>`_

.. raw:: html

  <div class="logo" style="text-align: center; margin: -7px 0 -10px 0;">

.. image:: _static/logo_brainstorm.png
   :width: 250px
   :target: http://neuroimage.usc.edu/brainstorm

.. image:: _static/logo_fieldtrip.png
   :target: http://fieldtrip.fcdonders.nl

.. image:: _static/python-logo.gif
   :target: http://python.org

.. raw:: html

  </div>

Cite OpenMEEG
-------------

The references to be acknowledged are:

    - A. Gramfort, T. Papadopoulo, E. Olivi, M. Clerc. OpenMEEG: opensource
      software for quasistatic bioelectromagnetics,
      `BioMedical Engineering OnLine 45:9, 2010 <http://www.biomedical-engineering-online.com/content/9/1/45>`_

    - Kybic J, Clerc M, Abboud T, Faugeras O, Keriven R, Papadopoulo T. A common formalism for the integral formulations of the forward EEG problem. IEEE Transactions on Medical Imaging, 24:12-28, 2005. `[PDF] <http://mail.nmr.mgh.harvard.edu/mailman/listinfo/mne_analysis>`_

Table of contents
-----------------

.. toctree::
   :maxdepth: 1

   contact
   why_openmeeg
   hackers_guide
   publications
   whats_new
   tutorial
