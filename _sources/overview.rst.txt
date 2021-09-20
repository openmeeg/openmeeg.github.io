Overview
========


What is OpenMEEG?
-----------------

    * The OpenMEEG software is developed within the `Athena project-team <https://team.inria.fr/athena/>`_ at INRIA Sophia-Antipolis.
    * It was initiated in 2006 by the Odyssee Project Team (INRIA/ENPC/ENS Ulm).
    * OpenMEEG solves forward problems related to Magneto- and Electro-encephalography (MEG and EEG).
    * The forward problem uses the symmetric Boundary Element Method (symmetric BEM), providing excellent accuracy (see :ref:`publications`).

Using OpenMEEG
-----------------

    * From Matlab using `Brainstorm <http://neuroimage.usc.edu/brainstorm/Tutorials/TutBem>`_ or `FieldTrip <http://www.fieldtriptoolbox.org>`_

    * For general lead fields computation (EEG, MEG, EIT, Internal potential):

        * From `Python <https://raw.github.com/openmeeg/openmeeg_sample_data/master/compute_leadfields.py>`_
        * From a `Bash <https://raw.github.com/openmeeg/openmeeg_sample_data/master/compute_leadfields.sh>`_ script on Unix systems (Linux/Mac).
        * From a `BAT <https://raw.github.com/openmeeg/openmeeg_sample_data/master/compute_leadfields.bat>`_ file on Windows.

.. raw:: html

  Works with:
  <div class="logo" style="text-align: center; margin: -7px 0 -10px 0;">

.. image:: _static/logo_brainstorm.png
   :width: 200px
   :target: http://neuroimage.usc.edu/brainstorm

.. image:: _static/logo_fieldtrip.png
   :width: 130px
   :target: http://fieldtrip.fcdonders.nl

.. image:: _static/nutmeglogo.png
   :width: 130px
   :target: http://www.nitrc.org/plugins/mwiki/index.php/nutmeg:MainPage

.. image:: _static/pythonlogo.png
   :width: 170px
   :target: http://python.org

.. raw:: html

  </div>

Cite OpenMEEG
-------------

The references to be acknowledged are:

    - Gramfort A., Papadopoulo T., Olivi E., Clerc M. `OpenMEEG: opensource
      software for quasistatic bioelectromagnetics <http://www.biomedical-engineering-online.com/content/9/1/45>`_,
      BioMedical Engineering OnLine 45:9, 2010

    - Kybic J., Clerc M., Abboud T., Faugeras O., Keriven R., Papadopoulo T. `A common formalism for the integral formulations of the forward EEG problem <http://ieeexplore.ieee.org/xpls/abs_all.jsp?isnumber=30034&arnumber=1375158&count=10&index=1>`_. IEEE Transactions on Medical Imaging, 24:12-28, 2005. `[PDF] <ftp://ftp-sop.inria.fr/odyssee/Publications/2005/kybic-clerc-etal:05.pdf>`_
