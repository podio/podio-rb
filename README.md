Podio
=====

Ruby wrapper for the Podio API.

Install
-------

Podio is packaged as a gem:

    $ gem install podio


Example
-------

    require 'rubygems'
    require 'podio'

    Podio.configure do |config|
      config.api_key = 'YOUR_API_KEY'
      config.api_secret = 'YOUR_API_SECRET'
      config.debug = false
    end

    podio = Podio::Client.new
    podio.get_access_token('YOUR_PODIO_ACCOUNT', 'YOUR_PODIO_PASSWORD')

    # simple GET request
    my_orgs = podio.connection.get('/org/').body

    my_orgs.each do |org|
      puts org.name
      puts org.url
    end


Meta
----

* Code: `git clone git://github.com/podio/podio-rb.git`
* Home: <https://github.com/podio/podio-rb>
* Bugs: <https://github.com/podio/podio-rb/issues>

This project uses [Semantic Versioning](http://semver.org/).
