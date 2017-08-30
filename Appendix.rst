Appendix
========

This section describes the type of data that is required to run a forward problem with OpenMEEG.

.. _sec.cond:

Geometry and conductivity description file
------------------------------------------

The conductivity description file defines the conductivity values corresponding to each domain listed in the Geometry Description File (`sec.geom`_).

The file extension should be: \*.cond .

.. warning:: the domain names should match the ones defined in the Geometry Description File (beware of differences in upper/lower case).

.. image:: _static/cond.png
   :width: 600 px
   :alt: Conductivity
   :align: center

.. _sec.meshes:

Meshes
------

Meshes describing the interfaces between regions of homogeneous conductivity. These meshes generally represent:

  - the inner skull surface
  - the outer skull surface
  - the outer scalp surface

The recommended mesh size is approximately 600 to 800 points per surface.
Example with three surfaces: outer scalp (gray), outer skull (blue) and inner skull (pink).

.. image:: _static/tete_couches_brain.png
   :width: 300 px
   :alt: External surface of the cortex
.. image:: _static/tete_couches_brainskullhead.png
   :width: 300 px
   :alt: Example with three surfaces: outer scalp (gray),

.. note::

    Meshes paths can be absolute (as depicted on `fig.geom`_) or relative to where the command line is executed.
    For the meshes, the following formats are allowed:
    
        - \*.bnd~: bnd mesh format.
        - \*.off~: off mesh format.
        - \*.tri~: TRI format corresponding to early BrainVisa. Also handled by Anatomist.
        - \*.mesh~: MESH format corresponding to BrainVisa versions 3.0.2 and later. Also handled by Anatomist.
        - \*.vtk~: VTK mesh format.
        - \*.gii~: Gifti mesh format.
.. _sec.sources:

Source description
------------------

Sources are defined by their geometry (position and orientation) and their magnitude.
OpenMEEG handles two types of source models: isolated dipoles, or distributed dipoles: these two models differ in their geometry description.

Isolated dipoles
~~~~~~~~~~~~~~~~

Isolated dipoles are represented by a text file (extension \*.dip or \*.txt), in which each line defines a dipole position and orientation, encoded in 6 real values:

   - three values encoding the Cartesian coordinate for the position,
   - three values encoding the orientation of the dipole (supposed unitary).

The following example shows a file describing 5 isolated dipoles:


.. image:: _static/dipolePositions_en.png
   :width: 600 px
   :alt: Dipole positions
   :align: center

.. note:: The referential of the coordinates should be the same as for the meshes (the MR coordinates in general).

Distributed dipoles
~~~~~~~~~~~~~~~~~~~

Distributed dipoles are supported on a mesh, whose format must be \*.mesh, or \*.tri, or \*.vtk.

Source activation
~~~~~~~~~~~~~~~~~

Source activation files are text files, in which each line corresponds to a source, and each column to a time sample.

    - for isolated dipoles, the nth line corresponds to the amplitude of the nth dipole (with its fixed orientation)
    - for distributed dipoles, the nth line correspond to the amplitude of the nth vertex in the source mesh.

Example for isolated dipoles:

.. image:: _static/dipActiv.png
   :width: 600 px
   :alt: Dipole positions
   :align: center

For distributed sources, a source mesh describes their support. This is a detailed
mesh generally covering the whole cortex. The mesh size should not exceed 35 000 points.
The source amplitude is represented as continuous, and linear on each of the mesh triangles.
The source orientation is modeled as piecewise constant, normal to each of the mesh triangles.

.. image:: _static/cortex.png
   :width: 300 px
   :alt: Cortex
   :align: center

Isolated sources are the superposition of current dipoles, each of which is defined by its position and its moment.

.. _sec.sensors:

Sensors
-------

For EEG, the sensors are defined by the list of the x-y-z coordinates of the electrode
positions. The electrodes are considered punctual and are called *patches*.
The MEG sensor description is more complex:
The MEG sensor definition is provided in a text file, in which each line provides the position of the sensor, and additional information such as its orientation or its name.

Sensors may have names (labels) in the first column of the file (it has to contains at least one character to be considered as label).

More precisely, *omiting the first column which can contain a label* there are 4 options for defining EEG, EIT or MEG sensors:

    - 1 line per sensor and 3 columns (typically for EEG sensors or MEG sensors without orientation or EIT punctual patches) :
         - the 1st, 2nd and 3rd columns are respectively position coordinates x, y, z of sensor
    - 1 line per sensor and 4 columns (spatially extended EIT sensors (circular patches) :
         - the 1st, 2nd and 3rd columns are respectively position coordinates x, y, z of sensor
         - the 4th column is the patche radius (unit relative to the mesh)
    - 1 line per sensor and 6 columns (typically for MEG sensors) :
         - the 1st, 2nd and 3rd are respectively position coordinates x, y, z of sensor
         - the 4th, 5th and 6th are coordinates of vector orientation
    - 1 line per integration point for each sensor and 8 columns (typically for MEG realistic sensors with coils, or gradiometers) :
         - the 1st column is sensors names
         - the 2nd, 3rd and 4th are respectively position coordinates x, y, z of sensor
         - the 5th, 6th and 7th are coordinates of vector orientation
         - the 8th is the weight to apply for numerical integration (related to sensor name)

An example of MEG sensor description:

.. image:: _static/sensors-grad.png
   :width: 600 px
   :alt: Sensor description
   :align: center
