# frozen_string_literal: true

module Barion
  module Models
    # Transaction's items model implementation
    # Model structure: https://docs.barion.com/Item
    class Item
      attr_accessor :name, :description, :quantity, :unit,
                    :price, :total

      def initialize(**params)
        self.name = params[:name]
        self.description = params[:description]
        self.quantity = params[:quantity]
        self.unit = params[:unit]
        self.price = params[:price]

        self.total = quantity * price
      end

      def api_json_format
        {
          'Name': name,
          'Description': description,
          'Quantity': quantity,
          'Unit': unit,
          'UnitPrice': price,
          'ItemTotal': total
        }.delete_if { |_, val| val.nil? }
      end

      def valid?
        %i[name description quantity unit price].each do |prop|
          return false if send(prop).nil?
        end

        true
      end
    end
  end
end
