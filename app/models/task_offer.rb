# frozen_string_literal: true

# Предложение пользователю выполнить задание
class TaskOffer < ApplicationRecord
  belongs_to :user
  belongs_to :task

  Notifications::Extensions::ForTaskOffer.instance.connect(self).listen
end
