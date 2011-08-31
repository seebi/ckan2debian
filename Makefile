default:
	@echo "targets: clean, valid, valid-parallel"

clean:
	rm -rf ckan-dataset*

valid:
	cat ValidPackages.txt | xargs ./ckan2debian.sh

valid-parallel:
	cat ValidPackages.txt | parallel ./ckan2debian.sh {}

