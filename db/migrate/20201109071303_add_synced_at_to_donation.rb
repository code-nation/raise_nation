class AddSyncedAtToDonation < ActiveRecord::Migration[6.0]
  def change
    add_column :donations, :synced_at, :datetime
  end
end
