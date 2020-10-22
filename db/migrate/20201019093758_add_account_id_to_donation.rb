class AddAccountIdToDonation < ActiveRecord::Migration[6.0]
  def change
    add_reference :donations, :account, null: false, foreign_key: true
  end
end
