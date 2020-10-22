class AddDonationSourceToDonation < ActiveRecord::Migration[6.0]
  def change
    add_column :donations, :donation_source_type, :string
    add_column :donations, :donation_source_id, :bigint
    add_index :donations, [:donation_source_id, :donation_source_type]
  end
end
