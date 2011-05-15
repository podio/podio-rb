#
# Basic OAuth web server flow example
#
# You need the sinatra and podio gems installed
# and provide your API key in the Podio.setup call
#
# Configure your API key on https://podio.com/settings/api
# so that the return URL is 'localhost'
#
# Start with
#   ruby sinatra.rb
#
# And point your browser to http://localhost:4567
#

require 'rubygems'
require 'sinatra'
require 'podio'


# CHANGE this this to make this example work
Podio.setup(
  :api_key    => 'YOUR_API_KEY',
  :api_secret => 'YOUR_API_SECRET'
)

get '/' do
  %(<p>Update the <code>Podio.setup</code> call in the sinatra app and <a href="/auth/podio">try to authorize</a>.</p>)
end

# access this to request a token from Podio
get '/auth/podio' do
  redirect Podio.client.authorize_url(:redirect_uri => redirect_uri)
end

# If the user authorizes it, this request gets your authorization code
# which is used to get an access token and make a successful api call
get '/auth/podio/callback' do
  begin
    # normally you store the token in the session to be able
    # to make API calls with it in subsequent requests
    token = Podio.client.authenticate_with_auth_code(params[:code], redirect_uri)
    user = Podio::UserStatus.current

    "<p><b>Your OAuth access token</b>: #{token.access_token}</p><p><b>Your user status info</b>:\n#{user.inspect}</p>"
  rescue Podio::BadRequestError
    %(<p>Outdated authorization code:</p><p>#{$!}</p><p><a href="/auth/podio">Start over</a></p>)
  end
end

def redirect_uri(path='/auth/podio/callback')
  uri = URI.parse(request.url)
  uri.path  = path
  uri.to_s
end
