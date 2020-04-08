# frozen_string_literal: true

# Модуль для работы с уведомлениями
#
# == Локализация и i18n
# Поиск локализаций осуществляется автоматически в:
#     notifications.ID.TYPE
#
# === для уведомлений с типом +site+ доступны следующие поля:
# [title]
#   заголовок уведомления
# [message]
#   текст уведомления
#
# === для уведомлений с типом +email+ доступны следующие поля:
# [title]
#   заголовок уведомления
# [message]
#   текст уведомления
# [subject]
#   тема письма с уведомлением
# [-]
#   любые поля, которые потребуются для шаблонов писем
#
# === для уведомлений с типом +viber+ доступны следующие поля:
# [title]
#   заголовок уведомления (не используется в самом сообщении)
# [message]
#   текст уведомления
#
# ---
module Notifications
  # Перечисление типов уведомлений:
  # - +site+ - уведомления на сайте
  # - +email+ - уведомления, которые будут отправлены по электронной почте
  # - +site+ - уведомления, которые будут отправлены через Viber
  NOTIFICATION_TYPES = %i[site email viber].freeze

  # Перечисление событий уведомлений в формате +ID:subject.event+, где:
  # - +ID+ - уникальный идентификатор уведомления
  # - +subject+ - сущность, о которой сообщается в уведомлении
  # - +event+ - описание события
  EVENT_TYPES = %i[
    T1:task.published
    T2:task.new_response
    T3:task.contractor_want_to_close
    T4:task.customer_want_to_close
    T5:task.new_customer_review
    T6:task.new_contractor_review
    T7:task.new_task_in_category
    T8:task.first_response
    T9:task.contractor_selected
    T10:task.other_contractor_selected
    T11:task.new_task_offer
    U1:user.id_confirmed
    U3:user.email_confirmed
    U4:user.become_executor
    U5:user.work_rules
    A1:user_account.success_refill
    A2:user_account.refill_bill
    S1:subsciption.activated
    S2:subsciption.deactivated
  ].freeze

  # Перечисление соответствий событий и типов уведомлений в формате
  # +ID:type1,type2...+, без пробелов, где
  # - +ID+ - уникальный идентификатор уведомления, соответствующий одному из
  #   перечисления +KINDS+
  # - +typeN+ - тип уведомления (способ доставки), из перечисления +TYPES+
  EVENT_NOTIFICATIONS = %i[
    T1:email
    T2:site,email,viber
    T3:site,email
    T4:site,email
    T5:site,email
    T6:site,email
    T7:email
    T8:email
    T9:site,email,viber
    T10:site,email
    U1:site,email
    U2:email
    U3:email
    U4:email
    U5:email
    A1:site,email,viber
    A2:email
    S1:site,email
    S2:site,email
    T11:site,email,viber
  ].freeze
end
