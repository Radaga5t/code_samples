# frozen_string_literal: true

module Barion
  # Communication with API gateway
  module Communication
    def self.post(url, body)
      Faraday.post(url) do |req|
        req.headers['Content-type'] = 'application/json'
        req.headers['Accept-language'] = 'en'
        req.body = body.to_json
      end
    end

    def self.get(url, body)
      Faraday.get(url) do |req|
        req.headers['Content-type'] = 'application/json'
        req.headers['Accept-language'] = 'en'
        body.map { |key, val| req.params[key] = val }
      end
    end
  end
end
