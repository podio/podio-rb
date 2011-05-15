Podio
=====

This is the official Ruby client for accessing the Podio API. Besides handling setup and authentication it also provides idiomatic Ruby methods for accessing most of the APIs operations. This client library is designed to be minimal and easily integrable into your projects.


Install
-------

Podio is packaged as a gem:

    $ gem install podio


Configuration
-------------

The main way of using the Podio library is via a singleton client, which you set up like this:

    Podio.setup(:api_key => 'YOUR_API_KEY', :api_secret => 'YOUR_API_SECRET')

This initializes a `Podio::Client` object and assigns it to a thread-local, which is used by all methods in this library.


Authentication
--------------

After the configuration you need to authenticate against the API. The client supports two ways of authentication:

### Web Server Flow

The default OAuth flow to be used when you authenticate Podio users from your web application. See the `sinatra.rb` in the examples folder.

    # Redirect the user to the authorize url
    Podio.client.authorize_url(:redirect_uri => redirect_uri)

    # In the callback you get the authorization_code
    # wich you use to get the access token
    Podio.client.authenticate_with_auth_code(params[:code], redirect_uri)

### Username and Password Flow

If you're writing a batch job or are just playing around with the API, this is the easiest to get started. Do not use this for authenticating users other than yourself, the web server flow is meant for that.

    Podio.client.authenticate_with_credentials('USERNAME', 'PASSWORD')


Basic Usage
-----------

After you configured the `Podio.client` singleton you can use all of the wrapper functions to do API requests. The functions are organized into modules corresponding to the official API documentation. The functions follow a common naming pattern that should be familiar to ActiveRecord users. For example:

    # Getting an item
    Podio::Item.find(42)

    # Posting a status message on space with id 23
    Podio::Status.create(23, {:value => 'This is the text of the status message'})

If there is a method missing or you want to do something special, you can use the Faraday connection directly. This allows you to do arbitrary HTTP requests to the Podio API with authentication, JSON parsing and error handling already taken care of. The same examples would look like this:

    # Getting an item
    response = Podio.connection.get('/item/42')
    response.body

    # Posting a status message on space with id 23
    response = Podio.connection.post do |req|
      req.url '/status/space/23/'
      req.body = {:value => 'This is the text of the status message'}
    end
    response.body

All the wrapped methods either return a single Ruby hash, an array of Ruby hashes, or a simple Struct in case of pagination:

    # Find all items in an app (paginated)
    items = Podio::Item.find_all(app_id, :limit => 20)

    # get count of returned items in this call
    items.count

    # get the returned items in an array
    items.all

    # get count of all items in this app
    items.total_count


Error Handling
--------------

All unsuccessful responses returned by the API (everything that has a 4xx or 5xx HTTP status code) will throw an exception. All exceptions inherit from `Podio::PodioError` and have three additional properties which give you more information about the error:

    begin
      Podio::Space.create({:name => 'New Space', :org_id => 42})
    rescue Podio::BadRequestError => exc
      puts exc.response_body      # parsed JSON response from the API
      puts exc.response_status    # status code of the response
      puts exc.url                # uri of the API request

      # you normally want this one, a human readable error description
      puts exc.response_body['error_description']
    end


Full Example
------------

    require 'rubygems'
    require 'podio'

    Podio.setup(:api_key => 'YOUR_API_KEY', :api_secret => 'YOUR_API_SECRET')
    Podio.client.authenticate_with_credentials('YOUR_PODIO_ACCOUNT', 'YOUR_PODIO_PASSWORD')

    # Print a list of organizations I'm a member of
    my_orgs = Podio::Organization.find_all

    my_orgs.each do |org|
      puts org['name']
      puts org['url']
    end

Note on Heroku Usage
---------------------
If you plan on using podio-rb on Heroku please noe that only the 1.9.2 stack has been tested. Specifically, bamboo-mri-1.9.2 is recommended, while 1.8.7 is still stock on Heroku. Refer to their documentation for information on how to migrate your dynos 

Meta
----

* Code: `git clone git://github.com/podio/podio-rb.git`
* Home: <https://github.com/podio/podio-rb>
* Bugs: <https://github.com/podio/podio-rb/issues>

This project uses [Semantic Versioning](http://semver.org/).
