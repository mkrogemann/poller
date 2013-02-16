poller
======

[![Build Status](https://travis-ci.org/mkrogemann/poller.png)](https://travis-ci.org/mkrogemann/poller)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mkrogemann/poller)
[![Dependency Status](https://gemnasium.com/mkrogemann/poller.png)](https://gemnasium.com/mkrogemann/poller)

poller is a Ruby gem that supports testing asynchronous calls to systems under test by exposing Poller implementations.


This is in large parts inspired by the work of Steeve Freeman &amp; Nat Pryce and theor excellent GOOS book.

It does not completely follow the patterns described in the book. Instead, what we are after here is to eventually return a result given it contains certain expected data. Main use case as of today is calling an http resource which should eventually contain the expected data. We can specify the success criterion in a Probe but we also want to return the resulting document once the criterion is met.
