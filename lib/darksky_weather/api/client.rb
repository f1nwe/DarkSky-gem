require 'httparty'

module DarkskyWeather
  module Api
    class Client
      include HTTParty
      base_uri "https://api.darksky.net/forecast/"

      def get_weather(lat:, lng:, timestamp: nil, **options)
        key         = DarkskyWeather::Api.configuration.api_key

        request_path   = "/#{key}/#{lat},#{lng}"
        request_path << ",#{timestamp}" if timestamp
        request_path << prepare_options(options) if options.any?

        raw_result  = self.class.get(request_path)
        request_uri = raw_result.request.uri.to_s

        return WeatherData.new(timestamp, request_uri, raw_result.parsed_response)
      end

      private

      def prepare_options(hash_options)
        '?' + hash_options.map { |k, v| "#{k}=#{v}" }.join('&')
      end
    end
  end
end
