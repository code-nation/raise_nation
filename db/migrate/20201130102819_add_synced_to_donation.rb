class AddSyncedToDonation < ActiveRecord::Migration[6.0]
  def change
    add_column :donations, :synced_external_id, :string
    add_column :donations, :synced_data, :jsonb
  end
end
