Changelog
=========

Version 0.5.2 - released 2013-12-26
-------------

* Drop support for Rubinius, remove rbx from .travis.yml
* Add support for MRI 2.1.0

Version 0.5.1 - released 2013-12-07
-------------

* Adjust to make it work with recent versions of Rubinius.
* Update dev dependencies

Version 0.5.0 - released 2013-08-26
-------------

* API change: Poller now returns a tuple containing the http response and the elapsed time. Clients can still ignore the result and rely on the fact that a failing poller.check will raise an error once the timeout occurs, so no immediate changes are required.

Version 0.4.2 - released 2013-08-18
-------------

* Adjust tests to new iana.org site layout and clean up test wording/formatting
* And switching back to example.com as example.iana.org no longer resolves
* Use github code highlighting feature in README

Version 0.4.1 - released 2013-03-30
-------------

* Bugfix: XPathContainsText matcher did not check if XPath expression returns nil

Version 0.4.0 - released 2013-03-29
-------------

* Refactoring: Change/simplify sequence of calls inside Poller.check method
* Reduce sleep time per sample by the time that the previous sampling consumed
* Make error message on timeout more informative (add total time and number of tries)
* Add integration tests

Version 0.3.2 - released 2013-03-16
-------------

* Bugfix: Make sure to pass a String to matchers in HttpProbe

Version 0.3.1 - released 2013-03-15 -> yanked!
-------------

* Refactoring: Change expected input of matchers to be a String rather than http response
* Improve tests (wording, remove redundant REXML requires)
* Add Coveralls service and badge

Version 0.3.0 - released 2013-03-12
-------------

* Add two XPath related matchers:
 * DocumentContainsXPath checks for occurence of XPaths (and optionally) the number of occurrences
 * XPathContainsText checks for presence of given search text (or Regex) under given XPath

Version 0.2.0 - released 2013-02-20
-------------

* Add capability to use SSL (certificates are not verfied making it possible to use invalid certificates)
* Add basic authentication (userinfo must be given in URL)


Version 0.1.1 - released 2013-02-19
-------------

First public release
