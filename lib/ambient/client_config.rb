# frozen_string_literal: true

module Ambient
  class ClientConfiguration
    attr_reader :api_key, :app_key, :api_url

    ##
    # Creates a new Ambient Client
    #
    # @param api_key [String] the configuration for the Ambient client.
    def initialize(api_key:, app_key:, api_url:)
      @api_key = api_key
      @app_key = app_key
      @api_url = api_url
    end
  end
end
  