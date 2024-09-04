# frozen_string_literal: true

module Ambient
  class DeviceInfo
    attr_reader :name, :coords

    def self.from_hash(data)
      DeviceInfo.new(data.dig("name"), data.dig("coords"))
    end

    def initialize(name, coords)
      @name = name
      @coords = coords
    end
  end

  class Device
    attr_reader :mac_address, :info, :last_data

    def self.from_hash(data)
      Ambient::Device.new(data.dig("macAddress"), Ambient::DeviceInfo.from_hash(data.dig("info")), data.dig("lastData"))
    end

    ###
    # Create a new Device instance
    #
    # @param mac_address [String] the mac address of the device
    # @param info [Ambient::DeviceInfo] information about the device
    # @param last_data [Hash] the latest measurement data from the device
    def initialize(mac_address, info, last_data)
      @mac_address = mac_address
      @info = info
      @last_data = last_data
    end
  end
end
