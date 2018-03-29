Openmeeg website
================

This repository contains the source code of the [openmeeg website](<http://openmeeg.github.io/>)
which contains all the documentation to get started in using
[openmeeg](<https://github.com/openmeeg/openmeeg>).

The documentation is written in [reStructuredText](http://docutils.sourceforge.net/rst.html)
and build using [**Sphinx**](http://www.sphinx-doc.org/) to render as a website.

### Requirerments 

In order to build our documentation, the following packages need to be available:
- sphinx
- pdflatex
- texlive-anyfontsize
- make

Refer to **Sphinx** doc in [how to install it](http://www.sphinx-doc.org/en/stable/install.html),
 but in short you can install it from [**pip**](https://pypi.python.org/pypi/pip) 
(but you can also get from most package managers or conda).

```sh
$ pip install sphinx
```

Use your favorite package manager to install the **latex**. For Debian based
systems (such as Ubuntu) do:

```sh
$ sudo apt-get install texlive-full
```

Most of the systems already come with `make` build utils, but if yours doesn't
here's you get them in Ubuntu:

```sh
$ sudo apt-get install build-essential
```


### How to build the [openmeeg](<https://github.com/openmeeg/openmeeg>) documentation

In order to build the webiste just in build the `html` target from the root of
the project as follows:

```sh
$ git clone -b source https://github.com/openmeeg/openmeeg.github.io
$ cd openmeeg.github.io
$ make html
```

This should generate a folder called `./build/html/` containing the `index.html`.
Open this file with any browser to see your local version of openmeeg website.

### How to contribute

To contribute to **openmeeg.github.io**, first create an account on [github](http://github.com/).
Once this is done, fork the [openmeeg.github.io repository](http://github.com/openmeeg/openmeeg.github.io)
to have your own repository, clone it using `git clone` on the computers where
you want to work. Make your changes in your fork, push them to your github
account, test them on several computers, and when you are happy with them, send
a pull request to the main repository.

All contributions are wellcome. If you want to contribute to [openmeeg](<https://github.com/openmeeg/openmeeg>)
don't hesitate we are a friendly community come swing by. 
