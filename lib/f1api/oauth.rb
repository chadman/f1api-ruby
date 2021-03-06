module FellowshipOneAPI # :nodoc:
  # Wrapper around the OAuth v1.0 specification using the +oauth+ gem.
  #
  # The Fellowship One API has two methods of authentication:
  # [OAuthAuthentication]       This is the default method if no method is declared.  This method allows Fellowship Tech to handle
  #                             the authentication and we redirect back to your app.
  # [CredentialsAuthentication]  The methods lets the consumer submit credentials and verify authentication.
  module OAuth
    # The OAuth consumer key.
    # This will get set automatically from the YAML config file if not set explictly
    attr_accessor :oauth_consumer_key
    alias :consumer_key :oauth_consumer_key
    alias :consumer_key= :oauth_consumer_key=

    # The OAuth consumer secret.
    # This will get set automatically from the YAML config file if not set explictly
    attr_accessor :oauth_consumer_secret
    alias :consumer_secret :oauth_consumer_secret
    alias :consumer_secret= :oauth_consumer_secret=

    # The OAuth access token object where all requests are made off of
    attr_accessor :oauth_access_token
    alias :access_token :oauth_access_token

    # The OAuth consumer object
    attr_reader :oauth_consumer
    alias :consumer :oauth_consumer

    # The URI for the resource of the authenticated user
    attr_reader :authenticated_user_uri

    # Creates the OAuth consumer object
    def load_consumer_config(type = :portal, site_url = nil)
      case type
      when :portal
        authorize_path = FellowshipOneAPI::Configuration.portal_authorize_path
      when :weblink
        authorize_path = FellowshipOneAPI::Configuration.weblink_authorize_path
      end

      @oauth_consumer_key ||= FellowshipOneAPI::Configuration.consumer_key
      @oauth_consumer_secret ||= FellowshipOneAPI::Configuration.consumer_secret

      url = site_url.nil? ? FellowshipOneAPI::Configuration.site_url : site_url
      @oauth_consumer = ::OAuth::Consumer.new(@oauth_consumer_key,
                        @oauth_consumer_secret,
                        {:site => url,
                         :request_token_path => FellowshipOneAPI::Configuration.request_token_path,
                         :access_token_path => FellowshipOneAPI::Configuration.access_token_path,
                         :authorize_path => authorize_path })
    end
  end
end
