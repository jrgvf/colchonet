class AddConfirmationFieldsToUsers < ActiveRecord::Migration
  change_table :users do |t|
    t.datetime :confirmed_at
    t.string :confirmation_token
  end
end
