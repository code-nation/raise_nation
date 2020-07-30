class AddAccountToNation < ActiveRecord::Migration[6.0]
  def change
    add_reference :nations, :account, null: false, foreign_key: true
  end
end
