#!/usr/bin/env bash
# @(#) takes a ckan dataset name and generates a debian package from it
#
# all packages: http://ckan.net/api/1/search/package?tags=format-rdf&limit=1000

datasetName="$1"

### start
if [ "$datasetName" == "" ];
then
    echo "Usage: `basename $0` {ckan dataset name}"
    exit 1;
fi

curlcommand="curl -# -A ckan2debian.sh -L"
PREFIXES="PREFIX moat:<http://moat-project.org/ns#> PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#> PREFIX dct:<http://purl.org/dc/terms/> PREFIX dcat:<http://www.w3.org/ns/dcat#> "
today=$(date +%Y%m%d)
package="ckan-dataset-$datasetName"
dirname="$package-$today"
modeluri="http://ckan.net/package/$datasetName"

echo "Create a new package directory: $dirname"
rm -rf $dirname
mkdir -p $dirname
cd $dirname

echo "Fetch dataset turtle:"
$curlcommand -H "Accept: application/turtle" $modeluri >ckan.ttl || exit 1
dumpurl=$(roqet -q -i sparql -e "${PREFIXES}\
    SELECT ?url WHERE {\
        ?s  a dcat:Distribution.\
        ?s dcat:accessURL ?url.\
        ?s dct:format ?f. \
        ?f moat:taggedWithTag ?t.\
        { ?t moat:name \"application/rdf+xml\"}\
            UNION
        { ?t moat:name \"rdf+xml\"}\
    }" -D ckan.ttl -r csv | tail -1 | cut -d "(" -f 2 | cut -d ")" -f 1)
echo -n "Search for dump URL: "
echo $dumpurl

echo "Download the dump: "
$curlcommand ${dumpurl} -o data.rdf || exit 1

echo -n "Validate the dump: "
rapper data.rdf -o turtle -O - >data.ttl 2>data.log || exit 1
echo -n "valid "
count=$(cat data.log | tail -1 | cut -d " " -f 4) 
echo "(found $count triple)"
rm data.log data.rdf

echo "Create package info and replace dataset specific values"
cp -R ../debian.stub debian
grep -rl "%%package%%" debian  | xargs sed -i "s|%%package%%|${package}|g"
grep -rl "%%name%%" debian     | xargs sed -i "s|%%name%%|${datasetName}|g"
grep -rl "%%date%%" debian     | xargs sed -i "s|%%date%%|${today}|g"
grep -rl "%%count%%" debian    | xargs sed -i "s|%%count%%|${count}|g"
grep -rl "%%modeluri%%" debian | xargs sed -i "s|%%modeluri%%|${modeluri}|g"

echo -n "Build the package: "
debuild >../${package}.log || exit 1
echo "done"


