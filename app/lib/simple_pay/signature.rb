# frozen_string_literal: true

module SimplePay
  # Signature handling
  module Signature
    def self.generate(key, message)
      # Format message["url"] to PHP style with backslashes
      data = message.to_json # .gsub('/', '\/')
      # Get encoded signature hash
      hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA384.new, key.to_s, data)
      # Encode hash to base64
      signature = Base64.encode64(hmac)

      signature.gsub("\n", '')
    end

    def self.check(data, signature_to_check, merchant_key)
      computed_sig = generate(merchant_key, data)

      computed_sig.eql? signature_to_check
    end
  end
end
