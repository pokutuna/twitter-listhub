require 'oauth'
require 'rubytter'

module Model
  class Twitter

    CONSUMER_KEY, CONSUMER_SECRET = open(File.dirname(__FILE__) + '/.token').read.split("\n")

    def self.consumer
      @consumer ||= OAuth::Consumer.new(
        CONSUMER_KEY,
        CONSUMER_SECRET,
        :site => 'http://api.twitter.com'
        )
    end

    def self.request_token(request_token, request_token_secret)
      request_token = OAuth::RequestToken.new(self.consumer, request_token, request_token_secret)
    end

    def self.get_request_token
      self.consumer.get_request_token(:oauth_callback => 'http://localhost:9393/auth/access_token')
    end

    def self.get_instance(access_token)
      rubytter = OAuthRubytter.new(access_token)
      return rubytter
    end
  end
end
