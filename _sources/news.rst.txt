.. _news:

.. role:: command

News
____

Version 2.6 (unreleased)
------------------------

- Many structural bugs with the Python wrappers were fixed. They should be
  more stable and usable now.
- Exceptions are now properly handled in OpenMP threads, which should improve
  stability.

Version 2.5
-----------

Important re-write
^^^^^^^^^^^^^^^^^^

OpenMEEG internal code went through an important internal cleanup.
Some code was factorized and reorganized. This should have no or low
external impact except if you use this internal interface (in C++ or
python). Overall numerical computations have not changed except that
some small increase in accuracy might be noticed (but in general, do
not expect much changes far from dipoles). Computation times should
not change either.

Python interface
^^^^^^^^^^^^^^^^

Python interface should be generally much more reliable and has been extended.
In particular, it is possible to directly provide meshes to OpenMEEG without
relying to files.

.. note::

    Coincidentally, to the internal API changes, some function calls must be changed.

        - :command:`om.HeadMat(geom, gauss_order)` => :command:`om.HeadMat(geom)`

        - :command:`om.DipSourceMat(geom, dipoles, gauss_order, use_adaptive_integration, "brain")` => :command:`om.DipSourceMat(geom, dipoles, "brain")`

        - :command:`om.SurfSourceMat(geom, mesh, gauss_order)` => :command:`om.SurfSourceMat(geom, mesh)`

    If you need to use non-standard integrator pass it as the last parameter (un-tested yet):

    .. code-block:: python

       gauss_order = 3
       integration_levels = 10
       tol = 0.001
       integrator = om.Integrator(gauss_order, integration_levels, tol)

New block API
^^^^^^^^^^^^^

With the re-write of the internal code, a new block-matrix API has been added. This is useful
for advanced leadfield computation (e.g. for varying conductivities leadfields without redoing
all computations). It will be soon exploited to add some new capabilities to OpenMEEG.

App improvments
^^^^^^^^^^^^^^^
- Add "-d" option to om_check_geom to check if dipoles are within
  the inner interface.

Version 2.4
-----------

Enhancements
^^^^^^^^^^^^
- handles non-nested geometries: domains can have several neighbors as long as their
  conductivity is constant and isotropic.
- handles zero-conductivity domains (modeling ventricles or silicone material)
- CGAL meshing tools (allowing to remesh or decimate existing meshes,
  or to mesh a levelset)
- can use linear algebra packages MKL and OpenBLAS, on all platforms (linux, MacOS and Windows) 
- support for VTK mesh formats

Version 2.1
^^^^^^^^^^^

Enhancements
^^^^^^^^^^^^
- added the adjoint way for computing a leadfield for either EEG, MEG or
  MEEG simultaneously. This save a lot of time and memory for big systems (>1000 pts/surfaces).
- better ordering in computations when inverting the matrix for the memory footprint.
- storage now more effective using the matio library even for symmetric matrices.
- support for matlab7.3 file format.
- reducing memory footprint of DSM, Head2MEG, SurfSource2MEG and DipSource2MEG computations
- improved MKL detection
- lapack inclusion (experimental) to ease the build on architectures where
  there is no alternative.

Bug fixes
^^^^^^^^^
- allowance of spaces in mesh file names with a new .geom format (old
  format is still accepted).
- bug when loading sensor file with no empty line at the end
- fix leak in Mesh class

Removed features
^^^^^^^^^^^^^^^^
- TV inverse solver

Version 1.1
^^^^^^^^^^^

Enhancements
^^^^^^^^^^^^
- added target for uninstalling (make uninstall).
- possibility of evaluating the potential at any point within inner volume.
- for Functional Electric Stimulation: added a new criterion to optimize: current activation.
- support for MKL-10.0 on MacOS.
- added the possibility of statically linked libraries for easier distribution (unix only).
- more information on mesh qualify in om_mesh_info.
- more tests (mostly for EIT tests).
- do not use optimized operator D when using OpenMP.
- automatic finding of fortan libraries (for unix), better blas/lapack/atlas detection.
- build system updated for cmake 2.6

Bug fixes
^^^^^^^^^
- corrected a misprint help message and adding a message if not enough arguments are given.
- corrected the magnitude of MEG leadfields, update the tests accordingly.
- added some missing guards against multiple .H inclusion.
- correctly initialized matrices before filling them.
- corrected handling of single layer models.
- corrected the order of atlas libraries in link.

Maintenance
^^^^^^^^^^^
- non-templated versions of the operatorsN,D,S ; the order of the parameters have been slightly changed .
- use namespaces everywhere, prefix include guard variables by OPENMEEG_.
- removed unnecessary info in file headers.
- matlab io files.
