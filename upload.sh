#!/usr/bin/env bash

svn ci -m ""
ssh maldives.inria.fr "svn up /net/servers/www-sop/teams/athena/software/OpenMEEG"
