# frozen_string_literal: true

module Barion
  # Base class for API's requests
  class BaseRequest
    attr_accessor :POS_key

    def initialize; end

    def api_url
      raise 'No API_INTERFACE specified' if self.class::API_INTERFACE.blank?

      BARION_API_URL + 'v' + API_VERSION + API_ENDPOINTS[self.class::API_INTERFACE]
    end

    def run(method = :post)
      case method
      when :post
        Communication.post(api_url, self)
      when :get
        Communication.get(api_url, JSON.parse(to_json))
      end
    end
  end
end
