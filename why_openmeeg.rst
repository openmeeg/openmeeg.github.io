.. _why_openmeeg:

======================
Why use OpenMEEG?
======================

OpenMEEG offers better precision.

How do you measure precision?
-----------------------------

Relative difference measure (RDM) *(should be close to 0)*:

.. figure:: _static/rdm_def.png
    :alt: Relative difference measure (RDM)
    :align: center

Magnitude error (MAG) *(should be close to 1)*:

.. figure:: _static/mag_def.png
    :alt: Relative difference measure (RDM)
    :align: center

A sample sphere model with 5 dipoles:

.. figure:: _static/sphere_dipoles_3D.png
    :alt: Sphere model with 5 dipoles
    :align: center

.. figure:: _static/sphere_dipoles_3D_zoom.png
    :alt: Sphere model with 5 dipoles (zoom)
    :align: center

Benchmark: OpenMEEG outperforms other implementations
-----------------------------------------------------

.. figure:: _static/bem_comparison_mags.png
    :alt: BEM Comparison MAGs
    :align: center

.. figure:: _static/bem_comparison_rdms.png
    :alt: BEM Comparison RDMs
    :align: center

See the following publication for more details on this comparison between different forward solvers:

    A. Gramfort, T. Papadopoulo, E. Olivi, M. Clerc. OpenMEEG: opensource software for quasistatic bioelectromagnetics, `BioMedical Engineering OnLine 45:9, 2010 <http://www.biomedical-engineering-online.com/content/9/1/45>`_
