# frozen_string_literal: true

require "json"
require "net/http"

require_relative "client_config"
require_relative "device"

module Ambient
  class ClientError < StandardError; end

  class Client
    ##
    # Creates a new Ambient Client
    #
    # @param client_config [Ambient.ClientConfiguration] the configuration for the Ambient client.
    def initialize(client_config)
      @config = client_config
    end

    def devices
      path = "devices"
      
      begin
        response = _get(path, @config)
      rescue StandardError => se
        raise Ambient::ClientError, "Error while getting the list of devices from the Ambient API (#{se.class.name}): #{se.message}"
      end

      unless response.is_a? Net::HTTPOK
        raise Ambient::ClientError, "The response from the Ambient API was not what was expected, got #{response.class.name} instead of Net::HTTPOK"
      end

      response_data = JSON.parse(response.body)
      array_of_devices = []
      response_data.each do |device_data|
        array_of_devices << Ambient::Device.from_hash(device_data)
      end

      array_of_devices
    end

    def device_data(device_mac_address, end_date: nil, limit: 288)
      path = "devices/#{device_mac_address}"
      params = {endDate: end_date, limit: }

      begin
        response = _get(path, @config, params: )
      rescue StandardError => se
        raise Ambient::ClientError, "Error while getting device data from the Ambient API #{se.class.name}: #{se.message}"
      end

      unless response.is_a? Net::HTTPOK
        raise Ambient::ClientError, "The response from the Ambient API was not what was expected, got #{response.class.name} instead of Net::HTTPOK"
      end

      JSON.parse(response.body)
    end

    private

    # :nocov:
    def _get(path, config, params: {})
      uri = URI("#{@config.api_url}/#{path}")
      all_params = params.merge({applicationKey: @config.app_key, apiKey: @config.api_key})
      uri.query = URI.encode_www_form(all_params)
      headers = {Accept: "application/json"}

      Net::HTTP.get_response(uri, headers)
    end
    # :nocov:
  end
end
