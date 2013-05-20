poller
======


[![Build Status](https://travis-ci.org/mkrogemann/poller.png)](https://travis-ci.org/mkrogemann/poller)
[![Code Climate](https://codeclimate.com/github/mkrogemann/poller.png)](https://codeclimate.com/github/mkrogemann/poller)
[![Coverage Status](https://coveralls.io/repos/mkrogemann/poller/badge.png?branch=master)](https://coveralls.io/r/mkrogemann/poller)
[![Dependency Status](https://gemnasium.com/mkrogemann/poller.png)](https://gemnasium.com/mkrogemann/poller)
[![Gem Version](https://badge.fury.io/rb/poller.png)](http://badge.fury.io/rb/poller)

poller is a Ruby gem that supports integration testing of systems that contain calls to asynchronous components (eg Splunk, Search Servers, ...) by exposing Pollers, Probes and Matchers.

It is in large parts inspired by the work of Steeve Freeman &amp; Nat Pryce and their excellent GOOS book ("Growing Object Oriented Software Guided By Tests").

If you are specifically interested in a poller implementation that can handle JSON, please continue reading and then have a look at [poller-json](https://github.com/mkrogemann/poller-json).

Installation
------------
The gem can be installed in the usual ways. Either let bundler take care of it and add to your Gemfile like this:

    gem 'poller'

Or install it directly on your command line

    gem install poller

Usage
-----
Complementary to this section, there is also a [Wiki](https://github.com/mkrogemann/poller/wiki) page with more [Usage Examples](https://github.com/mkrogemann/poller/wiki/Usage-Examples).

Find below an example usage of HttpPoller and an Http Response Matcher

    require 'poller'

    matcher = Matchers::HTTP::ResponseBodyContains.new(/your regex/)
    #  alternatively pass in a String

    poller = Poller::HTTP::HttpPoller.new("http://your.sut.example.com", matcher, 5.0, 1.0)
    #  timeout 5s, poll every 1s

    poller.check

The above code will either terminate happily and return nil as soon as the expected result is found in the http response body. The matcher passed into the Poller's constructor is used to determine whether the result matches the expectation.

Or, in the unhappy case, the call will eventually run into a Timeout resulting in a RuntimeError being raised with a message similar to this:

    RuntimeError: Timeout period has been exceeded for Poller (http://your.sut.example.com)
    ...

In case you have to use a Proxy to reach the system under test, use this syntax:

    proxy = { :hostname => 'proxy.internal.example.com', :port => 8080, :user => 'user', :password => '_secret' }

    poller = Poller::HTTP::HttpPoller.new("http://your.sut.example.com", matcher, 5.0, 1.0, proxy)

In case you need to authenticate against the resource you are polling add user:password to the URL like so:

    poller = Poller::HTTP::HttpPoller.new("http://user:password@your.sut.example.com", matcher, 5.0, 1.0, proxy)

SSL is supported but certificates will not be verified, so using invalid certificates (which is a common thing to do, right?) will not raise an exception.


Scope &amp; Feature Requests
----------------------------
In its current implementation stage, the gem focuses on systems that are accessible via http calls. Redirects are not followed as it stands today.

Please contact me in case you have ideas/feature requests both in terms of http-based systems and concerning extensions for non http-based systems.

Pull requests and bug reports are welcome!

Design
------
The gem has been developed to run in Ruby 1.9.3 and is being continuously integrated in Ruby 2.0.0, 1.9.3 and 1.8.7.

One design goal has been to work without external dependencies. Therefore, it does not make use of gems such as the fabulous [rest-client](https://github.com/rest-client/rest-client). Proxy support has been built on top of the less comfortable net/http API.

Extensions that require additional gems should be implemented as gems of their own. This way, users don't have to pull in any dependencies they don't really need (e.g. AMQP, JSON, ...).

Proxy configuration is done by passing in the proxy information in an OpenStruct instance or alternatively as a Hash (see [Usage](https://github.com/mkrogemann/poller#usage)). Proxies requiring authentication are supported.
