# frozen_string_literal: true

# Модель чата пользователя
class UserChat < ApplicationRecord
  attr_accessor :interlocutor
  attr_accessor :task_response_id
  attr_accessor :task_response_status
  attr_accessor :chat_as_executor
  attr_accessor :last_message_at
  attr_accessor :unread_count

  # в чате может присутствовать несколько собеседников
  has_and_belongs_to_many :users

  # в чате множество сообщений от собеседников
  has_many :user_chat_messages, dependent: :destroy

  # чат может принадлежать заданию
  belongs_to :task, optional: true, inverse_of: :user_chats

  enum chat_type: {
    chat_between_users: 0,
    chat_with_administration: 1
  }

  default_scope -> { order(created_at: :desc) }

  # Дата последнего сообщения, которое написано пользователем, id которого передается
  def refresh_last_message_at(user_id)
    last = user_chat_messages.order(sent_at: :desc).where(author_id: user_id).select(:id, :sent_at).take(1).first
    self.last_message_at = last.sent_at if last.present?
    last_message_at
  end

  def refresh_unread_count(user_id)
    self.unread_count = user_chat_messages.where(author_id: user_id, read: false).count
    unread_count
  end
end
