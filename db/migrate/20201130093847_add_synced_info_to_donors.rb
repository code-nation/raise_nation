class AddSyncedInfoToDonors < ActiveRecord::Migration[6.0]
  def change
    add_column :donors, :synced_external_id, :string
    add_column :donors, :synced_data, :jsonb
  end
end
