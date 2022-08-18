Data format
-----------

OpenMEEG handles several file formats corresponding to different types of objects: vectors, matrices, head geometries, conductivities, meshes, dipoles, sensors.

Vectors and matrices
^^^^^^^^^^^^^^^^^^^^^^^^

By default, matrices and vectors are stored on disk using a ``MATLAB`` file format.
Symmetric matrices which are not directly representable in the ``MATLAB`` format are represented as a ``MATLAB`` struct.
Other vector/matrices file formats are also supported.
Forcing a specific file format is achieved by specifying the proper file extension.
``MATLAB`` extension is ``.mat``.
Other useful file formats are ASCII (extension ``.txt``) which generates human readable files, and BrainVisa texture file format (extension ``.tex``).

OpenMEEG's own binary file format (extension ``.bin``) is available solely for backward compatibility and should be considered as deprecated (as it is subsumed by the ``MATLAB`` file format).

.. _sec.geom:

Geometrical model, mesh and conductivity files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**OpenMEEG geometrical models** are described through several files.
The toplevel file (generally ending with the extension ``.geom``) assembles various interface descriptions to build *Domains* corresponding to head tissues.
Empty lines or lines beginning with ``#`` are non-significant.

The file must start with a special comment line which allows its identification (see example in `fig.geom`_).
Geometrical models globally contain 2 sections, one for describing the interfaces and one for describing the domains.
In OpenMEEG, we make the following distinction between Mesh and Interface, which is helpful for defining non nested geometries.

    - "Mesh": a collection of vertices and triangles all connected.
    - "Interface": a closed mesh.

Sample *non-nested* geometry description:

.. image:: _static/geom1.png
   :width: 600 px
   :alt: Geometry .geom
.. _fig.geom:

Sample *nested* geometry descriptions:

.. image:: _static/geom2.png
   :width: 600 px
   :alt: Geometry .geom

.. image:: _static/geom3.png
   :width: 600 px
   :alt: Geometry .geom


The section starting with the keyword ``MeshFile`` is optional, as well as the section ``Meshes``.

- If ``MeshFile`` is found, it specifies the path to the VTK/vtp file containing the vertices and annoted triangles of your geometry. (Triangle annotations are labels that specify the mesh names).

- If ``Meshes`` is found, it specifies the paths to the meshes that may or may not be named. Mesh file formats supported are ``tri``, ``bnd``, ``mesh``, ``off``, ``gii``, and ``vtk`` (in case you use VTK).

    * A Mesh is defined with the keyword ``Mesh`` followed by an optional name and "``:``".

    * If no name is provided, the Mesh is named by its index (starting from 1).

    * If none of the two sections ``MeshFile`` and ``Meshes`` are present, the next section called ``Interfaces`` is expected to contain the filenames of the meshes.

- ``Interfaces`` section specifies the mesh descriptions of the interfaces between tissues.

    * It is introduced by the keyword ``Interfaces`` followed by the number of such interfaces.

    * An Interface is defined with the keyword ``Interface`` followed by a name and "``:``".

    * If no name is provided, the Interface is named by its index (starting from 1).

    * If the sections ``MeshFile`` and ``Meshes`` were NOT specified before, a path to a mesh file is expected.

    * In the opposite case, a sequence of mesh names is expected.

    * These meshes are concatenated to form a closed Interface.

    * '+' or '-' sign preceeding a mesh name reorients the meshes in order to form a consistently oriented interface.

- ``Domains`` section describes the head tissues and is introduced by the keyword ``Domains`` followed by the number of such domains.

    * Each domain is then described, one domain per line, by the keyword ``Domain`` followed by the domain name (which serves for identification and also appears in the conductivity description) followed by a list of IDs (names or integers).

    * These IDs are the interface names (as depicted in previous paragraph).

    * They must be preceeded by a '+' or '-' sign to indicate whether the domain is outside or inside the corresponding interface (as defined by the outward normal of the interface).

See `fig.geom`_ for a detailed example.


.. _sec.meshes:

Meshes
""""""

Meshes are a central element of Boundary Element Methods. They are used to represent the interfaces between regions of homogeneous conductivity. For instance, in a simple three-layer head model, three meshes would be used to represent:

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


Files ending with the ``.tri`` extension follow the BrainVisa file format for meshes. Such files contain two sections,
each section introduced by the character ``-``  at the beginning of the line followed by a space followed by either one number (first section) or three times
the same number (second section).

- ``The first section`` contains a list of vertices with associated normals.
  The number on the line introducing the section is the number of points.
  Each following line corresponds to a single point. Its coordinates are the three first numbers appearing on the line.
  The normal corresponds to the following three numbers. Each point is assigned an index (starting at 0) corresponding to its order of appearance in the list.

- ``The second section`` contains the triangles of the mesh.
  The number (repeated three times) in the section delimiter corresponds to the number of triangles.
  Each triangle is depicted by a sequence of three integers corresponding to the indices of the points assigned as described in the previous paragraph.

The following small example describes a very simple mesh containing 4 points and 4 triangles::

    - 4
    0 0 0 -0.5773 -0.5773 -0.5773
    1 0 0 1 0 0
    0 1 0 0 1 0
    0 0 1 0 0 1
    - 4 4 4
    0 1 2
    0 1 3
    0 2 3
    1 2 3

.. _sec.cond:

Geometry tools
""""""""""""""

Interfaces are required to be closed in order for the Boundary Element Method to function correctly. This is also necessary for the source meshes when computing forward solutions using surfacic source models (see below).
Moreover, the interface meshes must not intersect each other. Non-intersection can be checked with the command :command:`om_check_geom`.
The command :command:`om_mesh_info` applied to a mesh provides its number of points, of triangles, minimum and maximum triangle area, and also its Euler characteristic.
The Euler characteristic of a closed mesh of genus 0 (homotopic to a sphere) is equal to 2.
The Euler characteristic gives an indication if a mesh is likely to be closed or not.

In order to generate a VTK/vtp file, one can use the tool provided :command:`om_meshes_to_vtp`, which from a list of (closed or not) meshes and names, removes duplicated vertices and creates an easily viewable file in VTK/Paraview.

In order to check a geometry file, one can use the tool provided :command:`om_check_geom`, which display the read informations.

A **conductivity file** (generally ending with the extension ``.cond``) is a simple ASCII file that contains associations between tissue names and conductivity values.
Associations are provided one per line. Empty lines or lines beginning with ``#`` are non-significant. The file must start with a special comment line which allows its identification.
The next figure provides an example conductivity file corresponding to the geometry file presented above.

.. image:: _static/cond.png
   :width: 600 px
   :alt: Conductivities
   :align: center

Note that the tissue names are the ones appearing in the Domains descriptions of the Geometry description file (case sensitive).

.. _sec.sources:

Source descriptions
^^^^^^^^^^^^^^^^^^^

Sources are defined by their geometry (position and orientation) and their magnitude.
OpenMEEG handles two types of source models: isolated dipoles, or distributed dipoles: these two models differ in their geometry description.

Isolated dipoles
""""""""""""""""

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
"""""""""""""""""""

Distributed dipoles are supported on a mesh, whose format must be \*.mesh, or \*.tri, or \*.vtk.

Source activation
"""""""""""""""""

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
^^^^^^^

For EEG, the sensors are defined by the list of the x-y-z coordinates of the electrode
positions. The electrodes are considered punctual and are called *patches*.
The MEG sensor description is more complex:
The MEG sensor definition is provided in a text file, in which each line provides the position of the sensor, and additional information such as its orientation or its name.

Sensors may have names (labels) in the first column of the file.

More precisely, *omiting the first column which can contain a label* there are 4 options for defining EEG, EIT, ECoG or MEG sensors:

    - 1 line per sensor and 3 columns (typically for EEG/ECoG sensors or EIT punctual patches):

         * the 1st, 2nd and 3rd columns are respectively position coordinates x, y, z of sensor

    - 1 line per sensor and 4 columns (spatially extended EIT sensors (circular patches)):

         * the 1st, 2nd and 3rd columns are respectively position coordinates x, y, z of sensor
         * the 4th column is the patche radius (unit relative to the mesh)

    - 1 line per sensor and 6 columns (typically for MEG sensors) :

         * the 1st, 2nd and 3rd are respectively position coordinates x, y, z of sensor
         * the 4th, 5th and 6th are coordinates of vector orientation

    - 1 line per integration point for each sensor and 8 columns (typically for MEG realistic sensors with coils, or gradiometers):

         * the 1st column is sensors names
         * the 2nd, 3rd and 4th are respectively position coordinates x, y, z of sensor
         * the 5th, 6th and 7th are coordinates of vector orientation
         * the 8th is the weight to apply for numerical integration (related to sensor name)

An example of MEG sensor description:

.. image:: _static/sensors-grad.png
   :width: 600 px
   :alt: Sensor description
   :align: center
