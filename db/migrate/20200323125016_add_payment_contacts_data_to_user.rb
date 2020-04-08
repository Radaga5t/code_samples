class AddPaymentContactsDataToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :payment_city, default: nil
      t.string :payment_street, default: nil
      t.string :payment_postal_code, default: nil
      t.string :payment_house_number, default: nil
    end
  end
end
