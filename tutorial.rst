.. _tutorial:

======================
Tutorial
======================

.. contents:: Table of Contents
   :local:
   :depth: 2

Data
####

This section describes the type of data that is required to run a forward problem with OpenMEEG.


Meshes
------

Meshes describing the interfaces between regions of homogeneous conductivity. These meshes generally represent:

  - the inner skull surface
  - the outer skull surface
  - the outer scalp surface

The recommended mesh size is approximately 600 to 800 points per surface.

.. image:: _static/tete_couches_brain.png
   :width: 300 px
   :alt: External surface of the cortex
   :align: center

Example with three surfaces: outer scalp (gray), outer skull (blue) and inner skull (pink):

.. image:: _static/tete_couches_brainskullhead.png
   :width: 300 px
   :alt: Example with three surfaces: outer scalp (gray), 
   :align: center

Sources
-------

Sources can be of two types: isolated or distributed.


For distributed sources, a source mesh describes their support. This is a detailed
mesh generally covering the whole cortex. The mesh size should not exceed 35 000 points.
The source amplitude is represented as continuous, and linear on each of the mesh triangles.
The source orientation is modeled as piecewise constant, normal to each of the mesh triangles.

.. image:: _static/cortex.png
   :width: 300 px
   :alt: Cortex
   :align: center

Isolated sources are the superposition of current dipoles, each of which is defined by its position and its moment.

Sensors
-------

For EEG, the sensors are defined by the list of the x-y-z coordinates of the electrode
positions. The electrodes are considered punctual and are called *patches*.
The MEG sensor description is more complex, see Appendix~\ref{chap:format}.
