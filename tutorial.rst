.. _tutorial:

======================
Tutorial
======================

.. contents:: Table of Contents
   :local:
   :depth: 2


.. role:: command
.. role:: opt
.. role:: input
.. role:: output

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


OpenMEEG from the command line
===============================

Diagram for the low level pipeline for computing MEG and EEG leadfields (a.k.a., gain matrices) using OpenMEEG:

.. image:: _static/OpenMEEGSimple.png
   :width: 600 px
   :alt: dipole positions
   :align: center

This section reviews the main OpenMEEG command line tools. 
The general syntax and main options of each command is briefly provided.

Full details are available in OpenMEEG documentation. 
In this section, :command:`command` names are in :command:`red`, :opt:`options` are in :opt:`green` and :output:`output` files are shown in :output:`blue`.

om_assemble
-----------

General syntax:

:command:`om_assemble` :opt:`Option` :input:`Parameters` :output:`Matrix`

This program assembles the different matrices to be used in later stages.
It uses the head description (the geometrical model and the conductivities of the head see `sec.geom`_, and `sec.cond`_), the sources (see `sec.sources`_) and the sensors (see `sec.sensors`_) information.
:opt:`Option` selects the type of matrice to assemble.
:input:`Parameters` depends on the specific option :opt:`Option`.

A typical command is:

:command:`om_assemble` :opt:`-HeadMat` :input:`subject.geom` :input:`subject.cond` :output:`HeadMat.mat`

.. note:: the abbreviated option names :opt:`-HM` or :opt:`-hm` can be used instead of :opt:`-HeadMat`.
.. note:: The symmetric format only stores the lower half of a matrix.

We now detail the possible :opt:`Options` (with their abbreviated versions given in parentheses), allowing to define various matrices to assemble:

General options for :command:`om_assemble`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  - :opt:`-help` (:opt:`-h`,``--help``): summarizes all possible options.

    Head modelling options for :command:`om_assemble`: produce matrices linked to the propagation of electrical signals in the head.

  - :opt:`-HeadMat` (:opt:`-HM`, :opt:`-hm`): :command:`om_assemble` computes the Head matrix for Symmetric BEM (left-hand side of the linear system). 
    This matrix corresponds to the propagation of electrical signals within the head. 

**Source modelling** options for :command:`om_assemble`: compute the source matrix for Symmetric BEM (right-hand side of the linear system). 
This matrix maps the representation of the sources to their associated electric potential in an infinite medium (:math:`v_{\Omega_1}`). 
Different options exist for the 2 types of source models:

   - :opt:`-SurfSourceMat` (:opt:`-SSM`, :opt:`-ssm`): should be used for continuous surfacic distributions of dipoles.
                :input:`Input` is a file containing a mesh that describes the surface.  
                For faster computations, one can consider giving the name of the domain (containing all dipoles) as a string as an optional parameter in the end of the command line.
   - :opt:`-DipSourceMat` (:opt:`-DSM`, :opt:`-dsm`): should be used when considering several isolated dipoles.
     This model is the most commonly used and should be used by default even if the dipoles correspond to the vertices of a cortical mesh. 
     :input:`Input` is a file containing the dipole descriptions.
     For faster computations, one can consider giving the name of the domain (containing all dipoles) as a string as an optional parameter in the end of the command line (see Example).

**Sensor modelling** options for :command:`om_assemble`: compute matrices that integrate source information and computed potentials to provide the actual solution of the forward problem. 
The situation is slightly different for EEG, which only needs to compute the electric potential, and for MEG, which depends both on the electric potential and on the sources:

  - :opt:`-Head2EEGMat` (:opt:`-H2EM`, :opt:`-h2em`): :command:`om_assemble` computes the linear interpolation matrix that maps OpenMEEG unknown :math:`\mathbf{X}` to the potential on the scalp at EEG sensors: :math:`\mathbf{V_{sensors}} = \mathbf{Head2EEGMat} . \mathbf{X}`. :input:`Input` is a file describing the EEG sensor positions. :math:`\mathbf{Head2EEGMat}` is stored as a sparse matrix.
  - :opt:`-Head2MEGMat` (:opt:`-H2MM`, :opt:`-h2mm`): :command:`om_assemble` computes the contribution of Ohmic currents to the MEG sensors. :input:`Input` is a file describing the SQUIDS geometries and characteristics.
  - :opt:`-Head2InternalPotMat` (:opt:`-H2IPM`, :opt:`-h2ipm`): :command:`om_assemble` computes the matrix that allows
    the computation of potentials at internal positions from potentials and normal currents on head interfaces, as computed by the symmetric BEM.
  - :opt:`-SurfSource2MEGMat` (:opt:`-SS2MM`, :opt:`-ss2mm`): :command:`om_assemble` computes the source contribution to the MEG sensors using the same source model as the one used for the option :opt:`-SurfSourceMat, i.e. surfacic distribution of dipoles. For this option, :input:`Input` takes the form:
     - :input:`mesh squids` where :input:`mesh` contains a mesh describing the source surface
       and :input:`squids` is a file  describing the SQUIDS geometries and characteristics.
     - :opt:`-DipSource2MEGMat` (:opt:`-DS2MM`, :opt:`-ds2mm`): :command:`om_assemble` computes
       the source contribution to the  MEG sensors using the same source model as the one used for the option :opt:`-DipSourceMat`, i.e. isolated dipoles. 

For this option, :input:`Input` takes the form:

   - :input:`dipoles squids` where :input:`dipoles` contains the dipole description and :input:`squids` is a file describing  the SQUIDS geometries and characteristics.
   - :opt:`-DipSource2InternalPotMat` (:opt:`-DS2IPM`, :opt:`-ds2ipm`): :command:`om_assemble` computes the source  contribution to the chosen internal points. It gives the potential due to isolated dipoles, as if the medium were  infinite. For this option, :input:`Input` takes the form:
   - :input:`dipoles internalPoints` where :input:`dipoles` contains the dipole description and :input:`internalPoints` is  a file describing the points locations.

EIT options for :command:`om_assemble`:

   - :opt:`-EITSourceMat` (:opt:`-EITSM`, :opt:`-EITsm`,): :command:`om_assemble` computes the right-hand side for scalp current injection. This usage of :command:`om_assemble` outputs the right-hand side vector for a given set of EIT electrode. For this option, :input:`Input` is a file describing the EIT electrode positions.

om_minverser
------------

General syntax:

:command:`om_minverser` :input:`HeadMat` :output:`HeadMatInv`

This program is used to invert the symmetric matrix as provided by the command :command:`om_assemble` with the option :opt:`-HeadMat`.

This command has only one option.
    - :opt:`-help` (:opt:`-h`, ``--help``): summarizes the usage of :command:`om_minverser`.


om_gain
-------

General syntax:

:command:`om_gain` :opt:`Option` :input:`HeadMatInv` :opt:`Parameters` SourceMat Head2EEGMat :output:`GainMatrix`

This command computes the gain matrix by multiplying together matrices obtained previously (e.g. :input:`HeadMatInv` is the matrix computed using :command:`om_minverser`).
The resulting gain matrix is stored in the file :output:`GainMatrix`.
:opt:`Option` selects the type of matrice to build. :opt:`Parameters` depend on the specific option :opt:`Option`.

General options:


   - :opt:`-help` (:opt:`-h`, ``--help``): summarizes the usage of :command:`om_gain` for all its possible options.

Gain matrix type options: select the type of gain matrix to be computed by  :command:`om_gain`.

   - :opt:`-EEG`: allows to compute an EEG gain matrix. :opt:`Parameters` are then:
       - :input:`HeadMatInv SourceMat Head2EEGMat`
       - :input:`SourceMat` is the matrix obtained using :command:`om_assemble` with either of the options
         :opt:`-SurfSourceMat` or :opt:`-DipSourceMat`, depending on the source model. :input:`Head2EEGMat`
         is the matrix obtained using :command:`om_assemble` with the option :opt:`-Head2EEGMat`.
   - :opt:`-EEG` option is also used to compute an EIT gain matrix: in this case, :input:`SourceMat`
      should contain the output of the :opt:`-EITsource` option of :command:`om_assemble`. Multiplying
      the EIT gain matrix by the vector of applied currents at each EIT electrode yields the simulated
      potential on the EEG electrodes. The applied current on the EIT electrodes should sum to zero.
   - :opt:`-MEG`: allows to compute a MEG gain matrix. :opt:`Parameters` are then:
       - :input:`HeadMatInv SourceMat Head2MEGMat Source2MEGMat`
       - :input:`SourceMat` is the matrix obtained using :command:`om_assemble` with either of the options
         :opt:`-SurfSourceMat` or :opt:`-DipSourceMat`, depending on the source model. :input:`Head2MEGMat`
         is the matrix obtained using :command:`om_assemble` with the option :opt:`-HeadMEEGMat`.
         :input:`Source2MEGMat` is the matrix obtained using :command:`om_assemble` with either of the
         options :opt:`-SurfSource2MEGMat` or :opt:`-DipSource2MEGMat`, depending on the source model.
        .. note:: 
            The magnetic field is related both to the sources directly, as well as to the electric potential, according to: :math:`\mathbf{M_{sensor}} = \mathbf{Source2MEGMat} . \mathbf{S} + \mathbf{Head2MEGMat}.\mathbf{X}`.
   - :opt:`-InternalPotential`: allows to compute an internal potential gain matrix for sensors within the volume. :opt:`Parameters` are then:
       - :input:`HeadMatInv SourceMat Head2InternalPotMat Source2InternalPotMat`
       - :input:`Head2InternalPotMat` and :input:`Source2InternalPotMat` are respectivelly obtained
         using :command:`om_assemble` with option :opt:`-Head2InternalPotMat` and :opt:`-DipSource2InternalPotMat`.

Examples
========

Assuming a head model represented by the geometry file :input:`head.geom` and the conductivity file :input:`head.cond` and EEG sensors detailed in a file :input:`head.eegsensors`.

Computing the EEG gain matrix for sources distributed on the surface represented
by the file :input:`sources.tri` is done via the following set of commands::

    om_assemble -HM head.geom head.cond head.hm
    om_assemble -SSM head.geom head.cond sources.tri head.ssm
    om_assemble -h2em head.geom head.cond head.eegsensors head.h2em
    om_minverser head.hm head.hm_inv
    om_gain -EEG head.hm_inv head.ssm head.h2em head.gain

Considering now isolated dipolar sources detailed in the file :input:`sources.dip` with MEG sensors depicted in the file :input:`head.squids`. Using the same head model, the MEG gain matrix is obtained via the following set of commands::

    om_assemble -HeadMat head.geom head.cond head.hm
    om_assemble -DSM head.geom head.cond sources.dip head.dsm Brain
    om_assemble -h2mm head.geom head.cond head.squids head.h2mm
    om_assemble -ds2mm sources.dip head.squids head.ds2mm
    om_minverser head.hm head.hm_inv
    om_gain -MEG head.hm_inv head.dsm head.h2mm head.ds2mm head.gain

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
