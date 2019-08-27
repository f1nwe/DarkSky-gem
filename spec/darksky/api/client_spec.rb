require 'spec_helper'

RSpec.describe Darksky::Api::Client do

  describe "#get_weather" do
    let(:api_key){ "Bogus Key" }

    before(:each) do
      Darksky::Api.configure{|c| c.api_key = api_key }
      @client = Darksky::Api::Client.new
    end

    it "sends a request to the Darksky API" do
      lat, lng, timestamp = [33.6892651, -117.8828102, Date.new(2019, 1, 1).to_time.to_i]

      response_double = instance_double(HTTParty::Response)
      request_double  = instance_double(HTTParty::Request)

      expect(response_double).to receive(:request).and_return(request_double)
      expect(response_double).to receive(:parsed_response).and_return({})
      expect(request_double).to receive(:uri).and_return("https://api.darksky.net/#{api_key}/#{lat},#{lng},#{timestamp}")
      expect(Darksky::Api::Client).to receive(:get).with("/#{api_key}/#{lat},#{lng},#{timestamp}").and_return(response_double)

      @client.get_weather(lat: lat, lng: lng, timestamp: timestamp)
    end

    it "returns a WeatherData object for the specified time and location" do
      lat, lng, timestamp = [33.6892651, -117.8828102, Date.new(2019, 1, 1).to_time.to_i]

      response_double = instance_double(HTTParty::Response)
      request_double  = instance_double(HTTParty::Request)

      expect(response_double).to receive(:request).and_return(request_double)
      expect(response_double).to receive(:parsed_response).and_return({})
      expect(request_double).to receive(:uri).and_return("https://api.darksky.net/#{api_key}/#{lat},#{lng},#{timestamp}")
      expect(Darksky::Api::Client).to receive(:get).with("/#{api_key}/#{lat},#{lng},#{timestamp}").and_return(response_double)

      weather_data = @client.get_weather(lat: lat, lng: lng, timestamp: timestamp)

      expect(weather_data).to be_a(Darksky::Api::WeatherData)
      expect(weather_data.latitude).to eq(lat)
      expect(weather_data.longitude).to eq(lng)
      expect(weather_data.timestamp).to eq(timestamp)
    end

  end

end
