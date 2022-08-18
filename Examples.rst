Examples
--------

Assuming a head model represented by the geometry file :input:`head.geom` and the conductivity file :input:`head.cond` and EEG sensors detailed in a file :input:`head.eegsensors`.

Computing the EEG gain matrix for sources distributed on a surface mesh represented by the file :input:`sources.tri` is done via the following set of commands::

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
