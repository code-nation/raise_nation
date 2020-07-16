class AddReceiveNotificationsToAccountUser < ActiveRecord::Migration[6.0]
  def change
    add_column :account_users, :receive_notifications, :boolean, null: false, default: true
  end
end
