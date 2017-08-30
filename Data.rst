Data format
===========

OpenMEEG handles several file formats corresponding to different types of objects: vectors, matrices, head geometries, conductivities, meshes, dipoles, sensors.

Vectors and matrices
--------------------

By default, matrices and vectors are stored on disk using a ``MATLAB`` file format.
Symmetric matrices which are not directly representable in the ``MATLAB`` format are represented as a ``MATLAB`` struct.
Other vector/matrices file formats are also supported.
Forcing a specific file format is achieved by specifying the proper file extension.
``MATLAB`` extension is ``.mat``. 
Other useful file formats are ASCII (extension ``.txt``) which generates human readable files, and BrainVisa texture file format (extension ``.tex``).

OpenMEEG's own binary file format (extension ``.bin``) is available solely for backward compatibility and should be considered as deprecated (as it is subsumed by the ``MATLAB`` file format).

.. _sec.geom:

Geometrical model, mesh and conductivity files
-----------------------------------------------

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

    A Mesh is defined with the keyword ``Mesh`` followed by an optional name and "``:``".

    If no name is provided, the Mesh is named by its index (starting from 1).

    If none of the two sections ``MeshFile`` and ``Meshes`` are present, the next section called ``Interfaces`` is expected to contain the filenames of the meshes.

- ``Interfaces`` section specifies the mesh descriptions of the interfaces between tissues.
    It is introduced by the keyword ``Interfaces`` followed by the number of such interfaces. 

    An Interface is defined with the keyword ``Interface`` followed by a name and "``:``".

    If no name is provided, the Interface is named by its index (starting from 1).

    If the sections ``MeshFile`` and ``Meshes`` were NOT specified before, a path to a mesh file is expected.

    In the opposite case, a sequence of mesh names is expected.

    These meshes are concatenated to form a closed Interface.

    '+' or '-' sign preceeding a mesh name reorients the meshes in order to form a consistently oriented interface.

- ``Domains`` section describes the head tissues and is introduced by the keyword ``Domains`` followed by the number of such domains. 
  
  Each domain is then described, one domain per line, by the keyword ``Domain`` followed by the domain name (which serves for identification and also appears in the conductivity description) followed by a list of IDs (names or integers).
  
  These IDs are the interface names (as depicted in previous paragraph).

  They must be preceeded by a '+' or '-' sign to indicate whether the domain is outside or inside the corresponding interface (as defined by the outward normal of the interface).

See `fig.geom`_ for a detailed example.


**Meshes** see also `sec.meshes`_ in Appendix.
Generally ending with the ``.tri`` extension follow the BrainVisa file format for meshes, these files contain two sections.
Each section is introduced by the character ``-`` appearing at the beginning of the line followed by a space followed by either one number (first section) or three times
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

Interfaces are required to be closed in order for the Boundary Element Method to function correctly. This is also necessary for the source meshes when computing forward solutions using surfacic source models (see below).
Moreover, the interface meshes must not intersect each other. Non-intersection can be checked with the command :command:`om_check_geom`.
The command :command:`om_mesh_info` applied to a mesh provides its number of points, of triangles, minimum and maximum triangle area, and also its Euler characteristic.
The Euler characteristic of a closed mesh of genus 0 (homotopic to a sphere) is equal to 2.
The Euler characteristic gives an indication if a mesh is likely to be closed or not.

In order to generate a VTK/vtp file, one can use the tool provided :command:`om_meshes_to_vtp`, which from a list of (closed or not) meshes and names, remove dupplicated vertices and create an easily viewable file in VTK/Paraview.

In order to check a geometry file, one can use the tool provided :command:`om_check_geom`, which display the read informations.

A **conductivity file** (generally ending with the extension ``.cond``) is a simple ASCII file that contains associations between tissue names and conductivity values.
Associations are provided one per line. Empty lines or lines beginning with ``#`` are non-significant. The file must start with a special comment line which allows its identification.
The next figure provides an example conductivity file corresponding to the geometry file presented above.

.. image:: _static/cond.png
   :width: 600 px
   :alt: Conductivities
   :align: center

Note that the tissue names are the ones appearing in the Domains descriptions of the file depicting the geometrical model.

Source descriptions
--------------------

Sources may be represented either by a *surfacic distribution* of dipoles, or by *isolated dipoles* (dirac).

A **surfacic distribution** can be defined by a mesh that supports the dipoles. 
The dipole orientations are then constrained to the normal direction to the mesh and the moment amplitude is modelled as continuous across the mesh (piecewise linear).
Source values are defined at the mesh vertices.

**Isolated dipoles** are defined by a simple ASCII file as shown below:

.. image:: _static/dipolePositions_en.png
   :width: 600 px
   :alt: dipole positions
   :align: center
