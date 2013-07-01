default:
	@echo "targets: clean, test"

clean:
	rm -rf rdf-dataset*

test-package-dir:
	./ckan2debian.sh test/aksworg.cfg

test: test-package-dir
	cd rdf-dataset-aksworg && debuild
