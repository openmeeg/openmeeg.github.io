Context
=======

.. image:: _static/surf3.png
    :width: 400px

The forward problem consists in simulating the electric potential (EEG)
and magnetic fields (MEG) on the sensors due to electrical sources
within the brain.

.. image:: _static/dipole.png
    :width: 400px

The potential is computed on **all surfaces** of the head model
(scalp, outer skull and inner skull for a three-layer model). Let
:math:`\mathbf{X}` contain the values of the potential on the
discretized surfaces, as well as the values of the normal current. The
Boundary Element Method leads to a linear system:

.. math:: \mathbf{HeadMat} . \mathbf{X} = \mathbf{SourceMat}

See sections :ref:`command_assemble_headmat`, :ref:`command_assemble_sourcemat`
and :ref:`command_invert_headmat`.

The matrices relating the head model surfaces and the sensor data
must be computed. These are different for EEG and for MEG.
For EEG, the potential is interpolated from the surface discretization
points to the sensor positions through a simple linear transformation:

.. math::

   \left[ potential at sensors \right] =
       \left[ interpolation matrix \right] \times \left[ potential at interfaces \right] in the case of EEG.

For MEG, the Biot and Savart equation allows to identify two
contributions to the magnetic field: one which comes directly from the
sources, and an ohmic contribution which comes from the volume
conductor. Hence two linear transformations must be computed, one from
the source locations to MEG sensors, the other from the head model
interfaces to the MEG sensors.

See section [sect: command assemble sensors].

 : the matrix relating the sources (at fixed positions and orientations)
to the sensors is now ready to be computed (section [sect: command
gain]). This matrix is called the **gain matrix** and is denoted
:math:`\mathbf{G}`. The gain matrix is then applied to the source
activation to simulate the forward problem (section [sect: command
direct]).

Data
====

This chapter describes the type of data that is required to run a
forward problem with OpenMEEG. More detail on the data format is
provided in Appendix [chap:format].

|  :
| Meshes describing the interfaces between regions of homogeneous
conductivity. These meshes generally represent:

-  the inner skull surface

-  the outer skull surface

-  the outer scalp surface

The recommended mesh size is approximately 600 to 800 points per
surface.

|  :
| Sources can be of two types: isolated or distributed. For distributed
sources, a source mesh describes their support. This is a detailed mesh
generally covering the whole cortex. The mesh size should not exceed 35
000 points. The source amplitude is represented as continuous, and
linear on each of the mesh triangles. The source orientation is modeled
as piecewise constant, normal to each of the mesh triangles.

| |image3|
| Source mesh

Isolated sources are the superposition of current dipoles, each of which
is defined by its position and its moment.

 : For EEG, the sensors are defined by the list of the x-y-z coordinates
of the electrode positions. The electrodes are considered punctual and
are called *patches*. The MEG sensor description is more complex, see
Appendix [chap:format].

Commands
========

In the following, the binaries in , the options in , the inputs are in
**black** and the outputs in .

.. _command_assemble_headmat:

Head Matrix assembly :math:`\mathbf{HeadMat}`:
----------------------------------------------

Inputs:

-  subject.geom: geometry description file (see Appendix [sec:geom])

-  subject.cond: conductivity description file (see Appendix [sec:cond])

Output:

-  : binary file containing the matrix :math:`\mathbf{HeadMat}`
   (symmetric format).

The symmetric format only stores the lower half of a matrix.

Note: the abbreviated option names or can be used instead of .

.. _command_assemble_sourcemat:

Source matrix assembly :math:`\mathbf{Source}`:
-----------------------------------------------

Inputs:

-  subject.geom: geometry description file (see Appendix [sec:geom])

-  subject.cond: conductivity description file (see Appendix [sec:cond])

-  the source(s):

   [dipolar case
       ] dipolePosition.dip: dipole description file (list of
       coordinates and orientations) (see Appendix [sec:dipoles])

   [case of distributed sources
       ] sourcemesh: source mesh (accepted formats: \*.tri or \*.mesh of
       BrainVisa, or \*.vtk)

Output:

-  : binary file containing :math:`\mathbf{SourceMat}`

| For dipolar sources:
|  Note: the abbreviated option names or can be used instead of .

| For distributed sources:
|  Note: the abbreviated option names or can be used instead of .

.. _command_invert_headmat:

:math:`\mathbf{HeadMat}` matrix inversion:
------------------------------------------

Inputs:

-  HeadMat.bin: binary file containing matrix :math:`\mathbf{HeadMat}`
   (symmetric format)

Output:

-  : binary file containing matrix :math:`\mathbf{HeadMat}^{-1}`
   (symmetric format)

Linear transformation from X to the sensor potential:
-----------------------------------------------------

[sect: command assemble sensors]

| ****:

A linear interpolation is computed which relates X to the electrode
potential through the linear transformation:

.. math:: \mathbf{V_{electrode}} = \mathbf{Head2EEG} . \mathbf{X}

 where:

-  :math:`\mathbf{V_{electrode}}` is the column-vector of potential
   values at the sensors (output of EEG forward problem),

-  :math:`\mathbf{X}` is the column-vector containing the values of the
   potential and the normal current on all the surface of the model,

-  :math:`\mathbf{Head2EEGMat}` is the linear transformation to be
   computed.

Inputs:

-  subject.geom: geometry description file (see Appendix [sec:geom])

-  subject.cond: conductivity description file (see Appendix [sec:cond])

-  patchespositions.txt: file containing the positions of the EEG
   electrodes (see Appendix [sec:sensors])

Sortie:

-  : file containing the matrix :math:`\mathbf{Head2EEGMat}` (sparse
   format)

The sparse format allows to store efficiently matrices containing a
small proportion of non-zero values.

Note: the abbreviated option names or can be used instead of .

| ****:
| In the case of MEG there are more matrices to assemble, as explained
in section []. The magnetic field is related both to the sources
directly, as well as to the electric potential, according to:

.. math:: \mathbf{M_{sensor}} = \mathbf{Source2MEGMat} . \mathbf{S} + \mathbf{Head2MEGMat}.\mathbf{X}

| :
| Inputs:

-  subject.geom: geometry description file (see Appendix [sec:geom])

-  subject.cond: conductivity description file (see Appendix [sec:cond])

-  sensorpositions.txt: positions and orientations of MEG sensors (see
   Appendix [sec:sensors])

Output:

-  : binary file containing :math:`\mathbf{Head2MEGMat}`

Note: the abbreviated option names or can be used instead of .

| :
| Inputs:

-  the source(s):

   [dipolar sources
       ] dipolePosition.dip: dipole description file (list of
       coordinates and orientations) (see Appendix [sec:dipoles])

   [distributed sources
       ] sourcemesh: source mesh (accepted formats: \*.tri or \*.mesh of
       BrainVisa, or \*.vtk)

-  sensorpositions.txt: positions and orientations of MEG sensors (see
   Appendix [sec:sensors])

Output:

-  | : binary file containing :math:`\mathbf{DipSource2MEGMat}`

-  or : binary file containing :math:`\mathbf{SurfSource2MEGMat}`

| For dipolar sources:
|  Note: the abbreviated option names or can be used instead of .

| For distributed sources:
|  Note: the abbreviated option names or can be used instead of .

Gain matrix computation:
------------------------

[sect: command gain]

The gain matrix represents the linear transformation relating the
activation of sources, at **predefined positions and orientations** to
the values of the fields of interest (electric potential or magnetic
field) at predefined sensor positions (and orientations for MEG).

| ****:
| Inputs:

-  HeadMatInv.bin: binary file containing :math:`\mathbf{HeadMat}^{-1}`
   (symmetric format)

-  SourceMat.bin: binary file containing either
   :math:`\mathbf{SurfSourceMat}` or :math:`\mathbf{DipSourceMat}`

-  Head2EEGMat.bin: binary file containing :math:`\mathbf{Head2EEGMat}`
   (sparse format)

Output:

-  : binary file contining the gain matrix

| ****:
| Inputs:

-  HeadMatInv.bin: binary file containing :math:`\mathbf{HeadMat}^{-1}`
   (symmetric format)

-  SourceMat.bin: binary file containing either
   :math:`\mathbf{SurfSourceMat}` or :math:`\mathbf{DipSourceMat}`

-  Head2MEGMat.bin: binary file containing :math:`\mathbf{Head2MEGMat}`

-  Source2MEGMat.bin:binary file containing either
   :math:`\mathbf{DipSource2MEGMat}` or
   :math:`\mathbf{SurfSource2MEGMat}`

Output:

-  : binary file containing the gain matrix

The forward problem:
--------------------

[sect: command direct]

Once the gain matrix is computed, the forward problem amounts to
defining the source activation, and applying the gain matrix to this
activation.

Inputs:

-  GainMat.bin: binary file containing EEG or MEG gain matrix

-  activationSources.txt: file describing the source activation (see
   Appendix [sec:activ])

-  noise: noise (zero, or positive real number)

Output:

-  : file containing the simulated sensor data.

Data format
===========

[chap:format]

Geometry description file
-------------------------

[sec:geom] The geometry description file provides

-  the number of the meshed surfaces separating the different domains,

-  the names of the files corresponding to these surfaces,

-  the number of domains of homogeneous conductivity,

-  the positions of the domains with respect to the interfaces (inside or
   outside)

The geometry description file should have as extension: \*.geom

|image4|

“Meshes paths” can be

-  global (as on drawing)

-  relative to where the command line is executed

For the meshes, the following formats are allowed :

-  \*.tri : TRI format corresponding to early BrainVisa. Also handled by
   Anatomist.

-  \*.mesh : MESH format corresponding to BrainVisa versions 3.0.2 and
   later. Also handled by Anatomist.

-  \*.gii : Gifti mesh format.

-  \*.off : ASCII mesh format.

-  \*.bnd : ASCII mesh format.

-  \*.vtk : VTK mesh format.

Conductivity description file
-----------------------------

[sec:cond]

| The conductivity description file defines the conductivity values
corresponding to each domain listed in the Geometry Description File
(section [sec:geom]).
| The file extension should be: \*.cond .

|image5|

Source description
------------------

Sources are defined by their geometry (position and orientation) and
their magnitude. OpenMEEG handles two types of source models: isolated
dipoles, or distributed dipoles: these two models differ in their
geometry description.

Source position and orientation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[sec:dipoles]

Isolated dipoles
^^^^^^^^^^^^^^^^

Isolated dipoles are represented by a text file (extension \*.dip or
\*.txt), in which each line defines a dipole position and orientation,
encoded in 6 real values:

-  three values encoding the Cartesian coordinate for the position,

-  three values encoding the orientation of the dipole (supposed
   unitary).

The following example shows a file describing 5 isolated dipoles:

|image6|

The referential of the coordinates should be the same as for the meshes
(the MR coordinates in general).

Distributed dipoles
^^^^^^^^^^^^^^^^^^^

Distributed dipoles are supported on a mesh, whose format must be
\*.mesh, \*.tri, \*.vtk, \*.bnd, \*.off, or \*.gii.

Source activation
~~~~~~~~~~~~~~~~~

[sec:activ]

Source activation files are text files, in which each line corresponds
to a source, and each column to a time sample.

-  for isolated dipoles, the nth line corresponds to the amplitude of
   the nth dipole (with its fixed orientation)

-  for distributed dipoles, the nth line correspond to the amplitude of
   the nth vertex in the source mesh.

Example for isolated dipoles:

|image7|

Sensor definition
-----------------

[sec:sensors]

The sensor definition is provided in a text file, in which each line
provides the position of the sensor, and additional information such as
its orientation or its name. More precisely, there are 5 options for
defining sensors:

#. 1 line per sensor and 3 columns (typically for EEG sensors or MEG
   sensors without orientation) :

   -  the 1st, 2nd and 3rd columns are respectively position coordinates
      x, y, z of sensor

#. 1 line per sensor and 4 columns (typically for EEG sensors or MEG
   sensors without orientation) :

   -  the 1st column is sensors names

   -  the 2nd, 3rd and 4th are respectively position coordinates x, y, z
      of sensor

#. 1 line per sensor and 6 columns (typically for MEG sensors) :

   -  the 1st, 2nd and 3rd are respectively position coordinates x, y, z
      of sensor

   -  the 4th, 5th and 6th are coordinates of vector orientation

#. 1 line per sensor and 7 columns (typically for MEG sensors) :

   -  the 1st column is sensors names

   -  the 2nd, 3rd and 4th are respectively position coordinates x, y, z
      of sensor

   -  the 5th, 6th and 7th are coordinates of vector orientation

#. 1 line per integration point for each sensor and 8 columns (typically
   for MEG realistic sensors with coils, or gradiometers) :

   -  the 1st column is sensors names

   -  the 2nd, 3rd and 4th are respectively position coordinates x, y, z
      of sensor

   -  the 5th, 6th and 7th are coordinates of vector orientation

   -  the 8th is the weight to apply for numerical integration (related
      to sensor name)

An example of MEG sensor description:

|image8|

.. |image1| image:: _static/surf3.png
.. |image2| image:: _static/dipole.png
.. |image3| image:: _static/cortex.png
.. |image4| image:: _static/geom2.png
.. |image5| image:: _static/cond.png
.. |image6| image:: _static/dipolePositions_en.png
.. |image7| image:: _static/dipActiv.png
.. |image8| image:: _static/sensors-grad.png
