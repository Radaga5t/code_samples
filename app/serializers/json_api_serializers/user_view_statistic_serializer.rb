# frozen_string_literal: true

module JsonApiSerializers
  # сериалайзер для баланса пользователя
  class UserViewStatisticSerializer
    include FastJsonapi::ObjectSerializer

    set_key_transform :camel_lower

    attributes :user_view_count,
               :user_task_created,
               :user_task_executed
  end
end
