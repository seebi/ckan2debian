default:
	@echo "targets: clean, test"

clean:
	rm -rf rdf-dataset*

test-package-dir: clean
	./ckan2debian.sh test/aksworg-datahubio.cfg

test: test-package-dir
	cd rdf-dataset-aksworg-datahubio && debuild
