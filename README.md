# ckan2debian
This script creates a debian package of the form

    rdf-dataset-$name_$date_all.deb

for a [CKAN dataset](http://thedatahub.org) which comply with the following requirements:

* The dataset is RDF based and has a download-able dump
* The dump is request-able and can be transformed to ntriple

After the package installation, the dataset will uploaded as a new graph in virtuoso.
The graph and the source turtle files will be removed on package de-installation.

## stack.lod2.eu
This script was created for the [LOD2 stack debian repository](http://stack.lod2.eu)
and you might find some CKAN dataset packages there.

## Example

Try to do a `make test` which will run `ckan2debian.sh` with the config under
`test`.
