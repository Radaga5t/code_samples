# frozen_string_literal: true

module SimplePay
  # Base class with general payment system functionality
  class Base
    attr_accessor :currency, :language, :transaction_data

    def api_mode
      modes = {
        sandbox: 'https://sandbox.simplepay.hu/payment',
        live: 'https://secure.simplepay.hu/payment'
      }

      SANDBOX == 'true' ? modes[:sandbox] : modes[:live]
    end

    def api_interface
      raise 'API_INTERFACE is not set' unless self.class::API_INTERFACE

      interfaces = {
        start: '/v2/start',
        finish: '/v2/finish',
        refund: '/v2/refund',
        query: '/v2/query'
      }

      interfaces[self.class::API_INTERFACE]
    end

    # Request URL for current interface
    def api_url
      api_mode + api_interface
    end

    def merchant
      currency = CURRENCY if currency.blank?
      eval(currency + '_MERCHANT')
    end

    def merchant_key
      currency = CURRENCY if currency.blank?
      eval(currency + '_SECRET_KEY')
    end

    def salt(length = 32)
      o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      salt = (0...length).map { o[rand(o.length)] }.join

      Digest::MD5.hexdigest(salt)
    end

    def add_data(key, value = '')
      key = 'EMPTY_DATA_KEY' if key.blank?

      transaction_data[key] = value.to_s
    end

    def add_group_data(group, key, value)
      transaction_data[group] = {} unless transaction_data[group]

      transaction_data[group][key] = value
    end

    def add_items(items_data = {})
      item = {
        ref: '',
        title: '',
        description: '',
        amount: 0,
        price: 0,
        tax: 0
      }

      transaction_data[:items] = [] if transaction_data[:items].blank?

      items_data.map { |key, val| item[key] = val }

      transaction_data[:items].push(item)
    end

    def signature
      Signature.generate(merchant_key, transaction_data)
    end

    def exec_api_call
      result = Communication.post(api_url, transaction_data, signature)

      Oj.load(result.body, {})
    end
  end
end
