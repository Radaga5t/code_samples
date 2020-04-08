# frozen_string_literal: true

# SimplePay payment system module
module SimplePay
  # General message format
  # Character encoding: UTF-8
  # API messages method: POST
  # Redirecting method in the browser: GET
  # HMAC HASH signature method: SHA384
  # Data format: JSON
  # Content-type: application/json (in every case)

  # Time values: [string] ISO 8610 (2018-09-15T11:25:37+02:00)
  # Currency: ISO 4217 (HUF, EUR, USD)
  # Countries: ISO 3166-1 alpha-2 (HU, EN, DE etc.)
  # Every request/response includes field "salt" => [32 random characters]
  CURRENCY = 'HUF'
  LANGUAGE = 'HU'

  SANDBOX = ENV['SIMPLE_PAY_SANDBOX_MODE']

  SDK_VERSION = 'SimplePay_PHP_SDK_2.0_180906:b0e9811434b642501c7960078f395924'

  URLS = {
    back: "#{ENV['PROXY_FE'] || ENV['HOST_FE']}/profile/account",
    success: '',
    fail: '',
    cancel: '',
    timeout: ''
  }.freeze

  PAYMENT_METHODS = {
    card: 'CARD'
  }.freeze

  # HUF
  HUF_MERCHANT = ENV['SIMPLE_PAY_HUF_MERCHANT']     # merchant account ID (HUF)
  HUF_SECRET_KEY = ENV['SIMPLE_PAY_HUF_SECRET']     # secret key for account ID (HUF)

  # EUR
  EUR_MERCHANT = 'z'                             # merchant account ID (EUR)
  EUR_SECRET_KEY = 'z'        # secret key for account ID (EUR)

  # USD
  USD_MERCHANT = 'z'                             # merchant account ID (USD)
  USD_SECRET_KEY = 'z'        # secret key for account ID (USD)
end
