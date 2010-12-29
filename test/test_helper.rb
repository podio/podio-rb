require 'test/unit'
require 'yajl'
require 'active_support'

require 'podio'

def podio_test_client
  token = Podio::OAuthToken.new('access_token' => '352e85cd67eff86179194515b91a75404c1169ad083ad435b200af834b9121665b2aaf894f599b7d9b1bee6b7551f3a11e2a02dc43def9a9b549b1f2a4fe9a42', 'refresh_token' => '82e7a11ae187f28a25261599aa6229cd89f8faee48cba18a75d70efae88ba665ced11d43143b7f5bebb31a4103662b851dd2db1879a3947b843259479fccfad3', 'expires_in' => 3600)
  Podio::Client.new(
    :api_url => 'http://127.0.0.1:8080',
    :api_key => 'dev@hoisthq.com',
    :api_secret => 'CmACRWF1WBOTDfOa20A',
    :oauth_token => token)
end

Podio.client = podio_test_client
