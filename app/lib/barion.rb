# frozen_string_literal: true

# Barion payment system integration module
module Barion
  QJOB_BARION_ACCOUNT = ENV['BARION_ACCOUNT']
  POS_KEY = ENV['BARION_POS_KEY']
  PUBLIC_KEY = ENV['BARION_PUBLIC_KEY']

  BARION_API_URL = "https://api.#{'test.' if ENV['BARION_API_MODE'] == 'sandbox'}barion.com/"
  API_VERSION = '2'

  API_ENDPOINTS = {
    start: '/Payment/Start',
    payment_state: '/Payment/GetPaymentState',
    qr_code: '/QR/Generate',
    refund: '/Payment/Refund',
    finish_reservation: '/Payment/FinishReservation',
    capture: '/Payment/Capture',
    cancel_authorization: '/Payment/CancelAuthorization',
    send: '/Transfer/Send'
  }.freeze

  PAYMENT_TYPES = {
    immediate: 'Immediate',
    reservation: 'Reservation',
    delayed: 'DelayedCapture'
  }.freeze

  CURRENCY = {
    usd: 'USD', # U.S. Dollar
    eur: 'EUR', # Euro
    huf: 'HUF', # Hungarian forint
    czk: 'CZK'  # Czech crown
  }.freeze

  LOCALES = {
    cs: 'cs-CZ', # Czech
    de: 'de-DE', # German
    en: 'en-US', # English
    es: 'es-ES', # Spanish
    fr: 'fr-FR', # French
    hu: 'hu-HU', # Hungarian
    sk: 'sk-SK', # Slovak
    sl: 'sl-SI', # Slovenian
    el: 'el-GR'  # Greek
  }.freeze

  CALLBACK_URL = "#{ENV['PROXY_BE'] || ENV['HOST_BE']}/payments/barion"
  REDIRECT_URL = "#{ENV['PROXY_FE'] || ENV['HOST_FE']}/profile/account"

  COMMISSION = 0.1
end
