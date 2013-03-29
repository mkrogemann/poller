Changelog
=========

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
