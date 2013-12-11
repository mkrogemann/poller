#!/bin/bash -l

# this script is here to be used by Go and similar CI/CD products. It may at some point be replaced by a Rakefile.

rvm use 1.9.3@mkrogemann-poller --create --fuzzy
bundle update
[ -d rspec ] && rm -rf rspec
COVERAGE=true bundle exec rspec --tag ~type:integration --out rspec/rspec.xml --format html --out rspec/rspec.html

exit $?
