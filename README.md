# ckan2debian
This script creates a debian package of the form

    ckan-dataset-$name_$date_all.deb

for a [CKAN dataset](http://thedatahub.org) which comply with the following requirements:

* The dataset is RDF based and has a download-able RDF dump
* The dump is request-able and can be transformed to turtle (with rapper)

Currently, the resulting packages depend on `virtuoso-opensource-6.1`.
After the package installation, the RDF dataset will uploaded as a new graph in virtuoso.
The graph and the source turtle files will be removed on package de-installation.

## stack.lod2.eu
This script was created for the [LOD2 stack debian repository](http://stack.lod2.eu)
and you might find some ckan dataset packages there.

## dependencies
The package generation script depends on the following commands:

* wget, for downloading (`apt-get install wget`)
* rapper, for validating and turtle generation (`apt-get install raptor-utils`)
* roqet, for SPARQL queries (`apt-get install rasqal-utils`)
* php5, for parsing the ckan JSON output (`apt-get install php5-cli`)

## problematic issues

* virtuoso package dependency could be avoided
* the dba user is used for uploading to virtuoso
* my name and mail is hardcoded (debian.stub/changelog, debian.stub/control)
* there is no changelog written, just one package without a history
* package description should be enhanced
* package license should be used from the dataset
* there are not so much dataset which comply with the requirements

## example run
This is an example run of the script which creates a debian package of the CKAN
dataset "Italian Museums" from LinkedOpenData.it

    > ./ckan2debian.sh museums-in-italy
    Create a new package directory: ckan-dataset-museums-in-italy-20110831
    Fetch dataset JSON and search for id: 63cf86ac-1296-487e-8782-79d75319de3e
    Fetch dataset RDF and search for dump URL: http://dump.linkedopendata.it/musei
    Try to download the dump: Done
    Validate the dump: valid (found 49905 triple)
    Replace package specific values
    Build the package:

    You need a passphrase to unlock the secret key for
    user: "Sebastian Tramp"
    1984-bit RSA key, ID 9D601B44, created 2003-11-03

    You need a passphrase to unlock the secret key for
    user: "Sebastian Tramp"
    1984-bit RSA key, ID 9D601B44, created 2003-11-03

    done

    > ls -1d ckan-dataset*
    ckan-dataset-museums-in-italy-20110831
    ckan-dataset-museums-in-italy_20110831_all.deb
    ckan-dataset-museums-in-italy_20110831.dsc
    ckan-dataset-museums-in-italy_20110831_i386.build
    ckan-dataset-museums-in-italy_20110831_i386.changes
    ckan-dataset-museums-in-italy_20110831.tar.gz
