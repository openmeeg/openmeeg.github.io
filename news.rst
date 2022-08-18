.. _news:

.. role:: command

News
____

New with version 2.5 (upcoming).
--------------------------------

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