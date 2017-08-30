.. role:: command
.. role:: opt
.. role:: input
.. role:: output

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
