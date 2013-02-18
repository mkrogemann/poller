poller
======

[![Build Status](https://travis-ci.org/mkrogemann/poller.png)](https://travis-ci.org/mkrogemann/poller)
[![Code Climate](https://codeclimate.com/github/mkrogemann/poller.png)](https://codeclimate.com/github/mkrogemann/poller)
[![Dependency Status](https://gemnasium.com/mkrogemann/poller.png)](https://gemnasium.com/mkrogemann/poller)

poller is a Ruby gem that supports testing asynchronous calls to systems under test by exposing Poller implementations.

It is in large parts inspired by the work of Steeve Freeman &amp; Nat Pryce and their excellent GOOS book ("Growing Object Oriented Software Guided By Tests").

Installation
------------
The gem can be installed in the usual ways. Either let bundler take care of it and add to your Gemfile like this:

    gem 'poller'

Or install it directly on your command line

    gem install poller

Usage
-----
TBD

Scope &amp; Feature Requests
----------------------------
In its current implementation stage, the gem focuses on systems that are accessible via http calls.

Please contact me in case you have ideas/feature requests both in terms of http-based systems and extensions for non http-based systems.

Pull requests and bug reports are welcome!

Design
------
The gem has been developed to run in Ruby 1.9.3 but will also run in Ruby 1.8.7.

One design goal has been to work without external dependencies. Therefore it does not use such beautiful gems like the fabulous 'rest-client'. Proxy support has been built on top of the less comfortable net/http API.

There is currently no support for authenticated http proxies but building this into the codebase is easy. Please let me know if this is a requirement (see above).


