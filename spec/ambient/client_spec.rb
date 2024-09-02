# frozen_string_literal: true

RSpec.describe Ambient::Client do
  it "has a version number" do
    expect(Ambient::VERSION).not_to be nil
  end

  context "#devices" do
    let(:example_response_body) do
      JSON.dump([{
        "macAddress": "00:00:00:00:00:00",
        "info": {
          "name": "My Weather Station",
          "location": "Home"
        },
        "lastData": {
          "dateutc": 1515436500000,
          "date": "2018-01-08T18:35:00.000Z",
          "winddir": 58,
          "windspeedmph": 0.9,
          "windgustmph": 4,
          "maxdailygust": 5,
          "windgustdir": 61,
          "winddir_avg2m": 63,
          "windspdmph_avg2m": 0.9,
          "winddir_avg10m": 58,
          "windspdmph_avg10m": 0.9,
          "tempf": 66.9,
          "humidity": 30,
          "baromrelin": 30.05,
          "baromabsin": 28.71,
          "tempinf": 74.1,
          "humidityin": 30,
          "hourlyrainin": 0,
          "dailyrainin": 0,
          "monthlyrainin": 0,
          "yearlyrainin": 0,
          "feelsLike": 66.9,
          "dewPoint": 34.45380707462477
        }
      }])
    end

    it "raises an Ambient::ClientError when calling the Ambient API raises an exception" do
      config = Ambient::ClientConfiguration.new(
        api_key: "test api key", 
        app_key: "test app key", 
        api_url: "http://localhost.fake"
      )
      client = Ambient::Client.new(config)

      expect { client.devices }.to raise_error(Ambient::ClientError, /Error while getting the list of devices from the Ambient API/)
    end

    it "raises an Ambient::ClientError when the Ambient API responds with anything except an HTTP 200 OK" do
      config = Ambient::ClientConfiguration.new(
        api_key: "test api key", 
        app_key: "test app key", 
        api_url: "http://localhost.fake"
      )
      client = Ambient::Client.new(config)

      expect(client).to receive(:_get).and_return(Net::HTTPNotFound.new(nil, 404, "Test Not Found"))

      expect { client.devices }.to raise_error(Ambient::ClientError, /The response from the Ambient API was not what was expected/)
    end

    it "returns an Array of Ambient::Device" do
      config = Ambient::ClientConfiguration.new(
        api_key: "test api key", 
        app_key: "test app key", 
        api_url: "http://localhost.fake"
      )
      client = Ambient::Client.new(config)
      response = Net::HTTPOK.new("1.0", "200", "OK")
      expect(response).to receive(:body).and_return(example_response_body)
      expect(client).to receive(:_get).and_return(response)

      devices = client.devices

      expect(devices).to be_a(Array)
      expect(devices.count).to eq(1)
      expect(devices.first.info.name).to eq("My Weather Station")
    end
  end

  context "#device_data" do
    let (:example_response_body) do
      JSON.dump([
        {
          "dateutc": 1515436500000,
          "date": "2018-01-08T18:35:00.000Z",
          "winddir": 58,
          "windspeedmph": 0.9,
          "windgustmph": 4,
          "maxdailygust": 5,
          "windgustdir": 61,
          "winddir_avg2m": 63,
          "windspdmph_avg2m": 0.9,
          "winddir_avg10m": 58,
          "windspdmph_avg10m": 0.9,
          "tempf": 66.9,
          "humidity": 30,
          "baromrelin": 30.05,
          "baromabsin": 28.71,
          "tempinf": 74.1,
          "humidityin": 30,
          "hourlyrainin": 0,
          "dailyrainin": 0,
          "monthlyrainin": 0,
          "yearlyrainin": 0,
          "feelsLike": 66.9,
          "dewPoint": 34.45380707462477
        }
      ])
    end

    it "raises an Ambient::ClientError when calling the Ambient API raises an exception" do
      config = Ambient::ClientConfiguration.new(
        api_key: "test api key", 
        app_key: "test app key", 
        api_url: "http://localhost.fake"
      )
      client = Ambient::Client.new(config)

      expect { client.device_data("00:00:00:00:00:00") }.to raise_error(Ambient::ClientError, /Error while getting device data from the Ambient API/)
    end

    it "raises an Ambient::ClientError when the Ambient API responds with anything except an HTTP 200 OK" do
      config = Ambient::ClientConfiguration.new(
        api_key: "test api key", 
        app_key: "test app key", 
        api_url: "http://localhost.fake"
      )
      client = Ambient::Client.new(config)

      expect(client).to receive(:_get).and_return(Net::HTTPNotFound.new(nil, 404, "Test Not Found"))

      expect { client.device_data("00:00:00:00:00:00") }.to raise_error(Ambient::ClientError, /The response from the Ambient API was not what was expected/)
    end

    it "returns an Array of data" do
      config = Ambient::ClientConfiguration.new(
        api_key: "test api key", 
        app_key: "test app key", 
        api_url: "http://localhost.fake"
      )
      client = Ambient::Client.new(config)
      response = Net::HTTPOK.new("1.0", "200", "OK")
      expect(response).to receive(:body).and_return(example_response_body)
      expect(client).to receive(:_get).and_return(response)

      device_data = client.device_data("00:00:00:00:00:00")

      expect(device_data).to be_a(Array)
      expect(device_data.count).to eq(1)
      expect(device_data.first.dig("dateutc")).to eq(1515436500000)
    end
  end
end
