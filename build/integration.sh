#!/bin/bash -l

# this script is here to be used by Go and similar CI/CD products. It may at some point be replaced by a Rakefile.

rvm use 1.9.3@mkrogemann-poller --create --fuzzy

bundle update

[ -d "rspec-integration" ] || mkdir rspec-integration
bundle exec rspec --tag type:integration --out rspec-integration/rspec.xml --format html --out rspec-integration/index.html

echo `date +%s` > lastbuild.epoch
exit $?
