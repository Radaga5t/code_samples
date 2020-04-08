# frozen_string_literal: true

module Barion
  module Requests
    # Sending money between wallets
    # API request structure: https://docs.barion.com/Transfer-Send-v1
    class Send
      attr_accessor :user_name, :password, :currency, :amount, :recipient

      def initialize(**params)
        %i[user_name password currency amount recipient].each do |param|
          raise "Required param: #{param} is not passed!" unless params[param]
        end
        self.user_name = params[:user_name]
        self.password = params[:password]
        self.amount = params[:amount]
        self.currency = params[:currency]
        self.recipient = params[:recipient]
      end

      def api_url
        BARION_API_URL + 'v1' + API_ENDPOINTS[:send]
      end

      def run
        Barion::Communication.post(api_url, to_json)
      end
      
      def to_json
        {
          'UserName': user_name,
          'Password': password,
          'Currency': currency,
          'Amount': amount,
          'Recipient': recipient,
        }.to_json
      end
    end
  end
end
