#!/usr/bin/env bash
# @(#) takes a ckan dataset name and generates a debian package from it
#
# all packages: http://ckan.net/api/1/search/package?tags=format-rdf&limit=1000

config="$1"

### start
if [ "$config" == "" ];
then
    echo "Usage: `basename $0` {config file}"
    exit 1;
fi

configDir=`dirname $config`
source $config
datasetDump="$configDir/$datasetDump"
datasetMeta="$configDir/$datasetMeta"

datasetPackage="rdf-dataset-$datasetId"

today=$(date +%Y%m%d)
echo $today

echo $datasetId
echo $datasetName
echo $datasetDescription
echo $datasetDump
echo $datasetCount
echo $datasetUri
echo $datasetPackage

echo "Create a new package directory: $datasetPackage"
rm -rf $datasetPackage
mkdir -p $datasetPackage

cp $datasetDump $datasetPackage/data.nt.gz
cp $datasetMeta $datasetPackage/meta.nt.gz

cd $datasetPackage

echo "Create package info and replace dataset specific values"
cp -R ../debian.stub debian
grep -rl "%%id%%" debian             | xargs sed -i "s|%%id%%|${datasetId}|g"
grep -rl "%%name%%" debian           | xargs sed -i "s|%%name%%|${datasetName}|g"
grep -rl "%%homepage%%" debian       | xargs sed -i "s|%%homepage%%|${datasetHomepage}|g"
grep -rl "%%downloadUrl%%" debian    | xargs sed -i "s|%%downloadUrl%%|${datasetDownloadUrl}|g"
grep -rl "%%date%%" debian           | xargs sed -i "s|%%date%%|${today}|g"
grep -rl "%%count%%" debian          | xargs sed -i "s|%%count%%|${datasetCount}|g"
grep -rl "%%uri%%" debian            | xargs sed -i "s|%%uri%%|${datasetUri}|g"
grep -rl "%%package%%" debian        | xargs sed -i "s|%%package%%|${datasetPackage}|g"
grep -rl "%%copyrightYear%%" debian  | xargs sed -i "s|%%copyrightYear%%|${datasetCopyrightYear}|g"
grep -rl "%%copyrightHolder%%" debian| xargs sed -i "s|%%copyrightHolder%%|${datasetCopyrightHolder}|g"
grep -rl "%%copyrightMail%%" debian  | xargs sed -i "s|%%copyrightMail%%|${datasetCopyrightMail}|g"
grep -rl "%%licenseUrl%%" debian     | xargs sed -i "s|%%licenseUrl%%|${datasetLicenseUrl}|g"
grep -rl "%%licenseName%%" debian    | xargs sed -i "s|%%licenseName%%|${datasetLicenseName}|g"

echo -n "Build the package: "
#debuild >../${package}.log || exit 1
echo "done"


