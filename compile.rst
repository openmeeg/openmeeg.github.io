.. _compile:

==================
Compiling OpenMEEG
==================

What you need to know
---------------------

    * OpenMEEG compiles with CMake on Mac OS X, Windows 32 & 64, and Linux
    * Test suite requires CTest provided with CMake
    * OpenMEEG supports parallel processing with OpenMP (option to be enabled in CMake configuration)
    * OpenMEEG is faster if you use the Intel MKL libraries
    * The `source code <https://github.com/openmeeg/openmeeg>`_ is hosted on github. Feel free so send us patches.

Compiling OpenMEEG on Linux or Mac OS
-------------------------------------

Step by step commands to be run in the terminal::

    git clone https://github.com/openmeeg/openmeeg.git # get the code
    cd openmeeg # go into the openmeeg directory
    mkdir build # create a build folder
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=ON ..  # configure build with CMake
    make # build the project
    make test # test the build

You can replace *cmake* by *ccmake* to configure visually your project.

On windows you need to use the CMake GUI.
