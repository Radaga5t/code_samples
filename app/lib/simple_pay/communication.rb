# frozen_string_literal: true

module SimplePay
  # Communications with SimplePay API
  module Communication
    def self.post(url, body, signature)
      Faraday.post(url) do |req|
        req.headers['Content-type'] = 'application/json'
        req.headers['Accept-language'] = 'en'
        req.headers['Signature'] = signature
        req.body = body.to_json
      end
    end

    def self.get(url, body, signature)
      Faraday.get(url) do |req|
        req.headers['Content-type'] = 'application/json'
        req.headers['Accept-language'] = 'en'
        req.headers['Signature'] = signature
        req.body = body.to_json
      end
    end
  end
end
