# frozen_string_literal: true

module Sendpulse
  ACCOUNT_ID = '7226596'

  # Sendpulse api client
  class Client
    include Singleton

    %i[url user_id secret token http_client logger].each do |attr|
      attr_accessor attr
    end

    def initialize
      @refresh_token = 0

      configuration = Rails.application.config_for(:sendpulse)
      self.logger = Logger.new(STDOUT)
      self.url = configuration['url']
      self.user_id = configuration['user_id']
      self.secret = configuration['secret']

      raise 'Empty ID or SECRET' if user_id.to_s.empty? || secret.to_s.empty?
    end

    # phones - Array<numbers>, e.g. [78005553535, 79964562342]
    # message - string
    # Cost per SMS - 2.96 RUB
    def sms_send(phones, message)
      request = {
        sender: 'Qjob',
        phones: phones,
        body: message,
        transliterate: '0'
      }

      send_request('sms/send', 'post', request)
    end

    # recipients - Array<numbers>, e.g. [36705911220, 79964562342]
    # message - string
    # params - hash:
    #   image_url - string
    #   button_text - string (MAX LENGTH = 19 symbols)
    #   button_link - URL string
    # Costs:
    #   plain text (without img and btn) - 0.85 RUB
    #   with img and btn - 1.88 RUB
    def viber_send(phone, **params)
      request = {
        recipients: [phone],
        message: params[:message],
        send_date: 'now',
        sender_id: sender_id,
        message_live_time: 1000
      }

      if params[:button_link]
        request[:message_type] = 2
        request[:additional] = {
          button: {
            text: params[:button_text] || 'Qjob',
            link: params[:button_link] || 'https://qjob.hu'
          }
        }
      else
        request[:message_type] = 3
      end

      send_request('viber', 'post', request)
    end

    def id_sender
      sender_id
    end

    private

    def refresh_token
      @refresh_token += 1

      data = {
        grant_type: 'client_credentials',
        client_id: user_id,
        client_secret: secret
      }

      response = Faraday.post("#{url}/oauth/access_token", data)
      data = Oj.load(response.body, {})

      return false unless !data.nil? && data['access_token']

      self.token = data['access_token']
      @refresh_token = 0
      true
    end

    def sender_id
      response = send_request('viber/senders')

      response[:data].last['id']
    end

    def serialize(data)
      Oj.dump(data, {})
    end

    def unserialize(data)
      Oj.load(data, {})
    end

    def send_request(path, method = 'get', data = {})
      refresh_token if @refresh_token.zero? && token.blank?

      response_data = {}
      response = http_client.public_send(method, path, method == 'get' ? data : Oj.dump(data, {}))

      begin
        if response.status == 401 && @refresh_token.zero?
          refresh_token
          return send_request(path, method, data)
        else
          response_data[:data] = Oj.load(response.body, {})
          response_data[:http_status] = response.status
        end
      rescue StandardError => e
        logger.error "Exception \n  message: #{e.message} \n  backtrace: #{e.backtrace}"
      end

      handle_result(response_data)
    end

    def handle_error(custom_message = nil)
      data = { is_error: true }
      data[:message] = custom_message unless custom_message.nil?
      data
    end

    def handle_result(data)
      data[:is_error] = true unless data[:http_status].to_i == 200
      data
    end

    def http_client
      Faraday.new(url) do |client|
        client.adapter Faraday.default_adapter
        client.headers['Authorization'] = "Bearer #{token}"
        client.headers['Content-Type'] = 'application/json'
      end
    end
  end
end
